# One-take blend: every object becomes the next

Studied 2026-10-25 from the film she sent with "see how cool videos they are making ... motion graphic blending one into each other is so much better with them": @mem0ai's Claude Code memory explainer ([post](https://x.com/mem0ai/status/2105685414430523472), Oct 1 2026, 56.1s, 1920x1080 at 30fps). Full beat log: `library/videos/14-shared-late-oct.md` #1. Frames were read from the post's mp4 by exact seek; no copy of the video is kept.

This is a grammar to borrow, not a look. Mem0 is a competitor: never reuse its purple-on-black look, its Mars photo, its layouts or its benchmark claims. Rebuild the moves in supermemory's brand (one blue, Geist, our grounds).

---

## 1. Why it feels better than our films (measured)

| | Mem0 film | One-API v2.4 (ours) |
|---|---|---|
| Hard cuts | **0** | 0, but scenes swap by crossfade or dive |
| Moving frames (qa.md 2.3) | **49.5%** | 65.5% |
| Longest still | 3.2s (the terminal and the end) | 2.9s (the end) |
| Motion events | 18 in 56s, median 0.87s (0.27 to 2.2s) | many, continuous drift |
| Voice | 131 wpm, 11 sentences, 0.4 to 1.1s gaps | 180 wpm |
| Loudness | -10.9 LUFS, bed about 117 BPM (estimate) | -14 LUFS |
| Colours | black + one hue in five values + one guest colour | many hues, then one blue |

**The lesson is not "more motion".** It moves less than our films. It feels smoother because:
1. **One object carries the whole film.** A window becomes a chip, the chip hangs on a line over a container, the container is born as a band and straightens into a bar, cards are born under it and are absorbed back into it, a new window grows out of the chip, the bar shrinks into a hub pill, the hub gathers feature cards, and the mark ends it. The eye never has to find a new thing; the new thing grows out of the old one.
2. **Nothing leaves by fading to nothing.** Outgoing layers go out of focus and stay as depth (rack focus), or collapse into a smaller object that keeps living (window to chip, card to dot).
3. **One hue, five values.** Black ground; violet as a horizon glow (#291d4a), an active-card fill (#201840), an edge line (#503890), accent text (#8868d8) and particles (#c898e0). The only other colour is the guest product's: Claude orange, used only as a warm wash when a Claude window is born or leaves.
4. **Calm voice, picture a breath ahead.** Each visual change starts 0.2 to 0.4s before the word it shows ("Why tell it again?" focus pull starts 0.38s early; the logo is sharp as "Meet" is said), and category words trigger their own cards ("coding patterns", "decisions", "preferences", "context").
5. **Short transitions, real holds.** Transitions take 0.3 to 1.5s; holds of 1 to 3s are fine because nothing ever cuts.

---

## 2. The moves, with measured timings

Times are from the Mem0 film. Durations are the motion event lengths measured with frame differences.

| # | Move | What happens | Measured |
|---|---|---|---|
| 1 | **Hinge-up entry** | A window stands up out of the ground plane: a thin sliver at the horizon, a tall trapezoid in perspective, then flat and frontal, rising slightly. | 0.43 to 1.00s (0.57s) |
| 2 | **Calendar flip** | An app-icon calendar flips "TODAY 7" to "YESTERDAY 6" on the word "Yesterday". | about 0.4s, on the word |
| 3 | **Rack-focus handoff** | The scene goes soft and dark; its chips stay as blurred depth around the new line; the statement resolves word by word from blur, the key word in the accent. | 3.30 to 4.23s (0.93s) |
| 4 | **Mask wipe-out** | The statement wipes away right to left as the next element enters. | about 0.5s |
| 5 | **Warm-wash birth** | A new window slides in as a solid warm block (the guest colour, coral #e07a5f to #683830) with horizontal motion blur; the colour cools into the real dark UI while its text fades in. | 5.07 to 6.53s; again at 24.1 and 46.5 (about 1.0s) |
| 6 | **Connector growth** | A hairline grows down from the active window to the next node (a repo card); the camera follows the line. | 8.00 to 9.07s (1.07s) |
| 7 | **Wasted-motion particles** | White dots scatter from a card and orbit it: the agent "exploring the codebase" again. The problem shown as motion. | 9 to 10.5s |
| 8 | **Blur-in mark** | The scene dims to a faint ripple field; the logo resolves from heavy blur to sharp, landing on "Meet". | 10.30 to 11.17s (0.87s) |
| 9 | **Band opens** | Two curved strokes open sideways out of the logo like an eye, particles appear inside; the guest chip drops in above on a line. | 12.80 to 13.27s (0.47s) |
| 10 | **Band to bar** | The curved edges straighten into a rectangle; the particles keep drifting. The container never leaves, it changes shape. | 15.60 to 16.07s (0.47s) |
| 11 | **Category cards on their words** | Small dark cards with a mono category label (CODING PATTERN, CONTEXT, PROJECT DECISION, PREFERENCE) resolve from blur, each as its word is spoken. | 16.83 to 17.70s, stagger 0.15 to 0.2s |
| 12 | **Absorption** | Each card collapses into a filled accent pill, then a dot, then flies up into the bar with a short trail; one by one. | from 19.3s, about 0.3 + 0.15 + 0.4s per card |
| 13 | **Retrieval pulse** | The bar fills with glow, lilac dots rise into the window, the window line flips to the result in green ("Recalled 3 memories"). | 27.4 to 29.0s |
| 14 | **Collapse to chip** | The window warms and shrinks into a small labelled chip (the reverse of 5), freeing the frame; a grid of repo cards rises on lines from the bar. | 32.10 to 33.63s (1.53s) |
| 15 | **Count-up cards** | The active stat card fills with the deep accent and its number counts up (2.2x to 3.5x); the fill hands to the next card. | about 0.4 to 0.6s each |
| 16 | **Container to hub** | The long bar shrinks into a compact pill in the centre, the stats go soft. | from 40.3s |
| 17 | **Whip-in cards** | Four feature cards fly in from off frame with heavy motion blur, staggered, and land around the hub. | 40.30 to 42.53s (2.23s for four) |
| 18 | **Highlight hop** | One accent fill hops from card to card on each spoken phrase. | about 0.3s per hop |
| 19 | **Typed mark and shimmer** | The mark appears alone, the wordmark types in letter by letter with a few stars, the tagline resolves word by word, then one white highlight sweeps across it. | 51.2 to 55.5s |

**Story shape (for a product explainer):**
1. the pain on a day you recognise (yesterday you told it, why tell it again);
2. the cost (it explores the codebase again);
3. meet the product, as the container;
4. what goes in (categories on their words, absorbed);
5. what comes out (retrieval into the session, the result);
6. reach (every repo);
7. proof (count-up cards);
8. features (hub and hops);
9. setup (three commands);
10. the mark and the line.

---

## 3. Building them in our engine (HyperFrames, one pure `frame(t)`)

Everything is a function of `t`, like the one-API film. Use the film's curves (`ramp`, `win`, `OUT`, `INOUT`, `SOFT`).

- **Rack focus.**
  - Outgoing layer: `filter: blur(${12 * k}px)` and opacity `1 - 0.55 * k` over 0.5 to 0.9s (SOFT). Keep it on screen as depth.
  - Incoming words: per word `blur(8px) → 0`, opacity 0 → 1, `translateY(6px) → 0`, staggered 0.08 to 0.12s.
  - Start 0.3s before the line's first word.
- **Directional motion blur** (for whip-ins and wash slides). A CSS blur is round, so use an SVG filter in the page: `<filter id="mbx"><feGaussianBlur stdDeviation="0 0"/></filter>`, set `stdDeviation` to `${v * 0.04} 0` each frame from the element's speed, and apply `filter: url(#mbx)`. Zero it when the element lands.
- **Warm-wash birth.**
  - The window slides 260px in over 0.45s (OUT) with the motion blur above.
  - A wash layer over its body (`linear-gradient(135deg, wash, washDeep)`) goes from opacity 1 to 0 between arrival and arrival + 0.6s, and the content fades in over the second half of that.
  - The wash colour is the actor's colour:
    - Claude windows: coral (Claude's own orange);
    - supermemory objects: brand blue #0562ef to #031a4a.
- **Chip to window to chip (shared-element morph).**
  - Interpolate `left, top, width, height, border-radius` between the two rects over 0.6s (INOUT).
  - The chip label fades out in the first 40%, and the window content fades in over the last 40%.
  - Run the wash during the morph. Reverse it for the collapse.
- **Band to bar.**
  - One SVG path: the top edge `M x0,y Q cx,y-k x1,y`, the bottom edge mirrored.
  - Open the band by growing `x1 - x0` from 0 at a fixed `k` (0.47s).
  - Straighten it by taking `k` to 0 (0.47s, INOUT).
  - Keep the particle field inside clipped to the path, so it survives the shape change.
- **Absorption.**
  - Phase one, 0.3s: the card's width, height and radius go 160x52/8 → 56x18/9 → 10x10/5, its fill goes dark → accent, and its label fades out in the first 0.15s.
  - Phase two, 0.4s: the dot flies on a quadratic curve into the container (INOUT) with a 6-sample trail.
  - On arrival the container takes one more particle and flashes for 0.1s.
- **Retrieval pulse.** The container's inner glow ramps up over 0.4s. Three to five dots then rise on curves into the target line (0.6s), and the line's text swaps to the result in the success colour.
- **Count-up.** `value = from + (to - from) * OUT(p)` over 0.6s, with fixed decimals and tabular figures. The active card fill fades in over 0.2s and hands off to the next card over 0.25s.
- **Highlight hop.** One fill rect moves between the cards' rects over 0.3s (INOUT), starting on each phrase's first word. The old card's text dims back to grey.
- **Typed mark and shimmer.**
  - The wordmark is revealed letter by letter, 0.06 to 0.08s each.
  - The tagline words blur in, staggered 0.1s.
  - Then one shimmer: `background: linear-gradient(90deg, accent 40%, #fff 50%, accent 60%)` with `background-clip: text`, `background-size: 300%`, and the position swept once over 0.8s.
- **Words, not just pauses.**
  - `vo_eleven.py` keeps ElevenLabs' character timings, so beats can key to any word: `WORD(line, "patterns")` gives that word's start time.
  - Picture leads its word by 0.2 to 0.4s.
  - `BRK(line, word)` (the phrase break after a word) stays for scene changes.

---

## 4. Using it on a supermemory film

- **Style card:** this is a transition family (one take, shared-element morphs, rack focus). Count it on the card in `anti-house-style.md`. It can sit on our luminous blue night or on a near-black ground with a blue horizon glow. The second matches Mem0 too closely for a film about the same topic, so prefer our blue night when the subject is the same as theirs.
- **Colour:** brand blue in five values:
  - pool glow #031a4a;
  - active fill #0b2a6b;
  - edge #2f86ff;
  - text accent #6fa8ff;
  - particles #9cc3ff.
  The guest colour is only the product we sit inside (Claude coral, Cursor's own colour), and only as a wash.
- **Voice:** she wants it faster than Mem0's 131 wpm (her v2.2 note). Keep about 170 wpm, but leave a 0.5 to 0.9s breath between sentences so each transition has room.
- **Claims:** never answer their stat cards with ours side by side, and never reuse their numbers. LoCoMo and LongMemEval figures are landmines (`memory-benchmarks-research`, `oct16-research-landmines`).
- **Reach check:** the Mem0 post had 2.9K views and 36 likes by Oct 25 (posted Oct 1, 20.6K followers), against 100K for our memory graph film. A better grammar makes the film better. It does not by itself make it travel.

Engine: `engine/blend-kit/` has these moves as functions plus a short demo in our brand.
