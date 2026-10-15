# Batch 13: videos she sent with "learn this" (October 2026)

**Method:** videos she sends after the bookmark study (batches 1 to 12) land here.

**How each one is studied:**
- In the built-in browser from the post's mp4 URL, without downloading a file.
- Frames are drawn to a canvas and read in contact sheets of 16 tiles: a 3s overview, then 0.75-0.8s detail.
- "Measured" is the `qa.md` 2.3 metric rebuilt in the page: 30 fps samples, 160x90 luma, and the mean absolute difference scaled to limited range. A frame is "moving" at 0.15 or more. A cut is a difference over 6 and 3x both neighbours.
- Audio was not heard.
- Colours are sampled from the decoded 1080p frames.

### 1. @workersio · launch film · 45.4s · 16:9 (4K source) · 60.6K views · [post](https://x.com/workersio/status/2107923334134710653)

**Context:**
- Posted 2026-10-07; studied 2026-10-10.
- The account had 1,015 followers, so reach was about 60x. 711 bookmarks (1.17% of views) and 623 likes.
- It is the YC-backed company's launch post: a founder-voice launch letter ("Introducing Workers IO …") with the film attached.

**Hook (0-3s):**
- Frame 0 is one orange square (`#FC6D01`) on pure white with a faint dot grid.
- By 0.8s a counter reads "2 futures" (the number in orange), with two short op rows branching from the square.
- At 1.55s it reads "256 futures" over a wall of tiny rows.
- At 2.3s it reads "2,097,152 futures" over a wall of blocks filling the frame (2^1 → 2^8 → 2^21).
- The scale of the problem is a number that explodes in under 2.5s.

**Beats:**
- **3-6s:** the wall thins and the camera dives into one row, a single "future": `# c7a9…` → partition (orange) → put x → ack. Then it resets to the lone square.
- **6-8s:** testing today: `test_put ✓`, `test_get ✓` chips appear one by one; one path, green.
- **8-14s:** operations become coloured pills ("1 put x" blue, "2 get x" lavender, "3 del x" mint, number tabs in coral). They shuffle into a staircase (events arriving in the wrong order), snap into one horizontal timeline, and the camera pans along it as it grows.
- **14-18s:** the timeline becomes a branch tree with hash ids (`d7f1b2c7`…). "Inject faults into every branch." types in at top left ("faults" orange). Fault pills (kill leader, slow disk, partition, torn write) land on the branches.
- **18.5-22.5s:** "At the worst possible moment." The camera pushes into one partition pill until it fills the frame. A mono HUD reads "virtual time 00:00:18.836 +10s", then "+30s", then "01:00:41 +1h" (orange digits): time compression shown as a counter.
- **23-29s:** "Millions of futures all at once." The camera pulls back from the tree to a wall of rows. The wall tilts into a 3D plane receding to the horizon. Three scenario chips fill up at the top, and the plane's rows turn green as they pass.
- **29-32s:** one orange dot in the plane. "Data loss. Found." ("Found" orange). The camera dives into the failing timeline.
- **32-35s:** "Same seed, same bug, every time." The failing timeline repeats in identical rows (determinism, shown as repetition).
- **35-40s:**
  - A dark terminal card slides up under the timeline: the replay command, then a red line naming the bug.
  - "Fix it, replay it, ship it." builds word by word; the terminal turns green.
  - The timeline ends in a green pill.
- **40.6-42.2s:** back to the lone orange square, which morphs into the black W mark. The "Workers IO" wordmark slides out beside it.

**Look:**
- **Ground:** pure white `#FFFFFF` with a faint dot grid, which reads as a technical canvas without lines.
- **Palette:**
  - One accent, orange `#FC6D01`, for the system and every key word.
  - Op pills are soft gradients: sky blue `#50B0F0`→`#A0D0F0`, lavender `#A080F0`→`#C0B0F0` and mint `#50D0A0`, with coral `#F05050` number tabs.
  - The terminal is the only dark object.
- **Type:**
  - A clean grotesk for headlines: small, about 40px at 1080, top left, black, one or two words in orange.
  - Headlines build word by word, each word rising onto the baseline.
  - Mono for ids, labels and the HUD.
- **What fills the frame:** an invented but concrete product vocabulary (op pills, hash ids, fault pills, a seed, a replay command). It is never a screenshot, yet it reads as the real system.
- **Camera:** one virtual camera that dives, pans along timelines, pulls back and tilts the wall into 3D. Scale is the storytelling tool: one future, then millions.
- **Transitions:** no hard cuts at all; every change is a camera move or a morph.

**Ending:**
- The opening square returns and becomes the logo mark (a bookend morph), then the wordmark slides out.
- The lockup holds 3.2s on white.

**Measured:**
- Moving 72.1%, zero hard cuts.
- Longest still before the end card 0.87s (10.9-11.7s); end hold 3.17s.
- Motion per second peaks in the hook (7.5, 5.9 and 5.6 in seconds 1-3) and in the pull-back to "millions" (11.8, 8.6 and 5.9 in seconds 23-26).
- Mean luma 194-255 (white throughout).
- Loudness not measured.

**Why it works:**
1. **The problem is a number you watch explode** (2 → 2,097,152 in 2.3s), so the viewer feels why testing every path by hand is impossible before any words appear.
2. **One object carries the film.** The orange square is the system at the start, the failure in the plane and the logo at the end, so the brand mark literally is the thing being tested.
3. **The copy is a run of short, parallel lines**, two of them tricolons ("Same seed, same bug, every time." / "Fix it, replay it, ship it."). Each one is acted out by the picture as it types.
4. **Credibility comes from a made-up but consistent vocabulary** (hash ids, seeds, virtual time, a replay command): technical enough for engineers, simple enough to follow without reading it.

**Borrow:**
- the bookend survivor object that becomes the logo mark;
- the exploding counter hook in the first 2.5s;
- headlines that build word by word with one accent word;
- the tricolon close before the lockup;
- scale shown by a camera move (one row → a wall → a 3D plane);
- a mono HUD counter for time or volume;
- a dark terminal card as the single proof shot;
- zero hard cuts.

**For supermemory:**
- The blue tile could be the survivor, so a lone memory dot becomes the mark at the end.
- "2 memories → 256 → 2,097,152" could be the counter, over a wall of facts.
- "Same user, same fact, every agent." style tricolons.

**Don't copy:** the orange, their pill gradients, the W mark, the grotesk. The supermemory surface (Geist, hairline cards, one blue) always wins.

### 2. @rajzmotion · launch film (motion designer showcase) · 29.5s · 16:9 · 130K views · [post](https://x.com/rajzmotion/status/2109273645654888831)

**Context:**
- Posted 2026-10-11 by a motion designer with 1,372 followers (about 95x reach). 1,746 bookmarks (1.34%) and 2,031 likes.
- Caption: "Let me know when Opus 5.5 can do this", a challenge to AI motion design.
- She sent it on 2026-10-12 "for inspo and usage" while the learner-1 teaser was in work.

**Beats:**
- **0-3s:** a dreamy pastel gradient (lilac to peach) with a blurred human silhouette; "Imagine to have all your tool(s)" reveals letter by letter in a pink-to-white gradient.
- **~3s:** a pixel-square dissolve to light grey; "{ in one place }" in braces, with four corner dots.
- **5-6s:** "{ intro[image]ducing }", with a photo chip set inside the word and arrows at the sides.
- **7-10s:** a pixel dissolve into a 3D studio room that relights from a thermal false-colour pass to real daylight (the render "develops").
- **10-14s:** a push into the monitor; a huge prompt types across the frame over a sky of clouds ("a neo goth mo|"); a dithered cloud texture behind a prompt bar.
- **15-17s:** a "Building Image" step list (Processing, Generating, Image, Assemble) with coloured checkboxes.
- **17.5s:** a portrait assembles out of a grid of coloured dots.
- **18-24s:** 3D card stacks and a burst of photo variants cut on every beat; "you [photo] create".
- **25-29.5s:** an orange-pink gradient; "The AI-powered platform for modern creators" inside corner brackets; a product screenshot.

**Measured:**
- Moving 78.4%, no still of 0.4s or more.
- About 13 cut-like jumps, almost all in the 18-23s photo burst; the rest are dissolves and camera moves.
- Audio was not checked.

**Why it works:**
1. Every transition is a material change: gradient to pixels, thermal to daylight, dots to photo. The film keeps "developing" instead of cutting.
2. Typography carries objects: an image inside a word, braces as framing.
3. The product's process becomes a visual list.

**Borrow:**
- pixel or halftone dissolves between states;
- an image (or our mark) assembling from a dot grid;
- letter-by-letter gradient reveals;
- bracket and brace typography for one line;
- an inline image chip in a sentence;
- a blurred human silhouette in a soft field as an opening;
- a relight pass as a reveal.

**Don't copy:** the pastel palette, the fashion photos, their type.

### 3. @design4me__ · Instagram curation reel · 10.2s · 9:16 · 413 likes, 75 comments · [reel](https://www.instagram.com/reel/DeZLTwLoss7/)

**Context:**
- A "curated portfolio list" reel; the caption is a "comment INSPO" lead magnet.
- Audio: "Sugartapes · Viral Camera (Before And After)".
- Studied logged out in the built-in browser, with the sign-up prompt closed; no download.

**Beats:**
- **0-1.3s:** a person seen from behind in a dark room in front of a projected moodboard wall, with a serif hook centred low: "the way some people think about portfolios needs to be studied".
- **1.9-10s:** about 0.6s cuts of portfolio sites filmed on a real monitor in warm red-orange room light, each with its URL in small serif at the top.

**Why it works:**
- It is tactile: screens filmed in a physical room feel personal, not "screen recording".
- The hook is a thoughtful observation.
- The cut rate makes people pause and rewatch.

**Borrow:**
- the silhouette-before-a-projection opener (for us, a person before a wall of their own memories);
- a slow serif-feeling hook line;
- for Instagram, a 9:16 cut of a brand film with a one-line observation hook.

**Don't copy:** the room footage or anyone's portfolio sites.


---

## Added 2026-10-15: everything she shared from Oct 6 to Oct 15

Sources:
- her messages in every Claude Code chat;
- her X bookmarks dated Oct 5 to 8 (`~/content-engine/data/bookmarks.tsv`, 637 rows; the newest bookmarks need her X login in the browser pane);
- her Instagram saves since Oct 8, read only.

**Method:**
- **Full frame study** (#4 to #6): the same canvas method as #1, at 30 fps samples, 160x90 luma, with a 16 or 20 tile sheet.
- **Text study** for the rest: public post data from api.fxtwitter.com and Instagram's own page metadata. They are marked "not frame-studied".
- No media was downloaded. Audio was not heard.

### 4. @KeshWelch · mapsdata.ai launch film · 30.1s · 16:9 · 78K views · [post](https://x.com/KeshWelch/status/2108375862282215425)

**Context:** she sent it on Oct 9: "taking some inspo from this video ... showcase a world and all over the world there is different kinda context". It became the connect-the-dots film (lessons #71, #72, #88).

**What it is:**
- One continuous take around a dark, glowing green-blue globe.
- Beams arc in and land on cities. Each landing pops a data card with a counter (915, 2,317, 4,387, 948 ...).
- Country labels set bottom left (United States, Canada, Australia, United Kingdom).
- A serif tagline sits centred: "Every business on the map, one search away." (italic second line).
- A running total counts up bottom right (21,718 → 24,820).
- It ends on the logo with "Find leads anywhere".

**Measured:**
- Moving 94.9%, 0 cuts.
- The longest still is 1.07s, only at the open.
- Mean luma 31.8 (dark).

**Borrow:** one object the camera orbits for the whole film; landings as the beat; counters that keep climbing; data cards attached to the moment.

**Don't borrow:** the dark ground, glow and 3D. They are off the supermemory brand; use the blue field and the dot lattice instead (see `motion-systems.md`).

### 5. @dankimxyz (quoted by @MarkKnd, "can't stop rewatching it...") · Airwallex Agentic Banking Hackathon · 18.9s · 16:9 · 8.9K views on the quote, bookmarked Oct 5 · [post](https://x.com/MarkKnd/status/2107152661070147907)

**What it is:** kinetic type on black with pixel art.
- "Give agents [pixel icons] something to bank on": words are swapped for pixel icons as they are spoken.
- The pixel letters dissolve into an orange, fiery pixel field.
- "from a pool of $100K" is set in a giant pixel font.
- A grid of partner logos sits in hairline boxes (Visa, Claude, AWS, Metal, Coinbase, Base44).
- An orange "by Oct 23" pill.
- The "AEH" pixel logo morphs into the Airwallex logo.

**Measured:**
- Moving 48.6%.
- 34 cuts, almost all a 6-per-second strobe from 4.0s to 9.1s: pixel swaps on the beat.
- The longest still is 1.67s, on the end logo.

**Borrow:**
- Words that turn into pixel icons mid-sentence.
- A pixel or dither dissolve as the transition, which is already in the brand book's texture system.
- A beat-locked strobe for one short stretch.
- Partner logos in a hairline grid.

**Closest to supermemory's dot system of anything in the October batch.**

### 6. @supermemory · learner-1 announcement film · 79.9s · 16:9 · 1.87M views · [post](https://x.com/supermemory/status/2097035274094272935)

**Context:** posted Sep 7. She linked it on Oct 12 as the brand reference for the learner-1 teaser ("very intentional and deep").

**Act 1 (0-41s):** warm and black-and-white documentary footage with small centred captions:
- a fetus in the womb;
- "Humans are always learning" on black;
- a graduation photo;
- hands with a nest: "we improve after our failures";
- stone tools: "and tune ourselves to every task";
- a rocket launch: "or challenge we encounter";
- chips, MRI scans, a sand plain.

**The turn (~42s):** "We solved this" on white.

**Act 2 (45-75s):** everything goes blue. Halftone and duotone images: Learner-1 over dithered blue water, a flower, hands at a potter's wheel ("task"), a window ("injecting tokens into the model's context"), blossoms ("make models learn in real time"), a figure in a blue field ("continuously"), one warm glowing hand ("for the rest of its life").

**End:** the supermemory lockup on white.

**Measured:**
- Moving 64.6%.
- 56 cuts: a montage, the opposite of a continuous take.
- The longest still is 4.03s, on the "Humans are always learning" card.
- Mean luma 101.

**Borrow (and already used):**
- The grade as the act break (warm and grey, then brand blue).
- Halftone imagery in blue.
- One warm accent in a blue world.
- The site's own words as captions.

This is the brand's own register for big announcements.

### 7. @Parthivdzns · "Life's good with @supermemory" · 12.0s · 1:1 · bookmarked Oct 8 · [post](https://x.com/Parthivdzns/status/2108112062102876549)

Parthiv's own brand film, which she also sent as a file on Oct 8. Studied in lessons #70:
- off-white halftone images on electric blue #0A26EF;
- hairline guides framing a stage;
- captions in the bands ("MAKE MEMORIES / WITH SUPERMEMORY");
- the mark slides out into the wordmark.

Not frame-studied here.

### 8. @soojintech · "a magical village where you can explore and learn 6 AI concepts" · Instagram reel · 1.4K likes, 1,058 comments · saved by her Oct 14 to 15 · [reel](https://www.instagram.com/p/DefmtgohlQ7/)

**What it is:** an explorable game-like village. Each building teaches one concept (word embeddings, RAG, training vs inference, agents, MCP, vector databases). She built it with ChatGPT's Astra model, and the reel is comment-to-get-link.

Not frame-studied (from the caption).

**Borrow:** concepts as places in one world. That is a format for a memory explainer series: one room per supermemory concept (namespaces, expiry, updates, dreaming).

### 9. @ox8erlin · "/anatomy" skill reel · Instagram · 54K plays · saved by her Oct 13 · [reel](https://www.instagram.com/reel/DebfVQahw30/)

A tool reel about the **anatomy** skill (github.com/wheresryan22/anatomy, MIT, about 9.2K stars on Oct 14). The skill builds interactive isometric "machine" drawings that act out an idea.
- Installed in her Claude Code on Oct 14, after a security read.
- Dhravya's "memory machine" brand films (Slack, Oct 12) look like this style.

Route: lessons #98.

### 10. @shai.hq · "Claude for Designers EP 33 (Linear style)" · Instagram · saved by her about Oct 4 · [reel](https://www.instagram.com/reel/DeEhSRWBAi2/)

A tool reel about the **hairline** skill (github.com/lucasmarkes/hairline, about 1.95K stars on Oct 14). It suggests 2 to 3 concepts, then draws the chosen one as an interactive line animation in a single HTML file. Not installed. Notes: `~/personal-supermemory/reports/instagram/saved-skill-hairline.md`.

### 11. @irabukht · Wispr Flow's paid ads program (thread, no video) · 269K views · she sent it Oct 10 ("learn this, how whisper flow did their ads") · [post](https://x.com/irabukht/status/2108585781581217906)

**The model:**
- Brands recruit creators to film ads and pay them a percent of ad spend ("10 really good creators can get you to $50M a year").
- Wispr Flow stopped organic UGC and put everything into paid: 500 to 700 new UGC ads a month, aiming for 1,000.

**Use it for:** the `ad-film` recipe. Volume and creator faces beat polish for paid. Text only; the claims are the author's.

### 12. Launch films she sent for quote tweets (Oct 7)

Not frame-studied.

| Post | What it is | Length | Views |
|---|---|---|---|
| [@boltdotnew](https://x.com/boltdotnew/status/2107846455180288289) | "Introducing Commenting in Bolt": a short UI demo | 16.7s, 16:9 | 246K |
| [@envato](https://x.com/envato/status/2107924147435115006) | Burst mode: "Turn the start of an idea into up to six image directions at once" (a creator brief with assets) | 45.1s, 16:9 | 3.5M |

### 13. Bookmarks from Oct 5 to 8 with video

Not frame-studied.

| Post | What it is | Length | Views |
|---|---|---|---|
| [@ideogram_ai](https://x.com/ideogram_ai/status/2105327223431737780) | Ideogram 4.5 launch, "the most precise edit model": multi-turn edits without artifact buildup | 47.3s, 4K | 1.1M |
| [@defileo](https://x.com/defileo/status/2107258340376187371) | "who let a spider read my prompt": a 4:5 product demo, with a prompt score that goes from 37 to 82 | 21.5s, 4:5 | 1.18M |
| [@nikosolenne](https://x.com/nikosolenne/status/2107490745552683382) | 8 design reference sites, all already in `websites.md` | 13.4s | 84K |
| [@himanshubuildss](https://x.com/himanshubuildss/status/2107063044279058483) | "Most AI-built websites look generic because the AI was never given a real design brief": 29 resources; the sites are in `websites.md` | 40.2s, 4K | 42K |

### 14. Other references she sent (not video)

- **[@Aartiutwani](https://x.com/Aartiutwani/status/2108711667580481606), Oct 10:** "you need an engineering degree to understand SF billboards", 2 photos, 336K views. Billboard creative that speaks the audience's language. She used it as a tone reference ("something more relatable and cool").
- **The Pinterest pin, Oct 14:** a glowing glass head with a brain, which became the learner-1 v11 glass mind. Direction only: the pin is marked "AI modified" and was never traced. [pin](https://in.pinterest.com/pin/310255861852183938/)
- **A Pinterest search, Oct 12:** "memory stretch blue streaks human brain", the mood for the learner-1 teaser.
- **@sandruhdotcom, Instagram, saved:** "don toliver has an insane ear and he works with the most talented producers", 534K likes. It shows her music taste (the Don Toliver lane). Original scores in that lane only, never his melody (lessons #72, #79, #80, #92).
