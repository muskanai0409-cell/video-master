#!/bin/zsh
# v7 16:9: 4K master (one extra frame, trimmed), the 1080 cut from it, the score muxed. The held end card: q=1 into the
# first still frame, q=45 after it, so x264 only skips and the hold is bit-identical. keyint is longer than the film:
# with keyint=600 an IDR landed on frame 1200, inside the hold, and was coded at q=45 (a visible drop for the last 0.1s).
cd "$(dirname "$0")/.."
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
X="colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=1300:bframes=0"
export BPM=${BPM:-150}
NAME=${NAME:-learner-teaser-v7}; AUDIO=${AUDIO:-audio/master.wav}; SUB=${SUB:-6}
read W H F N S <<< "$(./render info)"
SCALE=2 SUBFRAMES=$SUB ./render raw 0 $((N+1)) 2>parts/log.txt | $FF -v error -y -f rawvideo -pix_fmt bgra -s 3840x2160 -r 60 -i - -vf 'scale=out_color_matrix=bt709:out_range=tv,format=yuv420p' -c:v libx264 -preset slow -crf 14 -tune film -profile:v high -level 5.2 -x264-params "$X:zones=$((S-30)),$S,q=1/$((S+1)),$((N+1)),q=45" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv parts/m4k.mp4
$FF -v error -y -i parts/m4k.mp4 -frames:v $N -c copy -movflags +faststart ../$NAME-4k-silent.mp4
$FF -v error -y -i ../$NAME-4k-silent.mp4 -vf "trim=end_frame=$((S+1)),setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,tpad=stop_mode=clone:stop=$((N-S))" -c:v libx264 -preset slow -crf 16 -tune film -profile:v high -x264-params "$X:zones=$((S-30)),$S,q=1/$((S+1)),$((N+1)),q=45" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv parts/tmp1080.mp4
$FF -v error -y -i parts/tmp1080.mp4 -frames:v $N -c copy -movflags +faststart ../$NAME-1080-silent.mp4
for v in 4k 1080; do $FF -v error -y -i ../$NAME-$v-silent.mp4 -i $AUDIO -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart ../$NAME-$v.mp4; done
echo all > parts/status.txt
