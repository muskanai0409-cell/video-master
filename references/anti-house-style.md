# Anti-house-style: every film gets its own visual language

**Her words, 2026-10-15:** "people can easily understand that you are making videos with opus 5.5 ... there's a watermark in every video that you make ... i dont want you to be generic at all, writing the text in the same way and same watermark ... please do anything to be the best at the game." Then: "also dont lose the supermemory branding in learning new stuff okay?"

**What this means:** the brand stays fixed. Everything else changes from film to film, on purpose, and is checked before any code is written.

The research behind this file is in `~/personal-supermemory/research_notes/Motion mastery/` (lanes A to D). The proof film is `reports/videos/media-reel-src/`.

## 1. My watermark (what made the films recognisable)

The diagnosis comes from my own films and lane C, section 4.1. Every row below is now a default to avoid, not a rule.

| Area | The tell | Where it came from |
|---|---|---|
| Type | Every statement rises from a mask line in Geist 500, ink 45% with key words in full ink, two lowercase lines in a bottom caption band | motion-grammar §3.7, every explainer since mcp-upload |
| Labels | Mono `01 · SECTION` labels, big section numbers, a HUD with topic and chapter progress | brand.md §4 |
| Ground | Blue 600 field with a Bayer-dithered dot lattice; hairline grid with + marks; `field.mp4` under a tint; paper and gold on blue | one command, namespaces, plugins, learner, local |
| Motion | One spring family with overshoot on every arrival; scramble text; a Hermite camera that never rests; rings, punches, a drawn cursor | rossaxbt-derived rules (SKILL §1f) |
| Ending | Object, then the mark pops, then the wordmark wipes in, then the horizontal lockup, then a held still | nearly every film (#70, #73, #74, #76, #91, #92) |
| Sound | Apple Loops hip-hop kits (Regrets, Longing, Yearning, Full Moon) or a 160 BPM F-minor synth into the trap lane; crash, riser and boom at every turn | one command to local v0.0.9 |
| Layout | The 16:9 explainer frame: text column, figure stage, HUD, progress | brand.md §4 |

The brand itself is not part of the watermark. The mark, the blue, lowercase supermemory, Geist and the lockup stay, as section 4 below says.

## 2. The rule: a style card before any code

Write this card in the film's README before the first still. Nine fields:

1. **Anchor from outside tech.** Name one grammar, such as an etching, a museum, a risograph zine, an Escher print, a Kubrick corridor, a fashion film, a weather map or a theatre programme. Without one, the model falls back on the house style (lane C row 18).
2. **Medium or material.** Pick one, and commit to it (or, in a media reel, one per act). Options include light and plaster, ink lines, type, print, paper, glass, film grain or a projection.
3. **Palette roles.** Which colour is the brand blue's job? It is only ever the hero or the payoff. The ground is anything but the default blue-field lattice, unless the brief asks.
4. **Type system.** Brand words are set in Geist. Choose one accent treatment, which must not be the mask rise unless chosen on purpose. Options include stepped type at 12 to 15fps, a serif accent, type as image, painted type, or no type at all.
5. **Motion cadence.** Curves by role: ease-out `(0.23, 1, 0.32, 1)` to enter, `(0.77, 0, 0.175, 1)` to move on screen, linear for constant motion. Step the type and glide the world. Use springs only if the brief is playful.
6. **Camera grammar.** One continuous move, a locked tripod, a focus pull, a log-space dolly, or cuts. Not "always drifting" by default.
7. **Transitions.** Choose from hard cuts on the bar, a medium swap, match cuts, a page curl, or light passing. Not the flood-and-shrink by default.
8. **Ending device.** Pick from section 5, and never the same one as either of the last two films.
9. **Sound.** A kit and tempo not used in the last two films, plus sound that comes from the picture (foley for each medium, a brush on the paint). No crash, riser and boom unless the cut calls for it.

**Then check it against `style-log.md`.** At most 2 of the 9 fields may match any of the last 3 films. If more match, change the card, not the check.

## 3. The style deck (languages with working engines)

| Language | What it looks like | Engine |
|---|---|---|
| Gallery light | A raymarched sculpture of the exact mark in brand-blue pigment, a sun through a mullioned window, a soft haze shaft, a polished floor, ACES, grain, bloom | `reports/videos/media-reel-src/` (medium 0) |
| Engraving | Banknote-style hatching that follows each surface. The weight carries the tone, and cross-hatching appears only in shade. Contours come from the geometry | media reel, medium 1 |
| Type as image | The scene set in Geist Mono at 15fps. The sculpture is spelled in its own name, edges are `/ \ | -` | media reel, `cells` kernel and CoreText |
| Survey drawing | Iso-height slices on the object, rings of distance across the room, sienna and blue on map paper | media reel, medium 3 |
| Risograph | Two drums (blue form, pink sun), clustered dots at 15° and 75°, misregistration, 12fps | media reel, medium 4 |
| Infinity room | Mirror walls (after Kusama): an endless hall of blue marks fading into white | media reel, medium 5 |
| Anamorphic ending | The wordmark painted across wall, corner and floor, aligned only from the final camera (after Varini) | media reel, `paintAt` |
| Memory board | Her v1 forgetting board: blue boxes and a smooth grid reflow | `reports/videos/forgetting-v3-src/` (use when asked) |
| Vector console | Product UI rebuilt from the measured DOM at 4K | `engine/console-film/` |
| Glass mind | A glass head with a reaction-diffusion brain | `reports/videos/learner-teaser-v7-src/mind.swift` |

**Still to build:**
- editorial serif: Didot or Bodoni scale contrast, slow line-masked reveals on a long expo-out (lane C row 24);
- papercraft or stop-motion on twos;
- grainy monochrome with the colour held for the payoff;
- a print run (a thermal receipt, a letterpress proof);
- a projection-mapped room.

## 4. The brand guard (her Oct 15 note)

These stay constant in every language:

- **The mark** is always the exact vector: `markfield.swift` from `apps/docs/images/supermemory.svg`, or the official PNGs. It is never retraced or redrawn by hand. A sculpture of it, a print of it or its letters spelled in type are treatments of that exact shape.
- **Brand blue is the one hero colour.** In each medium it marks the mark, or the payoff.
- **Words:** lowercase "supermemory", set in Geist and Geist Mono. Any other face is a medium (an engraving label, a museum line), never the brand voice.
- **The official horizontal lockup** closes the film in an official colourway: blue on paper, paper on blue, ink on paper or paper on ink. Its geometry is mark 588x480, gap 230, wordmark 3182x381, wordmark top 99 below the mark top. The ending device changes; the lockup does not.
- **Claims** follow SKILL §2 and the live site line ("memory and continual learning for agents").

## 5. Ending devices (rotate them)

| Device | What happens | Used in |
|---|---|---|
| Mark pop and wordmark wipe | The classic house ending | mcp-upload to local v0.0.9 (retired as a default) |
| Anamorphic alignment | Paint on the architecture lines up with a 3D mark from one viewpoint | media reel v1 |
| Defocus under the lockup | The scene racks out of focus and the lockup sharpens over it | (lane C C63) |
| Return to frame 0 | The last frame is the first, so the film loops | (C50, C115) |
| A light reveal | A sun patch or projector slides onto a painted lockup | |
| The last print | A print run ends on the lockup sheet | |
| Type resolves | A field of glyphs settles into the wordmark | |
| Through the window | The camera finds the lockup outside, or in a reflection | |

## 6. Sound rotation

**Kits used so far:**
- 01 Hip Hop (Yearning 140, Longing 164, Full Moon 154, Regrets);
- 160 BPM code synth;
- the trap lane;
- 07 Chillwave Chill Melody at 100 BPM (media reel).

**Unused, with matched keys:** Icy Crystals (A minor), Kyoto Night (B minor), Dreamers (G minor), Ethereal Lounge (F minor), Brooklyn Nights (D minor) and Time Delay (Ab major), all at 100 BPM; Indie Disco kits at 125.

Read tempo and key with `research_notes/Motion mastery/lane-d-toolbox.md` §6.
