# Pipelines: building and encoding on this Mac

## 1. What this Mac has (checked 2026-10-05)

| Tool | State |
|---|---|
| system `python3` | no numpy, no Pillow |
| `ffmpeg`, `ffprobe` on PATH | none |
| bundled ffmpeg 6.0 + ffprobe | `/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg` and `.../ffprobe`. Built with libx264 and libx265. Filters present: `tmix`, `tblend`, `signalstats`, `ebur128`, `drawtext`, `tile`. Muxers present: `framemd5`, `md5` |
| Swift | `/usr/bin/swiftc`, Apple Swift 6.3.3 |
| Node | v22.19.0 at `~/.local/node/bin/node` (HyperFrames needs 22+) |
| Geist fonts | `Geist.ttf` and `GeistMono.ttf` in `/Users/muskan/personal-supermemory/reports/videos/mcp-upload-src/fonts/` (also in the other `*-src/fonts/` folders and `reports/video-scripts/diagrams/source/lib/`) |

The ffmpeg path depends on the Cardboard app staying installed. If `"$FF" -version` fails, stop and tell her. Do not install ffmpeg without asking.

Set these at the start of every command (each Bash call is a fresh shell):

```bash
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
FP=/Applications/Cardboard.app/Contents/Resources/bin/ffprobe
```

---

## 2. The working pipeline: Swift frames into the bundled ffmpeg

First shipped with the mcp-upload explainer (2026-10-05). Source and README: `/Users/muskan/personal-supermemory/reports/videos/mcp-upload-src/`.

```
render.swift (pure render(ctx, t))
  ├─ ./render stills t1 t2 ...   → stills/t_<sec>.png + stills/sheet.png   (look before rendering)
  └─ ./render raw                → BGRA frames on stdout
        | bundled ffmpeg, libx264, bt709 tags, high-quality zone on the final still
        → reports/videos/<name>.mp4  → QA (qa.md)
```

**How the frames are drawn** (from `mcp-upload-src/render.swift`):
- CoreGraphics bitmap context in sRGB, 8 bits, BGRA (`premultipliedFirst` + `byteOrder32Little`), flipped so y grows downward.
- Fonts registered from `fonts/` with `CTFontManagerRegisterFontsForURL`. Variable weight through `kCTFontVariationAttribute` with the `wght` tag.
- Easing as cubic-bezier functions solved by bisection: `ease = bezier(0.2, 0, 0, 1)`, `eout = bezier(0.22, 1, 0.36, 1)`.
- The lockup drawn from the official artwork as luminance masks (`lock_mark.png`, `lock_word.png`) with the measured geometry (see `brand.md` section 5).
- Captions as data: a list of `(start, lines)`, so "never two on one frame" can be checked in code.
- Still ending: the first frame at or after the hold time is rendered once, and the same bytes are written for every later frame.

**Build, stills, encode** (the mcp-upload README's commands, with the zone explained below):

```bash
cd <name>-src
swiftc -O render.swift -o render
./render stills 0 4.6 8.4 12.6 14.95 18.1 23.0     # test frames + stills/sheet.png
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
./render raw | $FF -y -f rawvideo -pix_fmt bgra -s 1080x1080 -r 60 -i - \
  -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" \
  -c:v libx264 -preset slow -crf 16 -tune animation -profile:v high \
  -x264-params "colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0:zones=<Z0>,<LAST>,q=6" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart \
  ../<name>.mp4
```

For 16:9 use `-s 1920x1080`. `<LAST>` is the last frame index (frame count minus 1).

**Where the zone starts (tested 2026-10-05).** The zone tells x264 to encode the final still at high quality so its decoded frames come out identical. It must start before the hold, because x264 needs a few frames to converge after the last motion. Re-encoding the mcp-upload render (1488 frames; the source frames are identical from frame 1379 on, 109 frames):

| Zone start | Decoded identical frames at the end |
|---|---|
| 1392 (the hold time in the code) | 93 |
| 1392, plus a forced keyframe at the hold | 92 |
| 1379 (where the source still begins) | 106 |
| 1370 (about 10 frames earlier) | 110 |

So: find the first frame of the source's final identical run (pipe `./render raw` into `$FF -f rawvideo ... -f framemd5 -`, see `qa.md` section 2.5) and start the zone about 10 frames before it. The memory note says AVFoundation's H.264 encoder made still endings shimmer, which is why `render.swift`'s `video` mode (AVAssetWriter) is not used for delivery.

The full mcp-upload render plus encode took about 8 seconds of wall time on this Mac.

**Motion blur.** Four subframes per 60fps frame, averaged in the engine or with `tmix`. Recipes in `motion-grammar.md` section 4.

**Footage inside the render** (the flower-field film, a real console capture). Decode once to an image sequence with the bundled ffmpeg, then load frame by frame in Swift with ImageIO. The memory-graph v3 README did:

```bash
$FF -ss 22.0 -t 10.0 -i assets/field.mp4 -vf "scale=1920:1080:flags=lanczos" -q:v 2 -start_number 0 field/f%04d.jpg
```

`field.mp4` is 1280x720 at 25fps, 32s long, so at 60fps either map `floor(t * 25)` to a frame or extract with `-vf fps=60`. It is upscaled for 1080p; never describe it as native 1080p or 4K. The console capture `prasanna_graph.mp4` is 2332x1430 at 120fps; memory-graph v3 cropped it to the canvas and played it at 1.22x, so it must never be captioned "live".

**Audio, when there is any.** Render the picture silent, then mux:

```bash
$FF -y -i picture.mp4 -i mix.wav -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart out.mp4
```

`apad` keeps the audio from cutting the end card short (code-motion-graphics `qa.md`). Measure loudness after the AAC encode with `-af ebur128=peak=true`. House target -16 LUFS, true peak at or below -1 dBTP (pack `skills/sound-design`). The pack's sound scripts need numpy; its CC0 Kenney samples are WAV files in `studio/sfx_lib/wav/` and can be placed with ffmpeg (`adelay`, `amix`) instead.

**Folder convention** (match her existing cuts):

```
/Users/muskan/personal-supermemory/reports/videos/<name>.mp4
/Users/muskan/personal-supermemory/reports/videos/<name>-src/
  render.swift   render (binary)   fonts/   lock_mark.png   lock_word.png   assets/
  stills/        qa/
  README.md      rebuild commands, beat table, every claim with its source, measured QA, deliberate deviations
```

"update" means patch `render.swift` constants and timeline, rebuild, re-run QA. Never start over unless she says rebuild.

---

## 3. Engine

Full documentation: `../engine/README.md`. Summary:

- **Files:** `engine/reference-16x9.swift` is the shipped mcp-upload v3 renderer (26s, 16:9, the current house style). Copy it into a new `reports/videos/<name>-src/render.swift` with `engine/assets/fonts/` and the two lockup masks, then change the timeline, statements, layout, camera keys and `drawFigure`. `engine/reference-square-v1.swift` is the older square cut.
- **Build and run:** `swiftc -O render.swift -o render`; `./render stills <t...>` writes PNGs and a contact sheet; `./render raw | $FF ...` streams BGRA frames into the encode in section 2. A 26s film renders in about 30 to 40s. Draw one frame at a time: CoreGraphics on several threads at once sometimes gets shape edges (and once a colour) wrong, so renders stop being repeatable (found 2026-10-06; 85 of 400 frames differed between two runs). Parallelise only pure maths (pixel loops, motion-blur averaging) with `concurrentPerform` over rows. To check, hash every frame of two `raw` runs and expect 0 differences.
- **The `render(t)` contract:** every value is a pure function of `t`. Beats are constants (`B0..B7`, `TURN`, `END`, `T_STILL`, `T_END`); `STATEMENTS` carry lines where `*word*` marks key words; `CHAPTERS` drive the label, HUD index and progress bars.
- **Camera:** `CAMS` keys `(t, centre, zoom, dur, drift)`. A non-drift key eases (.2,0,0,1) from wherever the camera is; a drift key uses smoothstep so the camera keeps moving through the beat. Never add a per-beat multiplier that resets at a key: it makes a one-frame zoom jump (v2 bug).
- **Cursor:** `CURSOR_KEYS` (tip positions, world space), `PRESSES` (click ripples), and drag windows where the cursor rides with the dragged object. Drawn in world space so it scales with the camera.
- **Primitives:** `ease`/`eout`/`smooth`/`spring`, `text`, `label` (uppercase mono; never for "supermemory"), `rect`, `segLine`, `dot`, `paintMask`, `drawCounter` (tabular digits), `pathPoint` (characters streaming along a polyline), map unfold, card unfold, flood and shrink with film, receipt typing (characters revealed per frame).
- **Motion blur:** 4 subframes across a 180-degree shutter, averaged. Counters, countdowns and typed text use `(t * FPS).rounded() / FPS` so they never smear.
- **Still ending:** frames at or after `T_STILL` reuse one cached buffer. Start the x264 `zones` entry about 10 frames before `T_STILL * 60` and check the decoded run with `framemd5` (qa.md 2.5).
- **Footage:** pre-extract to JPEG frames, blended to 60fps with `framerate=fps=60:interp_start=0:interp_end=255` (plain `fps=60` judders), load lazily with a lock.
- **Gotchas found while shipping:** label() uppercases, so brand words must use `text()`; text over moving cards needs its reveal delayed until the card has moved; check header text widths at the zoom you film at; red is drawn only inside its bounded window.

---

## 4. Alternatives (each needs her yes before installing)

| Route | Needs | Notes |
|---|---|---|
| Her pack's Python renderers (`studio/*.py`, `skills/supermemory-explainers/scripts/engine.py`) | numpy, Pillow, ffmpeg on PATH | Not installed. If she agrees, use a venv inside the video folder, for example the memory-graph v3 README's `python3 -m venv .venv && .venv/bin/pip install numpy pillow imageio-ffmpeg`. Their encode commands call `ffmpeg`; point them at `$FF` instead. The pack's QA scripts (`qa.py`, `motion_density.py`, `tools/phone_check.py`) need the same. `qa.md` has ffmpeg-only equivalents |
| HyperFrames (HTML + GSAP, Node 22+) | npm package plus a pinned Chrome download | Follow `~/.claude/skills/code-motion-graphics/references/setup.md`: `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1` on every command, pin the CLI and run `npx --no hyperframes ...`, never send feedback, publish or auto-upgrade. Seatbelt-style agent sandboxes can kill Chromium |
| Remotion (React) | npm packages plus Chrome Headless Shell | Same setup file. Telemetry cannot be disabled. A Company License applies above the free tier; ask her to confirm eligibility |
| Plain `seek(t)` page + headless Chrome | puppeteer-core or Playwright | Driver in code-motion-graphics `references/frameworks.md` section 4. This is the rossaxbt and twoclipping architecture |
| Generated video models | paid APIs | Not for supermemory explainers. The pack renders every frame in code, and product UI must be a real capture |

Whatever the route, the pack's truth and brand rules and this skill's QA still apply.
