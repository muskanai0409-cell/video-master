# What the 64 gallery videos teach

Source: the ranked gallery at https://www.revid.ai/claude-motion-graphics (64 posts, scraped 2026-10-02), plus the research notes on every rank and the repos some posts link to. The videos were not watched. Lessons come from post text, prompts, linked repos and revid's titles.

## Read this first

- **The gallery is a sales funnel.** Every card's "Use as prompt" button leads into revid's own generator. The ranking is by likes and includes ads and competing tools.
- **Not all of it is Claude.** 15 of the 64 were made with other tools (ranks 12, 34, 36, 38, 40, 41, 42, 45, 46, 48, 51, 54, 57, 63, 64). Four more route Claude through a third-party product (9, 17, 33, 62).
- **"One prompt" is rarely one pass.** The posts that showed their work had long briefs, installed skills, reference repos, API keys, or hours of critique rounds behind them.
- **Numbers are claims.** View, like, time and cost figures are the posters' own and drift between sources. Treat them as claims.

**Labels used below:**
- **[Sponsored]**: a paid influencer post, partner post, a vendor's own ad, or a post with an affiliate or referral link.
- **[Likely sponsored]**: looks coordinated, but there is no disclosure.
- **[Self-promo]**: promotes the poster's own product, studio, service or newsletter.
- **[Not Claude]**: made with another tool.

## The ten lessons that recur across categories

1. **Setup beats prompt.** References, a renderer, real brand assets and a review loop decide quality (https://x.com/rexan_wong/status/2103707054108299437, https://x.com/donaldjewkes/status/2102801274173587569, https://x.com/LexnLin/status/2104148233106723099).
2. **Render deterministic frames from code; never screen-record.** Use `seek(t)` or `draw(t)` as a pure function of time (https://x.com/verbove/status/2103483957266268381, https://x.com/twoclipping/status/2103835273813496100, https://x.com/deedydas/status/2102787937482252537).
3. **Plan before pixels.** Inputs, then a beat map or storyboard, then stills, then approval (https://x.com/rexan_wong/status/2103707054108299437, https://x.com/twoclipping/status/2103835273813496100, https://x.com/verbove/status/2103483957266268381).
4. **Lock to a beat grid.** Something happens on every beat, and the drop and breakdown map to story moments (https://x.com/twoclipping/status/2103835273813496100, https://x.com/verbove/status/2103483957266268381, https://x.com/LexnLin/status/2104148233106723099).
5. **Continuity over cuts.** One morphing shape or one persistent actor carried through every seam (https://x.com/verbove/status/2103483957266268381, https://x.com/LexnLin/status/2104148233106723099, https://x.com/leo_xiaolei/status/2102724347446305104).
6. **Real brand, real UI, real data.** Invented UI and raw screenshots read as cheap (https://x.com/rexan_wong/status/2103707054108299437, https://x.com/HO_BA/status/2103845264649761062, https://x.com/op7418/status/2103148288400924827).
7. **Sound is half the film.** Cues come from the picture's timeline, SFX sit on measured peaks, and the mix is loudness-normalised (https://x.com/LexnLin/status/2104148233106723099, https://x.com/twoclipping/status/2103835273813496100, https://x.com/everestchris6/status/2104234619025682463).
8. **Look at rendered frames, and have a fresh critic judge.** The builder misses its own dead time (https://x.com/everestchris6/status/2104234619025682463, https://x.com/LexnLin/status/2104148233106723099).
9. **Ban the defaults and name a reference.** Without one you get centered text, a gradient and fades (https://x.com/rexan_wong/status/2103707054108299437, https://x.com/twoclipping/status/2103835273813496100).
10. **Make the product the subject.** The showreel framing alone can make the model ignore the product (https://x.com/robj3d3/status/2104649947610239253).

---

## Launch films

**#19 LexnLin, "tessel" (33 s, 60 fps).** https://x.com/LexnLin/status/2104148233106723099. Repo: https://github.com/Leonxlnx/claude-launchvideo (MIT).
- **Everything is code.** Claude Code on the web invented the name, logo, UI, animation, score and SFX for a fictional calendar app. The commit log shows 33 commits over about 8 hours, including four self-critique rounds.
- **One timing file.** `timeline.ts` (60 fps, 120 BPM, 30 frames per beat) drives both picture and sound. Whooshes sit on measured camera-velocity peaks, and impacts on the first frame a spring reaches its target.
- **One relay object.** A red "now" dot never leaves the screen, so every seam is a designed match. The logo opens into the product UI.
- **Strict brand discipline.** Ink and paper plus one accent used only for meaning, and one type family.
- **Fixes found by critique.** A flat feature section was redesigned; dead holds got a slow push-in; the calendar arrived empty, so the data now loads during the fly-in; a headline overflowed, so it is sized from DOM measurement; Chromium banding and blur artefacts were fixed; Remotion's AAC mux lag was fixed by muxing with ffmpeg.

**#8 twoclipping, "Develop" (29 s, 1:1).** https://x.com/twoclipping/status/2103835273813496100. [Self-promo: the thread reply sells an affiliate network.]
- **The most technical prompt in the set.**
  - It asks for inputs first, uses an Apple-keynote direction, and is 2D only, in one continuous take.
  - Every scene is made out of the previous one.
  - It carries a Banned list (crossfades, blur-ins, 3D flips, particles, glows, holds over 1 s).
  - It runs at 120 BPM with an event on every beat. The last frame equals the first.
- **Build details:**
  - one HTML file at 1440x1440, `seek(t)`, closed-form summed springs
  - a cursor driving real clicks and drags
  - real SFX placed by measured peak, -14 LUFS
  - 4 subframes per frame blended with ffmpeg `tmix` at 60 fps
  - QA: one frame per beat, then a scan for single-frame pops (frame-difference spikes 3x their neighbours)
- **The "$0, 0 external tools" claim** still relied on Mixkit audio, a Pexels clip, Playwright and ffmpeg.

**#26 op7418, CodePilot (50 s).** https://x.com/op7418/status/2103148288400924827. [Self-promo.] Skill: https://github.com/op7418/guizang-product-video-skill (AGPL-3.0).
- **How it was built.** Real React components bundled with esbuild, driven by GSAP and exported with HyperFrames. 14 shots at 120 BPM, with a code-synthesised score.
- **The skill's discipline.** `DIRECTION.md` comes before code, along with product-derived devices, a frame spec in numbers and a per-second shot list. UI text is at least 22 px at 1080p. The first frame is a poster. Music is ducked under SFX by role.
- **The metric lesson.** A metric-driven version hit 29/29 on-beat actions and still looked cramped. The "beats GPT-6 Astra" claim is unverified.

**#6 deedydas, muda (26 s).** https://x.com/deedydas/status/2102787937482252537.
- Plain JavaScript, Playwright and ffmpeg, with no video model and no libraries.
- The poster argues that motion graphics explain technical ideas in seconds where photoreal generation does not.
- "1 min for ~$2" is unverifiable and likely excludes setup.

**#35 tdinh_me, TypingMind logo reveal (21 s).** https://x.com/tdinh_me/status/2103704250329301409. [Self-promo.]
- Attach the real logo and ask for a slow reveal that assembles the mark piece by piece. A narrow, well-known brief leaves little to guess.
- Never let the model redraw the logo.

**#13 danielsmidstrup, ClimbX (30 s).** https://x.com/danielsmidstrup/status/2104013515623170390. [Self-promo.]
- Reused Tony Dinh's prompt plus a brand asset. The linked prompt could not be retrieved.
- "20 minutes, one prompt" is a claim.

**#37 RaphaelAubryy, Baguette Pro (20 s).** https://x.com/RaphaelAubryy/status/2104178266990858739. [Self-promo: the reply plugs the author's unrelated SaaS.]
- A genre transplant: an Apple-style product launch applied to a baguette.
- Naming a famous grammar hands the model pacing, palette, type and camera in one go.

**#27 moritzkremb, AI workspace launch (46 s).** https://x.com/moritzkremb/status/2103066071838466494.
- The prompt had the model pick a well-known SaaS, fetch real assets from the internet, and copy the style of launch videos posted on X.
- It shows genre-aiming works. It also carries trademark and impersonation risk if published. Use your own brand files.

**#23 ajith_io, DistilBook (40 s).** https://x.com/ajith_io/status/2103469807375208546. [Self-promo: a product plug; the relationship is unclear.]
- "Research <product>" before the showreel framing lets the model gather real features first.
- A longer 40 s duration suits a named product.

**#49 thayto_dev, AjustaCV pricing (15 s).** https://x.com/thayto_dev/status/2104200591278739735. [Self-promo.]
- The HyperFrames skill was installed, the showreel prompt was pasted, the prompt pointed at the project folder, and effort was set to max.
- The folder supplied the real pricing, colours and copy. "About 5% of the 5-hour limit" is second-hand.

**#56 T_Zahil, Uneed (15 s).** https://x.com/T_Zahil/status/2103873077788786692. [Self-promo: the reply plugs a newsletter with income claims.]
- Every frame was drawn in code and the music was synthesised in code.
- Synth audio worked for a showreel post. Compare #55, whose clients rejected synthesised SFX.

**#29 achxvi, TixFox (39 s).** https://x.com/achxvi/status/2104294892944097513.
- A pixel-art mascot plus one concrete hook (39-cent tickets) gives a short promo a story spine.
- No prompt or stack was shared.

**#44 dhruvalgolakiya (5 s).** https://x.com/dhruvalgolakiya/status/2102854634536866099. [Self-promo: the poster's own app.]
- The first 5 seconds took about 20 minutes, then an overnight run for the full video.
- Prove the style on a short clip before a long run, and add checkpoints.

**#47 SimonHoiberg, FounderStack (15 s).** https://x.com/SimonHoiberg/status/2103916672080097521.
- A claimed one-shot that beat the poster's two-month Remotion + Blender pipeline. No prompt was shared, so it cannot be verified.

**#15 likithareddy, Peggy (18 s).** https://x.com/likithareddy/status/2104202329805467984. [Self-promo: design services.]
- "20 min", with no process given. The app's UI and brand likely existed already as inputs.

**#16 shownotover, XFastest (30 s).** https://x.com/shownotover/status/2104124596957933687. [Self-promo.]
- "This is my product, give me your best" on Medium effort produced a shippable 30 s video in about 54 minutes on a Pro plan.
- The token-to-dollar extrapolation is unreliable, because agent token totals are mostly cached re-reads.

**#21 jackfriks, Post Bridge (15 s).** https://x.com/jackfriks/status/2103881791002357918. [Self-promo.]
- No method. "Under $0.10 and 10 minutes" cannot be verified.

## Product demos and UI motion

**#43 verbove, MakerMap (20 s, 1440x1440).** https://x.com/verbove/status/2103483957266268381. [Self-promo: the poster's own product.]
- **The most reusable template in the gallery.**
  - The setup: one reference post, one HTML file, one canvas, one `draw(t)`.
  - One shape that is never cut, morphing through the product story with real data ("3,393 makers").
  - A cursor driving real clicks, typing and a drag, on a 120 BPM grid.
  - Summed closed-form springs, a one-frame-per-beat contact sheet before the full render, 6-subframe motion blur at 60 fps, H.264 yuv420p.
  - All aspect ratios exported in parallel, and the last frame equals the first.
- **The failures it designs against.** Text overlapping during morphs, muddy black-to-accent fades, and cramped states.

**#60 HO_BA, mdfor.dev (30 s).** https://x.com/HO_BA/status/2103845264649761062. [Self-promo.]
- Earlier feedback was folded back into the prompt: use the actual screenshots, logo and assets; motion must match the music; a professional production, not a demo.
- Key note: never show a screenshot raw; break it into components and icons that animate.

**#61 robj3d3, SuperX MCP (20 s).** https://x.com/robj3d3/status/2103949734520279060. [Self-promo.]
- Live data as content: fetch the replies through an MCP, curate 60 down to 25, and make a film about that process (cause, then effect, with real numbers).
- Using real people's replies needs thought about consent and attribution.

**#31 SebastianRoehl, HabitKit update (15 s, vertical).** https://x.com/SebastianRoehl/status/2103912457836323096. [Self-promo.]
- Asking to highlight the recent updates in 15 s was too much. Changelog films need explicit scope (which versions, which 2-3 features) and a duration that fits.

**#58 thednyx, Habitify (11 s, 1:1).** https://x.com/thednyx/status/2102653181146575329.
- A single UI interaction animated in a square. A useful micro format; no method was shared.

## Showreels

**#1 stephanlivera (15 s).** https://x.com/stephanlivera/status/2103315922098470926.
- The canonical prompt, paraphrased: a 15-second motion graphics showreel for a résumé; go all out. Run on Max effort.
- The persona invites range over story. The side-by-side comparison with another model is what made it spread.
- No renderer was named, so it is not reproducible as a method.

**#5 ajith_io (15 s).** https://x.com/ajith_io/status/2103449416325890146.
- The same prompt reproduced by another user, which is why it became a meme format.

**#11 himanshutwtxs (15 s).** https://x.com/himanshutwtxs/status/2103495232637882858.
- The same prompt on Max, with a second sample on Medium. The reel is organised around classic animation principles, and sound is part of the experience.

**#14 darel023 (15 s).** https://x.com/darel023/status/2103424524297420829.
- An engineered variant: a hook in the first second, a sequence of distinct techniques (type, shape, camera, colour), a clean final frame, and pacing cut to music.

**#3 shneural, chrome 3D (32 s).** https://x.com/shneural/status/2103151003272962130.
- The bare prompt on a machine that already had a sample library, a synth, VST effects and a Blender MCP. Opus used them unprompted: 2D in skia-python, 3D through a Blender script, and audio sequenced from real drum samples to a beat grid.
- About 1.5 hours, excluding render.
- It is a single-run, partisan model comparison, not a controlled test.

**#22 condzxyz, Bauhaus (15 s).** https://x.com/condzxyz/status/2103556754550469102.
- With no brand, the model fell back on a strong historical idiom. Name such a style anchor deliberately. The audio was generated in the same run.

**#24 leonabboud (15 s).** https://x.com/leonabboud/status/2103576084499358051.
- About 15 minutes for a 15 s reel. The "$8-10k agency" comparison is opinion.

**#30 cherry_mx_reds (15 s).** https://x.com/cherry_mx_reds/status/2103510478152425926.
- An unattended run of the canonical prompt worked. "No storyboard" only holds for this generic self-showcase brief.

**#39 jacksonfall, agency showreel (36 s).** https://x.com/jacksonfall/status/2103925420211229164. [Self-promo: the poster's own branding studio.]
- A persona (a niche branding agency for startup founders), all graphics from scratch, 30 s, xhigh effort.
- How much was done by hand is unknown.

**#18 robj3d3, SuperX on Opus (15 s).** https://x.com/robj3d3/status/2103875898349088830. [Self-promo.]
- The canonical prompt on xhigh, with the audio produced in the same run.

**#28 robj3d3, SuperX on Sonnet (15 s).** https://x.com/robj3d3/status/2104649947610239253. [Self-promo.]
- A useful negative result: Sonnet 5.5 at max effort ignored the product name and made a reel about itself. When the product matters, make it the subject, add a research step, and check the storyboard names it.

## Explainers

**#55 everestchris6, roof inspection with 3D cutaways (29 s).** https://x.com/everestchris6/status/2104234619025682463. Repo: https://github.com/echris6/motion-video-kit (MIT).
- **The workflow.** A brief of provable facts, then mechanisms borrowed from references, then a storyboard table that names which object survives each transition.
- **Assets and components.** AI key frames come before image-to-video. Components are built in lab pages.
- **The Gauntlet.** One root seek clock, then a critic loop with a fresh reviewer each round.
- **Measured progress.** Frozen time fell from about 10 s of 36 s to 0.7 s of 28.6 s over four rounds.
- **Documented failures:**
  - a cubic ease-out popping on its first frame
  - wipes splicing two titles into one word
  - a top-down camera flattening the house
  - ACES shifting brand colours
  - `-apple-system` rendering as Times
  - a 33 ms SFX lead-in making every hit 2 frames late
  - clients rejecting synthesised SFX

**#59 leo_xiaolei, a pumpkin's tour of light and space (28 s).** https://x.com/leo_xiaolei/status/2102724347446305104.
- A long structured prompt that reproduces a reference's rhythm. Every transition must be a visible transformation, described as a physical process.
- It includes a second-by-second master timeline, a palette with hex values, procedural paper grain and an explicit avoid list. Randomness is seeded so playback is identical.
- The stack names `requestAnimationFrame`. For MP4 export the timeline must be seekable. The poster warns that quota use and run time are heavy.

**#52 itisRazak, DistilBook water cycle (40 s).** https://x.com/itisRazak/status/2103517930424332386.
- "Research <product>" first, then the showreel framing. It produced a light, hand-drawn explainer instead of the dark tech-reel default.
- Uploaded at 848x480, which undercut it.

**#32 alex_prompter, newsletter explainer (35 s).** https://x.com/alex_prompter/status/2103499977632997524. [Self-promo: a newsletter funnel.]
- A five-scene director template: problem, what I do, how it works in 3 steps, one proof point, name.
- Iterate with one note at a time.
- Screen-recording the live page is fine for a draft but not frame-accurate.

**#7 brivael, French theory film (5:32).** https://x.com/brivael/status/2104216601864106226. [Likely sponsored: the thread teases an integration with Argil (@argildotai), likely an affiliation.]
- A long explainer driven from an existing written essay. When the script exists, the model can sustain minutes.
- The source text is a politically charged opinion essay. It is included here only for the text-to-film method.

## Music videos and visualizers

**#2 donaldjewkes, illustrated AI timeline (2:22).** https://x.com/donaldjewkes/status/2102801274173587569.
- **The brief.** About 1,000 words dictated by voice, built on the PDoomVideo repo, with custom skills, and fal and ElevenLabs keys in the folder. It ran unattended for 12 hours with up to about $2k of credits available.
- **Generated video as a base plate.** The brief asked for Seedance clips as a motion and physics base plate only, with everything redrawn in JavaScript on top (rotoscoping) so the look stays coherent. Whether the final film did this was not verified.
- **Kinetic lyrics.** Vary between subtitle size and huge, quiet the background where text is big, and go biggest on the opening hook.
- **Failures named.** Things that only come together late feel jarring; lip-sync needs verification loops.

**#10 kaolti, robot head visualizer (28 s).** https://x.com/kaolti/status/2103887665305391343.
- A native macOS visualizer app plus one Blender-modelled hero object, driven by the poster's own track. Using your own music sidesteps licensing.

## Ads, commercials and vendor posts

Most of this group is not Claude writing code. The techniques still transfer; the claims do not.

**#9 higgsfield_ai, nature reserve brand kit.** https://x.com/higgsfield_ai/status/2103839805360820589. [Sponsored: vendor ad.]
- Opus drives the Higgsfield MCP, and the output is an editable After Effects project.
- The transferable idea is an editable deliverable. Installing a third-party MCP is a step to ask about.

**#33 higgsfield_ai, kinetic typography (15 s, square).** https://x.com/higgsfield_ai/status/2103963588012744859. [Sponsored: vendor ad.]
- Kinetic type is a strong first genre. Keep the composition parameterised so a revision is an edit. "43 minutes, 3 revisions" is a vendor claim.

**#17 trymirage, synthwave photo app.** https://x.com/trymirage/status/2103542300844474452. [Sponsored: vendor ad with ad tracking.]
- The layer and animation counts measure complexity, not quality. In code, editable layers come free because every element is a named component.

**#34 trymirage, cave to cyber city.** https://x.com/trymirage/status/2102825183669006742. [Sponsored: vendor ad.] [Not Claude.]
- Its feature list makes a checklist of techniques a code renderer can do too:
  - boolean shapes and custom shaders
  - type behind a subject via a matte
  - per-glyph motion and speed ramps
  - shutter motion blur and animated masks
  - parallax cards and audio-reactive parameters
  - adjustment layers

**#42 trymirage, build your own editor.** https://x.com/trymirage/status/2103164113895531001. [Sponsored: vendor ad.] [Not Claude.]
- The idea, not the product: once the film is a pure `draw(t)`, have Claude build a project-specific scrubber with a time slider, beat markers and parameter knobs.

**#57 trymirage, Muse launch remade.** https://x.com/trymirage/status/2102863208209932736. [Sponsored: vendor's own ad.] [Not Claude.]
- It re-skins another company's launch film. Borrow mechanisms, never another brand's layouts, logos or footage.

**#63 abxxai, speed ramps and masks.** https://x.com/abxxai/status/2102826435484475711. [Sponsored: paid influencer.] [Not Claude.]
- Plan a finishing pass for speed ramps, masks, titles and timing after the main build.

**#45 itsolelehmann, Captions app promo.** https://x.com/itsolelehmann/status/2102653764255551761. [Sponsored: paid influencer.] [Not Claude.]
- Revisions written as numeric offsets and event anchors: a title 0.5 s earlier, an SFX on the logo-in frame, a voice carried across a cut (a J/L-cut).
- Keep audio and video on separate tracks.

**#41 VibeMarketer_, creator explainer with kinetic captions (vertical).** https://x.com/VibeMarketer_/status/2102827275443982344. [Likely sponsored.] [Not Claude.]
- Kinetic captions on vertical talking-head content is a high-volume genre worth a template.

**#62 nett0eth, Weird Cats pixel-art site.** https://x.com/nett0eth/status/2103113461966459081. [Likely sponsored.]
- Claude Code drove a third-party editor. A strong existing visual identity (pixel art) carried the film.

**#38 orenmeetsworld, talking head with cutaways (vertical).** https://x.com/orenmeetsworld/status/2103589844597514745. [Sponsored: partner post.] [Not Claude.]
- Labelled assets plus two reference videos worked as inputs. Colour grading of log footage still had to be done in a grading tool.

**#12 heykazitarek, Gamma product video (2:45).** https://x.com/heykazitarek/status/2102524119510397209. [Sponsored: partner content.] [Not Claude.]
- Approve the concept and the opening segment before the rest is built.
- Give frame-specific feedback, and check the readability and cropping of screenshots.

**#40 QwolfAi, ECG monitor product film.** https://x.com/QwolfAi/status/2103056860366393504. [Sponsored: referral link.] [Not Claude.]
- Region-anchored feedback: circle an area on a frame and ask for a zoom and a label there. In code, pass a timestamp and a region.

**#46 CholeSyntax, neon glass SaaS promo.** https://x.com/CholeSyntax/status/2103047550345597022. [Sponsored.] [Not Claude.]
- Iterate on the same project rather than regenerating.

**#36 fahadaziz, PuppyDog launch.** https://x.com/fahadaziz/status/2102772136993763459. [Self-promo: product launch ad.] [Not Claude.]
- Its argument is that avatar tools and templates all look the same, and that real screens, workflows and scripts win. The customer statistics and agency-price comparisons are unverified.

**#64 joshmillgate, Ultramock launch made in the app.** https://x.com/joshmillgate/status/2102504820716306815. [Self-promo.] [Not Claude.]
- Dogfooding (making the product's launch film inside the product) is a persuasive story in itself.

**#48 Aiwithmaha, lip gloss beauty ad (vertical).** https://x.com/Aiwithmaha/status/2102952087823044888. [Not Claude: Seedance 2.0, a generative video model.]
- Photoreal hands, skin and products come from generative video or a camera, not code. Composite them under code-drawn type.
- Its shot list is a reusable beat sheet for physical products: unbox, reveal, texture, use, lifestyle end card.

**#51 saniaspeaks_, body scrub UGC ad (vertical).** https://x.com/saniaspeaks_/status/2104070616731058437. [Likely sponsored: a contest entry tagging the vendors.] [Not Claude.]
- A vertical UGC framing of a real product demo.

**#54 MonetizationDon, burger commercial (1:1).** https://x.com/MonetizationDon/status/2103901509155004644. [Self-promo: tags an editing app; the engagement ratio looks anomalous.] [Not Claude.]
- The order is keyframe stills, then image-to-video, then type and edit as a separate finishing pass. The traditional-cost claim is unsourced.

**#53 achxvi, creator payouts app with a clay mascot (vertical).** https://x.com/achxvi/status/2104137954427830588. [Self-promo: sells a video service through a paid link; tool unknown.]
- Format only: a mascot, the features, then an offer CTA.

**#50 aizal_mp4, AI support agent explainer (69 s).** https://x.com/aizal_mp4/status/2103192170501193940. [Self-promo: agency pitch; tool unknown.]
- No method. It is a pale pastel 69 s explainer.

## Tutorials and method posts

**#4 rexan_wong, how the one-prompt videos are really made.** https://x.com/rexan_wong/status/2103707054108299437.
- **A six-step method:**
  1. Pick 1-2 reference videos (for example from whatships.com) and say "match these".
  2. Install a code-video renderer (HyperFrames or Remotion).
  3. Use real UI components instead of invented UI.
  4. Dump in the brand, real screenshots, the reference and a braindump, and ask for 3 storyboard variants.
  5. Pick one and ask for one still per scene before anything moves.
  6. Let it run, then give director notes in camera language.
- The post recommends a component marketplace (21st.dev) without disclosure. For supermemory videos, product UI must be a real capture instead.

**#20 moritzkremb, five business use cases (23 min).** https://x.com/moritzkremb/status/2103115037334262241. [Self-promo: newsletter funnel.]
- A use-case map: launch videos; explainers for articles, skills and SOPs; long-form to short-form; personalised video proposals; animated presentations.
- The method lives only inside the video.

**#25 minchoi, cinematic essay in motion type (roundup).** https://x.com/minchoi/status/2104227722377757031. [Self-promo: a follow, bookmark and repost call to action; the video's maker is unclear.]
- The thread notes that high-end runs mix in external image references (Midjourney stills, moodboards) and long unattended runs.
