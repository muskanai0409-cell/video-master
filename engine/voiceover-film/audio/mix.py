# Part 1 sound: Bella VO + a GarageBand Apple Loops bed + on-picture clicks, all on the film clock.
#
#   ../../../../tools/kokoro/venv/bin/python mix.py        (after vo_build.py and `../render events > events.json`)
#
# - Music: Chillwave "Harmonic Waves" (E major, 90 BPM) stretched to the film's bar (90.6 BPM) with atempo, so
#   the console opening and "New session" land on downbeats. Decoded loops stay in ~/Library/Caches/video-master, never the repo.
# - Ducking: keyed from the VO with an 80 ms look-ahead, so the bed is already down when the first syllable lands
#   (no late duck), 300 ms hold across the read's own pauses, 450 ms release in the gaps between lines.
# - Effects: Kenney CC0 clicks (../sfx) and one synthesised soft tick, each placed on its exact sample.
# Writes mix.wav (48 kHz stereo float); make_audio.sh loudness-normalises it to master.wav.
import json, os, subprocess, struct, sys
import numpy as np, soundfile as sf

HERE = os.path.dirname(os.path.abspath(__file__))
FF = "/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg"
LOOPS = "/Library/Audio/Apple Loops/Apple/07 Chillwave/"
SCRATCH = os.environ.get("LOOPDIR", os.path.expanduser("~/Library/Caches/video-master/loops"))
SR = 48000
EV = json.load(open(os.path.join(HERE, "events.json")))
G = EV["grid"]
BAR, T0 = G["bar"], G["t0"]
BPM = 60 / (BAR / 4)
N = int(round(EV["t_end"] * SR))

def db(x): return 10 ** (x / 20)
def ts(t): return int(round(t * SR))

# ------------------------------------------------------------------ loops
def meta(path):
    d = open(path, "rb").read()
    i, m, sr, frames = 8, {}, None, None
    while i + 12 <= len(d):
        t, n = d[i:i + 4], struct.unpack(">q", d[i + 4:i + 12])[0]
        if n < 0: break
        body = d[i + 12:i + 12 + n]
        if t == b"desc": sr = struct.unpack(">d", body[:8])[0]
        if t == b"pakt": frames = struct.unpack(">q", body[8:16])[0]
        if t == b"uuid" and b"beat count" in body:
            parts = body[20:].split(b"\x00")
            m.update({k.decode(): v.decode() for k, v in zip(parts[0::2], parts[1::2]) if k})
        i += 12 + n
    beats = int(m.get("beat count", 16))
    return beats, beats / (frames / sr) * 60

def loop(name):
    """One seamless loop at the film's tempo (stretched from the middle of three tiled copies)."""
    os.makedirs(SCRATCH, exist_ok=True)
    out = os.path.join(SCRATCH, f"{name.replace(' ', '_')}@{BPM:.3f}.f32")
    src = LOOPS + name + ".caf"
    beats, bpm = meta(src)
    n_out = int(round(beats * 60 / BPM * SR))
    if not os.path.exists(out):
        raw = subprocess.run([FF, "-v", "error", "-i", src, "-ar", str(SR), "-ac", "2", "-f", "f32le", "-"], capture_output=True, check=True).stdout
        x = np.frombuffer(raw, dtype=np.float32).reshape(-1, 2)
        prime = int(round(2112 / 44100 * SR))
        n_src = int(round(beats * 60 / bpm * SR))
        one = x[prime:prime + n_src]
        if len(one) < n_src: one = np.vstack([one, np.zeros((n_src - len(one), 2), np.float32)])
        tiled = np.vstack([one, one, one]).astype(np.float32)
        st = subprocess.run([FF, "-v", "error", "-f", "f32le", "-ar", str(SR), "-ac", "2", "-i", "-", "-af", f"atempo={BPM / bpm:.6f}",
                             "-f", "f32le", "-"], input=tiled.tobytes(), capture_output=True, check=True).stdout
        y = np.frombuffer(st, dtype=np.float32).reshape(-1, 2)
        mid = y[n_out:2 * n_out]
        if len(mid) < n_out: mid = np.vstack([mid, np.zeros((n_out - len(mid), 2), np.float32)])
        mid.astype(np.float32).tofile(out)
    return np.fromfile(out, dtype=np.float32).reshape(-1, 2)

def tile(lp):
    """The loop laid over the whole film, phase-locked so its first beat falls on the grid's downbeat T0."""
    L = len(lp)
    idx = (np.arange(N) - ts(T0)) % L
    return lp[idx]

def env(points):
    """Gain envelope (linear) from (time, dB) points, smooth between them; -inf as -90."""
    t = np.array([p[0] for p in points]); g = np.array([p[1] for p in points])
    x = np.arange(N) / SR
    y = np.interp(x, t, g)
    return db(y).astype(np.float32)[:, None]

# ------------------------------------------------------------------ arrangement (dB per stem; -90 = off)
OFF = -90
DROP, PULL, LOCK, SESS = G["drop"], G["pull"], G["lock"], G["sessions"]
GAP = DROP - 0.5            # everything but the pad falls away into the pull-out, the thesis lands on the downbeat
END = EV["t_end"]
stems = {
    "Harmonic Waves Synth Pad": [(0, -4), (SESS, -4), (T0, -7), (GAP, -7), (DROP, -2), (LOCK, -2), (END - 0.15, OFF)],
    "Harmonic Waves Guitar":    [(0, OFF), (SESS - 0.2, OFF), (SESS + 0.8, -11), (T0, -9), (GAP - 0.25, -9), (GAP + 0.1, OFF)],
    "Harmonic Waves Bass":      [(0, OFF), (T0 - 0.02, OFF), (T0, -5), (GAP - 0.25, -5), (GAP + 0.08, OFF), (DROP, OFF), (DROP + 0.01, -10), (LOCK, -12), (LOCK + 0.6, OFF)],
    "Continuum Beat 01":        [(0, OFF), (T0 - 0.02, OFF), (T0, -9), (GAP - 0.3, -9), (GAP, OFF)],
    "Harmonic Waves Synth Lead": [(0, OFF), (DROP - 0.01, OFF), (DROP, -10), (LOCK, -9), (END - 0.15, OFF)],
}
music = np.zeros((N, 2), np.float32)
for name, pts in stems.items():
    music += tile(loop(name)) * env(pts)

# ------------------------------------------------------------------ VO
vo, vsr = sf.read(os.path.join(HERE, "vo_bella/vo_track.wav"), dtype="float32")
assert vsr == SR
if vo.ndim > 1: vo = vo.mean(1)
vo = np.concatenate([vo, np.zeros(max(0, N - len(vo)), np.float32)])[:N]

# ------------------------------------------------------------------ ducking keyed from the VO, with look-ahead
hop = int(0.005 * SR)
frames = len(vo) // hop
rms = np.sqrt((vo[:frames * hop].reshape(frames, hop) ** 2).mean(1) + 1e-12)
active = 20 * np.log10(rms) > -44
ahead, hold = int(0.08 / 0.005), int(0.30 / 0.005)
act = np.zeros(frames, bool)
for i in np.nonzero(active)[0]:
    act[max(0, i - ahead):i + hold] = True
DUCK = float(os.environ.get("DUCK", "7"))      # dB the bed drops while she speaks
target = np.where(act, -DUCK, 0.0)
g = np.zeros(frames); cur = 0.0
a_k, r_k = np.exp(-0.005 / 0.05), np.exp(-0.005 / 0.45)
for i in range(frames):
    cur = target[i] + (cur - target[i]) * (a_k if target[i] < cur else r_k)
    g[i] = cur
duck = db(np.interp(np.arange(N), np.arange(frames) * hop + hop / 2, g)).astype(np.float32)[:, None]

# ------------------------------------------------------------------ effects
def sfx(name): return np.fromfile(os.path.join(HERE, "../sfx", name + ".f32"), dtype=np.float32)
def tick():
    n = int(0.16 * SR); t = np.arange(n) / SR
    tone = 0.55 * np.sin(2 * np.pi * 1760 * t) * np.exp(-t / 0.045) + 0.25 * np.sin(2 * np.pi * 2637 * t) * np.exp(-t / 0.03)
    tone[:48] *= np.linspace(0, 1, 48)
    c = sfx("click_005"); tone[:len(c)] += 0.35 * c
    return tone.astype(np.float32)
KIT = {"key": [sfx("click_003"), sfx("click_005")], "key_enter": [sfx("switch12")], "click": [sfx("click_002")],
       "copy": [sfx("switch14")], "tick": [tick()]}
LEVEL = {"key": -17, "key_enter": -11, "click": -12, "copy": -12, "tick": -13}
fx = np.zeros(N, np.float32)
counts = {}
for e in EV["events"]:
    kind = e["kind"]
    if kind not in KIT: continue
    i = counts.get(kind, 0); counts[kind] = i + 1
    s = KIT[kind][i % len(KIT[kind])]
    lvl = LEVEL[kind] + (((i * 7919) % 5) - 2) * 0.6 if kind == "key" else LEVEL[kind]   # keys vary a little, like hands
    p = ts(e["t"])
    m = min(len(s), N - p)
    fx[p:p + m] += s[:m] * db(lvl)

# ------------------------------------------------------------------ levels: bed 12 LU under the voice, 19 LU while she speaks
def lufs(x):
    tmp = os.path.join(SCRATCH, "_m.wav"); sf.write(tmp, x, SR, subtype="FLOAT")
    out = subprocess.run([FF, "-hide_banner", "-i", tmp, "-af", "ebur128", "-f", "null", "-"], capture_output=True, text=True).stderr
    line = [l for l in out.splitlines() if l.strip().startswith("I:")][-1]
    return float(line.split()[1])
vo_i = lufs(vo)
mus_i = lufs(music)
bed = db((vo_i - 12) - mus_i)
mix = np.stack([vo, vo], 1) + music * bed * duck + np.stack([fx, fx], 1)
mix[:int(0.015 * SR)] *= np.linspace(0, 1, int(0.015 * SR), dtype=np.float32)[:, None]   # no click on the first sample
sf.write(os.path.join(HERE, "mix.wav"), mix.astype(np.float32), SR, subtype="FLOAT")
print(f"bpm {BPM:.3f}  vo {vo_i:.1f} LUFS  bed {mus_i:.1f} -> {mus_i + 20 * np.log10(bed):.1f} LUFS (duck {DUCK} dB)  "
      f"effects {sum(counts.values())}  length {N / SR:.2f}s")
