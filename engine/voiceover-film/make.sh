#!/bin/zsh
# console series part 1 · connect: sound, 4K master, 1080p cut, mux, QA.
set -e
cd "$(dirname "$0")"
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
NAME=${NAME:-console-part1-connect-v1}
OUT=../$NAME
audio/make_audio.sh                     # VO build, events from the picture, mix, loudnorm (also rebuilds ./render)
FS=$(./render times | awk '$1=="T_STILL"{printf "%d", $2*60+0.999}')
FE=$(./render times | awk '$1=="T_END"{printf "%d", $2*60+0.5}')
echo "frames $FE, still from $FS"
X264="colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0:zones=$FS,$((FE-1)),q=1"
SCALE=2 SUB=6 ./render raw 2>/dev/null | $FF -v error -y -f rawvideo -pix_fmt bgra -s 3840x2160 -r 60 -i - \
  -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" -c:v libx264 -preset slow -crf 14 -tune animation \
  -profile:v high -level 5.2 -x264-params "$X264" -force_key_frames "expr:eq(n,$FS)" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart $OUT-4k-silent.mp4
# 1080p: a lanczos cut of the 4K; the still is one frame cloned, so every held frame decodes identically
$FF -v error -y -i $OUT-4k-silent.mp4 \
  -vf "trim=end_frame=$((FS+1)),setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,tpad=stop_mode=clone:stop=$((FE-FS-1))" \
  -c:v libx264 -preset slow -crf 14 -tune animation -profile:v high -x264-params "$X264" -force_key_frames "expr:eq(n,$FS)" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart $OUT-1080p-silent.mp4
DUR=$(python3 -c "print($FE/60)")
for v in 4k 1080p; do
  $FF -v error -y -i $OUT-$v-silent.mp4 -i audio/master.wav -map 0:v -map 1:a -c:v copy -c:a aac -b:a 256k -ar 48000 \
    -t $DUR -movflags +faststart $OUT-$v.mp4
  rm $OUT-$v-silent.mp4
  $FF -hide_banner -i $OUT-$v.mp4 2>&1 | grep -E "Duration|Stream" | sed 's/^ */  /'
done
V=$OUT-1080p.mp4
mkdir -p qa
$FF -v error -i "$V" -vf "fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/motion.txt" -f null -
awk -F= '/YAVG/{n++; v=$2; if(v>=0.15) m++; t=n/30.0; if(v<0.15){ if(run==0) s=t; run++ } else { if(run>=12) printf "still %.2f-%.2f (%.2fs)\n", s, t, run/30.0; run=0 } } END{ printf "moving %.1f%%\n", 100*m/n }' qa/motion.txt
$FF -v error -i "$V" -vf "scale=320:180,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/pop.txt" -f null -
awk -F= '/YAVG/{k++; v[k]=$2+0} END{n=0; for(i=2;i<k;i++){a=v[i-1]; b=v[i+1]; nb=(a>b?a:b); if(v[i]>3*nb && v[i]>1.5){ printf "pop %.3fs %.2f\n", i/60.0, v[i]; n++ } } print n" pop candidates"}' qa/pop.txt
echo "1080p hold:"; $FF -v error -i "$V" -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -$((FE-FS)) | uniq -c | tail -1
echo "4k hold:"; $FF -v error -i "$OUT-4k.mp4" -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -$((FE-FS)) | uniq -c | tail -1
$FF -hide_banner -i "$V" -vn -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:" | tr -s ' ' | tr '\n' ' '; echo
ls -la $OUT-4k.mp4 $OUT-1080p.mp4
