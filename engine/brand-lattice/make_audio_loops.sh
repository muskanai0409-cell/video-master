#!/bin/zsh
# v8 score from Apple Loops: KIT=yearning|longing|fullmoon (BPM is the kit's tempo x2). Decodes the kit from
# /Library/Audio/Apple Loops into ~/Library/Caches (never into a repo), arranges it on the picture's beat grid
# (score_loops.swift), then two-pass loudnorm to -14 LUFS / -1 dBTP -> audio/master_<kit>.wav.
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
KIT=${KIT:-yearning}
case $KIT in longing) BPM=164; N="Longing";; fullmoon) BPM=154; N="Full Moon";; *) BPM=140; N="Yearning";; esac
LOOPDIR=${LOOPDIR:-$HOME/Library/Caches/video-master/loops}   # decoded loops live here, never in a repo
mkdir -p "$LOOPDIR" audio
for f in "/Library/Audio/Apple Loops/Apple/01 Hip Hop/$N"*.caf; do
	o="$LOOPDIR/$(basename "${f%.caf}" | tr ' ' '_').f32"
	[ -f "$o" ] && continue
	if [[ "$f" == *"Full Moon Sub Bass"* ]]; then
		# tagged E minor while the rest of the kit is F# minor (GarageBand would transpose it): +2 semitones, re-aligned
		$FF -v error -y -i "$f" -af "asetrate=44100*1.122462,aresample=48000,atempo=0.890899,adelay=24.2:all=1" -ac 2 -f f32le "$o"
	else
		$FF -v error -y -i "$f" -ar 48000 -ac 2 -f f32le "$o"
	fi
done
cat timeline.swift dsp.swift trap.swift score_loops.swift > sndl.swift
swiftc -O sndl.swift -o sndl 2>&1 | grep -E "error" || true
BPM=$BPM KIT=$KIT LOOPDIR=$LOOPDIR ./sndl
J=$($FF -hide_banner -i audio/mix_$KIT.wav -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
MI=$(echo "$J" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"], d["target_offset"])')
read I TP LRA TH OFF <<< "$MI"
$FF -v error -y -i audio/mix_$KIT.wav -af "aformat=channel_layouts=stereo,loudnorm=I=-14:TP=-1:LRA=11:measured_I=${I}:measured_TP=${TP}:measured_LRA=${LRA}:measured_thresh=${TH}:offset=${OFF}:linear=true,aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_f32le audio/master_$KIT.wav
$FF -hide_banner -i audio/master_$KIT.wav -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' '; echo
