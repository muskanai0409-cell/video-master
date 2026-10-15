> **Engine copy.** The film lives in `~/personal-supermemory/reports/videos/media-reel-src/` (renders, stills, QA). To build here: copy `engine/assets/lock_mark.png`, `lock_word.png` and `engine/assets/fonts/Geist*.ttf` (into `fonts/`) next to these files, take `dsp.swift` from `engine/brand-lattice/`, and run `./markfield mark_exact.f32 1024` once. Every path below is relative to the film folder.

# media reel v1: one moment, six media

**Brief:** a 20-second brand film that proves the video work no longer has a house style, made after her 2026-10-15 ask. Her words: "i dont want you to be generic at all ... same watermark of how opus 5.5 makes videos ... please do anything to be the best at the game". Plus "dont lose the supermemory branding in learning new stuff".

**What it is:**
- One sunlit gallery and one continuous camera move. The supermemory mark stands on a plinth as a sculpture in brand-blue pigment.
- On every bar, the medium the room is rendered in changes:
  1. light;
  2. an engraving;
  3. type;
  4. a survey drawing;
  5. a risograph print;
  6. an infinity mirror room.
- Then the camera pulls back, and the wordmark is painted across the walls. From the final camera it lines up with the sculpture into the official lockup (after Felice Varini).

**Outputs:**
- `../media-reel-v1-4k.mp4`: the 3840x2160 master.
- `../media-reel-v1-1080.mp4`: a Lanczos cut.
- `../media-reel-v1-review-1080.mp4`: the first direct 1080 render, before the light-sweep handovers.

All three are 60fps, 19.8s, with the score.

## Style card (anti-house-style.md §2)

| Field | This film |
|---|---|
| Anchor | A white gallery: a Klein-blue sculpture, Felice Varini's anamorphic paint, Yayoi Kusama's infinity rooms |
| Medium | Six media, one per act, all drawn from one 3D scene (raymarched, Metal) |
| Palette roles | Brand blue is the sculpture and the paint, and nothing else. The grounds change per medium: warm room, cream paper, ink black, map paper, riso pink, white mist |
| Type | No statements. Geist Mono as image in the type act; Geist painted on the walls at the end |
| Cadence | The world glides at 60fps; type steps at 15fps; the riso prints at 12fps |
| Camera | One continuous move around the sculpture, then a log-space pull-back with motion blur |
| Transitions | A band of window light crosses the frame on each downbeat and leaves the next medium behind |
| Ending | Anamorphic alignment: the 3D mark and the painted wordmark become the lockup from one viewpoint |
| Sound | GarageBand Chillwave "Chill Melody" (E major, 100 BPM) and "Pastel Colors" beats. Each medium gets its own small sound: a burin, keys, pencil, a print drum, glass, a brush |

## Beat table (100 BPM, 2.4s a bar)

| Bar | Time | Medium | What moves | Sound |
|---|---|---|---|---|
| 0 | 0.0 to 2.4 | light (0) | low close on the sculpture, a window gobo across it, the camera rising and swinging right | pad and chords, opening from 700Hz |
| 1 | 2.4 to 4.8 | engraving (1) | the light sweep hands over; hatching follows each surface | the groove arrives; a burin |
| 2 | 4.8 to 7.2 | type (2) | Geist Mono at 15fps; the sculpture is spelled in its own name | four keystrokes |
| 3 | 7.2 to 9.6 | survey (3) | the sculpture sliced in height, the room in rings of distance from it | the lead enters; two pencil strokes |
| 4 | 9.6 to 12.0 | riso (4) | two drums out of register, printed at 12fps | a print drum and a sheet |
| 5 | 12.0 to 14.4 | mirror room (5) | the walls become mirrors, a wide lens, an endless hall of blue marks fading to white | the second synth; glass |
| 6 | 14.4 to 17.76 | light | a log-space pull-back with motion blur. From 15.24 to 16.8 the wordmark is painted on left to right; the line under it follows | a brush; at 16.8 an E-major bell chord, and the groove stops |
| hold | 17.76 to 19.8 | light | 122 identical frames | the chord rings out |

## Claims and brand

- **The mark** is the exact vector path from `supermemory/apps/docs/images/supermemory.svg`, turned into an exact signed distance field by `markfield.swift`. The sculpture is an extrusion of that shape, never a retrace.
- **The lockup** is from `lock_mark.png` and `lock_word.png` (official masks), with geometry from brand.md: mark 588x480, gap 230, wordmark 3182x381, top 99 below the mark top.
  - The final camera is solved so the sculpture's front face is parallel to the image plane. The mark is therefore imaged without distortion, at 176px tall, and the lockup is centred at 43% height.
  - The colourway is blue on paper.
- **The line under the lockup**, "memory and continual learning for agents", is from the live supermemory.ai line ("the default engine for memory and continual learning for agents"; website-positioning memory). It is set in Geist 450, lowercase, with no em dash.
- **No numbers, no product UI, no claims beyond that line.**

## Rebuild

```
swiftc -O markfield.swift -o markfield && ./markfield mark_exact.f32 1024     # the exact field (once)
swiftc -O reel.swift -o reel                                                  # the renderer (compiles scene.metal at run time)
./reel stills 0 3.0 6.0 8.4 10.8 13.2 15.5 16.6 17.9                          # one still per act
W=480 H=270 ./reel paintcheck                                                 # proves the paint is unseen before it is painted on
./reel where                                                                  # where the wordmark lands in the room
./make_audio.sh                                                               # the score -> audio/master.wav (-14 LUFS, -1 dBTP)
RES=1080 ./parts/run.sh                                                       # a direct 1080 review render (about 6 min)
RES=4k ./parts/run.sh                                                         # 4K master + 1080 cut + score (about 30 min)
```

**Files:**
- `scene.metal`: the room, the light and every medium.
- `reel.swift`: camera, timeline, paint slide, type medium, sweeps, bloom, output.
- `score.swift`, `timeline_audio.swift`, `dsp.swift` (from the learner film) and `hp.swift`: the score.
- `fonts/`: Geist and Geist Mono.
- `lock_*.png`: the official masks.

**Environment overrides:**
- `FORCE=<n>` renders any medium at any time.
- `FIN_F` and `MARK_PX` move the final camera.

## QA (measured on the 1080 review render, before the sweeps)

| Check | Result |
|---|---|
| Format | 1920x1080, 60fps, 1188 frames, 19.80s, yuv420p, bt709 (tv) |
| Motion (pack metric: 30fps, 160x90, YAVG 0.15) | 82.6% moving, longest still before the hold 0.07s (her target: 60%+, under about 1s) |
| Hold | frames 1067 to 1188 bit-identical (`framemd5`), 2.03s |
| Paint | invisible until it is painted on (`paintcheck`: 0.0000% of the frame before 15.24s) |
| Loudness | -13.7 LUFS integrated, -1.2 dBTP peak |
| Copy | lowercase supermemory; no em dashes or semicolons on screen |

**Not yet done:**
- The score has not been listened to by anyone.
- The phone-size read of the final line (40px at 1080, about 8px on a 390px phone) is small, but the lockup reads.
- The sweeps went in after this QA. The 4K master is re-measured in the delivery note.

## Deliberate deviations from older rules

- **SKILL §2 "No gradients, glow, particles, 3D, shadows".** This film is real 3D with shadows, haze and a soft bloom. Her Oct 15 ask (be extraordinary, not the house style) relaxes the ban when the effect is physical and crafted. Brand blue is never glowed or outlined.
- **The 16:9 explainer frame** (text column, HUD, progress) is not used. This is a brand film with no statements.
- **Springs:** none. The camera eases by role, and the type steps.
- **"Blue first appears at the turn":** the sculpture is blue from frame 0. It is the subject, and the frame-0 thumbnail needed the brand.

## What did not work (kept for the next film)

- **CIDroste** (Escher's spiral) as the climax read as a generic tunnel filter and lost the mark. It was replaced by real mirrors.
- **Hiding the painted wordmark by framing alone** pushed the sculpture off the frame. Painting it on during the final move fixed that.
- **A zero-width antialiased line** still drew a 1px hairline, so every hatch family showed everywhere. Fixed by capping the coverage at the line's width.
- **The haze march stopped at 9m,** so beams were invisible from the far final camera. It now covers the whole ray. At 0.40 strength it washed out the blue mark; it is now 0.13.
