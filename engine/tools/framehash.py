"""Hash every raw BGRA frame on stdin, one line per frame: `<index> <md5>`.

Determinism check for the Swift renderers (two runs of the same code must match frame for frame):
    ./render raw | python3 framehash.py run1.txt 1920 1080
    ./render raw | python3 framehash.py run2.txt 1920 1080
    diff run1.txt run2.txt | grep -c '^<'      # expect 0
Width and height default to 1920x1080 (use 3840 2160 for a SCALE=2 render).
"""
import sys, hashlib
w = int(sys.argv[2]) if len(sys.argv) > 2 else 1920
h = int(sys.argv[3]) if len(sys.argv) > 3 else 1080
n = w * h * 4
out = open(sys.argv[1], 'w')
i = 0
r = sys.stdin.buffer
while True:
    b = r.read(n)
    if len(b) < n:
        break
    out.write(f"{i} {hashlib.md5(b).hexdigest()}\n")
    i += 1
out.close()
