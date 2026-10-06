# Prompt template: a supermemory explainer

A tagged prompt in the shape of the @rossaxbt templates (`<inputs>`, `<direction>`, `<structure>`, `<build>`, `<gotchas>`, `<start>`), which code-motion-graphics traces to @twoclipping's prompts. Adapted to supermemory: her brand and truth rules, the 16:9 layout, the Swift pipeline on this Mac.

Use it to brief a subagent, or give it to her to reuse. Fill every `<...>`. Delete lines that do not apply. Keep the product as the subject: a showreel framing can make a model drop the product entirely (code-motion-graphics `prompting.md`, robj3d3's test).

---

## The template

```
<inputs>
Ask me for these in one message before anything else:
- the topic, and the one thing a viewer should understand after watching
- the source of truth: the docs page, the tweet, or the run data. Every number I want on screen, with its source
- the problem, in my words: what is being solved, for whom
- a real capture if product UI must appear (a console or app recording). If there is none, no product UI is drawn
- format: 16:9, 1920x1080, 60fps, 25 to 26s max by default. Do I also want a square 15 to 25s social cut?
- sound: silent (default), a quiet bed, or my own voice (I record it, never synthesised)
- the tweet that will carry the video
- anything that must never be claimed
</inputs>

<direction>
A research-lab explainer in the supermemory.ai site language. White or paper ground, square
corners, 1px hairline cards, uppercase letter-spaced Geist Mono labels, Geist statements with most
words at ink 45% and the key words in full ink, dashed connectors, dot-grid figures, big Geist
numbers with a small unit. One blue, #0562ef, only for the thing being proved: it first appears at
the turn and is never removed. The blue tile with the white mark. The blue flower-field film for
the turn. The official horizontal lockup at the end, then a still.

Layout: a text column on the left with a section label per chapter ("01 · THE PROBLEM"), the
figure on a stage to the right, a consistent HUD, and a chapter progress rule at the bottom.

Motion: one continuous take. Every scene grows out of the last. Objects transform instead of
fading or cutting. Text rises from a mask line. A shape floods the frame, then shrinks into the
next scene. The camera pushes in so each moment fills the stage, and pulls back at chapter ends.
Something happens on every beat. Nothing is still for more than about 1s until the final still.
60fps with motion blur.

Story: the problem first. Then why it matters (one sourced number), the old way and where it
breaks, the turn (name supermemory here), the new way in 3 to 4 steps, what the user or the
model actually sees, the thesis once, the lockup.

Copy: lowercase, plain full sentences, one per beat, my voice rules. "supermemory" always lowercase.

Banned: crossfades between scenes, blur-ins, white flashes, 3D, particles, glow, gradients,
shadows, bouncy easing, camera shake, colour tweens, whooshes, holds over 1s, fabricated product
UI, any claim that model weights change, em dashes, semicolons, Title Case, not-X-but-Y lines,
anything that feels like a template.
</direction>

<structure>
120 BPM, 0.5s beats, about <72> beats for <36>s. One event per beat, never more than two changes
on one frame.

Chain:
<the problem, already composed on frame 0> → <its cost streams into a counter that lands on N>
→ <the old way: a line breaks> → <the broken end floods the frame blue> → <shrinks into the
supermemory tile> → <step 1> → <step 2> → <step 3> → <what the model receives> → <thesis> →
<the tile expands into the lockup> → still for 1.5s.

Section labels: 01 · THE PROBLEM, 02 · WHY IT MATTERS, 03 · THE OLD WAY, 04 · THE TURN,
05 · HOW IT WORKS, 06 · WHAT YOU SEE.

Statements, exact text, each held 2.5s or more:
<start-end> "<statement>"   key words: <...>
...
Thesis: "<thesis>"   the one blue word: <...>
</structure>

<build>
1. Swift with CoreGraphics and CoreText, Geist and Geist Mono from <fonts path>. One file at
   <W>x<H>. Every value is computed from t inside render(t): no timers, no state carried between
   frames.
2. Easing cubic-bezier(.2,0,0,1) for moves and cubic-bezier(.22,1,.36,1) for arrivals. When a
   value changes target several times, sum one closed-form step per change. No overshoot unless
   I ask.
3. Content leaves before its container morphs and enters after the container starts moving.
   Text that swaps inside a morphing shape gets its own mask.
4. 60fps, 4 subframes averaged per frame for motion blur.
5. The official lockup from lock_mark.png and lock_word.png with geometry mark 588x480, gap 230,
   wordmark 3182x381, wordmark top 99. Never redraw or assemble it.
6. Before the full render: one frame per beat as a contact sheet, plus 4 key stills.
7. Pipe raw BGRA frames into /Applications/Cardboard.app/Contents/Resources/bin/ffmpeg: libx264,
   -preset slow -crf 16 -tune animation, bframes=0, bt709 tags on the stream and the container,
   tv range, and a q=6 zone that starts about 10 frames before the final still.
8. Then measure: duration, fps and tags; decoded hex against the tokens; % moving and the longest
   still with the pack's metric; single-frame pops; the still ending by framemd5; a 390px phone
   sheet.
</build>

<gotchas>
- A flood must overshoot every corner and take about 0.3s, or half the screen changes in one frame.
- Never two statements on one frame. The outgoing line is gone before the incoming one rises.
- Measure every statement line against the 720px column before rendering.
- Thin blue lines decode lighter after 4:2:0 chroma. Check colours on solid areas.
- Lock the dot grid to the figure, or it jumps when the camera moves.
- When zooming into a chart, pin the axis labels so the scale stays visible.
- Cards never cross mid-move: separate x first, then y.
- "supermemory" stays lowercase, even in an uppercase label row.
- Start the x264 zone before the final still, not at it, or the first hold frames differ.
</gotchas>

<start>
Ask me for the inputs. Then show me: the claims table with a source for every number, the beat
map on the 0.5s grid (time, section label, statement, what moves, the survivor into the next
beat, the morph), and 4 stills (open, turn, new way, end card). Wait for my yes before the full
film.
</start>
```

---

## Square social cut (short form)

Use the same `<inputs>` and `<build>`. Change these:

```
<direction> ... 1080x1080, 15 to 25s. Statements in a bottom band with a fixed first-line
baseline, 96px gutters, 44 to 56px statements, labels 26px or more. No text column. </direction>
<structure> hook problem → (number or old way) → turn with flood → new way in 2 steps →
thesis → lockup and still. </structure>
<gotchas> ... check every frame at 360px wide. Re-frame from the 16:9 timeline, never letterbox. </gotchas>
```

---

## Patch prompt (for "update", not "rebuild")

From the pack's `reference/brief-template.md`:

```
PATCH against <file.mp4>. Do not rebuild. Keep <layout, palette, statements, runtime>.
1. <THE PROBLEM IN CAPS>
   what is wrong now, with the timestamp
   exactly what it becomes (positions, ms, hex)
2. ...
TIMING      where the time comes from, and the new total
LEAVE ALONE the list
RESULT      what the viewer should feel differently
```
