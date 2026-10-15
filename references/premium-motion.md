# Premium motion vocabulary (from luxury web and studio sites)

**Source:** `~/personal-supermemory/research_notes/Motion mastery/premium-web-motion.md` (Oct 15). It covers:
- @ascenta.studio's live code (her Instagram save);
- Immersive Garden, Locomotive, darkroom (Lenis), Obys, Lusion, Active Theory, Cuberto and OFF+BRAND;
- Codrops case studies.

**Use it with** `anti-house-style.md`. This file says how premium motion behaves; that one makes sure each film still looks like itself.

## 1. The vocabulary in one paragraph

A small set of moves, played slowly and not often:
- long out-curves (0.9 to 1.5s) for reveals;
- in-out curves for anything that crosses the frame;
- staggers of 0.05 to 0.1s;
- text and images entering through masks, never fades;
- inertia (λ ≈ 6 to 8/s) and small parallax (0.1 to 0.5 of frame height);
- one big, tightly tracked display face;
- a near-monochrome grade with a faint grain and vignette pass;
- no bounce.

Cheap is the opposite: default or linear easing, fade-ins, one 300ms timing everywhere, many sizes and colours, everything moving at once.

## 2. Curves and timings

| Role | Curve | Duration |
|---|---|---|
| Brand reveal (entrance) | expo-out `(0.16, 1, 0.3, 1)` (ascenta's only curve) or `(0.19, 1, 0.22, 1)`; quart-out `(0.165, 0.84, 0.44, 1)` | 0.9 to 1.5s |
| Crossing or leaving the frame | expo in-out `(1, 0, 0, 1)` or quart in-out `(0.77, 0, 0.175, 1)` | about 1 to 1.2s |
| Feedback (a click, a state change) | ease-out | 0.25 to 0.35s |
| Ambient drift under everything | `(0.2, 0.6, 0.4, 1)` | 20s or more, a few percent of scale or pan |
| Stagger | | 45ms a word, 50 to 80ms an item, 100ms a line |

**Never:** linear, the CSS default `ease`, bounce on anything premium (Apple's springs default to zero bounce; 15% barely reads), or staggers of 0.2s or more.

**Two speeds, never one.** Slow brand moments and quick feedback.

**Per lane A, rule 5:** pick 3 or 4 motion classes per film, each with its own curve, and don't reuse the last film's set.

## 3. Moves as pure functions of time (Swift)

```swift
func clamp01(_ x: Double) -> Double { max(0, min(1, x)) }
func eo(_ p: Double) -> Double { p >= 1 ? 1 : 1 - pow(2, -10 * p) }                       // expo out
func eio(_ p: Double) -> Double {                                                           // expo in-out
	if p <= 0 { return 0 }; if p >= 1 { return 1 }
	return p < 0.5 ? pow(2, 20 * p - 10) / 2 : (2 - pow(2, -20 * p + 10)) / 2
}
// 1. line-masked headline: line i slides up from below its own clip line
func lineRise(_ t: Double, line i: Int, t0: Double, dur: Double = 1.2, stagger: Double = 0.1) -> Double {
	1 - eo(clamp01((t - t0 - Double(i) * stagger) / dur))       // fraction of the line height still below the mask
}
// 2. masked image that settles: the clip opens, the picture keeps relaxing after the frame stops
func imageReveal(_ t: Double, t0: Double) -> (clipTop: Double, scale: Double) {
	(1 - eio(clamp01((t - t0) / 1.1)), 1.2 - 0.2 * eo(clamp01((t - t0 - 0.1) / 1.4)))
}
// 3. parallax by layer (speeds 0.1 product, 0.25 foreground, -0.1 background)
func parallax(_ p: Double, speed: Double, H: Double) -> Double { -speed * H * (2 * p - 1) }
// 4. product-film turntable over N pre-rendered stills, holding the last
func turntableFrame(_ p: Double, N: Int) -> Int { Int(floor(eio(clamp01(p)) * Double(N - 1))) }
// 5. inertial glide toward a target after a scripted step at tk (lambda 6.3 to 7.7 per second)
func glide(_ t: Double, tk: Double, from y0: Double, to T: Double, lambda: Double = 7.0) -> Double {
	t < tk ? y0 : T - (T - y0) * exp(-lambda * (t - tk))
}
// 6. velocity bend and grain pulse: v from glide's derivative, capped at +/-5
func bend(_ u: Double, v: Double, k: Double) -> Double { k * max(-5, min(5, v)) * sin(Double.pi * u) }
```

**Moves 7 to 10:**
- **Ambient drift:** a 20s+ scale or pan of 2 to 4%.
- **Counter preloader and wipe:**
  - the count is `round(100·eio(p))` over 1.5s, with the bar at `eio`;
  - then over 1s the bar slides one width right while halving, and the loader clips away.
- **Cover-flip:** `rect = mix(thumb, full, eio(p))` over 1.2s, with the next scene's line reveals starting in the last third.
- **Lagging cursor:** each pointer keyframe gets a 0.55s `eo` tween and a 15% magnetic pull near targets.

**Frame-rate independent smoothing:** `alpha = 1 - exp(-λ·dt)`, never a fixed per-frame lerp.

## 4. Type, colour and finish

- **Type sizes:**
  - few sizes; display type big and tight (about -2% tracking from 48px up);
  - all caps get +5 to 12% tracking, lowercase none;
  - a high-contrast serif only at display sizes (Didot's hairlines vanish when small);
  - one serif with one grotesk and a mono. ascenta pairs Fraunces with Geist and Geist Mono, which is the brand pairing plus one serif accent.
- **One grade:** near-monochrome, or soft black, warm grey and one accent, with every image graded to one tone. For supermemory, the accent is brand blue (anti-house-style.md §6).
- **The finishing pass,** last in the chain:
  - grain about ×0.15;
  - corners darkened up to 35%;
  - a hint of colour fringing (offset 0.005) applied early.

  It makes a render feel photographed rather than computed. The media reel's grain, vignette and CIBloom are this pass.

## 5. Where this meets my old tells (lane A)

| Topic | The house tell | What premium does instead |
|---|---|---|
| Masked text | letter by letter, 12ms a letter over 0.42s, on every line, in a bottom band | **line by line, 1.0 to 1.2s expo-out, 0.1s per line, used rarely.** Counts toward the 6-text-event budget; once per film as a signature |
| Camera | Hermite drift with pushes on every beat | **an ambient drift of a few percent over 20s+, or a locked frame.** One motivated move per section |
| Springs | 2.4Hz, damping 0.62, overshoot on every arrival | **no bounce.** Weight comes from duration and the curve |
| Product | many small objects, flat light | **one product, one hard light, shown big and sharp, early** (ascenta's fragrance rule) |
| Restraint | something on every beat | **take things away.** Motion only where it has a job (Immersive Garden, Noho) |
