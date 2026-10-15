# Lane A: what makes my Claude-made motion recognisable, and the antidotes (2026-10-15)

**Contract:** `00_contract.md` in this folder. Lane question: what makes AI and Claude-made motion graphics recognisable and generic, and how do the best AI-assisted creators avoid it.

**Method:**
- **Repo audit:** the READMEs and source of `forgetting-src`, `forgetting-v3-src`, `learner-teaser-v7-src`, `local-v009-src`, `console-part1-src` and `meadow-16x9-src`, plus `~/.claude/skills/video-master/references/` (`brand.md`, `motion-grammar.md`, `motion-systems.md`, `lessons.md`, `SKILL.md`).
- **Web:** articles, docs and X posts, read through the public fxtwitter API mirror where x.com returned 402. Anthropic's Opus 5.5 prompting guide was read directly.

**Source rules:** an X post proves what its author said, not that it is true. Vendor pages are flagged. Quotes are under 15 words; everything else is paraphrased. Nothing was downloaded.

**Related:** lane C §4.1 lists the same watermark from the lessons log. `references/anti-house-style.md` and `style-log.md` (written in the main session today) already turn part of this into rules. Section 3.3 below lists what this lane adds to them.

---

## 0. The short version

1. **The watermark is a recipe, not one effect.** My skill adopted all 12 signature moves of the most-bookmarked Claude motion prompts of Opus 5.5 launch week: @twoclipping's UI-morph prompt (1.16M views, 21K bookmarks) and his "Develop" film. @rossaxbt posted near-identical templates on Oct 3 and 4. Each recent film uses 8 to 10 of the 12.
   - The moves include: one continuous take; text rising from a mask line; spring pops; a black shape that floods past the corners, then contracts; an event on every beat; a cursor; a zoom to fill the frame; closed-form springs; 4-subframe blur; -14 LUFS; and the pop scan.
   - `motion-grammar.md` adopted these as house rules on Oct 5 and 6. Anyone who scrolled X in late September has seen hundreds of films built the same way.
2. **Anthropic's own guide names two of my defaults.** The Opus 5.5 prompting guide lists numbered "01/02/03" section labels and monospace labels as the model's fallback styles, with cream or off-white grounds, italic accent words and pill buttons. Every recent film opens with a mono uppercase `01 · SECTION` label and a big section number.
3. **The films share code.** `lib.swift` is byte-identical in learner-1 v7, forgetting v3 and local v0.0.9. Every film since one command uses the same spring (2.4 Hz, damping 0.62) and the same stock easing presets. They also share:
   - the caption band at y 868;
   - the letter-rise function (12 ms per letter, 0.42 s);
   - the 160 px grid with + marks;
   - 8-beat sections with the drop at beat 16;
   - the same ending;
   - Apple Loops from the same "01 Hip Hop" pack.
4. **The internet's tell list has moved past the cheap tells.** I already avoid the cheapest ones: centred text on a purple gradient, Inter, fade-ins.
   - The 2026 lists add: the same recipe reused ("brief contagion"); monospace numbered labels; constant motion ("motion for motion's sake"); every line animated; machine-perfect surfaces; model-drawn icons and invented data; synthetic voice cadence; and dithering, now sold as an AI-agent skill.
   - My films hit most of these.
5. **The antidote is decisions, not effects.** Top designers pick one anchor from outside tech per film. They choose curves per object class, use stillness and cuts on purpose, step their timing, add imperfection deliberately, take sound from real sources, and plan colour as a script. Each is turned into a numbered rule in section 3.
6. **Keep the brand constant, vary everything else.** Geist, the Bayer dither and the dot lattice are brand rules, but each is now also an AI default:
   - Geist is named as an AI-default font.
   - MengTo's dither skill has 1.3K installs.

   Keep them for the mark and the payoff, and stop letting them be the whole film's look.

---

## 1. My own house style: evidence from the repo

### 1.1 The lineage: the viral Claude recipe became my rules

The @twoclipping prompts: "Develop" (2026-09-26, about 139K views, 3.8K bookmarks, https://x.com/twoclipping/status/2103835273813496100) and the UI-morph template (2026-09-24, about 1.16M views, 21K bookmarks, https://x.com/twoclipping/status/2103273003555402193). They were read through the public API mirror on 2026-10-15. @rossaxbt posted near-identical templates on Oct 3 and 4; `motion-grammar.md` credits him and notes the match. His two posts returned 404 on Oct 15, so they could not be re-read.

Per film: learner-1 v7 to v11 and forgetting v3 use 9 of the 12 (no flood, no cursor, no edge springs), local v0.0.9 uses 10, and console part 1 about 8 (its moves are keyed to the voice rather than the beat).

| # | Move in the @twoclipping prompts | Where my skill adopted it | Films that carry it |
|---|---|---|---|
| 1 | One continuous take, each scene grows out of the last, no cuts | `motion-grammar.md` §1.1, SKILL §1(d), lessons #43 | every film since mcp-upload v3 |
| 2 | Text rises out of a mask line | `motion-grammar.md` §3.7; `riseText` in every engine | learner, forgetting, local, console |
| 3 | Icons pop from zero on a spring | lessons #79 ("spring pops"); `spring(... freq: 3.0, zeta: 0.45)` pop in `learner-teaser-v7-src/scene.swift:483` | learner, forgetting (cards spring out) |
| 4 | A black shape floods past the corners in about 0.3 s, then contracts into the next scene | `motion-grammar.md` §3.1 "Flood and shrink" | learner-1 reel, memory graph, mcp-upload |
| 5 | Closed-form springs as a pure function of time, one spring per target change | `motion-grammar.md` §2; `spring()` in every `lib.swift` | all |
| 6 | 120 BPM, an event on every beat | `motion-grammar.md` §1.3; SKILL §1(f) "something lands every half second" | all (at 140 to 164 BPM) |
| 7 | A cursor performs clicks and drags | `motion-grammar.md` §3.9; lessons #45 | mcp-upload, one command, console |
| 8 | The camera zooms so each moment fills the frame | `motion-grammar.md` §3.8 "Camera push and pull, every beat" | all |
| 9 | 4 subframes blended for motion blur at 60 fps | `motion-grammar.md` §4 | all (8 subframes from learner v8) |
| 10 | SFX on measured peaks, -14 LUFS | lessons §2.7; `make_audio*.sh` | all scored films |
| 11 | One frame per beat before the render; a pop scan at 3x the neighbours | `qa.md`; lessons §3.6 | all |
| 12 | Edge springs: leading and trailing edges on different springs, so a shape stretches | `local-v009-src/film.swift:99-104` ("edge springs: each edge on its own small lag") | local v0.0.9 morph chain |

The other viral pipelines teach the same thing, so the X audience has learned this exact look:
- @RaphaelAubryy, 2026-09-28, 404K views: closed-form springs with slight overshoot, 8 subframes, a beat map, -14 LUFS.
- 0xMovez, 2026-10-04: closed-form springs with a tiny overshoot on UI and none on type, 4 subframes, 120 BPM.
- @rexan_wong, 2026-09-26, 637K views.

### 1.2 Shared code (the same numbers in every film)

| What | Value | Where |
|---|---|---|
| `lib.swift` | **byte-identical** (md5 `674a21f5…`) | `learner-teaser-v7-src/`, `forgetting-v3-src/`, `local-v009-src/` |
| The spring | `spring(freq: 2.4, zeta: 0.62)`, the same default in every film | `lib.swift:56` in the three above; `console-part1-src/lib.swift:58`; `namespaces-v5-src/lib.swift:66`; `one-command-v2-src/lib.swift:66` |
| Easing | `ease = (0.2, 0, 0, 1)`, which matches Material 3's standard easing token. `eout = (0.22, 1, 0.36, 1)`, the stock "ease-out-quint" preset. `einout = (0.65, 0, 0.35, 1)`, the stock "ease-in-out-cubic" preset. `ease2 = (0.5, 0, 0.2, 1)` for the camera | `lib.swift:46-48` (learner, forgetting, local); `console-part1-src/lib.swift:45-48` |
| Where the curves came from | the supermemory.ai site's computed CSS (`brand.md` §2: arrival `.22,1,.36,1`, move `.2,0,0,1`) | right for rebuilt UI; a tell when every object in every film moves on them |

The preset names come from the `tailwindcss-easing` package. The Material 3 match comes from Flutter and M3 token references (see the ledger).

### 1.3 Every recurring choice, by area

**Type and copy**

| Recurring choice | Exact values | Where |
|---|---|---|
| Every statement rises letter by letter from a mask line | 12 ms stagger per letter, 0.42 s on `eout`, travel 0.95 × the font size; exit 6 ms per letter over 0.26 s; clip box 1.38 × the size | `learner-teaser-v7-src/scene.swift:319-334`; `forgetting-v3-src/scene_base.swift:178`; `local-v009-src/film.swift:164` |
| Statements are two lowercase lines in Geist 500 at 66 to 68 px | `STATE_F = sans(66, 500)`; `CAP_F = sans(68, 500)` | learner `scene.swift:317`; local `film.swift:856` |
| Captions follow the same shape and timing | Line 1 is a claim, line 2 a qualifier. The first line arrives about 0.3 to 0.5 beats into an 8-beat section, the second 0.6 to 1 beat later, and both leave at about beat 7.5 | `learner-teaser-v7-src/timeline.swift:21-28`; `forgetting-v3-src/timeline.swift:25-31`; `local-v009-src/film.swift:859-865` |
| The same closing line in consecutive films | "memory that keeps learning" (learner-1 and forgetting) | the two `timeline.swift` files above |
| Mono uppercase section labels | `01 · WEIGHTS` … `05 · RECALL`; `01 · remembering` … `04 · on command`; Geist Mono 22, uppercase, y 108 | learner `scene.swift:336-351`; forgetting `timeline.swift:33-35`; README of learner v7 |
| Big section numbers, bottom right in the band | `NUM_F = mono(54, 400)`, right-aligned at `BAND_Y + 158`; local uses `SEC_F = mono(54, 400)` | learner `scene.swift:350`; forgetting `scene_film.swift:411`; local `film.swift:876` |
| Brace verbs at 124 px | `{ updates } { merges } { infers } { forgets }`; `{ expires } { updates } { filters }` | learner `scene.swift:353-358`; forgetting README beats table |
| Scrambled text resolving | magicui Hyper Text / Text Scramble; `scrambled(cps: 26, settle: 0.07)` | `forgetting-v3-src/scene_film.swift:11`; forgetting README "Motion, from her saved sites" |
| Typed commands, one key sound per character | `docker compose up -d`; the code of `forgetMatching` | local README beats b5.3 to b7.4; forgetting README |
| Geist and Geist Mono only | the brand rule (her mid-Sep note) | `brand.md` §1; lessons #12 |

**Layout and frame**

| Recurring choice | Exact values | Where |
|---|---|---|
| A bottom caption band with a hairline | `BAND_Y = 868` in three films; a hairline at 32% paper | learner `scene.swift:10, 341`; forgetting `scene_base.swift:8`; local `film.swift:221, 867-871` |
| A HUD band, a world viewport and a caption band, hairline at each edge | the forgetting v3 "frame" | `forgetting-v3-src/README.md` (table: "A frame") |
| The 16:9 explainer frame | text column, figure stage, `01 · THE PROBLEM` HUD, chapter progress rule | `brand.md` §4; SKILL §1(b) |
| A hairline grid with + marks | a 160 px pitch, lines at 7% paper, + marks ±5 px at 42% | learner `scene.swift:363-378`; `forgetting-v3-src/scene_base.swift:196-210` |
| Symmetric, centred end compositions | the board ends as "a tidy 1-4-1 cross"; the mark is centred, then the lockup is centred | forgetting v3 README; local README b46 to b50 |

**Surface, colour and texture**

| Recurring choice | Exact values | Where |
|---|---|---|
| Blue 600 field, light dithered toward blue 500 on an 8x8 Bayer matrix | `FIELD = 0x0100f5`, `BLUE500 = 0x0562ef` | `world.swift:5-6` (forgetting, learner); `film.swift:8-9` (local); `motion-systems.md` §1 |
| A screen-fixed dot lattice, 7 px pitch; stored = square, recalled = 45° diamond | | `motion-systems.md` §1; learner v7 README |
| Paper on blue, gold accents | `PAPER = 0xf4f8ff`; `GOLD = 0xf3c77a` on lead tokens, synapses, section verbs | `world.swift:7-8`; learner `scene.swift:409-420`; forgetting `scene_film.swift:414` |
| The same brand film plate under product films | `field.mp4` tinted (R ×0.392, G ×0.618, B ×0.961) | `console-part1-src/film.swift:185-192` reuses `one-command-v2-src/bg/plate_2112x1188.rgb`; lessons §3.11 |
| Machine-perfect surfaces | the only grain is a triangular dither of about 1.6 levels against banding; no misregistration, no boil, no paper | lessons §3.12 |

**Motion primitives and camera**

| Recurring choice | Exact values | Where |
|---|---|---|
| Spring overshoot on arrivals | the 2.4 Hz / 0.62 family; pops at 3.0 Hz / 0.45 | `lib.swift:56`; learner `scene.swift:483` |
| A camera that never rests | Hermite spline through keyframes in log zoom; a push toward each change, then a pull back; a 1 to 2% drift during holds | `forgetting-v3-src/world.swift:79-120`; `motion-grammar.md` §3.8 |
| Zoom punches on hits | `punch()`: amplitude 0.05 to 0.07, attack 30 ms, decay 130 ms | `learner-teaser-v7-src/world.swift:72-80`; `local-v009-src/film.swift:59-76` (removed in forgetting v3, `world.swift:126`) |
| Shake on the drop | 9 px decaying over 0.09 s, for 0.35 s | `learner-teaser-v7-src/world.swift:64-70` |
| A whip to the next subject on the drop | "a whip to learner-1" at beat 16 | `learner-teaser-v7-src/world.swift:26` |
| Shockwave rings through the lattice | waves at 1,100 to 2,100 px/s, amplitude 0.45 to 0.85, on every hit | `forgetting-v3-src/scene_base.swift:40-42`; `local-v009-src/film.swift:267, 286-287` |
| The lattice pulses on every kit beat | `0.4 × (1 - e^(-u/0.02)) × e^(-u/0.12)` | `forgetting-v3-src/scene_base.swift:46-50`; learner `scene.swift:90-94`; local `film.swift:290-295` |
| Token streams along Béziers | paper bars with a gold lead token | learner `scene.swift:400-420`; forgetting `scene_base.swift:223` |
| Even footage gets the house camera | quintic-eased keyframes and blur on the tilt | `meadow-16x9-src/README.md` |

**Transitions, pacing and structure**

| Recurring choice | Exact values | Where |
|---|---|---|
| One survivor object morphs through states | a prompt chip, then a command bar, terminal, API call, request bar, counter, squares, the mark; or a chat bubble, then a query, a code editor, a query | local README; forgetting v3 README; `motion-systems.md` §3, §5 |
| A grid of 8-beat sections | each section is one bar of the kit, at 2× the kit's tempo; sections start on beats 0, 8, 16, 24, 32 and 40, with the lockup at about 48 | forgetting README ("each section is 8 beats"); learner v7 README; local README |
| The drop at beat 16 (or 8) | crash, shockwave, zoom punch, often a whip and shake | forgetting draft-1 README; learner v7 README |
| Constant motion | 78.4 to 89.4% of frames moving; the only still is the end card | QA in the forgetting v3, learner v7/v11 and local READMEs |
| Frame 0 is a subject recalled out of the lattice | the skull or brain; "v0.0.9" | learner v7 README; local README b0 |

**Ending**

The same five steps in every film:
1. Everything gathers.
2. The mark assembles: from diamond dots (learner, forgetting), or a square carved by the mark's distance field (local).
3. The mark slides into the horizontal lockup.
4. The wordmark wipes or ramps in from behind the mark.
5. A chip or version line (local, console), then a still of 1.25 to 1.4 s with bit-identical frames.

Sources: the README beat tables of all four films; `local-v009-src/film.swift:812-831` (`drawEnd`, wordmark `front` ramp); `motion-grammar.md` §3.6.

**Sound**

| Recurring choice | Exact values | Where |
|---|---|---|
| Kits from one GarageBand pack | Apple Loops "01 Hip Hop": Regrets (F minor, 80 → 160), Longing (C minor, 82 → 164), Yearning (A minor, 70 → 140), Full Moon (F# minor, 77 → 154), Rise Up (C major, 81 → 162); or a 160 BPM F-minor code synth | `motion-systems.md` §4; `score_forget.swift:1-5`; local README |
| One arrangement template | 1. keys alone. 2. drums in. 3. drums out for 1.5 beats before the turn, with a snare roll and a riser. 4. crash and boom on the drop. 5. a riser into the lockup. 6. the sub under the lockup | `motion-systems.md` §4; `forgetting-v3-src/score_forget.swift:54-61, 107-114` |
| The same SFX family | Kenney CC0 `switch11` to `switch14`, `click_002` to `005`; bells on true answers, thumps on stamps | `score_forget.swift` SFX block; lessons §3.14 |
| Synthetic voice on the console film | Kokoro `af_bella` | `console-part1-src/README.md` |
| Delivery | -14 LUFS, -1 dBTP | all READMEs |

**Process**

- Every new film starts by copying an engine: `cp -R engine/brand-lattice/.` (`motion-systems.md`, "Start a film from an engine"). Its constants come along with it.
- The 60 fps 4K master, the 1080 cut and the 18 to 22 s length are the same every time. So are the HUD band, the progress bar and the beat-locked type.
- The look is a byproduct of the toolchain. Nobody chose it for each film.

### 1.4 What is brand (keep) and what is house style (vary)

| Keep: brand rules | Vary: house habits that read as the generator |
|---|---|
| The exact mark and the official horizontal lockup | how the mark arrives (diamonds, carve, wipe), and how long it holds |
| One brand blue as the hero colour | blue 600 plus the lattice plus the grid as full-frame wallpaper in film after film |
| Lowercase "supermemory" in Geist | Geist mask-rise statements and mono `01 ·` labels as the only type voice |
| Bayer dither as the brand's halftone | dither used on every ground instead of as a treatment of one subject |
| No gradients, glow, or decorative particles (`brand.md` §6) | constant motion, punches, rings and pulses (these are decoration too) |

Two cautions. The site itself uses numbered mono cards (`001 / 002 / 003`, `brand.md` §3) and off-white paper grounds, so copying the site faithfully imports two of the Opus defaults Anthropic names (A-01). The site's own curves are also stock presets (§1.2).

---

## 2. What the internet says about AI-made motion tells (2025-2026)

### 2.1 Primary and first-person sources

| ID | Source (author, date) | What it says (paraphrased) | Tells named |
|---|---|---|---|
| A-01 | Anthropic, *Prompting Claude Opus 5.5*, frontend design defaults (read 2026-10-15). https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5 | Without design direction, Opus 5.5 falls back on a few default styles. A general "avoid a generic AI look" mostly swaps one default for another. It responds to named patterns, so check what the first result used and extend the ban list | cream or off-white backgrounds; italic accent words in headlines; numbered "01/02/03" section labels; monospace labels; pill-shaped buttons |
| A-02 | @twoclipping, "Develop" prompt, 2026-09-26 (139K views). https://x.com/twoclipping/status/2103835273813496100 | A $0 pure-code launch film. Every move is listed in §1.1. Its banned list is crossfades, blur-ins, "developing" brightness, 3D flips, particles, glows, holds over 1 s, and anything template-like | the recipe that became the template |
| A-03 | @twoclipping, UI-morph prompt, 2026-09-24 (1.16M views, 21K bookmarks). https://x.com/twoclipping/status/2103273003555402193 | One shape morphs through 8 to 12 UI states on a warm grey canvas in Geist, with slight-overshoot springs, a cursor and a zoom per state; the last frame equals the first | bans bouncy easing, particle bursts, glows, gradients on chrome, dead time |
| A-04 | Rexan Wong (@rexan_wong), 2026-09-26 (637K views, 18K bookmarks). https://x.com/rexan_wong/status/2103707054108299437 | Many one-prompt Opus 5.5 films look generic, including his own. Without a reference the model defaults to centred text, a gradient and fade-ins. He also says everyone uses the same model, so context and direction decide the result | centred text, gradient, fade-ins, fake-looking UI |
| A-05 | Raphaël Aubry (@RaphaelAubryy), 2026-09-28 (404K views). https://x.com/RaphaelAubryy/status/2104502744010629269 and https://github.com/howseen-ai/claude-motion-design | The prompt is a small part of the result and the harness does the work. Without a reference or a real product the output still looks AI-made. Borrow a reference's structure, never its content | default look; "mid" first renders; motion that feels mechanical |
| A-06 | Jake Moran (@jake11moran, HeyGen), 2026-08-03 and 2026-09-23. https://x.com/jake11moran/status/2084382572898070964 and https://x.com/jake11moran/status/2102878602316652828 | Lenny's film: a "motion-doctrine" skill (one continuous camera, no idle motion); "cut-the-curve" (scenes exit and enter in flight at matched speed); a "vox pack" (elements step at 12 fps while the camera stays smooth). His strictest rule is that everything on screen is real UI. Give motion notes by feel, such as slowing every zoom and pan to 0.7x. He also says scenes are reused across launches and HyperFrames has 380+ prebuilt blocks | invented UI; and, by implication, reuse driving sameness |
| A-07 | Filippo Carnevale (EPTA, @filippocarnvl), 2026-09-10 (126K views). https://x.com/filippocarnvl/status/2098112186573082702 | Launch formats die once copied. In a parking lot of identical cars only the different one is seen. Borrow from outside tech, flip the category's loudest trait, and ask whether the buyer has seen this shape in the last 90 days | format fatigue |
| A-08 | @leo_xiaolei, 2026-09-23. https://x.com/leo_xiaolei/status/2102724347446305104 | An anti-generic brief: hand-drawn wobble, procedural paper grain, cream `#F2E8CF`, sparse gradients. Its avoid list: generic SaaS illustration, AI gradients, neon, cyberpunk, stock look | slideshow cuts, crossfades. Note: it still mandates seamless morphing, and cream is itself an Opus default (A-01) |
| A-09 | Leon Lin (@LexnLin), 2026-09-27 (100K views). https://x.com/LexnLin/status/2104148233106723099 | A 33 s launch film for a made-up app, visuals and audio all in code, from one prompt over about 8 hours | (time spent is the signal: craft took hours, not one shot) |
| A-10 | DEV Community, Dishant Sharma, Oct 12. https://dev.to/dishant0406/i-asked-for-a-video-claude-motion-gave-me-an-html-file-459o | Reports an r/MotionDesign thread ("What kind of Motion survives AI?"): a working motion designer called Claude's output beginner-level with no keyframes. Commenters said the bland corporate default goes first | "animated slides"; "stock vector slop"; no keyframe craft (secondhand) |

### 2.2 Articles and design commentary

| ID | Source (date) | What it says | Tells named |
|---|---|---|---|
| A-11 | snapcn.dev (Shadcn Labs), 2026-10-01. https://snapcn.dev/why-ai-motion-graphics-look-the-same | Agents converge on the median of Remotion tutorials. Vague adjectives leave every choice to the default. Agents tween one scene and never watch their render | centred 80 px headline; purple-blue 135° gradient; white Inter; fade 0 → 1 plus a 20 px rise over about 20 frames; one scene, no cuts; bouncing springs |
| A-12 | 0xMovez, 2026-10-04. https://movez.substack.com/p/how-to-build-motion-design-studio | "Brief contagion": 4 of 9 viral posts reused one sentence, so the reels rhyme. A bare one-liner holds no idea | headline over a gradient; every element fading in; corner labels and decorative borders; glow on UI; particle bursts; bouncy easing; sliding instead of easing; dead beats |
| A-13 | Grow With AI (Aniket Chhetri), 2026-09-30. https://growwithaiguide.substack.com/p/claude-makes-the-best-motion-graphics | The same safe look without a reference; Canva and CapCut templates look like everyone else's | overlapping text; sliding instead of easing; text in corners; centred title on a gradient; blurry text; dead beats; bouncy easing; glows; particles |
| A-14 | Charlie Hills, MarTech AI (2026, undated). https://charliehills.substack.com/p/5-fixes-for-claude-motion-graphics | Three tells: invented chart data, the default font, and icons and illustrations Claude draws itself ("animates well" but draws poorly) | invented data; default font; self-drawn icons |
| A-15 | Jack Roberts, "Claude Design FINALLY Solved Motion Graphics" (transcript on LongCut, undated). https://www.longcut.ai/v/claude-design-finally-solved-motion-graphics-RDytbVDzMF4 | Says 99% of Claude motion graphics look generic (his estimate, method not shown); font is the biggest giveaway | fonts; generic icons; decorative rather than informative animation |
| A-16 | Moe Lueker, 2026-09-12. https://moelueker.com/blog/claude-skill-that-makes-videos-hyperframes-heygen | Output gets about 80% of the way, then stalls on fine detail. Scenes made one at a time don't read as one video | weak voiceover; scene inconsistency |
| A-17 | Creative Boom (Tom May), 2026-04-21. https://creativeboom.com/insight/10-trends-creatives-are-so-over-in-2026/ | Ten trends creatives are tired of | AI slop; glassmorphism and Liquid Glass; gradients; lazy minimalism; lazy maximalism; Canva and template culture; Y2K; bento grids; motion for its own sake, including kinetic type on social posts |
| A-18 | The New Yorker (Kyle Chayka), via a secondary summary (letsdatascience, 2026-06-30). https://letsdatascience.com/news/anthropics-claude-design-shapes-new-design-aesthetic-aaf43749 | A recognisable "Claude aesthetic" in sites and decks. The original was not readable (newyorker.com blocked for this agent) | beige and cream; rusty orange; large italic serifs; tracked-out subheads; ticker bars; rounded dashboard elements |
| A-19 | Laith Aljunaidy, "How to detect AI slop in your design" (GitHub wiki, edited 2026-05-24). https://github.com/Laith0003/ux-skill/wiki/How-to-detect-AI-slop-in-your-design | Typeface is the strongest single tell. Motion should answer a question, or be cut | Inter, Plus Jakarta Sans and Geist named; a floating gradient blob; a pulse on every card; the same hover everywhere; round-number stats (47%, 10x, 99.9%) |
| A-20 | Sailop, 2026-04-22. https://www.sailop.com/blog/ai-slop-definitive-guide-2026 | The fade-up (opacity 0, a 20 px rise, ease-in-out) in "roughly 83%" of AI landing pages; its own editor's note says the figures are illustrative | identical reveal timing everywhere; an evenly spaced 100 ms stagger |
| A-21 | 925 Studios (2026; agency). https://www.925studios.co/blog/ai-slop-design-tells | Inter plus an indigo gradient plus three rounded cards: "not choices at all" | defaults instead of decisions |
| A-22 | Opus Pro (Derek Coleman), 2026-04-17. https://www.opus.pro/blog/ai-slop-aesthetic-12-tells | Twelve tells of AI video, mostly generated footage | #5 motion too smooth, lacking real micro-jitter; #11 voice clones without breaths; #12 TTS "plateau" cadence |
| A-23 | VisionLabs, 2026-06-02. https://www.visionlabs.studio/blog/ai-motion-design-state-of-the-art | Broad briefs give generic output. Specify easing mathematically, timestamp the beats, attach a reference still | none named |
| A-24 | Latent Space AINews, 2026-09-29. https://www.latent.space/p/ainews-opus-55-is-good-at-explainer | Records Rexan Wong saying his one-prompt video looked "mid" | none named |

### 2.3 Tooling signals: the look is being packaged and sold

| ID | Signal | Why it matters |
|---|---|---|
| A-25 | MengTo's `dither-background` skill: a 4x4 Bayer ordered dither on a near-black base, 1.3K installs, first seen 2026-05-11. https://www.skills.sh/mengto/skills/dither-background | Ordered dither is now a one-command AI look. MengTo is also a visible Claude-motion creator (the guanmo cases in `code/prompting.md`) |
| A-26 | Bergside's "dithered" agent skill (about 440 installs in an August 2026 snapshot); Framer animated-dither components; UX Pilot's 8x8 Bayer gradient tool (via search results) | Dither has gone from a brand texture to a commodity |
| A-27 | Figma Config 2026 identity (2026-07-27). https://www.figma.com/blog/the-visual-identity-behind-config-2026/ | Figma's brand team built a dithering tool for hundreds of speaker portraits. The look is mainstream, from a top brand team |
| A-28 | Scramble and decrypt components on Framer and 21st.dev; magicui Hyper Text (her own source) | Scramble text is a stock component. Framer University treats it as a small accent, and Calgary's design system caps animated text at one instance per page |
| A-29 | A 3b1b-style animation skill (`subinium/3b1b-style-animation-skill`, via search); deedydas's Opus explainers | Even the 3Blue1Brown look is now a packaged default; copying a look without its reasoning goes generic |
| A-30 | Claude Motion beta, 2026-10-08, from secondary coverage (pasqualepillitteri.it, fourweekmba, borncity). https://pasqualepillitteri.it/en/news/21703/anthropic-launches-claude-dashboards-motion-beta | Code-made 30 s clips from business data for Team and Enterprise. One coverage summary says every animation starts from one Motion template. The Claude-made look will spread further, which raises the cost of looking like it |
| A-31 | HyperFrames' 380+ prebuilt blocks; HeyGen scenes "built once and restyled" (A-06); `ali-abassi/remotion-templates` with about 1,000 templates | Shared blocks are a sameness engine |
| A-32 | GarageBand loops: TidBITS (citing Rolling Stone) says listeners treat spotting bundled loops in hits as a pastime. https://tidbits.com/2019/03/20/for-better-or-worse-garageband-has-changed-music/ Apple Community threads report Content ID claims on films that use loops others have used. https://discussions.apple.com/thread/254661543 | My Apple Loops scores are spottable, and carry a claim risk on social |

### 2.4 The tells she asked about: evidence, and whether my films have them

| Tell | Internet evidence | In my films? |
|---|---|---|
| Centred kinetic text on black or a gradient | A-04, A-11, A-12, A-13 | **Mostly no.** Text sits bottom-left in a band. The end card and the local v0.0.9 counter are centred |
| Typewriter or typed text | A-28 (stock components) | **Yes:** typed commands and code with per-key clicks (local, forgetting, one command) |
| Scramble or decrypt text | A-28 | **Yes:** forgetting (question, code, chatter) |
| Glassmorphism or Liquid Glass | A-17 | **Partly:** the plugins film's Liquid Glass dock, the dots film's frosted cards, the glass head in learner v11 |
| Generic easing | A-11, A-20, A-23 | **Yes:** three stock presets plus one spring on everything (§1.2) |
| Gradient blobs | A-19 | **Near:** learner v11's dithered blue-500 "pool of light" behind the brain |
| Same fonts (Inter or Geist) | A-14, A-15, A-19, A-21 | **Yes, by brand rule:** Geist and Geist Mono only |
| Monospace numbered labels | A-01 | **Yes:** `01 · SECTION` plus a big number in every recent film |
| Same transitions | A-02, A-03, A-12 | **Yes:** a continuous take, morph chains, flood and shrink |
| Stock 3D | no specific source found | **No:** banned by `brand.md` §6 |
| Over-animation, motion for its own sake | A-17, A-19 | **Yes:** 78 to 89% moving, lattice pulses, rings, punches |
| No real footage | A-06, A-14 | **Mostly:** only the brand film plate; the UI is vector-rebuilt, which is a strength |
| Perfect symmetry | A-19 (everything centred) | **Partly:** centred end compositions, a 1-4-1 cross, the grid |
| No texture or imperfection | A-27 (Figma's counter-move), A-08 | **Yes:** machine-perfect vectors and dither, no grain, no boil |
| No art direction | A-01, A-21 | **Partly:** strong brand direction, but no per-film art direction until today's style card |
| Every word animated | A-17, A-28 | **Yes:** every caption letter rises; labels and numbers rise too |
| The same SFX whoosh | her verdict, lessons #22 ("it sounds AI-generated") | **No whooshes** since smfs, but the same Kenney click family, bells and the crash-boom-riser kit in every film |
| Invented data, round numbers | A-14, A-19 | **Partly:** "about 40% faster", "10x" in local (team claims, flagged); illustrative facts are labelled |
| Model-drawn icons | A-14 | **Yes:** pixel-art house, dog, bike, kite drawn in `art.swift` |
| Synthetic voice cadence | A-22 | **Yes:** Kokoro `af_bella` in console part 1 (her pick, lessons #93) |

### 2.5 What could not be found

- No measured study shows that Claude-made motion looks alike. The evidence is practitioner posts, vendor articles and Anthropic's own guide (A-01, the strongest source).
- Nothing found names whooshes as an AI tell. Her own verdict (lessons #22) is the evidence.
- @rossaxbt's two template posts returned 404 through the API mirror on 2026-10-15. The skill's earlier paraphrase stands, and the @twoclipping originals (A-02, A-03) were read instead.
- The New Yorker piece (A-18) was read only through a secondary summary.
- No 2026 interview turned up with a motion studio art director on AI and texture. Figma's Config write-up (A-27) is the closest primary source.

---

## 3. Antidotes

### 3.1 Tell by tell: what top designers do, and a rule I can implement

**Two notes before the table:**
- **Her standing asks still hold.** The antidotes vary the form, never these: lots of movement with one thing blending into the next (lessons #43, #83, #90, #92), polish (#15), the brand (#79, and today's "dont lose the supermemory branding"), readable type on a phone (#71) and the real product (#54). Where a rule below pulls against one of them (rules 7, 8 and 9), it is phrased as variety, not as less, and should be shown to her before it becomes a hard rule.
- **Sourced numbers versus starting values.** Numbers that come from the cited source say so (Carbon tokens, snapcn's sizes, Spider-Verse's twos). The rest are my starting values to tune on stills, not findings.

| # | Tell (from §1 and §2) | What top designers do | Rule (implementable, with numbers) | Source |
|---|---|---|---|---|
| 1 | Every line rises letter by letter from a mask | Type moves only when the motion means something. Default entrances are cuts or very short eases | In a 20 s film: **6 text events at most**; a per-letter stagger **once per film at most**, as a signature. The default entrance is a hard cut on a beat (0 frames) or a 4 to 8 frame ease-out with no rise. Exits are cuts | A-11 (8-frame entrance), A-28 (one animated text per page), A-17 |
| 2 | Mono uppercase `01 · SECTION` labels, big numbers, HUD, progress bar | Anthropic names numbered labels and mono labels as Opus defaults; ban them by name | **No numbered or mono section labels by default.** If the anchor needs labels, make them part of the world (a museum placard, a ticket stub, a rubber stamp) in that anchor's own typographic idiom | A-01 |
| 3 | Two-line statements in a bottom band at y 868 | Type placement is a composition choice per film | Pick one placement per film: on a surface in the world; one full-bleed word cropped by the frame; an editorial column top-left; or **no type**. The bottom band is for voiceover subtitles only | A-11 ("make one word huge, cropped"), lessons #64 |
| 4 | Geist at template sizes | Pair the brand face with one characterful treatment; push scale contrast | Geist stays for brand words. At least once per film, set the largest type at **6x or more** the smallest on the same frame (snapcn's example is 420 px against 64 px). Add one accent treatment from the style deck (serif, pixel type grown from the lattice, type as image, hand lettering) for one moment only | A-11, A-19, `anti-house-style.md` §2.4 |
| 5 | Three stock easing presets on every object | Motion systems give each class of object its own curve and duration | Define **3 or 4 motion classes per film**, each with its own curve: <br>- **info and UI:** a productive curve such as Carbon's `(0.2, 0, 0.38, 0.9)` at 110 to 240 ms <br>- **hero objects:** an expressive curve such as `(0.4, 0.14, 0.3, 1)` at 400 to 700 ms <br>- **camera:** its own long tail over 1.2 s or more <br>- **type:** stepped or cut <br>Exits accelerate and last about half the entrance. No two classes share a curve. Don't reuse the last film's set (a new preset pair used everywhere is just a new house style) | Carbon motion tokens (A-38), whaleyxbt/claude-motion (exit = half the entrance), A-23 |
| 6 | The same spring with overshoot on every arrival | Bounce only for things with momentum; weight comes from timing | **Damping 1.0 (no overshoot) by default.** Overshoot only for objects that are thrown, dropped or released, damping 0.75 to 0.85, **2 events per film at most**. Tie frequency to mass: light objects 3 to 4 Hz, heavy ones 1 to 1.5 Hz. Type and UI never overshoot | Apple Designing Fluid Interfaces, via Emil Kowalski's apple-design skill (A-39); Disney "Timing" (A-36) |
| 7 | A camera that never rests (Hermite drift, a push on every beat, zoom to fill) | Locked-off frames are a decision; camera moves carry meaning | Her #45 asked for a camera that never rests; that is now the tell. Keep the moving camera for the act that earns it, and hold **at least 30% of the runtime on a locked camera with zero drift**, with the motion carried by the objects. One motivated move per section at most. A move behaves like a physical rig (a dolly with inertia, a rack focus, or handheld noise of 0.3 to 0.6 px at 4 to 8 Hz), never an always-on spline drift | A-22 #5, A-06 (camera language), Murch "eye-trace" (A-37) |
| 8 | The same container-morph continuous take in every film | Choose the transition family per film; cut on emotion and story | **One transition family per film**, and never the same family in consecutive films. Her "one thing blending into other" stands, so the blend stays but changes kind: <br>- a container morph (rested for now); <br>- a match cut on shape; <br>- a medium swap (the same scene in a new material); <br>- a focus pull; <br>- light passing; <br>- a material transform (ink bleed, paper fold, a print run). <br>Hard cuts on the bar only when the card picks them | A-07 (flip the loudest trait), A-11 ("cut, don't fade"), Murch (A-37) |
| 9 | Something on every beat, 78 to 89% of frames moving, at one even density | Stillness is punctuation; one thing moves at a time | Keep the energy she asks for, but make it uneven: <br>- density rises and falls by act (about 40% moving in the setup, 85% in the payoff), about **55 to 75% overall**; <br>- **2 or more deliberate holds of 0.8 to 1.5 s** before the end card; <br>- one primary motion at a time; secondary motion travels no more than 20% of the primary's distance. <br>For calibration, the X benchmark in lessons §3.6 measured reels at 80 to 100% and explainers at 42 to 45% | A-17, A-19, Disney "Staging" and "Secondary action" (A-36) |
| 10 | 8-beat sections, identical caption timing, drop at beat 16 | Editors cut to emotion and story first, rhythm third | **No two consecutive sections the same length.** At least one odd-length section (5, 7 or 11 beats). One full silence of 0.5 s or more. Caption timings come from the picture, not from the bar | Murch's Rule of Six (A-37) |
| 11 | The drop package: crash, boom, rings, punch, shake, whip | One impact, designed for this film | **One impact event per film at most**, using a device not seen in the last 3 films (log it). Silence, a cut to black, or one recorded sound all count | A-07 |
| 12 | The lattice pulsing to the beat; rings on every hit | Decorative ambient motion is a known slop tell | **The ground never pulses to the music.** It reacts to 2 story events at most | A-19 (pulse on every card) |
| 13 | Scrambled text; typed code with one key sound per letter | Scramble is a stock component; use it as an accent | **One scramble or typing effect per film at most.** Real typing gets human jitter (40 to 120 ms per key, pauses at word breaks). Otherwise show the finished line | A-28 |
| 14 | The ending: survivor, mark from dots, wordmark wipe, chip, 1.25 to 1.4 s still | Rotate the ending device; the lockup stays official | **Never the same ending device as either of the last 2 films** (`anti-house-style.md` §5). The mark never assembles from dots or particles in consecutive films. Ending under 2.5 s | A-07, `anti-house-style.md` |
| 15 | Frame 0 is the subject recalled out of the lattice | Vary the hook | Rotate the hook type: <br>- a close-up of texture; <br>- a real sound first; <br>- a question; <br>- a mid-action frame; <br>- a cold open on the result. <br>Never the lattice recall twice in a row | A-12 ("the first 2 seconds carry the hook") |
| 16 | Blue 600, lattice and grid as full-frame ground in film after film | The ground is part of the concept, chosen per film | The blue field, lattice and grid as the main ground in **1 of any 3 films at most**, and for **50% of that film's runtime at most**. Otherwise dither treats a subject (a photo, a sculpture, a print), never the wallpaper | A-25, A-26, A-27 |
| 17 | Paper on blue with gold accents every time | Colour is planned as an arc across the film | Write a **5-panel colour script** before the first still. At least one act in a different value key (near-black, paper, or a mid-tone). Gold only when the card asks for it | Pixar colour scripts (A-40) |
| 18 | Machine-perfect vectors, centred and symmetric frames | Keep imperfection on purpose; break symmetry | Choose **one imperfection layer per film:** <br>- film grain at 2 to 4% luma, held at 24 fps; <br>- print misregistration of 1 to 3 px; <br>- line boil at 8 to 12 fps with 0.5 to 1.5 px jitter; <br>- paper texture; <br>- lens falloff. <br>**At least half the key frames asymmetric** (subject on a third, or cropped by the frame) | A-27 (Figma), A-08 (wobble, grain), Spider-Verse (A-35), Disney on "twins" (A-36) |
| 19 | Everything at a smooth 60 fps with blur | Stepped timing reads hand-made; blur only where a camera would make it | In **at least 1 of every 3 films**, animate the main elements on twos (12 fps) or threes (8 fps) with the camera on ones. Use smears or shifted copies instead of blur on stepped elements | Spider-Verse (A-35); Jake Moran's vox pack (A-06) |
| 20 | One GarageBand pack, minor keys, 140 to 164 BPM, one arrangement template, Kenney clicks | Sound designers record real sources and build the sound from the picture's own world | **Rotate genre and tempo band** (under 100, 100 to 130, over 130) so no two consecutive films share either. **At least half the SFX come from the film's own material** (recorded foley, or a physical model of the object). No riser-then-crash at the same structural point in consecutive films. Rest the "01 Hip Hop" pack for 3 films. Note the Content ID risk for any loop | Ben Burtt's method (A-41); A-32 |
| 21 | Synthetic voiceover (Kokoro) | A human read, or no voice | She chose Kokoro `af_bella` for the console series (lessons #93), so this is a flag, not a ban. Offer a human read (hers or a teammate's) as the premium option for flagship films. If Bella stays, keep the researched pause conform and don't put the same synthetic voice on every series | A-22 (#11, #12); lessons §2.7 (the pack's older rule: her own voice) |
| 22 | A drawn cursor with click ripples and a zoom on every UI action | Real UI, shown only as much as the story needs | A cursor only for an action that matters, **3 clicks per film at most, no ripples**. Show the slice of UI the story needs, enlarged (Jake Moran uses about 1.8x), on a clean ground | A-06, A-03 (the cursor is part of the viral recipe) |
| 23 | Invented data and round numbers (40%, 10x) | Real numbers make it look made for this product | Every number on screen is measured and sourced (a source line under it), or labelled "example". Prefer the precise figure to a rounded one | A-14, A-15, A-19 |
| 24 | Model-drawn pixel-art props (house, dog, kite) | Claude animates well and draws less well; use real assets | Hero imagery is the brand's own asset, real photography or footage treated in the engine, or drawn to a named style reference (an artist, a print process). **6 generic icons per film at most** | A-14, A-15 |
| 25 | Copy tics: claim plus qualifier, a repeated closing line, brace verbs | Write copy last, from the picture | No closing line reused in consecutive films. Vary the register per film: one word, a question, one full sentence, or none. Brace verbs only if the anchor is code | her rule: "dont make it same like before" (lessons #92) |
| 26 | Same format: 18 to 22 s, 16:9, 60 fps, 4K | Format is a creative choice | Rotate the aspect (16:9, 4:5, 1:1, 9:16, letterboxed 2.39:1) and the length band (a loop of 10 s or less, 15 to 25 s, 45 to 60 s) across films | A-07 (the 90-day check) |
| 27 | The engine copied forward with its constants | Each film gets its own motion module | Never copy `lib.swift`'s spring and easing constants into a new film. Derive them from the style card (rule 5). Shared code is fine for drawing and encoding, never for feel | §1.2 evidence |

### 3.2 Process antidotes (stop the watermark coming back)

1. **Name the defaults, then ban them by name (Anthropic's method, A-01).** Render the first still. List which defaults it used (labels, ground, type entrance, curve, camera, ending). Add each to the film's ban list and render again. "Make it not look AI" does not work; named bans do.
2. **Recipe-distance check (new).** Count how many of the 12 moves in §1.1 the film uses. **Four at most.** The current films use 8 to 10.
3. **Logo-off test (my proposal).** Hide the lockup. If a viewer could guess "Claude made this" from frame 0 to 3 s, change the hook, the ground or the type voice. Ask a fresh critic subagent with only the frames: "which defaults of AI-made motion do you see?"
4. **The 90-day check (A-07).** Before building, list what the feed (her X timeline, the Claude motion galleries) showed this month, and do the opposite of the loudest trait.
5. **Effort where it counts.** The films that stand out took hours and several critique rounds: LexnLin about 8 hours (A-09), Raphaël Aubry's launch film 5 versions (A-05), Jake Moran 5 prompt iterations plus stills (A-06). Budget the time for the look, not only for accuracy.

### 3.3 What this lane adds to `anti-house-style.md`

The style card, the style log, the ending rotation and the brand guard are already there. Add:
- the Opus default ban list from A-01, by name: numbered `01/02/03` labels, monospace labels, off-white grounds, italic accent words, pill buttons;
- the recipe-distance check (4 of 12 at most);
- the numeric rules from §3.1:
  - text event budget (rule 1);
  - motion classes (5);
  - spring policy (6);
  - locked-camera share (7);
  - motion % band (9);
  - section-length variety (10);
  - one impact (11);
  - no beat-pulsing ground (12);
  - stepped timing in 1 of 3 films (19);
  - SFX from the film's own material (20);
- the 5-panel colour script as a required field next to "palette roles".

### 3.4 Creators and studios whose code-made or AI-assisted motion does not look generic

| Who | Link(s) | What they make | Why it does not look generic | What to take |
|---|---|---|---|---|
| **DIA Studio** (Mitch Paone, Meg Donohoe) | https://dia.tv/ ; https://www.itsnicethat.com/features/dia-mitch-paone-meg-donohoe-graphic-design-animation-typography-180918 ; https://www.creativereview.co.uk/dia-agency-typography-motion-design/ | Kinetic identities and type systems, often driven by custom generative tools built per project (Adidas London, A-Trak, Bespoke) | Each brand gets its own motion rules and tools, not presets. Paone, a jazz pianist, designs with tempo, arrangement and rhythm as the system | Design the motion behaviour as part of the brand per film. Let the music's structure, not a fixed bar grid, set the type's rhythm |
| **Universal Everything** (Matt Pyke) | https://www.universaleverything.com/ ; https://www.stashmedia.tv/universal-everything-merges-ai-and-typography-for-freefarm-lifecycles-music-video/ | Procedural and AI-assisted moving image. The Freefarm "Lifecycles" lyric video (2023) mixes traditional animation and generative AI in a custom pipeline | A bespoke pipeline under human creative direction. The aim was surprise while keeping type legible, with imagery tied to the track's theme, texture and sound. The studio avoids repeating its past work | AI and code as one stage in a directed pipeline; texture and type both drawn from the sound |
| **Figma Brand Studio**, Config 2026 identity | https://www.figma.com/blog/the-visual-identity-behind-config-2026/ | Texture tools built with Figma Make (scribbly lines, blurred gradients, oval particles), a dithering tool for portraits, deliberately rough glyphs, collage-like motion | Imperfection kept on purpose. Motion and stills designed in parallel. Three textures and human selection, not one effect | One imperfection layer per film (§3.1 rule 18); design stills and motion together |
| **Jake Moran** (HeyGen), Lenny's Product Pass film | https://x.com/jake11moran/status/2084382572898070964 | A Fable plus HyperFrames launch film built from paper-craft props, handwritten captions and postcards | An anchor from outside tech (stationery), elements stepped at 12 fps over a smooth camera, real UI only. Caveat: he also reuses scenes across launches | Stepped timing over a smooth camera; a prop with a two-word role per feature |
| **Raphaël Aubry** (Howseen), "Baguette Pro" | https://x.com/RaphaelAubryy/status/2104178266990858739 ; https://github.com/howseen-ai/claude-motion-design | An Apple-keynote launch grammar applied to a baguette; a paper-zine K-pop remake | Genre transplant: a famous grammar hands the model a full set of decisions. References used for structure, never content. Caveat: the same spring and blur recipe underneath | Pick one grammar from outside tech per film (a keynote, a museum audio guide, a weather report) |
| **3Blue1Brown** (Grant Sanderson, Manim) | https://www.3blue1brown.com/faq/ ; https://github.com/3b1b/manim | Code-made maths explainers in his own engine | He wrote the tool, writes custom code for each new idea, and makes every movement deliberate, supporting the narration rather than competing with it. Caveat: the 3b1b look is now a packaged AI skill (A-29), so copying the look without the reasoning goes generic | Motion = the mechanism. Each transformation should be the explanation itself (forgetting is a morph only because the fact really steps aside) |
| **Zach Lieberman** | https://zachlieberman.medium.com/daily-sketches-2016-28586d8f008e ; https://ocula.com/art-galleries/unit-london/exhibitions/zach-lieberman-tbc/ | Daily code sketches since 2016 (blobs, circles, ripples); co-creator of openFrameworks | Personal tools, deliberate randomness in simple geometry, a loose "funky" movement, and a daily practice that keeps the language evolving | Add controlled randomness (per-element jitter, seeded variation) so nothing moves in lockstep |
| **Sony Pictures Imageworks**, *Spider-Man: Into the Spider-Verse* | https://www.creativebloq.com/features/how-into-the-spider-verse-got-its-mind-blowing-look | CG made to look hand-made | It rejected CG's defaults: characters on twos with the camera on ones, "shifting" copies and smears instead of realistic blur, halftone and offset print colour | The most direct lesson for code-made motion: step the timing, replace blur with drawn smears, add print texture |
| **EPTA Studios** (Filippo Carnevale) | https://x.com/filippocarnvl/status/2098112186573082702 | An 18 s text-led launch film (ASCII look, unusual soundtrack) and launches built from film, TV and infomercial grammars | They choose the format against the feed: the parking lot, flip the loudest trait, the 90-day check | Run the 90-day check before every film |
| **Tim Rodenbröker** | https://machen.bauhaus-dessau.de/sharingbauhaus/bauhaus-101 ; https://www.slanted.de/?p=555270 | Creative-coding educator; a "Programming Posters" course built on 40+ generative systems; an ECAL typography workshop "in a strict visual system" | A new system is designed for each piece, under strict typographic rules, rather than effects on top of a template | Build one small generative system per film (a type grid that distorts, a rule-based layout), not a library of effects |

---

## 4. Top 20 tells to kill (ranked)

Ranked by how fast a viewer spots it (the first 3 s first) and how often it appears in my films. Each has a check that can run on the stills or the code.

1. [ ] **Letter-by-letter mask rise on every line in a bottom band.** Check: one per-letter stagger per film at most; no `BAND_Y` band unless there is a voiceover.
2. [ ] **Mono uppercase `01 · SECTION` labels with big section numbers and a HUD.** Check: grep the film for `"0[1-9] ·"`, which should find nothing unless the labels are part of the world.
3. [ ] **The same container-morph continuous take in every film.** Check: the transition family differs from the last film's row in `style-log.md`; the blend changes kind (§3.1 rule 8).
4. [ ] **Spring overshoot on every arrival (2.4 Hz, damping 0.62).** Check: overshoot events per film, 2 at most, only on objects with momentum.
5. [ ] **Something on every beat at one even density (78 to 89% moving).** Check: density varies by act; about 55 to 75% overall; 2 or more holds of 0.8 to 1.5 s.
6. [ ] **A camera that never rests (drift, a push per beat, zoom to fill).** Check: at least 30% of the runtime at zero camera velocity.
7. [ ] **The same ending (mark from dots, wordmark wipe, chip, still).** Check: the ending device differs from the last 2 rows of `style-log.md`.
8. [ ] **Blue 600, lattice and + grid as the full-frame ground.** Check: in 1 of the last 3 films at most, and for 50% of the runtime at most.
9. [ ] **The drop package (crash, boom, shockwave rings, punch, shake, whip).** Check: one impact event, with a device new to the log.
10. [ ] **The "01 Hip Hop" Apple Loops sound and its arrangement template.** Check: genre, tempo band and pack differ from the last film; at least half the SFX come from the film's own material.
11. [ ] **Scrambled text and typed code with per-key clicks.** Check: one such effect at most.
12. [ ] **A lattice pulse on the beat, and rings on every hit.** Check: `latticePulse` returns 0; the ground reacts to 2 story events at most.
13. [ ] **Stock easing presets on every object.** Check: 3 to 4 motion classes, each with its own curve, none copied from the last film.
14. [ ] **8-beat sections with identical caption timing.** Check: no two consecutive sections the same length; one silence of 0.5 s or more.
15. [ ] **Claim-plus-qualifier copy, a repeated closing line, brace verbs.** Check: closing line not in the last 2 films; register chosen on the card.
16. [ ] **Paper on blue with gold leads.** Check: a 5-panel colour script exists; one act in a different value key.
17. [ ] **Model-drawn pixel-art props and icons.** Check: hero imagery is a brand asset, real footage or photography, or drawn to a named style reference.
18. [ ] **Machine-perfect, centred, symmetric frames with no grain.** Check: one imperfection layer; at least half the key frames asymmetric.
19. [ ] **A drawn cursor with ripples, and a zoom on every UI action.** Check: 3 clicks per film at most, no ripples.
20. [ ] **Synthetic voiceover and round-number claims on published films.** Check: a human read was offered for flagship films (Bella stays where she chose it, #93); every number sourced or labelled "example".

---

## 5. Variation matrix

Rule: when writing a film's style card, **no more than 2 of these 11 dimensions may repeat any of the last 3 films** (stricter than today's 2 of 9, because the matrix has more dimensions). The extra dimensions after the table (hook, frame rate, format) rotate freely.

| Dimension | Options (pick one per film) | Used recently (avoid next) |
|---|---|---|
| **Concept or metaphor** | a physical machine (anatomy-style); a museum or gallery; a print run (receipt, letterpress, riso); a weather map or forecast; a train timetable or departure board; a laboratory specimen; a theatre programme; a field guide; a courtroom exhibit; a recipe card | a memory board (forgetting); a head or brain (learner); a morphing container (local); a vector console (console); a gallery with Klein blue, Varini and Kusama (media reel v1) |
| **Ground or surface** | paper with real texture; near-black; a mid-tone grey or brand-tinted paper; a 3D raymarched room; treated photography or footage; a printed sheet; a projection on a wall | blue 600 with lattice and grid (learner, forgetting, local); the field film plate (console, one command, namespaces) |
| **Type system** | Geist set huge and cropped (6x scale contrast); an editorial serif accent; pixel type grown from the lattice; type as image (glyph fields); stencil or stamped type; hand lettering; no type | Geist mask rise with mono labels (all four) |
| **Layout or grid** | full-bleed single subject; an asymmetric editorial column; a split screen; a broken grid where the subject crops the frame; a diagram plate with leader lines; a centred icon only for the payoff | bottom band with HUD and + grid (learner, forgetting, local); the 16:9 explainer frame |
| **Colour strategy** | monochrome with blue held back for the payoff; two-ink riso (blue plus one); a grade as the act break (warm to brand blue); paper and ink with a blue stamp; a night palette with one lit blue | paper on blue with gold (learner, forgetting, local) |
| **Camera language** | locked tripod with cuts; one log-space dolly; rack focus between planes; handheld with inertia; top-down table shot; a slow orbit (turntable) | Hermite drift with pushes, punches and whips (learner, forgetting, local) |
| **Transition family** | hard cuts on the bar; match cuts; a medium swap (the same scene re-rendered in a new material); light passing (a sweep or projector); a page curl or physical reveal; a morph (rested for now) | morph chains, flood and shrink, gather (learner, forgetting, local); medium swaps (media reel v1) |
| **Texture** | film grain at 24 fps; print misregistration; line boil; paper fibre; halftone on a subject only; lens falloff; none (deliberately clinical, used rarely) | machine-perfect dither everywhere (all four) |
| **Rhythm and editing** | stepped on twos with a smooth camera; long holds with one sharp event; irregular section lengths with a silence; rubato (picture leads, music follows); fast cut montage of 0.2 to 0.4 s shots; a single take with only 3 events | 8-beat sections, an event on every beat (all four) |
| **Sound palette** | recorded foley of the anchor's material (paper, ink, glass); a solo instrument; ambient room tone with one musical sting; chillwave or ambient below 100 BPM; indie disco at 125; silence with diegetic sound only; a human voiceover | "01 Hip Hop" Apple Loops at 140 to 164 BPM (learner, forgetting, local); Chillwave Chill Melody at 100 BPM (media reel v1) |
| **Ending** | anamorphic alignment; defocus under the lockup; return to frame 0 (loop); a light reveal; the last print; type resolves; through a window or reflection; a cut to black, then the lockup | mark from dots and wordmark wipe (learner, forgetting, local); anamorphic alignment (media reel v1) |

**Also rotate (free):**
- **Hook:** texture close-up, sound first, a question, mid-action, the result first.
- **Frame rate:** 60 smooth; 24 filmic; on twos; mixed.
- **Format:** 16:9; 4:5; 1:1; 9:16; 2.39:1.

---

## 6. Evidence ledger

Status key: **V** read in full at the source on 2026-10-15; **P** read at the source, the claim is the author's own (self-reported); **S** secondary summary only; **R** repo file read directly.

| ID | Claim used here | Source | Date | Status |
|---|---|---|---|---|
| R-01 | `lib.swift` byte-identical in three films; the same `spring(2.4, 0.62)` and the `ease`/`eout` preset pair in six films (the third preset, `einout`, in three) | `md5` and `grep` on the files in §1.2 | 2026-10-15 | R |
| R-02 | Caption band, riseText, grid, labels, numbers, brace verbs, lattice pulse, punch, shake, whip and waves at the stated lines | the `.swift` files cited in §1.3 | 2026-10-15 | R |
| R-03 | Beats, motion %, endings, sound kits and arrangement | the six film READMEs; `motion-systems.md` §4; `score_forget.swift` | 2026-10-15 | R |
| R-04 | The motion grammar was adopted from the rossaxbt/twoclipping templates | `motion-grammar.md` sources and §1 to §4; SKILL §1(f) | 2026-10-15 | R |
| A-01 | Opus 5.5 frontend defaults (numbered labels, mono labels, off-white grounds, italic accents, pill buttons); naming bans works better than "avoid a generic look" | platform.claude.com, *Prompting Claude Opus 5.5* | read 2026-10-15 | V |
| A-02, A-03 | The @twoclipping prompts' moves, banned lists and counts | api.fxtwitter.com mirror of the two posts | 2026-09-24 and 26 | P |
| A-04 | Rexan Wong's default look and workflow | fxtwitter mirror | 2026-09-26 | P |
| A-05 | Raphaël Aubry's harness article and repo | fxtwitter mirror; github README | 2026-09-28 | P |
| A-06 | Jake Moran's motion-doctrine, cut-the-curve, the vox pack at 12 fps, the real-UI rule, the 0.7x note, 380+ blocks | fxtwitter mirror of both posts and the article | 2026-08-03 and 09-23 | P |
| A-07 | EPTA: formats die once copied; parking lot; outside tech; flip the loudest trait; 90-day check | fxtwitter mirror; youmind.com repost | 2026-09-10 | P |
| A-08 | @leo_xiaolei's look brief and avoid list | fxtwitter mirror | 2026-09-23 | P |
| A-09 | LexnLin's 33 s film, about 8 hours, one prompt | fxtwitter mirror | 2026-09-27 | P |
| A-10 | r/MotionDesign "beginner-level, no keyframes" | DEV Community article (the thread itself not read) | Oct 12 | S |
| A-11 | snapcn's default spec and fixes | snapcn.dev | 2026-10-01 | V |
| A-12 | 0xMovez on "brief contagion" and its banned list | movez.substack.com | 2026-10-04 | V |
| A-13 | Grow With AI's tells | growwithaiguide.substack.com | 2026-09-30 | V |
| A-14 | Charlie Hills's three tells | free section of his Substack (the full fixes are paywalled) | 2026 | V (partial) |
| A-15 | Jack Roberts's 99% claim, fonts | LongCut transcript page | undated | S |
| A-16 | Moe Lueker's 80% plateau | moelueker.com | 2026-09-12 | V |
| A-17 | Creative Boom's ten tired trends | creativeboom.com | 2026-04-21 | V |
| A-18 | The New Yorker's "Claude aesthetic" | letsdatascience summary (original not read) | 2026-06-30 summary | S |
| A-19 | The slop-fingerprint wiki (Geist named, a pulse on every card, round numbers) | GitHub wiki | 2026-05-24 | V |
| A-20 | Sailop's fade-up figure (illustrative per its own note) | sailop.com | 2026-04-22 | V (the figure is unverifiable) |
| A-21 | 925 Studios: defaults, "not choices" | 925studios.co | 2026 | V (vendor) |
| A-22 | Opus Pro's 12 tells (#5, #11, #12) | opus.pro | 2026-04-17 | V (vendor) |
| A-23 | VisionLabs: specify easing mathematically | visionlabs.studio | 2026-06-02 | V |
| A-24 | Latent Space: "mid" one-prompt video | latent.space | 2026-09-29 | V |
| A-25 | MengTo's dither skill, 1.3K installs, first seen 2026-05-11 | skills.sh | read 2026-10-15 | V (counts change) |
| A-26 | Other dither skills and components | search results only | 2026 | S |
| A-27 | Figma Config 2026: dithering tool, imperfection, parallel motion | figma.com/blog | 2026-07-27 | V |
| A-28 | Scramble as a stock component; one-per-page caps | search results (Framer, 21st.dev, Calgary design system) | 2026 | S |
| A-29 | A 3b1b-style animation skill exists | search result (jsdelivr README) | 2026 | S |
| A-30 | The Claude Motion beta on Oct 8, built on one template | secondary news coverage | 2026-10-08 | S |
| A-31 | HyperFrames blocks; remotion-templates | A-06; search result | 2026 | P/S |
| A-32 | GarageBand loops spotted by listeners; Content ID claims | TidBITS (citing Rolling Stone); Apple Community | 2019; 2023 | S |
| A-35 | Spider-Verse: twos and ones, shifting and smears instead of blur, print texture | creativebloq and a sessions.edu summary (search) | 2018 to 2023 | S |
| A-36 | Disney's 12 principles (timing, arcs, staging, secondary action, "twins") | Wikipedia, citing Johnston and Thomas 1981 | read 2026-10-15 | V |
| A-37 | Murch's Rule of Six (emotion 51, story 23, rhythm 10, eye-trace 7, 2D 5, 3D 4) | secondary write-ups (nofilmschool and others); book not read | 1995 book | S |
| A-38 | Carbon motion tokens (productive and expressive curves; 70 to 700 ms durations) | carbondesignsystem.com | read 2026-10-15 | V |
| A-39 | Apple's fluid interfaces: no bounce by default, bounce with momentum (damping about 0.8) | Emil Kowalski's apple-design skill pages, citing WWDC18 session 803; Apple transcript not checked | 2018 talk | S |
| A-40 | Pixar colour scripts (Eggleston, Toy Story) | Hyperallergic, MoMA audio guide (search) | 2020 to 2022 | S |
| A-41 | Ben Burtt built sounds from real recordings (projector hum plus TV buzz, swept mic for the Doppler) | DIY Photography, Mental Floss, nofilmschool (search) | various | S |
| A-42 | Creators' facts (DIA, Universal Everything, 3b1b FAQ, Lieberman, Rodenbröker) | the links in §3.4 (3b1b FAQ and Stash read directly; the rest via search summaries) | various | V/S |
| A-43 | `(0.2, 0, 0, 1)` = Material 3 standard; `(0.22, 1, 0.36, 1)` = ease-out-quint; `(0.65, 0, 0.35, 1)` = ease-in-out-cubic | Flutter and M3 token references and the `tailwindcss-easing` package, via search (the official M3 page did not render) | 2026-10-15 | S |

Caveat (time-sensitive): view, bookmark and install counts are as read on 2026-10-15 and will change.

---

## 7. Confidence and gaps

- **High confidence:** the repo diagnosis (§1, read from the code); Anthropic's named defaults (A-01); the recipe lineage (A-02, A-03 against `motion-grammar.md`).
- **Medium:** the general tell lists (§2.2). They agree across many independent posts, but several are vendors, and none measures prevalence.
- **Low:** any prevalence number (Sailop's 83%, Jack Roberts's 99%). Do not quote them.
- **Gaps:**
  - No sound-design source on AI tells beyond voice cadence (A-22) and her own whoosh verdict.
  - The @rossaxbt originals were unreachable.
  - Lane B (studio craft) should supply the parameter-level technique atlas for the antidotes marked S here: stepping, smears, line boil, grading.
