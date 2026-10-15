# Motion grammar: one continuous take

> **Read this first (2026-10-16).** This file is the grammar of the **explainer register**, the house style through Oct 14. Lane A traced it to the viral Claude motion recipe of launch week (mask rise, spring pops, flood and shrink, an event on every beat, a cursor, zoom to fill, 4-subframe blur): it is what made her say the films carry an "Opus 5.5 watermark". It is still a valid option when a style card picks the explainer register, but a film may use at most 4 of the 12 recipe moves. For any film, start with `motion-mastery.md` and `anti-house-style.md`.

How to make a supermemory film move the way Muskan now wants: "a lot of movement, things blending into each other from one thing to the other." Every scene grows out of the last one.

**Sources**
- Two prompt templates posted by @rossaxbt: a UI-morph loop (2026-10-03, about 34k views, https://x.com/rossaxbt/status/2106396375269134597) and a launch film (2026-10-04, about 79k views, https://x.com/rossaxbt/status/2106758817161597021). Ideas below are paraphrased. Note: both closely match prompts that the code-motion-graphics notes credit to @twoclipping from late September 2026 (the most-bookmarked guanmo prompt, status 2103273003555402193, and the "Develop" film, gallery #8, status 2103835273813496100). The rossaxbt posts do not credit them. That @twoclipping is the original author is an inference, so credit both if you cite either.
- Her pack: `skills/supermemory-explainers` section 3 (motion grammar, shipped morphs, camera) and `reference/feedback-rules.md`.
- Her shipped cuts: the learner-1 reel, memory-graph v2 and v3 (2026-10-02), the mcp-upload explainer (2026-10-05).
- code-motion-graphics `references/qa.md` and `frameworks.md` for the build-side rules.

---

## 1. Principles

1. **One continuous take.** No hard cuts, no crossfades between whole scenes, no white flashes. Objects transform into the next thing. The pack already asked for this ("transitions carry one shape into the next", smfs v2 onward). The current direction makes it the default for every beat, not just scene changes.
2. **Name the survivor.** Every seam in the beat map names the object that carries across it. If no object survives, the seam is a cut. Redesign it.
3. **Something happens on every beat.** Plan on a beat grid. Silent films: 120 BPM, so 0.5s per beat (the rossaxbt templates). With music: the bed's own grid (smfs used 100 BPM, 0.6s). A 36s film at 120 BPM is 72 beats.
4. **No dead holds.** No stretch over about 1s without motion, except the final still. Reading still happens: the statement holds still for 2.5s or more while the figure keeps moving on the beat.
5. **Never more than two changes on one frame** (pack). One event per beat satisfies this. One synchronised move beats three small ones.
6. **Container first, content second.** Content leaves before its container morphs and enters after the container has started moving. Text that swaps inside a morphing shape gets its own mask.
7. **The camera makes each moment fill the frame.** Push in on the active element, pull back to show the whole figure.
8. **Pure function of time.** Every value is computed from `t`. No state carried between frames, no integration frame by frame. This is what makes stills, contact sheets, re-renders and patches safe.

---

## 2. Timing and easing

Keep the pack's two curves. They are the site's own.

```
ease      cubic-bezier(.2,0,0,1)     moves         480-900ms
ease-out  cubic-bezier(.22,1,.36,1)  arrivals      300-700ms (rising, not fading in)
opacity   250ms on ease              layer fades (never colour tweens)
line draw 600ms source to target, 4px leading dot that fades 120ms after; label lands 150ms later
stagger   40-60ms whenever more than one unit moves
```

On a 0.5s grid, the short end of each range keeps events from piling up. SuperRAG v2 raised its motion share by moving from 700ms arrivals rising 12px to 480ms arrivals rising 26px (pack `quirky-product-reels` section 8).

**Springs, and the open question.** The pack allows at most one spring per piece, and smfs v4 asked for none. The rossaxbt templates use springs everywhere, with a slight overshoot. Until Muskan decides, do this:
- Use the closed-form technique for any value that changes target more than once, because it keeps `render(t)` pure: `x(t) = x0 + sum over k of (g_k - g_(k-1)) * s(t - t_k)`, where `s` is a step response that is 0 before 0.
- Use a critically damped step, which has no overshoot and reads like the pack's `--spring-36`: `s(u) = 1 - (1 + w*u) * exp(-w*u)`. It reaches 99% at `w*u = 6.64`, so for a 0.6s settle use `w = 11`.
- An 8% overshoot spring (pack `engine.spring8`) at most once per film, and only if the brief asks.
- To stretch a moving highlight, give its leading and trailing edges separate responses, the leading one faster (rossaxbt, also verbove via code-motion-graphics).

**Colour changes** never tween hex values. Fade a blue layer's opacity over the grey or paper one, so every frame is a real tint (pack rule, brief 24).

---

## 3. The catalogue

Each entry: what it is, when to use it, timing, where she has already shipped it, and what goes wrong.

### 3.1 Flood and shrink
A shape grows until it fills the whole frame, lives there for a beat, then shrinks into the key element of the next scene.
- **Use when:** the turn (old way to new way), a chapter change, or entering a different ground (paper to the blue flower-field film).
- **Timing:** grow about 0.3s, accelerating (ease-in), scaled from the shape's own centre. Hold full-frame for 1 beat (0.5s), with the field film or the next scene's ground moving inside it. Shrink into the target in 0.4 to 0.6s on `ease`.
- **Overshoot the corners.** A square of half-size `h` at centre `c` covers the frame only when `h` exceeds the larger of `max |cx - corner_x|` and `max |cy - corner_y|`. A circle needs a radius past the farthest corner. Add about 5%. A flood that stops short, or runs faster than about 0.3s, changes half the screen in one frame (rossaxbt gotcha, also code-motion-graphics `qa.md`).
- **Shipped:** learner-1 reel (the blue word floods the frame, then shrinks into the learner-1 square). Memory-graph v2 and v3 (the new commit's square floods the frame with supermemory.ai's `field.mp4`).
- **Watch:** a blue flood is the first blue, so it belongs at the turn. Text inside the flood enters only after coverage is complete. A dot grid must not jump across the flood (pack bug catalogue: cross-fade it between cameras or drop it).

### 3.2 Shape-to-shape state morph
One shape changes position, size and role while its content swaps. A grey card becomes a blue memory tile, which becomes a bar, which becomes a counter.
- **Use when:** one object changes meaning. This is the default seam.
- **Timing:** container 0.4 to 0.6s on `ease`, on a beat. Outgoing content masks or fades out over 0.12 to 0.16s before the container starts. Incoming content enters 0.16 to 0.22s after the container is about 70% of the way.
- **Shipped (pack section 3.2):** the counter box opens into the terminal card; the tallest bar stretches into the chart's y axis; 66 bars stack into one total bar; two bars drop onto the chart's 299 points; chart end points open into result cards; a counter flies into the accent words of the closing line. Dreaming: a fact card becomes a hairline history card in place.
- **Watch:** for supermemory, morph through abstract states (tile, card, chip, bar, scope box, counter), never through imitation product screens. The rossaxbt chain (button, loader, player, slider, tabs, chart, command palette) is for generic films. Draw morphs in screen space, between the source scene's camera and the target scene's camera (pack). Radius stays 0 on the site brand.

### 3.3 A line that breaks, then heals
A connector or chain (context, a pipeline, a link between facts) snaps. The gap stays visible while the statement names the failure. Then a new line draws across it.
- **Use when:** showing the failure in the old way, then the fix in the new way.
- **Timing:** snap 0.2s (the two halves pull apart 4 to 12px). Hold the gap for 1 beat. Heal with a 0.6s line draw and a 4px leading dot (pack line-draw spec), label 150ms after.
- **Precedent:** the SuperRAG brief (brief 64): a hairline slices through the function and the lower fragment shifts down 4px so the break is visible.
- **Watch:** draw the break in ink and the heal in blue, so blue is only added. Red is allowed only for one bounded window in a whole film (Dreaming v4), so avoid it.

### 3.4 Characters stream along a path, then collapse into a counter
Real characters (base64, tokens, file names) flow from a source along a path into a target, then compress into a number that counts up and lands.
- **Use when:** volume becomes a number: tokens re-read, characters typed out, files searched.
- **Timing:** stream 1.5 to 2.5s at constant speed along the path. Collapse into the counter box in 0.3s. Count for up to 1.2s (smfs v4 hook: 5 to 9,988 in 1.2s). Land, then pause 0.5s before the next event (smfs v1 feedback: "let the counter land").
- **Shipped:** mcp-upload beats 1 and 2: real base64 of a PDF-like byte stream scrolls from `report.pdf` into the model, then a counter lands on 6,666,668 (sourced from RFC 4648 arithmetic).
- **Watch:** the stream is texture, the count is the claim, so the count needs a source. Use tabular digits, right-aligned at a fixed edge, so nothing jitters (pack `tab_text`). Big counters in Geist, not mono, because mono commas look gappy (pack bug catalogue).

### 3.5 A card that unfolds like a map
One card opens into a grid: the centre first, then the four arms of a plus, then the corners. It can then rearrange into a bento (rossaxbt 79k template).
- **Use when:** one item opens into its context. One fact into the profile, one file into its folder, one container tag into its memories, one run into all runs.
- **Timing:** each panel 0.25 to 0.35s. Panels in a ring 40 to 60ms apart. The next ring starts when the previous one is about 60% open. Whole unfold 0.5 to 1s.
- **How, in 2D:** each new panel scales from 0 to 1 along the axis perpendicular to the edge it shares with its parent, anchored at that edge. Hairline borders, flat fills. No 3D flip, no shadow.
- **Watch (pack, profile buckets):** when panels rearrange, separate x first, then y. Keep vertical moves unstaggered. No card within 24px of another on any frame, including mid-move.

### 3.6 An element that expands into the end card
The thing the film proved is the last survivor. Everything else clears, and that element becomes the end card.
- **Use when:** every film. It replaces "fade to the logo".
- **Timing:** other elements clear in 0.2 to 0.3s. The survivor expands in 0.3 to 0.5s. The lockup mark lands as it settles (0.4 to 0.5s). The wordmark rises from a mask 60 to 100ms later (0.4 to 0.6s). `supermemory.ai` in mono below. Then a still hold of 1.2 to 2s with identical frames.
- **Two clean versions:** (a) the survivor becomes the blue square tile with the white mark (a site pattern), then settles into the mark's place in the horizontal lockup on paper; (b) the survivor floods the frame blue and the lockup appears in paper on blue, one of the four official colourways.
- **Watch:** use only the official lockup masks and geometry (`references/brand.md` section 5). Never assemble the mark from pieces, redraw it, stack it, recolour it outside the four colourways, or add glow (pack; code-motion-graphics section 9). No debris from earlier beats on the end card.

### 3.7 Text rises from a mask line
Each line of a statement or label sits in its own clip box. The incoming line rises one line-height into place from below its mask. The outgoing line exits upward through the top of its mask.
- **Use when:** every statement change, section label change and number label.
- **Timing:** outgoing 0.16 to 0.2s, fully gone before the incoming starts. Incoming 0.3 to 0.45s on `ease-out`. Lines of one statement 60ms apart. Optional site-style emphasis: once a line lands, its key words darken from ink 45% to full ink over 250ms.
- **Watch:** this replaces the pack's 8px drift, but keeps its rules: both lines travel the same direction, never two statements on one frame, fixed first-line position for every statement.

### 3.8 Camera push and pull, every beat
The figure lives in world coordinates behind a camera: `screen = ((x - cx) * s + W/2, (y - cy) * s + H/2)` (pack section 3.3).
- **Use when:** always. Screen-studio style: each beat, the camera eases to frame the active element so it fills most of the stage. Pull back at a chapter's end to show the whole figure, which sets up the next push.
- **Timing:** each move 0.6 to 0.9s on `ease`. While a statement holds, keep a 1 to 2% drift so the frame stays alive (pack X-benchmark rule).
- **Watch:** the HUD and the text column are screen space and never move with the camera. A cursor, if there is one, scales with the camera (rossaxbt). When zooming into a chart, keep the scale visible: pin the y-axis labels at a screen x on a paper plate and fade axis titles as the zoom starts (pack, smfs v1 feedback). Lock a dot grid to the figure so it moves with the camera.

### 3.9 Cursor-driven change (only for real actions)
A drawn cursor (never the OS pointer) moves in and clicks, drags or types, and that action triggers the change (rossaxbt; pack `console-product-films` uses a drawn cursor with a click ripple).
- **Use when:** the film depicts something a user really does: uploads a file, runs `npx supermemory plugin`, submits a query.
- **Watch:** never over fabricated product UI. Over a real capture or an abstract scope only. A held drag sets the value from the cursor position; on release it springs back from there.

---

## 4. Motion blur

Average 4 subframes per output frame at 60fps (rossaxbt, twoclipping). Two ways:
- **In the engine (preferred):** render at `t`, `t + 1/240`, `t + 2/240`, `t + 3/240`, accumulate, divide, then write the frame. Four times the render cost, one quarter of the pipe bytes of the next option.
- **In ffmpeg:** render at 240fps and blend: `-vf "tmix=frames=4,select='eq(mod(n\,4)\,3)',setpts=N/(60*TB)" -r 60`. Tested on a test pattern on 2026-10-05 with the bundled ffmpeg: 240fps in, 60fps out, 120 frames in 2.0s.

On still frames the four subframes are identical, so blur never breaks the still ending. Frame 0 must still be a composed thumbnail.

---

## 5. Seam table (put one in every beat map)

| Seam at | Outgoing scene | Survivor | Morph | Incoming scene | Duration |
|---|---|---|---|---|---|
| 4.0s | the problem | the grey card | state morph | the number | 0.5s |
| 14.0s | the old way | the broken line's end | flood and shrink | the new way | 1.2s |

A seam with no survivor is a cut. Redesign it.

---

## 6. Banned

From the rossaxbt banned lists, the pack's "never appears" lists and her feedback:
- crossfades between scenes, blur-ins, brightness "developing", 3D flips, white flashes, stock wipes
- particles, glows, bloom, lens flares, gradients on chrome, shadows, textures beyond the site's dot grid
- bouncy easing, camera shake, random blinking
- colour tweens (fade a layer instead)
- text over text, two statements on one frame
- holds over about 1s before the end card
- whooshes on transitions ("it sounds AI-generated", smfs v1 feedback)
- anything that looks like a template

Loops are optional. If a social cut is meant to loop, make the last frame equal the first, including any cursor position and speed (rossaxbt gotcha). Supermemory explainers normally end on a still lockup instead.
