#!/bin/zsh
# Render the media reel. RES=1080: a direct 1080p60 render (review). RES=4k: a 3840x2160 master and a Lanczos 1080 cut.
# The held end: q=1 into the first still frame, q=45 after it, so x264 only skips and the hold is bit-identical
# (keyint longer than the film so no IDR lands inside the hold).
cd "$(dirname "$0")/.."
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
X="colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=1300:bframes=0"
NAME=${NAME:-media-reel-v1}; RES=${RES:-1080}; SPP=${SPP:-2}
read N S <<< "$(./reel info)"
Z="zones=$((S-30)),$S,q=1/$((S+1)),$((N+1)),q=45"
if [ "$RES" = "4k" ]; then
	W=3840 H=2160 SPP=$SPP ./reel raw 0 $(echo "($N+1)/60" | bc -l) 2>parts/log.txt | $FF -v error -y -f rawvideo -pix_fmt bgra -s 3840x2160 -r 60 -i - -vf 'scale=out_color_matrix=bt709:out_range=tv,format=yuv420p' -c:v libx264 -preset slow -crf 14 -tune film -profile:v high -level 5.2 -x264-params "$X:$Z" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv parts/m4k.mp4
	$FF -v error -y -i parts/m4k.mp4 -frames:v $N -c copy -movflags +faststart ../$NAME-4k-silent.mp4
	$FF -v error -y -i ../$NAME-4k-silent.mp4 -vf "trim=end_frame=$((S+1)),setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,tpad=stop_mode=clone:stop=$((N-S))" -c:v libx264 -preset slow -crf 16 -tune film -profile:v high -x264-params "$X:$Z" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv parts/tmp1080.mp4
	$FF -v error -y -i parts/tmp1080.mp4 -frames:v $N -c copy -movflags +faststart ../$NAME-1080-silent.mp4
	for v in 4k 1080; do $FF -v error -y -i ../$NAME-$v-silent.mp4 -i audio/master.wav -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart ../$NAME-$v.mp4; done
else
	W=1920 H=1080 SPP=$SPP ./reel raw 0 $(echo "($N+1)/60" | bc -l) 2>parts/log.txt | $FF -v error -y -f rawvideo -pix_fmt bgra -s 1920x1080 -r 60 -i - -vf 'scale=out_color_matrix=bt709:out_range=tv,format=yuv420p' -c:v libx264 -preset slow -crf 16 -tune film -profile:v high -x264-params "$X:$Z" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv parts/r1080.mp4
	$FF -v error -y -i parts/r1080.mp4 -frames:v $N -c copy -movflags +faststart parts/review-silent.mp4
	$FF -v error -y -i parts/review-silent.mp4 -i audio/master.wav -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart ../$NAME-review-1080.mp4
fi
echo done > parts/status.txt
