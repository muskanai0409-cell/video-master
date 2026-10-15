#!/bin/zsh
# the media reel's score: decode the kit into the cache (never the repo), arrange it (score.swift), then a two-pass
# loudnorm to -14 LUFS / -1 dBTP -> audio/master.wav
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
LOOPDIR=${LOOPDIR:-$HOME/Library/Caches/video-master/loops}
mkdir -p "$LOOPDIR" audio
for n in "Chill Melody Bass 01" "Chill Melody Guitar Chords" "Chill Melody Lead Guitar" "Chill Melody Synth 01" "Chill Melody Synth 02" "Pastel Colors Beat 01" "Pastel Colors Beat 02"; do
	o="$LOOPDIR/$(echo "$n" | tr ' ' '_').f32"
	[ -f "$o" ] || $FF -v error -y -i "/Library/Audio/Apple Loops/Apple/07 Chillwave/$n.caf" -ar 48000 -ac 2 -f f32le "$o"
done
grep -v "^func highpass" dsp.swift > /dev/null
cat timeline_audio.swift dsp.swift hp.swift score.swift > snd.swift
swiftc -O snd.swift -o snd 2>&1 | grep -E "error" || true
LOOPDIR=$LOOPDIR ./snd
J=$($FF -hide_banner -i audio/mix.wav -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
MI=$(echo "$J" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"], d["target_offset"])')
read I TP LRA TH OFF <<< "$MI"
$FF -v error -y -i audio/mix.wav -af "aformat=channel_layouts=stereo,loudnorm=I=-14:TP=-1:LRA=11:measured_I=${I}:measured_TP=${TP}:measured_LRA=${LRA}:measured_thresh=${TH}:offset=${OFF}:linear=true,aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_f32le audio/master.wav
$FF -hide_banner -i audio/master.wav -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' '; echo
