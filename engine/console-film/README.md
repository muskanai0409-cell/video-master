# Worked example: the "one command" console film (sources only)

These are the sources of `one-command-v6`, an 18s 4K film made on 2026-10-06. It shows a supermemory console card
rebuilt in vector from the live page's measured DOM, the universal command copied and run in a typeset terminal,
each agent's tab clicked, the plugins orbiting the supermemory tile, and an end card. It also has a 160 BPM synth score,
Kenney CC0 sound effects, and the supermemory.ai hero film as the background, cut on the music's hits. Use it as the
template for product films built from real UI.

- **Not included:** the fonts (`fonts/`, the same Geist files as `../assets/fonts`), the console's agent logos
  (`logos/`), the SFX (`sfx/*.f32`, from her Kenney CC0 pack zip), the score stems and the 6 GB background plate.
  `make.sh` rebuilds the plate from `bg/field.mp4` (supermemory.ai/brand/media/field.mp4). Ask her before you download it.
- **Build:** `cat lib.swift term.swift timeline.swift film_bg.swift film.swift > render.swift && swiftc -O render.swift -o render`,
  then `./make.sh`. The score is built with `cat timeline.swift sound.swift > snd.swift && swiftc -O snd.swift -o snd && ./snd`.
  `sky.swift` is the rejected v5 computed dawn, kept as a reference. Use it instead of `film_bg.swift` to build v5.
- **Frames render one at a time:** CoreGraphics drawing on several threads made renders unrepeatable. See
  `../../references/lessons.md`.

The full version history and QA follow (her notes per version, what changed, the measured results).

---

# one-command v6 (current): the supermemory.ai hero film behind everything

`../one-command-v6-4k.mp4` and `../one-command-v6-1080p.mp4`: v5's cut, score, timing and render fixes, on a new
background. Her notes (2026-10-06): "i dont like the background, can we have something from here" (a screen recording of the
supermemory.ai hero), and "choose what looks the best and which makes the whole video look the best and very very
polished".

- **Source:** the hero film itself, `supermemory.ai/brand/media/field.mp4` (1280x720, 25fps, 32s, 2.3 MB), downloaded
  with her OK into `bg/field.mp4`. Six scenes cut every 4s: cosmos (0-2, 22-32), blossoms, rock, thistles with orange
  memory tiles, mountain over clouds, a flower. The site shows it under a multiply tint (`#0562ef` at 62%), so the plate
  bakes in the same tint: each channel x (0.392, 0.618, 0.961). The plate's cosmos averages `(3,62,199)`; her recording
  of the site averages `(6,61,193)`.
- **Plate:** `bg/plate_2112x1188.rgb` is all 800 frames, lanczos-scaled to 1.1x the frame (headroom for parallax), raw
  RGB, 6 GB. make.sh rebuilds it from `bg/field.mp4` if it's missing. `film_bg.swift` replaces `sky.swift` in the build.
- **Edit, every cut on a hit:**

  | Time | Scene |
  |---|---|
  | 0 to 3.0 | Cosmos (film 22-25s) under the console |
  | 3.0 (drop) to 6.0 | Rock, seen at the edges of the terminal |
  | 6.0 to 11.25 | Cosmos again (film 25-30.25s), as if it had kept playing |
  | 11.25 (card falls) to 14.625 | Mountain over clouds, behind the plugin ring |
  | 14.625 (final hit) to 16.5 | Cosmos for the line, slowing to a stop at the still |

  The film's 25fps frames are blended to play smoothly at 60fps, and never across the film's own cuts. The thistles
  were tried behind the tabs and dropped: the orange tiles crowded the white logo chips, and the fine detail showed
  the 720p softness at 1.9x.
- **Recoloured for a blue ground (the brand's paper-on-blue colourways):**
  - ring lines and memory dots are white;
  - the centre tile is white with a blue mark;
  - "give your agents" is white at 78% and "persistent memory" is white;
  - the lockup and the corner mark are white;
  - the "or one by one" label is a white box with blue text;
  - the command chip is plain white.
- The v5 dawn is kept in `sky.swift` / `film_v5.swift` / `make_v5.sh`.

**QA (decoded, 2026-10-06):**
- 4K is 28.0 Mb/s (63 MB). 1080p is 10.4 Mb/s (24 MB), a lanczos cut of the 4K. Both are 60fps, 18.00s, bt709.
  Moving footage costs more bits than the v5 sky.
- **84.0% moving.**
- **Pop check:** it flags 4 frames, at 3.000, 6.000, 11.250 and 14.633s. These are exactly the four planned scene
  cuts. Each was checked frame by frame: a clean one-frame cut, with no stray frame from the wrong scene.
- **End hold:** 89 identical decoded frames in the 1080p and 88 in the 4K. The film eases into the still (frame steps
  0.005, 0.004, 0.002, 0.001, then 0), so the background doesn't stop dead.
- **Audio:** -13.8 LUFS, peak -3.3 dBFS. The audio is the same as v3 to v5.
- **Decoded colours:** white tile and white chip `#fdfdfd`. The end-card ground at top left is `#0232ba`.

---

# one-command v5: the supermemory dawn, in code

`../one-command-v5-4k.mp4` and `../one-command-v5-1080p.mp4`: v4's cut, score and timing, but the white dot-grid
ground is replaced by a background computed in code (`sky.swift`). Her note (2026-10-06): "make it supermemory
background coded, like some pretty background".

- **Source:** supermemory.ai's own art. The site's closing panel uses `brand/media/cta-dawn.jpg`: a blue dawn sky, a
  warm sun, and a dot-matrix sun on a regular grid. Colours were sampled from that photo on 2026-10-06 (sky `#587eb5`
  / `#5c8ac0` / `#729ac6`, glow `#cfcdd9` / `#e4dbda` / `#e7dac8`, sun `#dfa454`). Nothing is the photo. Every
  pixel is computed, so it stays sharp at 4K.
- **Sky:** vertical blue gradient plus four elliptical glows (halo, mid, amber, core), computed at quarter resolution,
  then bilinear up with a triangular dither of about 1.6 levels, which removes 8-bit banding and reads as fine grain. Soft
  vignette.
- **The sun rises through the film:** it sits low behind the console (a warm glow under the card), climbs 210px over
  the first 11.25s, then rises into the middle of the plugin ring as the card falls away (12.35s). The headline lands
  on its core.
- **Dots (the brand memory field):** a 12px grid of white squares. The sun's dots fill its middle, with an edge set by
  an 8x8 Bayer threshold (the brand halftone: threshold, never blurred). A sparse 2.2% of the grid lights up across
  the sky over the film, one memory at a time. On every hit (enter, the four tab clicks, the second drop, the
  headline) a ring runs out from the sun, and the dots it crosses turn 45° (the brand's "recalled" state) and brighten.
  Gentle twinkle that settles before the still.
- **Clearspace:** no dots around the blue tile (1.5x its size), the corner mark, the headline (80% cleared) or the
  lockup and command.
- **Parallax:** the sky moves 6% as far as the world and zooms by the 0.2 power of the camera, so the camera keeps its
  depth. It reaches zero at the end, so the sun sits exactly behind the ring.
- **Unchanged:** the console card, terminal, ring, end card, timing and `audio/master.wav`.
- **Render fix (v4 had this bug too):** rendering frames on several threads at once sometimes made CoreGraphics get
  edge coverage wrong on the card and terminal outlines, and once a colour (a green 1px terminal edge). In v4, 120
  of the first 400 frames differed between two runs of the same code. Now all CoreGraphics drawing happens on one
  thread, and only pure maths (sky pixels, motion-blur averaging) runs in parallel. Two full renders are
  byte-identical, and match a one-frame-at-a-time render.
- **Encode:** the grain made x264 keep refining the still, so both cuts switch to near-lossless (`q=1`) at frame 921
  (15.35s). That falls inside the lockup's motion, so the switch is hidden and doesn't show as a snap on the still.

**QA (decoded, 2026-10-06):**
- 4K is 3840x2160 at 15.9 Mb/s; 1080p is a lanczos cut of the 4K at 6.4 Mb/s. Both are 60fps, 18.00s, bt709.
- **84.2% moving.** No still stretch before the end card, and 0 pop candidates.
- **End hold:** 90 identical decoded frames in each cut. The frame step into the hold is 0.000.
- **Audio:** -13.8 LUFS, peak -3.3 dBFS. The audio is the same as v3 and v4.
- **Decoded colours:** blue tile `#0260ed` (source `#0562ef`, normal 4:2:0 rounding), white chip `#fdfdfd`, top-left sky
  `#5675a7`, sun core `#eee5d7`. The sky shows no banding.
- **Repeatable render:** two full 1080p renders produced 1080 of 1080 identical frames.
- **Brand note:** the pack's console-film rule says "flat brand fields, not gradients". This background breaks that
  rule because she asked for it, and it uses the site's own dawn art and memory-field grammar, not invented
  decoration. The previous ground is kept in `film_v4.swift` / `make_v4.sh`.

---

# one-command v4: everything bigger

`../one-command-v4-4k.mp4` and `../one-command-v4-1080p.mp4`: same 18.0s cut, same score and timing as v3, with
everything larger while every element stays in frame. Her note (2026-10-06): "make everything a bit bigger, increase
the fonts a bit more, still incorporating everything".

- The card's width is the limit (zooming further would crop it), so the console's type, icons and row heights are set
  **12% larger than the page** (`US = 1.12`) at the same card width; the eight pills are re-packed with the page's own
  spacing rules (11px padding, 7px icon gap, 6px apart) and still all fit (13 to ~940 of 976). Combined with closer
  framing, card text goes from ~23px to ~27px on screen. This is a legibility choice, not the page's exact sizes.
- Camera: full-card shots at 1.86-1.93x (card fills ~95% of the width), the copy push at 2.6-2.74x.
- Terminal: 15 → 17px type, 22 → 25px lines, window 616 tall, framed at 1.7x: ~29px on screen (was ~22px).
- "or one by one" label 20 → 26px; lift chips and pops larger.
- Ring: radius 300 → 336, chips 104 → 122, tile 176 → 204. End card: headline 112 → 128px, lockup 360 → 430 wide,
  command 22 → 27px.
- Audio: unchanged `audio/master.wav` (-13.8 LUFS), still in sync because the timeline did not move.

---

# one-command v3 (current): music, sound and the orbiting plugins

`../one-command-v3-4k.mp4` and `../one-command-v3-1080p.mp4`, 18.0s, 60fps, AAC 256k stereo at **-13.8 LUFS**,
true peak -3.3 dBTP. Silent masters: `../one-command-v3-*-silent.mp4`. Stems: `audio/music.wav`, `audio/sfx.wav`,
`audio/master.wav`.

Her notes on v2 (2026-10-06): add cool fast music and sounds; bring back the motion graphic with the supermemory logo
in the middle and all the plugins spinning around it.

**What changed**
- The picture moved onto a 160 BPM grid (beat 0.375s, bar 1.5s), shared with the score through `timeline.swift`,
  per the pack rule "move the picture to the music". Shifts from v2: copy 1.40 → 1.50, lands 2.62 → 2.625,
  enter 2.95 → 3.00, after install 4.90 → 4.875, back to the tabs 6.35 → 6.00, tab clicks 7.15/7.85/8.55/9.25 →
  7.50/8.25/9.00/9.75, lift 10.0 → 10.5, end 10.45 → 11.25. Length 14.5 → 18.0s.
- The ring: seven plugins (every console tab except AmpCode, whose npm package is a 404) lift out of their pills on
  16ths, the card drops away, they fly into orbit around the blue supermemory tile with blue connector lines and dots of
  memory flowing in, spin 300° on the second drop with the tile pulsing on every kick, swirl into the tile at 14.25,
  and the final hit at 14.625 brings "give your agents / persistent memory", then the lockup and the command.

**Sound (register C, music plus physical effects, scene changes on hits)**
- Score: synthesised in `sound.swift` (no stock music, no generative audio model). 160 BPM, F minor
  (Fm, Db, Ab, Eb), 808/909-style drums, sub bass, supersaw chord stabs with sidechain pumping, a pluck hook with a
  dotted-eighth ping-pong delay, a Freeverb room. Arrangement: intro pad + arpeggio (the copy click is the first kick),
  a snare roll into the **drop on enter**, a break under "or one by one", a groove where **every tab click lands on a
  kick**, a build while the plugins lift out, the **second drop as the ring spins**, a final Fm9 hit on the line.
- Effects: real CC0 Kenney recordings for the copy and tab clicks, the paste key, the enter key (aligned to its thock,
  168 ms into the sample) and the typing; tuned pops for each logo; a soft bell dyad for "one approval" and the lockup;
  the felt thump exactly twice (card drops, line lands). No whooshes.
- Mix checks: band RMS <120 Hz -15.3, 120-400 -20.0, 400-2k -21.1, 2-8k -26.1, >8k -29.4 dB (the first pass was 11 dB
  bass-heavy and was rebalanced); every effect peaks 1.6 to 7.5 dB over the music around it.
- Not auditioned by me. Listen on laptop speakers and headphones before posting.

Rebuild: `cat lib.swift term.swift timeline.swift film.swift > render.swift && swiftc -O render.swift -o render && ./make.sh`,
then `cat timeline.swift sound.swift > snd.swift && swiftc -O snd.swift -o snd && ./snd` and the two-pass loudnorm +
mux in the session log (target -14 LUFS, TP -1).

---

# one-command v2

`../one-command-v2-4k.mp4` (3840x2160 master) and `../one-command-v2-1080p.mp4` (supersampled from the 4K
master). 60fps, **14.5s**, silent.

Her notes on v1 (2026-10-05): no music at all; don't copy every agent's command, only copy the universal one and run
it in a terminal like the long video did; then show that each agent has its own command; end on something like
"give your agents persistent memory"; short; highest quality, bigger, clearer; don't use the screen recording
directly; add the motion graphics.

## The console is rebuilt, not screenshotted

The "Connect an agent" card is redrawn in vector from the live page (console.supermemory.ai/agents, 2026-10-05):
every element's box from `getBoundingClientRect`, every computed style (Geist 13/12.5/11.5/12px and Geist Mono 12.5px,
`#f5f5f5` / `#a2a2a2` text, `#0a0a0a` card, `#101010` header and command boxes, `#121212` hover, borders at white 7%,
the active pill `#0d131a` with a `#1e3973` border, the check `#4fb877`), the page's own SVG paths for the copy, check
and arrow icons, the hover behaviour (the copy icon fades in over 0.18s, it scales out and the check scales in on
click), and every tab's exact text, including truncation at the box width. The logos are the console's own SVG marks.
Because it is vector it stays sharp at any zoom, which is why the camera can go big. This overrides the pack's
"real capture only" rule at her request; nothing on the card is invented.

The terminal is typeset from the CLI's own strings (`supermemory@4.25.4`): banner glyphs and colours, "Detected
integrations", the prompt answer, and after install "One approval connects Claude Code, Cursor, OpenCode, Codex."

## Beats

| Time | What happens |
|---|---|
| 0.0 | the card, big; camera pushes onto `npx supermemory plugin` |
| 0.95 | cursor hovers: the box lightens, the copy icon fades in |
| 1.4 | click: copy icon scales out, the green check scales in, a blue pulse on the box |
| 1.62 | the command lifts off the box and flies down into a terminal window that rises in; it lands as the pasted command |
| 2.95 | enter: the SUPERMEMORY banner sweeps in column by column, then `> PLUGINS` |
| 3.5 | Detected integrations: four `[ready]` rows slide in, each agent's logo pops beside its row |
| 4.9 | after install: "One approval connects Claude Code, Cursor, OpenCode, Codex.", "One approval" underlined in blue, the four logos pop |
| 6.35 | back up to the card, "or one by one" |
| 7.15 / 7.85 / 8.55 / 9.25 | cursor clicks Cursor, Codex, OpenCode, Muse Code: the pill lights up, its logo pops out, the old steps slide away, the new ones slide in and their commands type themselves, the card resizes |
| 10.0 | the five lift out of their pills into a row above the card |
| 10.45 | the card falls away; "give your agents / persistent memory", the lockup, `npx supermemory plugin` |
| 13.0 | still to 14.5 |

## Truth notes

- The headline is her line. The five logos are the agents that key memory by repo (see `../one-memory-src/README.md`).
- Known product issues, unchanged: `npx supermemory plugin` installs an old Cursor build (the OAuth line still lists
  Cursor because that is what the CLI prints); Codex's step 2 on the console (`/supermemory-login`) is stale and is
  shown for under a second as the page shows it.

## Rebuild

```bash
cat lib.swift term.swift film.swift > render.swift && swiftc -O render.swift -o render
SCALE=1 ./render stills 0 1.55 3.6 4.6 8.3 12.2      # quick 1080p checks
./make.sh                                            # 4K master, 1080p cut (frozen-frame hold), QA; about 15 min
```

## QA (decoded, 2026-10-05)

- 4K: 3840x2160, 60fps, 14.50s, yuv420p, bt709 x3, ~10 Mb/s. 1080p: lanczos downscale of the 4K master, same tags.
- Pack motion metric (1080p): **76.7% moving**, no still stretch over 0.4s before the end card.
- Pop scan: 0 candidates.
- Still ending: 88 identical decoded frames in the 1080p, 87 in the 4K.
- White decodes `#fdfdfd`.
