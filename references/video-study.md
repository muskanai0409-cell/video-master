# Video study: what 156 bookmarked videos do

On 2026-10-06 every video in her kept motion and design bookmarks was downloaded for study, measured and read frame by frame. That is 163 posts and 156 unique videos, posted from June to October 2026. The video files were never added to this repo.

- `library/videos/` holds the per-video notes, one file per study batch, plus an index of every video with its link and numbers.
- This file is the synthesis.
- `recipes/` turns it into build steps, one per format.

Read it when planning any video, choosing a format or its targets, or when she says "make it like the good ones".

**Two rules of use**
- Borrow mechanisms (a hook, a structure, a transition, a timing), never assets (palette, fonts, logos, layouts, footage).
- For supermemory films, SKILL.md sections 1 and 2 (her direction and the fixed rules) win over anything here. Several devices below are banned on the supermemory surface: gradients, glow, 3D, whip pans, AI footage. They are listed because they work elsewhere.

**Citations.** `5#18` means batch 5, entry 18, in `library/videos/5-launches-a.md`. Every entry carries the post link.

---

## 1. Method

| Measure | How | Caveat |
|---|---|---|
| Moving % | 30fps, 160x90 grey, frame difference; a pair is still below 0.15 mean difference | Same metric as `qa.md` 2.3, so it compares directly with her cuts |
| Longest still | longest run of still pairs | |
| Cuts per minute, median shot | scene score above 0.32 at 320px | Misses morphs, dissolves, dark cuts and cuts inside split screens; over-counts stepped redraws. "0 cuts" means it looks continuous, not that it is unedited |
| Loudness | EBU R128 integrated | Nobody listened to the audio. Only presence and loudness are known |
| Frames | a 16-frame sheet with tile k at (k+0.5)·T/16 by exact seek, a hook strip of the first 2.5s, an end strip of the last 4s | Videos over 240s were measured and sheeted on their first 240s; the end strip always shows the real end |

**Other caveats**
- Views are the bookmarked post's. A quote post carries the quoter's views, and views mostly track the account's reach.
- The study passes assigned the format labels.
- `engine/tools/study_video.py` does all of the above for one file.

**A sheet bug to remember.** `select='lt(abs(t-X),0.02)'` keeps 2 to 3 frames per target at 60fps, so a "16-frame" sheet ends near 40% of the video. At 24fps it skips targets. The first study pass was misled by this until three agents caught it. Use one seek per frame, or a plain `fps=N/D` filter with no `-ss` (tile k lands at (k+0.5)·D/N; checked 2026-10-06).

---

## 2. Measured benchmarks

156 unique videos, medians. Loudness is over the audible videos only (count in brackets).

| Format | Videos | Length | Moving | Longest still | Cuts/min | Median shot | LUFS |
|---|---|---|---|---|---|---|---|
| launch film | 48 | 53s | 77% | 1.4s | 8.8 | 4.2s | -14.4 (48) |
| product demo | 27 | 30s | 63% | 1.1s | 0 | 20.4s | -18.4 (15) |
| other (breakdowns, loops, sketches) | 18 | 35s | 67% | 1.1s | 0.9 | 10.2s | -15.0 (10) |
| talking head | 12 | 151s | 79% | 1.2s | 4.0 | 6.1s | -15.7 (12) |
| explainer | 10 | 65s | 50% | 2.6s | 0 | 49s | -16.1 (10) |
| UI-morph reel | 9 | 37s | 81% | 1.9s | 0.9 | 31s | -14.8 (9) |
| ad | 8 | 45s | 77% | 0.9s | 15.1 | 3.0s | -17.5 (8) |
| screen capture | 7 | 15s | 88% | 0.9s | 0 | 10s | (1) |
| AI-footage showcase | 6 | 28s | 80% | 0.1s | 13.4 | 3.7s | -14.7 (6) |
| changelog update | 5 | 75s | 73% | 2.3s | 0 | 18s | -19.1 (3) |
| tutorial | 4 | 111s | 15% | 3.6s | 0 | 56s | -23.6 (3) |
| showreel | 2 | 15s | 100% | 0s | 0 | 15s | (1) |
| **all** | **156** | **43s** | **73%** | **1.3s** | **2.2** | **10.3s** | **-15.5 (126)** |

| Views | Videos | Length | Moving | Longest still | Cuts/min |
|---|---|---|---|---|---|
| 500K and up | 44 | 66s | 73% | 1.5s | 7.9 |
| 100K to 500K | 51 | 33s | 75% | 1.0s | 0.7 |
| under 100K | 61 | 37s | 75% | 1.4s | 2.2 |

**Targets that hold across formats**
- **Movement:** 70 to 80% of frames moving. 64% of the set reaches 60%. Keep the longest still around 1.5s or less: 72% of the set stays at or under 2s, and only 16 of 156 hold a still over 3s, mostly tutorials, explainers and changelogs.
- **Cut rate by type:**
  - Product UI films move by camera, cursor and morph rather than cuts: demos and UI-morph reels median 0 to 1 cut a minute.
  - Footage-led launch films, ads and AI-footage pieces cut at 9 to 15 a minute, with 3 to 4s shots.
  - 61 of 156 videos have no detected cut.
- **Aspect:** 16:9 by default (113 of 156, and 37 of the 44 with 500K+ views).
- **Loudness:** finished social cuts sit near -14 LUFS, with launch films at a median -14.4. Dialogue-led pieces sit at -16 to -23. 31 of 156 have no audio or a silent track, almost all of them captures and demos.

**What predicts views: nothing measured in the craft.** Spearman correlation between views and:
- moving %: 0.01
- cuts per minute: 0.06
- longest still: 0.01
- length: 0.21, because big launches run longer

The 500K+ group moves as much as the rest. What the top-viewed share, from the notes rather than the metrics:
- **They announce something:** a product, an update, a raise, a mission. "Look what the model made" posts sat at 122K to 606K (batch 1).
- **They have reach or borrowed recognition:** a big account, a famous CEO's comment, partner logos, a co-brand. The same graph clip with the same caption drew 340K one day and 42K another (6#4, 6#20).
- **People are on screen:** 4 of batch 1's top 6.
- **Frame 0 is the subject,** one new named thing appears in the first 15s, and there is one proof device.

**supermemory's own films in the set (14)**
- Overall they look like the rest: median 45s, 71% moving, -14.6 LUFS.
- Their product-UI films move much less: the MCP launch (2#10) 53%, Muse Code (2#21) 63%, SMFS (2#23) 53%, eve (2#16) 25%, Keiki (2#17) 28%, the summarize clip (3#33) 24%. Demos elsewhere median 63% and UI-morph reels 81%.
- The learner-1 launch film (1#6) holds a 3s still and is mastered at -7.1 LUFS, the loudest in the set. Keiki sits at -34.9, which is effectively silent.

---

## 3. Hooks: the first 3 seconds

What recurs, strongest first:
1. **The premise in words by 1 to 1.5s.**
   - A typed claim on a plain ground: "Exa is now in Codex" by 1s, then the word is selected and clicked to enter the product (5#18); "…100% FREE." by 1.5s (5#17); type, backspace, retype (5#19); one word every 0.5s (5#21).
   - A question complete at 1s (1#9), or a number at 0.5s ("$13.5M", 1#11).
2. **Something live inside the sentence:**
   - inline app and agent chips that swap every 0.5s (1#2);
   - a magnifier swapping AI logos over the word "AI" (6#6);
   - a heart replacing the "o" with a ripple (2#14);
   - "Muse + [integration]" swaps (6#5);
   - a slot-roll "Introducing ___ for ___" (6#24).
3. **A number changing in frame 0:** "$397M" counting to "$400M" (2#11), a counter in front of a word (2#18), a euro odometer by 1s (5#25).
4. **Borrowed trust by 3s:** partner logos swinging in on orbit rings at 0.5s (5#3), a GitHub repo card with stars (5#20), a price (5#17).
5. **A familiar surface overloaded with the problem:**
   - a flooded inbox and a whip scroll (1#3);
   - one group-chat bubble at readable size, then a pull back to the whole thread (5#13);
   - a count-up "Thinking…" timer that ends on "WASTE." (3#5);
   - "ummmm" stretched over a level meter (3#18).
6. **The product already working at frame 0:** props placed for a live demo (5#2), a voice UI beside the user (5#11), a moving 3D result (5#15).
7. **The brand mark becomes the product,** in 1 to 2.5s and already moving: construction guides into the mark (2#3), a wordmark into a button into a photo (3#12), a button into a spinner into a player (3#23), an orb into a face (4#10). None of batch 6's top 8 opens on black or a static logo sting.
8. **A news peg in the first line or card:** "So yesterday the CEO of…" (6#1), a BREAKING acquisition card in second 1 (6#9), press headlines (6#21).
9. **A person mid-sentence** with a name super or captions by 1s: a founder on a rooftop (5#1), a walk-and-talk (1#1).
10. **A chat skit in the audience's own language:** "Sir… you want WHAT?" (6#14).
11. **Spectacle with no text:** a graph forming or zooming out (6#4), a tree flying into a force graph on one click (6#17), six live agent tiles (6#10).

**Weak opens** (the notes call these the weakest in their batches):
- a held UI still (2.4s in 2#17);
- a 2.5s fade up from black (3#24);
- an unzoomed 4K recording with tiny text (3#16, 3#19, 3#22);
- a silent talking head (3#35);
- a small icon held for 3s (1#14).

Slow opens only work when the post copy carries the hook.

---

## 4. Structures, with timings

| Structure | Length | Shape | Examples |
|---|---|---|---|
| One-task demo | 20 to 90s | claim, then a prompt typed, the work made visible, a structured result, the extras at about 1s each, then the logo | 5#18 in 23s: claim and click 0 to 2.6s, prompt 3 to 5s, work 6 to 11s, result 12 to 16s, availability line 16 to 18s, logo 4.5s |
| Designed launch film | 29 to 56s | problem or news 0 to 5s, pivot or "Introducing" at 10 to 18s, one task end to end with a number 13 to 38s, breadth (a list scroll, a logo ring, cards), URL or command 2 to 3s, logo 2 to 5s | 6#5, 6#6, 6#9, 6#14 |
| Founder-led launch | 65 to 200s | vision or problem, product named at 10 to 15% of the runtime, UI inserts of 3 to 6s with burned-in captions, a proof block (stats, logos, testimonials) at 60 to 80%, founder close, lockup | 5#1 (named at 14s of 94), 5#12 |
| Roster reel | 35 to 67s | claim within 2s, a trigger (command, URL, search) by 3 to 10s, N features on one template (a label pill plus one proof card in the same place, 2 to 4s each), "…and N more", CTA held 3 to 8s | 5#8, 5#20, 5#22 |
| Claim, then proof | 30 to 70s | every headline card is answered by one UI shot within about 5s | 1#2, 2#6 |
| Agent-native install | inside any of the above | the install shown literally: one URL pasted into Claude's connector field at about 5s (6#8), the docs URL copied, ⌘V into a coding agent, "Working for 2m 18s", the diff, the live result (6#14), a SKILL.md command at 15s and again at the end (6#9) | 6#8, 6#9, 6#14 |
| Cinematic bookends | 50 to 120s | an abstract or story open of 3 to 5s, title, 3 to 6 product moments, the opening motif returns, lockup | 5#23, 5#26, 5#16, 5#7 |
| Manifesto or trailer | 40 to 80s | a pattern-interrupt montage 0 to 4s, abstract footage with captions, late proof numbers, logo and URL | 6#13, 6#21 (both fast-cut, 22K to 131K views) |
| Result first, receipts after | 20 to 45s | the finished output for the first half, then the inputs and intermediates | 6#3, 6#11, 6#16 |
| One-take loop | 10 to 45s | a capture that ends in its start state, so autoplay rewatches seamlessly | 6#17 (tree, graph, tree), 4#9 |

**Runtime budgets that worked**
- **Cloudflare rebrand** (2#3), read from its breakdown's chapter bar (2#2): intro 20%, demo 14%, social proof 7%, features 10%, use cases 24%, outro 24%.
- **Film breakdown** (3#20): acts of 3, 7, 23, 3 and 5s.
- **Even cut grid:** one cut every 2s (3#34).
- **Her changelog (2#22):** 37% of the runtime (52s) went on six small fixes, and full-screen proof covered only about 8s of 140s. Budget by chapter.

---

## 5. Motion, camera and transitions

- **Motion comes from the camera, the cursor and the UI, not from cutting.** Batch 6's top 8 have 77% of frames moving at a median of 2.3 cuts a minute. Batch 4's rebuilt-UI launch films cut about once a minute and still move.
- **One element carries the film.** A single container springs between states (size, corner radius) while its content crossfades (3#12, 3#23, the red dot in 3#13). 12 of batch 3's 20 clips of 35s or less have no detected cut.
- **A fast montage needs a fixed anchor:**
  - Claude's arc holds fixed coordinates under one four-word line while the picture cuts every 0.4s (1#19, 96 cuts a minute);
  - an orange dot holds a 37-cuts-a-minute ad together (2#4);
  - a timeline line does the same with no cuts at all (2#17).
- **Push in until the one line or control that matters fills the frame:** the Trade button (5#3), a prompt at giant scale (5#14), the typed date (2#10). Crop to one control rather than showing the window.
- **Graph shots:**
  - zoom out from one labelled node to the whole graph in under 2s (6#4);
  - drag a node so its edges stretch;
  - dive in until the titles read;
  - resolve a path into a readable filmstrip (6#17) or a source panel (6#18);
  - morph tree to graph in one click (6#17).
- **Material transitions:** page curl and stamps (3#21), notebook flip (3#20), sketch to clean vector (3#29), ink scribble (3#2), halftone dissolve (3#27), a foreground occluder wipe (3#10, 3#11).
- **Depth as hierarchy:** keywords placed behind the speaker (3#10, 3#11), rack focus (3#24), blurred chips behind a headline (3#13). In code this is z-order, blur and slow parallax.
- **Speed:** directional motion blur on fast moves (3#11, 3#12, 3#23); a whip scroll with blur (1#3).
- **Bookends:** close by redrawing the first frame, so autoplay loops seamlessly: the horizon (1#19), the vertical ad (2#4). Or bring the opening motif back around the logo: an orbit returning with the X inside (5#19).
- **Avoid:**
  - blur dissolves held too long, which leave dead frames (1#18);
  - full-desktop or unzoomed captures, which measure 11 to 26% moving (6#15, 6#23).
- **Motion QA rubric,** from Emil Kowalski's `/review-animations` output (3#17):
  - ease-out on enter, about 200ms in and 150ms out for UI;
  - scale from 0.95, never from 0;
  - animate only transform and opacity;
  - keep a reduced-motion fade.

---

## 6. Type and colour

- **One accent, spent only on the key idea:** lilac (1#2), orange (1#12), yellow (1#8), blue on "100% FREE." (5#17), one green word (5#13). On supermemory that is `#0562ef`, only for the thing being proved.
- **Dim most of the line:**
  - two-line statements with the second line in grey (1#2, 1#12, 2#21);
  - grey-to-black word reveals (5#8);
  - her ink-45% statements are the same device.
- **Mixed faces:** a sans line with one italic serif word (2#11, 2#17, 2#7), or a heavy grotesk with an italic serif accent (3#5, 3#6, 3#10).
- **Tiny uppercase mono labels as chapter markers** (2#17, 2#21, 2#16, `// 01` in 1#10). Numbered steps "1 · ONE SKILL", "2 · DISCOVER" carry a demo (6#9).
- **Numbers as beats:**
  - giant numerals ("$7,000,000,000" over "FOR A ROUTER", 6#9);
  - odometer rolls (5#19, 1#17);
  - count-ups (3#5);
  - a struck-through price list that lands on one big number (5#22);
  - ending on a contrast ("90 years. 4 days.", 1#9).
- **Short words, landed hard:** one-word cards ending in a period ("WASTE.", 3#5); word-by-word builds with a blur-in (5#17, 5#20, 3#1, 3#9).
- **Captions:** burned-in for anything with speech or longer than about 60s. Long pieces get a chapter chip, a progress bar and caption pills (1#15).
- **Colour carries structure:**
  - one gradient per feature as a chapter key (1#1);
  - a ground switch for a change of point of view (5#19: light is you, dark is the other person; 5#12: a vintage frame for "before");
  - a grade switch at the reveal (1#6: natural colour to a blue duotone).
- **Phone first:** Muse Code's mono lines, the SMFS tooltips and the Okara page cannot be read at 480px wide (2#21, 2#23, 2#24). 3#9 stays followable on mute with auto-zoom and 2 to 5 word callouts.

---

## 7. Product UI on screen

- **Real capture or rebuilt vector UI:**
  - The two are about even in batch 5. Real capture leads in batch 6 (13 of 26).
  - The stronger captures crop hard, float the window on a designed ground (a gradient, a stage, a phone on a gradient), or add a receipt inset (the source photo in 6#3, the founder in 6#9).
  - Her rule for her own films: rebuild the UI in vector from the measured DOM (SKILL.md section 1g).
- **The cursor carries the story:**
  - closing the old tool's window (6#6);
  - clicking Allow on a consent card (6#5);
  - ⌘V keycaps (6#14);
  - selecting a word to enter the product (5#18);
  - clicking Tree/Graph (6#17).
- **UI composited into the world:** the model writes the title and the price onto an LED display on the desk (5#2); glass UI over footage (5#12, 5#11).
- **Prove a number by scrolling the real list:** 100+ skills and 3000 integrations scrolled in 6#8, rather than stating a count.

---

## 8. Showing invisible work (agents, retrieval, memory)

The strongest device in the launch batches: give the work you cannot see its own lane, counter or stack.

| Device | Seen in | What it proves |
|---|---|---|
| A log lane beside the conversation (You / model / Backend), showing the backend call that set the display | 5#2 | tool use, in real time |
| A running counter that rides through the demo ("$0.00"; "SPENT $" rising from $0.15 to $7.15) | 5#17, 6#9 | price or usage as a story |
| A wall of real sources scrolling under "12 subagents reviewed companies" | 5#18 | retrieval scale, without quoting a number |
| A stack of status lines ("Web search Exa…" seven times; "Reading sources… / Searching 2142 Files / Checking Gmail") | 5#18, 1#2 | an agent gathering context |
| Named cursors with verbs, or teammate messages | 3#15, 1#20 | several agents at work |
| An answer that says where its context came from | 5#23, 2#21 | memory was used |
| A readable memory object: a memory page, or a panel with lines drawn to the answer | 5#23, 2#16 | memory you can inspect |

---

## 9. AI footage (batch 4)

1. Use AI footage for what code cannot draw: people, light, weather, water, crowds. Keep everything that must be exact in code: UI, numbers, charts, text, logos. None of the 24 trusts AI with on-screen text.
2. Keep AI shots to 1.2 to 3s and cut on motion. Use one long take (8 to 15s) only when realism itself is the claim (4#12, 4#16, 4#20).
3. Lock every plate to one light and one style: one time of day, one period look, one recurring character or object, so a montage reads as one world (4#1, 4#9, 4#11).
4. Generate plates with empty space kept for type, and set the labels there (4#18, 4#4).
5. Bridge footage and UI with in-world carriers (a prompt bar over the scene, device frames, pinned label pills, a sprite guide) rather than hard-cutting between a film and a UI demo (4#5, 4#7, 4#8).
6. For proof claims, put the evidence side by side: synchronised split screens or before-and-after pairs with tiny labels (4#15, 4#17).
7. Treat AI clips as scrubbable assets. Render a turntable or orbit clip and drive its frame from the code timeline (4#22 does it with the cursor), so the render stays deterministic.
8. Skip AI footage when the product UI is the hero. The UI-led films (4#3, 4#10, 4#17, 4#23) carry 28 to 75s on rebuilt UI alone, with 0 to 2 cuts.

**Known weaknesses:**
- hands get cropped, gloved or blurred;
- outfits and hair drift between shots;
- signage softens;
- exact UI, charts and diagrams are never generated.

On the supermemory surface, AI footage is out unless she asks; the brand film (`field.mp4`) is the moving background.

---

## 10. Sound (loudness only; nobody listened)

| Group | Integrated loudness |
|---|---|
| Finished code-made social cuts | -13.8 to -14.9 LUFS (batch 3) |
| Launch films | median -14.4 |
| Music-led motion pieces | -10 to -14 |
| Dialogue-led pieces (founder, presenter, interview) | -16 to -23 |
| Batch 6's top 8 | median -18.4: the top-viewed are not loud |
| Loudest | -7.1 (1#6), -8.1 (6#21), -9.1 (6#22), -9.2 (6#26); the three batch 6 ones have low views |

- Product demos are often silent: 12 of 27 have no audio or a silent track.
- Give every beat one sound-making action: key presses on each shot (3#34), an ASMR concept (3#32).
- It is unclear whether X normalises loudness, so check by ear on a phone.
- Her rules: about -14 LUFS for social, never a commercial song or its melody, and an original score in code plus CC0 effects only when she asks for music.

---

## 11. Endings and CTAs

Batches 4, 5 and 6 (76 videos). Batches 1 to 3 are being added.

- **Hold time:** the norm is a 3 to 5s hold on the CTA or the lockup. Holds run from about 1.6s to 10s (5#16); 5#22 holds 7.5s and 5#4 about 7s.
- **Logo-only lockups** held 2.5 to 4.5s are the most common, often after an availability line ("Available now", "Research Preview", "macOS & Windows (Beta)") (5#3, 5#5, 5#6, 5#18, 5#23).
- **URL card, then the lockup:** a URL pill, "Try it free", "Only on", then the logo, about 6.5s in all (6#6). "Try it on Claude today:" plus the URL, then a co-brand lockup that mirrors the opening card (6#8).
- **The CTA drawn as UI:** a black pill button "Hire yours → okara.ai" held about 5s (5#8), a URL field with "Book a demo" (5#9), a Subscribe click (5#11).
- **A paste-into-your-agent command in a terminal pill:**
  - "Set up https://monid.ai/SKILL.md" (5#17);
  - "$ set up treg — …/llms.txt", held about 7.5s (5#22);
  - the install command over the founder (6#9);
  - `bun add` plus the URL in the lockup (6#14).
- **QR code plus URL** for desktop viewers (5#13).
- **A comment trigger built for X** ("Comment 'AGI' → it's yours", 5#20).
- **A callback:** the opening skit's character returns before the lockup (6#14).
- **Loops:** captures return to their first frame (6#17, 4#9).
- **No card:** 14 of batch 6's 26 and 10 of batch 4's 24 end without one. These are captures, loops, showcases, and talking heads with the CTA in the captions.
- **AI-tool launches** (batch 4): 9 of 10 launch films end on a card or a CTA line, but only 3 of 24 videos show a URL at all.

---

## 12. For supermemory: what to take

1. **Give memory a lane.** Put a memory panel beside the chat that logs each write, update and recall as it happens, the way 5#2 logs backend calls, 5#17 runs a counter and 5#18 scrolls its sources.
2. **Script the moment of being remembered, then show the memory.**
   - The user's own surprise does the proving: "Wait, you remember that?" (5#13); "I know you like visuals" (5#11).
   - Then the stored memory appears as a readable object: 5#23's memory page, or 2#16's lines from a memory panel to the answer.
3. **Turn extraction into an object.** Highlighter strokes lift off a page into labelled pills (3#29); this maps onto fact extraction.
4. **Show recall as a status stack.** "Searching memories…", then what was found, then what was used, stacking like 1#2 and 5#18.
5. **Show the install literally and early.**
   - The MCP URL pasted into a connector field, or the one command in a terminal pill.
   - Then the agent working, then the live result (6#8, 6#14, 6#9).
   - Check the command and every claim against the docs first: SKILL.md section 2 truth rules, and the `npx supermemory plugin` notes in `lessons.md`.
6. **Graph shots.** From one labelled memory, zoom out to the graph in under 2s, drag a node, dive until titles read, then resolve the path into a readable source panel (6#4, 6#17, 6#18).
7. **One anchor across any montage:** a single memory dot or tile at fixed screen coordinates (1#19, 2#4).
8. **Change the visual metaphor.**
   - Four supermemory films (2#10, 2#16, 2#17, 2#21) share the save-then-recall relay, and two (2#16, 2#21) share the same dark chat-plus-panel layout. Keep the relay and change the surface.
   - "Written in one tool, recalled in another" can be a ground switch like 5#19's light and dark modes.
9. **Move more.** Her product-UI films measure 24 to 63% moving, against 63% for demos and 81% for UI-morph reels here. Push in, keep the cursor working, and morph instead of holding.
10. **Mix to about -14 LUFS.** The learner-1 film sits at -7.1, and the Keiki clip at -34.9.
11. **Use the product's own words.** Per Dhravya's MCP note, use the term the docs, code and posts use.

**Competitors.** 6#1 is a memory product for Claude ("company brain"). It is in the study only as a craft example of the news-peg hook. Never cite or share it, or any memory-infra company's video, in public material (her no-competitors rule).

---

## 13. Where the evidence is

- `library/videos/README.md`: every video by format, with its link, length, views and measured numbers.
- `library/videos/1-reels-a.md` to `6-launches-b.md`: the per-video notes, each with:
  - the hook in the first 3s;
  - the beats with times;
  - the ending;
  - the look: ground, palette, type, fills, camera, transitions;
  - the measured numbers;
  - why it works;
  - what to borrow and what not to copy.

  Each batch ends with its patterns and lessons.
- `recipes/`: one build recipe per format, with targets from section 2.
- `engine/tools/study_video.py`: measure any new reference the same way before borrowing from it.
