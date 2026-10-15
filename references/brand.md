# Brand quick reference

**Sources:** her pack's `reference/brand-systems.md` and `skills/supermemory-explainers` section 1 (tokens read from supermemory.ai computed CSS, September 2026); the supermemory.ai site as observed on 2026-10-05, with values measured from 1x screenshots (`scratchpad/vidmaster/site-*.png`, session-only); her memory notes; the lockup files in `reports/videos/`.

---

## 1. Pick one surface per video

They are not the same, and mixing them is the most common brand error (pack). Name the surface in the delivery note.

| Surface | Use for | Ground | Ink | Accent | Type |
|---|---|---|---|---|---|
| **supermemory.ai site** (default now) | explainers, launch films, data films about supermemory | `#ffffff` body, `#f4f4f6` paper | `#0b1015` | `#0562ef` only | Geist, Geist Mono |
| Brand guidelines PDF | console and product films | flat ink `#0B1B41` for brand beats, paper for product | `#0B1B41` | blue 500 `#0562EF`, blue 600 `#0100F5` | per the PDF: Space Grotesk display, Geist headings, Geist Mono labels. Her mid-Sep feedback moved captions to Geist |
| smfs.ai | smfs data films only | `#fafaf8` | `#2c1a0e` | terracotta `#d4785a`, only ever smfs | Space Grotesk, DM Mono |

The full table of each surface, and every known conflict between them, is in the pack's `reference/brand-systems.md`. The brand PDF is on this Mac at `~/Downloads/Supermemory Brand Guidelines.pdf`.

---

## 2. supermemory.ai tokens

```
--paper  #f4f4f6   --ink #0b1015   --rule #dfdfdf   body #ffffff
--blue   #0562ef   --blue-deep #0450c8   --blue-press #033a9a   --on-blue #f4f8ff
--tick   #9ec6f7   (on dark grounds only: 1.77:1 on white, effectively invisible)
--logo-ink #141b34   --live #00c763
ink alphas: 86% #0b1015db  68% #0b1015ad  60% #0b101599  45% #0b101573  40% #0b101566  10% #0b10151a
--font Geist   --font-mono "Geist Mono"   radius 0px sitewide
arrival easing cubic-bezier(.22,1,.36,1)   move easing cubic-bezier(.2,0,0,1)
```

- Every grey is ink at an alpha. Neutral greys (`#e4e4e4`, `#a8a9a9`) were rejected in review.
- One blue. On white, `#0562ef` is right for hairlines and ticks too (5.25:1). Never use `#9ec6f7` for thin elements on white.
- Write "supermemory" and "supermemory.ai" in lowercase.

---

## 3. Website patterns (observed 2026-10-05)

| Pattern | What it looks like | Measured or noted |
|---|---|---|
| Ground | white page, paper only for surfaces | body `#ffffff` |
| Corners | square everywhere, including buttons and cards | radius 0 |
| Hairline cards and dividers | 1px lines, white fill | `#dfdfdf` (matches `--rule`) |
| Mono labels | Geist Mono, uppercase, letter-spaced: `IN PRODUCTION`, `RECALL LATENCY`, `RAW DATA`, `FILES IN MEMORY (LOG SCALE)` | not measured; use ink 60 to 68% (pack tokens) |
| Statements | Geist, most words grey, key words in full ink: "Our **promise** is the best memory for agents" | grey measured `#919395` on white, which is ink 45%; key words `#0b1015` |
| Figures | a hairline frame with a dot grid inside, grey square nodes with line icons, mono labels under nodes, dashed connectors, the active node as a solid blue tile | dots 2px at a 16px pitch, `#e6e6e7` (about ink 10%); dashed connectors 1px, 3px on and 3px off, `#bbbcbe` (about ink 28%) |
| Blue tile with the white mark | a solid square in brand blue with the white supermemory mark, used for learner-1 and the #1 bar | `#0562ef` exactly |
| Big numbers | Geist at large size with a small `+` or unit: `1T+`, `100k+`, `187ms`, `81%`, with a mono caption line above | eyeballed: the unit is about a third of the number's height |
| Numbered cards | `001 / 002 / 003` in small mono, top right, with corner crop brackets | |
| Quote block | a thin blue rule on the left | |
| Blue flower-field film | blue duotone footage of flowers moving | `field.mp4`, see section 5 |

Two cautions from the site:
- The figure on the homepage labels a node `SUPERMEMORY` in uppercase mono. The pack's rule wins: keep the brand name lowercase even inside an uppercase label row (the mcp-upload cut used lowercase labels for this reason).
- Do not lift numbers from the site into a video from memory. Scale numbers differ between sources and over time (site: "100k+ organizations", "over a trillion tokens a month"; the 2026-09-08 site said 100B+ tokens a day). Re-read the live page on the day and attribute it.

The memory-graph and mcp-upload cuts used rounded stages and cards. Under the current direction, video corners are square like the site unless a brief asks otherwise.

---

## 4. The 16:9 frame spec (a starting point)

> **Shipped values (mcp-upload v3, 2026-10-05) override the proposal below where they differ:** topic HUD at y 76 (mono 15px caps), chapter label mono 20px caps at y 404 with a 1px rule under it, statements Geist 500 56px with 66px leading from y 484 in a column x 112-752, figure x 800-1840 by y 110-970 with a white caption plate, progress bars at y 1010 (80px each, 12px gaps), a 20px logo mark bottom right, a 1px left rail at x 72. She asked for bigger diagrams, so keep the figure at least this size.

```
canvas     1920x1080, 60fps, 4-subframe motion blur
ground     #ffffff or #f4f4f6, one per film. On paper, cards are white. On white, cards are hairline only.
gutters    96px left and right
HUD        y 56-96
           left   section label "01 · THE PROBLEM"   Geist Mono 500, 28px, uppercase, tracking 0.06em, ink 68%
           right  "supermemory · <topic>"             Geist Mono 500, 28px, lowercase, ink 45%
           optional 1px #dfdfdf rule at y 120, x 96-1824
text col   x 96-816 (720px)
           one statement per beat, Geist 500, 64px (72-80px for short lines), line-height 1.1, tracking -0.02em
           2-3 lines, first line at the same y for every statement
           most words ink 45%, key words #0b1015, at most one blue word in the film
           a number's source line under it: Geist Mono 26-28px, ink 45%
stage      x 896-1824, y 168-912 (928x744)
           optional hairline frame #dfdfdf with the dot grid inside, locked to the figure
progress   y 1000, x 96-1824, one segment per chapter, 12px gaps, 2px tall
           done ink 68%, upcoming ink 10%, the active one fills with time in ink 68%. Never blue.
```

**Where the numbers come from.** 96px gutters: the Dreaming photo brief (brief 52). 28px labels: smfs v4, where small labels were raised to 28px at 1920x1080. Statement size: memory-graph v3 set full sentences at 80px at 16:9 (about 16px on a 390px phone) and found 16:9 needs about 1.5x the square sizes; 64px is about 13px on a phone, so treat 64px as the floor. Column width: Geist 500 measured 0.46 to 0.50em per character with CoreText (2026-10-05), so 720px holds about 22 characters per line at 64px and about 19 at 80px. Always measure in the engine. Everything else here is a proposal for her to confirm.

**Square social cuts:** use the pack's square grammar instead (bottom statement band with a fixed first-line baseline, 96px gutters, statements 44 to 56px, labels 26px minimum, checked at 360px wide).

---

## 5. Assets and where they live

| Asset | Path | Notes |
|---|---|---|
| Official lockup masks | `/Users/muskan/personal-supermemory/reports/videos/mcp-upload-src/lock_mark.png` (588x480) and `lock_word.png` (3182x381); same files in `memory-graph-src-v3/` | white-on-black luminance masks; draw in any of the four official colourways |
| Lockup geometry | mark 588x480, gap 230, wordmark 3182x381, wordmark top 99px below the mark top | from `memory-graph-src-v3/geom.npy`; within about 2% of the proportions of the brand PDF's p.14 lockup measured at 600dpi (mark 1123x912, gap 440, wordmark 6087x726, top 186) |
| Lockup source | `/Users/muskan/supermemory/apps/web/public/logo-light-fullmark.svg` and `logo-fullmark.svg` | memory-graph used the light fullmark; it matches the PDF geometry |
| Fonts | `Geist.ttf`, `GeistMono.ttf` in `reports/videos/mcp-upload-src/fonts/` | variable weight |
| Blue flower-field film | `/Users/muskan/personal-supermemory/reports/videos/memory-graph-src-v3/assets/field.mp4` | the site's `/brand/media/field.mp4`; 1280x720, 25fps, 32s; memory-graph used the 22 to 32s stretch |
| Console graph capture | `memory-graph-src-v3/assets/prasanna_graph.mp4` | Prasanna's Sep 19 recording, 2332x1430, 120fps; real UI, so usable; never caption it "live" |
| Dawn photograph (dusk register) | `https://supermemory.ai/brand/media/cta-dawn.jpg` | she later asked for "a plain white one", so light is the default |
| Engine copies | `~/.claude/skills/video-master/engine/assets/` | being set up by the main session; see `pipelines.md` section 3 |
| smfs lockup and fonts | the pack's `studio/fonts/`; the lockup asset from the smfs cuts | smfs films only |

The official mark and lockup artwork is supermemory's. Never put it in a public repo.

---

## 6. Never

- Redraw, trace, assemble from pieces, stack, recolour outside the four colourways (paper on blue, paper on ink, and their inverses), glow, shadow or outline the mark. The end-card lockup is horizontal, never stacked.
- Mix surfaces: no terracotta outside smfs, no PDF blue 600 in a site-surface film, no smfs brown ink in a supermemory film.
- Tailwind blues (`#2563EB`, `#60A5FA`), violet, Inter. All three were v1 mistakes.
- Gradients, glow, bloom, particles, 3D, shadows, emoji, extra logos, new fonts.
- Neutral greys, colour tweens, eyedropped hex values from a preview.
- Uppercase "SUPERMEMORY", "Supermemory" at the start of a caption, Title Case, em dashes.
- Fabricated product UI, or a rebuild of the product UI from component libraries.
- Brain or Nova presented as live products. Both were discontinued.
