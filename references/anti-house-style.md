# Anti-house-style: every film gets its own visual language

**Her words, 2026-10-15:** "people can easily understand that you are making videos with opus 5.5 ... there's a watermark in every video that you make ... i dont want you to be generic at all, writing the text in the same way and same watermark ... please do anything to be the best at the game". Then: "also dont lose the supermemory branding in learning new stuff okay?"

**The rule:** the brand stays fixed. Everything else changes from film to film, on purpose, and is checked before any code is written.

**Research:** `~/personal-supermemory/research_notes/Motion mastery/`:
- lane A: AI tells and antidotes, with an evidence ledger;
- lane B: the studio craft atlas;
- lane C: her library, 163 techniques;
- lane D: this Mac's toolbox.

**Proof film:** `reports/videos/media-reel-src/`.

## 1. My watermark (what made the films recognisable)

### 1.1 It was a recipe, not one effect

The skill adopted all 12 signature moves of the most-bookmarked Claude motion prompts of Opus 5.5 launch week: @twoclipping's UI-morph prompt (1.16M views, 21K bookmarks) and his "Develop" film. @rossaxbt posted near-identical templates on Oct 3 and 4. Each film from learner to local used 8 to 10 of the 12 (lane A §1.1).

| # | Move | # | Move |
|---|---|---|---|
| 1 | One continuous take, each scene grown out of the last | 7 | A cursor that clicks and drags |
| 2 | Text rising from a mask line | 8 | A camera zoom on every moment, to fill the frame |
| 3 | Icons popping from zero on a spring | 9 | 4 subframes of motion blur at 60fps |
| 4 | A shape that floods past the corners, then shrinks into the next scene | 10 | SFX on measured peaks, -14 LUFS |
| 5 | Closed-form springs as a pure function of time | 11 | One still per beat, a pop scan |
| 6 | An event on every beat (120 BPM) | 12 | Edge springs that stretch shapes |

**The recipe-distance check:** count how many of the 12 a film's look uses. **Four at most.** Moves 10 and 11 are process, not look, but still count.

### 1.2 Anthropic names two of my defaults

The Opus 5.5 prompting guide (lane A, A-01) lists the model's fallback styles:
- numbered `01 / 02 / 03` section labels;
- monospace labels;
- cream or off-white grounds;
- italic accent words;
- pill buttons.

Every recent film opened with a mono `01 · SECTION` label. **These are banned by name** unless the film's anchor makes them part of its world, such as a ticket stub, a museum placard or a rubber stamp, in that anchor's own typographic idiom.

### 1.3 The shared numbers

**`lib.swift` is byte-identical** in learner v7, forgetting v3 and local v0.0.9. The films also share:
- one spring (2.4 Hz, damping 0.62);
- stock easing presets: `(0.2, 0, 0, 1)`, which is Material 3's standard, plus ease-out-quint and ease-in-out-cubic;
- the caption band at y 868;
- the letter rise (12ms a letter, 0.42s);
- the 160px + grid;
- 8-beat sections with the drop at beat 16;
- the mark-from-dots ending;
- the "01 Hip Hop" loops.

**Rule:** never copy a previous film's spring and easing constants. Derive them from the style card (§3, rule 5). Shared code is fine for drawing and encoding, never for feel.

### 1.4 The tells, by area

| Area | The tell |
|---|---|
| Type | Every statement rises letter by letter in Geist 500, ink 45% with key words in full ink, two lowercase lines in a band at y 868 |
| Labels | Mono `01 · SECTION`, big section numbers, a HUD with chapter progress |
| Ground | Blue 600 with a Bayer lattice; a + grid; `field.mp4` under a tint; paper and gold on blue |
| Motion | An overshoot spring on every arrival; scramble text; a Hermite camera that never rests; rings, punches, a drawn cursor |
| Rhythm | 8-beat sections at one even density (78 to 89% moving); something on every beat |
| Ending | Object, then the mark from dots, then a wordmark wipe, then the lockup and a still |
| Sound | Apple Loops "01 Hip Hop" at 140 to 164 BPM, or the 160 BPM code synth into a trap drop; crash, boom and rings at the turn |

**Geist and the Bayer dither are AI defaults now too.** Geist appears on lists of AI-default fonts, and a dither skill for agents has 1.3K installs (lane A). They stay for the mark and the payoff, as brand. They stop being the whole film's look.

## 2. Process: decide first, then name the bans

1. **Run the 90-day check.** List what the feed showed this month (her X timeline, the Claude motion galleries). Note the loudest trait, and plan the opposite (EPTA's method).
2. **Write the style card** (§3). Check it against `style-log.md`: **at most 2 of the 11 dimensions may match any of the last three films.** If more match, change the card, not the check.
3. **Write a 5-panel colour script** (Pixar's practice): the palette at five moments. At least one act sits in a different value key: near-black, paper or a mid-tone.
4. **Render the first still, then name its defaults:** labels, ground, type entrance, curve, camera, ending. Ban each one by name and render again. "Make it not look AI" doesn't work; named bans do (A-01).
5. **Run the recipe-distance check** (§1.1): four of the 12 at most.
6. **Run the logo-off test.** Hide the lockup and show a fresh critic subagent only the frames: "which defaults of AI-made motion do you see?" Anything it names in the first 3s gets changed.
7. **Budget time for the look.** The films that stand out took hours and several critique rounds: LexnLin about 8 hours, Aubry 5 versions, Jake Moran 5 prompt rounds.

## 3. The style card (11 dimensions)

Write it in the film's README before the first still. Each dimension below has its options, and what recent films used (so avoid those next).

| Dimension | Options | Used recently (avoid next) |
|---|---|---|
| **Concept or anchor (from outside tech)** | a physical machine; a museum or gallery; a print run (receipt, letterpress, riso); a weather map; a departure board; a lab specimen; a theatre programme; a field guide; a courtroom exhibit; a recipe card; an Apple keynote transplanted; a Bauhaus poster | memory board; a head with a brain; a morphing container; a vector console; a gallery (Klein blue, Varini, Kusama) |
| **Ground or surface** | paper with real texture; near-black; brand-tinted mid-tone; a 3D raymarched room; treated footage or photography; a printed sheet; a projection on a wall | blue 600 with lattice and grid; the field-film plate; the white gallery |
| **Type system** (brand words always in Geist) | Geist huge and cropped (6x scale contrast on one frame); one serif accent; pixel type grown from the lattice; type as image; stamped or stencil type; hand lettering; no type | Geist mask rise with mono labels; Geist Mono as image, and painted Geist |
| **Layout** | full-bleed single subject; an asymmetric editorial column; a split screen; a broken grid with the subject cropped by the frame; a diagram plate with leader lines | bottom band with HUD and + grid; the 16:9 explainer frame |
| **Colour strategy** (and the 5-panel script) | monochrome with blue held for the payoff; two-ink riso (blue plus one); a grade as the act break; paper and ink with a blue stamp; a night palette with one lit blue | paper on blue with gold; a blue sculpture on white with a riso act |
| **Camera** | a locked tripod with cuts; one log-space dolly; a rack focus between planes; handheld with inertia (0.3 to 0.6px at 4 to 8Hz); a top-down table shot; a slow turntable | Hermite drift with pushes, punches and whips; one continuous orbit and a pull-back |
| **Transition family** (one per film, never the same as the last film) | hard cuts on the bar; match cuts on shape; a medium swap; light passing; a page curl or physical reveal; ink bleed or a paper fold; a container morph (rested for now) | morph chains, flood and shrink, gather; medium swaps by a light sweep |
| **Texture** (one imperfection layer per film) | film grain at 2 to 4% luma held at 24fps; print misregistration of 1 to 3px; line boil at 8 to 12fps with 0.5 to 1.5px jitter; paper fibre; halftone on the subject only; lens falloff | machine-perfect dither everywhere; grain and bloom |
| **Rhythm and editing** | on twos with a smooth camera; long holds with one sharp event; irregular section lengths with a silence; rubato; a montage of 0.2 to 0.4s shots; a single take with only 3 events | 8-beat sections, an event on every beat; one bar per act at 100 BPM |
| **Sound palette** | recorded foley of the anchor's material; a solo instrument; room tone with one sting; ambient below 100 BPM; indie disco at 125; diegetic sound only; a human voiceover | "01 Hip Hop" at 140 to 164; Chillwave Chill Melody at 100 |
| **Ending** | see §5 | the mark from dots with a wordmark wipe; anamorphic alignment |

**Rotate freely:**
- **Hook:** a texture close-up, sound first, a question, mid-action, the result first.
- **Frame rate:** 60 smooth, 24 filmic, on twos, mixed.
- **Format:** 16:9, 4:5, 1:1, 9:16, 2.39:1.
- **Length band:** a loop of 10s or less, 15 to 25s, 45 to 60s.

## 4. The numeric rules (lane A §3.1)

**Hold now:**

| # | Rule |
|---|---|
| 1 | **Text events:** 6 at most in a 20s film; a per-letter stagger once per film at most. The default entrance is a hard cut on a beat, or a 4 to 8 frame ease-out with no rise. Exits are cuts |
| 2 | **No numbered or mono section labels**, unless they belong to the anchor's world (§1.2) |
| 3 | **One type placement per film:** on a surface in the world; one full-bleed word cropped by the frame; an editorial column; or no type. The bottom band is only for voiceover subtitles |
| 4 | **Scale contrast:** at least once, the largest type is 6x the smallest on the same frame. Add one accent treatment for one moment |
| 5 | **3 or 4 motion classes, each with its own curve.** No two classes share a curve, and no film reuses the last film's set. Exits accelerate and last about half the entrance |
| | - info and UI: a productive curve such as Carbon's `(0.2, 0, 0.38, 0.9)` at 110 to 240ms |
| | - hero objects: an expressive curve such as `(0.4, 0.14, 0.3, 1)` at 400 to 700ms |
| | - camera: its own long tail over 1.2s or more |
| | - type: stepped or cut |
| 6 | **Springs:** damping 1.0 (no overshoot) by default. Overshoot only for things thrown, dropped or released (damping 0.75 to 0.85), 2 per film at most. Light objects run at 3 to 4Hz, heavy ones at 1 to 1.5Hz. Type and UI never overshoot |
| 10 | **No two consecutive sections the same length.** At least one odd-length section (5, 7 or 11 beats) and one silence of 0.5s or more |
| 11 | **One impact event per film at most**, with a device new to the log. Silence, a cut to black or one recorded sound all count |
| 12 | **The ground never pulses to the music.** It reacts to 2 story events at most |
| 13 | **One scramble or typing effect per film at most.** Real typing follows the measured rhythm (136M keystrokes): 90 to 180ms a key, about 120ms for a fast typist, never under 60ms, plus about 200ms at spaces and a breath before the key word (lane B §1.10, M4; corrected Oct 16 from "40 to 120ms") |
| 14 | **The ending device differs from the last 2 films.** The mark never assembles from dots in consecutive films. The ending runs under 2.5s |
| 15 | **Rotate the hook.** Never the same hook type twice in a row |
| 16 | **The blue field, lattice and grid as the main ground:** in 1 of any 3 films at most, and for half that film's runtime at most |
| 18 | **One imperfection layer per film**, and at least half the key frames asymmetric |
| 19 | **Steps:** in at least 1 of every 3 films, animate the main elements on twos or threes with the camera on ones. Use smears or shifted copies instead of blur on stepped elements (Spider-Verse) |
| 20 | **Sound:** rotate the genre and tempo band (under 100, 100 to 130, over 130) so no two consecutive films share either. At least half the SFX come from the film's own material. No riser-then-crash at the same structural point in consecutive films |
| 22 | **A cursor only for an action that matters:** 3 clicks per film at most, no ripples |
| 23 | **Every number is measured and sourced, or labelled "example".** Prefer the precise figure to a round one |
| 24 | **Hero imagery is a brand asset**, real footage or photography, or drawn to a named style reference. 6 generic icons at most |
| 25 | **No closing line reused in consecutive films.** Vary the register: one word, a question, one sentence, or none |

**Options, not defaults:** these cut against things she asked for before. Asked on Oct 15, she said "dont do anything to the video it's not needed, i just wanted you to learn better skills", with no preference on the rules. So her earlier asks stay the baseline (lots of movement, one thing blending into the next). A style card may pick any of these when the film's language calls for it, and must say so in the README.

| # | Proposed rule | Her earlier ask |
|---|---|---|
| 7 | At least 30% of the runtime on a locked camera, one motivated move per section | #45: a camera that never rests |
| 8 | One transition family per film; the container morph rested for now | #43, #83, #90, #92: one thing blending into the next. The rule keeps the blending and only changes its kind |
| 9 | Uneven density: about 55 to 75% moving overall, with 2 or more deliberate holds of 0.8 to 1.5s | SKILL §1(d): 60%+ moving, no still over about 1s |
| 21 | Offer a human read for flagship films | #93: she chose Kokoro Bella for the console series |

## 5. Ending devices (rotate them)

| Device | What happens | Used in |
|---|---|---|
| Mark from dots and a wordmark wipe | The old house ending | mcp-upload to local v0.0.9 (retired as a default) |
| Anamorphic alignment | Paint on the architecture lines up with a 3D mark from one viewpoint | media reel v1 |
| Defocus under the lockup | The scene racks out of focus and the lockup sharpens over it | |
| Return to frame 0 | The film loops | |
| A light reveal | A sun patch or projector slides onto a painted lockup | |
| The last print | A print run ends on the lockup sheet | |
| Type resolves | A field of glyphs settles into the wordmark | |
| Through a window or reflection | The camera finds the lockup outside, or in a mirror | |
| A cut to black, then the lockup | Silence, then the card | |

## 6. The brand guard (her Oct 15 note)

These stay constant in every language:

- **The mark** is always the exact vector: `markfield.swift` from `apps/docs/images/supermemory.svg`, or the official PNGs. It is never retraced or redrawn by hand. A sculpture, a print or type spelling it out are treatments of that exact shape.
- **Brand blue is the one hero colour.** In each medium it marks the mark, or the payoff.
- **Words:** lowercase "supermemory", set in Geist and Geist Mono. Any other face is a medium, never the brand voice.
- **The official horizontal lockup** closes the film in an official colourway: blue on paper, paper on blue, ink on paper or paper on ink. Its geometry is mark 588x480, gap 230, wordmark 3182x381, wordmark top 99 below the mark top. The ending device changes; the lockup does not.
- **Her standing asks still hold:** lots of movement, one thing blending into the next, polish, readable on a phone, the real product. The rules above vary the form, never these.

## 7. The style deck (languages with working engines)

| Language | Engine |
|---|---|
| Gallery light: a raymarched blue-pigment sculpture of the exact mark, sun gobo, haze, polished floor, bloom | `engine/media-reel/` (medium 0) |
| Engraving: hatching follows each surface, line weight carries the tone, contours from the geometry | media reel, medium 1 |
| Type as image: the scene set in Geist Mono at 15fps | media reel, `cells` kernel |
| Survey drawing: iso-height slices, rings of distance | media reel, medium 3 |
| Risograph: two drums, clustered dots, misregistration, 12fps | media reel, medium 4 |
| Infinity mirror room | media reel, medium 5 |
| Anamorphic ending | media reel, `paintAt` |
| Memory board | `reports/videos/forgetting-v3-src/` (only when asked) |
| Vector console | `engine/console-film/` |
| Glass mind | `reports/videos/learner-teaser-v7-src/mind.swift` |

**Still to build:**
- editorial serif: slow line masks, 6x scale contrast;
- papercraft or stop-motion on twos with smears;
- grainy monochrome with blue held for the payoff;
- a print run;
- a projection-mapped room;
- focus pulls with real depth of field.

## 8. Studios to learn from (lane A §3.4)

- **DIA Studio:** motion rules and tools per brand; rhythm from the music.
- **Universal Everything:** AI as one stage in a directed pipeline.
- **Figma's Config 2026 identity:** imperfection on purpose.
- **Jake Moran:** paper props, 12fps over a smooth camera.
- **Raphaël Aubry:** a famous grammar transplanted.
- **3Blue1Brown:** the motion is the mechanism.
- **Zach Lieberman:** seeded randomness, nothing in lockstep.
- **Spider-Verse:** twos, smears, print colour.
- **EPTA:** flip the feed's loudest trait.
- **Tim Rodenbröker:** one generative system per piece.

## 9. Sound rotation

**Used so far:**
- 01 Hip Hop (Yearning 140, Longing 164, Full Moon 154, Regrets);
- the 160 BPM code synth;
- the trap lane;
- 07 Chillwave Chill Melody at 100 BPM (media reel).

**Unused, with matched keys:**
- Icy Crystals (A minor), Kyoto Night (B minor), Dreamers (G minor), Ethereal Lounge (F minor), Brooklyn Nights (D minor) and Time Delay (Ab major), all at 100 BPM;
- Indie Disco kits at 125.

Read tempo and key with lane D §6. **Rest the "01 Hip Hop" pack for 3 films.**
