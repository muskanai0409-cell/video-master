# Batch 14: videos she sent with "learn this" (late October 2026)

**Method:** as in batch 13, nothing is downloaded to keep.
- Frames are read from the post's mp4 by exact seek (`ffmpeg -ss T -i <url> -frames:v 1`), with 2 fps overview sheets and 8-frame strips across every transition.
- Motion uses the `qa.md` 2.3 metric (`engine/tools/study_video.py <url>`), and motion events come from per-frame YDIF at 320px.
- The voice is transcribed (ElevenLabs speech-to-text) with word timings, and colours are sampled from decoded 1080p frames.

### 1. @mem0ai · Claude Code memory explainer · 56.1s · 16:9 1080p30 · 2.9K views · [post](https://x.com/mem0ai/status/2105685414430523472)

**Context:**
- Posted 2026-10-01 and studied 2026-10-25. Stats by then: 2,880 views, 36 likes, 17 bookmarks, 11 replies; 20.6K followers.
- Post text: "With Mem0 you don't have to re-explain your codebase to Claude Code every single session. Here's how it does that:".
- She sent it for the motion: "the things are so aesthetic and motion graphic blending one into each other is so much better with them".
- Grammar extracted to `../../one-take-blend.md`.

**Numbers:**
- 0 cuts; 49.5% moving; longest still 3.2s.
- 18 motion events of 0.27 to 2.2s (median 0.87s).
- -10.9 LUFS, music bed about 117 BPM (estimate).
- Voiceover: 119 words, 131 wpm, a calm female read, 11 sentences with 0.4 to 1.1s gaps.

**Look:**
- Pure black ground (#000000). In the middle scenes there is a faint dot grid (#0c0c0c); behind the logo, a faint concentric ripple.
- A violet horizon glow rises from the bottom edge (#291d4a to #1f1637).
- One hue in five values: active fill #201840, edge #503890, accent text #8868d8, particles #c898e0, plus the glow.
- One guest colour, Claude coral (about #e07a5f to #683830), used only as a wash on Claude windows.
- Type: white UI text in a grotesk, with mono uppercase labels on cards (TOKENS PER QUERY, CODING PATTERN).
- macOS window chrome with a light title bar; small dark cards with 1px borders.
- The hook alone uses a photographic planet horizon and an app-icon calendar.

**Beats (voice → picture):**
- **0.2 "Yesterday, you already told Claude how your codebase works."**
  - The calendar icon flips TODAY 7 → YESTERDAY 6.
  - A Claude Code window hinges up out of the planet's horizon (0.43 to 1.0s) and types "Here's how our codebase works: Auth runs through OAuth...".
  - Memory chips pop around it as each fact is typed (Auth uses OAuth, Uses PostgreSQL, Prefers TypeScript). Each chip carries a tiny coral line graph.
- **3.7 "Why tell it again?"**
  - Rack focus from 3.3s: the planet goes black with a violet glow, and the chips stay as blurred depth.
  - The line resolves word by word, with "again?" in violet.
- **5.3 "Your projects evolve, but important context can stay stuck in separate sessions and repos."**
  - The line wipes out right to left.
  - A new window slides in as a coral block with motion blur and cools into "Welcome to Claude Code / How does auth work in this repo? / Let me explore the codebase first...".
  - A hairline grows down to "Repo A" among dim repos B to E. Its six dots scatter and orbit it: the agent exploring again.
- **11.1 "Meet Memzero, which gives Claude Code a persistent memory layer."**
  - Repo A dims; the mem0 mark resolves from blur over a faint ripple (10.3 to 11.2).
  - A "Claude Code" chip drops in above on a line, and a curved band opens sideways out of the mark with particles inside (12.8 to 13.3).
- **16.1 "As you work, Memzero captures what matters: your coding patterns, decisions, preferences, and context."**
  - The band straightens into a bar (15.6 to 16.1).
  - The camera eases down, and four category cards resolve on their words (CODING PATTERN · Prefers TypeScript, CONTEXT · Auth uses OAuth, PROJECT DECISION · Uses PostgreSQL, PREFERENCE · Follow existing API patterns).
  - From 19.3s each card collapses into a violet pill, then a dot, and flies up into the bar.
- **24.5 "When Claude needs it, Memzero retrieves the relevant memory instead of loading everything."**
  - The chip grows into a coral-washed window that cools ("Update the authentication flow. / Retrieving context from Mem0.").
  - The bar fills with violet glow, and lilac dots rise into the window (27.5 to 29).
- **30.4 "So Claude Code doesn't just write code, it remembers how you work."**
  - The line turns green ("Recalled 3 memories from Mem0"), then blue ("Updated src/auth/callback.ts").
  - The window warms and collapses back into the chip (32.1 to 33.6), and a grid of ten repo cards rises on lines from a wider bar.
- **35.5 "Memzero recalls only what matters using a fraction of the tokens with accurate recall."**
  - The repos go soft.
  - Three stat cards count up in turn, each filled violet while active: "~3.5x fewer tokens", "94.4 on LongMemEval", "92.5 on LoCoMo". These are their claims; do not reuse them.
- **40.7 "It recalls context automatically, shares project knowledge with your team, and learns as you work."**
  - The bar shrinks into a hub pill.
  - Four feature cards whip in with motion blur (Recalls automatically, Learns as you work, Shared with your team, Private where it counts), and one violet fill hops between them by phrase.
- **46.8 "Getting started takes three commands, then just start coding."** Everything goes soft, and a Terminal chip grows into a coral-washed window that types the three plugin commands.
- **51.8 "Memzero, make every session remember."** The terminal goes soft. The mark appears, the wordmark types in letter by letter with a few stars, and the tagline resolves word by word in violet. One white shimmer sweeps across it, and the film holds on it.

**Why it matters for us:** it moves less than our films (49.5% against 65.5%) but reads smoother. Three things do that:
- one object carries the whole film;
- nothing leaves by fading to nothing;
- the picture starts a breath before each word.

The grammar and how to build it: `../../one-take-blend.md`; the engine: `engine/blend-kit/`.

### 2. @firecrawl · data artifact (Jev + company data) · 8.4s · 16:9 1080p60 · 45.7K views · [post](https://x.com/firecrawl/status/2114761999003340852)

**Context:**
- Posted 2026-10-26 and studied 2026-10-27. Stats by then: 45,666 views, 623 likes, 671 bookmarks, 32 reposts, 14 replies; 94.4K followers. Bookmarks beat likes, so people saved it as a reference.
- Post text: "Introducing Jev + Firecrawl company data / Pull company records from Alexandria and let Jev classify them. / We sorted 146 startups by who buys from them in 2.2 seconds."
- She sent it as the kind of film she wants: "SUPER COOL QUICK MOTION GRAPHIC ARTIFACT FOR SUPERMEMORY". Then: "NOT SAME TO SAME, BUT THE SAME CONCEPT", about where supermemory takes context from and how it builds a memory, "BUT ... WE DONT WNNA MAKE IT CRINGE" (lessons #143).
- An earlier cut from the same team is `7-more-a.md` #12 (@ericciarla, 5.2s, 132K views).

**Numbers:**
- 0 cuts; about 61% moving (qa metric); the only long still is the end hold on the wordmark, about 1.8s from 6.6s.
- Measured from the post's mp4 by exact seek; nothing kept but a 4 fps sheet.

**Look:**
- A white ground with a fine full-bleed grid; black type; Firecrawl orange as the one accent; the company logos supply every other colour.
- A big headline sentence whose numbers count, over a dense board.

**Beats:**
- **0 to 1.7s:** "Enriching company data for 0 → 6 → 22 → 45 → 74 → 108 → 146 startups" while a dense grid of company rows fills in with logos and data.
- **About 2s:** the rows collapse into their logos, which lift and scatter.
- **2.5 to 4.5s:** the logos sort into six labelled columns (Businesses, Industry, Healthcare, Consumers, Developers, Other), each with its own counter, under "Jev sorted 0 → 146 startups in 0.00 → 2.15 seconds".
- **4.5 to 5.5s:** the sorted board holds.
- **5.5 to 8.4s:** the logos swirl into the flame mark, and the wordmark types in and holds.

**Why it works:** one real dataset, a sentence whose counters run at real speed (the clip's runtime is the claim), a board dense enough to show scale, one transformation (enrich, then sort), and a fast end on the mark.

**Borrow:** the energy: speed, density, a counting headline, one transformation, a fast mark ending. **Don't copy:** the board layout itself (her "not same to same"), their orange, other companies' logos as data. Our versions: `~/personal-supermemory/reports/video-prompts/context-world-concepts-2026-10-27.md` and `cli-artifact-concepts-2026-10-27.md`.

### 3. @allophonesystem · Grok Bot integration launch ("give Grok Bot a phone") · 20.2s · 16:9 720p30 · 416K views · [post](https://x.com/allophonesystem/status/2115793573589258279)

**Context:**
- Posted 2026-10-29 and studied 2026-10-30. Stats by then: 416,378 views, 1,743 likes, 1,116 bookmarks, 110 reposts, 127 replies, 46 quotes.
- The account had 652 followers. Allo is a business phone system with AI agents (withallo.com).
- Post text: "We decided to give Grok Bot a phone."
- She sent [@irapss_ae's quote](https://x.com/irapss_ae/status/2115818559750475813), which says only "JESUS.". He is a motion designer with 1.4K followers, and his quote had 217,967 views and 1,827 bookmarks by Oct 30, more bookmarks than the original.
- Her words: "omg learn this video omg, add it to our skills this is too good".
- It launched on the same host, in the same week, as our Supermemory Bot film.
- The grammar is extracted to `../../character-rebus.md`.

**Numbers:**
- 3 hard cuts, at 9.73, 12.87 and 15.87. The 0.32 detector found 2 and missed the light-to-light cut at 12.87.
- 94.7% moving; longest still 0.2s.
- Music on a 120 BPM grid, -17.0 LUFS.
- No voiceover. Speech-to-text finds one line inside the story, "Hi, Gonzalo.", at 8.12s.
- X serves it at 1280x720 at most, although the post's metadata says 1920x1080.

**Look:**
- **Colours:**
  - ground #f6f9fc, a cool off-white;
  - the mascot in pure black with white eyes;
  - one green, #08a060, on the headset, pills and bubbles, and #088a55 on the phone's screen.
- **Type:** one centred, sentence-case headline at a time in a black medium grotesk. Cap height 44px of 720.
- **UI rebuilt in vector:** an iOS home screen with a Dynamic Island call card, message bubbles, a quote card, and a macOS app with a sidebar of agents.
- **End:** a dark green radial (a #095637 glow at bottom left into #010904), the yellow app icon, white type, and the mascot in white.

**Beats:**
- **0 to 2.7s:**
  - The mascot pinballs in, squashing and stretching, and settles.
  - A green headset arcs onto its head, and the frame punches in on the landing.
- **2.8 to 4.2s:** "Give your [mascot] a phone": the mascot is the word.
- **4.3 to 6.2s:** it drops below "Its own number", and a seed dot between "own" and "number" grows into a green number pill.
- **6.2 to 9.7s:**
  - The camera tilts down as a phone rises, and the island becomes an incoming call.
  - The mascot dives into the avatar slot and turns white.
  - "Gonzalo Rascon" morphs into "Grok Bot · Forwarding Call", the bot says "Hi, Gonzalo.", and "Answers your calls" lands.
- **9.73 to 12.8s (cut), "Text your customers":**
  - a typing bubble becomes "Hi Gonzalo! Here's your quote:";
  - a $1,000.00 quote card resolves beneath it;
  - the customer replies "Thanks, that was fast!".
- **12.87 to 15.8s (cut), "Prepares your call-back list" over a macOS app:**
  - the camera dives into the chat;
  - "Let's go, I'll call them now." gets the reply "Open Allo and hit Start. I'll text the ones you miss."
- **15.87 to 20.2s (cut), the dark radial:**
  - app icon, then the "allo" lockup;
  - then "Connect Allo to Grok Bot", with the mascot grown out of a seed dot between "to" and "Grok Bot";
  - a living hold to the end.

**Why it works:**
- The host's mascot carries the story and wears the product.
- A sentence with the mascot inside it opens and closes the film.
- The story runs as one take; the proof cuts on the beat.
- Every headline is a verb with the bot as its subject, proved by UI underneath within a second.

**Borrow:** the rebus line, the seed-dot pill, the gaze rig, the dive into a UI slot, the per-letter morph, the anchored bubbles, the logo turning into a word.

**Don't copy:** Allo's green, icon, headset idea, lines or UI. Don't dress or animate Grok Bot's mascot without her OK; our rule is "as @bot draws it".
