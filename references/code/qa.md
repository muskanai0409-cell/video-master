# QA: render checks, measurements, common failures

"A render that exits 0 proves nothing" (claude-animation-skill). You cannot see motion by reading code. Render images, open them with the Read tool, and measure what can be measured. Commands come from the linked sources, except those marked as written for this skill or cited to ffmpeg.org; none were run during research.

## 1. Gates by stage

| Stage | Check | How |
|---|---|---|
| Before building | The storyboard has an event, an end state and a transition out for every shot. Text fits. The product is named. Numbers have sources | Read `STORYBOARD.md` against `BRIEF.md`. Send the storyboard to a critic subagent |
| Stills | One still per scene, or one frame per beat, as a contact sheet. Nothing cramped, overlapping or off-grid | Section 2 |
| Each shot | First, middle and last frame against the storyboard. A strip around every fast action and contact | Section 2 |
| Hardest 2-4 s | 12-24 neighbouring frames: occlusion, contact, speed, loop seams, caption bounds | Strip at full frame rate |
| Determinism | The same frame rendered after seeking in a different order is identical | claude-animation-skill: `node film.mjs verify` with `CLAUDE_ANIMATION_LIB=$SK/lib` set on the same command (frameworks.md section 5). HyperFrames: run `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes snapshot --at 2.0`, copy the 2.0 s PNG it reports out of `snapshots/` to `det-a.png`, then run `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes snapshot --at 4.0,2.0` and compare `md5` of `det-a.png` with the new 2.0 s PNG. Snapshot's capture order and file naming are not documented, so a match is weak evidence (recipe written for this skill, not run). Remotion: `npx remotion still <id> out/det-a.png --frame=60`, then `npx remotion render <id> out/det-b --frames=0,30,60,90 --image-format=png`, and compare `md5` of frame 60 from each (the list may not render in the order given, so this mainly catches state carried between frames; https://www.remotion.dev/docs/cli/still.md, https://www.remotion.dev/docs/cli/render.md). Use `md5sum` on Linux |
| Framework gate | HyperFrames `lint`, then `check` with 0 findings. Remotion: view in Studio, then render chosen frames | Section 2 |
| Final render | Exists; duration and fps match the spec; streams present | `test -s out.mp4` and `ffprobe -v error -show_format -show_streams out.mp4` (HyperFrames CLI skill) |
| Master review | A contact sheet that spans the whole encoded master (rate set from its duration), a 10 fps strip around every cut, full-size frames of dense shots | Section 2 |
| Measured | Frozen time, loudness and true peak after AAC, audio sync, brand colour in the decoded file, contrast | Sections 3 and 4 |
| Human | Someone watches and listens to the whole film, at phone size, cold, and with sound off | Say plainly what you could not check (you cannot hear the mix) |

The three acceptance stages from the athemeroy audit:
1. Brief plus keyframe sheet approved.
2. The hardest 2-4 s, inspected frame by frame, with a seek-order determinism test.
3. The whole film watched and listened to, then handed off with the MP4, the editable project, the render command, the asset and service list, and the unverified claims.

Source: https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/visual-effects-fit.md

## 2. Looking at frames

### Before the full render (from source)

```bash
# HyperFrames (pinned local CLI; opt-outs on every command because each Bash call is a fresh shell)
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes snapshot --at <t1>,<t2>,<t3>
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes check --snapshots    # full gate plus annotated overview frames and per-finding crops
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes check --at-transitions
# Remotion
npx remotion render <composition-id> out/frames --frames=0,30,90 --image-format=png
# ClaudeAnimationBase-style page renderer
node render.mjs --sheet=0.1,0.8,1.6,2.4,3.1,3.9 --cols=6 --w=320 --out=out/check/sheet.jpg
node render.mjs --strip=2.1:2.6 --cols=6 --w=320 --out=out/check/strip.jpg
# claude-animation-skill (film.mjs looks for ../lib unless this is set).
# Each Bash call is a fresh shell, so set SK on the same line.
SK=<path to the claude-animation skill>; CLAUDE_ANIMATION_LIB=$SK/lib node film.mjs sheet 0,1,2,3,4
SK=<path to the claude-animation skill>; CLAUDE_ANIMATION_LIB=$SK/lib node film.mjs strip 1.9 12
```

Sources:
- HyperFrames: https://raw.githubusercontent.com/heygen-com/hyperframes/HEAD/skills/hyperframes-cli/references/lint-validate-inspect.md
- Remotion: https://raw.githubusercontent.com/remotion-dev/skills/HEAD/skills/remotion-render/SKILL.md
- ClaudeAnimationBase: https://github.com/JohnHeibel/ClaudeAnimationBase/blob/main/ANIMATION_GUIDE.md
- claude-animation-skill: https://raw.githubusercontent.com/buildwithhanif/claude-animation-skill/HEAD/plugins/claude-animation/skills/claude-animation/templates/film-template.mjs

### From an encoded file (ffmpeg)

```bash
# whole-film contact sheet: the sample rate is set from the duration, so 54 tiles span the entire file
D=$(ffprobe -v error -show_entries format=duration -of csv=p=0 final.mp4); ffmpeg -i final.mp4 -vf "fps=54/$D,scale=384:-1,tile=6x9" -frames:v 1 sheet.png
# or a fixed 2 fps, one numbered sheet per 27 s page (no -frames:v 1)
ffmpeg -i final.mp4 -vf "fps=2,scale=384:-1,tile=6x9" sheet_%02d.png
ffmpeg -ss <cut-0.4s> -t 1 -i final.mp4 -vf "fps=10,scale=320:-1,tile=10x1" -frames:v 1 cut.png  # strip across a cut
ffmpeg -i out/final.mp4 -vf "fps=2,scale=480:-2,tile=6x6" master_%02d.jpg                       # master check, one sheet per 18 s
ffmpeg -ss A -t D -i ref.mp4 -vf "fps=30,scale=400:-2,tile=7x7" ref_tiles_%02d.png              # a motion, frame by frame, one sheet per 49 frames
```

A fixed-fps sheet with `-frames:v 1` covers only the first cols*rows/fps seconds (6x9 at 2 fps is 27 s, 6x6 at 2 fps is 18 s, 6x8 at 1 fps is 48 s) and silently drops the rest, including the end card. Scale the rate to the duration, or write numbered sheets.

Sources:
- 2 fps sheet and cut strip: https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/references/review.md
- Master check: https://raw.githubusercontent.com/buildwithhanif/claude-animation-skill/HEAD/plugins/claude-animation/skills/claude-animation/references/workflow.md
- Frame-by-frame motion: https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/references/product-hero-realism.md

### How to look

- **Write each sheet to a new filename.** Cached preview images make a fix look like it failed (claude-animation-skill traps).
- **Count frames per read.** Render a sheet at a fixed 0.1-0.15 s step and read it in order. At 24 fps, 24 frames is 1 s (ClaudeAnimationBase guide).
- **Batch checks into one sheet.** HyperFrames notes that attaching images mid-session invalidates the prompt cache (`production-loop.md`).
- **Look at mid-transition frames,** not just rest states.
- **Scan for single-frame pops:** frame-difference spikes about 3x their neighbours (https://x.com/twoclipping/status/2103835273813496100).
- **Phone size.** Remotion's layout rules at 1080 wide: side margins of about 80 px, top and bottom margins of about 100 px for key text, headlines of 84 px or more, supporting text of 44 px or more (https://raw.githubusercontent.com/remotion-dev/skills/HEAD/skills/remotion-create/video-layout.md). The supermemory pack checks at 360-390 px wide.
- **Contrast.** HyperFrames `check` audits WCAG AA (4.5:1, or 3:1 for large text).

## 3. Measurements

**Frozen time.** Each sample is 0.1 s; count samples with `YAVG` below 0.35 as near-frozen (https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/scripts/frozen-time.sh):

```bash
ffmpeg -hide_banner -i film.mp4 -vf "fps=10,scale=320:-1,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG" -an -f null - 2>&1 | grep -o "YAVG=[0-9.]*"
```

**Loudness and true peak:**

```bash
ffmpeg -hide_banner -i film.mp4 -af ebur128=peak=true -f null -                              # integrated, LRA, true peak
ffmpeg -i final.mp4 -af loudnorm=print_format=summary -f null -                               # quick summary
ffmpeg -i renders/final.mp4 -af loudnorm=I=-16:TP=-1.5:LRA=8:print_format=json -f null -     # first pass of two-pass loudnorm
```

To normalise rather than just measure, run that first pass on the mix WAV (swap `renders/final.mp4` for `mix.wav`), then the second pass, feeding in the first pass JSON values (`input_i`, `input_tp`, `input_lra`, `input_thresh`, `target_offset`):

```bash
ffmpeg -i mix.wav -af loudnorm=I=-16:TP=-1.5:LRA=8:measured_I=<input_i>:measured_TP=<input_tp>:measured_LRA=<input_lra>:measured_thresh=<input_thresh>:offset=<target_offset>:linear=true -ar 48000 mix_norm.wav
```

Run both passes on the mix WAV before the mux, then re-measure the encoded MP4 with `ebur128`, because true peak rises in the AAC encode. Option names: https://ffmpeg.org/ffmpeg-filters.html#loudnorm

**Ducking.** Sidechain the music under the voice (or an SFX stem), then mix:

```bash
ffmpeg -i music.wav -i voice.wav -filter_complex "[1:a]asplit=2[sc][vo];[0:a][sc]sidechaincompress=threshold=0.03:ratio=10:attack=15:release=350[duck];[duck][vo]amix=inputs=2:normalize=0[out]" -map "[out]" mix.wav
```

Tune `threshold` and `ratio` by measuring: the supermemory pack wants music 18-20 dB under a voice. Option names: https://ffmpeg.org/ffmpeg-filters.html#sidechaincompress

Sources:
- ebur128: https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/scripts/loudness.sh
- Summary: https://raw.githubusercontent.com/buildwithhanif/claude-animation-skill/HEAD/plugins/claude-animation/skills/claude-animation/references/sound.md
- Two-pass: https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/references/audio-and-qa.md

**Score structure without listening.** `ffmpeg -i music.wav -lavfi showspectrumpic=s=1600x500:scale=log:fscale=log music-spec.png` (guizang review.md).

**Audio sync.** Render the picture muted and mux it:

```bash
ffmpeg -loglevel error -y -i picture.mp4 -i soundtrack.wav -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 320k -movflags +faststart -shortest out.mp4
```

`apad` pads the audio with silence so `-shortest` keeps the picture's length, and the end card is never cut off (https://ffmpeg.org/ffmpeg-filters.html#apad).

Then cross-correlate the decoded audio against the source WAV at several points. claude-launchvideo's `check-sync.py` fails if they are more than 1 ms apart or the true peak is above -1 dBTP (https://raw.githubusercontent.com/Leonxlnx/claude-launchvideo/HEAD/scripts/render.sh).

**Audible, not just present.** One delivered MP4 had an AAC track measured at -79.5 dB, effectively silent. A stream existing does not mean anyone can hear it (athemeroy cases.csv).

### Quality bar (motion-video-kit, https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/references/quality-bar.md)

**Measured:**

| Measure | Target |
|---|---|
| Frozen time | At most about 1 s per 30 s, and no single hold over 0.6 s except the final CTA |
| Loudness | About -14 LUFS punchy, about -16 calm; true peak at or below -1 dBFS |
| Loudness range (LRA) | About 3 LU or more for energetic scores, 1.5-3 for calm |
| SFX level | About +4 dB in their own band over the music; never 10+ dB spikes at 2-8 kHz |
| Text contrast | WCAG AA on settled text |
| Brand colour | The sampled background matches the brand token |
| Determinism | The same frame from different seek orders is identical |

**Visual:**
- Frame 0 is finished.
- No text collisions, even mid-transition.
- Equal spacing and aligned left edges.
- The CTA is readable at phone size for at least about 1.5 s.

**Loudness targets elsewhere.** claude-animation-skill defaults to -16 LUFS and -1.5 dBTP. guizang starts at about -16 LUFS and -1 to -1.5 dBTP, re-measured after the AAC encode. The supermemory pack masters at -16 LUFS.

## 4. Common failures and fixes

### Timing and runtime

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Render is blank, or frozen at t=0 | Timeline registered before an async build finished; or, with 2+ timelines, a `__timelines` key that does not match `data-composition-id` | Register at the end of the build; make host id, inner root id and key identical | HyperFrames determinism-rules.md, sub-compositions.md |
| Tiny unstyled text in the render while checks pass | Sub-composition `<style>`/`<script>` in `<head>`, which is discarded | Put everything inside `<template>` | HyperFrames sub-compositions.md |
| An animation's last frame never shows | The clip window is half-open `[start, start+duration)` | Land end states slightly before the clip ends | HyperFrames data-attributes.md |
| Every render waits about 45 s | No timeline registered | Set `data-no-timeline` on the root | HyperFrames troubleshooting.mdx |
| `check` reports 0 samples and looks clean | A lint error disabled the layout and contrast audits | Fix lint first | HyperFrames lint-validate-inspect.md |
| `sweep_static` fails | Reveals finish early, then a 3 s+ static hold | Spread the reveals or keep one element moving, but never add meaningless wobble | HyperFrames; guizang review.md |
| Remotion values overshoot | `interpolate()` is unclamped by default | Add both `extrapolate` clamps | Remotion timing.md |
| Remotion flicker | CSS or Tailwind animations, or R3F `useFrame()` | Drive everything from `useCurrentFrame()` | Remotion markup SKILL.md, 3d.md |
| Video cut short or padded | `<TransitionSeries>` transitions shorten the total | Recompute the parent `durationInFrames` | Remotion transitions.md |
| `npx remotion render` hangs | No composition id, so it opens a picker | Pass the id and an output path | Remotion cli/render.md |
| Frames differ between runs, or still elements jitter | State carried between frames; `Math.random()`; one moving element shifting the RNG stream for everything drawn after it | Pure `f(t)`; seed per element from stable names; run `verify` | ClaudeAnimationBase guide; claude-animation-skill |
| GSAP build hangs | Awaiting the paused master timeline, which is thenable and never resolves | Never `await` it | guizang starter.md |
| GSAP from-values wrong | `fromTo` writes from-values at build time | Measure layout before building tweens | guizang starter.md |
| Tweens lost on React nodes | Targeting nodes React re-renders | Animate stable wrapper nodes | guizang starter.md |
| Product micro-animations fight the clock | CSS transitions or framer-motion in the product | Freeze CSS animations; `MotionGlobalConfig.skipAnimations = true` | guizang |
| Error reading `useContext` on null | Two copies of React in the bundle | Alias react and react-dom to the video project's copy | guizang starter.md |
| Popovers drift under 3D | Portals mounted on `body` | Redirect the portal container into the shot | guizang |
| Every canvas goes blank after a parallel edit | A syntax error in a shared module | Edit a copy, run `node --check`, then `mv` it into place | motion-video-kit |

### Text and layout

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Headline runs off the frame | Size guessed, not measured | Measure in the real DOM after fonts load and size from that | claude-launchvideo commits |
| Fallback-font frames, wrong measurements | Fonts not loaded or not bundled | Gate the render on fonts (`delayRender` until `document.fonts.load`); add a local `@font-face` | claude-launchvideo FontGate; HyperFrames typography.md |
| `-apple-system` renders as Times | Headless Chrome has no system font mapping | Bind `@font-face` to local font files | motion-video-kit product-hero-realism.md |
| Text overlaps during a morph | Container and content animate together | Content enters after the container starts and leaves before the next morph; give swapping text its own mask | https://x.com/verbove/status/2103483957266268381; twoclipping |
| A wipe splices two titles into one word | Titles overlap the wipe | The outgoing title leaves before the wipe; the incoming enters after | motion-video-kit |
| Text flies through other text | Moving text between positions | Fade out, then fade in at the destination | motion-video-kit |
| A retained heading drifts about 12 px | Its parent has a slow scale push | Give the overlay the same push | motion-video-kit |
| A card is blank for 0.2 s between states | Content swapped out and in | Crossfade the contents in place | motion-video-kit |
| Text blurry under camera zoom | `will-change` on something the camera scales | Remove it | guanmo prompt 2103273003555402193 |
| Both faces of a 3D card show | `opacity` or `filter` on a `preserve-3d` element flattens it | Fade a wrapper instead | guanmo prompt 2102554209166000267 |
| A scaled `<span>` does nothing | Transformed elements must be block-level and sized | Make it block or inline-block with a size | HyperFrames determinism-rules.md |
| Title overlap survives several re-renders | Re-running without looking | Verify with frame probes, not by re-running | athemeroy cases.csv (@yrzhe_top) |

### Chromium rendering

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Contour rings, tints or darkening in gradients or motion blur | Chromium composites in 8 bits | Pre-bake dithered PNG backdrops; average motion-blur samples in float outside the browser and dither once | claude-launchvideo |
| Slow drifts move in steps | Fractional `left`/`top` combined with a transform snaps the layer | Put the translation inside the transform | claude-launchvideo commits |
| Console errors, stale shapes | Spring overshoot gave an SVG geometry a negative radius | Clamp spring outputs that drive geometry | claude-launchvideo commits |
| Stray ghost frames | Compositor promotion on layers with animated blur | No promotion on those layers | claude-launchvideo commits |
| Stepped blur ramp | Chromium's own blur steps | Crossfade a sharp copy and a blurred copy | claude-launchvideo RackFocus |
| Glass effect wrong | `backdrop-filter: url()` misreads displacement maps | Clone the scene behind the glass element | twoclipping |
| A hidden parent shows its child | Child has `visibility: visible` | Use `visibility: inherit` | twoclipping |
| Half the screen changes in one frame | A flood that does not overscale past the corners, or is too fast | Overscale and take about 0.3 s | twoclipping |
| Footage will not seek | `python -m http.server` cannot range-seek | Load as a blob URL; re-encode all-intra (`-g 1`); await `seeked` | twoclipping |
| Moving map shimmers | Per-frame `jumpTo()` | Render one fixed plate, move it with CSS; validate with an MP4 | Remotion maps |
| Chromium dies at startup | macOS seatbelt agent sandbox | Render outside the sandbox; do not build a substitute rasterizer | HyperFrames doctor-browser.md |
| Brand background colour shifts | ACES tone mapping in Three.js | Measure rendered pixels and compensate | motion-video-kit |
| Watercolour fills take seconds per frame | No dedicated GPU | Ask the model to avoid them on integrated graphics | ClaudeAnimationBase README |
| Misleading OffscreenCanvas error | A NaN in a p5.brush point list | Check the point list for NaN | ClaudeAnimationBase guide |

### Motion

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| One-frame pop at the start of a lift | A cubic ease-out starts at full speed | Smootherstep `x*x*x*(x*(x*6-15)+10)` with staggers of 5 ms or less | motion-video-kit three-js-patterns.md |
| Mid-swing speed hiccup on measured motion | Smoothstep between measured keys | A monotone cubic (Fritsch-Carlson) with zero end slopes | motion-video-kit product-hero-realism.md |
| Grey mush between shots | A long crossfade between a light and a dark shot | Hard-cut, or blur the subject out first | guizang direction.md |
| Muddy colour | Fading black straight into the accent | Move an accent element between states | verbove |
| Looks like a slideshow | Changes ease slowly, every element enters the same way | Snap then hold (change in 1-2 frames, ease the settle); vary entrances | claude-animation-skill motion.md; guizang |
| Loop pops | The last frame differs from the first, including cursor position and speed | Make them identical | guanmo prompt |
| Dead time nobody noticed | The builder's own checks missed about 10 of 36 s | Measure frozen time; use a fresh critic | motion-video-kit |
| Scene starts empty | Data loads after the cut | Load during the fly-in | claude-launchvideo commits |

### Audio

| Symptom | Cause | Fix | Source |
|---|---|---|---|
| Audio about 2.5 frames late | Encoder priming from Remotion's AAC mux, as measured in one project | `--muted` render, ffmpeg mux, sync check | claude-launchvideo |
| Every hit 2 frames late | The SFX file has a 33 ms lead-in | Align by measured onset (clicks) or peak (whooshes, impacts) | motion-video-kit; guizang audio-and-qa.md |
| SFX buried | Synthesised SFX peak near -20 dBFS against recordings near 0 dBFS at the same gain | Set gains from measured peaks; duck the music under key SFX | guizang |
| Repeated booms | Whooshes with more than 50% of their energy under 150 Hz | Reject them, or soften: `ffmpeg -loglevel error -y -i in.mp3 -af "highpass=f=150,lowpass=f=6500,afade=t=in:d=0.01,afade=t=out:st=<dur-0.15>:d=0.15" -ar 48000 out.mp3` | motion-video-kit audio.md, soften-sfx.sh |
| "Sounds AI-generated" | Whooshes on every transition, metronome ticks, synthesised thocks | Fewer, more physical sounds; library or recorded SFX | supermemory pack feedback rules; motion-video-kit |
| Music ends before the logo | Track trimmed to length | Edit the track so its own final hit lands on the end card; a 5 ms fade-in avoids a click | motion-video-kit audio.md |
| Clipping after export | True peak rises in the AAC encode | Re-measure true peak after encoding | guizang; claude-launchvideo |
| Music does not match the reference | The reference fetch failed silently | Confirm references actually loaded before relying on them | guanmo cases.json (@cromwellian) |
| Silent audio in HyperFrames | `<audio>` with no `id`, `crossorigin` on media, or a timed video missing `data-has-audio="true"` | Fix the attributes | HyperFrames variables-and-media.md |

### Tooling

| Symptom | Fix | Source |
|---|---|---|
| Homebrew ffmpeg has no `drawtext` for sheet labels | Draw labels in canvas or PIL and overlay them | claude-animation-skill traps.md |
| zsh eats `$var:l`-style text in scripts | Brace every variable: `${e}` | claude-animation-skill traps.md |
| H.264 yuv420p fails or pads | Use even width and height | A general encoding rule noted during research, not taken from a post or repo |
| Remotion config hardcodes a Linux browser path | Remove `Config.setBrowserExecutable(...)` before rendering on a Mac | claude-launchvideo `remotion.config.ts` |

## 5. Critic loop (motion-video-kit Gauntlet)

Source: https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/references/gauntlet.md

1. The builder never grades its own work. Spawn a fresh critic subagent each round.
2. Give the critic only the artifact (the MP4 or frames it extracts itself, not screenshots you chose), the brief and the client's own words, the references, and the previous critic report. Never give it your reasoning or your list of fixes.
3. The critic extracts contact sheets every 0.1-0.25 s plus dense 1/30 s windows around every transition, and computes frame difference and loudness.
4. Fix the highest-impact items first.
5. The next critic marks each earlier item FIXED, PARTLY or STILL PRESENT, looks for regressions, and ends with SHIP or ONE MORE PASS.
6. Stop at the quality bar, or when the gains turn cosmetic (usually 3-5 rounds).
7. Keep a ledger: round, artifact, findings, changes, measured result.

The kit ships prompts for a component critic (KEEP, REVISE or REJECT), a full-film critic, a verification critic and a storyboard critic.

## 6. Delivery

**Hand over:**
- the master MP4 at the agreed spec (motion-video-kit delivers motion work at 1080p60)
- a poster frame and a contact sheet
- the editable project and the exact render command
- an asset and licence list
- any generation ledger
- a music-only fallback when there is a mix

**State honestly:**
- what was measured automatically
- what you actually looked at
- what was sampled versus checked exhaustively
- what nobody has listened to yet

guizang also says never to claim listening that did not happen.

**For social posts:** frame 0 must be a finished picture, because X and Threads use it as the thumbnail. Hold a still of the finished opening for about 0.3 s, then fade it (guizang). Offer the extra aspect ratios (1:1, 16:9, 9:16) rendered from the same timeline if the brief needs them.
