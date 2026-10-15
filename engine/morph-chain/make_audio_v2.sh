#!/bin/zsh
# local v0.0.9 score v2: KIT=legend|trap|sympathy (all three when KIT is unset). prep_loops.py stretches the Apple Loops
# to 81 BPM into ~/Library/Caches/video-master (never the repo); score_v2.swift arranges and mixes; two-pass loudnorm to -14 LUFS /
# -1 dBTP -> audio/master_v2_<kit>.wav.
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
LOOPDIR=${LOOPDIR:-$HOME/Library/Caches/video-master/loops-81}
if [ ! -f "$LOOPDIR/Legend_Beat.f32" ]; then
	python3 prep_loops.py "$LOOPDIR" "01 Hip Hop/Legend Beat" "01 Hip Hop/Legend Dark Synth Pad" "01 Hip Hop/Legend FX Synth Pad" \
		"01 Hip Hop/Legend Sub Bass" "01 Hip Hop/Legend Synth Drone" "01 Hip Hop/Legend Synth Lead" "01 Hip Hop/Sophistication Beat" \
		"01 Hip Hop/Sympathy Beat" "01 Hip Hop/Sympathy Bass" "01 Hip Hop/Sympathy Lead" "01 Hip Hop/Sympathy Piano" \
		"01 Hip Hop/Sympathy Synth" "01 Hip Hop/Caution Beat"
fi
cat timeline.swift dsp.swift trap.swift score_v2.swift > sndl2.swift
swiftc -O sndl2.swift -o sndl2 2>&1 | grep -E "error" -A3 || true
for K in ${=KIT:-legend trap sympathy}; do
	BPM=162 KIT=$K LOOPDIR=$LOOPDIR ./sndl2
	J=$($FF -hide_banner -i audio/mix_v2_$K.wav -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
	MI=$(echo "$J" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"], d["target_offset"])')
	read I TP LRA TH OFF <<< "$MI"
	$FF -v error -y -i audio/mix_v2_$K.wav -af "aformat=channel_layouts=stereo,loudnorm=I=-14:TP=-1:LRA=11:measured_I=${I}:measured_TP=${TP}:measured_LRA=${LRA}:measured_thresh=${TH}:offset=${OFF}:linear=true,aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_f32le audio/master_v2_$K.wav
	echo "$K: $($FF -hide_banner -i audio/master_v2_$K.wav -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' ')"
done
