#!/bin/zsh
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
# v6 background plate: the hero film (bg/field.mp4, from supermemory.ai/brand/media) with the site's multiply tint, at 1.1x
[ -f bg/plate_2112x1188.rgb ] || $FF -v error -y -i bg/field.mp4 -vf "scale=w=2112:h=1188:flags=lanczos:in_color_matrix=bt709:in_range=tv:out_range=pc,format=rgb24,colorchannelmixer=rr=0.392:gg=0.618:bb=0.961" -f rawvideo bg/plate_2112x1188.rgb
V4=../one-command-v6-4k-silent.mp4; V=../one-command-v6-1080p-silent.mp4
SCALE=2 ./render raw 2>/dev/null | $FF -v error -y -f rawvideo -pix_fmt bgra -s 3840x2160 -r 60 -i - -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" -c:v libx264 -preset slow -crf 14 -tune animation -profile:v high -level 5.2 -x264-params "colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0:zones=921,1079,q=1" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart $V4
$FF -v error -y -i $V4 -vf "trim=end_frame=991,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,tpad=stop_mode=clone:stop=95" -c:v libx264 -preset slow -crf 14 -tune animation -profile:v high -x264-params "colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0:zones=921,1085,q=1" -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv qa/tmp1080.mp4
$FF -v error -y -i qa/tmp1080.mp4 -c copy -frames:v 1080 -movflags +faststart $V && rm qa/tmp1080.mp4
$FF -hide_banner -i $V4 2>&1 | grep -E "Duration|Stream"
$FF -hide_banner -i $V 2>&1 | grep -E "Duration|Stream"
$FF -v error -i "$V" -vf "fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/motion.txt" -f null -
awk -F= '/YAVG/{n++; v=$2; if(v>=0.15) m++; t=n/30.0; if(v<0.15){ if(run==0) s=t; run++ } else { if(run>=12) printf "still %.2f-%.2f (%.2fs)\n", s, t, run/30.0; run=0 } } END{ printf "moving %.1f%%\n", 100*m/n }' qa/motion.txt
$FF -v error -i "$V" -vf "scale=320:180,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/pop.txt" -f null -
awk -F= '/YAVG/{k++; v[k]=$2+0} END{n=0; for(i=2;i<k;i++){a=v[i-1]; b=v[i+1]; nb=(a>b?a:b); if(v[i]>3*nb && v[i]>1.5){ printf "pop %.3fs %.2f\n", i/60.0, v[i]; n++ } } print n" pop candidates"}' qa/pop.txt
echo "1080p hold:"; $FF -v error -i "$V" -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -95 | uniq -c | tail -1
echo "4k hold:"; $FF -v error -i "$V4" -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -95 | uniq -c | tail -1
$FF -v error -y -ss 4.6 -i $V -frames:v 1 qa/check_4.6.png
ls -la $V4 $V
# mux the score (timeline unchanged since v3, so audio/master.wav stays in sync)
for v in 4k 1080p; do $FF -v error -y -i ../one-command-v6-$v-silent.mp4 -i audio/master.wav -map 0:v -map 1:a -c:v copy -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart ../one-command-v6-$v.mp4; done
for v in 4k 1080p; do $FF -hide_banner -i ../one-command-v6-$v.mp4 2>&1 | grep -E "Duration|Stream"; done
$FF -hide_banner -i ../one-command-v6-1080p.mp4 -vn -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:"
