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
