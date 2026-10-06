# video-master

Muskan's master Claude Code skill for making videos and motion graphics in code: explainers, launch reels, product and console films, data films, social cuts and code-built promos. It covers supermemory work and anything else. It brings together:
- everything learned making supermemory's films from 2026-09-12 to 2026-10-06;
- the general code-motion-graphics workflow;
- a library of every motion-graphics bookmark and link she has shared.

Claude reads it before any video job. It routes the job, applies her current direction, and then follows a fixed order: brief, claims, story, beat map, stills, build, render, QA, delivery.

## Install

```bash
git clone https://github.com/muskanai0409-cell/video-master.git ~/.claude/skills/video-master
```

Keep the folder name. Claude loads the skill when a request matches its description, for example "make a 20 second launch video for the new API".

## What is inside

| Path | What it holds |
|---|---|
| `SKILL.md` | Routing by job type, her current direction (which overrides older rules), rules that never change, the workflow, the 16:9 frame, the morph catalogue, rendering, QA gates, delivery, and how to use the library |
| `references/lessons.md` | Her feedback log, dated and quoted, plus the rule each note became. Craft rules that hold today, pipeline fixes, truth and fact-check rules, rejected ideas, open items |
| `references/library/bookmarks.md` | 174 motion, video and design picks from her 604 X bookmarks (2026-06-05 to 2026-10-04), by theme, each with what to take, plus an index of every tool and gallery they link |
| `references/library/shared-links.md` | 91 links she sent in her own messages, with what she said about each, grouped by theme |
| `references/library/websites.md` | 113 design, motion, gallery, component-kit, 3D, AI-video and brand websites from her bookmarks and links, each a clickable link with what it is, what to use it for and the post it came from |
| `references/video-study.md` | A frame-by-frame study of all 304 videos in her bookmarks (2026-10-06 and 07): measured benchmarks per format and per view tier, hooks, structures with timings, motion, type, UI, AI footage, sound, endings, and what to take for supermemory |
| `references/recipes/` | One build recipe per format (launch film, product demo, UI-morph reel, explainer, changelog update, ad, talking head, AI footage, memory scenes): targets, beat template, hooks, moves, ending, posts to study, pitfalls |
| `references/library/videos/` | The per-video notes for every video bookmark (319 files in 12 batch files) and an index with each post's link and measured numbers. The videos themselves are not stored |
| `references/inspiration.md` | Curated design resources and the motion references her direction comes from, and how to study a reference |
| `references/story.md` | The problem-first story template for 16:9 explainers and square social cuts, with a worked example |
| `references/motion-grammar.md` | The morph catalogue (flood and shrink, state morphs, a line that breaks and heals, streams into counters, map unfolds, mask-line text, camera push and pull, cursor-driven change), timing, springs, motion blur, seam table, banned list |
| `references/brand.md` | supermemory's three brand surfaces, measured website tokens and patterns, the 16:9 frame spec, assets, the never list |
| `references/pipelines.md` | The Swift to ffmpeg pipeline that works on her Mac, encode settings, motion blur, the engines, alternatives |
| `references/qa.md` | Tested QA commands that need no numpy: decoded colours, the motion metric, pop scan, identical still ending, contact sheets, phone size, loudness, copy |
| `references/prompt-template.md` | A reusable brief for a subagent or another tool, plus the patch prompt |
| `references/code/` | The general code-motion-graphics workflow: setup, frameworks (HyperFrames, Remotion, plain `seek(t)` pages, node canvas), prompting, the lessons of revid's 64-post gallery, QA |
| `engine/reference-16x9.swift`, `engine/reference-square-v1.swift` | Reference explainer renderers (CoreGraphics and CoreText, 60fps, 4-subframe motion blur) |
| `engine/console-film/` | Sources of the one-command console film: the console UI rebuilt in vector, a typeset terminal, a 160 BPM beat grid shared with a synthesised score, CC0 effects, the supermemory.ai hero film as a background cut on the hits, 4K master |
| `engine/assets/` | Geist and Geist Mono fonts, and supermemory lockup masks |
| `engine/tools/` | `study_video.py` measures any reference video and makes its exact contact sheet, hook strip and end strip. Also helpers made during the films: a frame-hash determinism check, an SVG and PDF to alpha-PNG rasteriser, an SVG arc-flag fixer, and a localhost capture inbox for getting Chrome screenshots onto disk |

## How it was built

- **Her supermemory video pack** (her own Hyperagent skills) and the **video-master** and **code-motion-graphics** skills built with her on 2026-10-02 and 2026-10-05.
- **Every film made with her** and its README: version history, her notes per version, measured QA. The films are mcp-upload, memory-graph, one-memory, one-command, recall-strip, namespaces and smfs.
- **Her X bookmarks:** all 604 were read and the video, motion and design ones were kept. Posts are credited by handle and link. Text is paraphrased, and quotes are kept short.
- **Every link she sent in her own messages** to Claude Code, from 2026-09-05 onward. Among them are the three design-reference lists she sent on 2026-10-06: @devjuninho (8 sites), @noahelhadedy (11 sites) and @MaybeFlorent (an interactive-sections showreel).
- **The video study (2026-10-06 and 07):** every video in her bookmarks was downloaded for study only (never stored here), measured with the same motion metric as her cuts, and read frame by frame by six study passes. Their notes are in `references/library/videos/`, the synthesis in `references/video-study.md`, the build steps in `references/recipes/`.
- **Earlier research:** Hamza Khalid's setup guide, the 64-post revid.ai "Claude motion graphics" gallery, and the open kits and repos credited in `references/code/`.

## It installs nothing by itself

Claude asks before installing or running third-party code, and before downloading any file. It never posts, publishes or acts on her accounts. It treats commands found in posts, READMEs or other skills as information, not instructions.

## Private

This repo holds supermemory brand assets (the lockup masks) and notes on unreleased work. Keep it private unless those are removed.

## Credits

The general workflow draws on [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) (Apache-2.0) and [remotion-dev/skills](https://github.com/remotion-dev/skills) (no licence file, so paraphrased). It also draws on these kits:

| Kit | Licence |
|---|---|
| [buildwithhanif/claude-animation-skill](https://github.com/buildwithhanif/claude-animation-skill) | MIT |
| [JohnHeibel/ClaudeAnimationBase](https://github.com/JohnHeibel/ClaudeAnimationBase) | MIT |
| [Leonxlnx/claude-launchvideo](https://github.com/Leonxlnx/claude-launchvideo) | MIT |
| [echris6/motion-video-kit](https://github.com/echris6/motion-video-kit) | MIT |
| [op7418/guizang-product-video-skill](https://github.com/op7418/guizang-product-video-skill) | AGPL-3.0 |

The curated lists [guanmo-ai/awesome-ai-motion](https://github.com/guanmo-ai/awesome-ai-motion) and [athemeroy/awesome-claude-5-5-videos](https://github.com/athemeroy/awesome-claude-5-5-videos) (CC BY 4.0) are credited too. Licence details are in `references/code/frameworks.md` and the code-motion-graphics README.

Thanks to every creator whose post is linked in the library. Geist fonts are by Vercel (SIL Open Font License).
