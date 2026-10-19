#!/usr/bin/env python3
"""loop_index.py: index the installed Apple Loops by tempo, key, beats, genre and instrument.

Usage:  python3 -I loop_index.py [--out ~/Library/Caches/video-master/loop-index.tsv] [--bpm 90] [--tol 0.6]

Reads each .caf under /Library/Audio/Apple Loops directly (no afinfo, so ~3,000 loops index in seconds):
  - tempo = beat count x 60 / (valid frames / sample rate), from the 'pakt' and 'desc' chunks
  - key, key type, beat count, genre, category, subcategory and descriptors from the Apple Loops 'uuid' chunk
Writes a TSV (bpm, key, type, beats, genre, category, subcategory, descriptors, path). With --bpm it also prints
loops at that tempo, half it or double it, so a film's grid can be matched without time-stretching.
"""
import os, struct, sys

ROOT = "/Library/Audio/Apple Loops"
FIELDS = ("key signature", "key type", "beat count", "genre", "category", "subcategory", "descriptors")


def read_caf(path):
    b = open(path, "rb").read()
    if b[:4] != b"caff":
        return None
    i, sr, valid, meta = 8, None, None, {}
    while i + 12 <= len(b):
        typ, size = b[i:i + 4], struct.unpack(">q", b[i + 4:i + 12])[0]
        body = b[i + 12:i + 12 + max(size, 0)]
        if typ == b"desc":
            sr = struct.unpack(">d", body[:8])[0]
        elif typ == b"pakt":
            _, valid, prime, rem = struct.unpack(">qqii", body[:24])
        elif typ == b"uuid":
            s = [x.decode("utf-8", "ignore") for x in body[16:].split(b"\x00")]
            for k in FIELDS:
                if k in s and s.index(k) + 1 < len(s):
                    meta[k] = s[s.index(k) + 1]
        elif typ == b"data" and size < 0:
            break
        if size < 0:
            break
        i += 12 + size
    if not (sr and valid and meta.get("beat count", "").isdigit()):
        return None
    meta["bpm"] = int(meta["beat count"]) * 60 * sr / valid
    return meta


def main():
    args = sys.argv[1:]
    out = os.path.expanduser(args[args.index("--out") + 1] if "--out" in args else "~/Library/Caches/video-master/loop-index.tsv")
    want = float(args[args.index("--bpm") + 1]) if "--bpm" in args else None
    tol = float(args[args.index("--tol") + 1]) if "--tol" in args else 0.6
    rows = []
    for d, _, files in os.walk(ROOT):
        for f in files:
            if f.endswith(".caf"):
                p = os.path.join(d, f)
                try:
                    m = read_caf(p)
                except Exception:
                    m = None
                if m:
                    rows.append(m | {"path": p})
    rows.sort(key=lambda r: (r["bpm"], r["path"]))
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w") as fh:
        fh.write("bpm\tkey\ttype\tbeats\tgenre\tcategory\tsubcategory\tdescriptors\tpath\n")
        for r in rows:
            fh.write("%.2f\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (r["bpm"], r.get("key signature", ""), r.get("key type", ""), r["beat count"],
                     r.get("genre", ""), r.get("category", ""), r.get("subcategory", ""), r.get("descriptors", ""), r["path"]))
    print("indexed %d loops -> %s" % (len(rows), out))
    if want:
        for r in rows:
            for k in (0.5, 1, 2):
                if abs(r["bpm"] - want * k) <= tol * k:
                    print("%6.2f  x%-3s %-3s %-5s %-14s %-12s %-16s %s" % (r["bpm"], k, r.get("key signature", ""), r.get("key type", ""),
                          r.get("genre", "")[:14], r.get("category", "")[:12], r.get("subcategory", "")[:16], os.path.basename(r["path"])))


if __name__ == "__main__":
    main()
