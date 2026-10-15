#!/bin/zsh
# QA on the delivered files: format and tags, motion (pack metric), pops, the held end card, loudness, decoded field colour.
cd "$(dirname "$0")/../.."
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
NAME=${NAME:-local-v009}
V=$NAME-1080.mp4; V4=$NAME-4k.mp4
Q=local-v009-src/qa
read W H F N S <<< "$(local-v009-src/render info)"
for f in $V $V4; do echo "== $f"; $FF -hide_banner -i $f 2>&1 | grep -E "Duration|Stream" | sed 's/^ *//'; done
$FF -v error -i $V -map 0:v -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' > $Q/md5.txt
echo "frames: $(wc -l < $Q/md5.txt | tr -d ' ') (want $N)"
echo "unique md5 in the held end card, $((N-S)) frames (want 1): $(tail -$((N-S)) $Q/md5.txt | sort -u | wc -l | tr -d ' ')"
$FF -v error -i $V4 -map 0:v -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -$((N-S)) | sort -u | wc -l | tr -d ' ' | sed 's/^/4k: unique md5 in the hold (want 1): /'
$FF -v error -i $V -vf "fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=$Q/yavg.txt" -f null -
python3 - $Q/yavg.txt <<'PY'
import sys
v=[float(l.split('=')[1]) for l in open(sys.argv[1]) if 'YAVG' in l]
n=len(v); mov=[x>=0.15 for x in v]
print('moving %.1f%% of %d diffs (pack metric, >= 0.15)'%(100*sum(mov)/n,n))
run=0; still=[]
for i,m in enumerate(mov+[True]):
    if not m:
        if run==0: s=i
        run+=1
    else:
        if run/30>=0.4: still.append((run/30,(s+1)/30))
        run=0
print('stills >= 0.4s:', ', '.join('%.2fs at %.2fs'%x for x in still))
PY
$FF -v error -i $V -vf "scale=320:180,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=$Q/yavg60.txt" -f null -
python3 - $Q/yavg60.txt <<'PY'
import sys
v=[float(l.split('=')[1]) for l in open(sys.argv[1]) if 'YAVG' in l]
pops=[(i+1)/60 for i in range(1,len(v)-1) if v[i]>3*max(v[i-1],v[i+1]) and v[i]>1.5]
print('pop candidates at 60fps (3x both neighbours, > 1.5):', ', '.join('%.3fs'%p for p in pops) or 'none')
PY
$FF -hide_banner -i $V -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:|LRA:" | tr -s ' '
$FF -v error -sseof -0.3 -i $V -frames:v 1 -vf "crop=8:8:1890:1060,scale=1:1:flags=area,format=rgb24" -f rawvideo - | xxd -p | sed 's/^/decoded field patch, bottom right (expect near 0100f5 with dither): /'
$FF -v error -y -i $V -vf "fps=2,scale=480:270,tile=4x10" -frames:v 1 $Q/contact.png
