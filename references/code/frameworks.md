# Frameworks and kits

How each route authors a scene, keeps time, renders, handles audio and fonts, and where it breaks. Commands come from the linked sources, except those marked as written for this skill or cited to ffmpeg.org, npm or Python docs; none were run during research. Installing or scaffolding any of these needs the user's yes first (see `setup.md`). `HF` below is shorthand for a file path in the heygen-com/hyperframes repo (raw copies live under raw.githubusercontent.com/heygen-com/hyperframes/HEAD/ plus the path), and `RS` for a file path in the remotion-dev/skills repo (raw.githubusercontent.com/remotion-dev/skills/HEAD/ plus the path). The prefixes are not pages on their own.

## Contents

1. Choosing
2. HyperFrames
3. Remotion
4. Plain page + headless browser + ffmpeg
5. Node canvas (claude-animation-skill)
6. Reference projects worth reading
7. 3D
8. Licences at a glance

---

## 1. Choosing

| Task family | Renderer the athemeroy audit maps it to |
|---|---|
| Product UI and brand motion | SVG, Canvas or Remotion |
| Explainers | Manim, SVG or Remotion, plus TTS |
| Abstract loops and music response | Canvas, p5.js or WebGL, with fixed seeds and beat data |
| Interactive 3D | Three.js, WebGL or Blender |
| Stylised, paper or character | A reusable style or rig system |
| Physics | A real solver with baked caches |
| Live action | Supplied footage plus editing tools |

Source: https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/visual-effects-fit.md

**HyperFrames vs Remotion:**
- Remotion is React plus `useCurrentFrame()` and needs a bundler. HyperFrames is HTML plus a paused timeline that the renderer seeks, with no build step.
- Remotion uses its own source-available licence; HyperFrames is Apache-2.0.
- The HyperFrames docs rate Remotion and its Lambda renderer as more mature. They also warn that HyperFrames depends on authoring rules, such as a paused timeline, no wall-clock time and seeded randomness, and fails silently when one is broken (https://github.com/heygen-com/hyperframes#hyperframes-vs-remotion).
- One creator tried Remotion first, then switched to HyperFrames (athemeroy cases.csv, @leodev).

**Default.** HyperFrames for new work: no React, agent gates, catalog blocks, no licence fee.
**Remotion** when the project already uses it, or when the user wants Studio editing, the Player, Lambda, the caption editor or maps, and the licence fits.
**A plain page** when you need one file with total control, or a full framework is unwanted. It still needs puppeteer-core or Playwright, so ask first.

---

## 2. HyperFrames

> **Updated 2026-10-21.** This section was written against 0.8.111 (Oct 2). For any supermemory film, `../hyperframes.md` (0.8.181, installed as the plugin) supersedes it: setup, the contract, craft overrides, QA and open Mac bugs. The fixes below mark the lines that changed.

**Facts:**
- Repo: https://github.com/heygen-com/hyperframes, Apache-2.0, version 0.8.111, last commit 2026-10-02.
- npm package: `hyperframes`, needs Node 22+.
- Docs: https://hyperframes.heygen.com. Markdown copies are at `/llms.txt`, and each page has a `.md` variant.
- It ships 21 published agent skills and a registry of 448 blocks and components (210 blocks, 238 components on 2026-10-21).
- Command lines in this section use the pinned local CLI (`HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes ...`). Put `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1` in front of each one (see Commands below and `setup.md`).

### How a scene is authored

A video is an HTML file. `data-*` attributes declare timing, and a paused, seekable animation runtime moves things (GSAP by default). The renderer seeks every frame in headless Chrome (BeginFrame capture on Linux with chrome-headless-shell; Page.captureScreenshot on macOS/Windows and for transparent output) and encodes with FFmpeg, so the same input gives the same output. **Changed by 0.8.181:** on macOS with a hardware GPU the default capture is Chrome's drawElement ("fast capture") with a screenshot fallback, and it can drop a late scene file in renders past about 700 frames (open #5415), so `engine/hyperframes-starter/make.sh` forces screenshot capture.

Contract (HF`skills/hyperframes-core/SKILL.md`, HF`skills/hyperframes-core/references/data-attributes.md`):

- **The root element** is a `<div>` directly in `<body>` with `data-composition-id`, `data-width`, `data-height` and (recommended) `data-duration`. Style it at 100% width and height, never a hardcoded 1920px. A standalone `index.html` must not be wrapped in `<template>`.
- **`data-start` makes an element a clip.** Add `data-duration` and `class="clip"`. The class is a convention: the runtime never reads it, but lint warns when it is missing. `data-track-index` is only a Studio display lane.
- **One timeline.** Create exactly one `gsap.timeline({ paused: true })` per composition and register it as `window.__timelines["<composition-id>"]`. The key must equal the root id. Never call `tl.play()`.

Skeleton (illustrative, written for this skill):

```html
<div id="root" data-composition-id="promo" data-width="1920" data-height="1080" data-duration="8">
  <section id="hook" class="clip" data-start="0" data-duration="3">
    <div class="hook-inner"><h1 id="headline">...</h1></div>
  </section>
</div>
<script src="assets/gsap.min.js"></script>
<script>
  const tl = gsap.timeline({ paused: true });
  tl.fromTo("#headline", { y: 48, opacity: 0 }, { y: 0, opacity: 1, duration: 0.6, ease: "power3.out" }, 0.2);
  window.__timelines["promo"] = tl;
</script>
```

Vendor GSAP. With the user's OK, download gsap@3.14.2 once into `assets/gsap.min.js` (the templates load it from https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js), record its source and licence in `ASSETS.md`, and load it with `<script src="assets/gsap.min.js"></script>`. A CDN `<script>` is a render-time fetch, which SKILL.md section 2 bans. Swap out the CDN tag that init templates ship with.

### Timing (HF`skills/hyperframes-core/references/data-attributes.md`)

- **Render length.** It is the root `data-duration`, read once at compile time. The GSAP timeline length does not set it: a longer timeline is cut off, and a shorter one holds its last frame. Do not pad with empty tweens, and do not change the root duration from script or `--variables`.
- **Visibility window.** It is half-open, `[start, start+duration)`. Land end states slightly before the clip ends, or the last frame never renders. Back-to-back clips do not overlap.
- **fps.** `data-fps` is a hint. The CLI default is 30 fps; `--fps 60` doubles render time.
- **Clip attributes.** `data-media-start` is the offset into the source. `data-volume` defaults to 1, maximum 3.98. `data-playback-rate` accepts 0.1 to 10.
- **Layout.** Direct children of the root that are clips get automatic full-frame layout. Untimed full-bleed backgrounds need their own `position:absolute; inset:0`.
- **No timeline.** A composition that never registers a timeline should set `data-no-timeline`, or every render waits a 45 s ready timeout (HF`docs/guides/troubleshooting.mdx`).

### Animation rules (HF`skills/hyperframes-core/references/determinism-rules.md`, HF`skills/hyperframes-animation/SKILL.md`)

- **Banned:**
  - `Date.now()`, `performance.now()`, unseeded `Math.random()`
  - render-time fetches
  - hover, scroll or pointer state
  - `repeat: -1`. Use `repeat: Math.max(0, Math.floor(duration / cycleDuration) - 1)`, with floor, not ceil. (0.8.181 lint only warns when the root duration is finite; keep repeats finite anyway.)
- **Async builds.** Building inside `document.fonts.ready` is fine if you register the timeline only after the tweens are added. An empty timeline registered early renders blank. One skill says never build in async code; the core skill allows it. Follow core.
- **Clip elements.** Never tween `display`, `visibility` or `autoAlpha` on a `.clip`; animate a child wrapper. Never set a CSS transform and then tween the same property with GSAP; use `fromTo` or `xPercent`/`yPercent`.
- **Transforms and opacity only.** Tweening `width`, `height`, `top`, `left`, `margin`, `letterSpacing` or `fontSize` is a lint error since 0.8.181 (`gsap_non_transform_motion`): layout snaps to whole pixels and slow settles stutter. `filter` and `clipPath` are legal but costly.
- **Layout constants.** Precompute them at setup. Never call `getBoundingClientRect()` at tween time, because frames are sampled in parallel.
- **Text:**
  - No `<br>` in body text; wrap with `max-width`.
  - Transformed elements must be block-level and sized.
  - Fit text with `window.__hyperframes.fitTextFontSize(...)` or `window.__hyperframes.pretext`.
  - Counters: `tl.to(el, { innerText: 100, snap: { innerText: 1 } })`.
- **Compose before you write.** Pick 2-4 rules from the skill's `rules-index.md` and glue them with one timeline. Search the catalog first: `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes catalog --query "<the beat, in plain English>"`, then `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes add <name>`.
- **Keyframes contract** (HF`skills/hyperframes-keyframes/SKILL.md`):
  - The final frame is part of the animation. Do not reset to rest or end on black unless asked.
  - Punch-ins and Ken Burns moves go on a non-timed wrapper inside the clip.
- **Seam craft** (the repo's internal motion-doctrine skill, HF`.claude/skills/motion-doctrine/SKILL.md`):
  - Keep the same axis, direction and speed across a cut, and cut mid-motion.
  - Mirror the eases (exit `power4.in` into entry `power4.out`).
  - One dominant direction per film. No idle wobble.

### Other runtimes (https://github.com/heygen-com/hyperframes/tree/main/skills/hyperframes-animation/adapters: HF`skills/hyperframes-animation/adapters/gsap.md`, `css-animations.md`, `waapi.md`, `lottie.md`, `three.md`, `animejs.md`)

| Runtime | How to make it seekable | Duration inferred? |
|---|---|---|
| GSAP | Register the paused timeline | Yes |
| CSS keyframes | Finite iterations and `animation-fill-mode: both` | Yes, if finite |
| WAAPI | `fill: "both"`, finite iterations | Yes, if finite |
| Lottie / dotLottie | `window.__hfLottie.push(anim)` with `autoplay:false` and an explicit `loop`. Use local `assets/` paths for the animation and the player script | Yes |
| Three.js | Render on the `hf-seek` event from `window.__hfThreeTime`, never from rAF. `renderer.setSize(1920,1080,false)`, `setPixelRatio(1)` | **No.** Root `data-duration` is required |
| Anime.js v4 | `window.__hfAnime.push(x)` with `autoplay:false`. `anime()` is a TypeError in v4, and `easing:` became `ease:` | Yes |

### Sub-compositions (HF`skills/hyperframes-core/references/sub-compositions.md`)

- **The host** is a `<div>` with `data-composition-id`, `data-composition-src="compositions/x.html"`, `data-start`, `data-duration`, `data-width` and `data-height`.
- **Everything goes inside `<template>`.** In the sub-composition file, put the `<style>`, the markup and the `<script>` all inside it, because `<head>` is discarded at mount. Static checks pass even when this is wrong, and the render shows tiny unstyled text.
- **One id three times.** The host id, the inner root id and the `__timelines` key must be identical. With two or more timelines, a mismatched key freezes the render at t=0.
- **Unique ids.** Prefix inner ids with the composition id.
- **Styling and scope.** Style the root by `#root`, never by a class. A sub-composition cannot animate elements in the host.

### Variables (HF`skills/hyperframes-core/references/variables-and-media.md`)

- **Declare** on `<html>` as `data-composition-variables='[{"id":"title","type":"string","label":"Title","default":"Hello"}]'`. Types: string, number, color, boolean, enum.
- **Bind** with `data-var-text="id"` or `data-var-src="id"`. Each scalar is also exposed as the CSS property `--{id}`.
- **Read in script** once at init with `window.__hyperframes.getVariables()`.
- **Override per render:** `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes render --variables '{"title":"Q4 Report"}'`, adding `--strict-variables` in CI.
- **Batch:** `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes render --batch rows.json --output "renders/{name}.mp4"`.

### Media and audio (HF`skills/hyperframes-core/references/variables-and-media.md`, HF`skills/hyperframes-audio/references/attributes.md`)

- **The framework owns playback.** Never call `play()`, `pause()` or set `currentTime`.
- **Every `<audio>` needs an `id`,** or it renders silent.
- **Never use `crossorigin`** on media. It is a hard lint error.
- **Timed `<video>`:**
  - It keeps its sound only with `data-has-audio="true"`; otherwise mark it `muted`.
  - Do not nest it inside another timed element.
  - Animate a wrapper, never the video's own dimensions.
- **Music and voice** go in separate `<audio>` elements, for example `id="music"` with `data-start`, `data-duration` and `data-volume="0.4"`.
- **Fades and ducking** go in a `data-automation` volume lane, not a GSAP volume tween. Effects go in a `data-fx-chain` JSON attribute (highpass, lowpass, compressor, limiter, reverb and more). Submix buses use `<hf-audio-group>`.
- **Voiceover carve.** The skill's `carve.mjs` dips the music only in the voice's frequency bands.
- **Loudness matching** on `data-volume`: `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes normalize-audio --reference <id> --target <id> [--write]`.
- **Asset tools** (each may download a model on first run, so ask first): `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes tts`, `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes transcribe interview.mp4` (word-level, Parakeet or Whisper), `HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes remove-background`.

### Fonts (HF`skills/hyperframes-creative/references/typography.md`)

- **Bundled.** 18 families render offline, including Inter, Montserrat, Oswald, League Gothic (400 only), Archivo Black (400 only), Space Mono, IBM Plex Mono and JetBrains Mono.
- **Anything else** needs a local `@font-face`, or lint warns `font_family_without_font_face` and cloud renders fail closed.
- **Design advice.** The creative skill lists Inter, Roboto, Poppins, Playfair and Syne as an overused "monoculture" and says not to pair two sans-serifs.

### Commands (HF`README.md`, HF`skills/hyperframes-cli/SKILL.md`, HF`skills/hyperframes-cli/references/preview-render.md`)

Each Bash call starts a fresh shell, so the opt-outs go on every command. The first two lines need the user's yes (setup.md); after that the CLI runs from the pinned local copy with `npx --no`.

```bash
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx hyperframes@<version> init my-video --non-interactive --example=blank
cd my-video && npm install --save-dev --save-exact hyperframes@<version>
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes lint      # static check
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes check     # full browser gate
HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_SKIP_SKILLS=1 npx --no hyperframes render --quality delivery --output out.mp4
```

Other subcommands and flags, each run the same way (prefix plus `npx --no hyperframes`):

```bash
preview                                      # browser preview with live reload
preview --background                         # Studio in the background; stop with: preview --stop
render --quality draft                       # fast iteration
render --quality looks --output out.mp4      # first real encode
render --docker --strict --output out.mp4    # reproducible container render
render -c compositions/intro.html -o intro.mp4   # one composition file
render --fps 60 --quality delivery
render --format webm --output overlay.webm   # transparent (VP9 alpha)
render --format mov --output overlay.mov     # transparent (ProRes 4444)
render --format gif --fps 15 --output preview.gif
snapshot --at <t1>,<t2>,<t3>
check --snapshots
timeline --json
```

**Render flags:**
- **Quality.** `--quality` takes draft, looks, delivery, standard or high. The CLI skill says the default is `looks` (CRF 16) while the rendering docs say `standard`, so always pass it explicitly.
- **Other options:**
  - `--format mp4|webm|mov|gif|png-sequence|hls`
  - `--crf` or `--video-bitrate`, never both
  - `--workers N|auto` (each worker is a Chrome using about 256 MB)
  - `--gpu`, `--browser-gpu`, `--browser-timeout`
- **Output name.** The default is a timestamped file under `renders/`, so pass `-o` for a stable name.
- **Transparent output.** Leave `html`, `body` and the root unpainted.
- **Read the summary line.** The render summary's second line reports capture mode, GPU and stage timings. `screenshot` plus `software gpu` on Linux is the slow path.

**Gates:**
- `check` covers lint, runtime errors, failed requests, layout overflow and overlap, motion assertions and WCAG AA contrast. It must report 0 findings.
- A lint error disables the layout and contrast audits, so "0 samples" does not mean clean.
- A composition of 3 s or longer fails `sweep_static` if nothing moves across the samples. Spread the reveals or keep one element moving.
- Batch visual checks into one contact sheet, because attaching images mid-session invalidates the prompt cache (`production-loop.md`).

**Bundled workflows.** The router (`/hyperframes:hyperframes` in the Claude Code plugin, `/hyperframes` as a standalone skill) picks one of:
- remotion-to-hyperframes
- slideshow
- embedded-captions
- talking-head-recut
- music-to-video
- motion-graphics (short, usually under 10 s, no narration; HyperFrames' own skill, not this one)
- pr-to-video
- product-launch-video (up to about 3 minutes)
- faceless-explainer
- general-video

In the motion-graphics workflow, a Director subagent writes `shot-plan.json` and a Builder subagent adds catalog blocks before customising. The workflow then runs `lint`, `check` and `snapshot`, and asks the user whether to preview or render (HF`skills/motion-graphics/SKILL.md`).

**Porting from Remotion** (HF`skills/remotion-to-hyperframes/SKILL.md`):
- `useCurrentFrame` and `interpolate` become tweens, with frames converted to seconds.
- `Sequence` becomes a clip, and each scene becomes a `<template>` sub-composition.
- The port refuses `useState`/`useEffect` state machines.
- Validate the port by SSIM, with `png` and `bt709` settings matched on the Remotion side.

---

## 3. Remotion

**Facts:**
- The skills live in `remotion-dev/skills` (https://github.com/remotion-dev/skills). It mirrors `remotion/packages/skills` at version 4.0.532 and has no LICENSE file, so paraphrase rather than copy.
- There are 12 slash skills. `remotion-best-practices` routes to `remotion-create`, `remotion-markup` (about 30 rule files), `remotion-studio`, `remotion-render`, `remotion-captions`, `remotion-interactivity`, `remotion-maps`, `remotion-multimedia`, `remotion-saas`, `remotion-docs` and `remotion-upgrade`.
- The layout was split in July 2026, so guides citing `skills/remotion/rules/*.md` are stale.

### How a scene is authored (RS`skills/remotion-markup/SKILL.md`, https://www.remotion.dev/docs/the-fundamentals.md)

**The model.**
- A video is a React component plus `width`, `height`, `durationInFrames` and `fps`.
- Frames run from 0 to `durationInFrames - 1`.
- Compositions are registered in `src/Root.tsx`.

**Animation.**
- Drive every animation from `useCurrentFrame()` and `interpolate()`. CSS transitions and animations, and Tailwind `animate-*` or `transition-*` classes, do not render correctly.
- `interpolate()` does not clamp by default. Always add `extrapolateLeft: "clamp"` and `extrapolateRight: "clamp"`.
- Express ranges in seconds through fps, for example `[0, 0.3 * fps]`.
- Shape timing with `Easing.bezier(0.16, 1, 0.3, 1)` or `Easing.spring({damping: 200})` (a push with no bounce). Use `output: 'perceptual-scale'` for scale and `posterize: N` for a stepped look.
- Keep `interpolate()` inline in the `style` prop, and use the separate `scale`, `translate` and `rotate` properties so Studio can edit keyframes.
- The classic `spring({frame, fps, config})` still exists (defaults: mass 1, damping 10, stiffness 100). Raise damping to remove the bounce (https://www.remotion.dev/docs/spring.md).

Illustrative (written for this skill):

```tsx
const frame = useCurrentFrame();
const { fps } = useVideoConfig();
const opacity = interpolate(frame, [0, 0.5 * fps], [0, 1], {
  extrapolateLeft: "clamp", extrapolateRight: "clamp",
  easing: Easing.bezier(0.16, 1, 0.3, 1),
});
```

**Timing and sequencing** (RS`skills/remotion-markup/timing-props.md`, `sequencing.md`, `transitions.md`, `multi-scene-video.md`):
- **Timing props on components.** Put timing props (`from`, `trimBefore`, `durationInFrames`, `playbackRate`, `loop`) directly on components that support them. Remotion applies them in that order, so a child's frame is `trimBefore + (frame - from) * playbackRate`. Use `<Sequence>` only for a shared clock, a dimension override, or a component without timing props.
- **Premount.** Set `premountFor={fps}` on every timed component that supports it.
- **Series.** `<Series>` plays scenes back to back. `<TransitionSeries>` adds `fade`, `slide`, `wipe`, `flip` and `clockWipe` (`npx remotion add @remotion/transitions`).
- **Durations.** Transitions overlap and shorten the total (60+60-15=105), while overlays do not, so compute the parent `durationInFrames` to match.
- **Multi-scene films.** Use one file and one component per scene, each registered as its own `<Composition>` inside a `<Folder>`, plus the parent. That lets you iterate on one act without scrubbing the whole film (also used by https://github.com/Leonxlnx/claude-launchvideo).
- **Registration.** Write `<Composition>` props as inline literals (no variables, spreads or `satisfies`), use `type` rather than `interface` for props, and use `<Still>` for single frames.

**Assets, media, fonts, captions.**
- **Assets.** Put them in `public/` and reference them with `staticFile()`.
- **Media components.** `<Video>` and `<Audio>` come from `@remotion/media`. Images use `<Img>` or `<CanvasImage>`, and GIF/APNG/WebP use `<AnimatedImage>`.
- **Fonts.** Prefer `loadFont` from `@remotion/google-fonts/<Font>` at module top level, which blocks the render until loaded. Local files use `@remotion/fonts`. Measure text only after fonts load (`@remotion/layout-utils`: `measureText`, `fitText`).
- **Audio.** Layer `<Audio>` elements. Volume can be static, an inline `interpolate`, or a callback. `toneFrequency` (pitch) works only in server-side renders, not in Studio or the Player. Audio visualisation uses `@remotion/media-utils` (`visualizeAudio`, `useWindowedAudioData`).
- **Captions.** Captions are `Caption[]` JSON. Transcribe locally with `@remotion/whisper-webgpu` or import SRT with `parseSrt()`.
- **Voiceover.** ElevenLabs per scene, with `calculateMetadata` summing the durations. The user sets `ELEVENLABS_API_KEY` (RS`skills/remotion-markup/voiceover.md`).

**Effects, 3D, maps.**
- **Effects.** Prefer plain HTML and CSS first, then `effects={[...]}` from `@remotion/effects`. WebGL effects need `--gl=angle`.
- **3D.** Use `<ThreeCanvas>` from `@remotion/three` and animate only from `useCurrentFrame()`. React Three Fiber's `useFrame()` is forbidden.
- **Moving maps.** Render a fixed map plate once and move it with CSS translate and scale, because per-frame `jumpTo()` shimmers. Validate with a rendered MP4, not Studio.

**Layout** (RS`skills/remotion-create/video-layout.md`):
- "You are designing a video, not a webpage."
- Build each scene around one focal point and add no redundant elements.
- Margins at 1080 wide: about 80 px left and right and 100 px top and bottom for key text.
- Headlines at least 84px, supporting text at least 44px, scaled to the composition width.

### Agent workflow (RS`skills/remotion-best-practices/SKILL.md`)

- If the user changed something outside the chat, keep it; assume it was intentional.
- Open Studio as soon as the project runs, before building, and keep it open.
- Render only when the user explicitly asks (render, export, give me the MP4).
- For an API you are unsure of, fetch the current docs page as Markdown by appending `.md`, for example https://www.remotion.dev/docs/sequence.md, rather than relying on memory.

### Commands

```bash
npx create-video@latest --yes --blank --no-tailwind my-video
cd my-video
npm i
npx remotion studio --no-open          # prints the URL; a composition lives at /<composition-id>
npx remotion render <composition-id> out/frames --frames=0,30,90 --image-format=png   # chosen frames as PNGs
npx remotion still
npx remotion render HelloWorld          # by composition id; append an output path to override out/
npx remotion render --image-format=png --pixel-format=yuva444p10le --codec=prores --prores-profile=4444 MyComp out.mov
npx remotion render --image-format=png --pixel-format=yuva420p --codec=vp9 MyComp out.webm
npx remotion render --gl=angle          # WebGL during renders
npx remotion versions                   # check package versions before using new APIs
npx remotion ffprobe input.mp4
```

Sources: RS`skills/remotion-create/SKILL.md`, RS`skills/remotion-render/SKILL.md`, RS`skills/remotion-render/transparent-videos.md`, https://www.remotion.dev/docs/render.md, https://www.remotion.dev/docs/cli/render.md

**Render notes:**
- **Codec.** The default codec is H.264 and the default output folder is `out/`.
- **Always pass the id.** `npx remotion render` with no composition id opens an interactive picker, so always pass the id and an output path in an agent shell.
- **Props.** Inline `--props` JSON breaks on Windows shells; use a file.
- **Version gates.** Many APIs the skills prescribe need recent versions: `Easing.spring` 4.0.476+, `perceptual-scale` 4.0.490+, light leaks 4.0.500+, `--frames` lists 4.0.502+, `HtmlInCanvasMotionBlur` 4.0.529+.
- **Live preview flags.** `HtmlInCanvas` and motion-blur live preview need Chrome 149+ with a flag enabled.

**Pitfalls from a finished Remotion film** (https://github.com/Leonxlnx/claude-launchvideo):
- In this project, Remotion's AAC mux left about 2.5 frames (2048 samples) of encoder priming. Render with `--muted` and mux with ffmpeg. This was measured in one repo, so check sync in yours rather than assuming it.
- Its `remotion.config.ts` hardcodes a Linux cloud browser path; remove it before rendering on a Mac.
- Gate the render on fonts (`delayRender` until `document.fonts.load` resolves).

### Licence

Remotion is source-available. The Free License covers individuals, for-profit organisations with up to 3 employees, non-profits and evaluation. Others need a Company License: $25/month per person writing Remotion code (including through agentic tools), or $0.01 per render with a $100/month minimum for automation. Reselling a Remotion derivative is never allowed. Codec patent fees are not covered (https://raw.githubusercontent.com/remotion-dev/remotion/main/LICENSE.md, https://www.remotion.dev/docs/license/faq.md). Ask the user to confirm their eligibility before choosing Remotion for company work.

---

## 4. Plain page + headless browser + ffmpeg

This is the architecture of most finished Claude-made films in the research: PDoomVideo, ClaudeAnimationBase, Battle-of-Austerlitz-Film, the guizang starter, and the one-file prompts by twoclipping and verbove. A browser page paints any frame as a pure function of `t`. Headless Chrome, driven by puppeteer-core or Playwright, calls it frame by frame. ffmpeg encodes the frames.

### Contract

- **What the page exposes.**
  - A ready flag (`window.ready`, `window.READY` or `__filmReady`).
  - A frame function: `window.renderAt(t)` returning a data URL, `window.frameJPEG(T, 0.95)`, or `seek(t)` followed by a screenshot.
- **Shots paint the whole frame.** A shot is `fn(t, lt, dur)` (video time, time in shot, shot length) and paints everything, background included. Stable randomness comes from `hash(i)` or a per-element seed, never `Math.random()` (https://github.com/JohnHeibel/ClaudeAnimationBase/blob/main/ANIMATION_GUIDE.md).
- **Closed-form springs.** Use closed-form step responses with a small overshoot. When a value is re-targeted several times, sum one spring per change so it stays stateless (https://x.com/verbove/status/2103483957266268381, https://x.com/twoclipping/status/2103835273813496100). Put the two edges of a tab indicator on different springs to get stretch (https://x.com/verbove/status/2103483957266268381, https://raw.githubusercontent.com/guanmo-ai/awesome-ai-motion/HEAD/prompts/2103273003555402193.txt).
- **guizang's `seek(t)` steps** (https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/assets/starter/src/engine.js):
  1. Push `t` into a React film clock.
  2. Run idempotent real-interaction drivers.
  3. Seek one paused GSAP master timeline, with `gsap.ticker.sleep()` so nothing runs on the wall clock.
  4. Toggle shot visibility.
  5. Call per-frame canvas or WebGL hooks.

  It also freezes `Date`, seeds `Math.random`, serves fixture data for API calls, and freezes CSS transitions and framer-motion (`MotionGlobalConfig.skipAnimations = true`).
- **Wait before the first frame.** Wait for the ready flag, fonts (`document.fonts.ready`) and image decode. Fail the render on page errors or HTTP 4xx/5xx.

### A minimal driver (written for this skill)

Use it when no kit's renderer is wanted. It needs puppeteer-core and a local Chrome or Chromium. Installing puppeteer-core (`npm install --save-dev --save-exact puppeteer-core@<version>` in the video folder) needs the user's OK first, like any other install. Rename `window.ready` and `window.seek` to whatever your page exposes. Serve the page on localhost only (setup.md, last section). It was written from the contract above and the puppeteer API docs; it was not run during research.

```js
// render.mjs: seek a page frame by frame in headless Chrome and pipe PNGs to ffmpeg.
// Usage: CHROME_PATH=/path/to/chrome node render.mjs <url> <seconds> [fps] [width] [height] [out.mp4]
import puppeteer from "puppeteer-core";
import { spawn } from "node:child_process";
import { once } from "node:events";

const [url, secs, fps = "30", w = "1920", h = "1080", out = "out.mp4"] = process.argv.slice(2);
const total = Math.round(Number(secs) * Number(fps));
const gpu = { darwin: ["--use-angle=metal"], win32: ["--use-angle=d3d11"], linux: ["--use-gl=angle"] }[process.platform] ?? [];
const browser = await puppeteer.launch({ executablePath: process.env.CHROME_PATH, headless: true, args: gpu });
const errors = [];
try {
  const page = await browser.newPage();
  page.on("pageerror", (e) => errors.push(String(e)));
  page.on("response", (r) => { if (r.status() >= 400 && !r.url().endsWith("/favicon.ico")) errors.push(`${r.status()} ${r.url()}`); });
  await page.setViewport({ width: Number(w), height: Number(h), deviceScaleFactor: 1 });
  await page.goto(url, { waitUntil: "load" });
  await page.waitForFunction(() => window.ready === true, { timeout: 60000 });
  await page.evaluate(async () => { await document.fonts.ready; });
  const ff = spawn("ffmpeg", ["-y", "-loglevel", "error", "-f", "image2pipe", "-framerate", fps, "-i", "-",
    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "17", "-movflags", "+faststart", out],
    { stdio: ["pipe", "inherit", "inherit"] });
  for (let i = 0; i < total; i++) {
    await page.evaluate((t) => window.seek(t), i / Number(fps)); // an async seek is awaited too
    if (errors.length) { ff.kill(); throw new Error(`frame ${i}: ${errors.join("; ")}`); }
    const png = await page.screenshot({ type: "png" });
    if (!ff.stdin.write(png)) await once(ff.stdin, "drain");
  }
  ff.stdin.end();
  const [code] = await once(ff, "close");
  if (code !== 0) throw new Error(`ffmpeg exited with ${code}`);
  console.log(`wrote ${out}: ${total} frames at ${fps} fps`);
} finally {
  await browser.close();
}
```

- To keep PNG frames instead, write each `png` to `frames/00001.png` and so on, then encode with `ffmpeg -framerate 30 -i frames/%05d.png -c:v libx264 -pix_fmt yuv420p -crf 17 out.mp4`.
- Width and height must be even for yuv420p.
- Add the soundtrack afterwards with the mux command in `qa.md` section 3.
- For WebGL with no GPU, swap the `gpu` flags for `--use-angle=swiftshader --enable-unsafe-swiftshader`.

### Capture and encode

- **GPU flags** (https://github.com/JohnHeibel/ClaudeAnimationBase/blob/main/render.mjs):
  - macOS: `--use-angle=metal`
  - Windows: `--use-angle=d3d11`
  - Linux: `--use-gl=angle`. ClaudeAnimationBase also passes `--no-sandbox` and `--allow-file-access-from-files`. Use them only for local pages you wrote that load no remote scripts, and say so to the user.
  - no GPU: `--use-angle=swiftshader --enable-unsafe-swiftshader`
  - `node gpu_probe.mjs <chrome path>` shows which renderer each flag set gets.
- **Playwright with WebGL.** guizang and Austerlitz launch Chromium with `--use-angle=swiftshader --enable-unsafe-swiftshader --ignore-gpu-blocklist`. Use `preserveDrawingBuffer: true`, pixel ratio 1, and at most 2-4 WebGL contexts per film.
- **Encode settings.** ClaudeAnimationBase's `--encode` uses libx264 `-preset slow -crf 17 -pix_fmt yuv420p -movflags +faststart`, with audio `-c:a aac -b:a 192k -shortest`. Piped capture uses `-f image2pipe -c:v mjpeg -i -`. These are reconstructed from the script's argument arrays, not a literal command line.
- **Long films.** Austerlitz splits the render into 10 s chunks rendered by parallel workers, skips finished chunks on resume, concatenates with `-c copy`, then muxes the audio and an SRT subtitle track as `mov_text` (https://github.com/WinterArc21/Battle-of-Austerlitz-Film/blob/main/tools/render.mjs). Its options: `node tools/render.mjs [--fps 24] [--workers 2] [--from s] [--to s] [--chunk 10] [--crf 18]`.
- **Motion blur.**
  - Render several subframes per output frame and average them: 3-6 at 60 fps in the prompt-library specs, 4 in twoclipping's post, 6 in verbove's.
  - twoclipping blends with ffmpeg's `tmix` filter.
  - For the best quality, average outside the browser in float and dither once. Compositing inside Chromium quantises each sample to 8 bits and bands gradients (claude-launchvideo `accumulate.py`).
- **Multiple formats.** Export 1:1, 16:9 and 9:16 in parallel from the same `draw(t)`, zooming the camera so each state fills that format (verbove).

### Footage inside a browser render

- Re-encode the clip all-intra (`ffmpeg -g 1`), load it as a blob URL, and await `seeked` before drawing each frame (twoclipping).
- Or extract the clip to 30 fps JPEG sequences, swap the image per frame, and have `seek()` await image decode (https://raw.githubusercontent.com/guanmo-ai/awesome-ai-motion/HEAD/prompts/2102554209166000267.txt).

### ClaudeAnimationBase review commands (MIT)

Source: https://github.com/JohnHeibel/ClaudeAnimationBase/blob/main/ANIMATION_GUIDE.md

```bash
node render.mjs --sheet=0.1,0.8,1.6,2.4,3.1,3.9 --cols=6 --w=320 --out=out/check/sheet.jpg   # contact sheet
node render.mjs --strip=2.1:2.6 --cols=6 --w=320 --out=out/check/strip.jpg                   # every frame of a moment
node render.mjs --sheet=2.3,2.4 --crop=760,420,500,400 --w=500 --out=out/check/face.jpg      # full-res crop
node render.mjs --strip=2.1:2.6 --crop-at=960,700,500,400 --out=out/check/feet.jpg           # crop following a world point
node render.mjs --frames --workers=4                                                          # parallel, resumable frames
node render.mjs --encode --out=out/video.mp4
node render.mjs --clip --out=out/video.mp4                                                    # straight to MP4
```

Its guide keeps a per-frame cost budget (1.5 s per frame or less; PDoom used 2.5 s) and prints ms per frame while rendering.

---

## 5. Node canvas (buildwithhanif/claude-animation-skill, MIT)

**Model:**
- A film is a pure function `frame(ctx, t, i, S)`. `setup()` bakes heavy static layers once.
- Scenes are functions of local time, driven by window helpers, never by state carried between frames.
- Seeds come from stable names (`pen.begin("ant/body")`), never from the frame index.
- Rendering uses `@napi-rs/canvas`, piping raw RGBA to ffmpeg with no browser.

**Commands** (https://raw.githubusercontent.com/buildwithhanif/claude-animation-skill/HEAD/plugins/claude-animation/skills/claude-animation/SKILL.md):

```bash
SK=~/.claude/skills/claude-animation            # wherever this skill lives
mkdir my-film && cd my-film && cp $SK/templates/film-template.mjs film.mjs
export CLAUDE_ANIMATION_LIB=$SK/lib             # film.mjs otherwise looks in ../lib, which does not exist here
node film.mjs sheet 0,1,2,3,4                   # look
node film.mjs strip 1.9 12                      # 12 frames around a fast action
node film.mjs verify                            # frames rendered in and out of order must match (md5)
node film.mjs render                            # staged render, never overwrites a good file
node $SK/scripts/music.mjs bed.wav --dur 5 --end 4.4
node $SK/scripts/sound.mjs cues.json out/template.mp4 out/final.mp4 --bed bed.wav
```

Because each Bash call starts a fresh shell, run these in one call, or put `CLAUDE_ANIMATION_LIB=$SK/lib` (with `SK` set) in front of each `node film.mjs` line, or edit the template's `LIB` line once as its `[EDIT]` comment says.

**Its loop:**
brief → style bible + beat sheet → film from template → sheet → fix → strip the fast bits → verify → render → cues.json → sound → contact sheet of the master → deliver.

**Rules worth keeping:**
- **Style bible.** Paste it verbatim at the top of the film file every session; paraphrasing it lets the look drift.
- **Snap, then hold.** A change in 1-2 frames that then holds reads as intentional. Ease the settle, not the change.
- **Staggers.** Stagger groups by 0.05-0.14 s, keep loops out of phase, and start loops mid-cycle so frame 0 is not empty.
- **Sound.** Place SFX about 0.03 s before the visual contact. Two-pass loudnorm to -16 LUFS and -1.5 dBTP by default.

---

## 6. Reference projects worth reading (read-only)

| Project | Licence | What to borrow |
|---|---|---|
| [Leonxlnx/claude-launchvideo](https://github.com/Leonxlnx/claude-launchvideo) | MIT | 33 s, 60 fps Remotion launch film. `timeline.ts` is the single source (60 fps, 120 BPM, so 30 frames per beat, `b(bar, beat, sub)` helper, named `CUE`s). Cues are exported for a seeded Python score; whooshes sit on measured velocity peaks and impacts on the frame a spring lands. Named easings by feel. FontGate. Word-by-word reveals with no per-letter gimmicks. Per-act compositions plus "lab" stills. Optical-flow motion blur. Sync check fails if audio is more than 1 ms off or true peak is above -1 dBTP |
| [op7418/guizang-product-video-skill](https://github.com/op7418/guizang-product-video-skill) | AGPL-3.0, BUSL-1.1 assets | Product promos from real components at video scale (UI body text at least 22 px at 1080p). `DIRECTION.md` first. Per-second shot list. First frame as poster. SFX aligned by measured landmarks, music ducked by role. Honest delivery notes. AGPL-3.0: distributing a modified version, or serving one over a network, requires offering its source under AGPL. The README says commercial use is allowed and rendered videos are not automatically AGPL, and the BUSL-1.1 fallback assets carry their own terms |
| [echris6/motion-video-kit](https://github.com/echris6/motion-video-kit) | MIT | The Gauntlet critic loop and ready critic prompts. Quality bar measured with ffmpeg. Motion grammar of six rules and 16 mechanisms. Three.js render contract. Audio levels per event |
| [JohnHeibel/PDoomVideo](https://github.com/JohnHeibel/PDoomVideo) | none (reference only) | 156.6 s music video by Opus 5.5. Chapter-per-file with parallel subagents and ownership rules. `const B = n => OFF + n * BEAT` beat helper. Storyboard tables `Time / Lyric / Shot / Out` |
| [JohnHeibel/ClaudeAnimationBase](https://github.com/JohnHeibel/ClaudeAnimationBase) | MIT | `ANIMATION_GUIDE.md` written for the model: storyboard "reads", no-text rule for character pieces, animation principles, contact-sheet review |
| [WinterArc21/Battle-of-Austerlitz-Film](https://github.com/WinterArc21/Battle-of-Austerlitz-Film) | none (reference only) | 5:01 narrated documentary. Script beats → Kokoro TTS per beat (cached by hash) → measured durations → computed timeline. Sound cues derived from the picture. Subtitles from the same cues. Chunked resumable render |

---

## 7. 3D

- **When.** Use 3D only where it explains something physical or spatial (exploded layers, photos docking where they were taken). Keep type and UI in crisp HTML or SVG, positioned each frame from projected 3D anchors (https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/references/three-js-patterns.md).
- **Three.js contract:**
  - `preserveDrawingBuffer: true`, `setPixelRatio(1)`, `setSize(1920,1080,false)`.
  - `pose(t)` sets every transform from `t`, and `render(t)` runs from the root seek clock.
  - `anchors(t)` returns the screen points for overlays.
  - No rAF loops or timers.
- **Easing lifts.** Use smootherstep `x*x*x*(x*(x*6-15)+10)`; a cubic ease-out starts at full speed and pops for one frame. Keep camera pitch at 35-55 degrees, never top-down on textured planes. ACES tone mapping shifts brand background colours, so measure the rendered pixels.
- **Fonts in headless Chrome.** `-apple-system` renders as Times, so bind `@font-face` to local font files.
- **Blender.** A Blender MCP present on the machine led Opus to add a 3D chrome section unprompted (https://x.com/shneural/status/2103151003272962130). Curate what tools are installed, because the model uses what is there.

---

## 8. Licences at a glance

| Source | Licence | Implication |
|---|---|---|
| HyperFrames | Apache-2.0 | Free to use. Mind telemetry and skill auto-installs |
| Remotion (software) | Remotion License, source-available | Paid Company License above the free tier |
| remotion-dev/skills (text) | No LICENSE file | Paraphrase, do not copy |
| claude-animation-skill, ClaudeAnimationBase, claude-launchvideo, motion-video-kit | MIT | Reusable with attribution |
| guizang-product-video-skill | AGPL-3.0, plus BUSL-1.1 fallback assets | Distributing a modified version, or serving one over a network, requires offering its source under AGPL. Commercial use is allowed, and rendered videos are not automatically AGPL (README). The BUSL-1.1 assets carry their own terms |
| PDoomVideo, Battle-of-Austerlitz-Film | None | Reference only |
| guanmo-ai/awesome-ai-motion | MIT for curator scripts only | Creator prompts and videos keep their own rights |
| athemeroy/awesome-claude-5-5-videos | CC BY 4.0 for curator text | Attribute; linked prompts keep their own rights |
