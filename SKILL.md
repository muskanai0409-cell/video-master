---
name: video-master
description: "Muskan's master skill for every video and motion-graphics job: making, planning, storyboarding, scripting, rendering or patching an explainer, launch reel, promo, product or console film, data or benchmark film, social cut, logo reveal or kinetic-type piece, for supermemory or anything else. Use it first whenever she asks for a video, an animation, a reel, a teaser, a cutdown, a motion-graphics prompt, or references 'like this video'. Holds her current direction and every piece of feedback so far (lessons log), the morph catalogue, the story template, the Swift render pipeline on her Mac with two reference engines, QA, brand surfaces, a reusable prompt, the general code-motion-graphics workflow (HyperFrames, Remotion, plain pages), and a library of every motion-graphics bookmark and link she has shared, and recipes per format (launch film, product demo, UI-morph reel, explainer, changelog, ad, talking head, AI footage, memory scenes) learned from a frame-by-frame study of all 304 videos in her bookmarks."
---

# video master

This is the front door for every video job Muskan Jain (GTM, supermemory) asks for. It does four things:

1. picks the job type and routes to the right deeper material
2. states her **current** direction, which overrides older rules where they conflict
3. holds the parts no other skill has: the morph catalogue, the story template, the render pipeline that works on this Mac, and QA commands that run without numpy
4. keeps her taste on file: a lessons log of every note she gave (`references/lessons.md`) and a library of every motion-graphics bookmark and link she shared (`references/library/`)

Everything here traces to her supermemory video pack, the code-motion-graphics skill (folded in under `references/code/`), her memory notes and the READMEs of every film made with her (2026-09-12 to 2026-10-06), 174 motion and design picks from her 604 X bookmarks, 91 links she sent in her own messages, the supermemory.ai site, and a frame-by-frame study of all 304 videos in her bookmarks (`references/video-study.md`, 2026-10-06 and 07).

---

## 0. Pick the job, then route

| The ask | Route | Default output |
|---|---|---|
| Concept explainer for supermemory ("explain X", a doc page, a tweet) | this skill: `references/story.md`, `motion-grammar.md`, `pipelines.md`, `qa.md`, `brand.md`; plus pack `skills/supermemory-explainers` for grammar, tokens and the bug catalogue | 1920x1080, 60fps, **25 to 26s max** (her cap, 2026-10-05) |
| Data or benchmark film (runs, charts, numbers) | pack `skills/smfs-benchmark-explainer` + `skills/supermemory-explainers`; this skill for motion and QA | 1920x1080, 27 to 40s |
| Launch reel, "quirky", "catchy", "viral" promo | pack `skills/quirky-product-reels` + `skills/sound-design` (flat bed register) | 1920x1080, 15 to 30s |
| Product film from the real console or app | pack `skills/console-product-films`, with her override (2026-10-05): rebuild the UI in vector from the live page's measured DOM, never upscale a screen recording. Worked example: `engine/console-film/` | 10 to 58s, 60s ceiling; 4K master, 1080p cut |
| Edit of her own camera footage | pack `skills/muskan-editing-style`. Not explainer rules | her footage |
| Square or vertical social cut of a film | `references/story.md` section 3; re-frame from the same timeline, never letterbox | 1080x1080, 15 to 25s |
| YouTube packaging, long-form script | pack `skills/supermemory-youtube-production`; scripts live in `reports/video-scripts/` | plan or script |
| Music, SFX, voiceover timing | pack `skills/sound-design` | stems + -16 LUFS master |
| Any words: captions, statements, the tweet | pack `skills/voice-and-copy`, then her voice rules (section 2) | lowercase thesis register |
| A video that is not about supermemory, or a HyperFrames, Remotion or plain-page build | `references/code/workflow.md` (the code-motion-graphics skill, folded in) | its own workflow |
| Any new video, once the format is clear: launch film, product demo, UI-morph reel, explainer, changelog, ad, talking head, AI footage | `references/recipes/<format>.md` for measured targets, a beat template, hooks, endings and the posts to study; `references/recipes/memory-scenes.md` for showing memory on screen | the recipe's targets, overridden by section 1 where they differ |
| Ideas, references, "make it like this", a prompt for another tool | `references/video-study.md` (what 304 bookmarked videos do, measured), `references/library/videos/README.md` (every video with its link and numbers), `references/library/websites.md` (sites by use), `references/library/bookmarks.md`, `references/library/shared-links.md`, `references/inspiration.md`, `references/code/gallery-lessons.md` | a short list of mechanisms to borrow |
| "update", "fix", "make it better" on an existing cut | find its `reports/videos/<name>-src/README.md`; patch, do not rebuild | same file name + version |
| A brand or teaser film on the blue field (dot lattice, a subject recalled out of it, tokens), a head or brain as the subject, a board of facts that change (expire, update, forget), or real-sounding music with no budget | `references/motion-systems.md`, with the ready engines `engine/brand-lattice/` (dot field + glass mind + Apple Loops score) and `engine/memory-board/` (reflowing board + morphing bar + history row) | 16:9, 60fps, 4K master + 1080 cut, about 18 to 25s |

Do not blend registers. Presenter edits do not get explainer motion rules. Reels keep the pack's pop-and-hold grammar.

**Finding the pack** (her own, canonical for brand and truth). Check in order:
1. `~/.claude/skills/supermemory-video/SKILL.md` if it is installed.
2. The newest `~/Downloads/supermemory-video-skills*.zip`. Unzip it into the session scratchpad (it unpacks to `supermemory-video-skills/`). This is her own file, so unzipping is fine.
3. Otherwise ask her. Her README names a GitHub repo for it; ask before cloning anything.

Read the pack's `SKILL.md`, `reference/feedback-rules.md` and `reference/brand-systems.md`, then the sub-skill the table points to.

---

## 1. Her current direction (overrides older pack rules)

As of 2026-10-06 these points are what she wants. The pack was built from cuts shipped between 2026-09-12 and 2026-10-01, mostly silent square explainers. **Where an older pack rule conflicts with the points below, these win. The current brief beats both.** Say in the delivery note which older rule you overrode.

**(a) Explain the problem first.** Open on what is being solved, as something the viewer has felt, before any mechanism. Then why it matters (one sourced number), then the old way, then the turn. Template: `references/story.md`.

**(b) 16:9 by default, with proper segregation.** 1920x1080. A text column carries one statement per beat under a section label such as `01 · THE PROBLEM`. A figure stage carries the diagram. A consistent HUD (section label, topic, hairline) and a chapter progress rule run the whole film. Frame spec: `references/brand.md` section 4. Square is for social cuts.

**(c) supermemory branding from the website and the brand kit.** White or paper ground, square corners, 1px hairline cards, uppercase letter-spaced Geist Mono labels, Geist statements with most words at ink 45% and key words in full ink, dashed connectors, dot-grid figures, the blue tile with the white mark, big Geist numbers with a small `+` or unit, the blue flower-field film, the official lockup. Details and measured values: `references/brand.md`.

**(d) Lots of movement.** Her takeaway from the @himanshubuildss reel: "people love when there's a lot of movement, things blending into each other from one thing to the other." One continuous take. Each scene grows out of the last. Objects transform instead of fading or cutting. Something happens on every beat. No dead hold over about 1s, except the final still. Target 60% or more of frames moving. Catalogue: `references/motion-grammar.md`.

**(e) Polish.** 60fps with 4-subframe motion blur, text that rises from a mask line, a camera that pushes and pulls so each moment fills the frame. Then measure it (`references/qa.md`).

**(f) Her notes on the mcp-upload v2 cut (2026-10-05), applied in v3 and now standing rules:**
- **About 25 to 30 seconds** for a 16:9 explainer. She set 25 to 26s, then asked for 4 more seconds on mcp-upload v4 because the corruption beat was not understandable: comprehension beats the cap. Every key visual change (a failure, a turn, a result) needs its own 2 to 3s with the camera on it, and a before/after ("sent" vs "received") when something breaks. Merge statements before cutting a chapter; 8 statements of 2.6 to 3.0s plus a ~1.2s turn and a ~2.6s end card fits.
- **Diagrams bigger.** The figure is 1040px wide (x 800-1840), labels inside it are 14 to 17px in world units, and the camera sits at 1.6 to 2.3x zoom for most beats so the active pair fills the frame. Wide shots (about 1.15x) only for a beat's first second.
- **Cooler, like her rossaxbt references:** a cursor drives the story with real drags and clicks (scaled with the camera, click ripples), the camera is never still (a quick ease move at each beat, then a slow smoothstep drift that follows the action), something lands every half second, and arrivals use a closed-form spring with slight overshoot.
- Measure motion with the pack metric (`references/qa.md` 2.3), never a looser one. v3: 72.9% moving, longest still 0.93s before the end card; v2 measured 31.4% on the same metric.

**(g) Her notes from 2026-10-05 and 2026-10-06 (the one-command and namespaces films, mcp-upload v5).** Full log with quotes: `references/lessons.md`.
- **Never upscale a screen recording of product UI.** "so low quality ... dont use the screenrecording directly": rebuild the UI in vector from the live page's measured DOM (boxes, computed styles, icon SVG paths, hover states), render a 4K master and a lanczos 1080p cut.
- **Bigger.** "make everything a bit bigger ... still incorporating everything": type about 12% over the page at the same card width, camera closer, nothing cropped.
- **Show more, write less.** One universal command copied and run in a terminal, each option shown once; end on one line.
- **Sound.** Never a commercial song or its melody. An original score made in code (synth, on the beat grid, picture moved to the music) plus CC0 sound effects is fine when she asks for music; about -14 LUFS for social.
- **Backgrounds.** For product films she asked for a "supermemory background coded, pretty", rejected a computed dawn sky, then pointed at the supermemory.ai hero film (`field.mp4`). v6 uses it under the site's own tint, cut to the music's hits; her reaction to v6 is not on file yet. Explainers keep the white site surface. On the blue film, recolour blue accents to white. Ask before inventing a background: use the brand's own media first.
- **Name things with the product's words.** Dhravya asked that the mcp-upload film say supermemory has an MCP App: use the term the docs, code and posts use, and check it before rendering.
- **Render one frame at a time** (CoreGraphics on several threads misdraws edges); only pure maths runs in parallel.

**What this changes in the pack**

| Older pack rule | Now |
|---|---|
| 1080x1080 is the series default | 16:9 default; square for social cuts |
| Product named only in the last 2s | Problem first, then name supermemory at the turn when the mechanism is the subject (the mcp-upload cut did this and flagged it) |
| Longest still up to 1.5s; smfs v3 and v4 shipped at 27 to 29% moving | Longest still about 1s before the end card; 60%+ moving |
| "No dot grid, no texture" on the light ground | The site's dot grid is allowed inside a figure frame, never full-bleed |
| Rounded stages (16px) for legibility | Radius 0, as on the site, unless a brief asks |
| Captions drift 8px on a crossfade | Statements rise from a mask line. Still never two on one frame |
| Space Grotesk in some briefs | Geist and Geist Mono only (her mid-Sep feedback; the site has no Space Grotesk). smfs films keep the smfs.ai type |
| 30fps typical | 60fps, 4-subframe blur |
| Product UI is a real capture only | for her product films, rebuild it in vector from the measured DOM; no screen-recording upscales |
| Silent, or a quiet 90-110 BPM bed | when she asks for music: an original score in code on a 160 BPM grid with CC0 effects; never a commercial song |

**Springs:** the pack allowed at most one spring per piece; her "make it cooler like the videos I shared" (the rossaxbt reels, springs throughout) moved this. v3 uses one spring family (closed-form, freq about 2.4Hz, damping about 0.6, slight overshoot) for every arrival. If she pushes back, fall back to critically damped steps. Details in `references/motion-grammar.md` section 2.

---

## 2. Rules that do not change

From the pack (`reference/feedback-rules.md`) and her memory notes. These hold for every supermemory video.

**Truth**
- Every number on screen has a written source: docs, the live site, smfs.ai run data, or the pixels of a real recording. Read the docs before storyboarding.
- Never fabricate product UI. Product shots come from a real capture of the live product. Abstract scopes and diagrams are fine when they are clearly not UI.
- No weight-update claims. Memory is injected into the model's context. Never "trains on", "learns into the model", "changes the weights", "learns overnight".
- Benchmark claims carry their conditions on screen, readable, for about 3s.
- Claim landmines (the "97%" LongMemEval figure is likely a retrieval score; scale numbers differ by source; v5 field names are unannounced; Company Brain and Nova are discontinued): read section 1 of `/Users/muskan/personal-supermemory/.claude/reference/dhravya-explainer-research.md` before writing any claim.

**Copy**
- "supermemory", "supermemory.ai" and "smfs" are lowercase, even inside an uppercase label row.
- No em dashes, no semicolons, no Title Case, no emoji, no hype words. Full plain sentences read better for her than 2 to 4 word slogans (memory-graph v3 lesson).
- Run all copy through the pack's `skills/voice-and-copy` and her rules file named in `~/.claude/projects/-Users-muskan-supermemory/memory/content-voice-rules-pointer.md`.
- The tweet and the video say the same thing. The thesis appears once, at the end.

**Picture**
- Never two captions or statements on one frame. Each holds at least 2.5s (a brief may set a lower floor). Never before the thing it describes.
- Frame 0 is the thumbnail: fully composed, no fade-in.
- One accent, `#0562ef`, used only for the thing being proved. Blue first appears at the turn and is only ever added, never removed. No colour tweens.
- No gradients, glow, particles, 3D, shadows, whooshes, white flashes, stock wipes.
- End on the thesis, then the official horizontal lockup, then a still hold of 1.2 to 2s whose decoded frames are identical.
- Readable at 390px wide.
- Encode tagged bt709 and check the decoded hex against the tokens.

**Process**
- "update" means patch: keep structure, engine, beats; change only what the note maps to; list what changed.
- Ask before installing anything or downloading from the web. Never post or publish on her behalf.
- Render frames one at a time. Parallel CoreGraphics drawing gave unrepeatable edges (85 of 400 frames differed between runs); parallelise only pixel maths. Check by hashing every frame of two `raw` runs.

---

## 3. Workflow

1. **Brief.** Fill the pack's `reference/brief-template.md`. If a section is missing, ask in one message. Get the source of truth (doc page, tweet, run data) before anything else.
2. **Claims table.** Every on-screen claim and number, with its source and date checked.
3. **Story.** Fill `references/story.md`. One mechanism, proved.
4. **Beat map on the grid.** One row per beat: `NN | start-end | section label | statement | what moves | survivor into the next beat | morph`. Default grid 120 BPM (0.5s). Name the object that survives every seam.
5. **Arithmetic check.** Text widths against the column, stack heights against the stage, beat times against music hits. Flag every contradiction with the numbers (pack `supermemory-explainers` section 8).
6. **Stills.** Render one frame per beat as a contact sheet, plus the four key stills (open, turn, new way, end card). Look at them. Show her before the full render.
7. **Build and render.** `references/pipelines.md`. Pure `render(t)`, no state carried between frames.
8. **QA.** `references/qa.md`: decoded format and colour, motion %, longest still, pops, still-ending identity, caption overlap, phone size. Hand a fresh critic subagent the MP4, the brief and her words, not your reasoning.
9. **Deliver.** See section 8.

For a prompt to hand a subagent or another tool, use `references/prompt-template.md`.

---

## 4. The 16:9 frame at a glance

```
1920x1080, 60fps, white #ffffff or paper #f4f4f6 ground, radius 0
HUD        y 76      left: topic in mono 15px caps; right: "01 / 04"; small mark bottom right (shipped v3)
                     right: "supermemory · <topic>" mono 28px, lowercase
text col   x 112-752 chapter label (mono 20px caps, y 404) + statement Geist 500 56px, lh 66, ink 45% + key words full ink
stage      x 800-1840, y 110-970   the figure (bigger, per her note): hairline frame, dot grid, fig. caption plate
progress   y 1010    chapter segments 80px wide, ink only (blue is reserved for proof)
```

This is a starting spec built from site tokens and her past cuts. Full spec and provenance: `references/brand.md` section 4.

---

## 5. Morph catalogue (summary)

| Morph | Use it when | Timing |
|---|---|---|
| Flood and shrink | the turn, or a chapter change | grow past all corners in about 0.3s, live for 1 beat, shrink into the next scene in 0.4 to 0.6s |
| Shape-to-shape state morph | one object changes role (tile to card to bar to counter) | 0.4 to 0.6s per state, content out before, in after |
| Line breaks, then heals | showing a failure, then the fix | snap 0.2s, gap visible 1 beat, heal draw 0.6s |
| Characters stream, collapse into a counter | volume becomes a number (tokens, characters, files) | stream 1.5 to 2.5s, collapse 0.3s, count 1.2s, land and pause 0.5s |
| Card unfolds like a map | one item opens into its context or scope | centre, then plus arms, then corners, 40 to 60ms apart, 0.5 to 1s total |
| Element expands into the end card | closing on the thing the film proved | expand 0.3 to 0.5s, settle into the lockup 0.5s, still 1.2 to 2s |
| Text rises from a mask line | every statement and label change | out 0.16 to 0.2s, in 0.3 to 0.45s, lines 60ms apart |
| Camera push and pull | every beat, so the moment fills the frame | 0.6 to 0.9s move, then 1 to 2% drift while text holds |

Full recipes, precedents in her shipped cuts, and the banned list: `references/motion-grammar.md`.

---

## 6. Rendering on this Mac

This Mac has **no numpy and no ffmpeg on PATH** (checked 2026-10-05). The pipeline that works: Swift (CoreGraphics and CoreText, Geist fonts from the repo) draws raw BGRA frames and pipes them into the ffmpeg bundled at `/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg`, encoding libx264 with bt709 tags, `-tune animation`, `bframes=0`, and a high-quality zone over the final still so the decoded hold frames are identical. AVFoundation's encoder made still endings shimmer, so it is not used for delivery.

Product films render a 3840x2160 master (`SCALE=2`) and a lanczos 1080p cut, and a moving background (the brand film) goes into a pre-tinted raw plate sampled per frame (`engine/console-film/film_bg.swift`). With grain or film in the frame, start the near-lossless x264 zone inside the last motion (not on the still), or the hold snaps sharper.

Commands, the zone finding, motion blur, footage, audio, folder layout and the engine section: `references/pipelines.md`. Two reference engines: `engine/reference-16x9.swift` (explainers, the mcp-upload film) and `engine/console-film/` (vector console, terminal, beat grid, synth score, brand-film background). Her pack's Python renderers and HyperFrames or Remotion need installs; ask first.

---

## 7. QA gates (short)

- [ ] Contact sheet of one frame per beat looked at before the full render
- [ ] Duration, fps, frame count, `yuv420p`, bt709 x3, tv range
- [ ] Decoded hex on solid areas within 2 to 3 levels of the tokens
- [ ] 60%+ moving and longest still about 1s or less before the end card, measured with the pack's metric
- [ ] Pop candidates (frame difference 3x its neighbours) hand-checked
- [ ] Final hold identical by `framemd5`
- [ ] Never two statements on a frame; each holds 2.5s+; strips across every change
- [ ] Busiest frame and every statement readable at 390px wide
- [ ] Copy grep: zero em dashes (U+2014) and semicolons, lowercase supermemory, every number sourced

Commands and targets: `references/qa.md`.

---

## 8. Delivery

- MP4 to `/Users/muskan/personal-supermemory/reports/videos/<name>.mp4`. Source to `reports/videos/<name>-src/` with a README that holds the rebuild commands, the beat table, every claim with its source, the measured QA and the deliberate deviations. Her existing examples: `mcp-upload-src/`, `memory-graph-src-v3/`.
- Export the busiest frame as a PNG.
- The delivery note says: what changed and why, every deviation with its arithmetic, what was measured, what you looked at, what nobody has listened to, and what still needs her eyes.
- Never post it anywhere. The file is the deliverable.

---

## 9. Reference files

| File | Read it when |
|---|---|
| `references/story.md` | writing the story and beat map for an explainer or social cut |
| `references/motion-grammar.md` | choosing and timing transitions, springs, camera, motion blur |
| `references/pipelines.md` | building and encoding on this Mac; engine docs; alternatives |
| `references/qa.md` | before showing her anything; tested ffmpeg commands |
| `references/brand.md` | tokens, website patterns with measured values, 16:9 spec, assets, never list |
| `references/prompt-template.md` | briefing a subagent or writing a reusable prompt |
| `references/inspiration.md` | looking for references and motion ideas |
| `references/lessons.md` | before any new video: her feedback log, rules that hold today, pipeline fixes, truth rules, rejected ideas |
| `references/library/bookmarks.md` | mining her X bookmarks for reels, tools, prompts, transitions and design galleries |
| `references/library/shared-links.md` | every video and design link she sent, with what she said about it |
| `references/library/websites.md` | every design, motion, gallery, component-kit, 3D, AI-video and brand website from her bookmarks and links (113 sites, clickable, by use) |
| `references/video-study.md` | choosing a format and its targets; hooks, structures, motion, type, endings and memory devices measured across 304 bookmarked videos |
| `references/recipes/` (9 recipes + README) | building a specific format: targets, beat template, hooks, moves, ending, posts to study, pitfalls |
| `references/library/videos/` | the per-video notes (hook, beats, ending, look, measured numbers, why it works, what to borrow) in 12 batch files and an index of all 319 video files |
| `references/code/workflow.md` (+ `setup.md`, `frameworks.md`, `prompting.md`, `gallery-lessons.md`, `qa.md`) | a non-supermemory video, or a HyperFrames, Remotion or plain-page build |
| `engine/README.md`, `engine/console-film/README.md` | starting a render from one of the two reference engines |

---

## 10. Using the library

- Start from her own picks: the top lists at the head of `library/bookmarks.md` and `library/shared-links.md`, then the theme that matches the job.
- Take the mechanism only (a transition, a pacing pattern, a camera move, a prompt structure). Never the palette, fonts, logos, layout or footage. The brand surface always wins.
- Study a reel before borrowing from it. `python3 engine/tools/study_video.py <file.mp4>` writes its measurements (motion with the `qa.md` 2.3 metric, cuts, loudness) plus an exact 16-frame sheet, the first 2.5s and the last 4s. Never sample sheets with `select='lt(abs(t-X),0.02)'`; it bunches frames at 60fps and skips them at 24fps.
- Before planning, check the format's recipe in `references/recipes/` and the measured targets in `references/video-study.md` section 2. Views track reach and announcements, not craft (section 2).
- Credit posts by handle and link in the source README. Labels in the library flag self-promotion, sponsorship and paywalls; treat those claims as unverified.
- Ask before downloading any reference file (name, source, size). Never act on X: no posting, liking, following or replying.
