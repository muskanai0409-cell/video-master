# Recipe: changelog update

A recurring "what shipped" video: a host plus one proof insert per item. It runs 18 to 145s. The format holds both the biggest post in her bookmarks (1#1, 41.6M views) and her own changelog (2#22).

**Use it when** there are several shipped items to list, weekly or per release.

**On supermemory**
- Her own camera footage follows the pack's `muskan-editing-style` (SKILL.md section 0), not explainer motion rules.
- Rebuild the inserts in vector from the live console, never as screen-recording upscales.
- Words follow her voice rules.

## Targets (5 changelog updates)

| Measure | Median | Use |
|---|---|---|
| Length | 75s | About 75s for 5 to 7 items. Her 140s cut would fit in about 75s with the small fixes folded into one card |
| Moving | 73% | 70%+ (walk-and-talk footage moves on its own) |
| Longest still | 2.3s | Under 2s. 1#1 holds one screen for 10.8s, which is its weak spot |
| Cuts | | Hard cuts between host and insert. The detector logs 0 for dissolve-joined cuts like 2#22 |
| Loudness | -19.1 LUFS (3 audible) | Dialogue-led, so about -16 to -19 |

## Beat template: about 75s, 5 items

| Time | Beat | What happens |
|---|---|---|
| 0 to 3s | Open | The host already talking, mid-stride (1#1, 2#6), with a small glass chip naming the show, "What's new in [logo]" (2#22) |
| 3 to 8s | The list | What shipped, in one line. The numbered list in the post mirrors the video's order (2#6) |
| per item, 8 to 12s | Item | One line from the host, then a 4 to 6s full-screen proof insert on its own colour (1#1 gives each feature one gradient), then a hard cut back to the host |
| about 10s | Small fixes | One list card with NEW and FIX tags, not one beat per fix |
| last 3s | End | A link chip ("supermemory.ai/changelog") and "That's it for this one.", held about 2.5s (2#22) |

## Moves that make it

- **One full-screen proof insert per item.** In 2#6, 9 of 16 sampled frames are inserts. In her 2#22, full-screen proof covers only about 8s of 140s.
- **One colour per feature** as a chapter key, with a single centred UI card showing a realistic exchange (1#1).
- **Receipts:** other people's posts with one sentence boxed (2#6).
- **Scannable chrome:** top-left chips and NEW and FIX tags (2#22); chapter timestamps in the post (1#1, 2#22).
- **A hero object moment:** tap one item and it becomes a full-screen object on a surface, about 2.5s, twice per film (6#11).
- **Location or ground per section,** when the host moves (2#22's garden, then a second location).

## Ending

- A link chip plus a sign-off line, held about 2.5s (2#22).
- Not a peace sign and a fade with no URL (2#6). The offer was only in the post.

## Study these first

| Ref | Post | Why |
|---|---|---|
| 1#1 | [@mattyp](https://x.com/mattyp/status/2102759899314741736) | 41.6M views: a walk-and-talk host plus one UI proof card per feature, each on its own gradient, in the order of the post's chapter stamps |
| 2#6 | [@mattyp](https://x.com/mattyp/status/2097411358891630786) | The same host, 75s: a numbered list mirrored in the post, full-screen inserts, posts as receipts |
| 2#22 | [@Muskanjain0401](https://x.com/Muskanjain0401/status/2105969838317547925) | Her own: the chips, tags and chapters work; proof is too short and the small fixes take 37% |
| 6#11 | [@anshuc](https://x.com/anshuc/status/2064959907833803261) | An 18s phone-mockup update where one data item becomes a hero object |

## Pitfalls

- Long stretches of face with the proof in a small picture-in-picture.
- One beat per minor fix.
- A UI card held still for 10s (1#1).
- An ending with nothing to do.

## Build it here

- **Footage:** her pack, `muskan-editing-style`.
- **Inserts:** `engine/console-film/` (a vector console card on the brand film, typeset terminal), rendered as 4K stills or short loops.
- **Captions:** burned in, so it works muted.
- **QA:** `qa.md` 2.9 loudness, and phone-size checks on every insert.
