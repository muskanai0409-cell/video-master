# Lessons from Muskan's video work (Sep 12 to Oct 6, 2026)

Every note she gave, every rule it turned into, and every technical fix, so the next video starts where the last one ended. Read §1 for her taste, §2 before planning, §3 before building, §4 before writing any caption or tweet, §5 as the never-again list and §6 before posting.

This file records history and reasons. For how-to detail it cites the existing skills instead of repeating them: `VM` (video-master), `CMG` (code-motion-graphics) and `P` (her supermemory video pack).

## Conventions

- **Dates** are IST, the Mac's local clock, as the READMEs and memory notes record them. Transcript timestamps are UTC, so a note typed after 18:30 UTC lands on the next IST day.
- **`~`** marks a pack round with no date of its own. It is placed beside the Claude session where the same video was under review.
- **Quotes** are her words, typos kept. `…` marks a cut. "(brief text)" means a patch spec she pasted into Hyperagent. "(q)" means she typed it while Claude was mid-turn.
- **Newest wins** when sources disagree. §6.2 lists every conflict found.

### Source keys

| Key | Path |
|---|---|
| `M:<name>` | `/Users/muskan/.claude/projects/-Users-muskan-supermemory/memory/<name>.md` |
| `R:<dir>` | `/Users/muskan/supermemory/reports/videos/<dir>/README.md`. Other files in that folder are named directly, for example `namespaces-v5-src/make.sh` |
| `VP` | `/Users/muskan/supermemory/reports/video-prompts/memory-graph-15s.md` |
| `P:<path>` | `<path>` inside `~/Downloads/supermemory-video-skills (1).zip`, unzipped at `/private/tmp/claude-501/-Users-muskan-supermemory/22aa6ebb-6a41-4f1b-aca6-06715e9fd28d/scratchpad/vpack/supermemory-video-skills/` |
| `VM:<path>` | `~/.claude/skills/video-master/<path>` |
| `CMG:<path>` | `~/.claude/skills/code-motion-graphics/<path>` |
| `T:<id>@<MM-DD>T<hh:mm>Z` | a message she typed, in `/Users/muskan/.claude/projects/-Users-muskan-supermemory/<id>….jsonl`. Ids: `a970dfa1` (Sep 14 to 17), `3ddc516a` (Sep 20 to 22), `fcc01c64`, `836e08db`, `22aa6ebb` (the main video session), `bb7348ba` (memory graph, recall strip), `573c812a` (namespaces). "(q)" messages are stored as `queued_command` attachments, so a search of plain user messages misses them |
| `TR:<id>@<time>` | Claude's own reply at that time in the same transcript |
| `S:<path>` | any other file, path given in full |

---

## 1. Her feedback log

68 notes in date order. Within a day, rows are grouped by video. The `#` numbers are used for cross-references in later sections. The caller's example "why are you making it so ai generated" does not appear verbatim in any source. The nearest real lines are #20, #26 and #49.

| # | Date | Video, version | What she said | The rule it became | Still current? | Source |
|---|---|---|---|---|---|---|
| 1 | ~Sep 16 | good memory, Hyperagent cut (brief 23) | "do adeep deep thought process and then make the most perfect video" | Plan before rendering: tweet, then beat sheet, then sourced facts, then stills, then the full render | yes | `P:briefs/23-good-memory-tweet-beats.md` |
| 2 | Sep 16 | good memory | "make it quality of the video even better becasue now we are potraying ourselves as a memory giant" (q) | Every cut is a flagship brand piece. Check the live site for branding first | yes | `T:a970dfa1@09-16T12:09Z` |
| 3 | Sep 16 | good memory | "we neeed the video to be short only just 15-120 seconds" … "bro dont need 50 sec video" | Fix a cut by patching it, not by making it longer. Runtime ceilings are hard | yes. Ceilings are now set per format (§2.2) | `T:a970dfa1@09-16T12:46Z`, `12:48Z` |
| 4 | ~Sep 16 | good memory rebuild (brief 24) | (brief text) "tried to carry seven captions and five separate mechanisms" | One mechanism, proved. One idea and one line per beat | yes | `P:briefs/24-good-memory-rebuild.md` |
| 5 | ~Sep 16 | good memory (brief 27) | "i just needed a bit of an update to the video you made before not completely change it" | "update" means patch: keep the structure, engine, grammar and beats, and list what changed | yes | `P:briefs/27-good-memory-update-tweet.md`, `P:reference/feedback-rules.md` |
| 6 | Sep 16 | good memory v4 | "is this video correct accoring to the tweet you gave?" | The tweet and the video say the same thing. If they differ, fix the video | yes | `T:a970dfa1@09-16T15:01Z`, `P:skills/voice-and-copy/SKILL.md` §3 |
| 7 | Sep 17 | good memory v4 | "fix the branding abit too according to the brand guidelines … dont change the video" | Brand fixes are patches: exact site tokens, ink-alpha greys, the official lockup | yes | `T:a970dfa1@09-16T19:08Z`, `P:briefs/32-good-memory-patch.md` |
| 8 | ~Sep 17 | good memory patch (brief 32) | (brief text) "HISTORY and UNCONFIRMED are currently both a white square with a thin blue outline" | Opposite meanings never share a glyph: hairline for history, dashed pale fill for a guess | yes | `P:briefs/32-good-memory-patch.md` |
| 9 | Sep 17 | temporal search | "make it simple yet so beautifully simple and smart to understand it like 10-12 sec video" | Short concept cut built on one device | the length is superseded (16:9 explainers now run 25 to 30s, #44, #47) | `T:a970dfa1@09-17T04:09Z` |
| 10 | ~Sep 17 | temporal search patch (brief 39) | (brief text) "THE CAPTION COUNTS TWO, THE SCREEN SHOWS THREE" | A caption never counts what the screen doesn't show. Show the step that does the work (the parse) | yes | `P:briefs/39-temporal-search-patch.md` |
| 11 | ~Sep 17 | profile buckets v1 (brief 40) | "MAKE THIS VIDEO A BIT DIFFERENTLY … MAYBE SOME CREATIVE ANGLE TO IT" | A licence to change the device, never the brand | yes | `P:briefs/40-profile-buckets-v1.md` |
| 12 | Sep 17 | profile buckets v1 (11s) | "this can be a bit longer … change the font, please check the brand guidelines … max 20 sec" | Geist for content, Geist Mono for labels. No Space Grotesk in supermemory films | the font rule holds. The 20s cap is superseded by the per-format lengths | `T:a970dfa1@09-17T11:56Z`, `P:briefs/41-profile-buckets-rebuild.md`, `M:video-prompt-format` |
| 13 | Sep 17 | profile buckets v2 | "make it more polished and easier to understand (looks a bit all over the place after 0:12)" | At most two changes on a frame (nine events became three). Cards never cross: separate on x first, then y | yes | `T:a970dfa1@09-17T12:31Z`, `P:briefs/42-profile-buckets-patch.md`, `P:reference/case-studies.md` |
| 14 | ~Sep 17 to 21 | profile buckets dusk re-skin (brief 46) | "make it so polished, aesthetic like our branding is on point and still keep the video super easy to understand" | Tried a dusk ground: `cta-dawn.jpg` under a 0.55 to 0.60 ink scrim with a white dot field | superseded by #17 | `P:briefs/46-profile-buckets-dusk-reskin.md`, `P:reference/brand-systems.md` |
| 15 | Sep 21 | dreaming (brief 52) | "super polished as per our brand guidelines … high motion graphic which look super cool" | Brand-exact and high-motion in the same cut | yes | `T:3ddc516a@09-21T07:55Z` |
| 16 | Sep 21 | dreaming white v1 | "make the subtitles smaller they look very big … i think we can more animations" | Captions shrink when they fight the figure (56 to 38px). Never two captions on one frame: the old one fades out over 160ms rising 8px, then the new one fades in over 220ms | the no-overlap rule holds. Small captions are superseded for 16:9 by #34 | `T:3ddc516a@09-21T11:12Z`, `P:briefs/56-dreaming-white-patch.md` |
| 17 | ~Sep 21 | dreaming white (brief 56) | "a plain white one and adhere to the brand guidelines" | A light ground is the explainer default | yes for explainers. Product films moved to the hero film (#65) | `P:reference/feedback-rules.md`, `P:skills/supermemory-explainers/SKILL.md` |
| 18 | ~Sep 21 | dreaming white v2 (brief 57) | (brief text) "No frame between 16.4s and 19.0s may be empty white." | No empty frame between scenes. No card within 24px of another, including mid-move | yes | `P:briefs/57-dreaming-white-patch2.md` |
| 19 | Sep 21 | dreaming white v3 | "let's add some sound effects here … the sounds should be simple and short" | Sparse register: 3 or 4 cues, no music, no reverb, no sci-fi, silence between | yes for silent explainers. Product films use the synth score (#57) | `T:3ddc516a@09-21T11:43Z`, `12:03Z`, `P:briefs/58-dreaming-sound-design.md` |
| 20 | Sep 21 | dreaming tweet | "this is very ai generated … litrally how docs and dhravya talk abot dreaming" | The tweet that carries a video uses the docs' and Dhravya's own wording | yes | `T:3ddc516a@09-21T08:03Z` |
| 21 | ~Sep, before 28 | smfs v1 (brief 84) | "i need a explainer video on this, not more than 20-30 seconds" | A runtime in the brief is a hard ceiling | yes | `P:briefs/84-smfs-research-brief.md` |
| 22 | ~Sep, before 28 | smfs v1 sound | "it sounds AI-generated" (as the pack records her verdict) | No whooshes and no metronome ticks. Real typing, two thumps at most. Transitions carry one shape into the next, with no white flashes | yes | `P:skills/sound-design/SKILL.md` §1, `P:briefs/89-smfs-feedback-smoother.md` |
| 23 | ~Sep, before 28 | smfs v3 | "I don't want the video to be more than 40 seconds... check out this for real runs" | Real run data beats illustrative data. smfs films use the smfs.ai brand | yes | `P:skills/smfs-benchmark-explainer/SKILL.md` §6 |
| 24 | Sep 28 | smfs v3 (39.5s) | "is there something that can be better or polished or something that is wrong?" | Re-derive every number from the public runs: no "454" folder, the Starlight hero, no dollar figures | yes | `T:fcc01c64@09-28T14:26Z`, `M:smfs-explainer-fact-check` |
| 25 | Sep 29 | smfs v3 to v4 | "how we can make this video a bit shorter but still have the full context" | Cut by timing, not by content (39.5s to 27.5s). Take the motion from the revid benchmark, never its look | yes | `T:836e08db@09-29T11:19Z`, `P:briefs/97-smfs-v4-recut.md`, `P:reference/x-motion-benchmark.md` |
| 26 | Sep 29 | smfs v4, main-page post | "this is very ai generated can we use the language from our docs nnd blogs only pls" | Main-page copy reuses lines from the docs and blog | yes | `T:22aa6ebb@09-29T15:38Z` |
| 27 | ~Sep | console walkthrough v1 to v5, agents clip | (the pack records the changes, not her words) | 17 whooshes became 5. Copy halved. Holds of 3.5 to 4s. Tilt only as an accent. A navy gradient opening was rejected as off-brand. 60s ceiling | yes, except "real capture only", which #54 replaced | `P:skills/console-product-films/SKILL.md` §5, §7, §8 |
| 28 | Oct 1 | site screen recording, framed v1 | "i think we gotta amke the background smaller nd better it's plain nd boring" | Make the window bigger and use brand imagery instead of a plain gradient | superseded the same day by #30 | `T:22aa6ebb@10-01T13:12Z` |
| 29 | Oct 1 | site recording, "dazzle" v1 | "just start directly with the website and not any animation in the starting" | No intro logo animation. Frame 0 is the content | yes | `T:22aa6ebb@10-01T14:06Z` |
| 30 | Oct 1 | site recording, dazzle v3 | "remove the background nd save in my desktop" | For a site recording, the site shown full frame beat a decorative frame | yes | `T:22aa6ebb@10-01T14:27Z`, `S:~/Desktop/supermemory-site-no-background.mp4` |
| 31 | Oct 2 | memory graph brief | "GIVE ME A VIDEO PROMPT NOT MORE THNA 15 SECONDS THO" | 15s square, with a real console capture of the graph | the length is superseded by #34 | `T:bb7348ba@10-02T12:04Z` |
| 32 | Oct 2 | memory graph v1 (dusk) | "the background looks very dull as well … eve thye facts stated could have been better" | Open on paper and flood the frame with the field film at the turn. Use dev example facts, each with a source | yes | `T:bb7348ba@10-02T13:37Z`, `VP`, `M:memory-graph-video` |
| 33 | Oct 2 | memory graph v2 | "make sure you're using the skills and the refrence vidoes i sent you" (q) | Measure motion against the revid X benchmark | yes | `T:bb7348ba@10-02T13:39Z`, `M:memory-graph-video` |
| 34 | Oct 2 | memory graph v2 to v3 | "make the video more longer like 20 seconds and make the font a bit more bigger" | 16:9 needs about 1.5x the square type sizes. Full plain sentences at 80px beat 2 to 4 word display lines | yes | `T:bb7348ba@10-02T14:20Z`, `R:memory-graph-src-v3` |
| 35 | Oct 2 | memory graph v3 | "clear distinction that left example is of git and right is og obsidian so it looks very very polished" | A titled panel names each example. Names only, no third-party logos | yes | `T:bb7348ba@10-02T14:56Z`, `M:memory-graph-video` |
| 36 | Oct 2 | memory graph v3 | "is the language also coherent with whats written in our docs??/" (q) | Check every caption line by line against the docs | yes | `T:bb7348ba@10-02T14:57Z`, `R:memory-graph-src-v3` |
| 37 | Oct 2 | memory graph v3 | "let's make the memory graph video a bit bigger" | "Bigger" was ambiguous. The real graph clip went from 700 to 860px, and the delivery note said which reading was used | yes | `T:bb7348ba@10-02T15:28Z`, `TR:bb7348ba@10-02T15:36Z` |
| 38 | Oct 2 | memory graph v3 | "is this video technically and factually correct??" | Two git slips fixed ("when a line changed", a real diff line). Never call the clip "live". Never claim supermemory reads git | yes | `T:bb7348ba@10-02T15:36Z`, `M:memory-graph-video` |
| 39 | Oct 5 | AI memory YouTube script | "keep the video around 5-6 min explaienr part and is it necessary to have so many graphics??" | A short cut of about 5 to 6 minutes with 9 to 11 frames instead of 33 | yes | `T:fcc01c64@10-04T19:17Z`, `M:ai-memory-explainer-video` |
| 40 | Oct 5 | AI memory YouTube script | "i cant see anywhere vector graph, rag, chucking and anything emntioned, we need to add it" | Teach the basics the reference videos cover: RAG, chunks, embeddings, the vector graph | yes | `T:fcc01c64@10-05T13:25Z`, `M:ai-memory-explainer-video` |
| 41 | Oct 5 | mcp upload v1 (square, 24.8s) | "a bit unclear first we need to explain as to what is the problem or what is being solved" | Problem first, then why it matters, the old way, the turn and the new way | yes | `T:22aa6ebb@10-05T09:58Z`, `VM:references/story.md` |
| 42 | Oct 5 | mcp upload v1 | "polished in 16:9 proper segregations and formatting and also use supermmeory branding" | 16:9 by default, with a text column, a figure stage, a HUD and chapter progress, in site branding | yes | same message, `VM:SKILL.md` §1(b) |
| 43 | Oct 5 | mcp upload v1, about the @himanshubuildss reel | "people love when theres a lot of movement things are blending into each other form 1 thing to other thing" | One continuous take where objects morph into the next scene. 60% or more of frames moving | yes | same message, `VM:references/inspiration.md` |
| 44 | Oct 5 | mcp upload v2 (36.8s) | "not to make it more bigger than 25-26 seconds and make sure all the diagrams are a bit bigger" | 16:9 explainers run 25 to 26s at most. Figure 1040px wide, camera at 1.6 to 2.3x | the cap holds, with the comprehension exception in #47 | `T:22aa6ebb@10-05T10:18Z`, `R:mcp-upload-16x9-src` |
| 45 | Oct 5 | mcp upload v2 | "and make it more cooler like the videos i shared" | A cursor drives the drags and clicks. The camera is never still, something lands about every 0.5s, and springs overshoot slightly | yes | `T:22aa6ebb@10-05T10:19Z`, `M:mcp-upload-video` |
| 46 | Oct 5 | mcp upload v3 | "is the video factually corrrect can you check our docs and eevrything how dhravya was talking about it?" | Build a claim table against code, docs and posts. Dhravya has no public post on the ticket mechanism, so get a yes before posting | yes | `T:22aa6ebb@10-05T10:50Z`, `R:mcp-upload-16x9-src` |
| 47 | Oct 5 | mcp upload v3 (26s) | "at 0:10 it's not at all undertsandable that it's corrupted we gotta make sure thta people are understanding" | Being understood beats the length cap. Every failure gets a 2 to 3s close-up and a before/after ("sent" vs "received"). v4 runs 30s | yes | `T:22aa6ebb@10-05T11:31Z`, `R:mcp-upload-16x9-src` |
| 48 | Oct 5 | mcp upload tweet | "what is base 64?? will people undertsand it in the content" | Plain words over jargon: "types it out as text" | yes | `T:22aa6ebb@10-05T11:28Z`, `M:main-account-copy-format` |
| 49 | Oct 5 | mcp upload tweet, main account | "i have told yopu multiple times to keep the language how syeprmemoey keps it … fuyllstops agauina dn aagijn" | The main account copies supermemory's own post shape and phrases, with zero full stops | yes | `T:22aa6ebb@10-05T11:51Z`, `M:main-account-copy-format` |
| 50 | Oct 5 | one memory, every agent (brief, 45 to 60s) | "make sure we are using all the logos in the most creative way" | Use the console's own SVG marks as the logos, and check which agents the claim actually covers | yes | `T:22aa6ebb@10-05T12:04Z`, `R:one-memory-src` |
| 51 | Oct 5 | one memory v1 (45s) to one command | "okay this is cool but i just wanted the video from 0:29 seconds" … "write less, showcase more" | Lift the product moment into its own short film: bigger screen, fewer words | yes | `T:22aa6ebb@10-05T13:36Z` |
| 52 | Oct 5 | one command (brief) | "not bullshit ia generated music but something cool like just the tune of "no pole" by don toliver" | Never put a commercial song or its melody in a file. She then picked: cut to its beat, reuse captures, console only, 5 agents at about 20s | yes (the copyright rule) | `T:22aa6ebb@10-05T13:36Z`, her answers at `13:39Z`, `R:one-command-src` |
| 53 | Oct 5 | one command v1 (20.6s, 128 BPM cut) | "ohhh dont use that music at all please, and dont copy each prompt" … "IS VERY VERY BAD VIDEO" | A full redo, because she asked for one: copy only the universal command, run it in a terminal, then each agent's tab, and end on "give your agents persistent memory" | the structure holds. The music part is superseded by #57 | `T:22aa6ebb@10-05T14:03Z`, `R:one-command-v2-src` |
| 54 | Oct 5 | one command v1 | "I CANT SEE THE CONSOLE VIDEO PROEPRLY IT'S SO LOW QUALITY … DONT USE THE SCREENRECORDINGLY DIRECTLY" (q) | Rebuild product UI in vector from the measured DOM. Render a 4K master and a lanczos 1080p cut. This overrides the pack's "real capture only" rule | yes | `T:22aa6ebb@10-05T14:05Z`, `M:console-ui-vector-not-screenshots` |
| 55 | Oct 5 | recall strip (brief) | "just the screen and the updates … around 15 seconds will be fine" … "show more of termin al" | Close-ups on the terminal's recall lines | the length is superseded by #61 | `T:bb7348ba@10-05T13:38Z` |
| 56 | Oct 5 | recall strip (brief) | "YOU CAN TOTALLY USE TERMINAL AND RECPRD YOURSELF OR MAKE THINGS UP OR USE DHRAVYA'S VIDEO" | Made-up examples are allowed when she says so. The README lists what is made up, and the film is never called live | yes | `T:bb7348ba@10-05T14:10Z`, `M:recall-strip-video` |
| 57 | Oct 6 | one command v2 (14.5s, silent) | "i think we should add some cool fast music as well as sounds in it" | An original score synthesised in code, plus CC0 Kenney keys and clicks. The picture moves to the music grid | yes | `T:22aa6ebb@10-05T19:35Z`, `R:one-command-v2-src` (v3) |
| 58 | Oct 6 | one command v2 | "add that motion graphic in which supermemory logo was in between and it was spinning all the plugins" | The plugin ring orbiting the blue tile: 7 plugins, AmpCode left out | yes | `T:22aa6ebb@10-05T19:37Z`, `R:one-command-v2-src` (v3) |
| 59 | Oct 6 | recall strip v1 | "remove the claude tweet about the mod tools it looks very unserious and cheap" | No typeset tweet or quote cards; a focus beat replaces them. Swap out Dhravya's real example | yes | `T:bb7348ba@10-05T19:44Z`, `R:recall-strip-src` (v2) |
| 60 | Oct 6 | one command v3 (18s) | "make everyhting a bit bigger like increase the fonts a bit more still incorporating everything" | UI type, icons and rows at 1.12x the page, at the same card width. Closer camera. Nothing cropped | yes | `T:22aa6ebb@10-05T20:26Z`, `R:one-command-v2-src` (v4) |
| 61 | Oct 6 | recall strip v2 (15s) | "increase the length of the video a bit longer to make things bit more understandable and smooth" | 15s became 21.6s, with terminal text at about 46 to 48px on screen. She prefers about 20s or more with room per beat | yes | `T:bb7348ba@10-05T20:29Z`, `M:recall-strip-video` |
| 62 | Oct 6 | one command tweet | "need to post it from the main account, must be in the langauge we alraedy use in our docs" | Docs lines first, then the changelog. Link the console's agents page for the one command | yes | `T:22aa6ebb@10-05T20:48Z`, `M:main-account-copy-format`, `M:one-memory-video` |
| 63 | Oct 6 | one command v4 | "I THINK IN THE VIDEO WE CAN MAKE IT SUPERMEMORY BACKGROUND CODED, LIKE SOME PRETTY BACKGROUND" | Tried a dawn computed in code from the colours of `cta-dawn.jpg` (`sky.swift`) | superseded by #65 | `T:22aa6ebb@10-05T20:54Z`, `R:one-command-v2-src` (v5) |
| 64 | Oct 6 | recall strip v3 (21.6s) | "remove the subtitles on the top it looks very bad … keep it like before but make it super polished" | A UI film can run with no caption bar. The picture carries the story | yes for UI films | `T:bb7348ba@10-05T21:01Z`, `R:recall-strip-src` (v4) |
| 65 | Oct 6 | one command v5 (dawn) | "i dont like the background, can we have something from here" (with a recording of the supermemory.ai hero) | The ground is the brand's hero film `field.mp4` with the site's tint. Blue UI accents turn white. Scenes cut on music hits | yes. Her reaction to v6 is not on file | `T:22aa6ebb@10-05T23:29Z`, `R:one-command-v2-src` (v6) |
| 66 | Oct 6 | one command v6 | "choose what looks the best … very very polished" … "Yes, download it" | She hands over look choices, but each asset download still needs her OK | yes | her answers at `T:22aa6ebb@10-05T23:37Z`, `M:supermemory-site-media` |
| 67 | Oct 6 | mcp upload v4 to v5 (Dhravya's note, which she passed on) | "We should specify that supermemory has an MCP app (i forgot the word for it)" | The fix line became "supermemory has an mcp app that opens in your chat", and the app header reads "mcp app" | yes | `R:mcp-upload-16x9-src`, `T:22aa6ebb@10-06T09:34Z` |
| 68 | Oct 6 | namespaces v5 (brief) | "make a cool 15-20 second video around it , also check some more info from the console" | A 15 to 20s launch film, checked against the live console (the popup was not deployed yet) | yes | `T:573c812a@10-06T09:44Z`, `R:namespaces-v5-src` |

---

## 2. Craft rules that hold today

### 2.1 Story and structure

- **Problem first.** Make the viewer feel the problem before any mechanism appears. Then give one sourced number, the old way, the turn (a flood) where supermemory is named, one step per beat, what the user actually gets, the thesis once, the lockup and a still. [#41, `VM:references/story.md`]
- **One mechanism, proved.** Never count what the screen doesn't show, and show the step that does the work. [#4, #10, `P:reference/feedback-rules.md`]
- **Text load depends on the film type.**
  - Explainers use full plain sentences, one per beat (memory graph v3: 80px). [#34, `M:memory-graph-video`]
  - Product and UI films: "write less, showcase more". one command v1 added only three phrases of its own. The recall strip v4 has no captions at all. [#51, #64, `R:one-command-src`]
- **Frame 0 is the composed thumbnail.** Open on content, with no intro logo animation. [#29, `P:SKILL.md` §2 rule 7, `P:reference/x-motion-benchmark.md` point 6]
- **The payoff gets its own moment:** clear the screen, move in, pause. A counter lands, then holds 0.5s before the next event. [`P:reference/feedback-rules.md` Motion]
- **The ending:** thesis, then the official horizontal lockup, then a still of 1.2 to 2s whose decoded frames are identical. Product films end on one plain line: "give your agents / persistent memory", or "container tags are now [namespaces]". [`P:SKILL.md` §2 rule 9, `R:one-command-v2-src`, `R:namespaces-v5-src`]
- **Use her line when she gives one.** The one command headline is hers. [`R:one-command-v2-src` (v2 truth notes)]
- **Examples.**
  - Dev topics get dev examples: "deploys to vercel" became "deploys to cloudflare". [`M:memory-graph-video`]
  - Made-up examples need her say-so and get listed in the README: `~/code/storefront`, `user_123`. [#56, `R:recall-strip-src`, `R:namespaces-v5-src`]
- **Patch or redo.** "update" or "make it better" means patch. "VERY VERY BAD" or "redo" means rebuild the film, keeping the verified facts and assets. [#5, #53]
- **Think it through before rendering.** Render a contact sheet with one frame per beat, plus mid-transition frames, before the full render. [#1, `VM:references/qa.md` §1]
- **YouTube.**
  - Follow the PlanetScale model: teach agents generally, keep the tone genuine and serious, and keep AI-sounding language down. [`M:marketing-direction`]
  - The long script ran about 68% teaching and 32% supermemory, demo and CTA. Never name the competitor from a reference video. [`M:ai-memory-explainer-video`]

### 2.2 Length and pacing

| Format | Length now | How it got there | Source |
|---|---|---|---|
| 16:9 concept explainer | 25 to 26s, up to 30s when a beat needs it to be understood | mcp upload: 36.8s (too long), 26.0s, then 30.0s | #44, #47, `R:mcp-upload-16x9-src` |
| Product or launch film (console, CLI, announcement) | 15 to 20s | one command: 20.6s, 14.5s, 18.0s. namespaces: 19.5s | #52, #68, `R:one-command-v2-src`, `R:namespaces-v5-src` |
| Feature film built on a terminal UI | about 20s or more, with room per beat | recall strip: 15.0s, then 21.6s | #61, `M:recall-strip-video` |
| Square concept cut (pack era) | 11 to 23s | good memory 18 to 23.2s, temporal 12 to 14.6s, buckets 11 to 19.4s | `P:reference/case-studies.md` |
| Multi-part explainer plus product film | 45s (from a 45 to 60s brief) | one memory v1 | #50, `R:one-memory-src` |
| smfs data film | 40s at most. 27.5s shipped | 28s, 53.5s, 39.5s, 27.5s | #21, #23, #25 |
| Console walkthrough | 60s hard ceiling, 58s working | 48 to 51.5s | `P:skills/console-product-films/SKILL.md` §8 |
| YouTube explainer | about 5 to 6 min (short cut about 6:05, 929 words) | the 11:02 long version is kept for reference | #39, `M:ai-memory-explainer-video` |

Pacing:
- Each statement holds 2.5s or more (the pack default; smfs v4 used a 1.8s floor). Only one is on screen at a time, and never before its subject. [`P:SKILL.md` §2 rule 6]
- Each key change (a failure, the turn, a result) gets 2 to 3s with the camera on it. [#47, `VM:SKILL.md` §1(f)]
- Something happens about every 0.5s. No dead hold longer than about 1s before the end card. [#45, `VM:SKILL.md` §1(d)]
- To shorten, merge statements before cutting chapters. Eight statements of 2.6 to 3.0s, a turn of about 1.2s and an end card of about 2.6s fit 26s. [`VM:SKILL.md` §1(f)]

### 2.3 Motion and camera

- **Frame rate and blur.** 60fps, with 4-subframe motion blur. The shutter is 0.35 of a frame in the UI films (§3.3). [`R:one-command-v2-src`, `namespaces-v5-src/lib.swift`]
- **One continuous take.** Each scene grows out of the last. The turn uses a flood-and-shrink with the field film. No white flashes, no stock wipes, no crossfade where two scenes' text overlaps. [#43, #22, `VM:references/motion-grammar.md`]
- **One easing family.**
  - Moves use cubic-bezier(.2,0,0,1), arrivals (.22,1,.36,1), and camera moves (.5,0,.2,1).
  - Springs are closed-form at 2.4Hz with 0.62 damping, overshooting slightly. The pack allowed one spring per piece; her "make it cooler" moved this to one spring family throughout. [`namespaces-v5-src/lib.swift`, `VM:SKILL.md` §1]
- **The camera never rests.** Each beat gets a quick eased move of 0.55 to 0.8s, then a slow smoothstep drift that follows the action. A drawn cursor drives the real actions (drag, click, copy) and scales with the camera, with click ripples. [#45, `R:recall-strip-src` (v3), `R:mcp-upload-16x9-src` (v3)]
- **Motion target.** 60% or more of frames moving, with the longest still about 1s or less before the end card, on the pack metric (§3.6). Her Oct 5 to 6 cuts measured 72.9 to 88.8%.
  - The metric only registers change over a sizable area, so make the big things move. A small chip moving on paper counts as still. [`M:memory-graph-video`, `VM:references/qa.md` §2.3]
- **"Bigger" means a closer camera plus a type scale, never a crop.**
  - Full card at 1.86 to 1.93x.
  - Copy push at 2.6 to 2.74x.
  - Terminal at 1.7x.
  - Recall close-ups at 2.8 to 3.0x.
  - Explainer figures at 1.6 to 2.3x.
  - [#44, #60, `R:one-command-v2-src` (v4), `R:recall-strip-src` (v3)]
- **Background scene cuts land only on music hits** (drops, the final hit). The pop scan flags them, which is expected (§3.6). [`R:one-command-v2-src` (v6), `R:namespaces-v5-src`]
- **Landing into the still.** The background film eases to a stop (frame steps 0.005, 0.004, 0.002, 0.001, then 0) and parallax reaches zero, so the ground doesn't stop dead. [`R:one-command-v2-src` (v6), `namespaces-v5-src/film_bg.swift`]
- **Frame-locked text.** Typed text, counters and countdowns are locked to whole frames, so blur never smears them. [`R:mcp-upload-16x9-src` (v2 QA), `quant()` in `namespaces-v5-src/lib.swift`]
- **Measured lesson from SuperRAG:** v1 was 19% moving with 80% of the cut still. v2 fixed it with 480ms arrivals rising 26px and by filling six dead stretches. [`P:reference/case-studies.md`]

### 2.4 Type and legibility

- **Typefaces.** Geist for statements and content, Geist Mono for labels, code and terminals, both as variable weights. No Space Grotesk or Inter in supermemory films; smfs films keep the smfs.ai type. [#12, `M:video-prompt-format`, `P:reference/brand-systems.md`]
- **Sizes.** 16:9 needs about 1.5x the square sizes.
  - 80px captions at 1920 wide read as about 16px on a 390px phone, and 64px is the floor for statements.
  - Labels are 26 to 28px at minimum; smfs v4 raised its small labels to 28px. [#34, `VM:references/brand.md` §4]
- **UI text on screen.**
  - The console card went from about 23 to 27px after the 1.12x scale.
  - The one command terminal went from about 22 to 29px.
  - The recall close-ups run about 46 to 48px.
  - Console detail in a wide shot is small at phone size, so push in. [`R:one-command-v2-src` (v4), `R:recall-strip-src` (v3), `R:one-memory-src` (QA)]
- **Check at phone size.** 390px wide (360px for squares), always including the busiest frame. Export the busiest frame as a PNG. [`P:reference/qa-checklist.md`]
- **Lowercase "supermemory"** everywhere, even inside an uppercase label row. The engine's `label()` uppercases, so brand words go through `text()`. [`P:reference/brand-systems.md` §5, `VM:references/pipelines.md` §3]
- **Tabular digits** for counters, right-aligned at a fixed edge. [`P:skills/supermemory-explainers/SKILL.md` §4]
- **Flag legibility scaling.** Scaling UI type above the page (`US = 1.12`) is a deliberate deviation, and the delivery note must say so. [`R:one-command-v2-src` (v4)]

### 2.5 Brand surfaces: which system for which video

| Surface | Use it for | Tokens to hold | Her films on it | Source |
|---|---|---|---|---|
| **supermemory.ai site** | concept explainers, and the explainer parts of launch films | ground `#ffffff` (body) or paper `#f4f4f6`; ink `#0b1015`, every grey an ink alpha; one blue `#0562ef` for the proof only, first at the turn and never removed; `#9ec6f7` on dark grounds only; Geist and Geist Mono; radius 0 | good memory to dreaming (paper), memory graph v2 and v3, mcp upload v1 to v5, one memory v1, recall strip v1 to v4 (white) | `P:reference/brand-systems.md` §1, `VM:references/brand.md` |
| **Brand guidelines PDF** (`~/Downloads/Supermemory Brand Guidelines.pdf`) | console and product films | blue 500 `#0562EF` and blue 600 `#0100F5` (never both blues in a site-surface film); ink 950 `#0B1B41`; four logo colourways only (paper on blue, paper on ink, and their inverses); the horizontal lockup; 8x8 Bayer halftone composited by threshold; memory-field dots square at rest and turned 45° when recalled | the pack's console walkthrough and agents clip. Its colourway, halftone and dot rules carried into one command v5 and v6 and namespaces | `P:reference/brand-systems.md` §2, `R:one-command-v2-src` (v5, v6) |
| **smfs.ai** | smfs data films only | `#fafaf8`, ink `#2c1a0e`, terracotta `#d4785a` (only ever smfs), Space Grotesk and DM Mono, lockup "mark × smfs." | smfs explainer v1 to v4 | `P:reference/brand-systems.md` §3, `M:smfs-explainer-fact-check` |
| Inside a film: the console's own UI | product UI rebuilt in vector | the console CSS dark tokens: `#151515` float, `#101010`, `#0a0a0a`; text `#f5f5f5` / `#a2a2a2` / `#838383`; accent `#2f86ff`; success `#4fb877`; borders white at 7% | one command v2 to v6, namespaces | `R:one-command-v2-src` (v2), `R:namespaces-v5-src` |

The Oct 6 launch films mix systems: the site's hero film as ground, the console's tokens for the UI, and the PDF's paper-on-blue colourway for the lockup and the white accents. Name that mix in the delivery note. [`R:one-command-v2-src` (v6), `R:namespaces-v5-src`]

### 2.6 Backgrounds: what she accepted and rejected

| Ground | Where | Her verdict | Status | Source |
|---|---|---|---|---|
| Flat paper `#f4f4f6` or white | concept series, good memory to dreaming white | "a plain white one…" after the dusk try | the explainer default | #17 |
| Dusk: `cta-dawn.jpg` under a 0.55 to 0.60 ink scrim, with a white dot field | buckets re-skin, dreaming photo brief, memory graph v1 | dropped for "plain white"; memory graph v1 got "background looks very dull" | retired | #14, #32 |
| Paper or white, with a field-film flood at the turn | memory graph v2 and v3, mcp upload v2 to v5, one memory v1, recall strip | no complaint on file | current for explainers | `R:memory-graph-src-v2`, `R:mcp-upload-16x9-src`, `R:recall-strip-src` |
| Brand-blue gradient plus a browser frame, then the PDF sky texture | Oct 1 site recording | "plain nd boring", then "remove the background" | site recordings now run full frame | #28, #30 |
| The blue field film full frame at half speed, under real console captures | one command v1 | the cut was "VERY VERY BAD" (music, copying every command, soft captures) | superseded | #53, `R:one-command-src` |
| White dot grid | one command v2 to v4 | asked for a "pretty background" | superseded | #63 |
| Dawn computed in code: sky gradient, dot-matrix sun with a Bayer edge, recall rings | one command v5 | "i dont like the background" | rejected | #65, `R:one-command-v2-src` (v5) |
| The hero film `field.mp4` with the site tint, scenes cut on hits | one command v6, namespaces | asked for "something from here" (the site hero) | current for product and launch films. Her reaction to the result is not on file | #65, `R:one-command-v2-src` (v6) |

- The thistles scene (orange memory tiles) was tried behind the tabs and dropped. The tiles crowded the white logo chips, and the fine detail showed the 720p source's softness at 1.9x. [`R:one-command-v2-src` (v6)]
- Ask her before inventing a background. Use the brand's own media first (§3.11). [`M:supermemory-site-media`]

### 2.7 Sound

- **Pick a register** from the pack:
  - A: sparse cues, for silent explainers.
  - B: a cue palette over a bed.
  - C: music plus physical effects, with scene changes on hits (data films).
  - D: a flat launch bed, deliberately not synced.
  - Never apply one register's sync rule to another. [`P:skills/sound-design/SKILL.md` §2]
- **What she ruled out:**
  - Whooshes and metronome ticks: "it sounds AI-generated". [#22]
  - A commercial song or its melody, even as a beat reference. [#52, #53]
  - "bullshit ia generated music" [#52]: the score is composed in code, with no generative audio model and no stock music. [`R:one-command-v2-src` (v3)]
- **What she asked for:** "cool fast music as well as sounds". [#57]
- **The current recipe** (one command v3 to v6, namespaces):
  - 160 BPM (beat 0.375s, bar 1.5s) in F minor (Fm, Db, Ab, Eb), with 808/909-style drums and a sub bass.
  - Supersaw stabs with sidechain pumping, and a pluck hook with a dotted-eighth ping-pong delay, in a Freeverb room.
  - Drops land on the big picture changes, every click lands on a kick, and a final Fm9 hit lands on the end line.
  - The picture moves to the music grid through a shared `timeline.swift`. [`R:one-command-v2-src` (v3), `namespaces-v5-src/sound.swift`]
- **Effects** (each must have a physical cause on screen):
  - Real CC0 Kenney recordings for copy and tab clicks, the paste key, the enter key (aligned to its thock, 168ms into the sample) and typing.
  - Tuned pops for logos, and a soft bell dyad for "one approval" and the lockup.
  - A felt thump exactly twice, and no whooshes. [`R:one-command-v2-src` (v3), `R:namespaces-v5-src`]
- **Mix check:**
  - Band RMS: below 120Hz -15.3, 120 to 400Hz -20.0, 400Hz to 2k -21.1, 2 to 8k -26.1, above 8k -29.4 dB. The first pass was 11 dB too bass-heavy.
  - Each effect peaks 1.6 to 7.5 dB over the music around it. [`R:one-command-v2-src` (v3)]
- **Loudness.** The 2026-10-06 films master at -14 LUFS with true peak -1 dBTP by two-pass loudnorm, measuring -13.8 LUFS with peaks of -3.2 to -3.3 dBFS.
  - The pack and VM house target is -16 LUFS, and X reels sit at -12 to -14.6.
  - She never ruled on this (§6.2). [`namespaces-v5-src/make.sh`, `P:reference/x-motion-benchmark.md`]
- **Nobody has listened yet.** Claude cannot hear the mix. Every scored film says it has not been auditioned, and she listens on laptop speakers and headphones before posting. [`R:one-command-v2-src`, `R:namespaces-v5-src`]
- **Voiceover** is her own voice, never cloned or synthesised, with music ducked 18 to 20 dB under it. [`P:skills/smfs-benchmark-explainer/SKILL.md` §7]

### 2.8 Copy for the tweet that carries the video

- **The tweet and the video say the same thing.** Reuse the video's own on-screen lines. [#6, `P:skills/voice-and-copy/SKILL.md` §3]
- **@supermemory main account.**
  - Shape: one lowercase opening line, then "- " bullets, then a plain closing line.
  - Zero full stops, no colon before a list, under 280 characters.
  - Wording comes from the live docs first, then real posts, then the changelog. Swap the docs' em dashes for commas.
  - Plain words: "types it out as text", not "base64".
  - [#48, #49, #62, `M:main-account-copy-format`]
- **Her own account.**
  - One hook, short tilde bullets, a CTA, links in the first reply, at most 280 characters.
  - Open on her reaction, with run-on commas and one real imperfection.
  - One concrete example, labelled [real], [sourced] or [scene]. Never a fake stat or a fake quote.
  - No em dashes, no not-X-but-Y, no period-staccato. Lowercase "i", never "we".
  - [`M:short-tweet-format`, `M:drafts-ai-tells`, `M:concrete-examples-in-tweets`, `M:content-voice-rules-pointer`]
- **Linking the one command.** The docs never mention `npx supermemory plugin`, so link the console's agents page. [`M:one-memory-video`]
- **Approval.** A mechanism or plugin film needs a yes from Dhravya or Prasanna before the main account posts it. Claude drafts only and never posts. [`R:mcp-upload-16x9-src`, `R:one-memory-src`, `VM:SKILL.md` §8]
- **Measure outcomes.** A video is an input; signups are the outcome. Name the metric (for example, a per-person attribution link) when proposing a video. [`M:growth-outcomes-call`, `M:growth-analytics-mandate`]
- **Existing drafts.** Main-account drafts for the one command film are at `~/content-engine/drafts/2026-10-06-one-command-video.md`. [`M:one-memory-video`]

---

## 3. Technical pipeline lessons

### 3.1 Toolchain on this Mac

- This Mac has no numpy and no ffmpeg on PATH. The working ffmpeg 6.0 is bundled at `/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg` (with `ffprobe`). Swift is 6.3.3. If the Cardboard app goes, stop and ask her. Never install ffmpeg unasked. [`VM:references/pipelines.md` §1]
- **How the pipeline evolved:**
  - Sep: Hyperagent prompts, then the pack's Python engine (numpy and PIL).
  - Oct 2: memory graph ran in a venv with `numpy pillow imageio-ffmpeg`.
  - From Oct 5: Swift (CoreGraphics and CoreText), which needs no installs.
  - [`M:video-prompt-format`, `R:memory-graph-src`, `M:mcp-upload-video`]
- **Use x264 for finals.** AVFoundation's H.264 encoder made still endings shimmer. [`M:mcp-upload-video`]

### 3.2 Render architecture

```bash
cd /Users/muskan/supermemory/reports/videos/<name>-src
cat lib.swift timeline.swift film_bg.swift film.swift > render.swift && swiftc -O render.swift -o render
SCALE=1 ./render stills 0 2.6 3.9 6.9      # 1080p stills/t_*.png + stills/sheet.png, look before rendering
./make.sh                                   # 4K master, 1080p cut, QA, score, mux
```

- **Pure `render(t)`.** Every value is a function of `t`. Beat times live in `timeline.swift` (`bt(bar, beat)` on the 160 BPM grid), which the score also reads.
  - `./render check` and `./render debug` print statement widths and holds, and measured text widths against the screenshot ("measured 351").
  - [`namespaces-v5-src/timeline.swift`, `namespaces-v5-src/film.swift`, `R:one-memory-src`]
- **One frame at a time for CoreGraphics. Only pure maths runs in parallel.**
  - Drawing frames on several threads at once made CG get edge coverage wrong, and once a colour (a green 1px terminal edge).
  - one command v4 had 120 of its first 400 frames differ between two runs; mcp upload v4 had 85 of 400.
  - After the fix, two full 1080p renders matched on 1080 of 1080 frames.
  - The sky and plate pixels and the blur averaging run on `DispatchQueue.concurrentPerform`, over 32 chunks or over rows.
  - [`R:one-command-v2-src` (v5), `R:mcp-upload-16x9-src` (v5), `namespaces-v5-src/film.swift`]
- **Repeatability check.** Hash every frame of two runs and expect zero differences. `framehash.py` writes an md5 per 1920x1080x4-byte frame. [`S:/private/tmp/claude-501/-Users-muskan-supermemory/22aa6ebb-6a41-4f1b-aca6-06715e9fd28d/scratchpad/framehash.py`, `TR:22aa6ebb@10-05T21:23Z`]
  ```bash
  for k in 1 2; do SCALE=1 ./render raw 2>/dev/null | python3 framehash.py h$k.txt; done; diff h1.txt h2.txt | grep -c '^<'
  ```
- **The still ending.** Frames at or after `T_STILL` are rendered once and the same bytes are written for every later frame. [`namespaces-v5-src/film.swift`]
- **Render times:**
  - The 36.8s 16:9 engine renders in about 40s.
  - one memory took about 60s; one command v1 about 2 min.
  - 4K films with a plate and a score take about 15 to 20 min.
  - [`VM:engine/README.md`, `R:one-memory-src`, `R:one-command-src`, `R:namespaces-v5-src`]

### 3.3 Motion blur

- Each output frame averages 4 subframes: `t_k = t0 + (k/4 - 0.5) * SHUTTER / 60`. Each subframe is accumulated into a `UInt16` buffer, then `out = (acc + 2) / 4`. The still frames skip blur. [`namespaces-v5-src/film.swift`]
- **SHUTTER by film** (newest kept):

  | SHUTTER | Equivalent | Used in | Why |
  |---|---|---|---|
  | 0.5 | 180° | mcp upload 16:9, one memory v1 | default blur |
  | 0.3 | 108° | one command v1 | "so UI text holds up in camera moves" |
  | 0.35 | | one command v2 to v6, recall strip, namespaces | current for UI films |

  [`mcp-upload-16x9-src/render.swift`, `one-command-src/render.swift`, `one-command-v2-src/lib.swift`, `R:one-command-src`]
- **Frame-locking.** Typing, counters and countdowns use `quant(t) = round(t * 60) / 60`. [`namespaces-v5-src/lib.swift`]

### 3.4 The 4K master and the lanczos 1080p cut

- Design in 1920x1080 and render at `SCALE=2` (3840x2160). The 1080p file is a lanczos downscale of the decoded 4K, so both share every pixel decision. [`R:recall-strip-src` (v1), `R:one-command-v2-src` (v2)]
- **Frozen-frame hold for the 1080p cut.** Trim at the first still frame (+2), scale, clone the last frame with `tpad`, re-encode with a high-quality zone, then copy exactly N frames. Otherwise the downscaled hold isn't byte-identical. [`namespaces-v5-src/make.sh`, `R:recall-strip-src` (v3)]

```bash
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
X="colorprim=bt709:transfer=bt709:colormatrix=bt709:range=tv:keyint=600:bframes=0"
SCALE=2 ./render raw | $FF -v error -y -f rawvideo -pix_fmt bgra -s 3840x2160 -r 60 -i - \
  -vf "scale=out_color_matrix=bt709:out_range=tv,format=yuv420p" -c:v libx264 -preset slow -crf 14 -tune animation \
  -profile:v high -level 5.2 -x264-params "$X:zones=1048,1169,q=1" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv -movflags +faststart $V4
$FF -v error -y -i $V4 -vf "trim=end_frame=1060,setpts=PTS-STARTPTS,scale=1920:1080:flags=lanczos,tpad=stop_mode=clone:stop=115" \
  -c:v libx264 -preset slow -crf 14 -tune animation -profile:v high -x264-params "$X:zones=1048,1175,q=1" \
  -colorspace bt709 -color_primaries bt709 -color_trc bt709 -color_range tv qa/tmp1080.mp4
$FF -v error -y -i qa/tmp1080.mp4 -c copy -frames:v 1170 -movflags +faststart $V && rm qa/tmp1080.mp4
```

(These are the namespaces numbers: still at frame 1058 (17.625s), 1170 frames in total.)

- **Bitrates.** 4K runs 15.9 Mb/s on the computed sky, 23.4 Mb/s for namespaces and 28.0 Mb/s (63 MB) for one command v6. 1080p runs 6.4 to 10.4 Mb/s. Moving footage costs bits. [`R:one-command-v2-src` (v5, v6), `R:namespaces-v5-src`]
- **Resolution claims.** `field.mp4` is 1280x720. Never call a film "native 4K" or "native 1080p" when footage in it is upscaled. [`VM:references/pipelines.md` §2, `P:skills/voice-and-copy/SKILL.md` §4]

### 3.5 x264 settings and the still ending

- Fixed flags: `bframes=0`, `keyint=600`, `-tune animation`, `-preset slow`, `-crf 14` at 4K (16 on the older 1080p-native films), with bt709 tags on both the stream and the container. An untagged encode decoded `#0562ef` as `#065dff`. [`namespaces-v5-src/make.sh`, `R:mcp-upload-src`, `P:skills/supermemory-explainers/SKILL.md` §4.1]
- **Zones give the hold identical decoded frames.**
  - Start the zone about 10 frames before the still, so x264 has converged when the hold begins.
  - On a flat ground use `q=6`. On a grainy, dithered or film ground use `q=1` (near lossless), and start the zone inside the last motion so the quality switch is hidden. Otherwise x264 keeps refining the grain and the hold "snaps".
  - [`VM:references/pipelines.md` §2, `R:one-command-v2-src` (v5)]

| Film | Still from frame | Zone | Identical decoded end frames | Source |
|---|---|---|---|---|
| mcp upload v1 (test re-encodes) | 1379 | zone at 1392 gave 93; zone at 1370 gave 110 | 93 shipped | `VM:references/pipelines.md` §2 |
| mcp upload v4, v5 | | `1712,1799,q=6` | 81 (1.35s) | `R:mcp-upload-16x9-src` |
| one memory v1 | | `2604,2699` | 94 (1.57s) | `R:one-memory-src` |
| one command v1 | | `1125,1237` | 112 (1.87s) | `R:one-command-src` |
| one command v5, v6 | | `921,1079,q=1` (4K), `921,1085,q=1` (1080p). 921 is 15.35s, inside the lockup's motion | v5 90/90, v6 89 (1080p) / 88 (4K) | `R:one-command-v2-src` |
| recall strip v4 | 1188 | `1178,1295,q=6` (4K), `1178,1355,q=6` (1080p, `tpad stop=167`) | 114 (1080p) / 115 (4K) | `recall-strip-src/make.sh`, `R:recall-strip-src` |
| namespaces | 1058 | `1048,1169,q=1` (4K), `1048,1175,q=1` (1080p) | 112 / 111 | `namespaces-v5-src/make.sh`, `R:namespaces-v5-src` |

### 3.6 QA metrics (the newest form, from `namespaces-v5-src/make.sh`)

```bash
# motion: the pack metric. 30fps, 160x90 grey; a frame is moving when its mean abs difference (YAVG) is >= 0.15
$FF -v error -i "$V" -vf "fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/motion.txt" -f null -
awk -F= '/YAVG/{n++; v=$2; if(v>=0.15) m++; t=n/30.0; if(v<0.15){ if(run==0) s=t; run++ } else { if(run>=12) printf "still %.2f-%.2f (%.2fs)\n", s, t, run/30.0; run=0 } } END{ printf "moving %.1f%%\n", 100*m/n }' qa/motion.txt
# pops: native 60fps, 320x180; flag a frame whose difference is > 3x its larger neighbour and > 1.5
$FF -v error -i "$V" -vf "scale=320:180,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=qa/pop.txt" -f null -
awk -F= '/YAVG/{k++; v[k]=$2+0} END{n=0; for(i=2;i<k;i++){a=v[i-1]; b=v[i+1]; nb=(a>b?a:b); if(v[i]>3*nb && v[i]>1.5){ printf "pop %.3fs %.2f\n", i/60.0, v[i]; n++ } } print n" pop candidates"}' qa/pop.txt
# hold: how many identical decoded frames end the file
$FF -v error -i "$V" -f framemd5 - | grep -v "^#" | awk -F, '{print $6}' | tail -115 | uniq -c | tail -1
# loudness, after the AAC mux
$FF -hide_banner -i "$V" -vn -af ebur128=peak=true -f null - 2>&1 | grep -A14 "Summary" | grep -E "I:|Peak:"
```

- **Pop candidates are not defects until someone looks.**
  - On one command v6 the scan flagged exactly the 4 planned scene cuts (3.000, 6.000, 11.250 and 14.633s), and on namespaces the same (3.000, 6.000, 9.000 and 15.000s). Each was checked frame by frame.
  - On one command v1 it flagged 8 on-beat UI state changes.
  - [`R:one-command-v2-src` (v6), `R:namespaces-v5-src`, `R:one-command-src`]
- **Decoded colour:** sample an 8x8 patch, scaled to one pixel with area filtering (`VM:references/qa.md` §2.2). Expect 2 to 3 levels of drift, more on thin lines (4:2:0 chroma).
  - `#0562ef` decodes as about `#0260ed` on a tile, `#0460eb` on a 3px line and `#0061f7` in the word "namespaces".
  - White decodes as `#fdfdfd`, paper as `#f3f3f5`, and the terminal (drawn `#0a0a0a`) as `#090909`.
  - If every hex in a note of hers is a lightened token (`#007af5`, `#fdfdfd`), she eyedropped a scaled preview. Fix the tagging, not the colours.
  - [`R:mcp-upload-src`, `R:namespaces-v5-src`, `R:recall-strip-src`, `P:skills/supermemory-explainers/SKILL.md` §4.2]
- **Always name the metric.** The early "85%" and "72% moving" figures came from a looser homemade metric. The pack metric gave 31.4% (§6.2). [`R:mcp-upload-16x9-src`, `M:mcp-upload-video`]
- **Calibration** (pack metric, % moving / longest still before the end card):

  | Film | Result |
  |---|---|
  | mcp upload v3, v4, v5 | 72.9 / 0.93s, 75.2 / 1.03s, 75.1 / 1.03s |
  | one memory v1 | 78.1 / 0.83s |
  | one command v1, v2, v5, v6 | 88.8, 76.7, 84.2, 84.0 |
  | recall strip v1, v2, v3, v4 | 84.4, 84.6, 78.7, 79.9, with stills of 0.17 to 0.23s |
  | namespaces | 77.7 / 0.63s |
  | smfs v3, v4 | 29 / 2.8s, 27 / 3.8s |
  | X benchmark | reels 80 to 100, explainers 42 to 45 |

  [the READMEs, `P:reference/x-motion-benchmark.md`]
- **Also check:**
  - ffprobe tags (bt709 x3, tv range).
  - A whole-film contact sheet, a phone sheet at 390px and strips across every statement change (`VM:references/qa.md` §2.1, §2.6 to §2.8).
  - A fresh critic subagent handed the MP4, the brief and her words, never your own reasoning (`VM:references/qa.md` §3).

### 3.7 Vector rebuild of product UI from the measured DOM

- **Measure the live page** in her signed-in Chrome (local view only, nothing saved):
  - every element's box via `getBoundingClientRect`, and every computed style (Geist 13 / 12.5 / 11.5 / 12px, Geist Mono 12.5px, `#f5f5f5` / `#a2a2a2` text, `#0a0a0a` card, `#101010` header and command boxes, `#121212` on hover, borders white at 7%, the active pill `#0d131a` with a `#1e3973` border, the check `#4fb877`);
  - the page's own SVG paths for icons;
  - hover and copied behaviour (the copy icon fades in over 0.18s; on click it scales out and the check scales in);
  - every tab's exact text, including truncation at the box width.
  - [`R:one-command-v2-src` (v2)]
- **When only a screenshot exists** (namespaces, from Mahesh's dev-build screenshot):
  - measure at the screenshot's scale (1.392 screenshot px per CSS px);
  - take the console's colours from its stylesheet (`console.supermemory.ai/assets/index-CqOVIG2B.css`) and its icon set (lucide);
  - fit the text widths to the screenshot (title 348 vs 351 measured).
  - [`R:namespaces-v5-src`]
- **Invent nothing.** Every string on the card is the page's own, and real ✓ states come from real clicks. Say "rebuilt in vector" in the delivery note. No console shell around a popup taken from someone else's account. [`R:one-command-v2-src`, `R:namespaces-v5-src`]
- **Why vector:** JPEG captures upscaled under camera zoom looked soft, and vector stays sharp at any zoom and at 4K. [`M:console-ui-vector-not-screenshots`]

### 3.8 Typeset terminals and plugin UI

- **CLI terminal:** typeset from the CLI's source strings (`supermemory@4.25.4`, `bin/cli`): `printSupermemoryBanner` (glyphs and the CLI's own banner hexes), `printDetectionSummary`, `finishArrowPrompt` and `printPluginAuthStart` ("One approval connects Claude Code, Cursor, OpenCode, Codex."). [`R:one-memory-src`, `R:one-command-v2-src`]
- **Claude Code terminal:** rebuilt in Geist Mono from Dhravya's session plus the plugin's sources: `statusline.js`, `recall-strip.js`, `recall-approve.js`, and `colors.js` for the mark tint `#7c78fa`. Glyphs (◪ ⎿ ▾ ⏵) are drawn as shapes. Hook prefixes were shortened so lines fit; say so. [`R:recall-strip-src`]
- **Computed values:** the repo tag hash is computed in the renderer (CryptoKit SHA-256 of the normalized origin, giving `e11588c4b6c4bf0e`). [`R:one-memory-src`]

### 3.9 Fonts

- `Geist.ttf` and `GeistMono.ttf` (variable) sit in each `<name>-src/fonts/` and in `VM:engine/assets/fonts/`.
- Register them with `CTFontManagerRegisterFontsForURL(..., .process, nil)`. Set the weight through `kCTFontVariationAttribute` with the `wght` tag `0x77676874`, and cache fonts by family, size and weight.
- In the bitmap context, call `setShouldSmoothFonts(false)` and flip `textMatrix` for the y-down canvas.
- [`namespaces-v5-src/lib.swift` lines 78-96, `namespaces-v5-src/film.swift` (`makeContext`)]

### 3.10 Logos and the lockup

- **Agent logos** are the console's own marks: the inline SVG `outerHTML` read from the agents page, plus `console.supermemory.ai/marks/openclaw.svg` and `/marks/hermes.svg`. [`R:one-memory-src`, `TR:22aa6ebb@10-05T12:10Z`]
- **Rasterising with alpha:**
  - `sips` was tried first. A 15-line AppKit tool (`raster.swift`) does the job: `NSImage(contentsOf: svg)`, drawn `.sourceOver` into a cleared `NSBitmapImageRep` with `hasAlpha: true`, 1200px on the long side, written as PNG.
  - CoreSVG misread the compact arc flags in `codex.svg` and `hermes.svg`. `fixarc.py` expands them first.
  - Both tools live only in session scratch: `S:/private/tmp/claude-501/-Users-muskan-supermemory/22aa6ebb-6a41-4f1b-aca6-06715e9fd28d/scratchpad/onememory/logos/` (`raster.swift`, `fixarc.py`). The PNGs and SVGs are kept in `one-memory-src/logos/`.
- **Check every download.** curl on a missing `/marks/<name>.svg` saved the site's fallback HTML as a fake logo. Check the HTTP code and the content. [`TR:22aa6ebb@10-05T12:11Z`]
- **Tinting a single-colour logo:** `alphaMask()` turns RGBA alpha into a grey mask, which is painted through `clip(to:mask:)`. [`namespaces-v5-src/lib.swift`]
- **The supermemory lockup** uses the luminance masks `lock_mark.png` (588x480) and `lock_word.png` (3182x381):
  - gap 230, wordmark top 99px below the mark top, within about 2% of the PDF p.14 geometry;
  - horizontal, never stacked or redrawn;
  - paper on blue over the hero film.
  - [`VM:references/brand.md` §5, `P:reference/brand-systems.md` §2]

### 3.11 Brand film plates (`field.mp4`)

- **The source.** `https://supermemory.ai/brand/media/field.mp4`: 1280x720, 25fps, 32s, 2.3 MB. A copy is in `one-command-v2-src/bg/` (namespaces symlinks it). Downloading needs her OK each time.
  - Six scenes, cut every 4s: cosmos (0-2s and 22-32s), blossoms (2-6), rock (6-10), thistles with orange tiles (10-14), a mountain over clouds (14-18) and a flower (18-22).
  - [`M:supermemory-site-media`]
- **The site's look.** The site shows the film under a multiply tint of `#0562ef` at 0.62. That equals per-channel gains of R x0.392, G x0.618, B x0.961.
  - The plate's cosmos averages (3,62,199); her recording of the live site averages (6,61,193).
  - [`M:supermemory-site-media`, `R:one-command-v2-src` (v6)]
- **Build the plate once.** It is a 1.1x-frame raw RGB file of all 800 frames (6.0 GB), which `make.sh` rebuilds if missing:
  ```bash
  $FF -v error -y -i bg/field.mp4 -vf "scale=w=2112:h=1188:flags=lanczos:in_color_matrix=bt709:in_range=tv:out_range=pc,format=rgb24,colorchannelmixer=rr=0.392:gg=0.618:bb=0.961" -f rawvideo bg/plate_2112x1188.rgb
  ```
- **Playing it in Swift:**
  - `mmap` the plate and sample it bilinearly. Blend between neighbouring 25fps frames so it plays smoothly at 60.
  - **Never blend across the film's own cuts:** `FILM_CUTS = {50, 150, 250, 350, 450, 550}`.
  - An edit list maps each film section to film time, with every cut on a music hit, and slows from real time to a stop (`u * (2 - u)`) into the still.
  - Parallax: the film moves 6% as far as the world and zooms by the 0.2 power of the camera, reaching zero at the end.
  - [`namespaces-v5-src/film_bg.swift`]
- **The older JPEG path** (memory graph, mcp upload): extract only from inside one scene (for example 22 to 32s) and blend to 60fps. Plain `fps=60` judders.
  ```bash
  $FF -y -ss 22.0 -t 2.8 -i field.mp4 -vf "scale=1920:1080:flags=lanczos,framerate=fps=60:interp_start=0:interp_end=255" -q:v 2 -start_number 0 field/f%04d.jpg
  ```
  [`R:mcp-upload-16x9-src` (v3), `R:one-command-src`]
- **Recolour for a blue ground:**
  - ring lines and memory dots white;
  - the centre tile white with a blue mark;
  - text white or white at 78%;
  - the label a white box with blue text;
  - the command chip plain white.
  - The one blue left is the proof. [`R:one-command-v2-src` (v6), `R:namespaces-v5-src`]
- **Other brand media on the site:** `cta-dawn.jpg` (1408x782), `meadow.mp4` (1800x1004), `/brand/plans/{pro,max,scale}.jpg`, and `/what/{learn,carry,scale}.mp4`. The console's login hero meadow is `/assets/login-hero-poster-BGSFNUhU.jpg`. [`M:supermemory-site-media`, `M:namespaces-v5-video`]

### 3.12 Dither and halftone

- **Triangular dither** of about 1.6 levels (a 256x256 tile, xorshift) is added in the sky and plate pixel loops. It removes 8-bit banding in gradients and upscales and reads as fine grain. [`R:one-command-v2-src` (v5), `namespaces-v5-src/film_bg.swift`]
- **The computed sky** is drawn at quarter resolution, then upscaled bilinearly with the dither. It showed no banding. [`R:one-command-v2-src` (v5)]
- **The brand halftone** is an 8x8 Bayer threshold: never blurred, softened or randomised. In v5 it edged the dot-matrix sun on a 12px grid of white squares; recalled dots turn 45°. [`R:one-command-v2-src` (v5), `P:skills/supermemory-explainers/SKILL.md` §1.3]
- **Grain and the encoder.** Grain makes x264 keep refining the still, which is why those films use `q=1` zones started inside motion (§3.5).

### 3.13 Screen capture in Chrome, and her own recordings

- **Screen recording permission.** The app has no screen-recording permission, so `screencapture -l<windowid>` fails. Only she can grant it, in System Settings. [`R:one-memory-src`, `TR:22aa6ebb@10-05T13:37Z`]
- **The localhost capture inbox:**
  - Isolate the element in the page: a fixed backdrop in the page colour, then the element set to fixed position with CSS `zoom` (1.45x for the card, 2 to 3x for close-ups).
  - Take a Chrome-extension screenshot and `upload_image` it into a local page served by `python3 server.py` on `127.0.0.1:8765`. The page POSTs the file to `/save`, using the page title as the file name.
  - The page only repaints when a screenshot is taken, so take two shots per state.
  - Capture wide elements as tiles and join them in empty space.
  - Real ✓ states come from real clicks, which also copy each command to her clipboard.
  - [`R:one-memory-src`, `R:one-command-src`, `TR:22aa6ebb@10-05T12:15Z` to `12:17Z`]
- **Video frames from the built-in browser pane:** download them as one canvas atlas into `~/Downloads`. The pane blocks bursts of downloads. [`M:recall-strip-video`]
- **Video in the Chrome extension:** its agent window sits off-screen, so video never plays there. [`M:recall-strip-video`]
- **Loom downloads** need a paid plan. "Download video" redirected to an Atlassian billing page, and nothing was clicked there. [`M:recall-strip-video`]
- **Console sign-in:** the built-in browser pane is not signed in to the console. [`M:namespaces-v5-video`]
- **Her recordings land in `~/Desktop/Screenshots/`.** Filenames carry a U+202F before AM/PM. The `Group Containers/group.com.apple.screencapture` path she pastes is temporary and unreadable. [`M:supermemory-site-media`]
- **Cleaning her recordings.**
  - Trim the end, where the macOS recording toolbar and the dashed selection outline appear.
  - Crop the 2px dark line at the top edge (3px to be safe).
  - Retime a jerky scroll to a constant glide (9 px per frame).
  - Patch out the cursor, matching the page's brightness.
  - [`TR:22aa6ebb@10-01T12:35Z`, `13:15Z`, `13:49Z`, `14:30Z`]
- **Privacy.** Keep names, emails, workspace names and machine names out of frame. Never click a graph node (it opens real memory text). Keep frames containing a face local (`caps/` in `recall-strip-src`). [`VP` (capture steps), `R:recall-strip-src`, `P:skills/console-product-films/SKILL.md` §3]

### 3.14 Audio build

- **The score** is synthesised in `sound.swift` at 48kHz. It writes `audio/music.wav`, `audio/sfx.wav` and `audio/mix.wav`.
  - Kenney samples sit in `sfx/` as raw float32 `.f32` files: `click_002`, `003`, `005`, and `switch9`, `11` to `14`, `24`, `26` to `28`, `33`, `34`. Paste key `switch12`, enter key `switch33`, typing keys `switch12` to `14`.
  - `KENNEY_LICENSE.txt` (CC0) travels with them. The source WAVs are in `P:studio/sfx_lib/wav/`.
  - [`namespaces-v5-src/sound.swift`, `namespaces-v5-src/sfx/`]
- **Two-pass loudnorm and mux:**
  ```bash
  cat timeline.swift sound.swift > snd.swift && swiftc -O snd.swift -o snd && ./snd
  J=$($FF -hide_banner -i audio/mix.wav -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null - 2>&1 | sed -n '/^{/,/^}/p')
  # read input_i, input_tp, input_lra, input_thresh, target_offset from $J, then:
  $FF -v error -y -i audio/mix.wav -af "loudnorm=I=-14:TP=-1:LRA=11:measured_I=$I:measured_TP=$TP:measured_LRA=$LRA:measured_thresh=$TH:offset=$OFF:linear=true,aresample=48000" -c:a pcm_f32le audio/master.wav
  $FF -v error -y -i <name>-4k-silent.mp4 -i audio/master.wav -map 0:v -map 1:a -c:v copy -af apad -c:a aac -b:a 256k -ar 48000 -shortest -movflags +faststart <name>-4k.mp4
  ```
  [`namespaces-v5-src/make.sh`]
- **Always keep silent masters** (`-silent.mp4`) and the stems next to the scored files. [`R:one-command-v2-src` (v3)]
- **Hand her a beat-click version** when she will add her own track: a 128 BPM click track muxed onto the silent master (`aevalsrc`; high click on the bar downbeat). [`R:one-command-src`]

### 3.15 File locations

| What | Where |
|---|---|
| Finished films | `/Users/muskan/supermemory/reports/videos/<name>[-vN]-{4k,1080p}[-silent].mp4`, plus `<name>-busiest.png` |
| Source, one folder per film | `reports/videos/<name>-src/`: `lib.swift`, `timeline.swift`, `film_bg.swift`, `film.swift` (concatenated into `render.swift`), `sound.swift` (into `snd.swift`), `make.sh`, `fonts/`, `lock_mark.png`, `lock_word.png`, `logos/`, `sfx/`, `bg/`, `assets/`, `stills/`, `qa/`, `audio/` |
| Earlier versions | kept next to the current source as `film_vN.swift`, `make_vN.sh`, `render_vN.swift` |
| Hyperagent prompts | `/Users/muskan/supermemory/reports/video-prompts/` |
| YouTube scripts and diagrams | `/Users/muskan/supermemory/reports/video-scripts/` (patch the `diagrams/source/` templates, not the output) |
| Research behind films | `/Users/muskan/supermemory/.claude/reference/` (`mcp-app-upload-research.md`, `one-memory-every-agent-research.md`, `v5-api-research.md`, `v5-launch-blog-draft.md`, `muskan-links-index.md`, `smfs-video-script.md`, `dreaming-research-brief.md`, `dhravya-explainer-research.md`) and `research_notes/` |
| Her own cuts | `~/Downloads/smfs_explainer_v3_39s.mp4`, `~/Downloads/smfs_explainer_v4_27s.mp4` (her "bar" for memory graph v3), and the Oct 1 site edits in `~/Desktop/supermemory-site-*.mp4` |
| Brand sources | `~/Downloads/Supermemory Brand Guidelines.pdf`, the pack zip in `~/Downloads/`, `apps/web/public/logo-light-fullmark.svg` |
| Engine | `VM:engine/` (`reference-16x9.swift`, the fonts and the lockup masks) |

---

## 4. Truth and fact-check rules for supermemory claims

| Area | Rule | Source |
|---|---|---|
| "one memory" across agents | Only five agents key memory by repo: Claude Code, Codex, OpenCode, Cursor (marketplace build) and Muse Code. Say "five coding agents", never "every agent". OpenClaw (`openclaw_<hostname>`) and Hermes (`hermes`) don't key by repo. AmpCode's `amp-supermemory` is a 404 on npm. A ring of seven working plugins is fine only under a claim that isn't about sharing ("give your agents persistent memory") | `M:one-memory-video`, `R:one-memory-src`, `R:one-command-v2-src` (v3) |
| Cursor through the one command | `npx supermemory plugin` installs `cursor-supermemory@1.0.0` (2026-02-17), which keys by folder path, so Cursor set up that way doesn't share. Show the marketplace install (`/add-plugin cursor-supermemory`). Before posting, the team publishes the current build, or Cursor comes out of the OAuth line and the ring | `M:one-memory-video`, `R:one-memory-src` (must fix 1) |
| Console accuracy | Codex step 2 (`/supermemory-login`) is stale: never click it or push in on it. The AmpCode tab points at a package that doesn't exist | `R:one-memory-src`, `R:one-command-src` |
| Where to link | The docs never mention `npx supermemory plugin`. Link the console's agents page | `M:one-memory-video` |
| The repo tag | `repo_<name>__<first 16 hex of sha256(normalized origin)>`. SSH and HTTPS clones give the same tag (`e11588c4b6c4bf0e` for the supermemory repo). Compute it, never type it | `R:one-memory-src` |
| MCP app upload | Say "supermemory has an mcp app that opens in your chat", captioned "in chat apps that support mcp apps". The official term is "MCP Apps". Cursor renders them (since 2.6). MCP has no standard file upload yet (WG chartered 2026-04-23). The ticket is single use and lasts 2 minutes (`server.ts:27`, `space-state.ts:47-68`). 6,666,668 is the base64 length of 5,000,000 bytes (RFC 4648). The mechanism comes from open-source code, so get a yes from Dhravya or Prasanna | `R:mcp-upload-16x9-src`, `M:dhravya-explainer-research` |
| Recall strip | It is a rebuild of Dhravya's session: never "live" or "real footage". He called the expanded view "deliberately bad UX" and "an internal one", so never sell it as final. It needs Claude Code 2.1.287+ and plugin 0.1.9. The example and facts are made up, and the hook prefixes are simplified | `M:recall-strip-video`, `R:recall-strip-src` |
| Memory graph | The console clip is Prasanna's Sep 19 recording of an existing graph at 1.22x: never "live". supermemory doesn't read git history. Git tracks lines ("when a line changed"). Show only UPDATES and EXTENDS (the console legend has no derives type). "atomic facts", per the docs. The two-axes framing has no public Dhravya post, so never quote it as his. Graph counts change, so never show them. Avoid "git stores diffs", "obsidian has no history", memories as literal files, "never forgets", weight changes and benchmark numbers | `M:memory-graph-video`, `VP`, `R:memory-graph-src-v3` |
| API v5, namespaces | Post only after launch. The popup was not deployed (the screenshot came from a dev build; the live "What's new" stopped at Sep 14). Never show `attach` / `include`, header versioning or param counts. "forget merged" and "profile + search in one call" are wrong. The migration guide PR #1691 is unmerged. `user_123` and "alex is on the pro plan" are example values | `M:namespaces-v5-video`, `M:v5-api-launch`, `R:namespaces-v5-src` |
| smfs | Folder sizes are 5 to 9,988 (there is no 454; it's 480). The hero question is dp_013-q08 Starlight, not the Foundry dp_008-q06. No dollar figures. Say "smfs grep". Overall accuracy is about equal (92.7% vs 91.4%). "81% up from 69%" is the 9,988-file folder only, all from Claude Code. Never "71% fewer tokens", "50% faster" or "$20.95 vs $4.71 on a single question". Caveats go on screen for about 3s. Credit the mount and bash tool to Prasanna and xAFS to Soham | `M:smfs-explainer-fact-check`, `M:smfs-authorship`, `P:skills/voice-and-copy/SKILL.md` §4 |
| Benchmarks in general | The LongMemEval "97%" is a retrieval score (Recall@20 with aggregation). Never present it as answer accuracy. Re-read scale numbers on the live page the day you film. Every number needs a public source written next to it | `M:dhravya-explainer-research`, `M:beginners-guide-article`, `M:curation-no-competitors`, `VM:references/brand.md` §3 |
| Dreaming | No weight changes and no "learns overnight", cron or nightly framing. Never call it a summary. No benchmark numbers. It takes "minutes" (LiveKit docs say 10 to 20), never "at most 15" | `P:reference/case-studies.md`, `M:dhravya-explainer-research` |
| Search and docs | `/v4/search` defaults to `memories`, not hybrid. Caption field names as "current v4 API". The repo's claude-code docs page still says "Claude decides" | `M:dhravya-explainer-research`, `M:jev-article-research` |
| Products | Brain and Nova were discontinued: never present them as live. For Company Brain open source: no 0-100 scores, D1 rather than Postgres, a four-step setup, and "hundreds of companies" | `VM:references/brand.md` §6, `M:company-brain-open-source-research` |
| UI truth | Rebuilt UI must be exact (measured DOM or screenshot, real strings, real icons). Real states come from real clicks. Say "rebuilt" in the delivery note. Numbers in a captured console shot come only from its pixels | §3.7, `P:skills/console-product-films/SKILL.md` §1 |
| Privacy | Never put real personal memory text on screen (Dhravya's real fact showed his email, so made-up facts replaced it). Never use someone else's account shell (Mahesh's screenshot). Crop names, emails and workspace names | `R:recall-strip-src`, `R:namespaces-v5-src`, `VP` |
| Competitors | Never name the competitor from a reference video (the Hugging Face video is a Mem0 case study). No third-party logos beyond the agents a film is about | `M:ai-memory-explainer-video`, `VP` (never appears) |
| Approvals | A yes from Dhravya or Prasanna before main-account posts. Never post on her behalf. Each download of site or console media needs her OK | `R:mcp-upload-16x9-src`, `R:one-memory-src`, `M:supermemory-site-media` |

---

## 5. Anti-patterns she rejected

- Making a weak cut longer instead of better ("bro dont need 50 sec video"). [#3]
- Seven captions and five mechanisms in one cut. [#4]
- A caption count that doesn't match the screen. A window bracketing the wrong week. [#10]
- Busy back halves, "all over the place" (nine events at once). [#13]
- Captions too big for a square film, and a weak, "very light" last animation. [#16]
- The dusk photo ground. [#14, #17]
- Empty white frames between scenes. [#18]
- White flashes, the same whoosh at every scene change, metronome ticks. [#22]
- Tiny fine print, captions repeating the callout, counters that race on without landing. [`P:briefs/89-smfs-feedback-smoother.md`]
- Copy that sounds AI-written: full stops everywhere, tidy fact/reframe/moral shapes, wording that isn't supermemory's own. [#20, #26, #49, `M:drafts-ai-tells`]
- Too many whooshes (17), too much copy and fast holds in a console walkthrough. A navy gradient opening with texture through the logo's clearspace. [#27]
- Plain, boring backgrounds, and decorative frames around a site recording. [#28, #30, #32]
- Intro logo animations before the content. [#29]
- An explainer that doesn't say what problem it solves. [#41]
- Small diagrams; a slow explainer; a failure beat nobody can read. [#44, #45, #47]
- Jargon in copy ("base64"). [#48]
- A commercial song, its melody, or a beat-cut built around one. "bullshit ia generated music". [#52, #53]
- Copying every agent's command one by one. [#53]
- Soft, upscaled screen recordings or screenshots of product UI. [#54]
- A typeset tweet card ("very unserious and cheap") and someone's real internal example. [#59]
- A subtitle bar on top of a UI film. [#64]
- A background computed to look pretty instead of the brand's own footage. [#65]
- Pack-era mistakes that must not come back: Tailwind blues (`#2563EB`, `#60A5FA`), violet, Inter, neutral greys, a stacked lockup, colour tweens through periwinkle, eyedropped preview hexes. [`P:reference/brand-systems.md` §4, `P:skills/supermemory-explainers/SKILL.md` §7]

---

## 6. Open items and pending decisions

### 6.1 Open items

| # | Item | State | Source |
|---|---|---|---|
| 1 | Her reaction to the hero-film ground (one command v6, reused for namespaces) | not on file. Ask before the next film reuses it | `M:one-memory-video`, `R:namespaces-v5-src` |
| 2 | Scores on one command v3 to v6 and namespaces | nobody has listened. She checks on laptop speakers and headphones before posting | `R:one-command-v2-src`, `R:namespaces-v5-src` |
| 3 | Cursor npm build (path-keyed 1.0.0) | the team publishes the current build, or Cursor comes out of the OAuth line and the ring, before one memory or one command is posted | `R:one-memory-src` (must fix 1), `M:one-memory-video` |
| 4 | Console bugs shown in films | Codex step 2 is stale. The AmpCode tab points at a 404 package | `R:one-memory-src` (must fix 2) |
| 5 | Main-account approval | a yes from Dhravya or Prasanna for mcp upload, one memory and one command | `R:mcp-upload-16x9-src`, `R:one-memory-src` (must fix 3) |
| 6 | namespaces header art | waiting for her OK to download the console's `login-hero-poster-BGSFNUhU.jpg` (or `login-hero-D6y-S289.mp4`). Save it as `assets/hero.png` and rerun `make.sh`. The current inpainted crop is soft at 4K | `R:namespaces-v5-src` (open item 1), `M:namespaces-v5-video` |
| 7 | namespaces timing and claims | post only after the v5 announcement. Recheck whether PR #1691 has merged, whether the TS SDK has shipped, and whether the field is `attach` or `include` | `R:namespaces-v5-src`, `M:v5-api-launch` |
| 8 | Recall strip live demo | this Mac has Claude Code 2.1.280 and plugin 0.1.6, below the 2.1.287 and 0.1.9 the strip needs. Not upgraded | `M:recall-strip-video` |
| 9 | memory graph | quoting Dhravya's two-axes framing needs his OK. The post-copy rules apply (never "live", never "reads git") | `M:memory-graph-video` |
| 10 | smfs | v4 motion is 27% with a 3.8s still, below the 60% target. The SMFS YouTube script still needs its two beat-2 fixes before Soham records | `P:skills/smfs-benchmark-explainer/SKILL.md` §6, `M:smfs-video-script` |
| 11 | AI memory YouTube script | open: Virgil vs the Geist-only rule; demo prep (turn off Claude Code auto memory and Cursor Memories, use a repo with no CLAUDE.md); rewriting B18 and B21 | `M:ai-memory-explainer-video` |
| 12 | Springs | there is no recorded pushback on the spring family. If she pushes back, fall back to critically damped steps | `VM:SKILL.md` §1 |
| 13 | Loudness target | -14 LUFS (the Oct 6 films) vs -16 LUFS (pack and VM). Ask her once | §2.7 |
| 14 | Outcome tracking for videos | she asked for per-person attribution links. Nothing ties a video to signups yet | `M:growth-outcomes-call` |
| 15 | Scratch-only tools | `raster.swift`, `fixarc.py`, `framehash.py` and the capture inbox (`onememory/recv/`) live in session scratch. Copy them into the skill's engine to keep them | §3.10, §3.13 |
| 16 | 6 GB plate | `one-command-v2-src/bg/plate_2112x1188.rgb` can be rebuilt by `make.sh`. Delete it only with her OK | `one-command-v2-src/make.sh` |
| 17 | GitHub | on Oct 6 she asked to "add it all to github as a skill". code-motion-graphics went up through the web UI, because this Mac has no `gh` or SSH key | `T:22aa6ebb@10-06T10:54Z`, `M:code-motion-graphics-skill` |
| 18 | Brand bible | the "rebrand off flat paper" that was pending in Sep is settled for product films by the hero film. The brand bible with Shardul did not exist as of Sep 8; later status unknown | `M:video-prompt-format`, `M:marketing-direction` |

### 6.2 Where the sources disagree (newest kept)

| Topic | Older | Newer, kept | Sources |
|---|---|---|---|
| Product UI | The pack and the Oct 2 memory note: real capture only, never recreated | Oct 5: rebuild in vector from the measured DOM, inventing nothing | `P:skills/console-product-films/SKILL.md` §1, `M:video-prompt-format`, `M:console-ui-vector-not-screenshots` |
| Product-film ground | The pack: flat brand fields, no gradients. Then the computed dawn (v5) | v6: the hero film with the site tint | `P:skills/console-product-films/SKILL.md` §5, `R:one-command-v2-src` |
| Music | The pack: one quiet 90 to 110 BPM bed with no risers, drops or drums. Oct 5: "dont use that music at all" | Oct 6: a fast original synth score with drops. Never a commercial song | `P:skills/sound-design/SKILL.md`, #53, #57 |
| Loudness | The pack and `VM:references/qa.md` §2.9: -16 LUFS | The Oct 6 films: -14 LUFS / -1 dBTP. Not her ruling, so confirm with her | `namespaces-v5-src/make.sh` |
| Length | 10 to 12s, 15s, "max 20 sec", a 25 to 26s cap | Per format (§2.2). Being understood beats the cap | #9, #12, #31, #44, #47, #61 |
| Captions | The pack: "no frame without a caption" | Never two on one frame. Explainers use full sentences; UI films can run with none | #16, #34, #64 |
| Springs | The pack: at most one (smfs v4: none) | One spring family throughout | `P:SKILL.md` §2 rule 11, `VM:SKILL.md` §1 |
| Format | 1080x1080 at 30fps | 16:9 at 60fps. Squares are for social cuts | `VM:SKILL.md` §1 |
| Product name | The pack: only in the last 2s | At the turn, when the mechanism is the subject | `VM:SKILL.md` §1 |
| Type | Some pack briefs: Space Grotesk captions | Geist and Geist Mono only. smfs keeps smfs.ai type | `M:video-prompt-format` |
| Corners | Rounded stages (memory graph, mcp upload v1) | Radius 0 like the site, unless a brief asks. Rebuilt product UI keeps its own radii | `VM:references/brand.md` §3 |
| Motion figures | READMEs quoting 72% and 85% (homemade metric) | The pack metric, 31.4%. Sources disagree on which cut measured 31.4%: `VM:references/qa.md` says the square v1, while `R:mcp-upload-16x9-src` and `VM:SKILL.md` say the 16:9 v2 | §3.6 |
| Shutter | 0.5 (180°), then 0.3 | 0.35 for UI films | §3.3 |
| Threads | "frames in parallel" (`R:mcp-upload-16x9-src`, v3 rebuild note) | One frame at a time; only pure maths in parallel | §3.2 |
| Dreaming latency | Sep 21 brief: "at most 15 min catch-up" | Oct 5: "minutes" (10 to 20), never "at most 15" | `M:dreaming-research-brief`, `M:dhravya-explainer-research` |
| YouTube B11 chart | `M:beginners-guide-article`: the script still has the 97% vs 60% comparison | `M:ai-memory-explainer-video` (later the same day): fixed in `n6-search.png` | both notes |
| OpenAI dreaming page | `M:ai-memory-explainer-video`: still to confirm | `M:beginners-guide-article`: verified (openai.com/index/chatgpt-memory-dreaming, June 4 2026). Recheck before use | both notes |
| Docs as a source | `M:marketing-direction` (Sep 8): content comes from engineer calls, "never lifted from the docs or the blog" | Oct 5 and 6: main-account wording "must be in the langauge we alraedy use in our docs". These are different layers (where ideas come from vs how they are worded) | #49, #62 |
| Ground for explainers | The dusk photo | "plain white", then paper with a field-film flood | #14, #17, #32 |
