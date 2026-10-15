"""prep_loops.py: GarageBand Apple Loops -> seamless 81 BPM stereo f32 files (the film counts at 162 = 2 x 81).

For each loop: decode to 48 kHz, drop the AAC priming, cut exactly one loop, tile it 3 times, time-stretch with
ffmpeg's atempo (pitch kept), keep the middle copy (so the loop seam has no stretch artefact), trim to the exact
81 BPM length. Drum loops also get their kick and snare onsets measured, in film beats, written next to them as
<name>.hits ("kicks: ..." / "snares: ..."), for the score's sidechain and the picture's lattice pulses.

Usage: python3 prep_loops.py <outdir> "<pack>/<loop name>" ...
The decoded loops stay in ~/Library/Caches/video-master: never in the repo (the GarageBand licence covers soundtracks made with
them, not the loops on their own).
"""
import os, struct, subprocess, sys
import numpy as np

FF = "/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg"
ROOT = "/Library/Audio/Apple Loops/Apple/"
SR, TARGET = 48000, 81.0
FILM_BEAT = 60.0 / (2 * TARGET)


def meta(path):
    d = open(path, "rb").read()
    i, m, sr, frames = 8, {}, None, None
    while i + 12 <= len(d):
        t, n = d[i:i + 4], struct.unpack(">q", d[i + 4:i + 12])[0]
        if n < 0:
            break
        body = d[i + 12:i + 12 + n]
        if t == b"desc":
            sr = struct.unpack(">d", body[:8])[0]
        if t == b"pakt":
            frames = struct.unpack(">q", body[8:16])[0]
        if t == b"uuid" and b"beat count" in body:
            parts = body[20:].split(b"\x00")
            m.update({k.decode(): v.decode() for k, v in zip(parts[0::2], parts[1::2]) if k})
        i += 12 + n
    beats = int(m.get("beat count", 16))
    return beats, beats / (frames / sr) * 60, m


def onsets(x, lo, hi, frac, hop=120, win=1024):
    fr = np.fft.rfftfreq(win, 1 / SR)
    band, hw = (fr > lo) & (fr < hi), np.hanning(win)
    env = np.array([(np.abs(np.fft.rfft(x[i:i + win] * hw))[band] ** 2).sum() for i in range(0, len(x) - win, hop)])
    d = np.maximum(0, np.diff(env))
    thr, pk = d.max() * frac, []
    for i in range(1, len(d) - 1):
        if d[i] > thr and d[i] >= d[i - 1] and d[i] >= d[i + 1] and (not pk or i - pk[-1] > int(0.06 * SR / hop)):
            pk.append(i)
    return [round(((p * hop + win / 2) / SR) / FILM_BEAT * 4) / 4 for p in pk]   # to the nearest 16th of a film beat


def prep(outdir, rel):
    src = ROOT + rel + ".caf"
    beats, bpm, m = meta(src)
    name = os.path.basename(rel).replace(" ", "_")
    raw = subprocess.run([FF, "-v", "error", "-i", src, "-ar", str(SR), "-ac", "2", "-f", "f32le", "-"], capture_output=True, check=True).stdout
    x = np.frombuffer(raw, dtype=np.float32).reshape(-1, 2)
    prime = int(round(2112 / 44100 * SR))
    n_src = int(round(beats * 60 / bpm * SR))
    one = x[prime:prime + n_src]
    if len(one) < n_src:
        one = np.vstack([one, np.zeros((n_src - len(one), 2), np.float32)])
    tiled = np.vstack([one, one, one]).astype(np.float32)
    ratio = TARGET / bpm
    st = subprocess.run([FF, "-v", "error", "-f", "f32le", "-ar", str(SR), "-ac", "2", "-i", "-", "-af", f"atempo={ratio:.6f}",
                         "-f", "f32le", "-"], input=tiled.tobytes(), capture_output=True, check=True).stdout
    y = np.frombuffer(st, dtype=np.float32).reshape(-1, 2)
    n_out = int(round(beats * 60 / TARGET * SR))
    mid = y[n_out:2 * n_out] if abs(ratio - 1) > 1e-6 else one
    if len(mid) < n_out:
        mid = np.vstack([mid, np.zeros((n_out - len(mid), 2), np.float32)])
    mid.astype(np.float32).tofile(os.path.join(outdir, name + ".f32"))
    line = f"{name}: {beats} beats, {bpm:.2f} -> {TARGET} BPM (atempo {ratio:.4f}), key {m.get('key signature', '-')} {m.get('key type', '')}"
    if m.get("category") == "Drums":
        mono = mid.mean(1)
        k, s = onsets(mono, 30, 120, 0.3), onsets(mono, 1500, 5000, 0.35)
        with open(os.path.join(outdir, name + ".hits"), "w") as f:
            f.write("kicks: " + " ".join(f"{v:g}" for v in k) + "\n" + "snares: " + " ".join(f"{v:g}" for v in s) + "\n")
        line += f", {len(k)} kicks, {len(s)} snares"
    print(line)


if __name__ == "__main__":
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for rel in sys.argv[2:]:
        prep(out, rel)
