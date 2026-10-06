# Prompting, storyboards and director notes

How to brief yourself, the user's prompt, or subagents so the result looks directed rather than generated. Quotes are short and attributed; everything else is paraphrased. Prompt originals live at the linked URLs.

## 1. Why setup matters more than wording

- **Grounding.** The same bare prompt gives very different results depending on what surrounds it. One audit treats five things as independent variables: turn count, prompt length, pre-existing assets, tool restrictions and autonomy budget. A one-liner inside a rich project folder is not comparable to a one-liner in an empty one (https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/prompt-matrix.zh-CN.md).
- **The bare prompt, tested.** Hamza Khalid ran a viral prompt as-is with no setup. The character's head floated with no body, and the text colour fought the background (https://x.com/humzaakhalid/status/2105203643758895454).
- **Grounding lines.** In gallery ranks 49-64, each post that reused the generic showreel prompt (49, 52, 56, 60, 61) added one grounding line:
  - pointing at the project folder (https://x.com/thayto_dev/status/2104200591278739735)
  - "Research <product>" first (https://x.com/itisRazak/status/2103517930424332386)
  - use the actual screenshots, logo and assets (https://x.com/HO_BA/status/2103845264649761062)
  - live data fetched through an MCP (https://x.com/robj3d3/status/2103949734520279060)
- **The environment.** The model uses tools that are present even when not asked to. A Blender MCP and a sample library on the machine led to a 3D section and beat-sequenced audio (https://x.com/shneural/status/2103151003272962130).

## 2. Prompt anatomy (the high-performing shape)

The most-bookmarked prompt in the guanmo catalog (19.3k bookmarks) uses tagged sections (https://raw.githubusercontent.com/guanmo-ai/awesome-ai-motion/HEAD/prompts/2103273003555402193.txt, https://x.com/twoclipping/status/2103273003555402193). Use the same shape for your own brief or for a subagent:

| Section | What goes in it |
|---|---|
| `<inputs>` | What the agent must ask for before building: the UI states (8-12), brand colours and fonts, real data, owned footage, a licensed song of about 120 BPM. For an ad: the product name, a one-line promise, 3-5 UI moments, owned clips. |
| `<direction>` | Reference tier (for example "Dribbble-level UI motion" or "high-end minimal"), one UI font, motion feel (springs with only a tiny overshoot), camera behaviour (zoom so each state fills the frame), and an explicit **Banned:** list. |
| `<structure>` | BPM and bar count (for example 120 BPM by 7 bars), then an arrow-chained state list (button → loader → check → ... → back to button) or a bar-by-bar shot list. |
| `<build>` | Engineering rules: one file at a fixed size, every style computed from time in `seek(t)`, closed-form springs, beat grid from analysis, footage as frame sequences, subframe motion blur, SFX placed by measured peak, -14 LUFS, a contact-sheet preview before the full render. |
| `<gotchas>` | Known traps for this renderer (see `qa.md`). |
| `<start>` | Ask for the inputs, then show the state list or storyboard **on the beat grid** before writing any code. |

verbove's MakerMap prompt is the most transferable product-explainer template in the gallery (https://x.com/verbove/status/2103483957266268381). Its sections:

1. **Inputs.** Product and URL, 8-12 UI states, the real data in each state, brand colours, fonts and accent, and the output formats.
2. **Rules.**
   - One HTML file, one canvas, one `draw(t)`.
   - No CSS transitions, no timers, no carried state.
   - One shape that is never cut: it changes size, radius and colour while its content swaps.
   - A cursor drives every change with real clicks, typing and one drag.
   - "Real UI. Real data. No placeholders."
3. **Structure.** A 120 BPM grid with something on every beat, and a state chain that starts and ends on the logo.
4. **Motion.**
   - Summed closed-form springs.
   - Content enters after its container starts morphing and leaves before the next morph.
   - A short blur on transitions.
   - Never fade black straight into the accent; move an accent element between states instead.
   - The last frame equals the first.
5. **Export.** A one-frame-per-beat contact sheet first, then 60 fps with 6 subframes averaged, H.264 yuv420p, every aspect ratio in parallel.

## 3. The inputs-first handshake

Open every new video by asking, in one message, for what you cannot invent:
- **Goal.** Purpose, audience, the one takeaway, where it will be posted.
- **Format.** Duration, aspect ratio(s), fps. Observed defaults: in guanmo's 421 catalogued cases the median length is about 42 s and 16:9 covers 282 (aspect inferred from cover sizes; computed from https://raw.githubusercontent.com/guanmo-ai/awesome-ai-motion/HEAD/data/cases.json). athemeroy's audit finds a 39.2 s median over 1,401 files, with educational explainers longest at a median of about 102 s (https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/statistics.md). 15 s showreels and 30 s promos are common.
- **Product.** The repo, URL or docs, and which 2-3 features or which version range. Scope must fit the length: 15 s cannot carry many updates (https://x.com/SebastianRoehl/status/2103912457836323096).
- **Brand.** Logo file, colours, fonts, real screenshots or UI states, real numbers.
- **Sound.** Music (own track, licensed track, or synthesised in code), SFX (the user's library, a CC0 pack whose licence they confirm, or none), voiceover, and whether sound matters at all.
- **References.** One or two reference videos.
- **Limits.** What must never be claimed, plus deadline and budget.

Then show a beat map and a few key stills for approval before the full build. twoclipping asks for 4 stills (https://x.com/twoclipping/status/2103835273813496100). @makwired's skill flow: ask for the audio, listen, propose a director plan, wait for approval, then write code (athemeroy cases.csv).

## 4. Direction and variants

- **Three variants.** Ask for three storyboard variants so the user picks a direction instead of fixing the first idea (https://x.com/rexan_wong/status/2103707054108299437).
- **Three directions that really differ.** guizang's version: three directions that differ on at least three axes (ground and light, type voice, motif source, camera language, transitions, rhythm, sound). Pick one with reasons. Then list 3-5 signature devices, each written as "because the product has X, use Y"; drop any device without an X (https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/references/direction.md).
- **A frame spec in numbers.** Aspect, fps, background, safe area (guizang avoids the bottom ~13%), type ladder, UI magnification (about 22 divided by the product's body px), and the motion you will *not* use. guizang's case study found that quality came from writing this spec and a per-second shot list before code, not from metric checklists (https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/references/case-study.md).
- **One concept.** Build one concept, not a slideshow. Carry one motif through every seam: the logo becomes the product UI, and a relay object (a red "now" dot) never leaves the screen (https://github.com/Leonxlnx/claude-launchvideo).

## 5. Storyboard formats

Pick the one that fits the job. Every format gives each shot a time window, an event, an end state and a transition out.

**Launch or business film** (motion-video-kit, https://raw.githubusercontent.com/echris6/motion-video-kit/HEAD/business-motion-film/references/motion-grammar.md):

| Time | What the viewer sees | The beat's job | Transition out (which object survives) |
|---|---|---|---|

- **Density:** 12-15 distinct compositions per 30 s, beats of 1.4-3.5 s, and scale varied (macro → wide → overhead → UI close-up → type impact).
- **Framing:** the lead subject fills 60-85% of the usable frame in feature beats.
- **Rhythm:** each beat lands readably, then exits accelerating.
- **Signature moves:** name three signature transformations without using effect names.
- Send the storyboard itself to a critic before building.

**Product film, per second** (guizang):
- Each row holds the time, one protagonist, the picture and action with sub-beat times, the on-screen copy and the sound.
- Every shot has at least one state change or camera move. A fully static stretch over 2.5 s is allowed only for reading.
- Pacing for 45-60 s: opening 2-4 s, each core capability 7-12 s, small improvements 2-4 s each, close 2-3 s. Actions take 0.25-0.6 s. Show captions early so reading overlaps the demo (https://raw.githubusercontent.com/op7418/guizang-product-video-skill/HEAD/references/story-and-copy.md).

**Character or story piece** (ClaudeAnimationBase "reads", https://github.com/JohnHeibel/ClaudeAnimationBase/blob/main/ANIMATION_GUIDE.md):
- Write a logline, a world (palette and colour arc), a motif and an emotional arc.
- Each shot gets its time, the transition in, what is seen, the EVENT, the reaction and the camera.
- Under each shot list the timed **reads**, the things the viewer must understand, in order. "The reads are the timing sheet." Give each read time to be found, understood and registered: "Fast actions, slow meanings." The demo's ending was first packed into about 1.3 s and nobody could tell what happened.

**Music video** (https://github.com/JohnHeibel/PDoomVideo/blob/main/STORYBOARD.md):
- One table per chapter: `| Time | Lyric | Shot | Out |`. The Out column names the motivated transition into the next shot.
- A palette arc across chapters, and an ending that rhymes with the opening.

**Beat sheet** (claude-animation-skill, https://raw.githubusercontent.com/buildwithhanif/claude-animation-skill/HEAD/plugins/claude-animation/skills/claude-animation/templates/beat-sheet.md):
- Each beat gets a start, a duration, what the viewer notices, action → end state, camera (even "locked"), exposure and a sound cue time.
- A row with no end state is not a beat.

**Narrated explainer** (Austerlitz and athemeroy):
- List the factual claims and their sources first.
- Write the script as beats.
- Measure the TTS duration per beat and place the shots relative to their lines.
- Generate captions from the same timeline.
- If you cannot listen to the narration, say so and flag it for a human listen (https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/prompt-playbook.zh-CN.md).

## 6. Still frame per scene, then a short test

- **One still per scene.** Ask for one still frame per scene before anything moves (rexan_wong), or render one frame per beat as a contact sheet and fix cramped states (verbove).
- **Prove the style first.** Do it on about the first 5 s before a long run. One creator reports that the first 5 s took 20 minutes before an overnight full run (https://x.com/dhruvalgolakiya/status/2102854634536866099).
- **Then the hardest stretch.** Render the hardest 2-4 s and inspect 12-24 neighbouring frames (https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/visual-effects-fit.md).

## 7. Naming a reference style

- **Name it.** Naming a style beats describing it. A reference supplies pacing, type and transitions (rexan_wong). For references, there is whatships.com, which describes itself as a free, independent directory that sells no placement (recommended without disclosure in rexan_wong's post). It offers `/llms.txt` and `/search-index.json`.
- **Style tiers seen in working prompts:** "Dribbble-level" UI motion, Apple-keynote launch film, Netflix-style documentary, polished 16-bit sprite, C64 demoscene, Another World low-poly. Mediums: line art, paper cut-out shadow theatre, claymation in Blender, hand-drawn canvas (https://raw.githubusercontent.com/guanmo-ai/awesome-ai-motion/HEAD/data/cases.json).
- **Genre transplant.** Applying a famous grammar to an unexpected product (an Apple-style launch for a baguette) gives the model a whole set of decisions on pacing, palette, type and camera (https://x.com/RaphaelAubryy/status/2104178266990858739).
- **No brand?** Name a strong style anchor. Bauhaus primitives and pixel art gave distinctive unbranded results (https://x.com/condzxyz/status/2103556754550469102, https://x.com/achxvi/status/2104294892944097513).
- **Describe the look both ways.** Give a positive brief (palette hex values, texture such as procedural paper grain, line quality such as slight wobble) and an explicit avoid list (generic SaaS illustration, AI gradients, neon, cyberpunk, stock feel) (https://x.com/leo_xiaolei/status/2102724347446305104).
- **Describe transitions as processes.** Write each transition as a physical process, not an effect name: the centre spins faster, petals peel into star particles, the hue shifts yellow to deep blue (same post).

## 8. Showreel and short-prompt templates

**The canonical showreel prompt** (paraphrased): a dynamic 15-second motion graphics video showing what an incredible motion designer you are, like a résumé showreel; go all out. It produced the top video on Max effort (https://x.com/stephanlivera/status/2103315922098470926). Its strengths are a fixed duration, a persona and maximum effort. Use it as a capability demo, not a spec.

An engineered variant adds the structure (https://x.com/darel023/status/2103424524297420829):
- a striking hook in the first second
- a sequence of distinct techniques (typography, shape play, camera moves, colour shifts)
- a clean, memorable final frame
- pacing cut to music

**With a product attached:**
- **Make the product the subject.** The showreel framing pulls the model toward showing off itself. In one creator's test, Sonnet 5.5 at max effort dropped the product name entirely (https://x.com/robj3d3/status/2104649947610239253; robj3d3 is promoting his own SuperX).
- Lead with "Research <product>" (https://x.com/ajith_io/status/2103469807375208546), point at the repo, or supply assets.
- Check that the storyboard names the product before rendering.

**Persona and constraint.** A 30 s showreel for a niche branding agency for startup founders, all graphics from scratch, at xhigh effort (https://x.com/jacksonfall/status/2103925420211229164).

**Logo reveal.** Attach the real logo and ask for a slow reveal that assembles the mark and shows it at the end (https://x.com/tdinh_me/status/2103704250329301409). Do not let the model redraw the logo. For supermemory videos the pack says never to redraw the mark; this skill reads that as also ruling out assembling it from fragments.

**Five-scene business explainer.** Role: expert motion designer. A 30 s explainer as one page with five scenes: the problem, what I do, how it works in 3 steps, one proof point, the name. Bold type, brand colours (https://x.com/alex_prompter/status/2103499977632997524). Render it deterministically rather than screen-recording a live page.

**Curator templates** (athemeroy prompt playbook, CC BY 4.0, paraphrased; https://raw.githubusercontent.com/athemeroy/awesome-claude-5-5-videos/HEAD/docs/prompt-playbook.zh-CN.md):

1. **Zero-asset code animation.**
   - Format: JS + Canvas 2D, fixed duration and aspect.
   - A 6-8 shot storyboard with times, captions and transitions; one character design and a limited palette.
   - Render a 5 s sample and check overflow, continuity and speed, then render the full film.
2. **Explainer.**
   - Claims and sources come first, captions from the same timeline as the narration.
   - Flag "narration not auditioned" when you could not listen.
3. **Product promo.**
   - Read the repo and list three capabilities that can actually be shown.
   - Five shots, one message and real UI evidence per shot.
   - A low-res preview for approval. Never invent features, user data or testimonials.
4. **3D scene.**
   - Separate building the scene from filming it.
   - Greybox and camera preview first.
   - Don't silently download unlicensed models.
5. **Opus as director with a video model as pixel source.**
   - A continuity sheet, then per-shot prompts.
   - Log the models, versions and generation counts, and disclose who generated the frames.
6. **Transforming existing footage.**
   - Probe the duration, aspect, fps, audio and subtitles, then list the invariants.
   - Check a 10 s sample before the full pass.
7. **Short trigger for an existing skill.**
   - List what programs, services and costs it will invoke.
   - Disclose the human input, the preset skill and the existing assets.

**Disclosure.** "One prompt", "pure code", "zero external assets" and "no human edits" are four separate claims. Do not let one stand in for another.

## 9. Director notes: the revision vocabulary

**Notes that work:**
- **Camera language.** "Slow every zoom to 0.7x", "hard cut here", "push in on the button". The first render is about 80% there, and vague notes like "make it better" produce random changes (https://x.com/rexan_wong/status/2103707054108299437).
- **One note at a time.** "Slower.", "More energy.", "Add a scene about pricing." (https://x.com/alex_prompter/status/2103499977632997524).
- **Numeric offsets and event anchors.** "Bring the title in 0.5 s earlier", "land the SFX on the logo-in frame", "keep the voice playing across the cut". Keep event times as named data so each note is a one-line edit. The source is a paid influencer post; the technique still applies (https://x.com/itsolelehmann/status/2102653764255551761).
- **Notes anchored in space and time.** A region on a specific frame plus an instruction. QwolfAi circled the thermal printer on a frame and wrote "Zoom here + add text: Built-in High-Speed Thermal Printer". Vendor tools call this "Mark to Fix" (sponsored, not Claude, https://x.com/QwolfAi/status/2103056860366393504). In code, ask for a frame number or timestamp and a region. A small review page that records click coordinates per frame copies the idea.
- **Small creative notes.** Human notes can stay short when the setup is good, for example: more clay, darker lighting, text over the picture, a slow fade at the end. Otherwise that creator mostly typed "continue" (@SidMenonTM, guanmo cases.json).

**Folding notes back in.** Accumulated notes can go into the next brief, as in this list:
- use the actual product screenshots, logo and assets
- motion must match the music
- like a real professional production, not a demo
- never show a screenshot raw; break it into components and icons that animate

Source: https://x.com/HO_BA/status/2103845264649761062

**Iterate on the same project; don't regenerate.** Durations, colours, copy and event times belong in data so revisions are edits.

**Self-scoring.** @MengTo had Opus score each scene component and keep improving each one until it scored at least 8/10, within the budget (guanmo cases.json). Pair it with an independent critic (`qa.md`), because the builder misses its own dead time.

## 10. Anti-patterns that make output look generic

**Default looks:**
- **The default look.** Centered text, a gradient background, everything fading in. It happens when no reference or style is named (rexan_wong).
- **Generic motion.** The most-bookmarked prompt's Banned list: bouncy easing, particle bursts, glows, gradients on chrome, RGB split, camera shake, lens flares, neon, grid floors, dead time, anything template-like (guanmo prompt 2103273003555402193).
- **Lazy transitions.** Crossfades, blur-ins, 3D flips, holds over 1 s. Scenes should morph out of the previous one: text rises from a mask line, icons pop on a spring, a black shape floods and contracts into the next scene (https://x.com/twoclipping/status/2103835273813496100).
- **Slideshow cuts.** Unrelated slide-ins, or the same entrance on every element. Make every transition a visible transformation (https://x.com/leo_xiaolei/status/2102724347446305104). Don't use the same transition more than three times in a row (guizang direction.md).

**Fake or flat content:**
- **Invented product UI.** Wrong spacing, placeholder boxes and fake buttons make the whole video read cheap (rexan_wong). Use real UI at video scale.
- **Raw screenshots.** Panning over a flat image reads as a demo (https://x.com/HO_BA/status/2103845264649761062).
- **Text overuse in character pieces.** "Models overuse text" (ClaudeAnimationBase guide). Signs and captions that repeat the story are the classic failure. Tell the joke with pictures.
- **Vague slogans.** Captions should be full sentences: subject + action + observable result (guizang story-and-copy.md).

**Timing failures:**
- **Everything at one brisk speed.** Stacked events, and reads that end before the viewer understands them (ClaudeAnimationBase guide).
- **Light-to-dark crossfades.** A long crossfade between light and dark shots turns grey. Hard-cut, or blur the subject out first (guizang).

**Process failures:**
- **Metric gaming.** A version tuned to on-beat metrics scored 29/29 yet looked cramped with tiny text. Treat metrics as hints for where to look (guizang case-study.md).
- **Trusting "one-shot" claims.** They usually hide skills, references, assets and many revisions. One 45 s film took 163 model calls and about 6h45m, self-reported (athemeroy cases.csv, @mablesjoseph).
- **Pasting keys into prompts.** One catalogued prompt contained a placeholder ElevenLabs key. Reference `.env` variable names instead (guanmo, @achxvi case).

## 11. Effort, time and model

- **Effort.** The top showreels ran on Max or xhigh. The ClaudeAnimationBase author reports that the reasoning level tracks how extravagant and detailed the scene gets. Medium still produced a 30 s product video in about 54 minutes on a Pro plan (https://x.com/shownotover/status/2104124596957933687).
- **Model.** For branded work, Opus followed the product brief where Sonnet 5.5 at max effort did not, though this is one creator's anecdote (https://x.com/robj3d3/status/2103875898349088830; robj3d3 is promoting his own SuperX). A single-creator comparison put Sonnet at about 54% of Opus's cost, close on cards, charts and 3D, weaker on ink drawing (athemeroy cases.csv, @AxtonLiu).
- **Time to budget:**
  - about 15 minutes for a 15 s showreel (https://x.com/leonabboud/status/2103576084499358051)
  - about 8 hours, 33 commits and 4 critique rounds for a branded 33 s film (https://x.com/LexnLin/status/2104148233106723099)
  - one working day for the roofing film, where API spend was not tracked (motion-video-kit case study)

  All are self-reported.
