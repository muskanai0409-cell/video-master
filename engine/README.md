# Engine: native Swift renderer (works on this Mac with no installs)

This Mac has no numpy and no standalone ffmpeg. The working path is: draw every frame in Swift with
CoreGraphics + CoreText, pipe raw BGRA frames into the ffmpeg that ships inside Cardboard.app, and
encode with libx264. Proven on two shipped cuts (2026-10-05):

| File | What it is |
|---|---|
| `reference-16x9.swift` | 1920x1080 explainer, one continuous take, 4 chapters, text column + figure, flood with brand film, end card. Start new 16:9 work from this. |
| `reference-square-v1.swift` | 1080x1080 silent explainer, simpler grammar. Shows the AVFoundation writer (do not use it for finals, see below). |
| `brand-lattice/` | The learner-1 teaser engine (v11, Oct 15): the brand book's dot field, the glass mind with a reaction-diffusion brain (`mind.swift`, lab: `mindlab_main.swift`), token streams, the freeze sweep, the dissolve into the mark, and the Apple Loops score (`make_audio_loops.sh`, `KIT=longing|yearning|fullmoon`). Guide: `references/motion-systems.md` §1, §2, §4. |
| `memory-board/` | The forgetting-on-purpose engine (v3, Oct 14): boxed pixel-art facts that reflow between layouts, the morphing top bar (question, split-flap, code editor), status pills, the vanish, the history row, a continuous camera, and the Regrets loop score (`make_audio.sh`). Guide: `references/motion-systems.md` §3, §4. |
| `morph-chain/` | The local v0.0.9 launch film (Oct 14): one survivor container through docker → v5 → security → counter → squares → mark, on the brand book's dot field, with Apple Loops scores. Guide: `references/motion-systems.md` §5. |
| `voiceover-film/` | Console series part 1 (Oct 14): the console rebuilt in vector, a Kokoro voiceover with word-locked picture timing, ducking and captions. Lives next to its siblings in `~/personal-supermemory/reports/videos/` (relative paths). Guide: `references/voiceover.md`. |
| `assets/fonts/` | Geist + Geist Mono variable fonts (wght axis 0x77676874). |
| `assets/lock_mark.png`, `lock_word.png` | official supermemory lockup as luminance masks. Geometry: mark 588x480, gap 230, wordmark 3182x381, wordmark top offset 99. Horizontal only, never stacked. |

Brand film for floods and end cards: `/Users/muskan/personal-supermemory/reports/videos/memory-graph-src-v3/assets/field.mp4`
(blue duotone flower field, 1280x720, 25fps).

## Start a new video

```bash
mkdir -p ~/supermemory/reports/videos/<name>-src && cd $_
cp ~/.claude/skills/video-master/engine/reference-16x9.swift render.swift
mkdir -p fonts stills qa && cp ~/.claude/skills/video-master/engine/assets/fonts/*.ttf fonts/
cp ~/.claude/skills/video-master/engine/assets/lock_*.png .
```

Then edit, in this order:
1. `// timeline`: beat times (B0..B9, TURN, END, T_STILL, T_END), `STATEMENTS` (`*word*` marks a key
   word in full ink; everything else is ink 45%), `CHAPTERS`.
2. `// layout`: the figure world (0..944 x 0..800) and element rects.
3. `CAMS`: one camera key per beat (centre, zoom, duration). A slow push inside every beat is built in.
4. `drawFigure`: the elements. Every value must be a pure function of `t` (no state between frames).
5. `drawFlood` / `drawEnd`: the turn and the end card.

## Library pieces inside the reference file (reuse, do not rewrite)

- Tokens: `col(hex, alpha)`, supermemory.ai colours, ink alphas (never neutral grey).
- Time: `ease` = cubic-bezier(.2,0,0,1) for moves, `eout` = (.22,1,.36,1) for arrivals, `seg`, `lerp`,
  `lerpP`, `lerpR`, `spring(t, start)` (closed-form step response, slight overshoot; one spring family
  per piece).
- Text: `sans(px, wght)`, `mono(px, wght)`, `text(...)` (baseline, align), `label(...)` (uppercase,
  letter-spaced mono; never use it for the word "supermemory", which stays lowercase), `textW`.
- Shapes: `rect` (square corners, hairline), `segLine` (dashes), `dot`, `paintMask` (lockup and mark,
  upright in a y-down context).
- Camera: `camera(t)` from `CAMS`, `worldToScreen`, `worldRectToScreen` (needed for floods that leave
  the figure).
- Statements: `drawStatements` (each line rises out of its own mask line, 50ms stagger, exit up),
  `drawChapterLabel`, `drawHUD` (title, chapter index, progress bars, small mark).
- Morphs used: line that draws, breaks (spring gap) and heals into the blue lane; characters streaming
  along a path (`pathPoint`); a chip that grows out of a tile and collapses into a dot; a dot that turns
  blue and drops into a tile; tile flood to beyond the frame corners with film, then shrink into the
  new tile; a square that arcs along a bezier and unfolds like a map (x then y); a card that unfolds
  from a line; a card that expands to fill the frame for the end card.
- Frame: `renderFrame` averages 4 subframes over a 180-degree shutter (motion blur). Counters and
  countdowns use `(t * FPS).rounded() / FPS` so digits never smear.
- Output: `stills <t...>` writes PNGs + a 3-column contact sheet; `raw` streams BGRA frames, rendered
  one frame at a time (CoreGraphics is not safe to run on several threads at once; see references/pipelines.md), with a bit-identical still ending.

## Encode (always this, never AVFoundation's H.264 for finals)

```bash
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
swiftc -O render.swift -o render
./render raw | $FF -y -f rawvideo -pix_fmt bgra -s 1920x1080 -r 60 -i - \
  -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" \
  -c:v libx264 -preset slow -crf 16 -tune animation -profile:v high \
  -x264-params "colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0:zones=<first still frame>,<last frame>,q=6" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart out.mp4
```

Why each flag matters (measured, not assumed):
- AVFoundation's H.264 encoder made identical source frames decode up to 58 levels apart, so still
  endings shimmered. x264 with B-frames still varied; `bframes=0` plus a high-quality `zones` entry on
  the hold gives byte-identical decoded end frames.
- Untagged or VideoToolbox encodes shifted paper and white 2-3 levels; the tagged x264 path decodes
  `#0562ef` as about `#0260ed` to `#0662eb` (within 3-4 levels; thin lines read lower because of 4:2:0).
- Film extracted with `fps=60` from a 25fps source judders (frame-difference spikes every 2-3 frames).
  Extract with `framerate=fps=60:interp_start=0:interp_end=255` to blend in-betweens.

## Speed

36.8s at 1920x1080x60 with 4 subframes rendered in about 40s (frames one at a time, pixel maths in parallel).
Stills take a second or two. Iterate on stills and contact sheets; render the full film last.
