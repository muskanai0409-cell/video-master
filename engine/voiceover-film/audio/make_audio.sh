#!/bin/zsh
# Part 1 sound: VO build -> events from the picture -> mix -> two-pass loudnorm to -14 LUFS / -1.5 dBTP.
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
PY=../../../../tools/kokoro/venv/bin/python
$PY vo_build.py | tail -2
(cd .. && cat lib.swift console.swift vo_times.swift film.swift > render.swift && swiftc -O render.swift -o render && ./render events > audio/events.json)
$PY mix.py
J=$($FF -hide_banner -i mix.wav -af loudnorm=I=-14:TP=-1.5:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
read I TP LRA TH OFF <<< "$(echo "$J" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"], d["target_offset"])')"
$FF -v error -y -i mix.wav -af "aformat=channel_layouts=stereo,loudnorm=I=-14:TP=-1.5:LRA=11:measured_I=${I}:measured_TP=${TP}:measured_LRA=${LRA}:measured_thresh=${TH}:offset=${OFF}:linear=true,aresample=48000,aformat=channel_layouts=stereo" -c:a pcm_f32le master.wav
$FF -hide_banner -i master.wav -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' '; echo
