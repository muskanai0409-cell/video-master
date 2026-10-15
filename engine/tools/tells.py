#!/usr/bin/env python3
"""tells.py: lint a film's source folder for the house-style tells (anti-house-style.md).

Usage:  python3 -I tells.py <film-src-folder> [--log <style-log.md>]

It reads every .swift, .metal, .sh and .md file in the folder (not subfolders named parts/qa/stills/audio) and reports:
  1. named Opus defaults found in on-screen strings (numbered "01 ·" labels and friends)
  2. which of the 12 viral-recipe moves the code appears to use (cap: 4)
  3. copied house constants (the 2.4 Hz / 0.62 spring, the caption band at y 868, the shared lib.swift, the lattice
     pulse, the 01 Hip Hop kits)
  4. whether the README carries a style card, and (with --log) how many of its 11 dimensions look like each of the
     last three films in the style log (cap: 2 shared with any of them)

The checks are heuristics on names and strings: a hit means "look here", not proof. Exit code 1 when a cap is broken.
"""
import hashlib, os, re, sys

SKIP_DIRS = {"parts", "qa", "stills", "audio", "frames", "fonts", "sfx", "bg", ".git"}
SHARED_LIB_MD5 = "674a21f5"          # prefix of the byte-identical lib.swift in learner v7, forgetting v3, local v0.0.9

RECIPE = [
    (1, "one continuous take, scenes grown from the last", [r"continuous take", r"one take", r"zero cuts", r"no cuts"], "md"),
    (2, "text rising from a mask line", [r"\briseText\b", r"\bmaskRise\b", r"\bletterRise\b", r"rises? from a mask", r"mask[- ]rise"], "code"),
    (3, "spring pops from zero", [r"\bpop\w*\s*\(", r"spring\([^)]*zeta:\s*0\.[0-6]", r"pops? from zero"], "code"),
    (4, "flood and shrink", [r"\bflood\w*", r"flood and shrink"], "any"),
    (5, "closed-form spring on every arrival", [r"func spring\(", r"spring\(t"], "code"),
    (6, "an event on every beat", [r"every beat", r"lands every half second", r"something lands"], "md"),
    (7, "a drawn cursor with clicks", [r"\bcursor\w*\s*\(", r"\bclickRipple\w*", r"\bripple\w*\s*\("], "code"),
    (8, "camera push or zoom on every beat", [r"\bpunch\w*\s*\(", r"\bwhip\w*\s*\(", r"push on every beat", r"zoom to fill"], "any"),
    (9, "fixed 4-subframe blur", [r"SUBFRAMES\s*[:=]?\s*\??\s*\"?4", r"subframes\s*=\s*4", r"4[- ]subframe"], "any"),
    (10, "SFX on peaks at -14 LUFS", [r"I=-14", r"-14 LUFS"], "any"),
    (11, "one still per beat and a pop scan", [r"pop scan", r"pops\.txt", r"one (still|frame) per beat"], "any"),
    (12, "edge springs that stretch shapes", [r"edge springs?", r"leading and trailing edge"], "any"),
]
DEFAULTS = [
    ("numbered section label (01 ·)", r"[\"']\s*0[1-9]\s*[·.|/]\s*[A-Za-z]"),
    ("numbered counter label (01 / 05)", r"[\"']\s*0[1-9]\s*/\s*0[1-9]"),
    ("uppercase mono section label", r"mono\([^)]*\)[^\n]{0,80}[\"'][A-Z]{3,}[ A-Z·]{3,}[\"']"),
]
HOUSE = [
    ("the 2.4 Hz / 0.62 house spring", r"freq:\s*2\.4\b[^\n]{0,40}zeta:\s*0\.6[0-9]?"),
    ("the caption band at y 868", r"\b868\b"),
    ("a lattice that pulses to the beat", r"\blatticePulse\b"),
    ("the 01 Hip Hop loop kits", r"01 Hip Hop|Yearning_|Longing_|Full_Moon_|Regrets"),
    ("the 160 BPM house grid", r"BPM\s*[:=]?\s*\"?\(?\s*160\b"),
]

def files(root):
    for d, sub, fs in os.walk(root):
        sub[:] = [s for s in sub if s not in SKIP_DIRS]
        for f in fs:
            if f.endswith((".swift", ".metal", ".sh", ".md")) and f not in ("render.swift", "snd.swift", "sndl.swift"):
                yield os.path.join(d, f)

def read(p):
    try:
        return open(p, encoding="utf-8", errors="replace").read()
    except OSError:
        return ""

STOP = set("a an the and or of to in on with for by at as is it its one two each per no not then from into only".split())
def words(s):
    return {w for w in re.findall(r"[a-z0-9]+", s.lower()) if w not in STOP and len(w) > 2}

DIMS = ["concept", "ground", "type", "layout", "colour", "camera", "transitions", "texture", "rhythm", "sound", "ending"]
ALIASES = {"anchor": "concept", "medium": "ground", "palette": "colour", "palette roles": "colour", "color": "colour",
           "cadence": "rhythm", "motion cadence": "rhythm", "type system": "type", "transition": "transitions",
           "ending device": "ending", "music": "sound", "concept or anchor": "concept", "ground or surface": "ground",
           "colour strategy": "colour", "camera grammar": "camera", "rhythm and editing": "rhythm", "sound palette": "sound",
           "transition family": "transitions", "texture (one imperfection layer per film)": "texture"}

def style_card(readme):
    """the README's style card as {dimension: text}; accepts the 9-field and 11-dimension forms"""
    m = re.search(r"#+\s*Style card.*?\n(.*?)(\n#+\s|\Z)", readme, re.S | re.I)
    if not m:
        return {}
    card = {}
    for row in m.group(1).splitlines():
        cells = [c.strip() for c in row.strip().strip("|").split("|")]
        if len(cells) < 2 or set(cells[0]) <= set("-: "):
            continue
        key = re.sub(r"[*`]", "", cells[0]).lower().strip()
        key = ALIASES.get(key, key)
        for d in DIMS:
            if key.startswith(d):
                key = d
        if key in DIMS:
            card[key] = " ".join(cells[1:])
    return card

def log_rows(log):
    rows, header = [], None
    for line in log.splitlines():
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if header is None and cells and cells[0].lower() == "date":
            header = [c.lower() for c in cells]
            continue
        if header and not set(cells[0]) <= set("-: ") and len(cells) == len(header):
            rows.append(dict(zip(header, cells)))
    return rows

def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    root = sys.argv[1]
    log_path = sys.argv[sys.argv.index("--log") + 1] if "--log" in sys.argv else None
    code, md, broke = "", "", False
    for p in files(root):
        t = read(p)
        if p.endswith(".md"):
            md += t + "\n"
        else:
            code += t + "\n"
    print(f"tells.py: {root}\n")

    print("1. Named Opus defaults in on-screen strings")
    hits = [(name, len(re.findall(rx, code))) for name, rx in DEFAULTS]
    for name, n in hits:
        if n:
            print(f"   ! {name}: {n}")
    if not any(n for _, n in hits):
        print("   none found")

    print("\n2. Viral-recipe moves (cap 4 of 12)")
    used = []
    for num, name, rxs, where in RECIPE:
        hay = md if where == "md" else code if where == "code" else code + md
        if any(re.search(rx, hay, re.I) for rx in rxs):
            used.append(num)
            print(f"   #{num:<2} {name}")
    print(f"   = {len(used)} of 12" + ("   OVER THE CAP" if len(used) > 4 else ""))
    broke |= len(used) > 4

    print("\n3. Copied house constants")
    found = False
    for name, rx in HOUSE:
        n = len(re.findall(rx, code + md))
        if n:
            found = True
            print(f"   ! {name}: {n}")
    lib = os.path.join(root, "lib.swift")
    if os.path.exists(lib):
        h = hashlib.md5(open(lib, "rb").read()).hexdigest()
        if h.startswith(SHARED_LIB_MD5):
            found = True
            print("   ! lib.swift is the shared house copy (md5 674a21f5...): derive the feel constants from the style card")
    if not found:
        print("   none found")

    print("\n4. Style card")
    readme = read(os.path.join(root, "README.md"))
    card = style_card(readme)
    if not card:
        print("   ! no '## Style card' table in README.md (anti-house-style.md section 2)")
        broke = True
    else:
        print(f"   {len(card)} of 11 dimensions written: {', '.join(card)}")
        if log_path:
            rows = [r for r in log_rows(read(log_path)) if os.path.basename(os.path.normpath(root)).split('-src')[0] not in r.get("film", "")]
            for r in rows[:3]:
                shared = []
                for d in DIMS:
                    a, b = words(card.get(d, "")), words(r.get(d, ""))
                    if a and b and len(a & b) / len(a | b) >= 0.34:
                        shared.append(d)
                flag = "   OVER THE CAP" if len(shared) > 2 else ""
                print(f"   vs {r.get('film', '?')[:48]:<48} shares {len(shared)}: {', '.join(shared) or '-'}{flag}")
                broke |= len(shared) > 2
    sys.exit(1 if broke else 0)

if __name__ == "__main__":
    main()
