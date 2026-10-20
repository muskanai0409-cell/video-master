# hyperframes-starter

A supermemory starting point for films built with HyperFrames (HeyGen's HTML-to-video framework). Set up and tested on 2026-10-21 with HyperFrames 0.8.181, installed as the Claude Code plugin `hyperframes@hyperframes`.

The starter holds the brand constant and nothing else. The look of each film still comes from its style card (`references/anti-house-style.md`), so do not treat the template's hook animation as a house style.

## What is in it

| Path | What |
|---|---|
| `make.sh` | the only way to run the CLI here: plugin launcher, telemetry off, Cardboard's ffmpeg on PATH |
| `template/index.html` | root composition: brand tokens, Geist faces, a variable-driven hook on the root, the end card host |
| `template/compositions/endcard.html` | scene file: the official horizontal lockup as a CSS mask, four colourway classes, cut in and hold |
| `template/assets/` | vendored GSAP 3.14.2, Geist and Geist Mono, `brand/lockup.svg` and `brand/mark.svg` (official paths, `currentColor`) |
| `template/ASSETS.md` | source and licence of every asset |
| `template/hyperframes.json` | registry and paths, as `init` writes them |

## Start a film

```bash
SRC=~/personal-supermemory/reports/videos/<film>-src
cp -R ~/.claude/skills/video-master/engine/hyperframes-starter/template "$SRC"
M=~/.claude/skills/video-master/engine/hyperframes-starter/make.sh
$M "$SRC" check                       # lint + runtime + layout + motion + contrast
$M "$SRC" preview                     # Studio in the background; stop with: $M "$SRC" stop
$M "$SRC" draft                       # 1080p30 draft for timing
$M "$SRC" master                      # 4K60 delivery master + lanczos 1080p cut, bt709
$M "$SRC" probe "$SRC/renders/<film>-src-1080p60.mp4"
$M "$SRC" frames "$SRC/renders/<film>-src-1080p60.mp4" 0 2.5 5.9
```

Hook variants for A/B tests: `$M "$SRC" draft --variables '{"headline":"your agent forgot again"}'`, or a batch file with `render --batch rows.json`.

Renders land in `renders/`, which stays on the Mac (the personal repo ignores video files).

## Rules this starter already follows

- One root timeline per composition, paused, registered as `window.__timelines["<id>"]`. Host id, scene root id and timeline key are the same string.
- Top-level clips only on the root; nested layout lives in a scene file (lint `nested_structure_needs_subcomposition`).
- Render-time `--variables` reach the root only (tested). Variable-driven text goes on the root; scene files take static `data-variable-values` from their host.
- No CDN at render time: GSAP is vendored. No `Date.now()`, no unseeded `Math.random()`, no `repeat: -1`.
- Text containers are `display:block`. A flex container drops the space before an inline accent span.
- Never set a CSS transform on something GSAP moves; centre with `yPercent`.
- The lockup is the official SVG used as a mask. Never redraw, trace, glow, outline or stack it (`references/brand.md`).

## Numbers from the test renders (this Mac)

- 6s 1080p30 draft: about 8s, fast "drawelement" capture with the hardware GPU.
- 6s 4K60 delivery: 35s, screenshot capture.
- Decoded hex with the bt709 matrix: white `#fdfdfd`, accent `#0460ed` on text. That is inside the 2 to 3 level drift `references/qa.md` accepts.

## Still to do per film

Everything in SKILL.md §3 (brief, claims table, story, beat map, stills, QA) applies. Read `references/hyperframes.md` for the HyperFrames rules, the official skills to load, and how they fit her taste rules.
