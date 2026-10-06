# Batch 10-more-d: agent demos, long-form talks and launch films (29 entries)

> **Method note.** Frames come from exact-seek 16-frame sheets (tile k sits at (k+0.5)×T/16 with T = min(duration, 240), so for the nine videos over 240s the sheet and the metrics cover only the first 240s), hook strips (0, 0.5, 1.0, 1.5, 2.0 and 2.5s) and end strips (the last 4s). Audio was not heard: only its presence and loudness (LUFS) are reported. Views are the bookmarked post's, so a quoted clip carries the quoting post's count. Cuts use a 0.32 scene threshold, which misses dissolves, morphs, dark cuts and punch-ins. #23 and #24 are the same file. The local file for #4 is a partial download that stops decoding at ~782s of 2,605s, so its ending was not seen. There are no competitor videos in this batch.

### 1. @OpenAIDevs · product demo · 138s · 16:9 · 1.92M views · [post](https://x.com/OpenAIDevs/status/2098130570048045453)
- **Hook (0-3s):** Frame 0 is a frontal medium-wide of an engineer at a round table, laptop open with the OpenAI mark on the lid, in a daylight loft with a yellow stool and plants. By 0.5s a two-part name super (name, then Developer Experience Engineer, OpenAI) is in at lower left. Nothing else changes by 3s: he talks and gestures, and the product name waits until ~11s.
- **Beats:** to camera (0-11s) → close-up with Agents API set in white at lower left (~11-14s) → white line diagram: your app → harness/orchestration ↔ sandbox (~16-26s) → black terminal over a faint star field, streaming session events (queued, in progress, the agent's first sentence) (~30-40s) → split layout, a white code panel on the left (sandbox config, capability directories for Datadog, GitHub and skills) with him in the right third (~40-59s) → a log dump with one UPSTREAM_TIMEOUT error line (~61-66s) → programmatic tool calling card: 170,126 tool-result tokens against a two-field JSON in model context (~67-78s) → terminal spawns parallel subagents (~78-89s) → him (~89-105s) → a terminal link opens a checkout incident report PDF (~105-117s) → him, close and wide (~117-136s).
- **Ending:** He smiles in the wide while a small dot over his shoulder cycles orange, green, blue and pink for ~1.5s. A hard cut at 136.3s goes to a white card where the OpenAI wordmark assembles letter by letter, held ~1.3s. No URL and no availability line (the post carries the public-beta note).
- **Look:**
  - Ground: daylight loft for the presenter; inserts alternate between pure white panels and black terminals over a faint star field.
  - Palette: white, black, wood and concrete; color only from syntax highlighting and the yellow stool.
  - Type: white OpenAI sans for the super and the title; monospace everywhere else.
  - Fills frame: the presenter full-frame for ~40% of the runtime plus ~14s of split screen; real terminal output, code panels, one diagram, one token comparison and the report fill the rest.
  - Camera: two locked-off cameras (frontal wide and close); screen inserts are static captures.
  - Transitions: hard cuts only.
- **Measured:** moving 49.0%, longest still 2.87s, 8.3 cuts/min (median shot 5.92s), loudness -23.2 LUFS.
- **Why it works:** One incident is followed from setup to the finished report, so every feature (sandbox, skills, programmatic tool calls, subagents) appears as a step in the same job. A single before/after number card makes the efficiency claim readable at a glance.
- **Borrow:** one realistic job carried end to end, with the produced artifact (the report) as the payoff; one big before/after number for invisible efficiency. **Don't copy:** the loft set, OpenAI's type and wordmark animation, the incident scenario.

### 2. @EvanLuthra · other (phone-filmed screen) · 21s · 9:16 · 1.19M views · [post](https://x.com/EvanLuthra/status/2063252005502755247)
- **Hook (0-3s):** Frame 0 is a phone shot of a monitor filled with a dense orange-yellow web of connections between columns of nodes, with input nodes (small sine-wave icons) at the left edge. By 2.5s the camera has drifted right, the inputs have left frame and the first hidden layer is centered. There is no overlay text at any point.
- **Beats:** input layer (0-2s) → slow pan across the first hidden layer (2-8s) → a tilt up shows the app's title bar (a C++/OpenGL neural-network editor) and a desktop clock reading 09:57:11 onward (~8-14s) → later hidden layers (~14-17s) → pull-back to the monitor bezel, a 14-node sigmoid output layer with one highlighted output and a table of green and red values (~17-21s).
- **Ending:** a slow handheld drift over the output layer and the value table for the last ~4s; no card, the take just stops.
- **Look:**
  - Ground: a navy app UI on a physical monitor; desk cables visible at the end.
  - Palette: orange and yellow lines on navy; green and red numbers.
  - Type: none added; tiny UI labels only.
  - Fills frame: one neural-network diagram, edge to edge.
  - Camera: handheld phone, a continuous left-to-right pan with a tilt and a final pull-back.
  - Transitions: none (one take).
- **Measured:** moving 99.8%, longest still 0.03s, 0 cuts/min (one 21s take), loudness -11.0 LUFS.
- **Why it works:** The glowing web reads as a huge AI system even as a thumbnail, and the caption (300 agents doing a research team's work in 3 hours) supplies the story. It doesn't show that claim: there are no agents, tasks or results on screen, only a network visualizer, so the reach comes from the caption and the account, not the footage.
- **Borrow:** one slow, continuous camera move across a single dense, glowing structure as an atmosphere shot (for supermemory, a memory graph). **Don't copy:** the third-party software or the footage.

### 3. @atmoio · talking head · 963s · 16:9 · 850K views · [post](https://x.com/atmoio/status/2103895436360884389)
- **Hook (0-3s):** Frame 0 is a bearded presenter at a desk in a dark room washed purple, with an orange lamp glow at left and a blue uplight at right, his hand to his face. Through 2.5s he talks and gestures. There's no title, caption or graphic: the hook is the spoken line plus the post's one-word verdict on Opus 5.5.
- **Beats:** The sheet covers the first 240s. Talking head with reframes between a medium and a closer crop (0-52s) → a ~5s anime-style cutaway: a caped character in glasses, a snowy scene with code overlaid, a glowing holographic card (52.5-57.7s) → talking head (~58-200s) → screen recording of a dark chat app with his webcam inset at right (~200-232s), then a light website the model generated (~232s) → spot checks past 240s: more generated pages (~330-470s), a sepia render of the Colosseum (~540s), a clip of another speaker on a blue backdrop (~750s), then talking head to the end.
- **Ending:** talking head: he clasps his hands and smiles, then a reframe to a wider shot of him looking at camera for the last ~2s. No card.
- **Look:**
  - Ground: dark home studio with a purple wall wash and orange and blue practical lights.
  - Palette: purple, black, orange, electric blue.
  - Type: none on the talking head; the screen captures carry their own UI.
  - Fills frame: the presenter for ~80% of the first 240s; screen recordings with a webcam inset.
  - Camera: locked off, with reframes the detector misses.
  - Transitions: hard cuts.
- **Measured:** first 240s only: moving 90.1%, longest still 2.6s, 1.0 cuts/min (median shot 2.0s, which comes from the 5s cutaway; the first shot runs 52s), loudness -18.6 LUFS.
- **Why it works:** A strong verdict from a creator with an audience, said straight to camera and then backed by the model's output on screen. The anime cutaway is a cheap pattern break at ~50s, where long talking heads start losing people; the reach itself tracks the account and the topic (a new model).
- **Borrow:** one pattern-break insert near the 50s mark; proof as a screen recording with the speaker's face inset. **Don't copy:** the lit set, the anime clip.

### 4. @MollySOShea · other (sit-down interview) · 2605s · 16:9 · 678K views · [post](https://x.com/MollySOShea/status/2081749064056717807)
- **Hook (0-3s):** Frame 0 is the guest (Cognition's CEO, per the post) in a white tee in a teal-lit room while the Cognition logo assembles from dots at lower left; by 1s the super reads Cognition.ai. At ~1.3s it cuts to him in a dark hoodie by a window with the super still on. Archival clips, not the interview, open the film.
- **Beats:** The sheet covers the first 240s. Trailer cold open (0-50s): a code-review UI reporting no bugs (~2s), the Devin app icon (~3s), customer lockups (Cognition × Microsoft, × Mercedes-Benz) over clips (~4-6s), $2,250,000,000 over the two founders (~10s), a news headline highlighted in black, then $26,000,000,000 (~16s), $489,750,000 (~20s), then pull-quotes as two-tier captions, a small-caps lead-in over a large italic serif payoff such as "IN THE RANGE OF / 11x - 12x" (~24-48s) → a black beat (~49.5s) → black-and-white title sequence: a sponsor-presents card, name supers for host and guest, the show title (~50-57s) → the color interview (~58s on): three setups (two-shot, host single, guest single) in a bright room with green curtains and flowers, with the show bug top-left, the sponsor top-right and two partner logos bottom-center, in takes of 10-60s. A spot check at ~400s finds a mid-roll sponsor card with a URL.
- **Ending:** not seen. The local file stops decoding at ~782s of 2,605s, so the last seconds could not be checked.
- **Look:**
  - Ground: an ornate, bright room (green curtains, gilded armchairs, flowers) for the interview; mixed archival footage in the trailer.
  - Palette: cream, green and floral pink; black and white for the title sequence.
  - Type: large italic serif for money figures and payoff words, small sans caps for lead-ins, serif name supers; the show and sponsor bugs stay on screen.
  - Fills frame: archival clips, logos and headlines for ~50s, then a three-camera interview.
  - Camera: locked-off three-camera coverage; slow push-ins in the trailer.
  - Transitions: fast hard cuts in the trailer (24 in the first 60s), a black beat into the title sequence, few cuts after.
- **Measured:** first 240s only: moving 60.6%, longest still 2.3s, 7.0 cuts/min (median shot 2.09s, driven by the trailer; only 4 cuts after 60s), loudness -19.5 LUFS.
- **Why it works:** The first 50s sells all 43 minutes: the guest's biggest numbers and lines arrive as giant serif type before the conversation starts, and famous customer logos supply trust inside 6s. The post's stat list does the same job in text.
- **Borrow:** a 30-50s trailer cold open built from the best numbers and lines, set as two-tier captions (small lead-in, big payoff); customer logos inside the first 5s. **Don't copy:** the show branding, the sponsor bugs, the serif treatment.

### 5. @0xMovez · other (conference fireside chat) · 1456s · 16:9 · 471K views · [post](https://x.com/0xMovez/status/2062970118033023115)
- **Hook (0-3s):** Frame 0 is the speaker seated with a handheld mic in front of a black stage screen carrying the AI Ascent mark, topographic line art and a dotted curve. Word-by-word burned-in captions, mixing an italic serif and a bold sans, build in the empty black at the left from 0.5s through 2.5s. The camera is static.
- **Beats:** The sheet covers the first 240s. Captioned cold-open clip of the speaker (0-28s) → wide of the brick room, the screen titled Fireside Chat, the host walking on (~28-55s) → host single (~55-82s) → two-shot from the audience (~82-105s) → host, then the wide room (~105-140s) → speaker medium single for the rest of the first 240s, with occasional wides. Captions appear only in the cold open.
- **Ending:** a wide of the room, then a hard cut at ~1450s to the AI Ascent end card (logo beside an animated line-art curve and dot field on black), held ~5s.
- **Look:**
  - Ground: brick-walled event space with a black branded stage screen.
  - Palette: black, white line art, warm brick and wood.
  - Type: word-by-word captions mixing italic serif and bold sans, in the cold open only.
  - Fills frame: speaker singles for about half of the first 240s; host singles, two-shots and audience wides for the rest.
  - Camera: locked-off multi-camera event coverage.
  - Transitions: hard cuts.
- **Measured:** first 240s only: moving 78.5%, longest still 0.47s, 2.0 cuts/min (median shot 18.88s), loudness -19.9 LUFS.
- **Why it works:** The repost's value is the speaker (the Claude Code creator, per the post) and a quotable line about loops; the 28s captioned cold open gives a sound-off viewer that hook before the stage formalities. Craft is not the reason for the reach.
- **Borrow:** put the best 20-30s first, with word-by-word captions placed in the frame's empty space rather than over the face, then start the real recording. **Don't copy:** the event branding, the footage.

### 6. @fdotinc · explainer · 421s · 16:9 · 401K views · [post](https://x.com/fdotinc/status/2083279883950862631)
- **Hook (0-3s):** Frame 0 is a wide of a founder seated in an open office, with a monitor behind him showing four AI-lab logos in a 2x2 grid. The camera pushes in through 2.5s to a medium close-up as he talks. At ~4s a whip blur carries stacked white kinetic words about perfect instant answers.
- **Beats:** The sheet covers the first 240s. Cold open (0-50s): his lines intercut with a glitchy blue 3D blob beside a context-engineering diagram (~6-9s), a library shot and writing on glass, a node graph on white (~22s), a constellation on black, particles streaming into a ring, a giant cropped kinetic word, window (~50s) → title over office B-roll, Founder's Inc. Build Log Ep. X (~51-54s) → chapter 1 card in small lowercase type on white (~55s) → the founders roll out a big whiteboard (~82s) → cosine-similarity sketches (~97s) → an overhead hand-drawn explanation: RAG and vector embeddings, then a person, a sport and a food drawn as nodes joined by edges (~112-190s) → chapter 2 card (~202s) → spot checks past 240s: a 3D viewer counting 348,133 vertices (~265s), a CPU, RAM and SSD sketch (~295-310s), a storage-to-RAM diagram (~318s), chapter 4 card (~348s), a graph visualization on a laptop (~370s), a second founder explaining (~385-405s).
- **Ending:** the founders laugh, a whip pan finds a teammate in a grey tee mugging and pointing at the camera (~415-418s), then a white card with a small URL (f.inc/hello) and a chevron glyph that flashes above it, held ~3s.
- **Look:**
  - Ground: a sunlit hardware lab and office; pure white and pure black graphic cards.
  - Palette: warm daylight footage; black-and-white graphics with one electric blue.
  - Type: small lowercase sans for chapter cards, giant cropped black sans for kinetic words, marker handwriting.
  - Fills frame: the founder to camera, overhead whiteboard drawing (a large share of the first 240s) and short graphic inserts.
  - Camera: handheld with push-ins and whip pans; a top-down camera for the whiteboard.
  - Transitions: hard cuts, whip blurs, a glitch effect.
- **Measured:** first 240s only: moving 71.7%, longest still 3.93s, 22.5 cuts/min (median shot 2.38s), loudness -20.1 LUFS.
- **Why it works:** The whiteboard does what slides can't: you watch the idea move from similarity search to a graph of linked facts, stroke by stroke, so the product (a graph tool for very large contexts) arrives as the obvious answer. Numbered chapter cards make 7 minutes feel navigable.
- **Borrow:** overhead hand-drawing to explain memory (embeddings versus a graph of linked facts) before the product appears; lowercase numbered chapter cards for anything over 2 minutes. **Don't copy:** the lab footage, the blob, the show's title card and URL card.

### 7. @atmoio (quoted video) · talking head · 1165s · 16:9 · 301K views (quoting post) · [post](https://x.com/AndrewCurran_/status/2106231090113613844)
- **Hook (0-3s):** Frame 0 is the same purple-lit desk set as #3, the presenter with a hand to his chin. At ~2s a hard cut goes to a screen recording of a dark code editor with his webcam inset on the right. No title or captions.
- **Beats:** The sheet covers the first 240s. A brief to-camera open (0-2s) → the code editor scrolling through plan and spec files, webcam inset (2-150s) → a dark chat app with a long thread and a pink action button, inset (~155-240s) → spot checks past 240s: the chat app, more code, an article page and X posts, all with the inset (~260-1020s) → full-frame talking head for the close (~1100s to the end).
- **Ending:** talking head, arms folded on the desk; he finishes, nods and smiles. No card.
- **Look:**
  - Ground: dark home studio; dark-mode apps.
  - Palette: purple and navy with orange and blue practical lights.
  - Type: none added.
  - Fills frame: a screen recording across ~2/3 of the frame with the webcam inset overlapping its right edge.
  - Camera: locked off; no zoom on the screen.
  - Transitions: hard cuts (the dark cut at ~2s was missed by the detector).
- **Measured:** first 240s only: moving 86.5%, longest still 1.23s, 0 cuts/min detected (median shot 240s), loudness -18.3 LUFS.
- **Why it works:** The quoting post supplies the hook (praise for publicly changing one's mind, quoting his claim that a new Claude mode is superintelligence); the video is a long working session that's credible because the screen is real and unedited. Craft is not the reason for the reach, and the unzoomed code is unreadable on a phone.
- **Borrow:** when the proof is long, keep the speaker's face live on top of the real screen so reactions carry the dull stretches. **Don't copy:** the set or the layout.

### 8. @itsumeshk · UI-morph reel · 36s · 16:9 · 267K views · [post](https://x.com/itsumeshk/status/2103123541323596100)
- **Hook (0-3s):** Frame 0 is a dreamy, smeared still of a person at a desk with a laptop, split into chromatic fringes on a peach haze. By 1.0s it blurs further; at 1.5s the haze turns into a pastel gradient and a word types on in gradient letters, and by 2.5s a grey line says every day starts the same.
- **Beats:** the line (1.5-3s) → a glass 3D clock drops into the sentence (~3.4s) → app icons with red badge counts (Slack, Calendar, Gmail, a bell) orbit the clock (~5-8s) → tangled lines with dots (~10s) → the logo mark (~12s) → the title, Runable Scheduled Tasks (~14.6s) → a connected Gmail card whose three inbox rows flip to replied with green checks (~17-19s) → a Google Calendar card with an event being placed (~21s) → a phone showing a daily brief notification with meetings and leads (~23-26s) → bokeh dots, the mark in a glass circle (~28-30s) → a branching tree of task pills (email replies, morning brief, follow-ups, client meetings, inbox summaries, daily updates, new leads, weekly reports) checking off one by one (~32-34s).
- **Ending:** the finished tree dissolves to the dot mark at ~34.4s and the wordmark types on, complete by ~35.5s and held only ~0.5s. No URL or CTA.
- **Look:**
  - Ground: a soft, slowly drifting pastel gradient (peach, pink, mint).
  - Palette: pastels plus real app-icon colors and green checks.
  - Type: small light-grey geometric sans; the title in bold dark sans.
  - Fills frame: rebuilt UI cards (Gmail, Calendar, a phone notification) floating with soft shadows; a 3D glass clock.
  - Camera: a drifting virtual camera with slight push-ins; 60fps.
  - Transitions: dissolves and morphs only.
- **Measured:** moving 86.8%, longest still 1.03s, 0 cuts/min (one continuous piece), loudness -7.9 LUFS.
- **Why it works:** It sets up a feeling first (the same swamped morning, badge counts piling up), then shows three recognizable jobs done (replies sent, a meeting placed, a brief delivered) and ends on the whole tree of jobs that now run themselves. Every card is a result, not a settings screen; the 0.5s logo hold is too short to read.
- **Borrow:** the problem as one object (a clock swamped by notification badges); results as cards that flip to done; a closing tree of every job checking off. **Don't copy:** the pastel gradient, the glass clock, the mark.

### 9. @cleeeeeeeeement · screen capture · 6.4s · 16:9 · 232K views · [post](https://x.com/cleeeeeeeeement/status/2102767210758320413)
- **Hook (0-3s):** Frame 0 is a Google Search Console performance page at 0 clicks and 0 impressions with an empty chart. By 0.6s the totals read 307 and 17.1K and a line has started; by 2.5s it's past 1K clicks, with the cursor riding the tip of the line and a tooltip following it.
- **Beats:** one continuous climb: the totals tick up as the line draws left to right (0-6.4s) while keyword rows fill the query table below (~4-6s), finishing at 14.1K clicks and 961K impressions.
- **Ending:** no card; it stops mid-climb at the right end of the chart, and at 6.4s it simply loops on X.
- **Look:**
  - Ground: the light Search Console UI, full screen.
  - Palette: Google blue and purple metric tiles; blue and purple lines on white.
  - Type: UI only; no overlay.
  - Fills frame: one dashboard page.
  - Camera: static full-page capture, no zoom.
  - Transitions: none.
- **Measured:** moving 3.2% (the changes are too small to register at 160x90), longest still 2.2s, 0 cuts/min, no audio.
- **Why it works:** A number going up is the whole message, and it's the proof shot for a comment-to-get-the-setup post (in French: reply with a keyword and the system arrives by DM). Search Console doesn't animate its totals this way, so this is an edited reveal or a mock (unclear which), and without a zoom the numbers are tiny on a phone.
- **Borrow:** a 5-7s proof loop in which one metric climbs, with the camera zoomed onto the number. **Don't copy:** the dashboard, or any growth animation that implies real data it doesn't have.

### 10. @cocktailpeanut · other (TV clip) · 72s · 16:9 · 167K views · [post](https://x.com/cocktailpeanut/status/2100098315144602056)
- **Hook (0-3s):** One black frame, then a character in a maroon sweater stands in a kitchen holding a phone cabled to a laptop, presenting it to people off-screen. A static medium shot holds through 3s.
- **Beats:** the setup speech (0-11s) → an insert of the phone's camera over a hot dog on a plate (~11-12s) → a long reaction two-shot of two colleagues (~12-39s) → monitor inserts of the app: a pizza photo marked as evaluating, then a red X verdict (~40-50s) → reactions, a pair eating, a wide group shot around the table (~50-66s) → the two-shot (~69-72s).
- **Ending:** the clip ends mid-dialogue on the two-shot, held ~3.5s; no card.
- **Look:**
  - Ground: a cluttered, yellow-walled house kitchen (a sitcom set).
  - Palette: warm yellow with red and maroon wardrobe.
  - Type: none added; the app UI appears in-scene on a monitor.
  - Fills frame: actors, plus two app inserts.
  - Camera: TV coverage: medium singles, two-shots, a wide and inserts.
  - Transitions: hard cuts.
- **Measured:** moving 62.7%, longest still 2.4s, 12.5 cuts/min (median shot 3.5s), loudness -25.9 LUFS.
- **Why it works:** It's a joke, not a demo. Per the post, the sitcom Silicon Valley's yes-or-no food classifier predicted the decision model launched in the quoted video (#11); the audience already knows the scene, so recognition does all the work.
- **Borrow:** pair a launch with a widely known scene in the post's framing, as commentary rather than inside your own film. **Don't copy:** the footage (licensed TV) or anyone else's IP in a supermemory film.

### 11. @CompleteSkeptic (quoted video) · launch film · 176s · 16:9 · 167K views (same post as #10) · [post](https://x.com/cocktailpeanut/status/2100098315144602056)
- **Hook (0-3s):** Frame 0 is the founder standing in a warm wood-slat studio, smiling, in a tee with a joke slogan about neolabs. At ~1s it cuts to a soft profile close-up where a boxed monospace name tag types on (his name, then founder of TypeSafe AI), tied to him by a thin leader line; it's still typing at 2.5s. The same file is in batch 7-more-a as the founder's own post.
- **Beats:** name tag and intro (0-17s), with a white grid of frontier-lab logos (~10s) and a ChatGPT-style chat mock (~17-26s) → hot-pink halftone cards: stacked windows asking why not, then LM, LLM and RLHF lineage cards (~27-30s) → a black card listing failure modes one per line (~34s) → the founder in a new slogan tee almost every shot, with boxed callout labels on leader lines (~38-50s) → a System One card and an RLCD diagram on black (~52-58s) → a split-terminal race, TypeSafe against a GPT model (~64-72s) → word-by-word statements on black, a dot-grid sphere for parallel decisions, a list of three qualities (reliable, fast, self-consistent) (~88-105s) → a 99x-faster card with speed lines (~116s), a price chart whose Jev row reads $0.0 and FREE (~127s), an intelligence-versus-cost scatter (~131s) → the founder in a pink fur coat with a line about what you'll build with Jev (~136-139s).
- **Ending:** the logo mark on black (~139s), boxed labels about building product rather than god (~141s), then the mark in corner brackets over the URL typesafe.ai, held ~5s (~142.5-147.5s). Then comes a 28s pink DISCLAIMER card parodying drug-ad small print, its paragraph darkening word by word as it's read (~147.6-175s), and a ~0.6s fade to black; the last 4s are the finished disclaimer fading out.
- **Look:**
  - Ground: a warm amber wood-slat studio; hot pink with black halftone dots; pure black and white grids for type.
  - Palette: amber, hot pink, black, white.
  - Type: large white grotesk with boxed callouts and leader lines; monospace for tags and the DISCLAIMER label.
  - Fills frame: the founder for roughly half the runtime; mock UI (a chat, terminals), charts and type cards for the rest.
  - Camera: locked-off medium shots and profile close-ups with shallow depth; slow push-ins.
  - Transitions: hard cuts; type animates on.
- **Measured:** moving 58.1%, longest still 3.63s, 12.3 cuts/min (median shot 3.42s), loudness -19.5 LUFS.
- **Why it works:** Humor carries a dense technical claim: the slogan tee changes every shot, and the parody disclaimer restates the benefits as side effects, so the last 28s is a joke that repeats the pitch. Each hard number (the speed multiple, the free price row) gets a full card of its own.
- **Borrow:** a running visual gag (a wardrobe change per shot) to keep a founder monologue watchable; a read-along end card that turns the benefit list into a joke, placed after the URL lockup. **Don't copy:** the pink halftone look, the slogan tees, the disclaimer copy.

### 12. @everestchris6 · screen capture · 10s · ≈16:9 (1904x1080) · 141K views · [post](https://x.com/everestchris6/status/2099284683012121073)
- **Hook (0-3s):** Frame 0 is a dark dashboard already running: a lead-engine header with three counters (physical leads 173, digital leads 1,214, leads sold 135), a live clock, and three columns of cards. By 2.5s the columns have scrolled and the counters have ticked; nothing else changes.
- **Beats:** one continuous loop (0-10s): physical-lead cards (house photos tagged landscaping, solar, roofing, pool, fencing), digital-lead cards (a face thumbnail with a one-line pain quote) and sold-lead cards (company cards with prices) scroll upward, the active card outlined in red or blue. The counters reach 176, 1,227 and 141, and the clock runs from 05:12:41 to 05:12:54, 13s of clock in 10s of video.
- **Ending:** no card; the columns are still scrolling at the cut, so it plays as a loop.
- **Look:**
  - Ground: near-black dashboard panels.
  - Palette: dark grey, white text, red and blue outlines, green status text.
  - Type: small UI sans and mono; no overlay.
  - Fills frame: the whole dashboard, three dense columns.
  - Camera: static, no zoom.
  - Transitions: none.
- **Measured:** moving 62.9%, longest still 0.47s, 0 cuts/min, no audio.
- **Why it works:** It sells autopilot through constant motion and rising counters, so nobody needs to read a card to get it; the real payload is a linked guide (an X article). The density means nothing is readable on a phone.
- **Borrow:** a live counter row plus a running clock as proof that a system works on its own. **Don't copy:** the dashboard layout.

### 13. @gregisenberg · other (video podcast) · 2639s · 16:9 · 123K views · [post](https://x.com/gregisenberg/status/2085346429229252944)
- **Hook (0-3s):** Frame 0 is the host on a webcam in front of a wood bookshelf, mid-sentence. At 1s a yellow-outlined pill caption (marketing agents) appears at bottom center; by 2.5s it has grown into an equation built from pills, marketing agents = new coding agents.
- **Beats:** The sheet covers the first 240s. Equation hook (0-4s) → a title graphic on navy between two glowing arcs: coding agents create software, then marketing agents get customers, with a cursor icon (~4-15s) → a how-to-set-up bullet (~18s) → the host with keyword-colored captions (~19-23s) → a glitch flash (~24s) → split tiles with the guest's name in outlined green type (~25s) → teaser captions over screen shares (using Codex or Claude Code; 20 tools for marketing infrastructure) (~28-33s) → the conversation: split tiles on a pale dotted ground, full-frame guest, podcast pills for Spotify and Apple (~60-100s), a guest monologue (~140-205s) → dark slide cards with webcam tiles at the right, such as an old-versus-now card on targeting engagement signals instead of job titles (~215-240s) → spot checks show tool screen shares and process slides later on.
- **Ending:** a product site (Graphed, agents for marketing) with webcam tiles, then the two split tiles smiling for the last ~3s. No card.
- **Look:**
  - Ground: two home webcams (a bookshelf; a plain cream wall) on a light dotted canvas.
  - Palette: warm wood and cream with yellow and orange caption accents; dark slides with red, green and purple boxes.
  - Type: bold white captions with orange or yellow keywords, yellow pill captions, outlined green name type.
  - Fills frame: webcams for most of the runtime; screen shares and slide cards.
  - Camera: webcam framing with digital punch-ins and rounded split tiles.
  - Transitions: hard cuts and one glitch flash.
- **Measured:** first 240s only: moving 70.4%, longest still 1.47s, 5.2 cuts/min (median shot 5.29s), loudness -15.3 LUFS.
- **Why it works:** The first 4s turn the thesis into an equation you can read with the sound off, and the cold open promises concrete takeaways (tools, a setup) before the 44-minute conversation starts. The reach comes from the host's audience.
- **Borrow:** a thesis built on screen as an equation of caption pills; a 30s teaser that lists what you'll walk away with. **Don't copy:** the pill and caption styling, the show branding.

### 14. @sheemamoto · other (workshop recording) · 3369s · 16:9 · 101K views · [post](https://x.com/sheemamoto/status/2098107205233111494)
- **Hook (0-3s):** Frame 0 is a presenter on a dark stage in front of a big screen showing the SpaceX logo. By 0.5s a lime-and-black lower third names her as a SpaceXAI software engineer. She talks to camera, and nothing else changes by 3s.
- **Beats:** The sheet covers the first 240s. Stage intro with two-word captions in heavy outlined caps, one keyword in lime (0-28.6s) → a hard cut to a screen-shared whiteboard: a hand-drawn curve of trust against number of agents, a notes column, a webcam inset top-right, the lower third kept on (28.6-240s), with a GitHub contribution chart at ~232s (3000+ PRs in 5 months) → spot checks past 240s: an agent-friendly architecture doc and a ranked list of codebase rules, then full-frame webcam Q&A.
- **Ending:** a webcam close-up; captions thank everyone and say bye while she waves. No card.
- **Look:**
  - Ground: a dark stage for the intro, then a white digital whiteboard.
  - Palette: white and black with lime-green brand accents.
  - Type: heavy outlined uppercase captions two words at a time, the keyword in lime; a lime and black lower third.
  - Fills frame: the screen share for most of the runtime, with a small webcam inset; the stage intro and the Q&A are full-frame.
  - Camera: locked off; screen recording.
  - Transitions: one hard cut in the first 240s.
- **Measured:** first 240s only: moving 22.9%, longest still 1.57s, 0.2 cuts/min (median shot 211.4s), loudness -22.0 LUFS.
- **Why it works:** The post does the selling (an org chart of 20+ agents and a claim that only 1% of users use the tool right); the hour-long video is the proof. The constant captions keep a sound-off viewer reading while the whiteboard barely moves.
- **Borrow:** one hand-drawn chart (trust against number of agents) as the spine of a talk. **Don't copy:** the heavy outlined caption style, the event branding.

### 15. @Rasmic (quoted video) · UI-morph reel · 38s · 16:9 · 95K views (quoting post) · [post](https://x.com/Rasmic/status/2092761418365890727)
- **Hook (0-3s):** Frame 0 is near-black. By 0.5s a small pixel-art retro computer and a grey line, your agent has, appear; from 1.0s the bold second line swaps every 0.5s through what the agent lacks: memory, inbox, phone number, wallet (and hands by ~3.6s).
- **Beats:** the lack list (0.5-5s) → the product name with an alpha tag and a one-line promise (~6s) → a capabilities header with cards appearing one by one (memory, email, money, texting, a computer, sandboxes, connectors), then one highlighted white card for a single MCP URL (~8-13s) → "Setup is one paste.": a terminal types a connect-yourself prompt with a setup URL and a masked token, then green checks (fetched the setup, registered the MCP server, health check, tools listed) and a row of tool-name chips (~15-21s) → a line about tool servers waiting to be called is struck through and replaced by one about waking your agent: an iMessage question about a deposit, an event log line, typing dots, then a blue reply saying the payment went out that morning on the events card, receipt logged (~22-27s) → a row of runtimes (Claude Code, Codex CLI, Cursor, OpenClaw, eve) whose lines converge into one env-var pill (~29-33s).
- **Ending:** from ~33.5s an end card: the icon, a headline about giving your agent real capabilities, a subline listing them, and a button pill with the URL (bezalel.sh) that lights up white at ~34.5s; held ~3.5s, then a fade to black.
- **Look:**
  - Ground: flat near-black.
  - Palette: black, white and greys; green for checks and tool names; one blue chat bubble; the pixel icon's blue and teal.
  - Type: bold white sans headlines, grey sublines, monospace for the terminal and tool names.
  - Fills frame: centered type with small rebuilt UI (cards, a terminal, a chat thread) and lots of empty black.
  - Camera: none; elements fade and build in place.
  - Transitions: fades, a strike-through swap and converging lines; no hard cuts.
- **Measured:** moving 18.3%, longest still 3.87s, 0 cuts/min, loudness -8.7 LUFS.
- **Why it works:** The swapping noun lands the problem in 3s, and the setup beat shows the literal install (one pasted prompt, then checks), which is the strongest proof a developer tool can give. The iMessage exchange turns an abstract wake-on-event feature into one readable moment; the post names supermemory as its memory layer.
- **Borrow:** a swapping-noun lack list as the hook; the install shown as one pasted prompt followed by green checks; one event-to-reply exchange for background behavior. **Don't copy:** the pixel computer icon, the black card system, the copy.

### 16. @everestchris6 · screen capture · 11s · ≈16:9 (1908x1080) · 91K views · [post](https://x.com/everestchris6/status/2101706320261128398)
- **Hook (0-3s):** Frame 0 is a dark three-panel dashboard mid-run: a speed race between three model rows (Jev, Claude Haiku 4.5, a GPT model) with millisecond counters, a magenta radial gauge in the center panel with a task line and a cost, and a business photo with a customer quote at the right. By 1.0s the race counters jump past 1,986ms and the gauge sweeps; by 2.5s the next task (fetch a prospect's homepage) arrives at a cost of free.
- **Beats:** one decision cycle every ~2-3s (0-11s): a task line (pull pool-builder listings, fetch a homepage, fetch a county parcel record, fetch the same homepage again) → the three racers count up and the first finisher is outlined → the gauge sweeps and an allowed and refused tally updates → the business panel swaps (three heating-and-air firms, then a sign shop) with a price range; a wait-per-check area chart runs along the bottom.
- **Ending:** no card; it stops mid-cycle on a refused duplicate fetch and a sign shop's price range.
- **Look:**
  - Ground: near-black panels.
  - Palette: black and grey, magenta for Jev, orange and green for the other racers, a green and pink area chart.
  - Type: small mono UI; no overlay.
  - Fills frame: the whole dashboard.
  - Camera: static.
  - Transitions: none.
- **Measured:** moving 59.0%, longest still 0.43s, 0 cuts/min, no audio.
- **Why it works:** Same creator and visual system as #12. The race turns a speed claim into a head-to-head against named models, and every cycle shows a cost of free or a fraction of a cent; it's still too dense to read on a phone.
- **Borrow:** a three-lane race with live millisecond counters to prove a speed claim against named alternatives. **Don't copy:** the dashboard layout, the magenta gauge.

### 17. @brenhubr · product demo · 29s · ≈16:9 (3840x2156) · 62K views · [post](https://x.com/brenhubr/status/2071979004509221057)
- **Hook (0-3s):** Frame 0 is a macOS wallpaper (orange and blue rays) with a small black pill in the notch reading Fetching beside an app icon; at 0.5s it reads Editing. After a cut at 0.73s the notch has expanded by 1.0s into a black glass panel listing four sessions (Recipe Box, Budget Tracker, Notes App, Fable 6), each with a live status line, plus usage bars for Claude and Codex. By 1.5-2.5s a permission request with a code diff slides in, the cursor on Allow.
- **Beats:** the session list (~1-2s) → a permission request with code, Allow clicked (~2-3s) → a plan-approval card (~4.6s) → a big red denied state for one project (~6.4s) → an agent's multiple-choice question (which accounts, how far back) with a typed other answer and Send (~8-12s) → zooms on session rows and the refresh-usage control (~13-16s) → a usage panel with 5-hour and 7-day bars per tool (~17s) → a session waiting for your input, with its last reply (~19-23s) → per-session timers and stop buttons (~24s) → a list of local dev servers by port and framework (~26s) → folder shortcuts (skills, plugins, config, logs, root) for both tools (~28s).
- **Ending:** at ~29s the panel collapses back into the notch pill (Searching, 4 sessions), which is the opening state, so it loops. No CTA (the post asks for Product Hunt upvotes).
- **Look:**
  - Ground: a macOS gradient wallpaper.
  - Palette: a black glass panel on orange and blue; purple, green and orange status text; red and blue usage bars.
  - Type: monospace UI throughout; no overlay.
  - Fills frame: the notch panel, often cropped past the frame edges by the zoom.
  - Camera: tight cursor-following zooms and pans; 60fps.
  - Transitions: camera moves only (one cut at 0.73s).
- **Measured:** moving 89.4%, longest still 0.57s, 2.1 cuts/min (one cut; median shot 28.52s), no audio.
- **Why it works:** Every beat is a moment where an agent needs you (allow, approve, answer, waiting), which is exactly the product's job, and each one is cropped to the single control that matters. Ending back in the notch makes the loop seamless.
- **Borrow:** list the moments the product steps in and give each a 1-2s cropped close-up; end on the collapsed state that matches frame 0. **Don't copy:** the notch UI, the wallpaper.

### 18. @businessbarista (quoted video) · other (video podcast) · 947s · 16:9 · 45K views (quoting post) · [post](https://x.com/mattyp/status/2093800686723162155)
- **Hook (0-3s):** Frame 0 is the host talking to camera in an open office with a boom mic in front of him. By 2.0s a big glowing white bot-face icon swings in at the right, and from ~2.7s to 4.3s a burst of ~0.1s flashes shows web headlines and crypto price pages about a token that shares the bot's name (the confusing search results), before cutting back to the host.
- **Beats:** The sheet covers the first 240s. Host intro with the headline burst (0-5s) → the guest's X profile card pops in beside the host (~12s) → a pixel-art level card, EASY, with an orange bot sprite and glowing pixel type (~16-19s) → the guest in a dim room with string lights (~20-50s) → screen shares of the bot's chat app with the guest inset top-right: a demo thread, a long agent reply, a connector settings page (~50-115s) → yellow-bordered split tiles of host and guest on black (~140-160s) → more screen shares (a writing bot, a summary of how the bot helped) (~185-205s) → a spot check finds an INTERMEDIATE level card at ~282s.
- **Ending:** the yellow-bordered split tiles, both smiling, held ~4s. No card.
- **Look:**
  - Ground: a bright office (host) and a dim lamp-lit room (guest); a black dot-grid canvas behind the split tiles.
  - Palette: neutral office light, warm string lights, yellow tile borders, an orange pixel sprite.
  - Type: glowing orange pixel type for level cards; app UI otherwise.
  - Fills frame: webcams for most of the runtime; screen shares with a webcam inset.
  - Camera: webcams and a slightly moving host camera.
  - Transitions: hard cuts, plus the rapid flash burst in the hook.
- **Measured:** first 240s only: moving 51.6%, longest still 2.97s, 7.8 cuts/min (median shot 5.21s; 14 of the 31 cuts are the hook's flash burst), loudness -22.5 LUFS.
- **Why it works:** Game-style level cards (Easy, then Intermediate, climbing toward the God Mode named in the post) turn a 16-minute walkthrough into a progression you can track, and the headline burst acts out the confusion the episode clears up.
- **Borrow:** difficulty-level cards as chapter markers for a tutorial; a 1.5s flash burst of messy search results as the problem statement. **Don't copy:** the pixel sprite, the show's layout.

### 19. @zarazhangrui · product demo · 107s · 16:9 · 43K views · [post](https://x.com/zarazhangrui/status/2071766827345285411)
- **Hook (0-3s):** Frame 0 is a GitHub repo page (reading-block) in Chrome with a round-cornered webcam of the maker at bottom right. Through 2.5s only she moves; the screen is still.
- **Beats:** the repo page (0-12s) → a Google Calendar reading-block event whose description lists the saved links (~10-12s) → saving articles from a YouTube podcast page, a long-form article (a saved toast) and a product site (a toast saying a reading block was booked) (~13-34s) → the calendar event again, then the week view with the block in place (~34-50s) → extension settings: reading days, earliest and latest times, block length, saves per block (~55-65s) → the README's why and what sections (~68-93s) → SETUP.md, a one-time setup of about five minutes in two parts (~95-107s).
- **Ending:** she scrolls through the SETUP.md steps and back up to its title, held ~1-2s; no card.
- **Look:**
  - Ground: real full-screen Chrome with a green-tinted vertical tab sidebar.
  - Palette: white GitHub and Calendar UI with Calendar's blue and green blocks.
  - Type: UI only.
  - Fills frame: the real screen plus a rounded webcam inset at bottom right.
  - Camera: static full-screen capture, no zoom.
  - Transitions: 4 hard cuts.
- **Measured:** moving 7.9%, longest still 7.6s, 2.2 cuts/min (median shot 9.0s), loudness -12.9 LUFS.
- **Why it works:** It runs the promise literally (save articles, and a block with the links inside appears on the calendar), then ends on the setup doc so the viewer knows the cost of trying it. Without any zoom, the toasts and calendar text are too small on a phone.
- **Borrow:** show the trigger, the confirmation toast and the resulting object in another app (a calendar event holding the links); end on the setup instructions. **Don't copy:** the uncropped full-screen layout.

### 20. @DhravyaShah · talking head · 63s · 16:9 · 30K views · [post](https://x.com/DhravyaShah/status/2002194849332957309)
- **Hook (0-3s):** supermemory's own. Frame 0 is an empty San Francisco street with cable-car tracks. By 0.5-1.0s the founder walks into frame from the right holding a mic; by 2.0s he faces camera and a small boxed caption starts his line about book-a-demo buttons. At ~3.7s a huge censored swear word slams in, white on black.
- **Beats:** the street setup (0-3.7s) → the censored-swear card (~3.7-6.8s) → sitting on a ledge, saying they replaced theirs (~8s) → the site's Talk to founder button (~9-10s) → walk-and-talk along the waterfront and the Ferry Building, one location per idea, listing who he likes talking to (people building cool agents, founders, engineers, anyone with a wild idea) (~12-27s) → a close-up of his hoodie's back, printed with the brand word unforgettable (~28.8s) → if you're on our website, come talk to me (~34-40s) → no sales script, then a meme insert (a kid doing a double take) for the joke that there is one (~41-44s) → just a real conversation about memory (~50s) → the supermemory homepage (~57s).
- **Ending:** on the pier he says let's talk (~58.4-59.7s) → a black card adding for real (~59.7-60.6s) → a blue gradient card telling you to visit the website (~60.6-61.5s) → the supermemory logo lockup on blue, held ~1s.
- **Look:**
  - Ground: the overcast SF waterfront: streets, the Ferry Building, the Bay Bridge.
  - Palette: a muted teal-grey grade, a black hoodie; brand blue for the end cards.
  - Type: small white captions in black boxes; giant heavy white sans for the swear card; white sans on blue at the end.
  - Fills frame: the founder for most of the runtime; site captures and one meme insert.
  - Camera: handheld wide-angle, walking backward with him; a few close-ups.
  - Transitions: hard cuts, roughly one per line.
- **Measured:** moving 72.9%, longest still 1.13s, 20.1 cuts/min (median shot 2.33s), loudness -13.5 LUFS.
- **Why it works:** It turns a website button into a personal promise: the founder, in the city, telling you he'll answer. The profanity card is a pattern break at 4s, the hoodie close-up plants the brand word, and every location change carries a new line, so a 63s monologue never sits still; the 1s logo hold is short.
- **Borrow:** one location per sentence for a founder piece; a shock card inside the first 5s; a stepped close (spoken line, short card on black, website card, logo). **Don't copy:** the swear card in a formal launch, or the meme clip (rights).

### 21. @DhravyaShah · screen capture · 34s · ≈1.65:1 (3398x2062) · 21K views · [post](https://x.com/DhravyaShah/status/2069232087929156006)
- **Hook (0-3s):** supermemory's own. Frame 0 is the top of a blog post, Memory on the harness level, with a date, a one-paragraph standfirst, a listen-to-this-post audio player and the opening paragraphs. The page is still until ~2.5s, when the scroll starts.
- **Beats:** intro (0-3s) → a section on the context window (~3s) → Part 1, Remembering: a box diagram of the agent's main loop and a vector store joined by remember and recall arrows (~5s) → explicit versus implicit approaches (~7s) → interactive side-by-side chats, an explicit remember() tool against an implicit observer, the cursor clicking a next-turn button as each memory block updates (~9-16s) → a scatter of where each strategy lands (~18s) → the recall side of the same conversation (~20-24s) → a section arguing for a profile (~26s) → putting it together (~28s) → the same question answered with retrieval only and with a user profile (~29-31s) → how supermemory does it, ending on a playground screenshot (~31-34s).
- **Ending:** a ~1.5s hold on the playground screenshot and a closing line about the substrate. No card.
- **Look:**
  - Ground: a white page with a left table-of-contents rail.
  - Palette: black text on white; blue and red diagram boxes; green and orange buttons in the demos.
  - Type: the blog's sans with monospace labels.
  - Fills frame: a centered page column with interactive widgets.
  - Camera: a continuous scroll with the cursor clicking widgets; no zoom.
  - Transitions: none.
- **Measured:** moving 47.1%, longest still 2.03s, 0 cuts/min, no audio.
- **Why it works:** The widgets are the hook: memory being written and recalled turn by turn, with nobody narrating. As a video it scrolls fast and stays small, so it works as an invitation to open the post rather than as an explanation.
- **Borrow:** the two-pane, same-conversation comparison (explicit against implicit memory), stepped turn by turn, as a film beat: it's a ready-made memory lane. **Don't copy:** the uncropped scroll layout.

### 22. @0xSero · ad · 49s · 16:9 · 17K views · [post](https://x.com/0xSero/status/2070577007373562150)
- **Hook (0-3s):** Frame 0 is a woman in a striped shirt sitting under a tree with a laptop, laughing at camera, with a small Cerebras bug at top right. At 0.5s a serif caption says hi; by 1.5s the caption has her introduce herself as the DevX community lead.
- **Beats:** the intro (0-4.4s) → an excited-to-announce line (~4.6s) → a burst of blurred event photos at ~0.25s each, under a line about searching worldwide (~7.7-11.6s) → a group photo of community gatherers (~10.7s) → a close-up: food and venue budget covered (~13.8s) → a kaleidoscope mirror effect (~16.8s) → the Cafe Compute coffee-cup logo on orange-red (~19.9s) → meetup photo cards fanning in by city (~22.9s), city names cycling with emoji, your city next (~26s) → a URL bar typing cerebras.ai/ambassadors (~29s) → a browser mock of the Ambassadors page, with a promise to read every application (~32s) → she walks to the Cerebras office door (~35-44s).
- **Ending:** from 44.2s an end card: Apply at, the URL large in orange beneath it, Powered by Cerebras at bottom right, orange halftone in the corners of a light-grey ground; held ~4.7s to the end.
- **Look:**
  - Ground: a sunny campus and office exteriors; cream and light-grey graphic cards.
  - Palette: brand orange-red and cream, echoed by the host's striped shirt.
  - Type: classic serif captions at bottom center; a geometric sans on the end card; monospace labels.
  - Fills frame: the host for about half the runtime; photo bursts and graphic cards.
  - Camera: handheld, with a follow shot to the door.
  - Transitions: hard cuts, 0.25s photo bursts, a kaleidoscope effect.
- **Measured:** moving 54.6%, longest still 4.63s (the end card), 50.2 cuts/min (median shot 0.27s, from the photo bursts), loudness -20.1 LUFS.
- **Why it works:** A real person makes a program announcement feel human, the 0.25s photo bursts prove the meetups already happen, and the URL appears three times (typed into a URL bar, on a page, on the end card), so nobody misses the ask.
- **Borrow:** type the CTA URL into a browser bar mid-film, then hold it large on the end card for 4-5s. **Don't copy:** Cerebras orange, the coffee-cup mark, the footage.

### 23. @orchid_hq (quoted video) · launch film · 102s · 16:9 · 15K views (quoting post) · [post](https://x.com/DhravyaShah/status/2092663207014076437)
- **Hook (0-3s):** Frame 0 is dark wood floorboards with a slant of sunlight near sheer curtains. At 1.0s a tiny monospace subtitle appears (as a founder, her morning starts with two things); at 1.5s a cut to sunlit curtains; by 2.0s a wide of a woman at a tall loft window, drinking.
- **Beats:** a morning montage at ~0.4s per shot: lipstick, an earring, heels, coffee poured into a glass (~2.6-6s) → at her desk, message cards float in around her (a restock request, a wholesale order, a customer asking about delivery) (~7-10s) → a giant 09:42 clock overlay counting 18 minutes to a client call (~15s) → three photo cards of her, captioned that they all need her (~22s) → a peephole-vignette shot with a wholesale chat card (~28s) → her phone face down and a closed laptop (~35-41s) → "WHAT IF I JUST MADE ANOTHER ME?" in large serif caps (~47s) → she types agent briefs that appear as single serif lines over the footage: help customers in iMessage from the Shopify catalogue, answer the team in Slack from company data, find creators on Instagram (~60-69s) → results: a phone mock with an influencer photo and an iMessage reply that tracking was sent, while she reads on the floor (~79s) → smiling at her phone (~86s).
- **Ending:** a smiling profile, then a hard cut at 99.5s to black with a white rocking-horse logo and the URL Onkeiki.com in serif, held ~2s with a fade at the very end.
- **Look:**
  - Ground: a warm, filmic industrial loft with tall windows and sheer curtains.
  - Palette: amber wood, cream and a black blazer; desaturated and filmic.
  - Type: an elegant high-contrast serif for big statements and the agent briefs; tiny monospace subtitles.
  - Fills frame: one actor-founder throughout; UI only as floating message cards and typed lines.
  - Camera: cinema grade: shallow depth, slow push-ins, mirror and peephole shots.
  - Transitions: hard cuts, fastest in the opening montage.
- **Measured:** moving 75.9%, longest still 1.03s, 27.7 cuts/min (median shot 0.63s), loudness -18.8 LUFS.
- **Why it works:** It sells another-me as a feeling first (the overloaded morning, the countdown) and shows the product only as one typed sentence per agent, so the UI never breaks the film. Dhravya's quote notes it runs on supermemory.
- **Borrow:** the agent's brief typed as one line of text straight over live footage instead of a cut to a UI; a countdown overlay to set the stakes. **Don't copy:** the loft, the serif look, the rocking-horse mark, the actor.

### 24. @orchid_hq (quoted video) · launch film · 102s · 16:9 · 12K views (quoting post) · [post](https://x.com/maxktz/status/2092660494893015484)
- **Duplicate:** the same file as #23 (identical checksum), quoted by a different account whose post is a single word. The hook, beats, ending, look and measurements are identical: see #23.
- **Measured:** moving 75.9%, longest still 1.03s, 27.7 cuts/min (median shot 0.63s), loudness -18.8 LUFS.

### 25. @askOkara · product demo · 74s · ≈1.66:1 (1788x1080) · 9.6K views · [post](https://x.com/askOkara/status/2082346733733023871)
- **Hook (0-3s):** Frame 0 is a browser window floating on a light-grey canvas with a soft shadow, showing a landing page that introduces Okara as an AI CMO, with a website-URL input. By 1.0s the cursor is on the input; at ~1.45s the go-to-dashboard button is pressed; by 2.0s a black log header prints loading lines over a skeleton, and by 2.5s the dashboard is filled in (traffic numbers and a chart).
- **Beats:** landing → dashboard (0-3s) → a competitor-analysis document slides in from the right (~7s) → a brand-voice document (~11.6s) → a dashboard tour: analytics tabs, a GEO checklist, an agents feed with a dozen agent rows (~16-35s) → a GEO citation-gap report (~39s) → an SEO and GEO recommendations doc with code steps (~44s) → agent-feed items expanding into drafts (~48-53s) → an articles doc (~58s) → a LinkedIn-writer doc (~63s) → a generated UGC-style talking video with its script (~67-71s) → back to the dashboard as the cursor opens the video agent's item (~72-74s).
- **Ending:** the dashboard with the cursor moving; no card and no URL (the post carries the URL).
- **Look:**
  - Ground: a light-grey canvas with the browser window and its drop shadow, often cropped by zoom.
  - Palette: white UI, a black log header, small colored agent icons.
  - Type: UI only.
  - Fills frame: real product capture, with documents sliding in as right-hand panels.
  - Camera: zooms and crops on the window that follow the cursor.
  - Transitions: 20 jump cuts between states, plus slide-in panels.
- **Measured:** moving 75.7%, longest still 0.67s, 16.2 cuts/min (median shot 1.9s), loudness -16.8 LUFS.
- **Why it works:** URL in, dashboard out proves the drop-your-site promise in 2.5s, and the sheer volume of finished artifacts (reports, recommendations, posts, a video) is the argument. It's a fast skim with no hero output, so no single result can be read.
- **Borrow:** open on the one input (a URL field) and cut straight to the populated result. **Don't copy:** the Okara UI.

### 26. @juliafedorin (quoted video) · other (event interview) · 386s · 16:9 · 7.9K views (quoting post) · [post](https://x.com/DhravyaShah/status/2078194353261183077)
- **Hook (0-3s):** The same file as batch 3-code-craft #27 (Julia's own post); here it's the clip Dhravya quoted. Frame 0 is a two-shot on a grey sofa by a bright window, Dhravya holding a small mic; by 0.25s a boxed serif caption carries his line that they were only doing memory. At ~2s a halftone dot dissolve leads into B-roll of someone at a monitor with a memory-graph icon over their head.
- **Beats:** The sheet covers the first 240s. The first ~60s cut fast between the conversation and supermemory's own brand assets: the logo orbited by app icons on blue (~8s), a blue tagline card built on the word unforgettable (~15s), a three-card storage, structure and process diagram (~21s), a dark setup doc (~27s), a content-to-living-graph pipeline (~43s), the homepage (~50s), a graph UI page (~52s) → from ~60s, an uncut two-shot conversation with captions through 240s (spot checks show the same through ~360s).
- **Ending:** the two-shot as he sums up that doing six things at once sorts you, then a casual so-yeah caption; no card and no hold.
- **Look:**
  - Ground: a bright event venue with trees outside.
  - Palette: natural daylight; supermemory blue in the inserts.
  - Type: boxed white serif captions, centered low; a Composio watermark at top right.
  - Fills frame: the two-shot for most of the runtime; brand inserts in the first minute.
  - Camera: handheld, with reframes.
  - Transitions: halftone dissolves and hard cuts.
- **Measured:** first 240s only: moving 76.5%, longest still 1.73s, 4.0 cuts/min (median shot 3.5s; all 16 cuts fall before ~60s), loudness -24.2 LUFS.
- **Why it works:** The editor illustrates each claim in the first minute with the company's own visuals, then trusts the conversation. This adds to the earlier note: the inserts are supermemory's own marketing assets, which is why the cut rate is front-loaded.
- **Borrow:** a first minute in which every claim gets a product visual, followed by an uncut conversation. **Don't copy:** the footage, the watermark.

### 27. @askOkara · product demo · 29s · ≈1.65:1 (1784x1080) · 5.7K views · [post](https://x.com/askOkara/status/2085005974923096068)
- **Hook (0-3s):** Frame 0 is a browser window on white showing a Twitter Agent landing page with a URL input; the cursor presses the dashboard button by ~1.0s. A cut at 1.32s shows the dashboard loading (a black log header over a skeleton), and by 2.5s it's filled in, the cursor on the X agent's row.
- **Beats:** landing → dashboard (0-2.5s) → the X agent card (post in your voice daily) and its set-up button (~4.6s) → a start-with-your-posts step where a handle is typed (~6.4s) → reading your posts, with a checklist ticking (~8-12s) → rate 5 drafts: the cursor upvotes drafts one by one (~13-21s) → a review of the generated voice system prompt (~23s) → brand voice saved, with a connect-your-X-account button (~24.6s) → the panel closes and the camera pulls back to the whole window (~27-29s).
- **Ending:** the zoomed-out full dashboard with the cursor for ~2s; no card.
- **Look:**
  - Ground: a white canvas with the browser window and a soft shadow.
  - Palette: white UI, a black header, green checks, the X logo.
  - Type: UI only.
  - Fills frame: the right half of the app, zoomed, for most of the runtime.
  - Camera: a zoomed crop that follows the right-hand panel, then a final pull-back to the whole window.
  - Transitions: one cut, otherwise camera moves.
- **Measured:** moving 34.0%, longest still 1.73s, 2.1 cuts/min (one cut; median shot 27.83s), no audio.
- **Why it works:** Unlike #25 it does one task end to end (handle in, posts read, drafts rated, voice saved), which is exactly the v2 claim that it learns your voice from your past posts. The rating step shows the learning happening on screen.
- **Borrow:** a visible training step (rate the drafts) as proof that the product learns from you; a pull-back to the full app when the flow ends. **Don't copy:** the Okara UI.

### 28. @eersnington (quoted video) · product demo · 49s · ≈1.54:1 (1664x1080) · 3.5K views (quoting post) · [post](https://x.com/DhravyaShah/status/2065949081873326184)
- **Hook (0-3s):** Frame 0 is a Mac desktop inset in a blue gradient frame, showing a dark web app's integrations page (Executor, on localhost) with a sidebar of connected integrations. By 1.5s the cursor clicks a green Connect button; by 2.5s a connect-an-integration modal is open and the camera starts zooming in.
- **Beats:** the integrations page (0-2s) → modal search: super is typed and Supermemory appears as a popular integration (~3-8s, zoomed) → an Add Supermemory form with display name, namespace and a default container tag, plus a red banner saying the name already exists (~10-13s) → an add-connection dialog offering a cloud API key, local with no auth, or a local API key (~14-17s) → connection added, with Local Supermemory listed (~20-23s) → a switch to a terminal coding agent, asked to use the executor MCP to learn how to use supermemory (~24s) → it searches its tools, finds two Supermemory recall tools, describes the typed one's input shape and writes usage examples (~26-47s).
- **Ending:** the agent concludes that the typed recall tool is the better one, with a 24.4s run timer; held ~2s; no card.
- **Look:**
  - Ground: a macOS desktop inside a blue gradient border.
  - Palette: dark app UI with green buttons; a dark terminal with green, orange and purple syntax; the blue frame.
  - Type: UI only.
  - Fills frame: real capture, a browser and then a terminal.
  - Camera: zooms onto the modal and the form, then back out; static on the terminal.
  - Transitions: an instant window switch (no cut detected).
- **Measured:** moving 20.4%, longest still 3.43s, 0 cuts/min, silent audio track (-70 LUFS).
- **Why it works:** It's the install shown literally, followed by the payoff: an agent discovers supermemory's recall tool on its own and explains how to call it. The red already-exists banner is left in, which reads as unstaged; the silent track means it needs captions or sound to work in a feed.
- **Borrow:** install in a GUI, then hand off to an agent in a terminal that finds and uses the new tool by itself, and let the agent's own summary be the last line. **Don't copy:** the Executor UI.

### 29. @Muskanjain0401 (quoted video) · other (founders-at-work clip) · 9.0s · 16:9 · 1.2K views (quoting post) · [post](https://x.com/kavishshahh/status/2089964653296456009)
- **Hook (0-3s):** The same clip as batch 1-reels-a #4 (the original launch post, 2.60M views), also quoted in batch 9-more-c; here a 1.2K-view quote post calls it good marketing for her own brand and the company. Frame 0 is two co-founders at laptops in a bright café, shot low from behind two laptop lids. Nothing changes by 3s: they type.
- **Beats:** one candid take: typing, a glance, passers-by in the background (~4-7s).
- **Ending:** no card; the take ends mid-typing.
- **Look:**
  - Ground: a café with arched mirrors and shelving, in daylight.
  - Palette: teal glass, navy and black clothing, warm wood.
  - Type: none.
  - Fills frame: live footage only.
  - Camera: static, low angle, with the laptop lids framing the foreground.
  - Transitions: none.
- **Measured:** moving 100% (a static-looking shot, probably drift or grain), longest still 0s, 0 cuts/min (one 9s shot), loudness -8.3 LUFS.
- **Why it works:** As noted in batch 1, the post copy (an auto-apply feature list) does the selling and the clip puts real faces on it; the quoting post reads it as personal-brand marketing. The frames alone explain nothing about the product.
- **Borrow:** anchor a text-led launch post with a short candid founder clip from a low, over-the-laptop angle. **Don't copy:** the footage.

## Batch patterns

- **Formats (29 entries, 28 unique files):** 9 other (sit-down interview, conference fireside chat, two video podcasts, workshop recording, event interview, TV clip, phone-filmed screen, founders clip), 6 product demos (OpenAI Agents API, the notch app, Reading Block, Okara ×2, Executor), 4 screen captures (Search Console, two lead dashboards, the harness blog), 3 talking heads (atmoio ×2, Dhravya), 3 launch films (Jev, Keiki ×2 as a duplicate), 2 UI-morph reels (Runable, Bezalel), 1 explainer (Founders Inc build log), 1 ad (Cerebras). Nine run past 240s, so their sheets and metrics cover only the start. No competitor videos.
- **Hooks that recur:**
  - Long-form opens on a trailer: Molly (50s of money figures and pull-quotes), Greg (an equation in caption pills, then a title graphic), 0xMovez (a 28s captioned highlight), Founders Inc (a 50s kinetic cold open), Julia (product inserts throughout minute 1).
  - Input to result inside 3s: Okara ×2 (URL field to filled dashboard by 2.5s), the notch app (pill expands into the session list by 1s), Executor (Connect clicked by 1.5s).
  - A problem line built word by word: Runable (every day starts the same), Bezalel (your agent has no memory, no inbox, swapped every 0.5s), Keiki (a founder's morning).
  - A system already running at frame 0 with counters ticking: Search Console, both lead dashboards.
  - People on camera with nothing but a name super (OpenAI, the workshop) or no text at all (atmoio ×2, the Muskan clip): this works only with big reach or a strong post caption.
- **Pacing per format (medians from the metrics):**
  - Product demos: 62s, 41.5% moving, 2.2 cuts/min (OpenAI 8.3 and Okara 16.2 are the cut-heavy ones). Screen captures: 11s, 53% moving, 0 cuts. UI-morph reels: 36-38s, 0 cuts, both mastered loud (-7.9 and -8.7 LUFS).
  - Live-action films cut hard: Keiki 27.7 cuts/min (median shot 0.63s), Jev 12.3, Dhravya 20.1, Founders Inc 22.5, Cerebras 50.2 (0.25s photo bursts).
  - Long-form, first 240s (n=9): 71.7% moving, 4.0 cuts/min, -19.9 LUFS. The cuts cluster in the trailer: Molly 24 of 28 in the first minute, Julia 16 of 16, the Grok Bot episode 14 in one 1.5s burst.
  - 10 of 28 files have zero detected cuts, and 16 run at ≤2.2 cuts/min. The longest still is ≤3s in 22 of 28; the exceptions are Reading Block's static screen (7.6s), Cerebras's end card (4.6s), Founders Inc (3.9s), Bezalel's type cards (3.9s), Jev (3.6s) and Executor (3.4s).
  - Loudness: a median of -18.8 LUFS across 21 audible tracks. The loudest are short motion or social clips (Runable -7.9, the Muskan clip -8.3, Bezalel -8.7, Evan's clip -11.0); talks and interviews sit between -15 and -26. Six files have no audio track and one has a silent track.
- **Transitions and camera:**
  - UI films move with the camera: cursor-following zoom crops (the notch app, Okara ×2, Executor), dissolves and morphs (Runable), in-place fades and a strike-through swap (Bezalel).
  - Live action moves with cuts: Keiki's 0.4s getting-ready montage, Founders Inc's whip pans, Dhravya's one location per line, Cerebras's photo bursts, halftone dissolves in Julia's interview.
  - Unzoomed full-screen captures (Search Console, Reading Block, both dashboards, the blog, atmoio's code) are unreadable on a phone. That is the main craft failure in this batch.
- **Type and color:** two-tier pull-quote captions with a small lead-in over a big italic serif payoff (Molly); boxed callouts on leader lines (Jev); a high-contrast serif typed over footage (Keiki); lowercase chapter cards on white (Founders Inc); pixel level cards (Grok Bot); outlined caps with one lime keyword (the workshop). The grounds are owned and consistent within each film: pastel gradient (Runable), flat black (Bezalel), hot-pink halftone (Jev), filmic amber loft (Keiki).
- **Endings and CTAs (28 unique):** 14 have no card and end on footage or UI; 5 put a URL on the end card (Founders Inc ~3s, Jev ~5s before its disclaimer gag, Bezalel ~3.5s as a lit button pill, Cerebras ~4.7s, Keiki ~2s); 4 end on a logo only (OpenAI ~1.3s, Runable ~0.5s, AI Ascent ~5s, Dhravya ~1s after spoken and carded CTAs); 4 loop (the notch app collapses to its frame-0 state; Search Console and both dashboards just cut); 1 ending is unseen (Molly's truncated file).
- **Top-viewed (≥400K: OpenAI 1.92M, Evan 1.19M, atmoio 850K, Molly 678K, 0xMovez 471K, Founders Inc 401K):**
  - Mostly reach and topic, not craft. Four of the six run 7 minutes or longer (median 692s, against 56s for the other 22), and Evan's clip doesn't show what its caption claims. The Spearman correlation between views and duration is 0.32, and between views and moving % only 0.18.
  - What they share anyway: a known face or account, a big topic named in the post (a new API or model, a valuation, Claude Code's creator, a 1B-token context), and in the crafted ones a single spine: OpenAI's one incident, the Molly and Founders Inc trailer cold opens.
- **Lessons for her launch films and supermemory videos:**
  1. Show the install, then let an agent use it. Executor (#28) and Bezalel's setup-in-one-paste with green checks (#15) are the strongest proofs for a developer tool: paste the plugin or MCP command, then show the agent calling recall by itself.
  2. Make memory visible as a two-pane, same-conversation comparison stepped turn by turn (#21's widget), or as a training step the viewer watches (#27's rate-five-drafts). Both are ready-made memory lanes.
  3. Explain with a hand-drawn build: Founders Inc's overhead whiteboard turns similarity search into a graph of linked facts, stroke by stroke. A code-rendered version of that drawing is a clean memory-graph beat.
  4. Put the agent's brief on screen as one typed line over the scene (Keiki) rather than cutting to a full UI; the film stays a film and the product still speaks.
  5. Anything over 2 minutes needs a 30-50s trailer cold open of the best numbers and lines (two-tier captions), then chapter or level cards to show progress.
  6. Zoom onto the one control or number per beat. Every unzoomed capture here failed on a phone; the notch app and Okara v2 crop onto exactly what changes.
  7. Hold the URL for 3-5s and show it more than once (Cerebras types it into a URL bar, then holds it 4.7s). Runable's 0.5s logo and Dhravya's 1s logo are too short to register.
  8. A joke can carry the pitch (Jev's parody disclaimer restates the benefits as side effects), but put the URL lockup before the joke, as Jev does.
