# Character rebus: the mascot is the word, the survivor and the avatar

Studied 2026-10-30 from the film she sent with "omg learn this video omg, add it to our skills this is too good". It is Allo's Grok Bot launch, "We decided to give Grok Bot a phone." ([post](https://x.com/allophonesystem/status/2115793573589258279), Oct 29 2026, 20.2s, 16:9, served by X at 1280x720 30fps). She sent it through [@irapss_ae's quote](https://x.com/irapss_ae/status/2115818559750475813), "JESUS.". The full beat log is `library/videos/14-shared-late-oct.md` #3. Frames were read from the 720p mp4, the best X serves for this post, in the session scratchpad; no copy is kept.

**Why it matters to us:**
- It launches an integration on the same host as ours (Grok Bot), one day before our Supermemory Bot film.
- A 652-follower account reached 416K views (about 640 times its followers) and 1,116 bookmarks.
- The motion designer's quote added 218K views and 1,827 bookmarks, more saves than the original. Designers kept it as a reference.

This is a grammar to borrow, not a look. Never reuse Allo's green, yellow icon, headset idea, copy or UI. Our rule for the Grok Bot mascot still holds (§4).

---

## 1. Why it works (measured)

| | Allo film | Supermemory Bot v4 (ours, same metric) |
|---|---|---|
| Length | **20.2s** | 50.6s |
| Voice | none, plus one line inside the story: the bot answers the call, "Hi, Gonzalo." (8.12 to 8.74s) | Jessa, 46s of narration |
| Words on screen | 6 headlines of 3 to 5 words (about 25 words), plus UI text | a caption for every line |
| Moving frames (qa.md 2.3) | **94.7%**, longest still 0.2s | 69.0%, longest still 2.2s |
| Hard cuts | 3 (9.73, 12.87, 15.87), all in the second half; the first 9.7s is one take | 0 |
| Sound | upbeat music on a 120 BPM grid; -17.0 LUFS | Apple Loops score and foley, -14.2 LUFS |
| Colour | cool off-white ground #f6f9fc, pure black, one green (#08a060), real UI colours. The end switches to a dark radial: a #095637 glow at bottom left into #010904 | the theatre's blue, lavender and warm light |
| Type | one centred, sentence-case headline at a time in a medium grotesk. Cap height 44px of 720, about 6% of the frame height (about 64px at 1080p, a font size near 90px) | 56px bold captions |

**What does the work:**
1. **The host's mascot is the hero, and the product is something it wears.** Allo's own logo doesn't appear until 15.9s. Their product is a green headset on Grok Bot's character: "a phone" is a headset. The pitch reads as a picture, bot plus headset.
2. **The mascot is a word.** The film opens on "Give your [mascot] a phone" and closes on "Connect Allo to [mascot] Grok Bot". The same device at both ends makes the end rhyme with the start.
3. **One survivor carries the first half.** The mascot arrives, gets the headset and sits in the sentence. It then drops below the next headline, watches the phone rise, and dives into the call card to become the caller's avatar: 9.7s with no cut. Its eyes always look at whatever is happening (up at the pill, down at the phone), so the viewer looks there too.
4. **Then it cuts on the beat.** The second half has three hard cuts, 3.1s and 3.0s apart, and each opens a new surface: a text thread, a desktop app, the brand. The film speeds up as it moves from story to proof to brand.
5. **The headlines are verbs, and the bot is their subject:** "Answers your calls", "Text your customers", "Prepares your call-back list". The UI under each one proves the verb within about a second.
6. **Proof is product UI rebuilt in vector:**
   - an iOS Dynamic Island call card;
   - message bubbles and a quote card;
   - a macOS app with a sidebar of agents.

   It all stays sharp at 720p, with no screen recording.
7. **The brand only appears at the end, on a new ground.** The story plays on a light ground; a hard cut takes the brand to a dark radial, where the mascot turns white.

Recipe-distance check (anti-house-style §1.1), about 3 of the 12:
- one take, for the first half only;
- pops from zero (the seed dot, the bubbles);
- events on a 120 BPM grid.

The moves below (rebus line, seed pill, gaze rig, dive into UI, per-letter morph, anchored bubbles, logo to word) are not on that list.

---

## 2. The moves, with measured timings (30fps, so a frame is 33ms)

1. **Pinball entrance (0.1 to 1.0s).**
   - Frame 0 is the empty ground.
   - At 0.1s the mascot flies in from the top right, huge, as if near the lens. By 0.2 it is a pill stretched along its path, with two eye dashes.
   - It ricochets left (0.3) and right (0.4), smaller each time, with its eyes drawn as short dashes while it moves.
   - It settles at centre by 0.9 with round eyes.
   - Stretch along the path stands in for motion blur.
2. **Accessory drop with an impact zoom (1.6 to 2.4s).**
   - The headset enters small at the top right (1.6), then grows and spins along an arc over the head (1.7 to 2.2).
   - The mascot's eyes track it: at 1.7 they slide off the top edge of the disc, which reads as looking up.
   - It lands at 2.3, and the frame punches in about 2x on the landing. A pleased squint follows: the eyes go to flat dashes at 2.5 and 2.6.
3. **Rebus line (2.8 to 3.1s).**
   - The mascot stays at the centre of the line. Words land one every 3 frames (0.1s) on either side: "Give" 2.80, "your" 2.90, "a" 3.00, "phone" 3.10.
   - The inline mascot is about 3x the cap height (139px against a 44px cap at 720p). Its centre sits a third of a cap below the cap middle, so it rests on the line.
   - The full line holds 0.8s while the eyes look around, so the hold stays alive.
4. **Drop out of the line (3.8 to 4.6s).**
   - The mascot squashes and drops below the line while the words leave.
   - The next headline lands above it: "Its" 4.3, "own" 4.5, "number" 4.6, 0.1 to 0.15s a word.
5. **Seed-dot pill (5.03 to 5.43s, 13 frames).**
   - A 1px green dot appears in the gap between "own" and "number".
   - Frames 2 to 6 (0.17s): it grows into a circle holding a phone icon.
   - Frames 7 to 9 (0.1s): it stretches into a pill.
   - Frames 9 to 13: it keeps widening while its masked digits appear one per frame.
   - The line re-centres every frame, so both neighbours part evenly. The mascot looks up at it. The end card reuses this move with the mascot itself as the seed.
6. **Tilt down to the device (6.2 to 6.7s).** On the beat (onsets at 6.26 and 6.39):
   - the headline exits up;
   - the phone rises from the bottom edge;
   - the mascot stays in frame above it.

   This is a camera tilt with one survivor. The Dynamic Island then grows into the incoming-call card (6.6 to 6.7).
7. **Dive into the UI (7.15 to 7.45s).**
   - The camera pushes in on the call card for 0.2s.
   - The mascot tilts and drops into the card's avatar slot (on the 7.38 hit), shrinking to the slot size.
   - It turns white the frame it touches the dark card, replacing the default contact avatar.
8. **Per-letter morph of UI text (7.65 to 8.2s).**
   - "mobile · Gonzalo Rascon" becomes "Grok Bot · Forwarding Call" one glyph at a time, left to right: each glyph crossfades in place, about one per frame.
   - The green accept button collapses into a live waveform that grows to the right.
   - The bot's voice says "Hi, Gonzalo." under it.
9. **Tilt again to make room for the headline (8.6 to 8.9s).** The phone moves down, and "Answers your calls" lands above it (8.7, 8.8, 8.9).
10. **Cut to a back view, then the turn (9.73 to 9.9s).**
    - The new scene opens on the mascot from behind, showing only the headset, and "Text" lands.
    - The mascot turns to face right: the eyes slide in across the disc and the earcup swaps sides. This is a 2D sphere turn.
11. **A typing bubble that becomes the message (9.9 to 11.4s).**
    - A green bubble pops out beside the mascot (it squashes on entry) with three bouncing dots. The dots count down to one, then the bubble empties.
    - "Hi" types inside and the bubble widens with the text: "Hi Gonzalo!".
    - The camera pulls back as the headline exits up, and the bubble stretches into a full-width message: "Hi Gonzalo! Here's your quote:".
    - A quote card resolves beneath it from pale and grey to full colour in 0.3s (11.1 to 11.4).
12. **Right-anchored reply (11.6 to 12.3s).** The customer's black bubble pops at the bottom right with typing dots, then "Thanks, that was fast!" types. The bubble grows leftward from its right edge, the way a sent message does.
13. **Hard cut into a desktop app (12.87 to 15.8s).**
    - The headline "Prepares your call-back list" lands (12.87 to 13.1) over a macOS window already in place. Its sidebar of agents uses the mascot as the "Front Desk" avatar.
    - The agent's messages land one by one (13.3, 13.8).
    - At 14.0 to 14.2 the camera zooms into the chat pane until it fills the frame.
    - The user's reply types (14.2 to 14.6), and the last agent line fades from grey to ink (15.0).
14. **Brand end on a new ground (15.87 to 17.6s).**
    - A hard cut to the dark radial shows the yellow app icon alone (15.9 to 16.3).
    - The icon slides left as the wordmark's letters fade in left to right (16.4 to 16.7).
    - The lockup holds on a slow push-out (16.8 to 17.5).
15. **The logo becomes a word, then a sentence, then the mascot (17.6 to 18.6s).**
    - The icon leaves, and "Connect" lands to the left of the bold wordmark (17.63).
    - The wordmark turns into "Allo" in the headline font (17.70). "to" (17.77), "Grok" (17.83) and "Bot" (17.90) follow.
    - A white seed dot appears between "to" and "Grok Bot" (17.97). It grows into a white sphere with the headset (18.03 to 18.23), which turns from side view to face us (18.30 to 18.57).
    - The last 1.6s holds with the eyes moving: a living still, not a frozen one.

**Sound against picture.** The music's hits fall on a 0.25s grid offset by about 0.13s, so the tempo is 120 BPM. These moves land within a frame or two of a hit:
- the phone's rise (6.26);
- the dive (7.38);
- the second cut (12.87, against hits at 12.82 and 12.90);
- "Connect" (17.62);
- the mascot's arrival at the end (18.24).

**Headline holds**, from first word to exit:
- 1.4s ("Give your … a phone")
- 2.0s ("Its own number")
- 1.0s ("Answers your calls")
- 1.1s ("Text your customers")
- 1.2s ("Prepares your call-back list")
- 2.6s (the end line)

Each fully built headline holds 0.8 to 2.3s.

---

## 3. Building them in our engine (HyperFrames, one pure `frame(t)`)

Everything is a function of `t`, with no CSS transitions (`references/hyperframes.md`). Use real DOM text, so it stays sharp at 4K.

- **Rebus line.**
  - Use a centred flex row of word spans and slot spans. Word *i* lands at `ti`: `k = clamp((t - ti) / 0.10)`, `opacity = k`, `translateY = (1 - easeOutCubic(k)) * 0.22em`.
  - A slot's width is animated. Flex centring re-centres the row every frame, so the neighbours part evenly for free.
  - Size an inline character at about 3x the cap height and drop its centre a third of a cap below the cap middle.
- **Seed-dot pill.** The slot width `w(t)` runs:
  - 0 to 0.08em in one frame;
  - to a 1em circle in 0.17s (easeOutCubic; any overshoot follows anti-house-style §4 rule 6);
  - to the pill's width in 0.15s.

  The icon fades in during the circle stage, then the content glyphs arrive one per frame. Give the slot a word space on each side, so at `w = 0` the line still reads normally.
- **Gaze rig.**
  - The eyes are two ellipses offset by `0.35 * R * normalize(target - centre)`. To look away or up, push the offset past the rim and clip to the disc, so the eyes vanish.
  - A blink is `scaleY` 1, 0.1, 1 over 4 frames. A pleased squint is flat dashes for 3 frames.
  - Point the gaze at the next thing that moves, half a beat before it moves.
- **Sphere turn.** Over 0.25s, `phi` goes from 90° to 0°:
  - features sit at `x = R * sin(phi)` with a horizontal scale of `cos(phi)`;
  - an accessory on the far side moves to `x = -R * sin(phi)` and is hidden while it is behind the disc.
- **Stretch for speed.** Flat characters get `s = 1 + min(0.6, |v| * k)` along the velocity and `1/s` across it (the area stays the same), rotated to the velocity's angle. Eyes become short dashes above a speed threshold.
- **Typing bubble.**
  - Measure the typed prefix with canvas `measureText`. The bubble width is the text width plus padding, anchored left for incoming and right for outgoing.
  - The typing indicator is 3 dots bouncing 2px, 0.12s apart in phase.
  - The keystroke rhythm follows anti-house-style rule 13: 90 to 180ms a key, a pause at spaces.
- **Per-letter morph.** Draw the old and new strings in the same box. Old glyph *i* fades out and new glyph *i* fades in from `t0 + i / 30`, each fade lasting 3 frames.
- **Dive into a slot.**
  - The character follows a short arc to the slot's centre in 0.25s (easeInCubic), scaling to the slot's size, with a 2-frame squash on landing.
  - Switch the fill (black to white) on the frame its centre crosses the dark surface's edge.
- **Cuts on the beat.** Keep the first half as one take with a survivor. Put the second half's hard cuts on 8th-note hits of the score. Allo uses 120 BPM; pick ours on the style card.

---

## 4. Using it on a supermemory film

- **Where it fits.**
  - Integration launches: the Supermemory Bot in Grok Bot, the plugins for Cursor, Claude Code and Codex, MCP.
  - Social cuts of 25s or less, where one sentence with an object inside it says the whole idea.
- **The host's mascot.** Our standing rule is to draw Grok Bot's mascot "as @bot draws it", with no new expressions and no "×" lockup (memory `grok-bot-plugin-launch`).
  - Allo dressed it in a headset and gave it blinks, a squint and a gaze. Ask her before dressing or animating another company's mascot that way.
  - The safe version: our own mascot, or a memory chip, is the rebus object, and the host appears as itself.
- **A memory object as the seed pill.** Memory has no prop like a headset. The object our films already use is the "◪" memory chip.
  - It grows out of a seed dot inside a sentence and carries a real stored fact, for example "It keeps [◪ Zephyr uses Postgres] for every Bot". That is the Supermemory Bot film's own example, from Ishaan's test chat.
  - Run the line past her before it carries a claim.
- **Length.** Allo says it in 20s and about 25 words on screen; our Bot film runs 50.6s with 46s of narration. A 20s, text-led cut in this grammar is the obvious test, if she raises length again.
- **Rules that conflict with Allo.** Ours win unless a brief says otherwise:
  - Frame 0 is composed (SKILL.md §2); Allo's frame 0 is the empty ground.
  - One typing effect per film (anti-house-style rule 13); Allo types in four bubbles. Type one bubble and land the rest whole.
  - Statements hold at least 2.5s; Allo's 3 to 5 word headlines hold 0.8 to 2.3s built. A brief may set a lower floor for headlines that short.
  - We master at -14 LUFS; Allo's mix is -17.
- **The brand stays ours:** blue `#0562ef` as the one hero colour, Geist, and the official lockup at the end. Allo's switch to a dark brand end maps to our blue field or the dark lockup colourway.

---

## 5. What not to copy

- Allo's green (#08a060), the yellow app icon, the headset, "Give your … a phone", the iOS call card, the quote card, the names in their UI (Gonzalo Rascon), the dollar amount.
- Their mascot treatment of another company's character, until she says it's fine for us.
- Their end line shape word for word ("Connect Allo to [mascot] Grok Bot"). Ours already ends on "Add supermemory to Grok Bot".
