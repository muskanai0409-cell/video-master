# Lane B: a craft atlas of world-class motion design (2026-10-15)

Contract: `00_contract.md`. Question for this lane: what do the best studios, title designers, product teams and creative coders actually do, and with which numbers, so a Swift renderer (CoreGraphics, CoreImage, optional Metal, every frame a pure function of `t`) can do it too?

**How to read an entry.** Every technique has seven parts: what it looks like, why it works, when to use it and when not, parameters, where it is seen (a URL), how to build it, and two tags.

- **Status tag.** `new` = not in `motion-grammar.md`, `motion-systems.md`, the media reel or the anti-house rules. `extends` = exists in a narrower form (the entry says what it adds). `exists` = already built or already a rule; listed so the atlas is complete, kept short.
- **Brand tag.** `ok` = fits the supermemory surface as it stands. `card` = allowed when a film's style card calls for it and it is physical and crafted (anti-house-style §1 and SKILL line on real light). `banned` = on the motion-grammar §6 or SKILL ban list for the supermemory surface; listed for other films.
- **Numbers.** A number with a source tag such as `[S3]` comes from that source (ledger in section 12); `lead` marks a source known only from a search summary or a secondary write-up. A number marked "start at" is my craft default, to tune by eye. Numbers I computed are marked "my arithmetic".
- **Purity.** Anything that needs a simulation (physics, fluids, flocks, datamosh) is simulated once, deterministically (fixed step, seeded random), cached, and then sampled by `render(t)`. That keeps stills, contact sheets and subframes safe.

---

## 0. The short version

1. **The premium end of the industry is moving away from "smooth".** Figma cut its Config 2025 opening film from 60 to 15fps so it would feel handmade [S47]. Vercel Ship 2025's opener was animated by hand, pose by pose, on twos, with no templates [S48]. Spider-Verse replaced motion blur with drawn smears and used misprinted colour plates instead of focus blur [S49]. Perfectly smooth 60fps everything, with blur on every move, is now a machine tell.
2. **Restraint is the thread through the title canon.** Saul Bass limited Psycho to on/off, left/right, up/down and black/white [S40]. Stranger Things is type alone; its creative director, Michelle Dougherty, says simple is "sometimes the hardest" [S38]. Panic Room's team refused a CG fly-through because a virtual camera move signals a visual effect [S42].
3. **Motion systems publish their numbers.** Material (16 duration tokens from 50 to 1000ms, springs as damping ratio plus stiffness) [S1, S2], IBM Carbon (productive vs expressive curves, 70 to 700ms) [S3] and Apple (springs set by duration and bounce) [S4] give role curves that are not the same as the house curves. Use them as named sets, a different set per film (anti-house rule 5).
4. **Typing has measured rhythm.** 136M keystrokes: average inter-key interval 239ms (SD 112), a floor near 60ms, fast typists about 120ms with SD 11ms [S54]. The anti-house rule 13 figure of "40 to 120ms a key" is faster than the measured average, and its low end sits below the floor. Use the measured distribution (1.10).
5. **Texture has published physics.** AV1's film grain model (autoregressive noise scaled by intensity) [S23] and a 2026 film-emulation paper (3 grain octaves weighted 50/33/17%, halation radii R 1.4, G 1.0, B 0.7 of a base radius, strength capped at 0.5) [S24] give real parameters. Physically based bloom mixes at 0.03 to 0.15 [S27]. A pro colorist dials grain down to about 30% opacity, "felt rather than seen" [S25].
6. **Variable type works on this Mac with no installs.** Geist and Geist Mono are variable fonts (weight 100 to 900). Geist Mono keeps the same advance at every weight; Geist's "supermemory" grows 17% wider from weight 100 to 900 (measured this run) [S79]. Weight animation is ready, with one layout rule (1.1).
7. **CoreImage already has the hard primitives** (checked this run): `CIMaskedVariableBlur` (tilt-shift and focus), `CIPageCurlWithShadowTransition`, `CIAccordionFoldTransition`, `CIColorMap` (gradient maps), `CIPalettize`, `CISignedDistanceGradientFromRedMask` (a distance field from any mask), `CIKMeans`, the line, dot, hatched and CMYK screens [S79].
8. **Sound may trail the picture a little but must never lead it.** The broadcast detectability window is about 45ms early to 125ms late [S58]. Keep each sound 0 to 2 frames after its picture.
9. **Hooks.** Google's ABCD research says open mid-action or on a close-up, with bold sound and high-contrast images, and work the brand into the story (product shots, in-situ branding) [S60]. Research Facebook cited (by Fors Marsh Group) found recall after 0.25s of exposure, and in Facebook's own test only 24% of 965 ads made sense with the sound off [S61].
10. **Section 11 has 25 signature moves,** each a complete spec (timing, curves, parameters, sound, build, brand rule), meant to be dropped into a style card.

**Count:** 118 techniques in sections 1 to 10 (69 `new`, 28 `extends`, 21 `exists`), plus 25 signature moves and 2 spares.

---

## 1. Kinetic typography

### 1.1 Variable-axis weight wave
- **Looks like:** a line of type whose stroke weight rolls through the glyphs like a wave, while the letters stay exactly where they are. The wave can come to rest heavy on one word.
- **Why it works:** weight is a channel of emphasis that does not move the reading position, so the eye registers stress without losing its place. Motion in weight reads as breath, not travel.
- **Use / avoid:** use for the one stressed word, or a slow tide under a held statement. Avoid on body text, and never let widths reflow (letters sliding sideways as weight changes is the cheap version).
- **Parameters:** start at weight 300 to 800 (Geist range 100 to 900 [S79]); period 1.2 to 2.0s; phase 50 to 80ms per glyph; profile a raised cosine 3 to 5 glyphs wide; amplitude eases in over 400ms; resting emphasis 700 to 800 against 350 to 400 for the rest.
- **Seen in:** Studio Dumbar's DEMO identity, a variable face that a script reshapes for each word, legible throughout [S50b]. &Form's Tokyo Dome City face swings from hairline to expanded on width and height axes [lead, It's Nice That via search].
- **Build:** CoreText variation: `CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute: [0x77676874: w]])` then `CTFontCreateCopyWithAttributes`. Cache fonts by weight rounded to steps of 5. Geist Mono keeps a fixed 0.6em advance at every weight [S79], so animate it freely. For Geist, lay the line out once at the resting weight, then draw each glyph centred in its fixed slot at its own weight. `w_i(t) = w0 + A·env(t)·raisedcos((t − i·phase) mod period)`.
- **Also on this Mac:** SF Pro has a `GRAD` axis (400 to 1000) that thickens strokes without changing width, and New York has optical size 12 to 256 [S79]. Both are Apple fonts licensed for Apple UI work, so check the licence before using them in a published film.
- **Tags:** `new` · `ok`

### 1.2 Per-glyph physics
- **Looks like:** letters fall, collide, stack, get knocked or tugged like small physical objects, then settle into the word.
- **Why it works:** physics gives every glyph its own timing for free (overlap, follow-through), and the settle reads as weight. The type becomes a participant in the scene.
- **Use / avoid:** playful or tactile beats, a word assembling from a pile; once per film (anti-house rule 1 allows one per-letter stagger). Avoid for serious claims and for the brand word in a formal film.
- **Parameters:** start at gravity 2400px/s² at 1080 (reads like a dropped card); restitution 0.15 to 0.3; friction 0.6; angular velocity damped hard so glyphs tilt 8° at most on impact; everything settled within 0.8 to 1.2s; the final seek to the readable layout is a critically damped spring (damping 1.0) at 3 to 4Hz, the rate anti-house rule 6 gives light objects.
- **Seen in:** Zombieland's titles, where the type was designed to "become another character", built in 3D and lit to match each shot [S44].
- **Build:** simulate once at load with a fixed 1/240s step and a seeded random source; store each glyph's x, y and angle per step; `render(t)` interpolates the two nearest samples. Collision shapes: glyph bounding boxes from `CTFontGetBoundingRectsForGlyphs`, or a glyph distance field from `CISignedDistanceGradientFromRedMask` for contact against curved letters. Steer with invisible "director" forces (a paddle, a magnet) rather than random starting states, so the result is designed.
- **Tags:** `new` · `card`

### 1.3 Type as a window
- **Looks like:** huge, heavy letters act as cut-outs; the next scene, the product or a texture plays inside them; then the letters grow until the window becomes the whole frame.
- **Why it works:** word and image carry meaning together, and the growth is a built-in transition: the word opens into what it names.
- **Use / avoid:** title reveals and chapter openers where the word names what is inside. Avoid thin weights (the window gets too narrow) and busy footage (letter edges disappear).
- **Parameters:** start at weight 800 or heavier; letters 60 to 120% of frame height; the content inside starts at 1.15 to 1.3x scale and settles to 1.0 as the letters grow (the counter-scale gives depth); growth 600 to 900ms on an expressive curve such as Carbon's `(0.4, 0.14, 0.3, 1)` [S3]; grow about the counter of one letter (the bowl of an "o") so the camera seems to enter through it.
- **Seen in:** Stranger Things makes large hollow letters the whole image [S38]. No verified film reference for the window variant was opened this run.
- **Build:** render scene B as a `CIImage`; glyph outlines from `CTFontCreatePathForGlyph`, filled into a mask at frame size; `CIBlendWithMask(B over A)`. Scale the path about the chosen counter's centre.
- **Tags:** `new` · `ok`

### 1.4 Macro glyph slides (extreme scale)
- **Looks like:** letters at 3 to 8 times the frame height drift slowly; only fragments are visible (a bowl, a terminal); they slide together and lock into the readable word at the end.
- **Why it works:** at macro scale letters become abstract shapes, which makes a mystery; the lock is a satisfying resolution; slow constant drift reads as cinema rather than interface.
- **Use / avoid:** openers and teasers, once per film. Avoid when the word must be read in the first second.
- **Parameters:** start at drift 1.5 to 4% of frame width per second, linear, with only the last 12 to 20 frames on an ease-out into the lock; 4 to 8s in all; the final word 40 to 70% of frame width; a rim stroke of 2 to 4px at 1080. Stranger Things moved from an early "locking in" style to a smoother slide because the first felt too rigid for its period [S38].
- **Seen in:** Stranger Things (Imaginary Forces), ITC Benguiat drifting through a void, red at the edges, scanned 35mm grain [S38].
- **Build:** glyph paths from `CTFontCreatePathForGlyph`, transformed by large scale and a translation keyed to `t`; final positions come from the laid-out `CTLine`; before the lock `x_i(t) = final_i + v_i·(T_lock − t)`, then the ease. Grain over the top (5.1).
- **Tags:** `new` · `ok` (a rim light on type is a style choice; never a glow on the mark)

### 1.5 Grid choreography
- **Looks like:** hairline grid lines sweep in; text blocks ride the lines, rising and falling as if tethered; then the grid becomes something real (windows of a building, rows of a table).
- **Why it works:** a grid promises order, so motion constrained to it reads as designed; the grid can match-dissolve into a real structure.
- **Use / avoid:** data, schedules, lists, Swiss editorial films. Avoid with fewer than three blocks, and do not fall back on the brand lattice with + marks (anti-house rule 16).
- **Parameters:** start at 6 to 12 columns; each line draws in 400 to 700ms, 60 to 90ms apart; blocks move on one axis at a time, 300 to 500ms on a productive curve such as `(0.2, 0, 0.38, 0.9)` [S3]; never diagonal.
- **Seen in:** North by Northwest (Saul Bass): intersecting lines confine the title blocks, which rise and fall "as though tethered", then the grid fades into the glass facade of a Manhattan building whose windows line up with it [S41].
- **Build:** grid lines in world space; each block snaps between intersections along one axis; for the match, solve a homography from four grid points to the facade's window corners and dissolve the 2D grid into the plate.
- **Tags:** `new` · `ok`

### 1.6 Text on a meaningful path
- **Looks like:** a line of text travels along a curve (a route between two apps, an orbit, a timeline), each glyph turned to the path's direction.
- **Why it works:** the path is the idea (where data goes, how time passes), and the reader's eye follows the type along it.
- **Use / avoid:** only when the path means something. Avoid the rotating circular badge: curved and path text are sold as stock website components (several Framer marketplace listings came up in search), so it reads as template. Avoid tight curves (glyphs collide on the inside).
- **Parameters:** start at a minimum radius of curvature of twice the cap height; tracking +2 to +6% where the path is concave; constant speed of 60 to 160px/s at 1080; fade glyphs inside the last 4% of the path.
- **Seen in:** the template versions in search results only (Framer marketplace). No film reference was verified this run.
- **Build:** sample the Bézier path into 1,024 points with cumulative arc length; each glyph's midpoint sits at `s_i = s0(t) + x_i`; position `P(s_i)`, angle `atan2(P'(s_i))`; draw each glyph path with that transform. Pure in `t`.
- **Tags:** `new` · `ok`

### 1.7 Bar and slice reveals
- **Looks like:** thin bars sweep across the frame and carry the type in and out, or slice it into offset bands; every move is on or off, left or right, up or down.
- **Why it works:** a tiny vocabulary makes graphic tension; edges and directions do all the work.
- **Use / avoid:** tense, rhythmic, music-led openers; data headlines. Avoid in soft or organic films, and never mix in diagonal or random directions.
- **Parameters:** start at bars 0.5 to 3% of frame height; bar speed 1 to 2 frame widths per second; slices offset 2 to 12% of glyph height; each move on a beat; two directions per film at most.
- **Seen in:** Psycho (Saul Bass): thin white bars bring the titles in and out and never cross; Bass restricts himself to on/off, left/right, up/down and black/white [S40].
- **Build:** bars are rects; the type is clipped to the union of the swept bar areas; slices draw the type N times, each clipped to a horizontal band and shifted by `dx_k(t)`.
- **Tags:** `new` · `ok`

### 1.8 Outline to fill
- **Looks like:** the word draws itself as an outline, holds a beat, then fills (from one edge, or flooding outward from inside each letter).
- **Why it works:** it shows construction, then commitment. The hollow state is light and invites reading; the fill lands the decision.
- **Use / avoid:** naming moments, product names. Never on the supermemory mark, which is never assembled from pieces (brand guard). Avoid strokes under 2px at 1080 on phone cuts.
- **Parameters:** start at stroke 1.5 to 3px at 1080 (scale with size); outline draw 500 to 900ms per word, glyphs 30 to 50ms apart; hold one beat; fill 200 to 350ms ease-out.
- **Seen in:** Stranger Things uses hollow letters as its whole look [S38].
- **Build:** stroke draw by dash phase (`setLineDash` with the path length L and phase `L·(1 − p)`). Fill by distance field: compute the glyph's distance field once (`CISignedDistanceGradientFromRedMask` on the glyph mask, or the engine's EDT), then fill where `d < threshold(t)` sweeping from the deepest point to the edge.
- **Tags:** `new` · `ok` (words only)

### 1.9 Echo and stack type
- **Looks like:** a word repeated as a stack of outlined or fading copies offset in space or in time, like an echo, which then collapse into the solid word.
- **Why it works:** repetition is emphasis and rhythm; time-offset copies show the path of a move as type rather than as blur.
- **Use / avoid:** one key word (a verb), or a chant-like phrase on the beat. Avoid long words and more than 8 copies.
- **Parameters:** start at 4 to 8 copies; each copy 2 to 4 frames behind (or 4 to 10% of the cap height apart); copy n at opacity 0.5^n or outline only; collapse in 300 to 450ms on a beat.
- **Seen in:** Spider-Verse replaced blur with repeated, stepped images that read as blur but stay sharper [S49], the moving version of this device.
- **Build:** draw the word at `p(t − k·δ)` for k = 0 to N with a style per k. Pure, because `p` is a pure function.
- **Tags:** `new` · `ok`

### 1.10 Typing like a person
- **Looks like:** characters appear in uneven bursts: quick inside words, small pauses at spaces, a longer pause before the key word, one correction. The caret stays solid while typing and blinks only when idle.
- **Why it works:** people never type at a constant interval, and the eye spots metronomic typing as fake. The pause before the key word builds anticipation.
- **Use / avoid:** prompts, commands, chat inputs. One typing or scramble effect per film (anti-house rule 13).
- **Parameters (measured):** average inter-key interval 239ms (SD 112) with a floor near 60ms; fast typists about 120ms with SD 11ms; slow typists over 480ms; a key is held about 116ms; on average 25% of keystrokes overlap the previous key, about 50% for fast typists [S54]. Older studies cited there: pairs typed by alternating hands are 30 to 60ms faster than same-hand pairs [S54]. **Start at** a fast typist: mean 130ms, SD 25ms inside words, +150 to 300ms at word breaks, +400 to 700ms before the key word, one backspace correction per 40 or so characters. Caret: blink half-period 500 to 530ms (a user setting; wxWidgets uses 500ms "for Windows compatibility", and one secondary source reports a Windows default of 530) [lead S-caret]; solid while typing; resume blinking 500ms after the last key.
- **Correction:** anti-house rule 13 says "40 to 120ms a key". The whole band is faster than the measured average, and its low end sits below the measured floor of about 60ms. Use 90 to 180ms with word-break pauses, unless the input is meant to look pasted or machine-fast.
- **Seen in:** the CHI 2018 study of 168,000 typists [S54].
- **Build:** at load, draw keystroke times from a seeded random source (lognormal intervals, a hand-alternation bonus, word-break pauses) into an array. `text(t)` = every character whose time is at or before `t`. Caret visible = typing within the last 500ms, or `fract((t − lastKey)/1.06) < 0.5`. Each key sound sits 1 to 2 frames after its glyph appears.
- **Tags:** `extends` (typing exists; the rhythm model is new) · `ok`

### 1.11 Rolling digits with a trend
- **Looks like:** each digit is a column that spins to its new value, upward when the number rises and downward when it falls; the column edges fade through a soft mask.
- **Why it works:** direction carries meaning (up means more); separate columns let the eye follow the change without flicker; tabular figures stop sideways jitter.
- **Use / avoid:** a real, sourced number changing from A to B (anti-house rule 23). Avoid counting up from zero, which lane C lists as a template tell, and avoid unsourced figures.
- **Parameters:** NumberFlow's examples spin and move in 750ms and fade in 350ms ease-out; its edge masks are 0.25em top and bottom and 0.5em at the sides; direction is the sign of new minus old; a continuous mode passes through the in-between values; tabular figures [S55]. Start at 600 to 800ms per change, with the units column landing first and the others 40ms apart.
- **Seen in:** NumberFlow by Maxwell Barvian [S55].
- **Build:** for continuous mode, interpolate the value `N(t)` and give each column its own fractional strip offset (`N / 10^i` with its fractional part driving the column). Draw a strip of 0 to 9 in Geist Mono (or Geist with tabular figures), clipped by a box with a linear alpha mask. Pure in `t`.
- **Tags:** `extends` (counters exist) · `ok`

### 1.12 Editorial hierarchy (serif display, grotesk text, few sizes)
- **Looks like:** a magazine spread in motion: a large serif headline, a small grotesk line under it, a hairline rule, lots of air, slow masked reveals on a grid.
- **Why it works:** editorial layouts read as authored by people; few sizes with strong contrast give instant hierarchy. Lane C found serif the biggest missing register in her films.
- **Use / avoid:** manifestos, research, letters, statements. Avoid in dense UI demos.
- **Parameters:** two or three sizes on a frame; commentary on the Vignelli Canon reports a headline about twice the body size and few sizes per layout [lead S76], while anti-house rule 4 asks for one 6x contrast per film; line length 45 to 75 characters; display leading 1.05 to 1.15, text 1.35 to 1.5; reveals as a line mask on a long expo-out (lane C row 24) of 700 to 1,100ms; one serif accent word per frame.
- **Seen in:** commentary on The Vignelli Canon (white space as the layout's silence) [lead S76]; Paula Scher's Public Theater identity (wood type, clashing faces, scale) [lead S75].
- **Build:** `CTFramesetter` into a column. Serifs bundled with this Mac: Didot, Bodoni 72, Baskerville, Hoefler Text, Iowan Old Style, Charter, Cochin, Palatino, Georgia, Times New Roman, and the variable New York (checked this run). Confirm each licence before a published film; brand words stay in Geist.
- **Tags:** `new` (listed under "still to build" in anti-house-style) · `ok` as a medium

### 1.13 Fewer words: a reading-time budget
- **Looks like:** each card carries one idea in 2 to 6 words, and nothing needs a second read.
- **Why it works:** motion competes with reading. A viewer who is also tracking movement reads fewer characters per second than a subtitle reader.
- **Use / avoid:** always.
- **Parameters:** Netflix caps adult subtitles at 20 characters per second and 42 characters per line [S56]. Start at a hold of at least `0.4s + characters/15` seconds (slower than the subtitle cap because the picture moves too); at most 6 text events in a 20s film (anti-house rule 1); one claim per card; cut adjectives; swap a claim for a number or a demonstration. Apple's iPod headline packs a number and a container into one line: "1,000 Songs in Your Pocket" [S62].
- **Seen in:** the iPod launch release [S62].
- **Build:** a timeline lint: for every text event, count characters and check the hold; fail on too-short holds, more than 6 events per 20s, or two statements on one frame.
- **Tags:** `new` as a numeric rule · `ok`

### 1.14 Retinal strobe type (one burst)
- **Looks like:** words flash at the edge of readability, each in a different typeface, cut to the music, for a second or two.
- **Why it works:** it plays with persistence of vision and turns type into rhythm and colour; it contrasts with the calm sections around it.
- **Use / avoid:** 1 to 2s in a music-led film, for words that do not need reading (thirty integration names as texture). Avoid anything that must be read, and anything that breaks the flash limit.
- **Parameters:** a new face every 2 to 4 frames at 60fps, at a constant lightness so the frame does not flash. WCAG 2.3.1 allows no more than three general flashes a second unless the flashing area is small (about 25% of a 10° field, roughly 341x256px at 1024x768) [S57]; keep large luminance flips to 3 a second or fewer.
- **Seen in:** Enter the Void (Tom Kan): each credit in its own face, the succession tuned to LFO's "Freak", exploring "retinal persistence and the limits of readability" [S43].
- **Build:** pick the face from a list by frame-group index (deterministic); fixed baseline and centre; colours chosen at the same OKLab lightness (6.4).
- **Tags:** `new` · `card`

### 1.15 Type anchored in the world, with a locked camera
- **Looks like:** words exist as objects in the scene (painted on a wall, standing on a roof), lit by the scene's light, casting shadows and reflections, seen through mostly static shots.
- **Why it works:** type that obeys the scene's light is believable. Static shots and cuts read as filmed; a sweeping virtual camera reads as an effect.
- **Use / avoid:** 3D and media-reel films. Avoid a CG fly-through around the type.
- **Parameters:** match the key light's direction and softness; shots of 2 to 4s, locked or with at most 1% drift; cut on the beat.
- **Seen in:** Panic Room: 3D titles placed over Manhattan plates, Copperplate chosen because it bevels well and reads at odd angles; long, mostly static shots and cuts, because a virtual camera move would have signalled a visual effect [S42].
- **Build:** in the Metal raymarcher, extrude a glyph's distance field the way `markfield.swift` extrudes the mark; or project 2D type onto a plane with a homography and add a shadow pass (offset, blurred, multiplied).
- **Tags:** `extends` (the media reel paints the wordmark on walls) · `ok`

---

## 2. Transitions

### 2.1 Graphic match cut (shape)
- **Looks like:** a hard cut where the main shape keeps its position, size and orientation while its meaning changes completely (a thrown bone becomes an orbiting satellite).
- **Why it works:** the viewer's point of fixation does not move, so the cut is nearly invisible to the eye while the idea jumps. It makes a metaphor without words.
- **Use / avoid:** linking problem to product, old to new; the best single cut in a film. Avoid near-misses: a shape that almost matches looks like a mistake.
- **Parameters:** start at the matched element within ±5% of position and ±10% of size across the cut; same orientation; cut while the element is moving at mid-speed, not at rest; if it moves, keep direction and speed within ±15%.
- **Seen in:** 2001: A Space Odyssey, bone to satellite; a graphic match links shots by shape, colour or movement [S64].
- **Build:** at the cut frame, read the outgoing element's screen rect and place the incoming element exactly there. In a seam table (motion-grammar §5) this is a seam whose survivor changes identity.
- **Tags:** `new` · `ok`

### 2.2 Motion match across a cut
- **Looks like:** one object leaves frame right at speed; in the next shot a different object enters from the left at the same speed and direction.
- **Why it works:** continuity of movement carries the eye over the cut, so two shots read as one gesture.
- **Use / avoid:** montages and product chains. Avoid flipping screen direction by accident.
- **Parameters:** start at screen velocity matched within ±15%; cut when the leading edge is 10 to 30% past the frame edge; the same shutter on both sides so the blur matches.
- **Seen in:** Murch's "Rule of Six" for the ideal cut: emotion, story, rhythm, eye-trace, the 2D plane of the screen and 3D space, weighted 51, 23, 10, 7, 5 and 4% [lead S63].
- **Build:** each shot stores an exit velocity; solve the incoming start so `p_in(t_cut) = p_out(t_cut) + v·Δt`.
- **Tags:** `new` · `ok`

### 2.3 Colour or light match
- **Looks like:** a cut where the dominant colour field or light shape carries over (a blue screen becomes a blue sky; a desk lamp becomes the sun).
- **Why it works:** large colour fields register before shapes, so continuity of the field hides the change of content.
- **Use / avoid:** chapter changes and grade changes. Avoid matching hue without matching lightness, which jumps.
- **Parameters:** start at the dominant region's OKLab lightness within ±0.05 and hue within ±10° across the cut, and its area within ±20% (OKLab in 6.4) [S69].
- **Seen in:** no film reference verified this run.
- **Build:** measure mean OKLab of the region on both sides; grade the incoming shot to match for 6 to 12 frames, then ease to its own grade.
- **Tags:** `new` · `ok`

### 2.4 Cut on action
- **Looks like:** the cut lands inside a movement (a card starts to flip, a hand starts to turn) and the movement finishes in the next shot.
- **Why it works:** attention follows the action, so the edit goes unnoticed.
- **Use / avoid:** every cut between two views of one action. A cut at rest is a deliberate punctuation, not the default.
- **Parameters:** start at the cut 25 to 40% into the action, with 1 to 3 frames of the action repeated across the cut.
- **Seen in:** Murch's criteria (rhythm and eye-trace) [lead S63].
- **Build:** author each action with a normalised progress; cut at 0.3; the incoming view starts at 0.28.
- **Tags:** `new` · `ok`

### 2.5 J and L cuts
- **Looks like (sounds like):** the next scene's sound starts before its picture (J), or the last scene's sound runs over the new picture (L).
- **Why it works:** sound prepares the eye and smooths the seam.
- **Use / avoid:** every scene change in a voiced film; into a reveal (hear it before you see it). Avoid when on-camera lips must sync.
- **Parameters:** start at a J lead of 6 to 24 frames at 60fps (100 to 400ms); L tails of 200 to 600ms with a 150ms fade.
- **Seen in:** split edits, J and L [S65].
- **Build:** each scene's audio starts at `t_cut − lead`.
- **Tags:** `new` · `ok`

### 2.6 A bespoke aperture (distance-field wipe)
- **Looks like:** the next scene opens through a shape that belongs to the film (a chat bubble, a chip, a letter's counter), never a stock circle or star.
- **Why it works:** the shape carries meaning, and growing it by a distance threshold keeps a perfect edge at any size.
- **Use / avoid:** chapter changes where the shape is the subject. Never use the supermemory mark as an aperture (brand guard), and never a stock iris (banned stock wipes).
- **Parameters:** grow until the shape covers the farthest corner plus 5% (motion-grammar §3.1); 450 to 700ms; ease in over the first 30%, then an expressive ease out; a 1 to 2px antialiased edge; an optional dark rim of 2 to 6px.
- **Seen in:** Inigo Quilez's catalogue of 2D distance functions (40+ shapes) [S11].
- **Build:** Metal: `d = sdShape((p − c)/s)·s`; mask = `smoothstep(px, −px, d − r(t))`; composite. Or rasterise a `CGPath` scaled by `r(t)` as a `CIImage` mask.
- **Tags:** `extends` (flood and shrink uses a square) · `ok`

### 2.7 Distance-field morph (shape A becomes shape B)
- **Looks like:** one shape melts into a different shape (a chip into a bar, a circle into a rounded square, a glyph into an icon) with a clean outline on every frame.
- **Why it works:** mixing two distance fields always gives a closed, smooth outline, so there are no vertex-matching glitches.
- **Use / avoid:** container morphs between different topologies. Avoid shapes with thin parts (they pinch) and any morph of the mark.
- **Parameters:** `d(p, t) = mix(dA(p), dB(p), e(t))` with `e` on an expressive curve over 400 to 700ms; if the shapes do not overlap, add a smooth-union bridge mid-way (k = 8 to 24px); keep the two areas within 2x of each other or scale-compensate.
- **Seen in:** Config 2024's identity, where hovering the logo morphs each letterform into a primitive shape and "Transform: morphing shapes" is one of four motion principles [S46]; Quilez's operators [S11].
- **Build:** distance fields for glyphs and icons computed once from masks at 2x (the engine's EDT); mix per pixel in Metal; the outline is `|d| < w`.
- **Tags:** `extends` (state morphs exist; field interpolation is new) · `ok`

### 2.8 Infinite zoom and Droste recursion
- **Looks like:** the camera zooms forever into a picture that contains itself, at a constant felt speed; or the last frame contains the first, and the film loops by diving into it.
- **Why it works:** exponential scale change feels like constant speed; self-similarity is uncanny and memorable; a perfect loop rewards rewatching.
- **Use / avoid:** loops, "memory inside memory", endings. Avoid `CIDroste` on a frame without a real inset: lane D found it reads as a generic tunnel filter.
- **Parameters:** scale `s(t) = k^(t/T)` with k the inset ratio (start at 6 to 10) and T = 2 to 6s per level; zoom centre fixed on the inset. Powers of Ten pulled out at one power of ten every 10 seconds and dived back at one every 2 seconds [S36]. Escher's Print Gallery, idealised, contains a copy of itself turned about 157.6° and shrunk about 22.58 times [lead S37].
- **Seen in:** Powers of Ten (Eames, 1977) [S36]; the de Smit and Lenstra study of Escher's Print Gallery [lead S37].
- **Build:** draw level `L = floor(t/T)` at scale `k^fract(t/T)` and the nested copy inside its inset at that scale divided by k (and the next level inside that); no feedback buffers, so it stays pure. For Escher's spiral, use `CIDroste` with its inset set to the real frame in the picture.
- **Tags:** `extends` (the media reel has a log-space pull-back) · `ok`

### 2.9 Whip pan with directional blur
- **Looks like:** the camera snaps sideways so fast the frame smears into streaks, then lands on a new scene.
- **Why it works:** the cut hides inside the blur, and the move says the two places are next to each other.
- **Use / avoid:** once or twice in an energetic film. Avoid in calm films and on stepped animation (Spider-Verse used blocky smears for fast pans instead of blur) [S49].
- **Parameters:** start at 6 to 10 frames at 60fps (100 to 170ms); peak speed 3 to 6 frame widths per second; blur length = speed × shutter (half a frame's travel at 180°); cut at the peak; ease in with `(0.5, 0, 1, 1)`, land with a slight overshoot (damping 0.8).
- **Seen in:** her learner v7 film used a whip with shake at the drop (lessons #79); a whip scroll with blur in her studied films (video-study §5).
- **Build:** the 4-subframe blur is too few at whip speed; use `CIMotionBlur` on each layer with radius proportional to speed, or 16+ subframes for the two peak frames only.
- **Tags:** `extends` · `card`

### 2.10 Light handover (an exposure burn, not a white flash)
- **Looks like:** light floods the frame the way an overexposed film frame does (highlights clip first, then mid-tones), the cut happens at the peak, and exposure falls into the new scene.
- **Why it works:** a physical light event bridges the scenes, and highlight-first roll-off looks photographic, where a flat fade to white looks like a template.
- **Use / avoid:** a reveal or chapter change, once per film. Avoid the flat white flash (banned) and more than three large flashes a second [S57].
- **Parameters:** start at +2 to +3 stops over 6 to 10 frames through a filmic curve; peak lightness 0.95 at most, never pure white; 1 to 2 frames at the peak; decay over 10 to 18 frames; a warm tint toward (1.0, 0.92, 0.82) at the peak; halation rising with it (5.2).
- **Seen in:** the media reel's light-sweep handovers (lane D, media-reel README).
- **Build:** in linear light `c' = c·2^EV(t)`, then the tone curve; swap scenes under the peak.
- **Tags:** `extends` · `card`

### 2.11 Shared-axis push
- **Looks like:** outgoing content slides a short way and fades while incoming content slides in from the same direction; or a z version where the outgoing view scales up and away as the next scales in.
- **Why it works:** things come from somewhere and go somewhere, so the viewer builds a map. Rauno Freiberg: motion that "communicates where it is spatially" [S7].
- **Use / avoid:** steps, lists, flows, navigation. Avoid sliding a whole frame width, which reads as a carousel.
- **Parameters:** Material's shared axis runs 300ms on `(0.4, 0.0, 0.2, 1)`, with slide or scale as the primary motion and a fade-through as the secondary; its container transform fades content in over the first 25% of the move and runs 300ms in, 250ms out [S1]. Start at a 30 to 60px slide at 1080; for z, outgoing 1.0 to 1.08 and incoming 0.94 to 1.0.
- **Seen in:** Material's transition patterns [S1].
- **Build:** two layers with transforms and opacity; pure in `t`.
- **Tags:** `new` · `ok`

### 2.12 Liquid merge (metaballs)
- **Looks like:** two blobs approach, a neck bridges them, and they become one; or one splits into droplets.
- **Why it works:** surface tension reads as alive, and merging says "these combine".
- **Use / avoid:** two facts merging, a fork splitting. Avoid decorative blobs (aurora and blob backgrounds are template tells, lane C §1.3).
- **Parameters:** field `f = Σ rᵢ² / |p − cᵢ|²`, inside where `f ≥ 1` [S19]; or a smooth minimum with k = 0.2 to 0.5 times the smaller radius; merge over 500 to 800ms.
- **Seen in:** Jamie Wong's metaballs with marching squares [S19]; her plugins film's liquid glass (lessons §3.12).
- **Build:** per-pixel field in Metal with a 1px smoothstep edge, or marching squares with linear edge interpolation for vector output [S19].
- **Tags:** `extends` (smooth-min glass exists) · `ok`

### 2.13 Ordered dissolve (every pixel exactly once)
- **Looks like:** the next scene appears cell by cell in an even, pseudo-random order, crisp, with no blur.
- **Why it works:** it is a digital material. A maximal LFSR visits every cell exactly once, so the duration is exact and the coverage even; a Bayer order gives a printed, structured feel.
- **Use / avoid:** digital or retro stories; worlds made of cells. Avoid in soft films (it is not a crossfade).
- **Parameters:** Wolfenstein 3D's fizzlefade uses a 17-bit maximal LFSR in Galois form (mask `0x00012000`), 131,072 states, each of the 320x200 pixels hit once [S21]. Start at 4 to 12px cells at 1080 and 0.6 to 1.2s. Bayer version: show cell where `bayer(x, y) < p(t)` with the 8x8 matrix [S20].
- **Seen in:** Wolfenstein 3D, explained by Fabien Sanglard [S21].
- **Build:** precompute each cell's rank once (its index in the LFSR sequence divided by the count); a cell shows scene B when `rank < p(t)`.
- **Tags:** `new` (Bayer exists as texture, not as a transition order) · `ok`

### 2.14 Slit-scan time smear
- **Looks like:** each column, or each ring, of the picture shows a slightly different moment, so moving things stretch, bend and ripple across the frame.
- **Why it works:** it draws time as space, which is strange and beautiful, and it fits stories about time, history and memory.
- **Use / avoid:** memory and time stories; a new state that ripples across the frame. Avoid on static scenes (nothing happens) and on UI that must be read mid-move.
- **Parameters:** delay map `τ(x, y) = k·x/W` (linear), `k·r` (radial "tree rings") or a painted map; start at k = 0.2 to 1.0s.
- **Seen in:** Golan Levin's catalogue: Trumbull's Stargate for 2001 (1968); Rybczyński's The Fourth Dimension (1988), each line one frame later than the last; Time Maps (2004) with time by distance from a centre; Robot Mirror (2005) with brightness as the delay map [S22].
- **Build:** the scene is a function of time, so render it at `t − τ`: quantise τ into 32 to 64 bands, render the scene at each band's time, and stitch. For a whole sequence rendered in order, a ring buffer of earlier frames is also deterministic.
- **Tags:** `new` · `ok`

### 2.15 Paper fold and page curl
- **Looks like:** the frame folds like a map or curls like a page, shaded and casting a shadow, revealing the next scene underneath.
- **Why it works:** a physical material reads as made by hand, and the shading tells the 3D story.
- **Use / avoid:** editorial, print and papercraft films (papercraft is on the "still to build" list). Avoid in UI films, and use it once.
- **Parameters:** start at 280 to 450ms per panel, panels 60 to 100ms apart; Lambert shading from the fold angle with ambient 0.35 to 0.5; shadow offset 6 to 16px blurred 12 to 30px at 1080; paper tooth (5.7).
- **Seen in:** a page curl and stamps in her studied films (video-study §5); `CIPageCurlWithShadowTransition` and `CIAccordionFoldTransition` exist on this Mac [S79].
- **Build:** CoreImage transitions take a time input from 0 to 1, so feed them `p(t)`; or fold panels in Metal as hinged rotations with perspective.
- **Tags:** `new` · `card`

### 2.16 Through an object (a portal)
- **Looks like:** the camera flies into a detail (a letter's counter, a lens, a screen) and comes out inside the next scene.
- **Why it works:** space stays continuous, and "going inside" is itself a story (inside the agent's memory).
- **Use / avoid:** once per film, at the turn. Keep it short and motivated so it does not become the CG fly-through the Panic Room team avoided [S42].
- **Parameters:** start at a log-space approach of 0.8 to 1.5s; the portal fills the frame at the swap; the next scene starts at 1.2 to 1.5x and settles to 1.0 in 400 to 600ms.
- **Seen in:** Powers of Ten's continuous dive into a hand [S36].
- **Build:** distance on a log curve; render the next scene inside the portal's mask until the mask covers the frame, then swap layers.
- **Tags:** `extends` (flood and shrink) · `ok`

### 2.17 Datamosh handover
- **Looks like:** the new scene's motion pushes and drags the pixels of the old scene, smearing them along the movement, until the new picture lands clean.
- **Why it works:** two scenes blend through motion rather than opacity; it is a glitch with real logic.
- **Use / avoid:** digital culture, corruption, forgetting. Avoid on brand-critical frames and beyond a second (it turns to mud).
- **Parameters:** start at 8 to 24 frames of drag, at 0.5 to 1.5 times the incoming motion, then a hard cut to the clean frame on the beat.
- **Seen in:** datamoshing, where in-between frames are interpolated from two sources; Nabil Elderkin's "Welcome to Heartbreak" for Kanye West (2009) [S73].
- **Build:** you know your own scene's motion, so build the flow field analytically; advect the last outgoing frame through it, `img_{n+1}(p) = img_n(p − v(p))`. This carries state, so render those frames once in order and cache them.
- **Tags:** `new` · `card`

### 2.18 Foreground occluder wipe
- **Looks like:** something in the foreground (a hand, a card, a pillar, a giant letter) passes the lens, and when it clears, the scene behind has changed.
- **Why it works:** the cut is motivated by the world, so it feels filmed rather than edited.
- **Use / avoid:** invisible transitions in 2.5D and 3D scenes. Avoid in flat 2D where nothing could be in front.
- **Parameters:** start at full coverage for 1 to 3 frames; occluder speed 2 to 4 frame widths per second; the occluder slightly defocused (blur 1 to 3% of frame width).
- **Seen in:** foreground occluder wipes in her studied films (video-study §5, 3#10 and 3#11).
- **Build:** depth-sorted layers; swap the background layer while coverage is 100%.
- **Tags:** `new` · `ok`

---

## 3. Camera language in 2D, 2.5D and 3D

### 3.1 Multiplane parallax
- **Looks like:** layers at different depths slide at different speeds as the camera moves sideways: near layers fast, far layers slow.
- **Why it works:** parallax is one of the strongest depth cues, so flat artwork becomes a space.
- **Use / avoid:** 2.5D stages, illustration, depth behind UI. Avoid too many moving layers (mush) and depths that contradict the sizes of things.
- **Parameters:** screen offset = camera offset × focal ÷ depth; start at 3 to 5 layers with depth from 1 to 8, so near layers move 4 to 8 times faster than far ones. Disney's camera used up to seven layers of painted glass [S34].
- **Seen in:** Disney's multiplane camera, tested on The Old Mill (1937) and used on Snow White [S34].
- **Build:** each layer has a depth z; `screen = (world − cam)·f/z + centre`; add depth blur per layer (3.4).
- **Tags:** `new` (lane C: no depth stack in the engines) · `ok`

### 3.2 Dolly versus zoom
- **Looks like:** a dolly changes perspective (near things grow faster than far ones, the background slides); a zoom scales everything evenly and looks flat.
- **Why it works:** a dolly feels like moving through space; a zoom feels like looking harder (scrutiny, surveillance, a punch-in).
- **Use / avoid:** dolly for immersion, zoom for scrutiny. Never zoom-punch content sampled through a screen-fixed lattice (motion-systems §1: it shimmers).
- **Parameters:** start at a crash zoom of 2x in 8 to 12 frames with an ease-out; run dollies on log distance (3.12).
- **Seen in:** the dolly zoom entry explains the difference [S33].
- **Build:** in a 2.5D perspective rig `s = f / (z − z_cam)`: a dolly changes `z_cam`, a zoom changes `f`.
- **Tags:** `new` · `ok`

### 3.3 Dolly zoom (the Vertigo effect)
- **Looks like:** the subject stays the same size while the background stretches or squeezes behind it.
- **Why it works:** it contradicts normal perception, so it signals a realisation or unease [S33].
- **Use / avoid:** one realisation beat per film. Avoid timid values, which look like a mistake.
- **Parameters:** keep the subject's width constant: `W = 2·d·tan(FOV/2)` [S33]; start at FOV 50° to 20° (or the reverse) over 1.2 to 2.5s, ease in-out, with the background 3 to 10 times farther than the subject.
- **Seen in:** Vertigo, first made by Paramount camera operator Irmin Roberts [S33].
- **Build:** given distance `d(t)`, set `FOV(t) = 2·atan(W / (2·d(t)))`.
- **Tags:** `new` · `card`

### 3.4 Rack focus and depth of field
- **Looks like:** focus shifts from one plane to another; the unfocused plane softens with round highlights.
- **Why it works:** focus moves attention without a cut, and depth becomes hierarchy.
- **Use / avoid:** switching between proof and statement; the "defocus under the lockup" ending (anti-house §5). Avoid blurring text that must be read.
- **Parameters:** blur radius `b = K·|1/z − 1/z_focus|` (the thin-lens circle of confusion grows with aperture and with the difference in inverse distance); start at a maximum of 1.5 to 3% of frame width; a pull of 600 to 1,000ms on `(0.65, 0, 0.35, 1)`; 1 to 3% scale change during the pull for lens breathing [S32].
- **Seen in:** a rack focus in her studied films (video-study §5, 3#24). Spider-Verse used misaligned colour plates instead of focus blur (signature move 5) [S49].
- **Build:** per-layer `CIBokehBlur` or `CIMaskedVariableBlur` (both on this Mac) [S79]; in Metal, jitter the ray origin over a lens disk (lane D).
- **Tags:** `extends` · `ok`

### 3.5 Handheld micro-shake (the trauma model)
- **Looks like:** the frame breathes slightly like a camera on a shoulder, or jolts on an impact and settles.
- **Why it works:** smooth, organic noise reads as a person holding the camera; an impact jolt makes a hit physical.
- **Use / avoid:** documentary feel; one impact. Avoid constant strong shake (camera shake is on the brand ban list) and per-frame white-noise jitter, which looks digital.
- **Parameters:** `offset = max · trauma^2 · noise(seed, t·freq)` with trauma decaying about 1 per second; the exponent is 2 or 3 in common implementations [lead S82]. Start at handheld 0.5 to 2px and 0.05 to 0.2° at 0.3 to 1.2Hz; impact 6 to 14px and 0.6 to 1.2° at 8 to 14Hz, gone in 250 to 400ms. In 3D, rotate only (moving the position can push the camera into walls) [lead S82].
- **Seen in:** Squirrel Eiserloh's GDC 2016 camera talk, via implementations that cite it [lead S82].
- **Build:** smooth noise per axis with separate seeds; `trauma(t)` summed analytically from the impact times; pure in `t`.
- **Tags:** `extends` (learner v7 used shake) · `banned` on the supermemory surface unless a card asks for documentary

### 3.6 Orbit and crane (moves on a sphere)
- **Looks like:** an orbit circles the subject so light slides across its form; a crane rises and tilts down to keep the subject placed while the world opens out.
- **Why it works:** the orbit shows real 3D form and makes materials catch light; height reads as grandeur and reveal.
- **Use / avoid:** hero objects and reveals. Avoid endless constant-speed spins (screensaver) and orbiting UI icons (template tell, lane C §1.3).
- **Parameters:** start at 10 to 25° of arc per second and 30 to 90° per shot, eased over 0.8 to 1.2s at each end, with a 2 to 6° change in elevation; a crane rises 0.5 to 2 subject heights over 2 to 4s, the tilt keeping the subject's screen height within ±5%.
- **Seen in:** the media reel's opening bar: a low close shot with the camera rising and swinging right (media-reel README); ManvsMachine's procedurally built product worlds [lead S83].
- **Build:** camera on a sphere `(r·cos φ·cos θ, r·sin φ, r·cos φ·sin θ)` with `θ(t)`, `φ(t)`; for the crane, `pitch = atan((y_cam − y_subject)/distance)`.
- **Tags:** `exists` (media reel) · `ok`

### 3.7 Top-down (the god's-eye view)
- **Looks like:** the camera looks straight down at an arrangement (a desk, a map, a board of memories).
- **Why it works:** it flattens space into a composition and reads as the plan of the whole system.
- **Use / avoid:** overviews, "everything at once". Avoid when depth is the point.
- **Parameters:** start at an orthographic or long lens (FOV 15 to 25°), rotating 2 to 6° a second for life, with contact shadows for object height.
- **Seen in:** Powers of Ten opens overhead on a picnic at the Chicago lakefront and pulls straight up [S36].
- **Build:** the default 2D world, rotated; shadows offset away from a fixed light.
- **Tags:** `new` as a deliberate camera language · `ok`

### 3.8 Tilt-shift miniature
- **Looks like:** a full-size scene looks like a model: one sharp band, strong blur above and below, a high angle, punchy colour, sped-up movement.
- **Why it works:** we read a steep blur gradient as the shallow focus of a small, near scene, so the brain shrinks the world (Held et al. 2010) [S35].
- **Use / avoid:** making a system feel like a toy world (a city of servers, a model of the pipeline). Avoid text inside the blur.
- **Parameters:** start at a sharp band 15 to 30% of frame height, blur rising to 1.5 to 3% of frame width at the edges, the band aligned with the ground plane (later studies found the blur's orientation to the ground matters more than its rate) [S35]; camera 30 to 60° down; saturation +15 to 30%, contrast +10%; movement at 2 to 4x speed, on twos.
- **Seen in:** Held, Cooper, O'Brien and Banks on blur and perceived size [S35]; tilt-shift "miniature faking" [S35b].
- **Build:** `CIMaskedVariableBlur` driven by a `CILinearGradient` mask [S79].
- **Tags:** `new` · `card`

### 3.9 Lens character: distortion, breathing, fringes and vignette
- **Looks like:** a little barrel bend near the edges, a slight scale change while focus moves, thin colour fringes in the corners, corners a touch darker.
- **Why it works:** perfect pinhole rendering is a CG tell; a hint of lens says "photographed".
- **Use / avoid:** photographic and 3D films. Avoid on flat UI and brand surfaces, where it reads as a filter.
- **Parameters:** radial distortion `x_u = x_d + (x_d − x_c)(K1·r² + K2·r⁴)`, barrel when K1 is negative [S31]; start at K1 = −0.02 to −0.06 with r normalised to 1 at the corner; breathing 1 to 3% over a focus pull [S32]; lateral chromatic aberration by scaling red and blue radially [S30], start at ±0.1 to 0.2% at the corners and zero in the central 40%; natural vignetting follows the cos⁴ law [S29], start at corners 8 to 15% darker.
- **Seen in:** the optics pages for each effect [S29, S30, S31, S32].
- **Build:** one final Metal pass: per-channel radial sampling, inverse distortion, cos⁴ multiply.
- **Tags:** `new` · `card`

### 3.10 Shutter angle as a style dial
- **Looks like:** at 180° movement blurs naturally; at 45 to 90° action goes crisp and strobing; at 270 to 360° it smears dreamily.
- **Why it works:** the amount of blur carries feeling. Traffic gave one storyline a 45° shutter for a sharp, strobe-like look [S67].
- **Use / avoid:** change it per act (narrow for chaos, wide for calm). Avoid a narrow shutter on fast pans across fine detail (judder).
- **Parameters:** subframes spread across `angle/360` of the frame interval: 45° spans 1/8 of a frame, 180° half. The engine's 4 subframes at 1/240s spacing span three quarters of a 60fps frame, about 270° (my arithmetic). Start at `n = max(4, ceil(speed_px_per_frame · angle/360 / 2))` subframes.
- **Seen in:** Traffic (2000) [S67].
- **Build:** subframe times `t + (k/(n − 1) − 0.5)·(angle/360)/fps` for k = 0 to n − 1 (a centred shutter).
- **Tags:** `extends` (fixed 4-subframe blur exists) · `ok`

### 3.11 Locked-off frames
- **Looks like:** the camera does not move; the composition is fixed and things move inside it; cuts change the view.
- **Why it works:** a camera that never rests is part of the house watermark (anti-house §1); locked frames read as filmed and confident.
- **Use / avoid:** at least 30% of the runtime in films that want a filmed feel (option rule 7). Avoid in a morph-chain film whose idea is one continuous take.
- **Parameters:** zero drift, or at most 0.3 to 0.6% scale drift across a shot; shot lengths varied (anti-house rule 10).
- **Seen in:** Panic Room chose long, mostly static shots and cuts over a CG fly-through [S42].
- **Build:** camera constant per shot; cut on the beat.
- **Tags:** `new` as a default · `ok`

### 3.12 Log-space dolly
- **Looks like:** a push or pull that feels like constant speed across huge changes of scale.
- **Why it works:** perceived speed follows the ratio of scale change, not its difference, so a linear zoom feels like it accelerates or stalls.
- **Use / avoid:** every large push or pull, every portal (2.16), every infinite zoom (2.8).
- **Parameters:** `scale(t) = s0·(s1/s0)^e(t)`, with `e` linear for constant speed or eased at the ends only. Powers of Ten held one power of ten per 10 seconds going out [S36].
- **Seen in:** Powers of Ten [S36]; the media reel's pull-back (lane D).
- **Build:** interpolate `log(scale)` (or log distance), then exponentiate.
- **Tags:** `exists` (media reel, learner v3 rig) · `ok`

---

## 4. Composition and layout

### 4.1 Modular grid with a baseline
- **Looks like:** every element sits on columns and a baseline, and moving things land on grid lines.
- **Why it works:** a grid reads as order even when it is invisible, so motion that lands on it looks intended.
- **Use / avoid:** always, most of all in editorial and data films. Avoid stacking everything in the centre.
- **Parameters:** start at 12 columns on 1920x1080 with 96 to 128px margins, 24 to 32px gutters and an 8px baseline; type inside about 90% of the frame. For 9:16, start by keeping key type out of the bottom 20% and top 10%, where platform controls sit (time-sensitive: check each platform's current overlay).
- **Seen in:** commentary on The Vignelli Canon ranks the grid as the first layout tool [lead S76]; North by Northwest's title grid [S41].
- **Build:** a `Grid` struct (`col(i)`, `row(j)`, `baseline(k)`); every position derives from it; a debug overlay in stills.
- **Tags:** `extends` · `ok`

### 4.2 Negative space as the subject
- **Looks like:** most of the frame is empty ground, and one small element carries the meaning.
- **Why it works:** emptiness focuses attention and adds tension; crowded frames read as cheap.
- **Use / avoid:** statements, endings, premium moments. Avoid on dense proof shots.
- **Parameters:** start at the subject covering 3 to 15% of the frame, placed on a third or at an optical centre slightly above the middle (about 45% from the top); flag any statement frame with more than 40% ink.
- **Seen in:** commentary on Vignelli treats white space as the layout's silence [lead S76]; Stranger Things' letters in a dark void [S38].
- **Build:** measure ink coverage per still in QA.
- **Tags:** `new` as a rule · `ok`

### 4.3 Scale contrast and asymmetry
- **Looks like:** a giant element beside a tiny one on the same frame, with the main mass off-centre and a small counterweight across from it.
- **Why it works:** contrast makes hierarchy instantly; asymmetry makes movement and tension, where centred, evenly sized layouts are the generated default.
- **Use / avoid:** at least once per film (anti-house rule 4 asks for 6x type contrast; rule 18 asks for half the key frames asymmetric). Avoid making everything big.
- **Parameters:** 6 to 12x between the largest and smallest type on a frame; main mass on a third (33 or 67%) or the golden section (38 or 62%); counterweight 1/8 to 1/4 of the main mass's area; the giant element may crop at the frame edge.
- **Seen in:** Paula Scher's Public Theater posters, built from wood type, clashing faces and scale [lead S75].
- **Build:** layout only; check the ratio in QA stills.
- **Tags:** `exists` (rules 4 and 18) · `ok`

### 4.4 One-point symmetry
- **Looks like:** a corridor or an object dead centre, lines converging to one vanishing point, strict symmetry.
- **Why it works:** a perfectly centred perspective feels deliberate, ritual, monumental, slightly unsettling.
- **Use / avoid:** the reveal of the product or the mark, a confrontation; 1 to 3 shots per film. Avoid as a default, or it becomes the new watermark.
- **Parameters:** vanishing point at the exact centre within ±0.5% (or at 50% across and 40 to 50% down); symmetry within 1 to 2%.
- **Seen in:** Kogonada's "Kubrick // One-Point Perspective" supercut [S74].
- **Build:** camera aligned to the scene's axis; QA by mirroring a still and differencing it.
- **Tags:** `new` · `ok`

### 4.5 A frame within the frame
- **Looks like:** the subject seen through a window, a card, a doorway, a hairline box or a phone.
- **Why it works:** a frame isolates and adds depth, and says "this is a view of something", which suits evidence.
- **Use / avoid:** receipts, quotes, product screens, point of view. Avoid nesting more than two levels.
- **Parameters:** start at an inner frame 40 to 70% of frame width; a 1px hairline at 1080, or a real object's edge; inner content ±8% lightness from the outer ground.
- **Seen in:** Parthiv's film with hairline guides framing a stage (lessons #70); the Droste frame (2.8).
- **Build:** layout plus a mask.
- **Tags:** `extends` · `ok`

### 4.6 Full-bleed versus inset
- **Looks like:** an image switches between filling the frame (immersion) and sitting as an inset (evidence).
- **Why it works:** full-bleed means feel, inset means read and compare; changing size is itself a story beat.
- **Use / avoid:** the emotional beat full-bleed, the proof beat inset, with a push or pull between them. Avoid switching at random.
- **Parameters:** start at an inset 50 to 70% wide with at least 6% margins; the push to full-bleed 600 to 900ms on an expressive curve.
- **Seen in:** the stronger captures in her study float the window on a designed ground (video-study §7).
- **Build:** rect interpolation, ideally on the camera rather than on the image.
- **Tags:** `new` as a rule · `ok`

### 4.7 Synchronised split screen
- **Looks like:** two or more panels show different scenes with exactly synchronised action (before and after, with and without memory).
- **Why it works:** side-by-side comparison, with sync making the difference the only variable.
- **Use / avoid:** proof. Avoid panels that are out of sync (noise).
- **Parameters:** a fixed divider; the shared action within ±1 frame across panels; labels of 3 words or fewer.
- **Seen in:** synchronised split screens and before-and-after pairs for proof in her studied films (video-study §9, 4#15 and 4#17).
- **Build:** render each panel's scene from one timeline with offsets; mask by panel rects.
- **Tags:** `new` · `ok`

### 4.8 The typographic poster frame
- **Looks like:** the whole frame is a type composition: mixed weights and sizes, words as blocks, one colour accent, no image.
- **Why it works:** type alone can carry identity and energy, and it avoids generic imagery.
- **Use / avoid:** manifesto beats, launch statements. Avoid long sentences.
- **Parameters:** 3 to 7 words; three sizes at most; one word in the brand blue; blocks cut in on beats or on twos; one word cropped full-bleed by the frame (anti-house rule 3 option).
- **Seen in:** the Public Theater identity [lead S75].
- **Build:** CoreText, one run per word, Geist weights 100 to 900 by variation (1.1).
- **Tags:** `new` · `ok`

### 4.9 Composition rhythm across a film
- **Looks like:** the frame's centre of mass moves on purpose from shot to shot (left, right, centre for the monument), rather than every frame being centred.
- **Why it works:** the eye travels between frames as well as within them; alternating mass keeps cuts lively and gives the centred shot its weight.
- **Use / avoid:** any film with cuts. Avoid placing every hero in the middle.
- **Parameters:** start at no more than two consecutive key frames with the mass in the same third; one centred frame per act, reserved for the most important object.
- **Seen in:** Murch's eye-trace criterion: plan where the eye is at the cut [lead S63].
- **Build:** in the storyboard table, log each key frame's mass position; QA lists the sequence.
- **Tags:** `new` · `ok`

---

## 5. Texture and finish

**The subtlety budget.** Premium finishing is "felt rather than seen": a pro colorist tunes grain at full opacity, then drops it to about 30% [S25]. Anti-house rule 18 allows one imperfection layer per film. Judge at phone size and at a 100% crop, and judge after encoding, because grain makes x264 keep refining held frames (motion-systems encode notes).

### 5.1 Film grain, done like film
- **Looks like:** fine, irregular, slightly clumped grain that changes every frame, strongest in the mid-tones, weaker in the highlights, faintly coloured.
- **Why it works:** grain gives a render a physical surface and hides banding. Real grain is spatially correlated and depends on brightness; flat white noise looks digital.
- **Use / avoid:** photographic and film looks. Avoid on flat brand surfaces at phone size (reads as noise), and keep it under vector UI type rather than on it.
- **Parameters:** AV1's model shapes Gaussian noise with an autoregressive filter (lag up to 3) into a 64x64 luma template, applies it in 32x32 blocks at random offsets each frame, and sets strength with a piecewise-linear function of brightness [S23]. The Deep Analog paper sums three octaves weighted 50, 33 and 17%, with intensity `0.005 + 0.05·softplus(x)` (at least 0.005, about 0.04 for a neutral output), through a mid-tone mask `σ(aL² + bL + c)` (example a = −2.0, b = 1.5, c = 0.8) [S24]. Start at σ 0.015 to 0.03 of full scale for a visible 35mm feel at 1080, 0.006 to 0.012 for "felt"; grain 1.0 to 1.6px; chroma grain 30 to 50% of luma grain; soften the image very slightly first, because on film the grain is the sharpest detail [S25].
- **Seen in:** Stranger Things used scanned 35mm grain [S38].
- **Build:** Metal: hashed Gaussian noise seeded by frame index, a 3x3 correlating kernel, three octaves at 1x, 2x and 4x, times the mid-tone mask, added in gamma space. Subframes share their frame's seed, because grain belongs to the exposure, not the subframe.
- **Tags:** `extends` (triangular dither "grain" exists) · `card`

### 5.2 Halation
- **Looks like:** a red-orange glow at the edges of bright highlights, strongest where bright meets dark; orange near the edge, redder farther out.
- **Why it works:** it is film physics. Light passes through the emulsion, scatters off the camera's metal interior back toward the film's base side, and re-exposes the red-sensitive layer, which sits nearest the base; very bright light reaches the green layer too and turns the glow orange [S26]. It says "shot on film" and adds warmth.
- **Use / avoid:** lamps, screens glowing in the dark, the moment a product switches on. Never on the mark (a glow on the mark is banned); not on flat UI. LED sources produce little halation compared with incandescent light [S26].
- **Parameters:** highlights `H = I·σ(20(L − t_h))` with t_h between 0.5 and 0.95; blur radius per channel R 1.4r, G 1.0r, B 0.7r; strength from 0 to 0.5; `I' = I + α·ChannelBlur(H)` [S24]. Start at t_h 0.8, r 6 to 12px at 1080, α 0.15 to 0.3.
- **Seen in:** Dehancer's halation model [S26]; the Deep Analog renderer [S24].
- **Build:** threshold in linear light, three `CIGaussianBlur` passes (one per channel radius) or one Metal pass, then add.
- **Tags:** `new` · `card` (never on the mark)

### 5.3 Bloom, physically based and subtle
- **Looks like:** very bright areas spill a little light into their surroundings.
- **Why it works:** it imitates scattering in a lens or the eye, so light reads as bright without clipping.
- **Use / avoid:** real light in 3D scenes. Avoid thresholded glow around UI or the mark (banned).
- **Parameters:** 5 or 6 downsampled levels with Jimenez's 13-tap filter, a 3x3 tent upsample with radius about 0.005, mixed at 0.03 to 0.15 (0.04 typical), no threshold, and a Karis average on the first level to kill fireflies [S27].
- **Seen in:** LearnOpenGL's physically based bloom [S27]; the media reel uses `CIBloom` radius 18, intensity 0.2 (lane D).
- **Build:** a Metal mip chain, or `CIBloom` for quick work.
- **Tags:** `exists` (CIBloom; the mip chain is the upgrade) · `card`

### 5.4 Chromatic aberration, lateral and tiny
- **Looks like:** thin colour fringes on hard edges near the corners only.
- **Why it works:** it is a lens fingerprint and makes CG look optically captured.
- **Use / avoid:** photographic looks, corners only. Avoid the centre-frame "RGB split" glitch (template) and any fringe on text.
- **Parameters:** lateral aberration is corrected (or made) by scaling the colour channels radially [S30]; start at red +0.1 to 0.2% and blue −0.1 to 0.2% at the corners, fading to zero inside the central 40%.
- **Seen in:** Spider-Verse used out-of-register colour passes on purpose, as a way to show out-of-focus [S49] (signature move 5).
- **Build:** final pass, per-channel radial sampling.
- **Tags:** `new` · `card`

### 5.5 Gate weave and film breath
- **Looks like:** the whole picture drifts by fractions of a pixel, a little more vertically than horizontally, and exposure flickers very slightly from frame to frame.
- **Why it works:** real film moves in the camera gate. Perfectly locked frames under grain look like an overlay; weave sells the projected-film illusion.
- **Use / avoid:** archive or "before" sections, film looks. Avoid when UI must sit on a grid, and keep titles steady unless they are meant to be printed into the film.
- **Parameters:** Dehancer models weave as random shifts within a period of frames (X, Y, rotation, auto-zoom to hide edges) and notes it shows more on small gauges; its Film Breath tool varies exposure, contrast and colour separately [lead S28]. Start at X 0.2 to 0.5px and Y 0.4 to 1.0px at 1080, rotation at most 0.03°, a period of 3 to 8 frames smoothed, a 0.5% scale-up; breath ±1 to 2% exposure.
- **Seen in:** Dehancer's Gate Weave and Film Breath tools [lead S28].
- **Build:** smooth value noise keyed to the frame index; apply to the picture layer before titles.
- **Tags:** `new` · `card`

### 5.6 Dust, hair and scratches
- **Looks like:** an occasional speck or fibre for a frame or two, a faint vertical scratch.
- **Why it works:** physical history; age.
- **Use / avoid:** only in an archive section, and sparingly. Constant dust is a cheap preset.
- **Parameters:** start at 0 to 2 specks per frame, each 1 to 3 frames long and 2 to 8px; a hair every 3 to 6s; a scratch 1px wide at 5 to 15% opacity, lasting 0.5 to 2s with a slight sideways wander.
- **Seen in:** Se7en kept printing accidents (fish hooks and razor blades run through the machine) in the final cut [S39].
- **Build:** a seeded event list for the whole film; draw shapes with a slight blur; light specks for a negative look, dark for a print.
- **Tags:** `new` · `card`

### 5.7 Paper and ink
- **Looks like:** a toothy paper ground, ink that spreads slightly at its edges, uneven ink density.
- **Why it works:** material honesty; it signals print and a human hand.
- **Use / avoid:** editorial, riso, letterpress, papercraft. Avoid in UI films.
- **Parameters:** start at paper tooth from multi-octave noise at 2 to 6px with ±2 to 4% lightness; fibres as stretched noise; ink spread by growing the ink mask 0.5 to 1.5px with a noisy edge; ink density 85 to 100% with ±5% low-frequency mottle.
- **Seen in:** the media reel's riso medium (paper tooth, ink blotch noise) (lane D).
- **Build:** a tileable 2048x2048 paper texture made once; multiply; ink edges from the shape's distance field plus noise.
- **Tags:** `extends` · `card`

### 5.8 Risograph and misregistration
- **Looks like:** two or more flat ink layers that overprint (multiply), screened in coarse dots, slightly out of register.
- **Why it works:** cheap print's imperfection is warm and human; overprint makes new colours from two inks.
- **Use / avoid:** zines, playful briefs. The media reel already has this medium.
- **Parameters:** media reel: two drums, clustered dots at 15° and 75°, misregistration 2.6px, 9.5px cells, 12fps (lane D). New use: misregistration as focus (signature move 5) [S49].
- **Seen in:** media reel medium 4 (lane D); Spider-Verse's misprinted colour [S49].
- **Build:** each plate sampled through its own offset, multiplied onto paper.
- **Tags:** `exists` · `card`

### 5.9 Duotone and gradient maps
- **Looks like:** an image recoloured so its shadows become one colour and its highlights another (or a three-stop ramp).
- **Why it works:** it pulls mismatched images into one look. Collins' Spotify system used duotone imagery so artwork every service receives would look like Spotify's own, with a tool (the Colorizer) to apply it at scale [lead S53].
- **Use / avoid:** unifying photos and footage in the brand's colours. Avoid rainbow ramps, and never on UI captures (it destroys the meaning of UI colours).
- **Parameters:** normalise contrast first (5th to 95th percentile to 0 to 1), then map through a ramp interpolated in OKLab (6.4); start with the shadow stop at lightness 0.15 to 0.25 and the highlight at 0.90 to 0.97.
- **Seen in:** Collins' Spotify identity [lead S53].
- **Build:** `CIColorMap` with a 256x1 gradient image generated in OKLab [S79].
- **Tags:** `new` · `ok` with an ink, blue, paper ramp

### 5.10 Posterise and limited levels
- **Looks like:** continuous tone collapses into 3 to 6 flat bands, like a screen print or cel shading.
- **Why it works:** bold, graphic, printable, and it removes CG smoothness. Spider-Verse avoided smooth gradations, using a dot pattern for transitions instead [S49].
- **Use / avoid:** print looks and stylised 3D. Never let banding happen by accident: band on purpose, or dither.
- **Parameters:** start at 3 to 6 levels of OKLab lightness with 1px antialiased thresholds, optionally halftoned within each band.
- **Seen in:** Spider-Verse [S49].
- **Build:** `CIColorPosterize` (sRGB levels) or a Metal quantise on OKLab lightness.
- **Tags:** `new` · `card`

### 5.11 Choosing a dither: ordered, error diffusion, blue noise
- **Looks like:** Bayer is a regular crosshatch; Floyd-Steinberg is organic but wormy; Atkinson is contrasty and loses shadow and highlight detail; blue noise is even and patternless.
- **Why it works:** each carries an era (Bayer the early computer, Atkinson the classic Mac, blue noise the modern renderer), so the choice is a style decision.
- **Use / avoid:** choose per style card; the brand lattice already owns Bayer, so do not default to it. Avoid frame-by-frame error diffusion in motion unless boiling is the look, because small changes propagate and the pattern crawls.
- **Parameters:** Bayer matrices are built recursively; threshold with `brightness > bayer(x, y)`, and dither in linear light [S20]. Floyd-Steinberg sends 7/16, 3/16, 5/16 and 1/16 of the error to its neighbours; Atkinson sends 1/8 to six neighbours and drops a quarter of the error, which raises contrast; blue noise uses a 64x64 void-and-cluster tile; Riemersma dither follows a Hilbert curve with r = 1/16 and n = 16 [S20].
- **Stability in motion:** Return of the Obra Dinn pinned its dither to a sphere around the camera, so it holds during rotation but swims during movement; surface-stable fractal dithering keeps dots on surfaces at a constant screen size [S77].
- **Seen in:** Surma's "Ditherpunk" [S20]; Obra Dinn and its successor technique [S77].
- **Build:** Bayer and blue noise as threshold maps in Metal; error diffusion on the CPU per frame, either accepted as a boil on twos or stabilised by diffusing only the change from the previous frame.
- **Tags:** `extends` (Bayer exists) · `ok`

### 5.12 CRT and scanlines
- **Looks like:** visible scanlines, a phosphor stripe or dot mask, slight curvature and glow.
- **Why it works:** it signals an era (terminals, arcades) and has the glow of a real tube.
- **Use / avoid:** retro computing and "the old way" sections. Avoid as a generic filter on modern UI.
- **Parameters:** crt-royale's beam defaults run from sigma 0.02 to 0.30, so bright lines grow thicker than dark ones; aperture grilles work at 1080p, slot and shadow masks need 1440p to 4K [S90]. A port of Timothy Lottes' shader declares hardScan −8, hardPix −3, warp 0.031 and 0.041, maskDark 0.5, maskLight 1.5 and bloomAmount 0.15 [S90b]. Start at 270 to 360 visible lines on a 1080 frame.
- **Seen in:** the crt-royale documentation on GameTechWiki [S90]; the Lottes port [S90b].
- **Build:** a final pass: a Gaussian beam profile per line whose width follows brightness, a stripe mask multiply, a barrel warp.
- **Tags:** `new` · `card`

### 5.13 Line boil and stepped imperfection
- **Looks like:** drawn lines wobble slightly every two or three frames, as if redrawn each time, so even held poses stay alive.
- **Why it works:** a redrawn line on twos is the signature of hand animation. Config 2025's opening film was cut from 60 to 15fps to feel handmade [S47], and Vercel Ship 2025's opener was animated on twos [S48].
- **Use / avoid:** sketch and illustration looks, "idea" moments. Never on precise UI or on the mark.
- **Parameters:** start at a displacement of 0.5 to 1.5px at 1080 along the stroke normal, reseeded 12 to 15 times a second (twos at 24fps, or Config's 15fps); faster boils read as jitter; stroke width ±8%.
- **Seen in:** Config 2025 [S47]; Vercel Ship 2025 [S48].
- **Build:** per stroke, offset each point by `noise(seed = floor(t·12), pointIndex)` along its normal; pure in `t`.
- **Tags:** `new` · `card`

### 5.14 Halftone variants
- **Looks like:** tone made from dots that grow (AM screens), from scattered dots of one size (FM, or stochastic), from lines, or from hatching; colour from rotated screens that form rosettes.
- **Why it works:** each screen is a printing era and a texture; dot shape changes the feel.
- **Use / avoid:** print looks. The brand already uses round halftone and Bayer; reach for line, hatch or FM screens to vary it.
- **Parameters:** AM varies dot size on a regular grid, FM varies spacing [S72]; round dots meet at 70% tone, elliptical at 40 and 60%, square at 50% [S72]; screens are rotated against each other to avoid moiré, and newsprint runs about 85 lines per inch [S72]. The common CMYK set of 15°, 75°, 0° and 45° is standard practice but was not on the page opened.
- **Seen in:** the halftone entry [S72]; Spider-Verse's "Kirby dots" from comic printing [S49].
- **Build:** `CILineScreen`, `CIHatchedScreen`, `CIDotScreen`, `CICircularScreen` and `CICMYKHalftone` exist on this Mac [S79]; FM screening from a blue-noise threshold (5.11).
- **Tags:** `extends` · `ok`

---

## 6. Colour strategies

### 6.1 One hero colour, every colour with a job
- **Looks like:** ink and paper (or two neutrals) carry nearly everything; one hero colour appears only on the thing being proved.
- **Why it works:** scarcity gives the hero colour meaning, so it works as a pointer.
- **Use / avoid:** every film. Avoid a new colour per card, rainbow colouring and neon (design-tells).
- **Parameters:** start at the hero colour on 10% or less of the pixels in a statement frame; one accent with one meaning per film.
- **Seen in:** one accent that means something, from her library (lane C row 1).
- **Build:** a palette table with a role for each colour; QA counts hero-colour pixels per still.
- **Tags:** `exists` · `ok`

### 6.2 Colour held back for the payoff
- **Looks like:** the film runs in monochrome, or ink and paper, and the hero colour arrives only at the turn, first on the one object that matters.
- **Why it works:** withholding makes the first appearance of colour an event.
- **Use / avoid:** launches, before-and-after stories. Avoid when colour is needed early to understand the picture.
- **Parameters:** start with the first hero colour at 40 to 65% of the runtime, on one object, spreading afterwards if at all; arrival 300 to 600ms as a fading colour layer, never a hex tween (motion-grammar §2).
- **Seen in:** Up's colour script drains colour after a death and brings it back with the adventure, per summaries of Pixar's colour scripts [lead S68].
- **Build:** grade every layer to ink and paper; a hero layer whose opacity rises at the turn.
- **Tags:** `new` (on the anti-house "still to build" list) · `ok`

### 6.3 A colour script before the render
- **Looks like (planning):** a strip of small thumbnails, one per beat, showing palette and light; colour intensity rises with emotion and falls in the quiet beats.
- **Why it works:** colour becomes structure. Pixar's art director Ralph Eggleston made pastel colour scripts for Toy Story, and the studio made one for every film after that [lead S68].
- **Use / avoid:** every film over about 20 seconds.
- **Parameters:** start at one swatch per beat (5 to 12 beats), each logging hero coverage %, mean lightness and chroma; one peak; no two neighbouring beats the same.
- **Seen in:** Pixar colour scripts (Eggleston, Lou Romano) [lead S68].
- **Build:** render one still per beat at 64px wide into a strip; put it in the film's README before the full render.
- **Tags:** `new` · `ok`

### 6.4 Perceptual gradients (OKLab)
- **Looks like:** gradients that keep an even brightness and never pass through muddy grey or drift purple.
- **Why it works:** RGB, HSV and even CIELAB interpolation shift hue and lightness unevenly; white to blue drifts purple in CIELAB and HSV, while OKLab stays close to a straight path [S69].
- **Use / avoid:** every gradient and every colour transition.
- **Parameters:** linear sRGB to LMS with Ottosson's first matrix, a cube root per channel, then his second matrix to L, a, b [S69]; interpolate there, convert back, then dither (triangular, existing) against banding.
- **Seen in:** Björn Ottosson's OKLab post [S69].
- **Build:** two small Swift functions; bake a 256-entry table per gradient.
- **Tags:** `new` · `ok` (the brand book's three gradients look better this way)

### 6.5 Cosine palettes for procedural colour
- **Looks like:** smooth multi-hue ramps defined by four vectors.
- **Why it works:** compact, harmonious colour for generative fields, animatable through its phase.
- **Use / avoid:** generative grounds and data colour in non-brand films. Avoid rainbow output on brand films (a tell); keep the amplitude narrow.
- **Parameters:** `color(t) = a + b·cos(2π(c·t + d))`; Quilez's example with a = b = (0.5, 0.5, 0.5), c = (1, 1, 1), d = (0, 0.33, 0.67) gives a full rainbow; d = (0, 0.10, 0.20) a warmer, narrower ramp [S10].
- **Seen in:** Inigo Quilez's palettes article [S10].
- **Build:** one line of Metal.
- **Tags:** `new` · `banned` as a rainbow on brand films, `ok` when narrowed to the brand ramp

### 6.6 Ground switch (light versus dark as point of view)
- **Looks like:** the ground flips between paper and ink when the point of view, the person or the era changes.
- **Why it works:** a big, simple signal of "a different world".
- **Use / avoid:** you versus them, before versus after, written in one tool and recalled in another (video-study §12). Avoid flipping for decoration.
- **Parameters:** switch on a cut or inside a wipe; invert type colour roles consistently.
- **Seen in:** a studied film where light mode is you and dark mode is the other person (video-study §6, 5#19).
- **Build:** two palettes keyed to a scene flag.
- **Tags:** `exists` (in the study) · `ok`

### 6.7 A grade for each storyline
- **Looks like:** each act or thread has its own grade and texture (cool, warm, strobed).
- **Why it works:** viewers track threads by colour without labels.
- **Use / avoid:** films with two or three threads or eras.
- **Parameters:** Traffic gave one storyline tungsten stock without a filter for a cold blue look, another diffusion, flashing and overexposure for warmth, and the Mexico thread tobacco filters with a 45° shutter [S67]. Start at a temperature shift of 800 to 1,500K between threads.
- **Seen in:** Traffic (2000) [S67].
- **Build:** one `CIColorCube` per act, blended over 0 to 12 frames at the seam.
- **Tags:** `new` · `card`

---

## 7. Rhythm, timing and editing

### 7.1 Curves chosen by role (the published sets)
- **Looks like:** information moves fast and plainly, hero objects move with weight, the camera glides, and each class keeps its own curve.
- **Why it works:** one curve for everything is a tell; different curves per class tell the eye what kind of thing is moving.
- **Use / avoid:** pick 3 or 4 classes per film from one family (anti-house rule 5), and change family between films.
- **Parameters:**

| Family | Standard | Enter | Exit | Durations |
|---|---|---|---|---|
| Material 3 [S1] | `(0.2, 0, 0, 1)` | decelerate `(0, 0, 0, 1)`; emphasized decelerate `(0.05, 0.7, 0.1, 1)` | accelerate `(0.3, 0, 1, 1)`; emphasized accelerate `(0.3, 0, 0.8, 0.15)` | 16 tokens: 50 to 200 (short), 250 to 400 (medium), 450 to 600 (long), 700 to 1,000ms (extra long) |
| Carbon productive [S3] | `(0.2, 0, 0.38, 0.9)` | `(0, 0, 0.38, 0.9)` | `(0.2, 0, 1, 0.9)` | shared tokens 70, 110, 150, 240, 400, 700ms; productive is described as significantly faster than expressive |
| Carbon expressive [S3] | `(0.4, 0.14, 0.3, 1)` | `(0, 0, 0.3, 1)` | `(0.4, 0.14, 1, 1)` | the same tokens, toward the slow end |
| iOS-style sheet (Vaul) [S6c] | `(0.32, 0.72, 0, 1)` | same | same | 500ms |
| Emil Kowalski (lane C row 2) | in-out `(0.77, 0, 0.175, 1)` | `(0.23, 1, 0.32, 1)` | short; about half the entrance (anti-house rule 5) | UI under 300ms [S6] |

- **When linear:** constant motion (a drift, a macro glyph slide, an orbit, a ticker), mechanical things, time itself. **When strong ease-out:** arrivals that must feel decisive. **When springs:** thrown, dropped or released things, and anything redirected mid-move, because a spring keeps its velocity when retargeted [S4].
- **Seen in:** the systems above.
- **Build:** a `Curve` enum with these constants and a cubic-Bézier solver (Newton plus bisection).
- **Tags:** `extends` · `ok`

### 7.2 Springs set by duration and bounce (closed form, pure in `t`)
- **Looks like:** physical settling with a chosen amount of overshoot, from none to playful.
- **Why it works:** a spring decelerates the way real objects do and keeps velocity when its target changes [S4, S5].
- **Use / avoid:** anti-house rule 6: damping 1.0 by default; overshoot only for thrown, dropped or released things; type and UI never overshoot.
- **Parameters:** Apple sets springs by perceptual duration and bounce: mass 1, stiffness `(2π/duration)²`; bounce 0 is smooth, about 0.15 hardly feels bouncy, 0.3 is noticeable, and values above about 0.4 call for caution [S4]. Apple's printed damping line is garbled on its page, so it was checked on this Mac: SwiftUI's own `Spring(duration:bounce:)` returns mass 1, stiffness `(2π/duration)²` and damping `(1 − bounce)·4π/duration` for bounce 0 to 0.4, so `ω0 = 2π/duration` and the damping ratio is exactly `ζ = 1 − bounce` (bounce 0.15 gives 0.85, 0.3 gives 0.7) [S79]. Negative bounce reports parameters that do not follow this formula; avoid it. Material's expressive spatial springs are damping ratio 0.8 with stiffness 380 (default), 0.6 and 800 (fast), 0.8 and 200 (slow); its effects springs are 1.0 with 1,600, 3,800 and 800 [S2]; its standard spatial springs are 0.9 with 1,400, 700 and 300 [S1]. Overshoot for each damping ratio, `exp(−πζ/√(1 − ζ²))` (my arithmetic): 0.9 → 0.15%; 0.85 → 0.6%; 0.8 → 1.5%; 0.7 → 4.6%; 0.6 → 9.5%.
- **Seen in:** WWDC23 "Animate with springs" [S4]; Material's motion tokens [S1, S2].
- **Build:** underdamped step `x(t) = 1 − e^(−ζω0t)·(cos ωd·t + (ζω0/ωd)·sin ωd·t)` with `ωd = ω0·√(1 − ζ²)`; critical `1 − e^(−ω0t)(1 + ω0t)` (motion-grammar §2). Retargeting: summing step responses, `x(t) = Σ Δg_k·s(t − t_k)` (motion-grammar §2), already keeps position and velocity continuous, because each step starts with zero velocity; add an impulse term `v·e^(−ζω0τ)·sin(ωd·τ)/ωd` (with `τ = t − t_k`) only for an external kick such as a throw. All closed form, so `render(t)` stays pure.
- **Tags:** `extends` · `ok`

### 7.3 Anticipation
- **Looks like:** a small counter-move before the main move: a card dips before it rises, a button squashes before it launches.
- **Why it works:** it prepares the eye, so the main move reads as intended (Disney's second principle) [S9].
- **Use / avoid:** launched or thrown objects and big reveals. Avoid on UI and type, and on frequent events.
- **Parameters:** start at a counter-move of 5 to 12% of the travel over 80 to 160ms (5 to 10 frames at 60fps), ease in-out; the main move starts from that extreme.
- **Seen in:** the twelve principles [S9].
- **Build:** a two-segment curve: `p(u) = −a·sin((π/2)·u/u0)` for `u < u0` (it arrives at `−a` with zero velocity), then the main curve from `−a` to the target.
- **Tags:** `new` · `card`

### 7.4 Follow-through, overlap and drag
- **Looks like:** parts of a thing stop at different times: the label settles after its card, the tail after the head.
- **Why it works:** loose parts keep moving after the body stops, and different parts move at different rates [S9]; simultaneous stops look rigid and digital.
- **Use / avoid:** compound objects. Text inside UI stays locked to its container.
- **Parameters:** start with secondary parts 2 to 6 frames (33 to 100ms) behind and settling at damping 0.7 to 0.85 (4 to 10% amplitude) while the primary settles at 1.0; offsets inside a group of 20 to 40ms.
- **Seen in:** the twelve principles [S9]; Ben Marriott's Adobe MAX 2022 session lists overlapping action among its topics [lead].
- **Build:** each child follows its parent's position through its own spring with a delay `δ`.
- **Tags:** `new` · `ok`

### 7.5 Duration grows with distance; exits are shorter
- **Looks like:** small hops are quick, long journeys take longer, and leaving is faster than arriving.
- **Why it works:** a constant duration makes long moves feel rushed and short ones sluggish; a fast exit hands attention to what comes next.
- **Use / avoid:** always.
- **Parameters:** IBM says duration should be dynamic: the bigger the change in distance or size, the longer the animation [S3]. Material: fade in 150ms and out 75ms; container transform in 300ms and out 250ms [S1]. Start at hops under 10% of the frame in 150 to 250ms, half the frame in 350 to 500ms, the full frame in 500 to 800ms, the camera 1.2s or more (anti-house rule 5); exits at 0.5 to 0.75 of the entrance, on an accelerating curve.
- **Seen in:** Carbon [S3]; Material [S1].
- **Build:** `duration = clamp(100 + 410·√(d/W), 120, 900)` ms, with d the travel and W the frame width, reproduces those bands: 230ms at a tenth of the frame, 390ms at half, 510ms across (my fit).
- **Tags:** `new` · `ok`

### 7.6 A stagger budget
- **Looks like:** a group moves as one gesture with a ripple through it, not as a queue.
- **Why it works:** small offsets show hierarchy and cause; offsets that are too long break the group apart. Config 2025's glyphs work this way: one glyph can shift and set off a ripple through the whole composition [S47].
- **Use / avoid:** groups of 3 or more. Anti-house rule 1 allows one per-letter stagger per film.
- **Parameters:** start at 20 to 60ms per item, with the whole stagger no more than 30 to 40% of the move's duration; order by reading order or by distance from the cause.
- **Seen in:** Config 2025 [S47].
- **Build:** `start_i = t0 + min(i·δ, 0.35·D)` or ordered by `distance(i, origin)`.
- **Tags:** `extends` · `ok`

### 7.7 Holds and the breath
- **Looks like:** after a big moment, motion drops almost to nothing for half a second to a second and a half while the viewer catches up.
- **Why it works:** contrast in density makes the peaks land; constant motion flattens everything.
- **Use / avoid:** after every climax. Option rule 9 asks for 2 or more deliberate holds of 0.8 to 1.5s; her standing ask is lots of movement, so use moving holds where she wants motion.
- **Parameters:** start with holds of 0.8 to 1.5s; moving-hold drift of 1 to 2% (exists); motion density cut by half or more for 1 to 2 beats after the peak.
- **Seen in:** motion-grammar §1 (moving holds); anti-house option rule 9.
- **Build:** a density curve in the beat table; QA measures the moving percentage per second.
- **Tags:** `extends` · `ok`

### 7.8 Ones, twos and threes
- **Looks like:** characters and objects animate at 12 or 8 drawings a second while the camera stays smooth.
- **Why it works:** Spider-Verse was animated mostly on twos, with some ones and threes, and dropped motion blur for drawn motion lines and blocky smears on fast pans [S49]; Vercel Ship 2025 animated on twos for a 12fps rhythm even with the camera at 24 [S48]; Config 2025 ran its film at 15fps [S47]. Stepping reads as made by hand.
- **Use / avoid:** anti-house rule 19 (one film in three). Never motion-blur a stepped layer.
- **Parameters:** stepped time `t_s = floor(t·12)/12` (twos) or `floor(t·8)/8` (threes); the camera uses the continuous `t`; a smear on fast moves: one held frame stretched 1.5 to 3x along the velocity.
- **Seen in:** Spider-Verse [S49]; Vercel Ship 2025 [S48]; Config 2025 [S47].
- **Build:** per layer, a `timeStep` setting; the shutter applies only to continuous layers.
- **Tags:** `exists` (rule 19; the media reel steps type and riso) · `ok`

### 7.9 Speed ramps
- **Looks like:** an action slows sharply at its key instant, then snaps back to speed.
- **Why it works:** it stretches the apex so the eye can take it in: the hero moment.
- **Use / avoid:** once per film, on a real apex (a card at the top of its flip, a drop of ink at impact). Avoid on talking or UI.
- **Parameters:** start at speed 1.0 down to 0.15 to 0.3 and back to 1.0; each ramp 6 to 12 frames (a smoothstep in speed); the slow part 0.5 to 1.5s centred on the apex; keep the output-time shutter so the slow part is crisper.
- **Seen in:** no reference opened this run (a common action-film grammar).
- **Build:** source time `s(t) = ∫speed`, analytic for piecewise smoothsteps; `render(s(t))`.
- **Tags:** `new` · `card`

### 7.10 Structure on the beat, accents off it
- **Looks like:** big changes land on downbeats; small accents land on off-beats or a sixteenth early.
- **Why it works:** on-beat events feel stable, syncopation feels energetic, and all-on-beat feels mechanical. Scoring every single movement (Mickey Mousing) reads as comic or trite when overdone [S66].
- **Use / avoid:** every music-led film. Avoid one sound and one hit per move.
- **Parameters:** structural changes on beat 1 of a bar; secondary accents on the "and" or a sixteenth early (a push); at most one primary event per beat (motion-grammar §1); one impact per film (anti-house rule 11); one odd-length section of 5, 7 or 11 beats (rule 10).
- **Seen in:** ManvsMachine's Air Max films, edited so tightly to the soundtrack that sound and image read as one piece [lead S83]; Mickey Mousing as the warning [S66].
- **Build:** beat helpers `b(n)` already exist; add `and(n) = b(n) + 0.5 beat` and `push(n) = b(n) − 0.25 beat`.
- **Tags:** `new` · `ok`

### 7.11 Silence and drop-outs
- **Looks like (sounds like):** the music drops out for a beat or two before the turn, and the picture holds its breath with it.
- **Why it works:** the gap makes the return land harder than any riser.
- **Use / avoid:** once per film (rule 10 asks for one silence of 0.5s or more).
- **Parameters:** drums out 1 to 2 beats before the turn (the existing Apple Loops arrangement); motion density cut by half during the drop.
- **Seen in:** motion-systems §4 (the arrangement).
- **Build:** the audio timeline and the beat table share `b(n)`.
- **Tags:** `exists` · `ok`

### 7.12 Arcs
- **Looks like:** organic things travel on curved paths; mechanical things go straight.
- **Why it works:** natural movement follows arcs, mechanical movement typically moves in straight lines [S9]; straight-line tweens on organic things look robotic.
- **Use / avoid:** thrown or floating objects, characters, hands. Keep UI and mechanical parts straight.
- **Parameters:** start with an arc that sags 5 to 15% of the travel distance.
- **Seen in:** the twelve principles [S9].
- **Build:** a quadratic Bézier between start and end with its control point offset along the normal.
- **Tags:** `new` · `ok`

---

## 8. Generative and procedural visuals

**Determinism rule for this section.** Anything with state (flocks, cloth, fluids, reaction-diffusion, pixel sorting over time) is simulated once at load with a fixed step and a seeded random source, cached per frame (or per 1/240s when subframes are needed), and then sampled by `render(t)`. Fields with no state (distance fields, noise, flow fields evaluated per point, Voronoi) are computed directly from `t`.

### 8.1 The 2D distance-field kit
- **Looks like:** crisp vector shapes of any kind (rounded boxes, stars, arcs, moons, hearts, eggs, vesicas) with perfect edges, offsets, outlines and rounding at any size.
- **Why it works:** one function per shape gives antialiasing, strokes, glows, insets and morphs for free.
- **Use / avoid:** every abstract shape, every aperture (2.6), every morph (2.7). Avoid hand-rasterised shapes that cannot be inset or morphed.
- **Parameters:** Quilez lists 40+ 2D primitives with exact code; `opRound` subtracts r to round any shape, `opOnion` takes `|d| − r` to make rings [S11]; antialias with `smoothstep(−px, px, −d)` where px is one pixel in the shape's units.
- **Seen in:** Inigo Quilez's 2D distance functions [S11].
- **Build:** port the needed functions to Metal and Swift once; for glyphs and logos with no formula, compute a field from the mask (EDT, or `CISignedDistanceGradientFromRedMask`) [S79].
- **Tags:** `extends` (SDFs exist) · `ok`

### 8.2 Raymarched 3D in a shader
- **Looks like:** real 3D (soft shadows, ambient occlusion, reflections, haze, depth of field) with no meshes.
- **Why it works:** sphere tracing a distance field gives physical light cheaply, and lane D measured 0.15 to 0.25s a 1080p frame on this Mac.
- **Use / avoid:** the media reel's language. Avoid as every film's default (the style log rotates media).
- **Parameters:** soft shadows `k·h/t` (start at k 8 to 32) and AO from 5 samples along the normal (lane D); normals by central or tetrahedral differences of the field.
- **Seen in:** the media reel and `engine/gpu/` (lane D).
- **Build:** exists.
- **Tags:** `exists` · `card`

### 8.3 Flow fields
- **Looks like:** thousands of curves that follow an invisible current, like combed hair, wind or water.
- **Why it works:** neighbouring curves follow similar directions, so the image has strong coherent rhythm with organic variety.
- **Use / avoid:** grounds, texture, "information flowing", a word formed from fur (signature move 18). Avoid the default Perlin look, which Hobbs calls overused.
- **Parameters (Tyler Hobbs):** a grid of angles at about 0.5% of image width (his pseudocode uses 1%), extending 50% beyond each side of the image; Perlin scale about 0.005 of grid coordinates mapped to 0 to 2π; step length 0.1 to 0.5% of width; short curves give fur, long curves smooth lines; start points on a grid, at random, or by circle packing; a minimum separation stops curves crowding; rounding angles to multiples of π/10 gives a "rocky" look and π/4 chaos [S14].
- **Seen in:** Tyler Hobbs's flow field essay [S14].
- **Build:** curves traced once per frame from seeded starts (deterministic); animate by drawing curves on along their length `L(t)`, or by moving the noise's third coordinate slowly.
- **Tags:** `new` · `card` (strokes must carry meaning on the brand surface)

### 8.4 Curl-noise particles
- **Looks like:** smoke-like swirling particles that never bunch up or thin out unnaturally.
- **Why it works:** the velocity is the curl of a noise potential, so it has no divergence; flow looks like a real incompressible fluid, and solid obstacles can be respected [S17].
- **Use / avoid:** when particles are the data (memories drifting, tokens flowing). Avoid decorative particles (banned on the brand surface).
- **Parameters:** in 2D, velocity is the noise gradient rotated 90°; obstacles by ramping the potential to a constant near the surface (a multiplicative ramp, or an additive one that keeps free slip) [S17]. Start at a noise scale of 1/150 to 1/400 of the frame and speeds of 20 to 120px/s at 1080.
- **Seen in:** Bridson, Hourihan and Nordenstam's 2007 curl-noise paper, as analysed by Ding and Batty (2023) [S17].
- **Build:** integrate particles with a fixed step and cache; or, for short trails, integrate each particle from a fixed start every frame (deterministic but slower).
- **Tags:** `new` · `banned` as decoration, `card` as data

### 8.5 Boids
- **Looks like:** a flock or school that wheels and splits like birds or fish, then can gather into a shape.
- **Why it works:** three local rules (separation, alignment, cohesion inside a neighbourhood defined by a distance and an angle) produce life-like group motion that is unpredictable over moderate spans and predictable over very short ones [S16].
- **Use / avoid:** many agents acting together (a swarm of agents, users arriving). Avoid as screen decoration.
- **Parameters:** start at a neighbour radius of 30 to 60px at 1080, separation radius 12 to 20px, weights 1.5, 1.0 and 1.0, top speed 120 to 220px/s, a 270° field of view; to assemble a shape, cross-fade the weights into "seek target" over about 1s and land with no overshoot.
- **Seen in:** Craig Reynolds' boids (SIGGRAPH 1987) [S16].
- **Build:** bake with a spatial hash (Reynolds notes the naive version is O(n²) and spatial structures make it near O(n)) [S16].
- **Tags:** `new` · `card`

### 8.6 Reaction-diffusion with a parameter map
- **Looks like:** organic spots, stripes, mazes and coral, and fronts that grow across the frame.
- **Why it works:** the Gray-Scott system grows evenly spaced, winding patterns that read as alive; changing the feed and kill rates over space or time changes the pattern.
- **Use / avoid:** growth, ink, biology, brains (exists in the glass mind). Avoid the same coral in every film.
- **Parameters:** D_A 1.0, D_B 0.5, Δt 1.0; a 3x3 Laplacian with centre −1, edges 0.2, corners 0.05; mitosis f 0.0367, k 0.0649; coral f 0.0545, k 0.062; a common default f 0.055, k 0.062; f and k can vary across the grid for different patterns in different areas [S15].
- **Seen in:** Karl Sims' tutorial [S15]; the glass mind (motion-systems §2).
- **Build:** bake one state per frame; drive f and k from a style map (an image or a distance field) for patterned fronts; the ink-bloom wipe is signature move 17.
- **Tags:** `extends` · `card`

### 8.7 Voronoi cells with exact borders
- **Looks like:** a cellular mosaic (cracked glaze, territories, shattered glass, cells), with clean even borders.
- **Why it works:** the cells are the regions nearest each seed point, so they tile space naturally; exact border distances give lines of constant width.
- **Use / avoid:** shatters, territories, "facts as cells", re-sorting (signature move 26 in the spares). Avoid wobbly approximate borders.
- **Parameters:** pass 1 finds the nearest seed in the 3x3 neighbourhood; pass 2 checks the 5x5 neighbourhood around that seed and measures the distance to each bisector as `dot(0.5·(mr + r), normalize(r − mr))`; borders as `1 − smoothstep(0.0, 0.05, d)` [S13].
- **Seen in:** Quilez's Voronoi borders article [S13].
- **Build:** Metal per pixel; animate seeds with slow noise; shatter by giving each cell its own transform keyed to `t`.
- **Tags:** `new` · `ok`

### 8.8 L-systems (growth)
- **Looks like:** branching plants, trees, coral or networks drawing themselves.
- **Why it works:** rewriting rules give self-similar branching that reads as growth; drawing the derivation over time is the animation.
- **Use / avoid:** knowledge growing, a memory branching. Avoid literal clip-art trees.
- **Parameters:** the classic fractal plant: axiom `−X`; rules `X → F+[[X]−X]−F[−FX]+X` and `F → FF`; angle 25°; `F` draws forward, `+` and `−` turn, `[` and `]` push and pop the turtle state [S91]; introduced by Aristid Lindenmayer in 1968 [S91].
- **Seen in:** the L-system entry [S91].
- **Build:** expand the string at load; turtle-walk it into segments tagged with depth and order; reveal segments by `order < N(t)` with tapered widths by depth.
- **Tags:** `new` · `ok`

### 8.9 Verlet ropes and cloth
- **Looks like:** cables that sag and swing, flags and sheets that ripple, a drape pulled off to reveal.
- **Why it works:** Verlet integration keeps only current and previous positions, so it is stable; constraints solved by relaxation give believable cloth cheaply [S87].
- **Use / avoid:** wires between tools, hanging labels, a cloth reveal. Avoid jelly-soft cloth on the brand surface.
- **Parameters:** `x += x − x_old + a·dt²` (1.99 instead of 2 adds drag); for most cloth, one relaxation pass per step is enough because errors spread across later frames; a square-root-free stick update [S87]. Start at a step of 1/240s and 2 to 4 relaxation passes for ropes.
- **Seen in:** Thomas Jakobsen's "Advanced Character Physics" (Hitman) [S87].
- **Build:** bake per 1/240s; render reads positions by time.
- **Tags:** `new` · `card`

### 8.10 Stable fluids (dye in water)
- **Looks like:** ink in water: curling, folding, diffusing colour.
- **Why it works:** Stam's method advects by tracing back along the flow (the method of characteristics) and projects to a divergence-free field, so it is unconditionally stable for any step; its known drawback is numerical dissipation, flow damping out too fast [S89].
- **Use / avoid:** "memory diffusing", ink and paint looks. Avoid as a generic splash background.
- **Parameters:** a well-known WebGL implementation defaults to simulation 128, dye 1,024, density dissipation 1, velocity dissipation 0.2, pressure 0.8, 20 pressure iterations, curl (vorticity) 30, splat radius 0.25; its step order is curl, vorticity, divergence, clear pressure, pressure solve, gradient subtract, advect velocity, advect dye [S18].
- **Seen in:** Jos Stam's "Stable Fluids" (SIGGRAPH 1999) [S89]; Pavel Dobryakov's WebGL fluid [S18].
- **Build:** Metal compute passes at 256x144 for velocity and full size for dye; bake per frame.
- **Tags:** `new` · `card`

### 8.11 Domain-warped noise grounds
- **Looks like:** marble, smoke, oil on water, slowly folding fibrous grounds.
- **Why it works:** feeding noise into its own coordinates makes folds and swirls that plain noise lacks.
- **Use / avoid:** slow, living grounds; paper fibres. Avoid aurora blobs (template tell, lane C §1.3).
- **Parameters:** Quilez's pattern `f(p) = fbm(p + 4·q)` with `q = (fbm(p), fbm(p + (5.2, 1.3)))`, then a second warp `r` with offsets (1.7, 9.2) and (8.3, 2.8), colour taken from q and r. (His article failed to load this run; the formula is from memory, so verify against https://iquilezles.org/articles/warp/ before quoting it.)
- **Seen in:** Quilez's domain warping article [unverified this run].
- **Build:** Metal fbm, time added to one offset at 0.02 to 0.05 units a second.
- **Tags:** `new` · `card`

### 8.12 ASCII by shape, not by brightness
- **Looks like:** an image drawn in characters whose shapes follow the edges (a slash for a diagonal, a pipe for a vertical), so the picture stays sharp.
- **Why it works:** treating each character as a pixel of one brightness blurs everything; matching the character's shape to the cell's shape keeps contours.
- **Use / avoid:** the type medium (exists in the media reel). Avoid brightness-ramp ASCII, which looks like a filter.
- **Parameters (Alex Harri):** six sampling circles per cell in a staggered layout; each glyph's shape vector is the share of each circle it covers, normalised per component across the character set; the best glyph is the nearest vector (Euclidean, square root skipped); contrast is boosted globally (normalise, raise to a power, rescale) and directionally from 10 external circles that reach into neighbouring cells; lookups are cached by quantising each component to 5 bits [S70].
- **Seen in:** "ASCII characters are not pixels" [S70]; the media reel's type medium uses tone plus an edge angle per cell (lane D).
- **Build:** compute glyph vectors once from Geist Mono outlines; per frame sample six circles per cell in Metal; nearest neighbour through the cache.
- **Tags:** `extends` · `ok` (Geist Mono)

### 8.13 Pixel sorting
- **Looks like:** runs of pixels in an image sorted by brightness, so the picture melts into streaks along columns or rows.
- **Why it works:** it keeps the image's own colours but rearranges them, so it reads as the image dissolving, not a filter painted over it.
- **Use / avoid:** decay, forgetting, corruption (signature move 21). Avoid as a generic glitch.
- **Parameters:** Kim Asendorf's ASDFPixelSort (2010) sorts runs bounded by a threshold, with modes keyed to black, brightness (default 127) or white, columns first, then rows [S71]. Start with the threshold sweeping from 0.95 to 0.4 over 1.5s and runs capped at 10 to 40% of the frame height.
- **Seen in:** ASDFPixelSort [S71].
- **Build:** CPU per frame on a downscaled copy (2x), sorted runs written back; deterministic, cache the frames.
- **Tags:** `new` · `card`

### 8.14 Lissajous and harmonograph curves
- **Looks like:** looping figures traced by two oscillations, slowly evolving, the kind of figure a pendulum drawing machine leaves.
- **Why it works:** simple frequency ratios make elegant, hypnotic, mathematical drawings.
- **Use / avoid:** abstract rhythm, signal, "thinking". Avoid as a screen saver.
- **Parameters:** `x = A·sin(a·t + δ)`, `y = B·sin(b·t)`; start at ratios 3:2, 5:4 or 7:6 with δ drifting 0.05 to 0.2 rad/s; harmonograph decay `e^(−t/τ)` with τ 10 to 40s.
- **Seen in:** Vertigo's titles, where John Whitney contributed the spiral "Lissajous" imagery [S45].
- **Build:** a polyline of 2,000 points per frame, drawn on along its length.
- **Tags:** `new` · `ok`

(Halftone variants are 5.14; datamosh is 2.17; metaballs are 2.12.)

---

## 9. Sound design in sync

### 9.1 One sound per event, and the sound names the material
- **Looks like (sounds like):** each picture event gets one sound, and that sound tells you what the thing is made of (paper, glass, ink, metal).
- **Why it works:** sound fuses with the image it lands on, so it decides the material; a generic whoosh says nothing.
- **Use / avoid:** every film. At least half the effects should come from the film's own material (anti-house rule 20).
- **Parameters:** at most one foreground effect per beat; each medium gets its own small family of sounds (the media reel: a burin, keys, a pencil, a print drum, glass, a brush).
- **Seen in:** Buck's Good Books film, where Antfood spent about eight months making the audio transitions carry the picture transitions [lead S51]; Config 2024 gave each video custom sound [S46].
- **Build:** a cue list exported from the renderer (event time, material); the score script places a sample per cue.
- **Tags:** `exists` (media reel foley per medium) · `ok`

### 9.2 Sound trails the picture, never leads it
- **Looks like (sounds like):** clicks and hits land with or just after their picture.
- **Why it works:** viewers notice sound that leads its picture at a much smaller offset than sound that lags it, because sound arriving after light is what the world normally does.
- **Use / avoid:** always.
- **Parameters:** ITU-R BT.1359 puts detectability at about 45ms early to 125ms late, acceptability at about 90ms early to 185ms late; ATSC guidance is stricter, 15ms early and 45ms late [lead S58]. Keep each sound 0 to 2 frames (0 to 33ms at 60fps) after its picture, as the voiceover engine already does.
- **Seen in:** the ITU recommendation, through secondary summaries [lead S58].
- **Build:** cue time = picture time + 1 frame by default.
- **Tags:** `exists` (voiceover engine) · `ok`

### 9.3 The anatomy of a hit
- **Looks like (sounds like):** a riser builds, a hit lands with a sharp attack, a weighty body and a tail that sets the pace into the next shot.
- **Why it works:** the attack syncs, the body gives weight, the tail decides how long the moment lasts.
- **Use / avoid:** one impact per film (anti-house rule 11); no riser into a crash at the same point in consecutive films (rule 20). Often the better hit is silence (7.11).
- **Parameters:** start with a riser of 2 to 8 beats, the hit exactly on the picture's peak frame, a tail of 0.6 to 2s, and the music ducked 3 to 6dB for 200 to 400ms around it; pick a hit for its texture and frequency position rather than its size [lead S80].
- **Seen in:** general sound-design practice, secondary sources only [lead S80].
- **Build:** the score script reads the peak frame from the renderer's cue list.
- **Tags:** `exists` · `ok`

### 9.4 Whooshes, if ever
- **Looks like (sounds like):** a band of noise that swells and fades with a move.
- **Why it works:** it can sell speed, but it is the most generic sound in motion graphics.
- **Use / avoid:** banned on the supermemory surface ("it sounds AI-generated", smfs v1 feedback). Elsewhere: rarely, and only on a real move.
- **Parameters:** keep it under 0.5s, pan it with the direction of travel, glide its pitch with the speed, one texture layer at most [lead S80].
- **Seen in:** secondary sound-design guides [lead S80].
- **Build:** filtered noise with an envelope in `dsp.swift`.
- **Tags:** `exists` (as a ban) · `banned`

### 9.5 Room tone instead of digital silence
- **Looks like (sounds like):** even "silent" moments carry a faint air or room sound, except a deliberate cut to true silence.
- **Why it works:** dead digital silence sounds like a dropout; a quiet bed keeps the world present, so a deliberate silence stands out.
- **Use / avoid:** under every quiet section; drop it only for the one deliberate silence.
- **Parameters:** start at a room-tone bed around −50 to −60 dBFS, filtered to the scene's space.
- **Seen in:** no source opened this run (standard post-production practice).
- **Build:** a looped, crossfaded noise bed in the score.
- **Tags:** `new` · `ok`

### 9.6 Loudness and peaks
- **Looks like (sounds like):** the film plays at the same level as everything around it in the feed, without clipping.
- **Why it works:** platforms normalise loudness, so a louder master only gets turned down and loses its dynamics.
- **Use / avoid:** every master.
- **Parameters:** Spotify normalises to −14 LUFS integrated; keep true peak under −1 dBTP, or under −2 dBTP for masters louder than −14 [S59]. Her study measured finished code-made social cuts at −13.8 to −14.9 LUFS and dialogue-led pieces at −16 to −23 (video-study §10). Time-sensitive: check each platform's current target.
- **Seen in:** Spotify's loudness page [S59].
- **Build:** the existing two-pass loudnorm.
- **Tags:** `exists` · `ok`

### 9.7 Arrangement follows picture
- **Looks like (sounds like):** instruments enter and leave with the story (keys alone at the start, drums for the story, out before the turn), so the music is cut to the film.
- **Why it works:** sound and picture read as one piece when the edit and the arrangement share a structure.
- **Use / avoid:** music-led films. Avoid wallpaper music under picture.
- **Parameters:** sections on bar lines; one instrument change per section; a picture-born ending sound (the last print, a brush) rather than a cymbal.
- **Seen in:** ManvsMachine's Air Max work locked edit to soundtrack [lead S83]; Config 2025 replaced a PA announcement with the sound of an orchestra warming up as the start signal [S47].
- **Build:** the arrangement table is the beat table.
- **Tags:** `exists` (Apple Loops arrangement) · `ok`

### 9.8 The audible word lands the picture
- **Looks like (sounds like):** in a voiced film, picture changes land on the audible onset of a word, slightly before it.
- **Why it works:** the voice is what the viewer tracks; picture that lands a hair early reads as caused by the word.
- **Use / avoid:** every voiced film.
- **Parameters:** picture 2 frames before the audible onset; clicks 2 frames after their visual (the existing voiceover engine).
- **Seen in:** `references/voiceover.md` (sync proven at +33 and +55ms in console part 1).
- **Build:** exists (`vo_times.swift`).
- **Tags:** `exists` · `ok`

---

## 10. Story devices for 15 to 60s brand films

### 10.1 A hook inside 1.5 seconds
- **Looks like:** by 1.0 to 1.5s the viewer already has a premise, a question, a moving number, or the product doing something.
- **Why it works:** feeds are scrolled fast. Research Facebook cited (Fors Marsh Group) reported recall of mobile feed content after 0.25s of exposure [lead S61]; Google's ABCD research tells advertisers to open mid-action or on a close-up, with bold sound and bright, high-contrast images [S60].
- **Use / avoid:** every social film; rotate the hook type film to film (anti-house rule 15). Weak opens from her study: a held UI still, a fade up from black, an unzoomed 4K capture (video-study §3).
- **Parameters:** premise by 1.0 to 1.5s (her study's strongest opens); movement in frame 0; a composed frame 0, because it is the thumbnail.
- **Seen in:** Google ABCD [S60]; her study's hooks (video-study §3).
- **Build:** QA renders frame 0 and the 1.5s frame side by side and asks "what is this about?".
- **Tags:** `exists` (in the study) · `ok`

### 10.2 One idea, said once
- **Looks like:** the film's whole idea fits in one short line, and every beat serves it.
- **Why it works:** one idea survives a scroll; two ideas cancel. The iPod launched as "1,000 Songs in Your Pocket": a number and a container [S62].
- **Use / avoid:** every film. Cut any beat that needs a second idea.
- **Parameters:** the idea in 8 words or fewer, written at the top of the beat table; every beat's row names how it serves that line.
- **Seen in:** Apple's 2001 iPod release [S62]; Google ABCD's advice to keep the message focused [S60].
- **Build:** a planning rule.
- **Tags:** `new` · `ok`

### 10.3 Withhold, then reveal
- **Looks like:** the viewer sees fragments, effects or the result before the whole or the cause: macro letters before the word, the answer before the receipts.
- **Why it works:** a gap in knowledge holds attention, and the reveal pays it off.
- **Use / avoid:** teasers, launches. Avoid withholding the product so long that the film never says what it does (lessons #76).
- **Parameters:** start with the reveal at 55 to 75% of the runtime; or result-first structures, with the finished output for the first half and the inputs after (video-study §4).
- **Seen in:** Stranger Things' macro letters resolving into the title [S38]; result-first films in her study (video-study §4).
- **Build:** the beat table marks the reveal frame; nothing before it shows the whole.
- **Tags:** `new` · `ok`

### 10.4 Problem, turn, proof, door
- **Looks like:** a short film in four movements: the pain, the turn ("then this"), the proof (the product working), the door (the call to action and lockup).
- **Why it works:** it maps onto Google's ABCD (attention, branding, connection, direction) [S60] and onto the launch-film structures in her study (video-study §4).
- **Use / avoid:** most launch and product films. Vary it with withhold-then-reveal (10.3) or a loop (10.5) so the structure does not become a watermark.
- **Parameters (start at):**

| Length | Hook | Problem | Turn | Proof | Door |
|---|---|---|---|---|---|
| 15s | 0 to 1.5 | 1.5 to 5 | 5 to 7 | 7 to 12.5 | 12.5 to 15 |
| 30s | 0 to 2 | 2 to 9 | 9 to 12 | 12 to 26 | 26 to 30 |
| 60s | 0 to 3 | 3 to 15 | 15 to 20 | 20 to 52 (three proofs) | 52 to 60 |

- **Seen in:** Google ABCD [S60]; video-study §4.
- **Build:** a beat-table template with these columns.
- **Tags:** `extends` · `ok`

### 10.5 The loop
- **Looks like:** the last frame becomes the first, so autoplay runs the film again seamlessly.
- **Why it works:** loops add watch time and reward a second look.
- **Use / avoid:** social cuts; Droste returns (signature move 9). Avoid when the lockup must hold still at the end (make a separate loop cut).
- **Parameters:** match position, velocity, cursor and sound tail at the seam (motion-grammar §6); match the grain seed too.
- **Seen in:** her studied loops (video-study §5 and §11).
- **Build:** render frame N with `t = 0` state, and check the seam by playing the last and first second together.
- **Tags:** `exists` · `ok`

### 10.6 The callback
- **Looks like:** the opening motif returns at the end, changed by what happened in between.
- **Why it works:** a closed circle feels designed; the change in the motif is the story in one image.
- **Use / avoid:** films with a strong opening image.
- **Parameters:** the same composition and camera as the first shot, with one difference (the memory is kept, the line is healed).
- **Seen in:** opening motifs returning around the logo in her study (video-study §5).
- **Build:** reuse the first shot's camera and layout constants.
- **Tags:** `exists` · `ok`

### 10.7 Three, with a twist
- **Looks like:** three examples in the same form; the third breaks the pattern.
- **Why it works:** two set a pattern, the third surprises; the break is where the laugh or the point lands.
- **Use / avoid:** lists of use cases or integrations. Avoid four or more in the same form.
- **Parameters:** start at 1.5 to 3s for each of the first two, about 1.5 times that for the twist.
- **Seen in:** no source opened this run (a standard comedy and rhetoric structure).
- **Build:** a beat-table pattern.
- **Tags:** `new` · `ok`

### 10.8 Design for sound off
- **Looks like:** the story reads with the sound off: captions for speech, visual proof for every claim.
- **Why it works:** feeds start muted; in Facebook's own test of 965 video ads, only 24% could be understood without sound [lead S61].
- **Use / avoid:** every social cut.
- **Parameters:** burned-in captions for speech; every spoken claim also shown.
- **Seen in:** Facebook's test, through press coverage [lead S61].
- **Build:** QA watches the cut muted.
- **Tags:** `exists` (captions rule in the study) · `ok`

### 10.9 Endings that are not a logo slam
- **Looks like:** the film ends on something with meaning, then the official lockup arrives quietly.
- **Why it works:** a logo slam is the most generic ending there is, and the house "mark pops, wordmark wipes in" ending is retired as a default (anti-house §5).
- **Use / avoid:** rotate (anti-house rule 14): never the same device as either of the last two films; the ending under 2.5s; a held lockup of 1.5 to 3s.
- **Options:**
  - the product's real action is the last frame, and the lockup sits beside it;
  - the survivor of the film becomes the lockup quietly (motion-grammar §3.6);
  - defocus under the lockup (3.4);
  - anamorphic alignment (the media reel);
  - type resolves out of a field of glyphs (8.12);
  - the last print of a print run is the lockup sheet;
  - a light reveal: a sun patch or projector slides onto a painted lockup;
  - the lockup found in the world (on a surface, in a reflection, through a window);
  - return to frame 0 (10.5);
  - a cut to black and one recorded sound, then the lockup;
  - the call to action as a real UI object, such as a command pill (video-study §11).
- **Seen in:** her study's endings (video-study §11); the anti-house ending table.
- **Build:** each ending as a function `ending(kind, t)` in the engine, so rotation is a parameter.
- **Tags:** `extends` · `ok` (the lockup itself never changes)

---

## 11. Signature moves (25, fully specified)

Each move is a complete recipe for a style card. Times assume 60fps and 1080p (scale pixel values by frame height). "Rules" names the anti-house rules each move touches. Two spares follow the 25.

### M1. Macro glyph lock
- **The move:** the film opens on two fragments of one giant Geist letter drifting toward each other in a void; they lock into the first letter of the hero word; a log-space pull-back reveals the whole word.
- **Where:** the opener (a mystery hook).
- **Timing:** drift 0 to 3.4s, linear, each fragment at 2% of frame width per second; the last 16 frames before the lock on `(0.23, 1, 0.32, 1)`; pull-back 3.4 to 4.6s, scale 5.0 to 1.0 in log space on `(0.65, 0, 0.35, 1)`.
- **Parameters:** the letter 5x frame height at the start; the word at rest 55% of frame width; a 3px rim on the final letter only; grain σ 0.012.
- **Sound:** a sustained low tone; at the lock, one felt-mallet note a fifth above. No riser.
- **Build:** 1.4 and 3.12 (glyph paths, two clipped halves, a log camera).
- **Rules:** hook type "mystery" (rule 15); brand words in Geist; never the mark.
- **From:** Stranger Things [S38]; Powers of Ten [S36].

### M2. Weight tide
- **The move:** in a held statement set in Geist Mono, a wave of stroke weight runs left to right and comes to rest heavy on the key word.
- **Where:** the statement after a reveal.
- **Timing:** the wave crosses in 1.6s, 60ms per glyph; the key word ramps to 800 and stays; the rest relax to 350 over 600ms after the wave passes.
- **Parameters:** base 350, crest 800, a raised-cosine crest 4 glyphs wide; Geist Mono's advance is fixed at 0.6em, so nothing reflows [S79].
- **Sound:** none, or one pad swell whose pan follows the wave.
- **Build:** 1.1.
- **Rules:** counts as the film's single per-letter stagger (rule 1); no mask rise.

### M3. Trend odometer
- **The move:** a sourced number changes from old to new; each digit column rolls in the direction of the change, units through every value in between, higher columns through fewer; columns land right to left.
- **Where:** a proof beat.
- **Timing:** 750ms per change on `(0.05, 0.7, 0.1, 1)` [S1]; units land first, each column to the left 40ms later.
- **Parameters:** masks 0.25em top and bottom, 0.5em at the sides [S55]; Geist Mono or tabular Geist; digit line-height 0.9.
- **Sound:** one soft tick per landing column, 1 frame after it lands; no slot-machine whirr.
- **Build:** 1.11.
- **Rules:** never from zero (a template tell); measured and sourced (rule 23).

### M4. Typed by a person
- **The move:** a prompt typed with real rhythm: bursts inside words, a held breath before the key word, one typo fixed, a caret that blinks only when idle.
- **Where:** an input moment (a command, a question).
- **Timing:** inter-key mean 130ms, SD 25ms; +200ms at spaces; +550ms before the key word; one wrong character, then a backspace 220ms later; caret solid while typing, blinking 530ms on and 530ms off from 500ms after the last key.
- **Parameters:** grounded in measured typing (fast typists average about 120ms with SD 11ms; all typists 239ms with SD 112ms) [S54].
- **Sound:** one recorded key per character, 1 frame after its glyph, rotating 3 samples with ±2dB variation; a different sound for the space bar.
- **Build:** 1.10.
- **Rules:** the film's one typing effect (rule 13), with the speed band corrected.

### M5. Misregistration focus pull
- **The move:** the plane that is out of focus is drawn as two or three ink plates out of register with a coarse halftone instead of a blur; pulling focus slides the plates into register while the halftone fines up.
- **Where:** moving attention between a near proof and a far statement.
- **Timing:** 500ms on a critically damped spring at 2Hz; plates converge 30ms apart.
- **Parameters:** plate offsets 6 to 12px in different directions (ink up-left, blue down-right); halftone cell 14px to 6px; the sharp plane drawn clean.
- **Sound:** a soft paper slide, and a muted drum thunk as the plates register.
- **Build:** render the plane once per plate colour; sample each through its own offset `o_k(t)`, screen it with its own threshold, multiply onto paper.
- **Rules:** plates in ink and brand blue; never on the mark; counts as the film's imperfection layer (rule 18).
- **From:** Spider-Verse used misaligned colour passes to show out-of-focus [S49].

### M6. Stepped world, smooth camera
- **The move:** objects and type animate on twos while the camera dollies smoothly at 60fps; fast moves get one smeared frame instead of blur.
- **Where:** a whole act, or the whole film.
- **Timing:** objects at `floor(t·12)/12`, the camera at `t`; any object moving more than 40px in one step is drawn once stretched 2x along its velocity.
- **Parameters:** no motion blur on stepped layers; shutter on the camera layer only.
- **Sound:** foley quantised to the same 12fps grid.
- **Build:** a time step per layer (7.8).
- **Rules:** satisfies rule 19.
- **From:** Spider-Verse [S49]; Vercel Ship 2025 [S48]; Config 2025 [S47].

### M7. Shutter swing
- **The move:** the chaotic "before" act is shot with a crisp 45° shutter; at the turn the film switches to a soft 270° shutter for the calm "after".
- **Where:** the act change at the turn.
- **Timing:** the switch happens on the cut, with no ramp.
- **Parameters:** subframes spread over 1/8 of a frame at 45° and 3/4 at 270°; 8 or more subframes for fast motion at 270°.
- **Sound:** before, dry and close; after, the same sounds with a short room.
- **Build:** 3.10.
- **From:** Traffic's 45° shutter storyline [S67].

### M8. Powers-of-eight pull
- **The move:** from overhead on one memory card, the camera pulls straight up by a factor of 8 every 2.5s through self-similar levels (card, board, app, the network of apps), centre fixed; the last level settles where the lockup will sit.
- **Where:** the scale beat, or the ending.
- **Timing:** `s(t) = 8^(t/2.5)` for three levels (7.5s), the last 0.8s eased.
- **Parameters:** each level fades in when it covers 1.5% of the frame and out below 0.3%.
- **Sound:** one soft pitched tick at each level crossing, rising a scale degree per level.
- **Build:** 2.8 and 3.12; each level drawn as a function of its own local scale.
- **From:** Powers of Ten [S36].

### M9. Droste return
- **The move:** the last scene shows a screen or a printed sheet; the camera dives into it at constant felt speed, and what it shows is frame 0, so the film loops perfectly.
- **Where:** the end of a loop cut.
- **Timing:** a 2.4s dive in log space, inset ratio 6; the last frame equals frame 0, grain seed included.
- **Parameters:** a real frame edge (a bezel, a paper border) so it never reads as a tunnel filter (lane D on `CIDroste`).
- **Sound:** the last sound's tail crossfades into frame 0's sound over 200ms.
- **Build:** 2.8; QA plays the last and first seconds together.
- **From:** Powers of Ten [S36]; Escher's Print Gallery [lead S37].

### M10. Slit-scan arrival
- **The move:** a new layout arrives as a time smear: the right of the frame is already new while the left is still old, and the change ripples across.
- **Where:** a before-to-after state change.
- **Timing:** `τ(x) = 0.6s·(1 − x/W)`; the move itself 0.4s on `(0.4, 0.14, 0.3, 1)`.
- **Parameters:** 48 time bands; text masked out of the smear until it settles.
- **Sound:** a filtered chord swelling across the stereo field with the ripple (not a whoosh).
- **Build:** 2.14.
- **From:** Golan Levin's slit-scan catalogue [S22].

### M11. Fizzle into cells
- **The move:** the outgoing scene breaks into 8px cells, which switch to the next scene in an exact pseudo-random order over a second, each cell once; each switching cell shows as a flat square for 2 frames before it resolves.
- **Where:** a digital transition.
- **Timing:** 1.0s; order from a maximal LFSR.
- **Parameters:** 8px cells; 2-frame squares; the flashing area stays small [S57].
- **Sound:** granular ticks whose density follows the switching rate.
- **Build:** 2.13.
- **From:** Wolfenstein 3D's fizzlefade [S21].

### M12. Rack focus from statement to proof
- **The move:** a statement on a far plane and the proof on a near one; focus pulls from the statement to the proof, and the statement loses colour as it softens.
- **Where:** a claim and its proof in one frame.
- **Timing:** 800ms on `(0.65, 0, 0.35, 1)`; 1.5s on each focus.
- **Parameters:** blur up to 2% of frame width (`K·|1/z − 1/z_f|`); planes at depth 1 (proof) and 3 (statement); 1.5% breathing; the soft statement at −60% saturation.
- **Sound:** a quiet mechanical focus tick, or nothing.
- **Build:** 3.4 with `CIMaskedVariableBlur` per layer.

### M13. Tilt-shift system city
- **The move:** an overhead 45° view of a "city" of server blocks and memory tiles looks like a model, with small movements running fast and stepped like toys.
- **Where:** "how it all fits together".
- **Timing:** a 3 to 5s shot; motion at 3x speed on twos.
- **Parameters:** a sharp band 22% of frame height aligned with the ground; blur up to 2.5% of width; saturation +20%; contrast +10%.
- **Sound:** small wooden clicks and a music-box tone.
- **Build:** 3.8.
- **From:** Held et al. on blur and perceived size [S35].

### M14. Dolly-zoom realisation
- **The move:** at the realisation beat, the key element keeps its size while the world behind it stretches away.
- **Where:** once, at the turn.
- **Timing:** FOV from 50° to 22° over 1.8s on `(0.65, 0, 0.35, 1)`.
- **Parameters:** constant width `W = 2·d·tan(FOV/2)` [S33]; background 5 to 10x farther than the subject.
- **Sound:** one sustained note bending down a semitone across the move.
- **Build:** 3.3.
- **From:** Vertigo [S33].

### M15. Shape match cut
- **The move:** a round element in the outgoing scene (a loader ring, a bubble) cuts to a round element in the incoming scene (a cursor ring, the bowl of a letter) at the same place, size and speed.
- **Where:** problem to product, or between chapters.
- **Timing:** a hard cut while both move at mid-speed; no dissolve.
- **Parameters:** position within ±5%, size ±10%, velocity ±15%.
- **Sound:** the outgoing sound cut on the frame; the incoming sound 1 frame later; no transition sound.
- **Build:** 2.1.
- **From:** 2001's bone-to-satellite cut [S64].

### M16. Map fold reveal
- **The move:** a card folds open in four panels like a paper map, shaded by its fold angles and casting a soft shadow; inside is the next scene.
- **Where:** one thing opening into its context (a physical variant of the house unfold).
- **Timing:** 280ms per panel, 80ms apart, on `(0.4, 0.14, 0.3, 1)`.
- **Parameters:** Lambert shading with ambient 0.4; shadow offset 10px, blur 20px; paper tooth (5.7).
- **Sound:** a recorded paper fold per panel; the last with a soft thud.
- **Build:** 2.15 (panels in Metal, or `CIAccordionFoldTransition`).

### M17. Ink bloom wipe
- **The move:** reaction-diffusion grows from a dozen seeds inside a shape, changing from spots to maze as it spreads, and the grown pattern becomes the mask that reveals the next scene.
- **Where:** growth, learning, "it spreads".
- **Timing:** 2.0s; feed and kill move from mitosis (0.0367, 0.0649) to coral (0.0545, 0.062) over the first 1.2s [S15].
- **Parameters:** a 512x288 grid, upscaled with a smooth threshold; mask where B > 0.25.
- **Sound:** a wet brush stroke and a low swell.
- **Build:** 8.6, baked.
- **From:** Karl Sims [S15].

### M18. Flow-field handwriting
- **The move:** thousands of short strokes drift in a curl field, then comb onto the outlines of a word until it reads as fur, then smooth out.
- **Where:** generative brand moments, "something forming".
- **Timing:** 2.5s: 1.0s drifting, 1.0s attraction, 0.5s combing.
- **Parameters:** 4,000 strokes, each 0.3% of width long; the field blends curl noise with the glyph distance field's gradient turned 90° so strokes flow along the outline [S14, S17].
- **Sound:** a soft brushing texture swelling with the attraction.
- **Build:** 8.3 and 8.4.
- **Rules:** `card` only; the strokes must be the story, not decoration.

### M19. Halation switch-on
- **The move:** a product's screen turns on in a dark scene; its light rises over 6 frames with a red-orange halation edge that peaks and settles.
- **Where:** the product reveal.
- **Timing:** brightness 0 to 1 over 6 frames; halation strength 0 to 0.35 at frame 6, settling to 0.15 over 600ms.
- **Parameters:** threshold 0.75; base radius 10px; channel radii 1.4, 1.0 and 0.7 of base [S24]; bloom 0.04 [S27].
- **Sound:** a relay click and a low electrical hum fading in.
- **Build:** 5.2 and 5.3.
- **Rules:** `card`; never on the mark.

### M20. Datamosh handover
- **The move:** for 14 frames the incoming scene's motion drags the outgoing picture's pixels with it; on the downbeat the clean new frame lands.
- **Where:** overload, "the old way breaks".
- **Timing:** 14 frames, landing on a beat.
- **Parameters:** drag at 1.0x the incoming motion; no crossfade.
- **Sound:** the outgoing music bit-crushed for those frames, cut clean at the landing.
- **Build:** 2.17, cached.
- **Rules:** `card`.

### M21. Pixel-sort decay
- **The move:** an image melts downward as its brighter runs sort into streaks, then the streaks fade into the ground.
- **Where:** decay, context lost.
- **Timing:** a 1.5s sort sweep, then a 0.5s fade.
- **Parameters:** threshold from 0.95 to 0.4; runs capped at 35% of the frame height; columns only [S71].
- **Sound:** a descending granular texture.
- **Build:** 8.13.
- **Truth note:** in supermemory films, forgetting is never shown as deletion (motion-systems §3). Use this for the old way (a chat that loses its context), never for supermemory's own forgetting.

### M22. Type poster takeover
- **The move:** the frame becomes a three-size type poster: blocks cut in on beats, one word cropped full-bleed, one word in the brand blue.
- **Where:** a manifesto or launch statement.
- **Timing:** five words on five consecutive beats, on twos; a 1.5s hold.
- **Parameters:** Geist 900, 400 and 100; sizes in the ratio 8:2:1; one word cropped by the frame.
- **Sound:** one hit per block from the kit's own sounds; the last block silent.
- **Build:** 4.8.
- **From:** the Public Theater identity [lead S75].

### M23. Echo collapse
- **The move:** a verb slides across 30% of the frame and leaves six outline echoes, which collapse into the solid word on the next beat.
- **Where:** a single action word in a statement.
- **Timing:** the slide 400ms; echoes 2 frames apart at opacity 0.5^n; the collapse 350ms on the beat.
- **Sound:** a short tape-delay echo of the slide's sound that collapses with it.
- **Build:** 1.9.

### M24. Line boil to ink
- **The move:** an idea is sketched as boiling lines; on the beat the boil stops, the lines thicken and fill, and from then on it is clean vector.
- **Where:** "the idea becomes real".
- **Timing:** boil for 2.0s (reseeded 12 times a second, 1px); thicken 1 to 3px over 250ms; fill over 200ms.
- **Sound:** pencil scratching, then one pen click on the beat.
- **Build:** 5.13 and 1.8.

### M25. Archive versus now
- **The move:** the old way plays as an archive (a 4:3 inset with gate weave, grain, dust, stepped at 18fps, warm); at the turn the frame widens to full-bleed, clean, 60fps, in the brand palette.
- **Where:** before and after.
- **Timing:** the widening over 700ms; weave, grain and dust stop on the frame the widening starts.
- **Parameters:** weave X 0.4px, Y 0.8px, period 5 frames; grain σ 0.03; about one speck per frame; +1,200K warm grade; steps at `floor(t·18)/18`.
- **Sound:** projector rattle and narrow mono audio, a beat of silence, then clean stereo.
- **Build:** 5.5, 5.6, 5.1, 6.7 and 4.6.

### Spare M26. Voronoi re-sort
- **The move:** an image shatters into Voronoi cells with exact borders; the cells drift and turn slightly, then slide into a tidy grid of tiles ordered by colour or topic.
- **Timing:** shatter 300ms; drift 800ms; sort 900ms with 20ms between ranks.
- **Sound:** ceramic tile clicks.
- **Build:** 8.7.

### Spare M27. Bar-carried title
- **The move:** two thin bars carry a title on, slice it into three bands that offset by 6% of the cap height on the beat, and carry it off; only on/off and left/right.
- **Timing:** bars at 1.5 frame widths a second; the slice takes 2 frames.
- **Sound:** dry string stabs on each move.
- **Build:** 1.7.
- **From:** Psycho [S40].

---

## 12. Sources and evidence ledger

All pages accessed 2026-10-15, read only, nothing downloaded except two PDFs that WebFetch cached for text extraction (the typing study and Stable Fluids). "Read" = the page itself was opened and the passage found. "Lead" = known only from a search summary or a secondary write-up; the claim is labelled `lead` where it is used.

| ID | Source | URL | How read | Supports | Does not establish |
|---|---|---|---|---|---|
| S1 | Material Components for Android, Motion theming doc | https://github.com/material-components/material-components-android/blob/master/docs/theming/Motion.md | read | Material 3 easing curves, 16 duration tokens, standard spring tokens, transition patterns and their durations and fade thresholds | the m3.material.io pages (they did not render) |
| S2 | AndroidX Compose `ExpressiveMotionTokens.kt` | https://raw.githubusercontent.com/androidx/androidx/androidx-main/compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/tokens/ExpressiveMotionTokens.kt | read | expressive spring damping and stiffness values | how Google applies them in its own films |
| S3 | IBM Carbon, Motion overview | https://carbondesignsystem.com/elements/motion/overview/ | read | productive and expressive curves, duration tokens, duration grows with distance | |
| S4 | Apple WWDC23 "Animate with springs" | https://developer.apple.com/videos/play/wwdc2023/10158/ | read | duration and bounce model, stiffness formula, bounce guidance, velocity kept on retarget | the damping line, printed garbled on the page (checked instead with the S79 probe) |
| S5 | Josh W. Comeau, "A Friendly Introduction to Spring Physics" | https://www.joshwcomeau.com/animation/a-friendly-introduction-to-spring-physics/ | read | why springs feel physical; most of his springs are not bouncy | recommended defaults (none given) |
| S6 | Emil Kowalski, "Great animations" and "You don't need animations" | https://emilkowal.ski/ui/great-animations , https://emilkowal.ski/ui/you-dont-need-animations | read | UI under 300ms, frequency rule, ease-out for responsiveness | film timing |
| S6c | Vaul source constants (Emil Kowalski) | https://raw.githubusercontent.com/emilkowalski/vaul/main/src/constants.ts | read | `(0.32, 0.72, 0, 1)`, 0.5s | |
| S7 | Rauno Freiberg, "Invisible details of interaction design" | https://rauno.me/craft/interaction-design | read | spatial consistency, interruptibility, frequency and novelty | numeric timings (none given) |
| S9 | Wikipedia, Twelve basic principles of animation | https://en.wikipedia.org/wiki/Twelve_basic_principles_of_animation | read | anticipation, follow-through and overlap, arcs, timing | ones versus twos (not covered there) |
| S10 | Inigo Quilez, palettes | https://iquilezles.org/articles/palettes/ | read | cosine palette formula and example sets | |
| S11 | Inigo Quilez, 2D distance functions | https://iquilezles.org/articles/distfunctions2d/ | read | primitive list, `opRound`, `opOnion`, code | |
| S13 | Inigo Quilez, Voronoi edges | https://iquilezles.org/articles/voronoilines/ | read | two-pass exact borders, the border formula | |
| S14 | Tyler Hobbs, "Flow Fields" | https://www.tylerxhobbs.com/words/flow-fields | read | grid spacing, noise scale, step length, start strategies, collision, quantised angles | |
| S15 | Karl Sims, Reaction-Diffusion tutorial | https://www.karlsims.com/rd.html | read | constants, Laplacian weights, mitosis and coral pairs, varying f and k across space | the equations (an image on the page) |
| S16 | Craig Reynolds, Boids | https://www.red3d.com/cwr/boids/ | read | three rules, neighbourhood, emergence, O(n²) note | numeric weights (mine) |
| S17 | Ding and Batty, "Differentiable Curl Noise" (2023), analysing Bridson et al. 2007 | https://cs.uwaterloo.ca/~c2batty/papers/Ding2023/Differentiable_Curl_Noise.pdf | lead (search summary of the paper's content) | curl of a potential is divergence-free; boundary ramps | the 2007 paper's own text (not opened) |
| S18 | Pavel Dobryakov, WebGL Fluid Simulation `script.js` | https://github.com/PavelDoGreat/WebGL-Fluid-Simulation | read | default config and step order | |
| S19 | Jamie Wong, "Metaballs and Marching Squares" | https://jamie-wong.com/2014/08/19/metaballs-and-marching-squares/ | read | field, threshold, marching squares, interpolation | |
| S20 | Surma, "Ditherpunk" | https://surma.dev/things/ditherpunk/ | read | linear-light dithering, Bayer recursion, blue noise, kernels, Atkinson loss, Riemersma | |
| S21 | Fabien Sanglard, "Fizzlefade" | https://fabiensanglard.net/fizzlefade/ | read | 17-bit LFSR, mask, every pixel once | wall-clock duration |
| S22 | Golan Levin, "An Informal Catalogue of Slit-Scan Video Artworks" | http://www.flong.com/archive/texts/lists/slit_scan/index.html | read | history and variants (x, radial, maps) | |
| S23 | Andrey Norkin, AV1 film grain synthesis | https://norkin.org/research/film_grain/ | read | AR model, template and block sizes, scaling function | blending weights (in his DCC 2018 paper) |
| S24 | "Deep Analog" (arXiv 2608.14702, 2026), HTML | https://arxiv.org/html/2608.14702 | read (first 100k characters) | grain octaves and ranges, halation threshold, channel radii, strength cap | that these match any specific film stock |
| S25 | Frame.io, "How a Pro Colorist Uses Film Grain" (2023) | https://blog.frame.io/2023/08/14/how-a-pro-colorist-uses-film-grain/ | read | about 30% opacity, "felt rather than seen", soften before grain | numeric blur |
| S26 | Dehancer, "Halation and its simulation" | https://blog.dehancer.com/articles/halation/ | read | the physics, the look, LED versus incandescent | radii or intensities |
| S27 | LearnOpenGL, "Physically Based Bloom" | https://learnopengl.com/Guest-Articles/2022/Phys.-Based-Bloom | read | mip count, filters, mix 0.03 to 0.15, no threshold, Karis average | |
| S28 | Dehancer Gate Weave and Film Breath | https://dehancer.com/learn/article/gate-weave | lead (search summary) | the model's controls | pixel amplitudes (mine) |
| S29 | Wikipedia, Vignetting | https://en.wikipedia.org/wiki/Vignetting | read | cos⁴ law, artistic use | |
| S30 | Wikipedia, Chromatic aberration | https://en.wikipedia.org/wiki/Chromatic_aberration | read | lateral versus axial; radial channel scaling corrects lateral | that fringing grows toward the edges (not stated) |
| S31 | Wikipedia, Distortion (optics) | https://en.wikipedia.org/wiki/Distortion_(optics) | read | Brown-Conrady radial model, barrel and pincushion | |
| S32 | Wikipedia, Focus breathing | https://en.wikipedia.org/wiki/Focus_breathing | read | definition | magnitudes |
| S33 | Wikipedia, Dolly zoom | https://en.wikipedia.org/wiki/Dolly_zoom | read | width formula, Vertigo, Irmin Roberts | |
| S34 | Wikipedia, Multiplane camera | https://en.wikipedia.org/wiki/Multiplane_camera | read | layer speeds, up to seven layers, The Old Mill | |
| S35 | Held, Cooper, O'Brien, Banks, "Using Blur to Affect Perceived Distance and Size" (ACM TOG 2010) | https://escholarship.org/uc/item/3ts0x35k | lead (abstract and summaries) | blur gradients change perceived size; tilt-shift in its keywords; later work on orientation | which gradients the 2010 experiment tested |
| S35b | Wikipedia, Tilt-shift photography | https://en.wikipedia.org/wiki/Tilt%E2%80%93shift_photography | read | miniature faking by post blur | the perceptual explanation |
| S36 | Wikipedia, Powers of Ten (film) | https://en.wikipedia.org/wiki/Powers_of_Ten_(film) | read | one power of ten per 10s out, per 2s back in, overhead opening | an on-screen indicator in 1977 |
| S37 | de Smit and Lenstra, Escher and the Droste effect (Leiden) | https://pub.math.leidenuniv.nl/~smitbde/escherdroste/ | lead (search summary) | 157.6° and 22.58 | |
| S38 | Art of the Title, Stranger Things | https://www.artofthetitle.com/title/stranger-things/ | read | Benguiat, hollow letters sliding, red edges, scanned 35mm grain, "simple is sometimes the hardest" | runtime |
| S39 | Art of the Title, Se7en | https://www.artofthetitle.com/title/se7en/ | read | scratched type, kept printing accidents, hand assembly | flash frames |
| S40 | Art of the Title, Psycho | https://www.artofthetitle.com/title/psycho/ | read | bars carrying titles, on/off, left/right, up/down vocabulary | split type, timings |
| S41 | Art of the Title, North by Northwest | https://www.artofthetitle.com/title/north-by-northwest/ | read | grid, tethered columns, dissolve into a facade | |
| S42 | Art of the Title, Panic Room | https://www.artofthetitle.com/title/panic-room/ | read | 3D type in plates, Copperplate, static shots over a CG fly-through | the lighting process |
| S43 | Art of the Title, Enter the Void | https://www.artofthetitle.com/title/enter-the-void/ | read | a face per name, tuned to the track, "retinal persistence" | cut rate |
| S44 | Art of the Title, Zombieland | https://www.artofthetitle.com/title/zombieland/ | read | type as a character, built in 3D, lit per scene | letter-by-letter physics |
| S45 | Art of the Title, Vertigo | https://www.artofthetitle.com/title/vertigo/ | read | John Whitney's "Lissajous" spirals | how they were made |
| S46 | Figma, "Crafting the visual identity for Config 2024" | https://www.figma.com/blog/config-2024-branding/ | read | four motion principles, letterforms morphing into primitives, motion library, custom sound per video | timing rules |
| S47 | Figma, "How we shaped the visual identity for Config 2025" | https://www.figma.com/blog/how-we-shaped-the-visual-identity-for-config-2025/ | read (first 100k characters) | 60 to 15fps, ripple between glyphs, expressive vs functional type, orchestra cue | |
| S48 | Basement, "Behind the Ship" (Vercel Ship 2025) | https://basement.studio/post/behind-the-ship | read | animated by hand on twos, no templates, silhouette material, warm grade | type, sound |
| S49 | Cartoon Brew, Imageworks on Spider-Verse | https://www.cartoonbrew.com/feature-film/if-its-not-broke-break-it-sony-imageworks-renegade-approach-to-spider-man-into-the-spider-verse-167321.html | read | mostly twos, no motion blur, smears, misprinted colour for focus, dot patterns, Kirby dots | per-character ones versus twos (from secondary summaries) |
| S50 | Studio Dumbar, OpenAI ongoing collaboration | https://studiodumbar.com/work/openai | read | organic motion across OpenAI's brand, restraint, shader work for ChatGPT's Advanced Voice mode | timings, curves or rules (none on the page) |
| S50b | Studio Dumbar, DEMO | https://studiodumbar.com/work/demo | read | variable face reshaped by a script per word | animation details |
| S51 | Motionographer interview, Buck "Good Books" | https://motionographer.com/2012/03/26/interview-buck-good-books-metamorphosis/ | lead (search summary) | continuous morphing film; Antfood's audio carried the transitions | |
| S53 | Collins, Spotify | https://www.wearecollins.com/work/spotify/ | lead (search summary) | duotone system, the Colorizer tool | |
| S54 | Dhakal, Feit, Kristensson, Oulasvirta, "Observations on Typing from 136 Million Keystrokes" (CHI 2018) | https://userinterfaces.aalto.fi/136Mkeystrokes/ (PDF: https://www.pokristensson.com/pubs/DhakalEtAlCHI2018.pdf) | read (text extracted from the PDF) | IKI mean 238.66ms SD 111.6, floor about 60ms, fast 120ms SD 11, slow over 480, keypress 116ms, rollover 25% and 49.9% | error-rate figures (not extracted) |
| S55 | NumberFlow | https://number-flow.barvian.me/ | read | trend, masks, example timings, continuous mode, tabular numbers | documented default timings |
| S56 | Netflix, English (USA) Timed Text Style Guide | https://partnerhelp.netflixstudios.com/hc/en-us/articles/217350977-English-USA-Timed-Text-Style-Guide | read | 20 characters per second (adult), 42 per line | durations |
| S57 | W3C, Understanding SC 2.3.1 | https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html | read | three flashes a second, flash definitions, area | |
| S58 | ITU-R BT.1359 | https://www.itu.int/rec/R-REC-BT.1359/en | lead (secondary summaries) | +45/−125ms detectability, +90/−185ms acceptability; ATSC 15/45ms | |
| S59 | Spotify for Artists, loudness normalisation | https://support.spotify.com/us/artists/article/loudness-normalization/ | read | −14 LUFS, −1 dBTP (−2 if louder) | other platforms (time-sensitive) |
| S60 | Google, ABCDs of YouTube video ad creative | https://business.google.com/us/think/future-of-marketing/youtube-video-ad-creative/ | read | open mid-action or close-up, bold sound, brand inside the story, focused message | a "first five seconds" number (in the PDF guide, not opened) |
| S61 | Facebook research via Marketing Dive and Social Media Today (2016) | https://www.marketingdive.com/news/facebook-why-mobile-video-ads-must-work-fast/446217/ | lead (search summary) | recall after 0.25s; 24% of 965 ads understandable sound-off | method, sample sizes |
| S62 | Apple Newsroom, "Apple Presents iPod" (2001) | https://www.apple.com/newsroom/2001/10/23Apple-Presents-iPod/ | read | "1,000 Songs in Your Pocket" | |
| S63 | Walter Murch's Rule of Six, via No Film School and others | https://nofilmschool.com/2016/11/6-rules-good-cutting-according-oscar-winning-editor-walter-murch | lead (search summary) | the six criteria and weights | the book's wording |
| S64 | Wikipedia, Match cut | https://en.wikipedia.org/wiki/Match_cut | read | graphic match definition, 2001 | Lawrence of Arabia (not on the page) |
| S65 | Wikipedia, Split edit | https://en.wikipedia.org/wiki/Split_edit | read | J and L cuts and uses | timings |
| S66 | Wikipedia, Mickey Mousing | https://en.wikipedia.org/wiki/Mickey_Mousing | read | definition and criticism | |
| S67 | Wikipedia, Traffic (2000 film) | https://en.wikipedia.org/wiki/Traffic_(2000_film) | read (first 100k characters) | per-storyline grades, 45° shutter | |
| S68 | Pixar colour scripts via MoMA audio and StudioBinder | https://www.moma.org/audio/playlist/192/2575 | lead (search summary) | Eggleston's Toy Story colour scripts; one per film after; Up's colour arc | |
| S69 | Björn Ottosson, "A perceptual color space for image processing" | https://bottosson.github.io/posts/oklab/ | read | matrices, blending behaviour, hue error | |
| S70 | Alex Harri, "ASCII characters are not pixels" (2026) | https://alexharri.com/blog/ascii-rendering | read | six circles, shape vectors, contrast enhancement, caching | some exact values (garbled in extraction) |
| S71 | Kim Asendorf, ASDFPixelSort | https://github.com/kimasendorf/ASDFPixelSort (source `ASDFPixelSort.pde`) | read | modes, thresholds, columns then rows, 2010 | |
| S72 | Wikipedia, Halftone | https://en.wikipedia.org/wiki/Halftone | read | AM and FM, dot shapes and meeting points, 85 lpi newsprint, rotation against moiré | CMYK angle values |
| S73 | Wikipedia, Datamoshing | https://en.wikipedia.org/wiki/Datamoshing | read | interpolation from two sources, Welcome to Heartbreak | I-frame mechanics |
| S74 | Kogonada, "Kubrick // One-Point Perspective" (Vimeo) | https://vimeo.com/48425421 | title confirmed (Vimeo verification page) | the reference exists | its content (not watched) |
| S75 | Paula Scher's Public Theater identity, via Cooper Hewitt and Typeroom | https://www.cooperhewitt.org/2018/04/05/everyones-public-theater/ | lead (search summary) | wood type, clashing faces, hierarchy | |
| S76 | The Vignelli Canon, via secondary commentary | https://andrewclark.super.site/all-media/the-vignelli-canon | lead (search summary) | grid first, white space as silence, few sizes | the book's wording |
| S77 | Rune Skovbo Johansen, Surface-Stable Fractal Dithering | https://runevision.com/tech/dither3d | read | Obra Dinn's sphere compromise; dots stuck to surfaces at constant screen size | the mechanism (in his video) |
| S79 | Local probes on this Mac (this run) | session scratchpad: `axes.swift`, `adv.swift`, `cif.swift`, `spring.swift` | run | Geist and Geist Mono weight 100 to 900; Geist Mono fixed advance; Geist +17% width from 100 to 900; SF and New York axes; 58 CoreImage filters present; serif families installed; SwiftUI `Spring(duration:bounce:)` parameters | licences |
| S80 | Sound-design practice (Sono Sanctus interviews, Artlist, Epidemic, others) | https://motionographer.com/2019/04/11/soundon-with-sono-sanctus/ | lead (search summary) | outcome-first sound, whoosh and hit anatomy | numeric mix levels |
| S82 | Squirrel Eiserloh's GDC 2016 camera talk via Game Developer and implementations | https://www.gamedeveloper.com/programming/video-sprucing-up-cameras-with-math | lead (search summary) | trauma squared or cubed times noise; rotation-only shake in 3D | the talk's own numbers |
| S83 | ManvsMachine via Motion Array and Cannes Lions entries | https://motionarray.com/learn/motion-design/studio-spotlight-manvsmachine/ | lead (search summary) | edit locked to soundtrack (Air Max); procedural megacity (iMac Pro) | |
| S87 | Thomas Jakobsen, "Advanced Character Physics" | https://www.gamedeveloper.com/programming/advanced-character-physics | read | Verlet step, relaxation, one pass often enough, sqrt approximation | rope settings |
| S89 | Jos Stam, "Stable Fluids" (SIGGRAPH 1999) | https://www.dgp.toronto.edu/public_user/stam/reality/Research/pdf/ns.pdf | read (text extracted from the PDF) | method of characteristics, projection, unconditional stability, numerical dissipation | |
| S90 | GameTechWiki, CRT-Royale | https://emulation.gametechwiki.com/index.php/CRT-Royale | lead (search summary) | beam sigma range, mask types and resolutions | |
| S90b | CRTLottes port for Godot 4 | https://godotshaders.com/shader/crtlottes-for-godot-4-x/ | lead (search summary) | Lottes parameter defaults | that these are Lottes' originals |
| S91 | Wikipedia, L-system | https://en.wikipedia.org/wiki/L-system | read | fractal plant rules, angle 25°, Lindenmayer 1968 | |
| S-caret | Microsoft caret docs, wxWidgets caret source, a Windows FAQ page | https://learn.microsoft.com/en-us/windows/win32/menurc/about-carets | lead (search summary) | blink time is a user setting; 500ms wxWidgets default; 530 reported | a macOS default |

**Leads used in passing (search listings only):** &Form's Tokyo Dome City variable face (It's Nice That); Framer marketplace curved-text components; Ben Marriott's Adobe MAX 2022 session listing (overlapping action among its topics). None of them carries a number used here.

---

## 13. Gaps, conflicts and corrections

1. **A rule to correct.** Anti-house rule 13 sets real typing at "40 to 120ms a key". The measured average is 239ms (SD 112), the floor about 60ms, and fast typists average about 120ms [S54]. Proposed wording: "90 to 180ms a key with pauses at word breaks; 120ms average for a fast typist".
2. **Apple's damping formula** is printed in a garbled form on the WWDC page [S4]. Resolved this run: SwiftUI's `Spring(duration:bounce:)` on this Mac gives damping `(1 − bounce)·4π/duration` for bounce 0 to 0.4, a damping ratio of exactly `1 − bounce` (7.2). Negative bounce reports a different, unexplained stiffness, so the atlas does not use it.
3. **Two Quilez pages failed to load** (smooth minimum, domain warping) with 404s on redirect. The smooth minimum is already in the engine; the domain-warp offsets in 8.11 are from memory and marked unverified.
4. **Studios with no numbers.** Buck, ManvsMachine, Ordinary Folk, Collins, Pentagram and DixonBaxi surfaced only through project pages and search summaries: they publish looks, rarely parameters. Gunner, Tendril, Oddfellows, Giant Ant, Golden Wolf, Koto and W+K motion were not reached with any craft detail this run. The written craft came from title designers (Art of the Title), two product brands that publish making-ofs (Figma Config, Vercel Ship via Basement), Imageworks on Spider-Verse, and the creative-coding writers.
5. **Launch films without making-ofs.** For Linear, Stripe Sessions, Arc, Raycast, Rabbit, Humane, Notion, Cursor, OpenAI and Anthropic, no behind-the-scenes text with craft parameters was found. Linear appears to make its films in-house (a Motion Storyteller job listing); Studio Dumbar describes OpenAI's motion only as organic and restrained [S50]. Watching those films frame by frame would need downloads, which this lane did not do; lane C's study of her bookmarks covers some of them by measurement.
6. **"Jake Moran"** could not be identified as a motion designer. Nearest matches: Jake Bartlett ("Jake in Motion") and Jake Moraru (After Effects tutorials). Not used.
7. **Nothing was watched.** Every "Seen in" reflects what the cited page says about a film, not a frame-by-frame measurement.
8. **Craft defaults without a source this run:** the crane move, speed ramps, colour-match tolerances, room-tone level, the rule of three, scanline counts, dust and scratch rates, CMYK screen angles, and the 9:16 safe zones. They are marked "start at" and should be tuned by eye.
9. **The reading-time rule** (`0.4s + characters/15`) is my adaptation of subtitle standards [S56] for moving pictures; it is stricter than Netflix's cap on purpose.
10. **Old and platform-framed evidence.** Facebook's 0.25s and 24% figures date from 2016 and come from the platform's own research via press [S61]. Loudness targets are time-sensitive [S59].
11. **Licences.** SF Pro and New York are Apple fonts licensed for Apple UI work; the macOS serif families need a licence check before a published commercial film. Geist and Geist Mono (the brand faces) are the safe variable fonts.

---

## 14. If I were building next (in this order)

1. **A curve-family switch and closed-form springs** (7.1, 7.2): every film picks a family, and the engine enforces it. Cheap, and it removes the single-spring watermark.
2. **Variable Geist** (1.1, M2): one helper, `geist(weight:)`, with the fixed-slot layout rule. Unlocks the weight tide, the poster frame (M22) and type at many weights without new fonts.
3. **Per-layer time steps and a shutter-angle setting** (7.8, 3.10, M6, M7): small changes to the render loop with a large effect on how hand-made the films feel.
4. **A depth stack with focus** (3.1, 3.4, M5, M12): lane C's biggest gap. `CIMaskedVariableBlur` makes the first version a day's work.
5. **The film-finish pass** (5.1, 5.2, 5.5): grain on the AV1 model, halation with channel radii, gate weave; one Metal kernel, used only when a style card asks.
6. **A match-cut helper in the seam table** (2.1, M15): a seam type whose survivor changes identity, checked for position, size and speed.
7. **The editorial serif language** (1.12, 4.8): the anti-house list's first "still to build".
