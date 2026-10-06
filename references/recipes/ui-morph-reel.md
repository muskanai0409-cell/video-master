# Recipe: UI-morph reel

A run of features or agents built from rebuilt UI and kinetic type, moving as one continuous gesture with almost no cuts. It runs 14 to 67s.

This is the most code-native format in the set. The ones with 500K+ views move 81% of the time (the median across all 20 is 66%). In the launch batch, 7 of 26 were this shape, and they include the 5.4M-view X launch (5#3).

**Use it when:**
- there are several features, agents, roles or integrations to show;
- a single flow ends exactly on the product's tagline.

**On supermemory** her surface still applies (SKILL.md section 1): white or paper ground, square corners, Geist, one blue accent for the proof. This is the format her rossaxbt references come from (3#12, 3#23).

## Targets (20 UI-morph reels, medians)

| Measure | Median | Use |
|---|---|---|
| Length | 38s | 30 to 40s for a roster; 14s for a single morph |
| Moving | 66% (81% for the 7 with 500K+ views) | 80%+ |
| Longest still | 1.9s | about 1s before the end card |
| Cuts per minute | 0 | 0 to 4: morphs, pushes and crops, not cuts |
| Loudness | -14.7 LUFS | -14 |

## Beat template: the roster, about 35s

| Time | Beat | What happens |
|---|---|---|
| 0 to 2s | Claim | Built word by word with a blur-to-sharp reveal, or typed. One accent word: "…100% FREE." in blue at 1.5s (5#17). Or an "X for Y" analogy: "OpenRouter for agent tools" (5#22) |
| 2 to 4s | Proof object | Partner logos on orbit rings (5#3), or a repo card with a star count and the role files (5#20) |
| 4 to 10s | Trigger | A command in a terminal, a URL typed into a field (5#8), or a search typed (5#17) |
| 10 to 28s | The roster | N items on one fixed template: a label pill in the same place, plus exactly one proof card. Each holds 2 to 4s (about 2.3s in 5#20, about 4s in 5#8) |
| 28 to 31s | Breadth and thesis | "…and eight more" as a chip cloud (5#20), then one thesis line ("All of it, inside Claude.") |
| 31 to 35s | CTA | Held 3 to 8s: a button, a terminal pill, a QR code or a comment trigger |

**Single-flow variant** (5#3, 40s):
- The trust hook: exchange logos at 0.5s.
- One unbroken user flow: search, a chart scrubbed by a finger, a crop onto the "Trade" button, the broker sheet.
- It ends on a three-word outro naming the flow ("From ticker to trade"), with the opening orbit expanding into dozens of ticker icons.

## Moves that make it

- **A neutral grey placeholder card as the morph bridge** between unrelated UI states. A six-feature tour then reads as one gesture (2#14).
- **One container springs between states** (size, radius) while its content crossfades. The open prompt template for this is 3#23.
- **Push and crop onto the one button that matters** (5#3's Trade button; 5#19's "Number" menu item).
- **Switch the ground or theme to mark a change of point of view:** light mode is you, dark mode is the person reaching you (5#19).
- **Use an odometer roll for the key value,** such as a phone number rolling into a pill (5#19).
- **A struck-through price list landing on one big number** in the accent: "$139/mo, $99/mo…" crossed out, then "cents per call" (5#22).
- **A running counter that rides through every scene** ("$0.00", 5#17).
- **Competitors as crossed-out icon tiles,** not names (5#17). On supermemory, don't show competitors at all (her rule).
- **A glyph swap on the emotional word,** such as a heart for the "o" in "love you." (2#14).
- **An isometric wall of cards with a counter,** for scale right before the CTA (2#14).

## Ending

- A real button with the URL inside: "Hire yours → okara.ai", held about 5s (5#8). Or "Start for free at testimonial.to" (2#14).
- A paste-into-your-agent command in a dark terminal pill: "Set up https://monid.ai/SKILL.md" (5#17); "$ set up treg — …/llms.txt", held about 7.5s (5#22). On supermemory: the MCP URL or the one install command.
- A QR code plus the URL, for desktop viewers holding a phone (5#13).
- A comment trigger built for X: "Comment 'AGI' → it's yours" (5#20).
- The opening motif returning around the logo (5#19).

## Study these first

| Ref | Post | Why |
|---|---|---|
| 5#3 | [@X](https://x.com/X/status/2102147636702634195) | A logo-orbit trust hook; one flow cropped onto one button; a three-word outro; 5.4M views |
| 5#8 | [@askOkara](https://x.com/askOkara/status/2089366669613531602) | A claim plus the replaced tools in 2s; every agent a label plus one proof card; a CTA drawn as a button |
| 5#20 | [@OriSilver](https://x.com/OriSilver/status/2092225524210827424) | One command calls a cast of named specialists at about 2.3s each; "…and eight more"; square |
| 5#17 | [@shengkunye](https://x.com/shengkunye/status/2093050916953903451) | A running $0.00 counter; the CTA as a terminal pill |
| 5#22 | [@jasonzhou1993](https://x.com/jasonzhou1993/status/2087138389770514867) | The "X for Y" analogy; a role-swap headline; struck-through prices |
| 5#19 | [@benjitaylor](https://x.com/benjitaylor/status/2102443951898992825) | Light and dark mode for a change of point of view; odometer; the motif returns |
| 5#13 | [@tlxue](https://x.com/tlxue/status/2100288496170574284) | Opens on one readable bubble and pulls back; "Wait, you remember that?"; QR code ending |
| 2#14 | [@damonchen](https://x.com/damonchen/status/2104207711844049157) | A grey placeholder card as the morph bridge; a glyph swap |
| 3#23 | [@rossaxbt](https://x.com/rossaxbt/status/2106396375269134597) | An open prompt template for a 14s code-only UI morph |

## Pitfalls

- A held, almost static open, like 5#22's first 3s. Make frame 0 move (`video-study.md` section 3).
- Different layouts per feature. The roster only reads when the pill and card sit in the same place every time.
- Too many words per card: one label and one proof, nothing else.
- Crossed-out competitor names or logos on a supermemory film.

## Build it here

- `engine/reference-16x9.swift` (explainer frame and morphs), or `engine/console-film/` when the UI is supermemory's console.
- Morphs: `motion-grammar.md`, the shape-to-shape state morph, at 0.4 to 0.6s per state.
- Springs: one family, closed-form, about 2.4Hz, damping about 0.6 (SKILL.md section 1).
- QA from `qa.md`: 80% moving, and the same template positions checked on a contact sheet.
