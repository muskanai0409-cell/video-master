#!/bin/bash
# supermemory HyperFrames runner (video-master engine, Oct 21 2026).
# Usage: make.sh <project-dir> <command> [extra args]
#
#   lint | check | snapshot | timeline | info | doctor | catalog | add | keyframes | beats
#                 passed straight to the CLI
#   preview       Studio in the background (prints the URL); stop with: make.sh <dir> stop
#   draft         fast check render, 1080p30, renders/draft.mp4
#   render        1080p60 delivery, renders/<name>-1080p60.mp4
#   master        4K60 delivery master + lanczos 1080p cut tagged bt709 (her product-film rule)
#   blur          1080p at 240fps, then a 4-subframe average down to 60fps (SHUTTER=2 for 180 degrees)
#   probe <file>  ffprobe summary
#   frames <file> <t1> [t2 ...]   PNG stills at those seconds into renders/frames/
#
# It always runs the CLI through the installed Claude Code plugin's pinned launcher, with
# telemetry off, and puts Cardboard's ffmpeg on PATH when no ffmpeg is installed.
set -euo pipefail

HF_ROOT=$(ls -d "$HOME"/.claude/plugins/cache/hyperframes/hyperframes/*/ 2>/dev/null \
  | sed 's#/$##' | awk -F/ '{print $NF" "$0}' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -d' ' -f2)
if [ -z "${HF_ROOT:-}" ]; then
  echo "HyperFrames plugin not found. Install: claude plugin marketplace add heygen-com/hyperframes && claude plugin install hyperframes@hyperframes" >&2
  exit 1
fi
L="$HF_ROOT/skills/hyperframes/scripts/plugin-cli.mjs"

# Opt-outs (research_notes/HyperFrames Oct 2026/01_docs_cli_changelog.md section 2):
# telemetry, global skill installs, the daily npm update ping, silent optional npm installs.
export HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1 HYPERFRAMES_SKIP_SKILLS=1 \
       HYPERFRAMES_NO_UPDATE_CHECK=1 HYPERFRAMES_NO_OPTIONAL_INSTALL=1 NO_COLOR=1
# No Homebrew ffmpeg on this Mac: use Cardboard's build (has libx264, h264_videotoolbox,
# libvpx-vp9 and ProRes). HyperFrames reads the two path variables first.
if ! command -v ffmpeg >/dev/null 2>&1; then
  CB=/Applications/Cardboard.app/Contents/Resources/bin
  export PATH="$CB:$PATH" HYPERFRAMES_FFMPEG_PATH="$CB/ffmpeg" HYPERFRAMES_FFPROBE_PATH="$CB/ffprobe"
fi

# Known open bugs on macOS (research_notes/HyperFrames Oct 2026/03_community_and_limits.md 4a, 4d):
# - #5415: fast drawElement capture silently drops a scene file that starts after 0s once a render
#   passes about 700 frames, and `check` still passes. Default to screenshot capture; FAST=1 opts in.
# - #4435 and a creator report: parallel workers can emit a blank first frame per worker and
#   flicker blurs. Default to one worker; WORKERS=4 opts in (needed for WebGL films over 30s, #5604).
export PRODUCER_EXPERIMENTAL_FAST_CAPTURE=$([ "${FAST:-0}" = 1 ] && echo true || echo false)
W="--workers ${WORKERS:-1}"

dir=${1:?project dir}; cmd=${2:?command}; shift 2
cd "$dir"
name=$(basename "$(pwd)")
mkdir -p renders
hf() { node "$L" "$@"; }

case "$cmd" in
  # Only local, read-or-write-the-project commands. Not wrapped on purpose: usage (reads Claude
  # Code's Keychain token), publish, cloud, lambda, cloudrun, auth, feedback, tts, transcribe,
  # remove-background, skills, upgrade. Run those only after her yes.
  lint|check|timeline|info|doctor|catalog|keyframes|beats|compositions|docs|compare|benchmark)
    hf "$cmd" "$@" ;;
  snapshot)
    # never send frames to Gemini, even if a GEMINI_API_KEY is in the env or a project .env
    hf snapshot --describe false "$@" ;;
  add)
    # registry blocks come from GitHub main, unpinned: commit the added file with the film.
    # (add also copies an include snippet to the clipboard)
    hf add "$@" ;;
  preview) hf preview --background "$@" ;;
  stop)    hf preview --stop ;;
  draft)   hf render $W --quality draft --fps 30 --output renders/draft.mp4 "$@" ;;
  render)  hf render $W --quality delivery --fps 60 --output "renders/$name-1080p60.mp4" "$@" ;;
  master)
    hf render $W --quality delivery --fps 60 --resolution landscape-4k --output "renders/$name-4k60.mp4" "$@"
    ffmpeg -v error -y -i "renders/$name-4k60.mp4" \
      -vf "scale=1920:1080:flags=lanczos,format=yuv420p" \
      -c:v libx264 -preset slow -crf 14 -profile:v high \
      -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
      -c:a copy -movflags +faststart "renders/$name-1080p60.mp4"
    echo "master: renders/$name-4k60.mp4  cut: renders/$name-1080p60.mp4" ;;
  blur)
    sh=${SHUTTER:-4}
    hf render $W --quality delivery --fps 240 --output "renders/$name-240.mp4" "$@"
    w=$(printf '1 %.0s' $(seq 1 "$sh"))
    ffmpeg -v error -y -i "renders/$name-240.mp4" \
      -vf "tmix=frames=$sh:weights='${w% }',select='not(mod(n\,4))',setpts=N/(60*TB),format=yuv420p" \
      -r 60 -c:v libx264 -preset slow -crf 14 \
      -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
      -c:a copy -movflags +faststart "renders/$name-1080p60-blur.mp4"
    echo "blurred: renders/$name-1080p60-blur.mp4" ;;
  probe)
    ffprobe -v error -show_entries \
      format=duration:stream=codec_name,width,height,r_frame_rate,pix_fmt,color_space,color_primaries,color_transfer \
      -of compact "${1:?file}"
    # silent narration can pass `check` (#2775): read the loudness of anything with audio
    if ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$1" | grep -q .; then
      ffmpeg -nostats -hide_banner -i "$1" -af ebur128=peak=true -f null - 2>&1 | grep -E "I:|Peak:" | tail -2
    else echo "no audio stream"; fi ;;
  frames)
    f=${1:?file}; shift; mkdir -p renders/frames
    for t in "$@"; do
      ffmpeg -v error -y -ss "$t" -i "$f" -frames:v 1 "renders/frames/$(basename "$f" .mp4)-t$t.png"
    done
    ls renders/frames ;;
  *) echo "unknown command: $cmd" >&2; exit 2 ;;
esac
