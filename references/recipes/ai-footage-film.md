# Recipe: AI footage with code-drawn type

Generated video plates (people, places, light, physical effects) cut together under type, UI and labels drawn in code. This covers launch films built on AI footage and AI-footage showcases (batch 4: 24 videos, including a 9.6M-view short film).

**Use it when** the film needs what code cannot draw: people, a world, weather, water, fire, crowds, lens behaviour.

**Not when** the product UI is the hero. The UI-led films in the same batch carry 28 to 75s on rebuilt UI alone, with 0 to 2 cuts (4#3, 4#10, 4#17, 4#23).

**On supermemory** AI footage is out unless she asks for it. She asked for it on Oct 30 for the Claude Code plugin film (lessons #174): photoreal Hollywood genre scenes with a real-looking actress, made in Cardboard (`cardboard` skill: cast sheets, Veo 3.1, Kling 3.0 Pro, Wan 3.0). Worked example: `reports/videos/claude-code-plugin-film-src/`. The brand film (`field.mp4`) is the moving background, and product proof is always rebuilt UI. Ask before installing or paying for any generation tool.

## Targets

| Group | Length | Moving | Cuts per minute | Median shot |
|---|---|---|---|---|
| AI-footage showcases (6) | 28s | 80% | 13.4 | 3.7s |
| Launch films built on AI footage (batch 4) | 63 to 112s | 75 to 89% | 13.2 to 22.4 (median 17.1) | 1.2 to 2.9s |
| The 6.5-minute short film (4#1) | 393s | 80% | 35.2 | 1.4s |

- Loudness is about -14.7 LUFS for showcases. AI-footage launches run loud (-7.1 to -13.1).
- Cut counts are lower bounds: the detector misses cuts between same-palette AI shots.

## Beat template: a 60 to 90s launch built on footage

| Time | Beat | What happens |
|---|---|---|
| 0 to 3s | Hook | A gag or macro detail before the title (the bump in 4#18; the creature in a glass in 4#1). Or intent before image: the description typed or spoken over black before the subject appears (4#5). Or the brand mark becoming the subject (particles build the host in 4#8; the orb becomes a face in 4#10) |
| 3 to 10s | The world | One longer take establishes realism (8 to 15s only when realism is the claim, 4#12). Otherwise cut at 1.2 to 3s from the start |
| middle | Prompt, then result | Pair every beat with one instruction and the cut that fulfils it. A chat bar floats over the scene and types the instruction (4#7), or the subtitles are the user's prompt (4#5) |
| middle | Labels in the plate | Code-drawn pills pinned to objects (4#8), slash-command labels in the empty half of the frame (4#18), headline words split around the subject |
| last 3 to 4s | CTA | A small caps CTA line over the last shot as the camera pulls back (4#7), or the character's last line as the CTA ("Now, talk to me.", 4#5), then the wordmark about 2.5s |

## The rules (from the 24 videos)

1. AI for what code cannot draw. Code for everything exact: UI, numbers, charts, text, logos. None of the 24 trusts AI with on-screen text.
2. Shots of 1.2 to 3s, cut on motion. Use a long take only when realism is the claim.
3. Lock one light, one period look and one recurring character or object, so a montage reads as one world (4#1, 4#9, 4#11).
4. Generate plates with empty space kept for type.
5. Bridge footage and UI with in-world carriers (prompt bars, device frames, label pills, a sprite guide), never a hard cut from film to screen recording.
6. Put proof side by side: synchronised split screens, or before-and-after pairs with tiny labels (4#15, 4#17).
7. Treat clips as scrubbable assets: render a turntable or orbit clip and drive its frame from the code timeline (4#22), so renders stay deterministic.
8. Hide what AI does badly:
   - hands: crop, glove, blur or give them a prop;
   - drift: check outfits and hair between shots;
   - signage: keep it soft.

## Study these first

| Ref | Post | Why |
|---|---|---|
| 4#1 | [@PJaccetturo](https://x.com/PJaccetturo/status/2100218143625073088) | One light and one costume language hold 141 cuts in one world for 6.5 minutes; opens on a macro insert |
| 4#5 | [@VivixLabs_HQ](https://x.com/VivixLabs_HQ/status/2105329123271033028) | Prompt as subtitle: describe, see, change the scene; the CTA is the character's line |
| 4#7 | [@higgsfield_ai](https://x.com/higgsfield_ai/status/2103875279588602225) | A floating prompt bar over footage; each danger paired with one prompt and one output |
| 4#8 | [@BytePlusGlobal](https://x.com/BytePlusGlobal/status/2101893220288663884) | A host formed from particles; label pills pinned to objects |
| 4#10 | [@ElevenLabs](https://x.com/ElevenLabs/status/2065129866471551160) | The brand orb morphs into a face; a minimal UI pipeline, no footage needed |
| 4#12 | [@abxxai](https://x.com/abxxai/status/2097698694296686623) | One long take sells realism, then fast cuts; borrows the vlog genre |
| 4#18 | [@higgsfield_ai](https://x.com/higgsfield_ai/status/2098081141039456756) | Slash-command labels teach the syntax during the montage |
| 4#15 | [@BytePlusGlobal](https://x.com/BytePlusGlobal/status/2102358910443401590) | A synchronised A/B split screen as proof |

## Pitfalls

- Borrowed famous-brand titles ("Claude for X", "Tinder for Y", 4#3, 4#23, 6#24): impersonation and legal risk.
- Anyone's likeness or voice without consent (4#16 clones a real person, with the reference pack).
- AI-rendered text, charts or UI.
- Outfits and hair that drift between shots (4#12, 4#5).
- Mastering too loud.

## Build it here

- Plates: Cardboard (`cb generate`, her account, credits about a cent each): a cast sheet for each recurring person, one still per shot for her approval (8.1 credits), then video. Other tools need her OK for each tool and download. Drop them into `reports/videos/<name>-src/plates/`.
- Compositing: the Swift pipeline reads frames as a raw plate, the way `engine/console-film/film_bg.swift` samples the brand film. Draw all type, pills and UI in CoreText and CoreGraphics on top.
- QA: `qa.md`, plus a drift check: a contact sheet of every shot of the recurring character.
