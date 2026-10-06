# Recipe: talking head

A person on camera carries it (a founder, a host, a creator), with graphics and product inserts around them. It runs 19s to 20min. 12 of 156 in the set.

**Use it when** a person's credibility, story or news is the point.

**On supermemory** edits of her own footage follow the pack's `muskan-editing-style`, not explainer motion rules (SKILL.md section 0). Inserts are rebuilt UI.

## Targets (12 talking heads, medians)

| Measure | Median | Use |
|---|---|---|
| Length | 151s | 60 to 150s for a launch; the long ones are interviews and episodes |
| Moving | 79% | 75%+ (people move; punch-ins help) |
| Longest still | 1.2s | under 1.5s |
| Cuts per minute | 4.0 | Punch-in and punch-out every 3 to 6s; a 2.2s median shot keeps a 94s conversation moving (5#5) |
| Loudness | -15.7 LUFS | -16 to -19 for dialogue |

## Beat template: a founder launch, about 90s

| Time | Beat | What happens |
|---|---|---|
| 0 to 1s | Hook | The news in second one as on-screen numbers on both sides of the speaker ("We just raised" / "$13.5M", 1#11). Or a news peg in the first line (6#1), a credential card (6#7), or the person addressed by name in giant type ("hey farza!", 6#22) |
| 1 to 15s | Thesis | One enlarged caption line for the thesis; burned-in captions throughout, for muted autoplay |
| at 10 to 15% | Product named | A mid-video title card as a chapter break (6#1) |
| middle | Proof | Real product inserts caught mid-task, under a quarter of the runtime. Screenshot overlays are timed to the noun being said (6#7). Archive receipts get dated, coloured borders (6#22) |
| 60 to 80% | Proof block | Logos, one metric, a dashboard |
| end | Close | The founder's line, then an empty set with the logo (5#5), or the logo, tagline and URL card, about 4s (6#1) |

## Moves that make it

- **Overheard, not presented:** a two-person working session intercut with real screens (5#5, 3.0M views).
- **One location or ground per section** of the argument (2#13).
- **Punch in and out** about every 3s, so no frame holds (2#13).
- **Keywords placed behind the speaker** in the scene's depth (3#10, 3#11).
- **One-word punctuation cards** between talking sections (6#22).
- **Comedy and behind-the-scenes cutaways** as pacing breaks, with proof placed between the jokes (1#11).

## Study these first

| Ref | Post | Why |
|---|---|---|
| 5#5 | [@cursor_ai](https://x.com/cursor_ai/status/2098162488013455784) | A conversation with real screens; a 2.2s median shot; ends on the empty set with the logo |
| 1#11 | [@adambcohen93](https://x.com/adambcohen93/status/2082122814539334018) | The raise in second one; type on both sides of the speaker; comedy earns 145s |
| 6#7 | [@yoyozhang06](https://x.com/yoyozhang06/status/2094801751287201951) | A credential hook; overlays timed to nouns; the product as the payoff in the last quarter |
| 6#22 | [@DannPetty](https://x.com/DannPetty/status/2067239384714248512) | A name-addressed cold open; dated receipts; one-word cards |
| 3#11 | [@jake11moran](https://x.com/jake11moran/status/2102544324445848031) | Keywords behind the speaker (a published HyperFrames skill) |

6#1 is a strong news-peg example, but it is a memory product for Claude (a competitor). Use it for study only; never cite or share it.

## Pitfalls

- A silent talking head (3#35).
- A static unzoomed capture beside the face.
- Product UI that arrives too late with nothing to watch before it. Batch 6's talking heads bring the UI in at 44% and 71% of the runtime, and need a strong first line to hold until then.

## Build it here

- **Footage:** the pack's `muskan-editing-style`.
- **Captions and keyword plates:** CoreText, rising from a mask line.
- **Inserts:** `engine/console-film/`.
- **QA:** `qa.md` 2.9 loudness, and captions readable at 390px.
