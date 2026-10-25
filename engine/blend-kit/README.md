# blend-kit: one-take blend moves for HyperFrames films

The moves from `references/one-take-blend.md`, studied from the Mem0 Claude Code explainer (Oct 2026), as pure functions of `t`. The template is a 15s demo with zero cuts, in supermemory's brand.

The demo's sequence:
1. A window stands up out of the ground glow.
2. Its facts become chips as they are typed.
3. The chips go soft as depth while a statement resolves word by word.
4. The tile resolves from blur, a band opens out of it and straightens into a bar.
5. The chips come back, line up, and are absorbed one by one (card, pill, dot, flight with a trail).
6. An agent chip slides in with motion blur and grows into a window under a blue wash that cools.
7. The bar answers it with a glow and rising dots.
8. The window folds back into its chip, and the official lockup steps in letter by letter. The tagline resolves and one shimmer passes.
9. Still hold.

Measured on the 1080p30 draft: 15.0s, 0 cuts, 45.5% moving (`qa.md` 2.3), longest still 1.2s (the end hold). The Mem0 film: 49.5%.

## Files

| Path | What |
|---|---|
| `template/assets/blend.js` | `window.BLEND`: curves, `hinge`, `defocus`, `wordIn`, `wipeOut`, `mblur` + `speedOf`, `washBirth`, `morphRect` + `place`, `bandPath`, `absorb`, `count`, `hop`, `steps` + `LOCKUP_STEPS`, `shimmer`, `WORD` |
| `template/index.html` | the demo: DOM for windows, chips and type; one canvas for the band, particles, flying dots and connectors; a slow eased camera on the root |
| `template/assets/` | GSAP, Geist, Geist Mono and the official mark and lockup, copied from `hyperframes-starter` |

## Start a film from it

```bash
SRC=~/personal-supermemory/reports/videos/<film>-src
cp -R ~/.claude/skills/video-master/engine/blend-kit/template "$SRC"
M=~/.claude/skills/video-master/engine/hyperframes-starter/make.sh
$M "$SRC" lint
$M "$SRC" snapshot --at 1,3,5,7,9,11,13 --no-end
$M "$SRC" draft
WORKERS=2 HF_SEGMENTED_CAPTURE=true $M "$SRC" render --resolution landscape-4k --output renders/<film>-src-4k60.mp4
```

## Rules that came with it

- **Picture leads its word by 0.2 to 0.4s.** Beats key to `WORD(line, "word")`, which needs `words` in `vo-times.js` (`tools/vo_eleven.py` in the one-API film writes them), or to `BRK(line, word)` for phrase breaks.
- **One object carries the frame.** Before adding an element, decide which existing element it grows out of, and where it goes when it is done (into a container, into a chip, or soft as depth).
- **One hue in five values** (`#031a4a`, `#0b2a6b`, `#2f86ff`, `#6fa8ff`, `#9cc3ff`) on the blue night. A guest colour (Claude coral) is only ever a wash on that product's own window.
- **The lockup is the official SVG as a mask.** It is stepped in by its real letter edges (`LOCKUP_STEPS`, measured from `lockup.svg`). The mark itself never glows or shimmers; the shimmer is on the tagline only.
- **Never copy Mem0's look, copy or numbers**; the reference says why.
- **Helper names must not clash with a film's globals.** A `PW` helper once blanked a film because `PW` was already the part width.
