# Recipe: memory scenes

How to show memory on screen: writing it, recalling it, updating it and inspecting it. These scenes slot into any film about supermemory (a launch, a demo, an explainer, a reel). They come from what worked in the 304 bookmarked videos and from supermemory's own films in the set.

**Truth first.** Memory is injected into the model's context. Never draw weights changing, "learning overnight" or training (SKILL.md section 2). Every number on screen needs a source.

## The problem with what we have

**The relay is over-used.** Four supermemory films in the set use the same save-then-recall relay (2#10, 2#16, 2#17, 2#21), and two of them share the dark chat-plus-panel layout (2#16, 2#21). Keep the relay, which is the proof. Change the surface each time.

**Our UI films move less** (moving %):

| Film | Moving |
|---|---|
| 2#10 | 53% |
| 2#21 | 63% |
| 2#23 | 53% |
| 2#16 | 25% |
| 2#17 | 28% |
| 3#33 | 24% |
| Demos elsewhere (median of 49) | 60% |
| UI-morph reels with 500K+ views | 81% |

## Scenes

### 1. The memory lane (writes and recalls as a log)

- **What:** a narrow panel beside the conversation logs each memory operation as it happens. For example, `+ prefers TypeScript`, `↻ moved to Berlin (updates: lives in NYC)`, `↗ recalled 3 · project atlas`.
- **Why it works:**
  - 5#2's backend lane logs the call that set the display, and that one insert proved tool use for a 7.4M-view launch.
  - 5#17 and 6#9 run a counter through the whole demo.
- **Timing:**
  - Each entry slides in 0.25s after the chat line that caused it.
  - Recalls flash the source entry for 0.4s.
  - Hold the lane on screen for the whole scene.
- **Rule:** use the product's real terms. The console's graph legend shows UPDATES and EXTENDS (see the truth table in `lessons.md`). The engine notes are in `.claude/reference/memory-engine.md` in the supermemory repo. The lane lines above are illustrative: rewrite them from the docs.

### 2. Being remembered (the human beat)

- **What:**
  - Script the user's own surprise: "Wait, you remember that?" (5#13).
  - Or have the assistant name a preference the user stated earlier: "I know you like visuals" (5#11).
  - Then show the stored memory as a readable object for 1.5 to 2s.
- **Why it works:** the proof is a reaction, not a claim. A single personal callback (5#11 turns the kid's game into the math problem) carries a 139s ad.
- **Timing:** about 1s for the callback line, 1s for the reaction, 2s on the memory.

### 3. Days later (the time skip)

- **What:** facts dropped casually, then a "days later" card or a pan along a timeline, then one question whose answer is built from the earlier facts. Lines are drawn from the memory panel to the words they produced (2#16). Or the key nouns physically ride a timeline into the reply (2#17).
- **Change it next time:** carry the nouns as tiles that fly from session one's bubble into session two's answer. Or switch the ground for the second session, the way 5#19 uses light mode for you and dark mode for the other person.

### 4. Written in one tool, recalled in another

- **What:** save in client A, ask in client B. A close-up of the model or client label signals the switch (2#10).
- **Stronger version:** give each client its own ground or frame and cut on a match (the same chat input position). Or split the frame, and let a memory tile cross the seam.

### 5. Extraction (a document becomes facts)

- **What:** highlighter strokes sweep a page, then the highlighted phrases lift off into labelled pills that stack into the memory lane (3#29 does this for a different product).
- **Timing:**
  - the sweep takes 0.3s per line;
  - the lift-off takes 0.4s, with the page dimming to 45% as the pills rise;
  - the pills settle with one spring.

### 6. Recall as a status stack

- **What:** status lines stacking during retrieval: "Searching memories…", then "Found 4 in project atlas", then "Using: deadline Oct 8, owner Maya". The grammar is 5#18's seven "Web search…" lines and 1#2's "Reading sources… / Searching 2142 Files".
- **Then:** an answer that says where its context came from. Name the client, the date and the teammate (2#21). Or state that it pulled the project context from memory (5#23).

### 7. The readable memory page

- **What:** after the answer, open the memory itself as a page: what is stored, related items, where it came from. That makes memory inspectable, not magic (5#23, the closest analog in the set).
- **On supermemory:** rebuild the console's own memory view in vector. Do not invent UI (SKILL.md section 2).

### 8. The graph dive

- **What:**
  - Start on one labelled memory and zoom out to the whole graph in under 2s (6#4).
  - Drag one node so its edges stretch.
  - Dive in until the titles read.
  - Resolve the path into a readable strip or a source panel (6#17, 6#18).
- **Payoff:** the graph that grows out of the chat to fill the frame is the climax of 2#10.
- **Rules:**
  - Show the graph only while its labels are readable at 390px wide. A hairball with no readable label proves nothing.
  - A recorded console graph is never "live", and supermemory doesn't read git history (`lessons.md`, the truth table).

### 9. The install, literally

- **What:**
  - The MCP URL pasted into a connector field by about 5s (6#8).
  - Or the one command copied and run in a terminal, then the agent working, then the live result (6#14, 6#9).
  - End on the command in a terminal pill.
- **Check first:**
  - which agents the command really supports;
  - the docs gap noted in `lessons.md`: the docs do not mention `npx supermemory plugin`, so link the console agents page;
  - the exact product term (Dhravya: it is an MCP App).

### 10. One anchor through a montage

- **What:** one memory dot or tile at fixed screen coordinates while scenes change around it. Fast cuts then read as one thought (1#19's arc, 2#4's orange dot).

### 11. Two lanes, side by side

- **What:** the same prompt run with and without memory, two lanes stepping turn by turn, with token, time and cost counters and a red note where the memory-less side fails. Dhravya's markdown film and blog widget already do this (batches 8 and 10); make the text big enough for a phone.

### 12. The approval beat

- **What:** a human checkpoint as the trust moment: the agent proposes a memory update or an action, the user clicks Allow, and the state flips to Live. Four launch videos in the second pass use this as their climax.

### 13. The loop

- **What:** a 3 to 10s loop with one fixed thing and one changing thing: the supermemory mark held in a dock while agent icons swap through the slot beside it (batch 8). Good for a pinned post or a site hero.

## Endings for memory films

- **The install command or MCP URL** in a terminal pill, held 3 to 5s, then the lockup. Batch 2 found only 3 of 8 supermemory films ending on a URL or command.
- **A tagline that names the behaviour.** 2#17 ends on "Build an agent / that remembers." On supermemory, run it through her voice rules and the pack's voice-and-copy.

## Don't

- Don't show a competitor's product or name, even crossed out.
- Don't claim "every agent" when only some are repo-keyed (see `lessons.md` and the one-memory notes).
- Don't use the discontinued consumer framing (Nova, the Brain app, closed Aug 28) for new films.
- Don't put a static 2.5s UI still at the open (2#17).

## Build it here

- **Lane, stack and pill scenes:** `engine/console-film/` has the vector console, typeset terminal, cursor and beat grid.
- **Graph scenes:** use the measured console graph, or the memory-graph film sources named in `lessons.md`.
- **QA:**
  - every memory label must be readable at 390px;
  - every operation name must match the docs;
  - check motion with `qa.md` 2.3.
