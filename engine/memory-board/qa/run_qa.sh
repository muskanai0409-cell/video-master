#!/bin/zsh
# QA on the delivered files: format and tags, motion (pack metric), pops, the held end card, loudness, decoded field colour.
cd "$(dirname "$0")/../.."
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
V=${NAME:-forgetting-on-purpose-v3}-1080.mp4; V4=${NAME:-forgetting-on-purpose-v3}-4k.mp4
Q=forgetting-v3-src/qa
for f in $V $V4; do echo "== $f"; $FF -hide_banner -i $f 2>&1 | grep -E "Duration|Stream" | sed 's/^ *//'; done
$FF -v error -i $V -map 0:v -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' > $Q/md5.txt
echo "frames: $(wc -l < $Q/md5.txt | tr -d ' ')"
echo "unique md5 in the held end card (want 1): $(tail -${HOLD:-78} $Q/md5.txt | sort -u | wc -l | tr -d ' ')"
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
pops=[(i+1)/30 for i in range(1,n-1) if v[i]>3*max(v[i-1],v[i+1]) and v[i]>1.0]
print('pop candidates (3x both neighbours, > 1.0):', ', '.join('%.2fs'%p for p in pops) or 'none')
PY
$FF -hide_banner -i $V -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:|LRA:"
$FF -v error -sseof -0.3 -i $V -frames:v 1 -vf "crop=1:1:1897:1071,format=rgb24" -f rawvideo - | xxd -p | sed 's/^/decoded field pixel (expect ~0100f5 or a lattice dot): /'
$FF -v error -y -i $V -vf "fps=2,scale=480:270,tile=4x11" -frames:v 1 $Q/contact.png
