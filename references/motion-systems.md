# Motion systems (built Oct 6 to 15, 2026)

These systems came out of the films made from Oct 6 to 15:
- the learner-1 teaser (v7 to v11);
- "forgetting on purpose" (v1 to v3);
- the local v0.0.9 launch film;
- console series part 1.

Each one is in `engine/`, ready to copy. Her notes on each are in `lessons.md` (#74 to #98).

| System | Engine | Use it for | Her verdict |
|---|---|---|---|
| Brand-book dot field | `engine/brand-lattice/` | Brand or teaser films on the blue field. A subject is recalled out of the lattice, and memories travel as dots and tokens | The look is right ("see how we do our branding and colors"). The subject must be pretty (#85) |
| Glass mind | `engine/brand-lattice/mind.swift` | A head or brain as the film's subject: "the model", "the agent", "a mind" | v11 is the current pick. It replaced the skull, which Shardul found off-putting |
| Memory board | `engine/memory-board/` | Explainers about facts changing: expire, update, filter, forget on command, recall | She preferred the board (boxes, blue) to a sparse white rebuild (#82, #83) |
| Apple Loops score | `brand-lattice/make_audio_loops.sh`, `memory-board/make_audio.sh` | Real-sounding music with no licence budget | She took the loop tracks after rejecting two code-made scores (#80) |
| Morph chain | `engine/morph-chain/` | Launch films of 20s or less: one container that changes state on the beat, ending as the mark | Built to her brief "one thing blended into other ... super duper polished" (#92) |
| Voiceover-keyed film | `engine/voiceover-film/` + `references/voiceover.md` | Explainers with a spoken voice (Kokoro af_bella), the picture locked to each word | "the latency should be perfect" (#93) |
| Animation skills | anatomy (installed), hairline (not installed) | Interactive isometric "machine" figures (anatomy) or one-file line animations (hairline) for docs and posts | Her Instagram saves (#98) |

## Start a film from an engine

```bash
mkdir -p ~/personal-supermemory/reports/videos/<name>-src && cd $_
cp -R ~/.claude/skills/video-master/engine/brand-lattice/. .        # or memory-board/.
mkdir -p fonts stills && cp ~/.claude/skills/video-master/engine/assets/fonts/*.ttf fonts/
cp ~/.claude/skills/video-master/engine/assets/lock_*.png .
./make.sh && BPM=164 SCALE=1 SUBFRAMES=1 ./render stills 0 2.6 5.4 13.6   # contact sheet in stills/
```

Then:
- `KIT=longing ./make_audio_loops.sh` (brand-lattice) or `./make_audio.sh` (memory-board) builds the score.
- `BPM=164 NAME=<name> AUDIO=audio/master_longing.wav SUB=8 ./parts/run.sh` renders the 4K master and the 1080 cut, with the score muxed in.

Everything is timed in beats (`b(n)`, with `BPM` from the environment), so the picture always lands on the music.

---

## 1. Brand-book dot field (`scene.swift` paintField)

This is the brand book's imagery system. Pages 30 and 31: "a quiet lattice of stored dots, and a subject recalled out of it".

**Field:**
- the ground is blue 600 (#0100F5);
- its light is dithered toward blue 500 on the 8x8 Bayer matrix ("never blur, soften, or randomize it");
- a hairline grid with + marks sits over it.

**Lattice:** screen-fixed, pitch 7px.
- Every cell is a dot sized by tone (side = pitch × 0.92 × √tone).
- **Stored = square, recalled = rotated 45°.** A subject is recalled when its cells turn into diamonds.
- The lattice pass is pure maths, so it runs rows in parallel. The pixel pass is per-pixel and also parallel.

**Motion vocabulary:**
- **Recall in:** a sweep down the subject with jitter per cell (`skullIn`).
- **Freeze:** a front runs down the subject, glinting as it passes, and turns its diamonds back to squares ("weights freeze the day training ends"). Afterwards nothing structural changes; only light and memories move.
- **Shockwaves:** rings of recalled dots run out from each hit, with a 0.05s soft attack so nothing flashes on one frame.
- **Lattice pulse:** the whole lattice swells softly on every kit beat while the drums play.
- **Tokens:** a token is a short sharp bar laid along a Bézier path, with word-like lengths. It is paper-coloured, with a gold lead token. Use `tokenStream` for training pouring in, a memory's copy leaving, and recall pouring back.
- **Dissolve to the mark:** the subject leaves from the outside in, and the mark assembles in diamonds, then resolves into the crisp lockup.

**Don'ts:**
- Never zoom-punch a subject sampled through the screen-fixed lattice: it re-samples and shimmers. Punch only on beats where the camera is already moving.
- Never use a bright, high-contrast halftone of a real person. It reads as a ghost (#85).

## 2. Glass mind (`mind.swift`)

This replaced the skull (v11). Her reference was a Pinterest pin of a glowing glass head with a brain. It is direction only: never trace or download a reference image, and AI-modified pins can't be assets anyway.

**Fields** (computed once in a 1000-unit box, y down, facing right, then sampled per lattice cell):
- **Glass head:**
  - a Catmull-Rom profile (`HEAD_PTS`), eyes closed;
  - tone = a luminous rim (Fresnel: `0.62·e^-(d/7)²`) plus a nearly empty volume, so the field shows through;
  - the face's quiet features (lid, nostril, lips, jaw) as faint lines.
- **Cortex folds:** Gray-Scott reaction-diffusion.
  - Settings: Karl Sims' coral (feed 0.055, kill 0.062, dA 1.0, dB 0.5), 250×250 grid, 5200 iterations, ping-pong buffers through raw pointers.
  - Seeded inside the brain, kept clear of the two fissures (lateral and central).
  - The sulci are the pattern's boundaries. Distance from them makes rounded lit gyri.
  - Noise isolines read as camouflage; reaction-diffusion reads as a brain.
- **Cerebellum:** folia as arcs about 19 units apart. **Brainstem and cord:** a lit glass tube.
- **Exact distance fields:** Felzenszwalb-Huttenlocher EDT, two 1D passes. Use them for rims, line glows and ridge shading.

**Life:**
- **`mindLight(t)` follows the story:**
  - it glows while training pours in and settles at the freeze;
  - it rises a step with each memory and goes out at the reset;
  - it returns with recall and fades for the lockup;
  - it breathes ±7%.
- **Colour:** the brain's dots warm toward gold (the glow and gold stops) with that light. A dithered blue-500 pool glows in the field behind the brain.
- **Dot colour ramp:** sky (#94B6FF) in shadow to paper in the light. Never flat white everywhere: that was what made the skull harsh.
- **Synapses:** 61 gold or glow diamonds, linked to their nearest neighbours by hairlines, twinkling, with small pulses running along the links.
- **Memory pockets:** where a memory lands, the brain clears in an ellipse around it, so the pixel art floats in its own window and stays readable. The reset closes the pockets with the scan band.

**Iterate fast:** `mindlab_main.swift` builds a lab (`mind_tone.png`, plus dots at rest, lit, and at the frame-0 framing) in about a second:
```bash
cat lib.swift timeline.swift mind.swift mindlab_main.swift > /tmp/ml.swift && swiftc -O /tmp/ml.swift -o mindlab && ./mindlab
```

## 3. Memory board (`world.swift` + `scene_film.swift`, forgetting v3)

The board: twelve boxed pixel-art facts in a 4 × 3 grid, with chatter bubbles in the gaps, a history row below, and a caption band.

**Reflow, never holes:**
- `LAYOUTS` holds the board's states: A start, B after expires, C after updates, D after filters, E after forget.
- `boardPos(i, t)` glides each card between them, with a left-to-right stagger (`REFLOW` holds the start time and duration of each step).
- Example: the top row re-centres after "expires", and sf slides into nyc's exact place after "updates" ("a superseded fact steps aside for the one that replaced it").

**Step aside into history:**
- the card lifts (scale 1.06), then arcs (−70 units at the peak) into its history slot, shrinking to 0.46;
- it is drawn on top while it travels, its label fades as it shrinks, and its pill stays readable (12.5px floor).

**One survivor at the top (the bar):**
- One box carries the story. It traces its outline in, types the question, and its split-flap shuffles and lands on the answer (aceternity Text Flipping Board).
- It flips NYC to SF on "updates".
- On command it opens into the code editor (dry run, a 0 → 3 ticker, then forget the previewed ids), then folds back into the question for recall.
- It is screen-fixed, so it never crops.

**Status pills:** EXPIRED, SUPERSEDED, LATEST, MATCH and FORGOTTEN, each with one pulse ring on arrival (kinetics Status Pill).
- Checkbox draw for the dry run's matches; a near-miss card stays unticked with NOT A MATCH.

**Vanish:** chatter scrambles, breaks into dots, falls, and snaps onto lattice cells (aceternity Vanish Input, kinetics Lattice Snap).

**Camera:** one continuous Hermite take. It pushes slowly toward each change and pulls back so each glide into history is seen. No shake, no punches; her v1 note was "smooth".

**Truth:** forgetting is never shown as deletion. Facts step aside into "HISTORY · NOT ERASED", dimmed and dashed.

## 4. Apple Loops score (real recorded parts, no licence budget)

**Licence:** GarageBand's licence lets us use its loops "on a royalty-free basis, to create your own original soundtracks for your video and audio projects".
- Never ship loops on their own.
- Decoded copies go to `~/Library/Caches/video-master/loops`, never into a repo.

**Kits:** `/Library/Audio/Apple Loops/Apple/01 Hip Hop/` for the films below. For a new film, pick by tempo and key:
- `python3 -I engine/tools/loop_index.py --bpm 109` indexes all 1,470 installed loops in about 3s. It reads tempo from each CAF's `pakt` frames, and key, beats, genre and instrument from its Apple Loops chunk. Output: `~/Library/Caches/video-master/loop-index.tsv`.
- It lists the loops at that tempo, at half and at double, so a kit plays on the film's grid without time-stretching. The bundled ffmpeg only has `atempo`, which smears a harp or piano stretched by 17%.
- The style card's sound dimension counts pack and key. Dreaming v2 dropped Chillwave "Harmonic Waves" (E major) because the media reel used Chillwave in E major. It took Modern RnB "Breathless" harp and piano (E minor, 109) and moved the picture grid to 109; the events were already within 0.15s of its beats.

| Kit | Key | Kit BPM | Film BPM |
|---|---|---|---|
| Longing (learner-1 track B) | C minor | 82 | 164 |
| Yearning | A minor | 70 | 140 |
| Full Moon | F# minor | 77 | 154 |
| Regrets (forgetting) | F minor | 80 | 160 |

**Arrangement:**
- Run the film at 2× the kit's tempo, so each 8-beat section of the film is one bar of the kit.
- The arrangement follows the picture:
  - keys alone in the intro;
  - drums in on the story;
  - drums out for a beat and a half before the turn, with a snare roll and a riser;
  - a crash and boom on the downbeat, and strings on the turn;
  - a low-pass sweep and a riser into the lockup;
  - the sub under the lockup.

**Gotchas:**
- Skip the 2112-sample AAC priming of every loop.
- Pitch-check every bass loop against the kit's key. Full Moon's sub is tagged E minor, so shift it +2 semitones and realign it by 24.2ms.
- Two-pass loudnorm to -14 LUFS / -1 dBTP for social.

**Effects:** put one effect on each picture event, from Kenney CC0 clicks (`sfx/`) plus synthesis in `dsp.swift`:
- a key click per typed character;
- a flutter while a split-flap shuffles;
- clock ticks that speed up into a stamp;
- a thump on SUPERSEDED;
- a fizz on vanish;
- a clean bell on the true answer and a doubtful pair of notes on the wrong one.

## Encode notes learned here

- **The held end card:** x264 zones `S-30..S q=1 / S+1..N+1 q=45`, and **keyint must be greater than the frame count**.
  - keyint 600, then 1300, put an IDR inside the hold, which dropped its quality.
  - Use 4000.
- **Mux with `-af apad -shortest`**: a 5ms-short audio track drops the last frame otherwise.
- **A spike in a preview at frame 250** is x264's default keyframe, not the animation.

## 5. Morph chain (`engine/morph-chain/`, local v0.0.9)

> For a longer voiced explainer where UI objects (windows, chips, a container) become each other with zero cuts, use the one-take blend grammar instead: `one-take-blend.md` and `engine/blend-kit/` (Oct 25).

**The survivor:** one paper container lives on the brand book's dot field. Each state change lands on a beat.
- **Version:** "v0.0.9" is recalled out of the lattice. It wipes solid, then flies into the corner as the HUD.
- **Command:** a prompt chip stretches into a command bar, and `docker compose up -d` is typed with one key sound per character.
- **Terminal:** ENTER on the drop opens a terminal, with a pull bar and the result lines.
- **API call:** the terminal becomes a v5 call (the docs' own example, `client.search("user_dhravya", …)`), and the namespace lights up.
- **Request bar:** the call becomes a request bar: a 401 shuts the lock, the key row goes in, a 200 opens it.
- **Counter:** the bar becomes a counter that rolls from 0 to 40%, with lattice streaks.
- **Squares:** the counter is cut into ten squares. Nine fall back into the lattice, from the outside in.
- **Mark:** the last square carves itself into the mark, using the mark's distance field thresholded down to zero.
- **Lockup:** the lockup, then the install chip `$ npx supermemory local`.

**Moves borrowed:** the @rossaxbt morph chain (edge springs, motion blur mid-resize), the @workersio survivor-becomes-logo and counter, and @LexnLin's recurring brand element (the version returns under the lockup).

**Truth:** keep a claims ledger. Stylised terminal output is labelled illustrative, and unsupported team claims are flagged before posting.

## 6. Voiceover-keyed film (`engine/voiceover-film/`, console series part 1)

**The picture follows the voice:**
- `audio/vo_build.py` makes the Kokoro read and conforms its pauses to the researched ranges.
- It writes every word's *audible* onset to `vo_times.swift`.
- `film.swift` keys every move to those times: the picture lands 2 frames early, and clicks sound 2 frames after their visual.

**The console:** rebuilt in vector from the measured DOM (`console.swift`), never a screen recording. `pages_test.swift` renders every page state for checking.

**Sound:** music ducked under the voice with an 80ms look-ahead, 19 LU under while she speaks. The full spec is in `references/voiceover.md`.

## Pixel kinetic type (a reference to try next)

From @dankimxyz's Airwallex film (`library/videos/13-shared-oct.md` #5), the closest outside reference to the brand's dot system:
- words swap for pixel icons as they are spoken;
- pixel letters dissolve into a dithered field;
- a giant pixel-font number;
- a beat-locked strobe for one short stretch;
- partner logos in a hairline grid.

The brand-lattice engine already has the parts: the lattice, recall to diamonds, and Bayer dither.
