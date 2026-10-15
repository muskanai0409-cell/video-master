# Premium vs cheap web motion (for the video renderer)

**Date:** 2026-10-15.

**What this is:** a sub-report for lane C, written by a research agent and saved here unchanged in substance. It covers @ascenta.studio (her Instagram save) and the studios that make expensive-looking sites.

**Codrops and timing caveats:**
- Codrops numbers come from search-engine extracts of those articles, because direct fetches were blocked.
- Studio durations are self-reported.
- Easing formulas, λ conversions and frame-per-screen figures are the agent's own calculations.

## Verdict

Expensive-looking sites use a small motion vocabulary, played slowly and not often:
- long expo or quart out-curves (about 0.9 to 1.5s) for reveals, and in-out curves for anything that crosses the frame;
- staggers of 0.05 to 0.1s;
- text and images entering through masks, not fades;
- inertia at about lerp 0.1, and parallax at 0.1 to 0.5 of frame height;
- one big, tightly tracked display face;
- a near-monochrome grade with a faint grain and vignette pass.

Cheap looks like:
- linear or default easing, and bounce;
- fade-only entrances;
- many sizes and colours;
- everything moving at once;
- pages so heavy the product shows up late.

## 1. ascenta.studio (verified from its live code)

**Who they are:**
- Instagram @ascenta.studio, about 2.3k followers; ascentastudio.com.
- Run by La Factoria LLC (USA and Spain). Prices: a site $500, a store $2,500, an animated hero add-on $500.
- Not the same as ascenta.studio, which is a Russian-language studio.

**The concepts:**
- Nine invented brands: two perfumes, skincare, lipstick, a running shoe, a drink, a watch, a leather bag and a VR headset.
- Each makes one product the hero, under one hard light (a bottle in molten gold, a bag in one shaft of light, a shoe floating in the dark).
- Headlines are 2 to 5 words. Sections are numbered 01 to 05, with "01 / 05" counters.

**Measured from styles.css and main.js:**
- Type: Fraunces serif with Geist and Geist Mono.
- Colour: pale grounds #E9F1FB and #F1FAF5, ink #0B1322, accents #3D4DFF and #7A5CFF.
- **One house curve: `cubic-bezier(.16,1,.3,1)`.**
- Durations: rises 0.9s, reveals 1s, buttons 0.3s, nav underline 0.35s. Delay steps of 0.08, 0.16, 0.26 and 0.36s. Headline words are staggered 45ms each after a 0.25s wait.
- The hero poster drifts for 22s on `cubic-bezier(.2,.6,.4,1)`.
- Card entries finish within the first 45 to 60% of their scroll entry.
- Scroll: Lenis lerp 0.12, 1.4s anchor jumps. Reveals fire at 8% visibility.
- The hero video runs at 24fps and 4.6 Mbps (0.5 on mobile), and is skipped on slow connections.
- NACRE's hero is a 485-frame still sequence, which suggests a scroll-scrubbed product film (inferred).

**Their fragrance-page rules:** show the bottle big and sharp; keep the mood without letting page weight delay the product; make the notes readable at a glance.

**Gaps:**
- The reel itself and its caption could not be watched or read.
- The concept pages hold a hidden Spanish fragment with instructions. It was ignored.

## 2. Studios and their signatures

1. **Immersive Garden:** bas-relief 3D, 3D Roman numerals as navigation, GSAP and Lenis. "More time removing than adding."
2. **Locomotive:** per-element parallax at speeds of 0.1 to 0.5, switched off on touch screens.
3. **darkroom.engineering / Studio Freight:** Lenis (lerp 0.1, or a 1.2s expo ease), the shared inertia of award sites.
4. **Obys:** type-first editorial layouts. The logo morphs as the page goes from dark to light. Tiny timing and spacing tweaks were the hardest part.
5. **Lusion:** rich visuals from stacking modest techniques.
6. **Active Theory:** tints the whole scene with the average colour of the playing video. Decorative WebGL is noise without a purpose.
7. **Cuberto:** a lagging cursor follower (expo.out 0.55, stick 0.15, slight skew) and magnetic buttons.
8. **OFF+BRAND:** Aether 1, a fictional headphone site. Motion is precomputed into 3D files and tied to scroll, and one frequency band of the soundtrack drives the visuals.

## 3. Twenty-five principles (premium rule; the cheap version)

1. **Entrances on out-curves:** expo-out `(0.19,1,0.22,1)` or `(0.16,1,0.3,1)`, or quart-out `(0.165,0.84,0.44,1)`. Never linear or the CSS default `ease`.
2. **Crossing or leaving the frame on in-out:** expo in-out `(1,0,0,1)` or quart in-out `(0.77,0,0.175,1)`. A cover flip runs 1.2s expo.inOut.
3. **Two speeds:**
   - brand reveals take 0.9 to 1.5s;
   - feedback takes 0.25 to 0.35s;
   - one 300ms default everywhere is cheap.
4. **Tight staggers:** 45ms a word, 0.05s across a grid, 0.08s for icons, 0.1s a line. Never 0.2s or more.
5. **Text through masks:** lines slide up from 100% of their height inside a clip (GSAP demo: 0.6s, stagger 0.1, expo.out). Fades are cheap.
6. **Images reveal, then settle:** clip from `inset(100% 0 0 0)` to `inset(0)`, while the image inside scales from 1.2 to 1, slightly out of step (1.2s power4.inOut).
7. **Inertia on everything that travels:** lerp 0.1, or `min(1, 1.001 - 2^(-10t))` over 1.2s.
8. **Time-based smoothing:** `alpha = 1 - e^(-λ·dt)`. Lerp 0.1 at 60fps is λ ≈ 6.3/s; 0.12 is λ ≈ 7.7/s.
9. **Small parallax:** offset = progress (-1 to 1) × frame height × speed, at speeds of 0.1 to 0.5.
10. **Product films as frame sequences,** never a scrubbed MP4. Apple's AirPods page uses about 37 frames per screen of scroll.
11. **Never fully dead:** a very slow drift on the hero (22s), or a 24fps film behind the content.
12. **Distortion follows speed, then rests:** bend = sin(u·π) × velocity, capped at ±5, with the velocity smoothed (lerp 0.05).
13. **A faint finishing pass:**
    - grain (fractal noise at 0.65 with 3 octaves, or shader grain × 0.15);
    - colour fringing (offset 0.005);
    - corners darkened by up to 35%;
    - fringing early in the chain, grain last. It makes a render feel photographed.
14. **One grade, few colours:** near-monochrome, or soft black, warm grey and one accent, with every photo graded to one tone.
15. **Few type sizes, display type big and tight.** Inter's tracking is `-0.0223 + 0.185·e^(-0.1745·size)`, so about -2.2% from 48px up.
16. **All caps get 5 to 12% tracking;** lowercase never does.
17. **High-contrast serifs only at display sizes.** Didot's hairlines vanish small. Pair one serif with one grotesk and a mono.
18. **No bounce on luxury.** Apple springs default to zero bounce. About 15% barely reads, 30% is clearly bouncy, and over 0.4 is too much.
19. **Take things away.** Immersive Garden, Pell Mell and Noho step motion up only where it has a job.
20. **Reveals early and gently:** ascenta triggers at 8% visibility.
21. **A short preloader, once:**
    - the mark on 1.4s expo.out, then a 1.5s expo.inOut bar;
    - an `inset(0 0 100% 0)` wipe over 1s;
    - shorter for repeat visitors.
22. **Transitions keep continuity:** the old page drifts up under an overlay and wipes, or a link flips into the next page's title in 0.9s. A hard cut or a white flash is cheap.
23. **Sound is opt-in, sparse and tied to state:** one tick when the panel changes, volume scaled by drag speed.
24. **The cursor lags with intent** (Cuberto 0.55 expo.out, sticking to targets). A cursor locked 1:1 on a floating site is cheap.
25. **Speed is part of luxury.** The product appears fast.

## 4. Ten signature moves as pure functions of time

**Notation:**
- `p = clamp((t - start) / dur, 0, 1)`
- `Eo(p) = 1 - 2^(-10p)`, expo-out
- `Eio`: expo in-out

1. **A line-masked headline.** Line i: `y = 100% × (1 - Eo(p_i))`, starting at `t0 + 0.1·i`, over 1.2s, clipped to the line's box.
2. **A masked image that settles.** Clip top `= 100% × (1 - Eio(p))` over 1 to 1.2s. The image scale `= 1.2 - 0.2·Eo(q)`, with q starting about 0.1s later and running about 1.4s.
3. **Slow product parallax.** `y = -speed × H × (2p - 1)` across the shot, at speeds of 0.1 (product), 0.25 (foreground) and -0.1 (background).
4. **A product-film turntable.** `frame = floor(Eio(p) × (N - 1))` over pre-rendered stills. Hold the last frame.
5. **An inertial glide.** After each scripted step at time tk: `y = T - (T - y0)·e^(-λ(t - tk))`, with λ of 6.3 to 7.7/s.
6. **A velocity bend and grain pulse.** v = dy/dt from move 5, capped at ±5. Vertex offset `= k·v·sin(πu)`, grain `= base + |v|/10`.
7. **An ambient hero drift.** A few percent of scale and pan over 20s or more on `cubic-bezier(.2,.6,.4,1)`.
8. **A counter preloader and wipe.**
   - The count is `n = round(100·Eio(p))` over 1.5s, with the bar at `scaleX = Eio(p)`.
   - Then, over 1s, the bar slides one width right and halves while the loader clips away (`inset(0 0 100% 0)`).
9. **A cover-flip transition.** `rect = mix(thumbRect, fullFrame, Eio(p))` over 1.2s. The next scene's line reveals start in the last third.
10. **A lagging cursor with a magnetic stick.** Each pointer keyframe gets a 0.55s Eo tween. Near a target, pull about 15% toward its centre, with a speed-capped skew.

## Sources

**ascenta:**
- instagram.com/ascenta.studio
- ascentastudio.com (with styles.css, main.js, /nacre/, /fragrance-brand-website-design)
- ascentatrack.com

**Codrops case studies:**
- MERSI
- Joffrey Spitzer
- Telha Clarke
- 1820 Productions
- Pell Mell
- Noho
- Obys
- Trionn
- Spain Collection
- Bloom Paris TV
- Gabriel Contassot
- OPTIKKA
- Forged.build
- Ronin161

**Libraries and docs:**
- Lenis
- Locomotive Scroll
- Cuberto mouse-follower
- GSAP SplitText
- Flutter curves
- Material durations
- Apple WWDC23 "Animate with springs"
- NN/g on animation duration
- practicaltypography.com
- Inter dynamic metrics
- Jonathan Hoefler
