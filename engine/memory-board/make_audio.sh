#!/bin/zsh
# forgetting on purpose: the score. Decodes GarageBand's "Regrets" kit into ~/Library/Caches (never a repo), arranges it on
# the picture's beat grid with the sound effects (score_forget.swift), then two-pass loudnorm to -14 LUFS / -1 dBTP.
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
LOOPDIR=${LOOPDIR:-$HOME/Library/Caches/video-master/loops}   # decoded loops live here, never in a repo
mkdir -p "$LOOPDIR" audio
for f in "/Library/Audio/Apple Loops/Apple/01 Hip Hop/Regrets"*.caf; do o="$LOOPDIR/$(basename "${f%.caf}" | tr ' ' '_').f32"; [ -f "$o" ] || $FF -v error -y -i "$f" -ar 48000 -ac 2 -f f32le "$o"; done
cat timeline.swift dsp.swift trap.swift score_forget.swift > snd.swift
swiftc -O snd.swift -o snd 2>&1 | grep -E "error" || true
BPM=${BPM:-160} LOOPDIR=$LOOPDIR ./snd
J=$($FF -hide_banner -i audio/mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
MI=$(echo "$J" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"], d["target_offset"])')
read I TP LRA TH OFF <<< "$MI"
$FF -v error -y -i audio/mix.wav -af "aformat=channel_layouts=stereo,loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=${I}:measured_TP=${TP}:measured_LRA=${LRA}:measured_thresh=${TH}:offset=${OFF}:linear=true,aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_f32le audio/master.wav
$FF -hide_banner -i audio/master.wav -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' '; echo
