# Part 1 voiceover: Kokoro af_bella lines -> one timed VO track + the word clock the picture is keyed to.
#
#   ../../../../tools/kokoro/venv/bin/python vo_build.py
#
# 1. gen      each line through tools/kokoro/tts_timed.py (exact per-phoneme timings; audio identical to the take
#             she approved, checked sample for sample on 2026-10-14)
# 2. words    phoneme timings -> words; every pause measured as the quiet run around its punctuation mark
# 3. conform  each pause set to its target length, spliced only inside silence the model left (never into sound)
# 4. place    lines on the film clock with set gaps; each line's first sound lands on a frame boundary
# 5. polish   one ffmpeg pass over the whole track (48 kHz, high-pass, presence, de-ess, gentle compression)
# 6. export   vo_times.swift (word onsets on the film clock), vo_times.json, captions + SRT
#
# Targets and gaps live in TIMING below; the research behind them is in ../README.md ("Voice timing").
import json, os, re, subprocess, sys
import numpy as np, soundfile as sf

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.dirname(HERE)
KOKORO = os.path.abspath(os.path.join(SRC, "../../../tools/kokoro"))
PY = os.path.join(KOKORO, "venv/bin/python")
FF = "/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg"
OUT = os.path.join(HERE, "vo_bella")
SR, SR_OUT, FPS = 24000, 48000, 60

# ------------------------------------------------------------------ the read (generation text: phonetic spellings)
LINES = [
    ("One command, and your agent starts remembering you.", 1.0),
    ("Without it, every session starts from zero. You're telling it you use P N P M. Again.", 1.0),
    ("Okay so, open agents and M C P. Start with the plugin, it loads your memory every session.", 1.02),
    ("One command covers Claude Code, Cursor, Codex and Open Code. Browser sign-in, no key to copy, and there's your agent.", 1.03),
    ("Other M C P clients can use this U R L, and there's a C L I too.", 1.02),
    ("Giving your own app memory? Paste the setup prompt from overview into your agent. It asks before changing code.", 1.03),
    ("This part needs a key. Pick its access, copy it, it only shows once.", 1.02),
    ("Your first call lands in requests, with its status and how long it took.", 1.02),
    ("New session, it already knows you use P N P M.", 1.0),
    ("Next, giving it more to remember.", 1.0),
]
# On-screen words (captions, SRT), chunked one caption line at a time. Lowercase except tool brand names.
CAPTIONS = [
    ["one command,", "and your agent starts remembering you."],
    ["without it, every session starts from zero.", "you're telling it you use pnpm.", "again."],
    ["ok so, open agents and mcp.", "start with the plugin,", "it loads your memory every session."],
    ["one command covers", "Claude Code, Cursor, Codex and OpenCode.", "browser sign-in, no key to copy,", "and there's your agent."],
    ["other mcp clients can use this url,", "and there's a cli too."],
    ["giving your own app memory?", "paste the setup prompt from overview", "into your agent.", "it asks before changing code."],
    ["this part needs a key.", "pick its access, copy it,", "it only shows once."],
    ["your first call lands in requests,", "with its status and how long it took."],
    ["new session, it already knows you use pnpm."],
    ["next, giving it more to remember."],
]
BURN = [True] * 8 + [False, False]      # lines 9-10: the thesis and the chip carry the words on screen

# ------------------------------------------------------------------ timing (seconds)
TIMING = {
    # Low ends of the natural ranges (research spec, 2026-10-14; ../README.md "Voice timing"): commas 0.2-0.3 where the
    # read pauses at all, sentence stops 0.5-0.75, line gaps 0.6-0.75 inside a scene, 0.83-1.4 at a scene change,
    # 1.0-1.4 before the payoff. The low ends keep the read tight (her "no latency") and still natural.
    "comma": 0.25,          # clause comma, where the read pauses
    "list": 0.20,           # commas inside a list of names (the audible floor)
    "sentence": 0.50,       # full stop inside a line
    "question": 0.55,
    "first_line_at": 0.30,  # first sound of line 1 on the film clock
    # quiet between the end of line i and the first sound of line i+1 (0.8 = scene change, 0.6 = same scene)
    "gaps": [0.80, 0.80, 0.60, 0.80, 0.80, 0.80, 0.80, 1.00, 0.70],
    "keep_edge": 0.045,     # never cut closer than this to either edge of a pause (keeps the decays)
}
# per-mark overrides: (line, spoken word index) -> seconds
OVERRIDE = {
    (1, 1): 0.30,           # "One command, [beat] and your agent..."
    (2, 1): 0.20,           # "Without it, every session" (light)
    (2, 15): 0.65,          # "...you use P N P M. [the tired beat] Again."
    (4, 4): "list", (4, 5): "list",    # "Claude Code, Cursor, Codex"
    (4, 9): 0.55,           # "...Open Code. [copy, the terminal docks] Browser sign-in"
    (4, 15): 0.30,          # "no key to copy, [beat] and there's your agent"  (the row lands on "there's")
    (5, 10): 0.30, (8, 5): 0.30, (9, 1): 0.30,
    (7, 7): 0.22, (7, 9): 0.22,        # "Pick its access, copy it, it only shows once": separate steps
}
QUIET_DB = -40.0            # a 10 ms frame this far under the line's loudest frame counts as silence
MARKS = set(",.?!;:")

def run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode: sys.exit(r.stdout + r.stderr)
    return r.stdout

# ------------------------------------------------------------------ 1. gen
def gen():
    os.makedirs(f"{OUT}/timed", exist_ok=True)
    for i, (text, sp) in enumerate(LINES, 1):
        wav, js = f"{OUT}/timed/l{i}.wav", f"{OUT}/timed/l{i}.json"
        if os.path.exists(js) and json.load(open(js))["text"] == text and json.load(open(js))["speed"] == sp:
            continue
        print(run([PY, os.path.join(KOKORO, "tts_timed.py"), "af_bella", str(sp), wav, text]).strip())

# ------------------------------------------------------------------ 2. words
MERGE = {3: {("with", "the")}}   # text words espeak voices as one phoneme word
def phon_words(tm):
    words, cur = [], []
    for p, s, e in tm:
        if p == " ":
            if cur: words.append(cur); cur = []
        else: cur.append((p, s, e))
    if cur: words.append(cur)
    out = []
    for w in words:
        core = [x for x in w if x[0] not in MARKS]
        out.append({"ph": "".join(x[0] for x in core), "start": core[0][1], "end": core[-1][2],
                    "mark": "".join(x[0] for x in w if x[0] in MARKS)})
    return out

def text_words(line, text):
    out = []
    for w in re.findall(r"[A-Za-z][A-Za-z'\-]*[,.?!]?", text):
        bare = lambda s: re.sub(r"[,.?!]", "", s).lower()
        if out and (bare(out[-1]), bare(w)) in MERGE.get(line, set()): out[-1] += " " + w
        else: out.append(w)
    return out

def frames_rms(a, n):
    m = len(a) // n * n
    return np.sqrt((a[:m].reshape(-1, n) ** 2).mean(1))

def quiet_runs(a, frame=0.01):
    n = int(frame * SR)
    rms = frames_rms(a, n)
    q = rms <= rms.max() * 10 ** (QUIET_DB / 20)
    runs, i = [], 0
    while i < len(q):
        if q[i]:
            j = i
            while j + 1 < len(q) and q[j + 1]: j += 1
            runs.append([i * n, (j + 1) * n]); i = j + 1
        else: i += 1
    return runs, rms

def sound_span(a):
    """First and last sample of sound (above the quiet line), 2.5 ms resolution."""
    n = int(0.0025 * SR)
    rms = frames_rms(a, n)
    loud = np.nonzero(rms > rms.max() * 10 ** (QUIET_DB / 20))[0]
    return int(loud[0] * n), int((loud[-1] + 1) * n)

def target_for(line, k, mark):
    v = OVERRIDE.get((line, k))
    if isinstance(v, (int, float)): return float(v)
    if isinstance(v, str): return TIMING[v]
    if "?" in mark: return TIMING["question"]
    if "." in mark or "!" in mark: return TIMING["sentence"]
    return TIMING["comma"]

# ------------------------------------------------------------------ 3. conform
def conform(i):
    js = json.load(open(f"{OUT}/timed/l{i}.json"))
    a, sr = sf.read(f"{OUT}/timed/l{i}.wav", dtype="float32")
    assert sr == SR
    words = phon_words(js["timings"])
    tw = text_words(i, js["text"])
    assert len(words) == len(tw), (i, [w["ph"] for w in words], tw)
    runs, _ = quiet_runs(a)
    edits, report = [], []         # (position in original samples, delta samples)
    for k, w in enumerate(words):
        w["text"] = tw[k]
        if not w["mark"] or k == len(words) - 1: continue
        lo, hi = int((w["end"] - 0.15) * SR), int((words[k + 1]["start"] + 0.15) * SR)
        cands = [r for r in runs if r[1] > lo and r[0] < hi]
        if not cands:
            report.append(f"  {w['text']!r}: no silence, left as read"); continue
        r0, r1 = max(cands, key=lambda r: r[1] - r[0])
        cur, tgt = (r1 - r0) / SR, target_for(i, k, w["mark"])
        delta = int(round((tgt - cur) * SR))
        mid = (r0 + r1) // 2
        if delta < 0:
            keep = int(TIMING["keep_edge"] * SR)
            room = (r1 - r0) - 2 * keep
            if room <= 0: report.append(f"  {w['text']!r}: {cur:.3f}s, too short to cut"); continue
            delta = -min(-delta, room)
        edits.append((mid, delta))
        w["quiet"] = (r0, r1, delta)
        report.append(f"  {w['text']!r:<14} {w['mark']} {cur:.3f}s -> {cur + delta / SR:.3f}s")
    # apply edits back to front so positions stay valid
    out = a.copy()
    fade = int(0.006 * SR)
    for pos, d in sorted(edits, reverse=True):
        # both sides of the splice sit inside the silence, so a 6 ms fade out / fade in hides the join
        if d < 0:
            p0 = pos - (-d) // 2
            l, r = out[:p0].copy(), out[p0 - d:].copy()
            mid = []
        else:
            l, r = out[:pos].copy(), out[pos:].copy()
            mid = [np.zeros(d, np.float32)]
        x = min(fade, len(l), len(r))
        l[-x:] *= np.linspace(1, 0, x, dtype=np.float32)
        r[:x] *= np.linspace(0, 1, x, dtype=np.float32)
        out = np.concatenate([l, *mid, r])
    def moved(t):
        s = int(round(t * SR))
        return (s + sum(d for p, d in edits if p <= s)) / SR
    for w in words:
        w["start"], w["end"] = moved(w["start"]), moved(w["end"])
        if "quiet" in w:      # where the pause after this word starts and ends, after the edit
            r0, r1, d = w.pop("quiet")
            q0 = moved(r0 / SR)
            w["pause"] = (q0, q0 + (r1 - r0 + d) / SR)
    assert len(out) == len(a) + sum(d for _, d in edits)
    s0, s1 = sound_span(out)
    os.makedirs(f"{OUT}/conformed", exist_ok=True)
    sf.write(f"{OUT}/conformed/l{i}.wav", out, SR, subtype="FLOAT")
    return {"line": i, "audio": out, "words": words, "sound": (s0 / SR, s1 / SR), "report": report}

# ------------------------------------------------------------------ captions: display tokens -> spoken words
ALIAS = {"ok": ["okay"]}
def bare(s): return re.sub(r"[^a-z0-9']", "", s.lower())
def map_tokens(line, words):
    spoken = [bare(w["text"].replace(" ", "")) for w in words]
    chunks, j = [], 0
    for chunk in CAPTIONS[line - 1]:
        toks = []
        for tok in chunk.split(" "):
            b = bare(tok)
            for n in range(1, 5):
                cat = "".join(spoken[j:j + n])
                if cat == b or cat in ALIAS.get(b, []) or (n == 1 and b in ("with", "the") and spoken[j] == "withthe"):
                    break
            else:
                sys.exit(f"line {line}: can't map {tok!r} at spoken {spoken[j:j + 4]}")
            toks.append({"text": tok, "w0": j, "w1": j + n - 1})
            if not (b == "with" and spoken[j] == "withthe"): j += n
        chunks.append(toks)
    assert j == len(spoken), (line, j, len(spoken))
    return chunks

# ------------------------------------------------------------------ 4-6
def main():
    gen()
    lines = [conform(i) for i in range(1, len(LINES) + 1)]
    for L in lines:
        print(f"l{L['line']}  sound {L['sound'][0]:.3f}-{L['sound'][1]:.3f}s")
        print("\n".join(L["report"]))
    # place: line 1's first sound at first_line_at; then speech end + gap; snap each first sound to a frame
    starts, t = [], TIMING["first_line_at"]
    for k, L in enumerate(lines):
        onset = round(t * FPS) / FPS                  # film time of this line's first sound, on a frame
        starts.append(onset - L["sound"][0])         # film time of the line file's sample 0
        if k < len(lines) - 1:
            t = onset + (L["sound"][1] - L["sound"][0]) + TIMING["gaps"][k]
    total = starts[-1] + len(lines[-1]["audio"]) / SR + 0.5
    track = np.zeros(int(total * SR) + 1, np.float32)
    for L, st in zip(lines, starts):
        p = int(round(st * SR)); track[p:p + len(L["audio"])] += L["audio"]
    sf.write(f"{OUT}/vo_track_raw.wav", track, SR, subtype="FLOAT")
    chain = ("aresample=48000:filter_size=128:phase_shift=10:cutoff=0.97,highpass=f=85,"
             "equalizer=f=260:t=q:w=1:g=-1.5,equalizer=f=3400:t=q:w=1.3:g=2.2,equalizer=f=10500:t=h:w=0.7:g=1.5,"
             "deesser=i=0.35:m=0.5:f=0.5,acompressor=threshold=-21dB:ratio=2.6:attack=4:release=90:makeup=2.5")
    run([FF, "-v", "error", "-y", "-i", f"{OUT}/vo_track_raw.wav", "-af", chain, "-c:a", "pcm_f32le", f"{OUT}/vo_track.wav"])
    # check the polish pass kept every line exactly where it was placed (onset within 1 ms)
    pol, psr = sf.read(f"{OUT}/vo_track.wav", dtype="float32")
    if pol.ndim > 1: pol = pol.mean(1)
    n = int(0.001 * psr)
    env = frames_rms(pol, n)
    for L, st in zip(lines, starts):
        want = st + L["sound"][0]
        k0 = int((want - 0.05) / 0.001)
        seg = env[k0:k0 + 100]
        got = (k0 + int(np.argmax(seg > env.max() * 10 ** (QUIET_DB / 20)))) * 0.001
        assert abs(got - want) <= 0.0025, f"line {L['line']} moved: {want:.4f} -> {got:.4f}"
    print("polish pass: every line onset within 2.5 ms of its placement")
    # audible onset of every word, read off the polished track (the picture keys to these, not the phoneme clock):
    # after a pause, the first 1 ms frame above the quiet line; inside connected speech, the strongest spectral-flux
    # rise (300 Hz-8 kHz) within -40/+70 ms of the phoneme start
    nfft, hop = 512, 48
    win = np.hanning(nfft).astype(np.float32)
    fr = np.fft.rfftfreq(nfft, 1 / psr); band = (fr > 300) & (fr < 8000)
    nfr = (len(pol) - nfft) // hop
    idx = np.arange(nfft)[None, :] + hop * np.arange(nfr)[:, None]
    mag = np.log(np.abs(np.fft.rfft(pol[idx] * win, axis=1))[:, band] + 1e-6)
    flux = np.concatenate([[0], np.maximum(0, np.diff(mag, axis=0)).sum(1)])
    ftime = (np.arange(nfr) * hop + nfft / 2) / psr
    thr_all = env.max() * 10 ** (QUIET_DB / 20)
    for L, st in zip(lines, starts):
        ws = L["words"]
        for k, w in enumerate(ws):
            s0 = st + w["start"]
            after_pause = k == 0 or "pause" in ws[k - 1]
            if after_pause:
                b = st + (ws[k - 1]["pause"][1] if k else L["sound"][0])
                k0 = int((b - 0.03) / 0.001)
                seg = env[k0:k0 + 80]
                w["aon"] = (k0 + int(np.argmax(seg > thr_all))) * 0.001
            else:
                lo, hi = s0 - 0.04, s0 + 0.07
                if k + 1 < len(ws): hi = min(hi, st + ws[k + 1]["start"] - 0.02)
                if k > 0: lo = max(lo, st + ws[k - 1]["start"] + 0.04)
                m = (ftime >= lo) & (ftime <= hi)
                w["aon"] = float(ftime[m][np.argmax(flux[m])]) if m.any() else s0
    d_on = [lines[i]["words"][k]["aon"] - (starts[i] + lines[i]["words"][k]["start"]) for i in range(len(lines)) for k in range(len(lines[i]["words"]))]
    print(f"audible onsets vs phoneme clock: median {np.median(d_on) * 1000:+.0f} ms, range {min(d_on) * 1000:+.0f} to {max(d_on) * 1000:+.0f} ms")
    # export
    data = []
    for L, st in zip(lines, starts):
        ws = [{"text": w["text"], "on": round(st + w["start"], 4), "off": round(st + w["end"], 4), "aon": round(w["aon"], 4),
               **({"pause": [round(st + w["pause"][0], 4), round(st + w["pause"][1], 4)]} if "pause" in w else {})} for w in L["words"]]
        data.append({"line": L["line"], "start": round(st + L["sound"][0], 4), "end": round(st + L["sound"][1], 4),
                     "words": ws, "chunks": map_tokens(L["line"], L["words"]), "burn": BURN[L["line"] - 1]})
    json.dump({"fps": FPS, "timing": TIMING, "lines": data}, open(os.path.join(SRC, "vo_times.json"), "w"), indent=1)
    sw = ["// Generated by audio/vo_build.py from the timed Bella read. Do not edit by hand.",
          "// Film-clock seconds. VO_ON[l][w] = spoken word w of line l starts (phoneme clock); VO_OFF = it ends.",
          "let VO_START: [Double] = [" + ", ".join(f"{d['start']:.4f}" for d in data) + "]",
          "let VO_END: [Double] = [" + ", ".join(f"{d['end']:.4f}" for d in data) + "]",
          "/// VO_AON[l][w]: when word w of line l becomes audible on the final 48 kHz track. The picture keys to this.",
          "let VO_AON: [[Double]] = ["] + ["\t[" + ", ".join(f"{w['aon']:.4f}" for w in d['words']) + "]," for d in data] + ["]",
          "let VO_ON: [[Double]] = ["] + ["\t[" + ", ".join(f"{w['on']:.4f}" for w in d['words']) + f"],   // l{d['line']}" for d in data] + ["]",
          "let VO_OFF: [[Double]] = ["] + ["\t[" + ", ".join(f"{w['off']:.4f}" for w in d['words']) + "]," for d in data] + ["]",
          "/// Pauses the voice takes after a word: (line, word, quiet starts, quiet ends). The word is heard ending at the start.",
          "let VO_PAUSE: [(l: Int, w: Int, a: Double, b: Double)] = ["] + [f"\t(l: {d['line'] - 1}, w: {k}, a: {w['pause'][0]:.4f}, b: {w['pause'][1]:.4f})," for d in data for k, w in enumerate(d['words']) if 'pause' in w] + ["]"]
    sw += ["struct CapTok { let text: String; let w0: Int; let w1: Int }",
           "/// Caption chunks per line: one on-screen caption line each, tokens mapped to spoken words.",
           "let CAPS: [(line: Int, burn: Bool, chunks: [[CapTok]])] = ["]
    for d in data:
        cs = ", ".join("[" + ", ".join(f'CapTok(text: {json.dumps(t["text"])}, w0: {t["w0"]}, w1: {t["w1"]})' for t in ch) + "]" for ch in d["chunks"])
        sw.append(f"\t(line: {d['line'] - 1}, burn: {'true' if d['burn'] else 'false'}, chunks: [{cs}]),")
    sw.append("]")
    open(os.path.join(SRC, "vo_times.swift"), "w").write("\n".join(sw) + "\n")
    # SRT: one cue per caption chunk
    def ts(x):
        ms = int(round(x * 1000)); return f"{ms // 3600000:02d}:{ms // 60000 % 60:02d}:{ms // 1000 % 60:02d},{ms % 1000:03d}"
    cues = []
    for d in data:
        for ch in d["chunks"]:
            on = d["words"][ch[0]["w0"]]["aon"] - 0.05
            off = d["words"][ch[-1]["w1"]]["off"] + 0.25
            cues.append([on, off, " ".join(t["text"] for t in ch)])
    for a_, b_ in zip(cues, cues[1:]): a_[1] = min(a_[1], b_[0] - 0.02)
    srt = "\n".join(f"{k + 1}\n{ts(c[0])} --> {ts(c[1])}\n{c[2]}\n" for k, c in enumerate(cues))
    open(os.path.join(SRC, "captions.srt"), "w").write(srt)
    print(f"track {len(track) / SR:.2f}s; lines at " + ", ".join(f"{d['start']:.3f}-{d['end']:.3f}" for d in data))
    print(f"speech ends {data[-1]['end']:.2f}s; wrote vo_track.wav, vo_times.swift/.json, captions.srt")

if __name__ == "__main__":
    main()
