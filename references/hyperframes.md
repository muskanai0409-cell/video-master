# HyperFrames: making our films with it

Checked 2026-10-21 against HyperFrames 0.8.181 (npm, published 2026-10-20), installed here as the Claude Code plugin `hyperframes@hyperframes`. ⚠️ It shipped 70 releases between Oct 2 and Oct 20: re-check the version (`make.sh <dir> info`) before trusting a flag below.

**Evidence.** Every rule here traces to the research run in `~/personal-supermemory/research_notes/HyperFrames Oct 2026/`: `00_contract.md`, `01_docs_cli_changelog.md` (docs, CLI, changelog; ledger A1-A106), `02a_core_skills.md` (the 12 core skills; B1 ledger), `02b_craft_skills.md` (the 9 workflow skills plus 6 internal team skills; B2 ledger), `03_community_and_limits.md` (top videos, creator workflows, GitHub issues; C ledger), `04_hands_on.md` (what ran on this Mac; D1-D20), `05_catalog_index.md` (the registry, grouped). Ids in brackets point at those ledgers.

**Engine.** `engine/hyperframes-starter/` (a brand-constant template plus `make.sh`). Read its README before the first render.

## Contents

0. When to use it
1. Setup on this Mac
2. Commands that need her yes
3. Which official skill for which job
4. The contract (what breaks a render)
5. Craft: what to take, what to override
6. Format playbooks
7. The registry and shader transitions
8. Rendering recipes
9. QA gate
10. Known bugs on this Mac
11. What the best HyperFrames films do
12. What changed since our Oct 2 notes

---

## 0. When to use it

HyperFrames writes a video as an HTML page: `data-*` attributes set timing, one paused GSAP timeline per composition moves things, and the renderer seeks every frame in a pinned headless Chrome and encodes with ffmpeg.

Pick it when HTML is the native medium of the film:
- type-led films and kinetic type;
- product UI rebuilt from the live DOM (her rule: never upscale a screen recording);
- a launch film from a website (`capture`), a PR or changelog explainer, a short motion graphic;
- captions or designed overlays on talking-head footage;
- beat-synced promos;
- many variants of one film (hook A/B tests through `--variables` or `--batch`);
- transparent overlays (MOV ProRes 4444, WebM VP9), GIFs for docs, a live deck (`present`).

Keep our Swift and Metal engines (`engine/`) for raymarched 3D and real light (`media-reel`), the dot-lattice brand field (`brand-lattice`), and films already built there. HyperFrames can run Three.js, WebGPU and shaders, but our Metal path is already measured and deterministic.

Either way, SKILL.md §3 (brief, claims table, story, beat map, stills, QA), the style card (`anti-house-style.md`) and the brand rules (`brand.md`) apply. HyperFrames is a renderer, not a look.

## 1. Setup on this Mac

Done on 2026-10-21 (D1-D20):
- **Plugin.** `hyperframes@hyperframes` 0.8.181 at user scope: 21 skills, no hooks, agents or MCP servers, about 4.1k tokens always on. The router is `/hyperframes:hyperframes`. Update only through the plugin manager (`claude plugin marketplace update hyperframes`, then reload), never `hyperframes skills update`.
- **CLI.** Always through `engine/hyperframes-starter/make.sh <project> <command>`. It runs the plugin's pinned launcher (`<plugin>/skills/hyperframes/scripts/plugin-cli.mjs`) and sets:
  - `HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1` (the launcher itself does not turn telemetry off [B1]); `telemetry disable` was also run once;
  - `HYPERFRAMES_SKIP_SKILLS=1` (no global skill installs), `HYPERFRAMES_NO_UPDATE_CHECK=1` (stops a detached daily npm ping that runs even in agent shells [A6][A8]), `HYPERFRAMES_NO_OPTIONAL_INSTALL=1` (no silent npm installs of onnxruntime, @google/genai or sharp [A14]);
  - ffmpeg from Cardboard.app (6.0 with libx264, h264_videotoolbox, libvpx-vp9, ProRes) through `HYPERFRAMES_FFMPEG_PATH` and `HYPERFRAMES_FFPROBE_PATH`, because this Mac has no Homebrew [A46][A47];
  - screenshot capture and one worker by default, for two open bugs (§10). `FAST=1` and `WORKERS=4` opt back in.
- **Chrome.** The pinned chrome-headless-shell 152.0.7977.30 is in `~/.cache/hyperframes/chrome`. Since 0.8.178 check, snapshot and render always use it [A51].
- **doctor.** Do not gate on `doctor --json` `.ok`: it now counts optional tools (whisper, Kokoro, MusicGen, Docker), so it reads false here even though rendering works [B1]. Read the FFmpeg, FFprobe and Chrome rows instead. It also warned "Low memory" with 1.6 GB free; renders still worked. If one fails, close apps or pass `--low-memory-mode`.
- **MCP.**
  - The hosted connector is added to Claude Code at user scope: `https://mcp.heygen.com/mcp/hyperframes/`. It shows "Needs authentication" until she signs in to HeyGen through `/mcp` (or `claude mcp login hyperframes`). It is beta, renders in HeyGen's cloud on her credits, and its tool list and prices are not published [A86]-[A88]. Use it for quick chat-made videos (claude.ai, phone); our films stay local, where we keep the files, Studio and pixel control.
  - There is no local MCP server: the `@hyperframes/inspector` stdio server was removed in 0.8.156 [A89].
  - Studio registers 12 WebMCP tools on `document.modelContext` (look, inspect, frame, select, seek, set text and style, transform, add/update/delete animation, add keyframe). They need a WebMCP browser (Chrome 149+ origin trial or `chrome://flags/#enable-webmcp-testing`). Claude Code cannot call them directly [A84][A85].
- **Studio.** `make.sh <dir> preview` serves it at `http://localhost:3002/#project/<name>`. Stop it with `make.sh <dir> stop`. Auto-keyframe starts on: turn it off before a layout fix that should not animate [A81].

## 2. Commands that need her yes

`make.sh` does not wrap these on purpose. Each one reaches the network, an account, a download or her credentials:
- `usage` (reads Claude Code's OAuth token from the Keychain [A22]);
- `publish` (a signed-out link can be claimed by whoever opens it [A23]), `cloud`, `lambda`, `cloudrun`, `auth`;
- `feedback`, including the `--search-miss` report that `catalog --json` pre-fills;
- `tts` (311 MB model plus Python packages), `transcribe` and `init --video` (may `brew install whisper-cpp` or build it from source; use `--no-runtime-install` or `--skip-transcribe`) [A18][A20];
- `remove-background` (168 MB model), `models install`, `catalog --on-device`;
- `skills`, `upgrade`;
- `capture` (direct internet; AI captions through Gemini or OpenRouter keys) [A17];
- `snapshot --describe` (sends every frame to Gemini when a `GEMINI_API_KEY` is set; `make.sh` always passes `--describe false`) [A16];
- `open` (the desktop app defaults its agent to "Full access", no checks) [A82];
- the `media-use` workflow: it loads every key from the nearest `.env` up to five folders above the project, caches assets in a global `~/.media`, and sends PostHog events [B1]. No `.env` sits above `reports/videos/` today (checked Oct 21).

The CLI auto-loads `<project>/.env` on every command [A15]. Never put a key in a film folder.

## 3. Which official skill for which job

Load the plugin skill for the job, then apply §5's overrides. The router (`/hyperframes:hyperframes`) maps intents if unsure.

| Job | Plugin skill | Take from it | Override with her rules |
|---|---|---|---|
| Launch film from a URL, brief or script | `product-launch-video` | the five arcs, reveal on the voice, the cut catalog, held frames before climaxes | crossfade default, frame presets, 3-5s hook window, value claim by beat 2 |
| PR or changelog explainer | `pr-to-video` | the four archetypes, diff and mechanism alternation, 2.2 words a second budget | the fixed code-editorial preset (Anthropic's cream, coral and ink) |
| Explainer with no footage | `faceless-explainer` | concept, how-to, listicle and story structures; three or more framings | thesis at the end (`story.md`), her 25-30s cap |
| Short motion graphic, under about 10s | `motion-graphics` | category durations (stat 4-6s, sting 3-5s), proof snapshots | bounce and elastic, count-ups from zero |
| Beat-synced promo | `music-to-video` | hits at 0ms, landing moves 40-190ms early, camera once per phrase | picture-before-sound order (her sound lands 0-2 frames after picture) |
| Captions on footage | `embedded-captions` | rail plus scarce embeds, words within 80ms | its retired "Standard" default |
| Designed cards over a talking head | `talking-head-recut` | card count and pacing table | `repeat: -1` habits; add her punch-ins and first-second hook |
| A deck | `slideshow` | one idea per slide, fragments | none |
| Anything else | `general-video` | companion mode | as §5 |
| Authoring rules | `hyperframes-core`, `hyperframes-animation`, `hyperframes-keyframes` | §4 and §5 | async build: register the timeline last |
| Audio | `hyperframes-audio` | carve, master bus, truepeak | LUFS per her rules (-14 social) |
| Blocks | `hyperframes-registry` | discovery, quality bar | adapt every block (§7) |
| Studio | `hyperframes-studio` | live-DOM rebuilds, one world across cuts | none |
| Figma | `figma` | asset, tokens, component; `verify-motion.mjs` for match-this-reference jobs | needs a FIGMA_TOKEN she provides |
| A Remotion project | `remotion-to-hyperframes` | the port | none |
| Creative direction | `hyperframes-creative` | typography for video, narration | its house style (breathing decoratives, presets) |
| Footage and images | `media-use` | treatments, recipes | §2 side effects; ask first |

## 4. The contract (what breaks a render)

Most of these fail silently: `check` can pass and the frame is still wrong.

**Structure**
- The root `<div>` sits directly in `<body>` with `data-composition-id`, `data-start="0"`, `data-width`, `data-height`, `data-duration` and `data-fps` [A55]. Its `data-duration` alone sets the render length.
- Only top-level clips on the root. Anything with nested layout goes in a scene file under `compositions/`, mounted with `data-composition-src` (lint `nested_structure_needs_subcomposition`) [D16].
- In a scene file, the `<style>`, markup and `<script>` all go inside `<template>`. The host id, the scene's root id and its `window.__timelines` key are the same string. Prefix inner ids with the scene id.
- Every element with `data-composition-id` waits for a matching timeline. Static sections get a plain `id` or `data-no-timeline`, or every render waits 45s [A61].
- Clip visibility is half-open, `[start, start + duration)`. Land end states before the clip ends.
- `data-track-index` is a Studio display lane only. Paint order is `z-index` [A56].

**Timeline**
- Exactly one `gsap.timeline({ paused: true })` per composition, registered as `window.__timelines["<id>"]`. Never `play()`.
- Build synchronously, or register the timeline only after every tween is added. An empty timeline registered early renders blank [B1].
- In scene files use `fromTo`, not `from`: hosts re-seek scenes on every show.
- Never `Date.now()`, `performance.now()` or unseeded `Math.random()`. Never a render-time fetch: vendor GSAP in `assets/`. Every official template, example and caption skin loads GSAP from a CDN, so swap it [B1][B2].
- `repeat: -1` is only a warning when the root duration is finite [A63]. Prefer finite repeats anyway.

**Motion**
- Transforms and opacity only. Tweening `width`, `height`, `top`, `left`, `margin`, `letterSpacing` or `fontSize` is now a lint error: layout snaps to whole pixels and slow settles stutter. `fontSize` becomes `scale`; letter spacing becomes per-character `x` after a split [A64][B1].
- Never tween `display`, `visibility` or `autoAlpha` on a `.clip`; animate a child, or keep to opacity.
- Never set a CSS transform on something GSAP moves; use `xPercent`/`yPercent` [D18].
- Precompute layout at setup. Never measure (`getBoundingClientRect`) at tween time.

**Variables**
- Render-time `--variables` reach the root composition only. A scene file gets values only from its host's static `data-variable-values` (tested three ways on 0.8.181) [D17]. Put variable-driven text on the root.
- Declarations are an array on `<html data-composition-variables>`; values are an object keyed by id.

**Text**
- Fonts ship as files in the project (`assets/fonts/`). The render machine has no system families to fall back on.
- Use each face in static markup too: the fonts gate waits only for faces in static markup, and script-built text can be measured in the fallback font (open #5112) [C95].
- Text containers with inline accent spans are `display:block`, never flex: flex drops the space before the span [D18].
- No `<br>` in body text; wrap with `max-width`. Fit dynamic text with `window.__hyperframes.fitTextFontSize` or `pretext`. Give text masks 0.2em of room.

**Media**
- `<video>`/`<audio>` trim with `data-media-start`; nested compositions with `data-playback-start` [A58].
- Re-encode source footage with a keyframe every second (`-g` equal to the fps), or seeks freeze [B2].
- A video with sound keeps it on the `<video>` (`data-has-audio="true"`); music and voice go on separate `<audio>` elements.

## 5. Craft: what to take, what to override

HyperFrames contradicts itself. Its internal team doctrine (`.claude/skills/motion-doctrine`, `cut-the-curve`, `seam-craft`, not shipped in the plugin) bans idle motion, crossfades and elastic eases. The published skills add breathing decoratives, default to crossfade and allow elastic, and the published code is what runs [B2 §1.0]. Our rules side with the internal doctrine.

**Take these (merged from B1's top 25 and B2's 30 rules, most valuable first):**
1. **Reveal on the voice, never front-load.** Nothing appears before the voiceover names it. One time window per spoken cue, reveals spread over the back half of the shot, end on a held read. Everything on screen in the first quarter "reads as a PowerPoint slide" [B1-036][B2-165].
2. **Cut at peak velocity with the same vector on both sides.** Same axis and signed direction (on Z, the same sign of scale change). Mirrored in and out curves, cut mid-motion, partial travel about 12% (230px at 1920), exit fade finished by 25-30% of the travel, entry from 0.35 opacity [B2-04][B2-29]. The curve family comes from the film's style card, not `power4` every time.
3. **The transition is the exit.** No exit tweens before a transition except in the last scene [B1-234].
4. **One transition language.** One primary type for 60-70% of changes plus one or two accents, two shader transitions at most [B1-237]. Her rule is stricter: one family per film, never the last film's.
5. **One subject, one continuous move.** Move it between two boxes in one transform tween (or FLIP); split x, y and scale tweens read as a hitch [B1-739].
6. **Camera like money.** Static by default, one real move per shot, never spring or back eases [B1-404].
7. **No idle motion.** No breathing, floating or drift. A small finite jitter at most, faded out before the transition. Leave 0.3-0.75s before a payoff [B2-11][B2-177].
8. **Land the read.** At least 1s sharp after every climax [B1-387]. Our short-film ending rule (still hold 1.2-2s, ending under 2.5s) beats their "lockup 20-30% of runtime".
9. **Blur scales with the subject.** 10px peak at a text seam; 18-20px only for full-frame surfaces; the same on both sides of a cut [B2-26]. Motion blur (`data-hf-motion-blur`, 720 degree shutter, 16 samples) on one to three snap beats per film only, never on text being read [B1-285].
10. **Groups land as one beat.** Total stagger about 0.5s or less, ordered by importance [B1-205].
11. **Numbers are data.** A number and its bar share start, duration and ease; `tabular-nums`; never overshoot a readout [B1-413]. No count-up from zero (her rule).
12. **Restraint around the hero.** Glow at 0.45 opacity or less; achromatic shadows; no chrome around a hero beat [B1-361].
13. **Mix to numbers.** Music bed 0.12 under a voice plus a spectral carve (`carve.mjs`, strength 0.8: six bands from 250Hz to 2.5kHz), because "a duck alone is not a finished mix". SFX about 0.35. `truepeak` last on the master bus, 2dB under the limit. -14 LUFS for social [B1-043][B1-637].
14. **Budget narration.** About 2.2 words a second for TTS; 19 words per 9s frame at most [B2-160].
15. **Captions are a model, not a band.** Drop filler, a quiet verbatim rail (two lines of 32-42 characters at most), scarce big embeds behind the subject, every word within 80ms of the transcript [B1-529][B2-45].
16. **Show the behaviour, not just the artifact.** Alternate a code or UI beat with a beat that animates what it does [B2-189]. Never approximate the product's UI: rebuild live DOM and perform each change as an interaction [B1-766].
17. **Pitch wide.** Five concepts from five paths, at least two from the tail; drop any two with the same silhouette [B1-012].
18. **Look; never trust `check`.** It passes blank renders [B1-146].

**Override these (HyperFrames defaults that break her rules):**
- The 13 frame presets. About 10 use cream or paper grounds and most use uppercase mono labels; `pr-to-video` always uses code-editorial, Anthropic's palette [B2]. Never use a preset as the look. The supermemory brand and the film's style card set it.
- Breathing, drifting or pulsing decoratives, registration marks and mono coordinate labels in every scene (`house-style.md`, `prompt-expansion.md`) [B2-78][B2-109].
- Crossfade as the default seam, and cut-the-curve LEFT as a house direction [B2-121].
- `power3.out` as every film's curve. Her rule: 3 or 4 motion classes, each with its own curve, never the last film's set (`anti-house-style.md` rule 5).
- Count-ups from zero, scale-from-zero entrances, overshoot on UI, bounce and elastic.
- A flat 70ms-per-key typewriter. Real typing runs 90-180ms a key with pauses (rule 13).
- An oversized cursor with click ripples as filler. Her cap: 3 clicks, no ripples (rule 22).
- 8-12 phrase rapid montages. Her cap: 6 text events in a 20s film (rule 1).
- A 3-5s hook window and the value claim by beat 2. Her hook lands in 0-1.5s; the thesis appears once, at the end (`story.md`).
- Body text minimums of 28-42px. Her phone floor is about 64px at 1920 wide (`brand.md` §4).
- Delaying the first animation 0.1-0.3s. Her frame 0 is a finished picture.
- Exits at 75% of the entry length. Hers are about half.
- A reserved bottom 16.67% caption band with the hero at 0.42H when the film has no captions.

## 6. Format playbooks

Condensed from `02b_craft_skills.md` §3; timings are the skills'. Her recipe (`references/recipes/`) wins where they differ.

- **Launch** (`product-launch-video`). Pick one arc: PAS (hook, pain, agitation, solution tease, product, proof, CTA), Future Pacing, Demo Loop, Before-After-Bridge, or Feature-Benefit Cascade. A beat is 1-2 sentences of 6-20 words. A UI demo is 3 or more beats on one surface (input, response, result, benefit). Hers: hook in 0-1.5s, about 25-30s for a 16:9 cut.
- **PR video** (`pr-to-video`). 30-90s, up to about 155 words. Archetypes: changelog (2-4 items), feature reveal (outcome, impact, change, diff, mechanism, callback), fix explainer (problem, the bug happening, diff, working), refactor. Hunks of 4-12 lines. Numbers on a number frame, never in the narration.
- **Weekly changelog** (internal `changelog-video`). Square, 45-60s: title 2s or less, about 4 themes of 9-12s (one hero visual, 3 spoken items at most), outro 3.5s or less, 14 spoken beats at most. Hers: about 75s for 5-7 items, no still over 2s.
- **Faceless explainer.** Concept (mechanism layer by layer), how-to (3-6 steps on one stage), listicle, or story. Hero at 40-60% of the frame; three or more framings, never the same twice in a row.
- **Music-driven.** Cut at hard stops, surges and drops; hits at 0ms; camera once per phrase; strobes 2-3s at most; a readable word holds a beat or more; the CTA lands on the final hit. Trust the beat grid only on rhythmic music.
- **Talking-head recut.** Cards every 6-8s under a minute, 8-12s up to 3 minutes. A static one-liner bores past 8s. Fade in 0.4s, internal reveals 0.3-0.65s after the card starts.
- **Short motion graphic.** Hook in about 0.5s, one dominant motif, one change past about 2.5s. Stat 4-6s (count 1.2-1.6s, then hold, label after); logo sting 3-5s.

## 7. The registry and shader transitions

- 448 items (210 blocks, 238 components) [A4]. Grouped index: `research_notes/HyperFrames Oct 2026/05_catalog_index.md`. Search by the effect in plain words: `make.sh <dir> catalog --query "a fast whip into the next scene"`. Official advice: describe what you want to communicate, never name an effect [C09].
- `make.sh <dir> add <name>` fetches from the registry's `main` branch, not pinned to the CLI version [A29], and copies an include snippet to the clipboard. Commit the added file with the film.
- Blocks are showcase compositions, not drop-ins. The tested one (`cinematic-zoom`) loads GSAP from a CDN, imports Google Fonts, uses its own `main` id and fails one lint rule. Before use: vendor GSAP, swap fonts to Geist, colours to the brand tokens, rename ids, and turn it into a scene file [D].
- Shader transitions: use `@hyperframes/shader-transitions` (`init({ bgColor, accentColor, scenes, transitions: [{ time, shader, duration, ease }], timeline })`) with the 14 named shaders only: domain-warp, ridged-burn, whip-pan, sdf-iris, ripple-waves, gravitational-lens, cinematic-zoom, chromatic-split, glitch, swirl-vortex, thermal-distortion, flash-through-white, cross-warp-morph, light-leak [A69]. WebGL rendered fine here with the hardware GPU. Our bans still hold (no white flashes, no glitch for its own sake), so most films use none, and never more than two.

## 8. Rendering recipes

All through `make.sh` (see the engine README):
- `draft` 1080p30 for timing; `render` 1080p60 delivery; `master` 4K60 supersampled (`--resolution landscape-4k`, no re-layout) plus a lanczos 1080p cut tagged bt709; `blur` 240fps averaged 4 to 1 down to 60fps (`SHUTTER=2` for 180 degrees).
- Always pass `--quality`: the CLI default (looks, CRF 16) and the docs (standard) disagree [A37].
- Transparent overlays: `--format mov` (ProRes 4444; 8-bit capture in a 10-bit container, open #5479) or `--format webm` (VP9 alpha; its alpha lives in side data, so `pix_fmt` alone doesn't prove it is missing). GIF at 15fps for docs. `png-sequence` for compositing.
- Variants: `--variables '{"headline":"..."}'` or `--batch rows.json --output "renders/{name}.mp4"`.
- Long or heavy renders: `HYPERFRAMES_RENDER_DETACHED=1`; timeouts `--browser-timeout`, `--player-ready-timeout`, `--protocol-timeout`; segmented capture with `HF_SEGMENTED_CAPTURE=true` and `--resume` [A39][A41].
- Measured here (one worker, screenshot capture): 15s 1080p60 in 15s; 6s 4K60 in 35s; 6s at 240fps in 60s. Fast capture rendered a 4s 1080p30 draft in 9s.

## 9. QA gate

The HyperFrames layer, then everything in `references/qa.md`:
1. `make.sh <dir> check`: lint, runtime errors, layout over 9 samples, motion assertions, WCAG contrast. Gate on it, but it passes blank renders. Films over about a minute hit a fixed 120s check deadline (open #5682): check in ranges (`--range 0,30`).
2. Write a `<scene>.motion.json` sidecar (`appearsBy`, `before`, `staysInFrame`, `keepsMoving`) so `check` tests the motion you meant [B1-114].
3. `make.sh <dir> snapshot --at <times>` around every cut (cut -0.1s and +0.2s), each scene's midpoint, the opening and the final hold. Look at them at full resolution, and zoom (`--zoom '#headline'`) into fine text and edges.
4. Render, then `make.sh <dir> probe <file>`: duration equals the root `data-duration`, 60/1, yuv420p, bt709 tags, and the loudness. Silent narration can pass `check` (open #2775) and audio differs a little between renders (open #5669).
5. `make.sh <dir> frames <file> <t...>` and sample hex with the bt709 matrix (`qa.md` 2.2). Measured: white `#fdfdfd`, accent `#0460ed` on text, inside the accepted drift.
6. `qa.md`: the motion metric, identical decoded frames on the final hold, readable at 390px, the anti-house-style check and `tells.py`.

## 10. Known bugs on this Mac (open on 2026-10-21)

No open issue blocks all rendering on macOS arm64 [C §4i]. Plan for these:
- **#5415** fast drawElement capture silently drops a scene file that starts after 0s once a render passes about 700 frames, and `check` passes. `make.sh` defaults to screenshot capture (`PRODUCER_EXPERIMENTAL_FAST_CAPTURE=false`). A 900-frame test with a late scene rendered correctly [D].
- **#4435** and a creator report: parallel workers can emit a blank first frame per worker and flicker blurs. `make.sh` defaults to one worker.
- **#5604** `--workers auto` drops to one worker for WebGL films of 30s or more: pass `WORKERS=4` for those, and check the first frame of each chunk.
- **#5112** script-built text measured in the fallback font: keep each face in static markup (the starter does).
- **#5682** the 120s check deadline on long films (§9).
- **#2775** and **#5669**: silent narration passes `check`; audio is not bit-identical between renders.
- **#5479** ProRes MOV is 8-bit capture in a 10-bit container: expect contour rings under heavy grades.
- **#5245** Cisco Secure Endpoint quarantines a CLI chunk (managed Macs only; not this one as far as we know).
- Agent sandboxes: since 0.8.169 Chrome retries in one process on a software GPU. It works, but slowly and with SwiftShader text artifacts. Render outside a sandbox [A52].

## 11. What the best HyperFrames films do

From `03_community_and_limits.md` (live X and YouTube numbers, 2026-10-21). These are correlations in a small, self-selected sample.
- **The base rate is low.** 1,681 non-official HyperFrames-era films on X: median 577 views and 6 likes; only 24 passed 100k views [C29].
- **They start from a reference or a known format.** A news-map simulation (477k views), a toddler counting cartoon, a YouTube avatar explainer (1.3M), staff films "based on a reference video". The official account: "Opus 5.5 makes better videos with references" [C12][C15][C26].
- **A human sets the beats.** "DO NOT LET THE AGENT CHOOSE WHAT TO PUT" (leodev) [C20]; one still per scene before anything moves; director notes like "slow every zoom to 0.7x", never "make it better" [C21][C22].
- **They feed real brand material:** the codebase, components, landing page, screenshots, brand files.
- **The agent watches its own render** and fixes what it sees [C17][C24].
- **Length follows the job.** Launch films 40-90s; pure motion graphics 5-20s; story explainers 3.5-10 minutes when there is a narrative.
- **Sharing the prompt earns bookmarks** (bookmarks per like about 2 to 2.7 on workflow posts, against 0.3 to 1 on showcase-only posts). For saves and follows, put the prompt in the replies.
- **The copy hook is a cut in effort or a recognizable claim** ("1-shotted in less than 20 mins", "2 prompts only"). On YouTube the big titles lead with Claude or Opus, not HyperFrames.
- **Landscape leads**: 34 of the top 50.
- **The weak ones** use a one-line prompt with no brand or reference and fall back to "centered text, gradient background, everything fading in".

## 12. What changed since our Oct 2 notes (0.8.112 to 0.8.181)

Breaking: every command rejects extra positional arguments (0.8.113); a root `data-fx-chain` is now the master bus for the whole mix (0.8.150); snapshots and check reports moved to `.hyperframes/artifacts/` (0.8.152); the inspector MCP server was removed (0.8.156).

New and useful: the Studio desktop app and `open`/`catch-up`; `history` begin, end and undo for agent turns; `timeline` edit verbs; `beats` and `audio` (onsets, loudness) without Chrome; `keyframes --shot`; `snapshot --zoom` and `compare`; `data-fade-in/out`, relative timing (`data-start="intro + 0.5"`), `data-color-grading`, `data-vfx-chain`, speed ramps, TypeGPU and frame sources; render inside agent sandboxes; the pinned Chrome always used (0.8.178); a render with no usable encoder now stops before capture (0.8.174); multi-worker empty-frame failures fixed (0.8.180). Full list: `01_docs_cli_changelog.md` §11.
