# Motion mastery: the playbook (read before every new film)

**What this is:** the distilled result of the Oct 15 research run she asked for ("learn ... from all the resources you can find ... be the best at the game"), then "feed these researches into yourself" (Oct 16).

**The full reports** are in `references/research/motion-mastery/`, one file per lane:
- **A:** AI tells, the viral recipe, antidotes, the top 20 tells, the variation matrix.
- **B:** the craft atlas: 118 techniques with parameters and 25 fully specified signature moves.
- **C:** her own library: 163 techniques, the 20 references most "her", and premium versus cheap.
- **D:** the toolbox on this Mac.
- **Premium web motion:** ascenta's live code and the award studios.

The originals live in `~/personal-supermemory/research_notes/Motion mastery/`.

**How to use it:**
- §1 to §4 set the decisions.
- §5 lists moves to put on a style card.
- §6 says what to build next.
- `anti-house-style.md` holds the rules and checks.
- `premium-motion.md` holds the curves and Swift functions.

## 1. What I learned, in ten lines

1. **My watermark was a recipe.** The 12 moves of the viral Claude motion prompts of launch week (A §1.1), plus Opus's own fallback styles (numbered `01` labels, mono labels). Cap: 4 of 12 per film, and ban the defaults by name.
2. **Premium is moving away from "smooth".**
   - Figma cut its Config 2025 film to 15fps to feel handmade, and Vercel Ship 2025's opener was animated by hand on twos.
   - Spider-Verse used smears instead of blur, and misregistered plates instead of focus blur (B §0).
   - Perfect 60fps everything, with blur on every move, is now a machine tell.
3. **Restraint is the canon.**
   - Saul Bass limited Psycho to on/off, left/right, up/down and black/white.
   - Stranger Things is type alone.
   - Panic Room refused a CG fly-through because it signals "visual effect" (B §0).
   - Luxury web studios "spend more time removing than adding" (premium web §2).
4. **One hero object, one light, focus doing the editing.** This is ascenta, Miguel07Code's instrument, and the media reel's sculpture (C rows 20 and 26).
5. **One material per act, used as the whole world:** engraving, riso, ASCII or paper. Never decoration on top (C row 12; premium web: "a render pass as the brand's whole world").
6. **Curves come from a published system, a different one per film:** Material, Carbon productive or expressive, Apple's duration plus bounce (B §7.1). Exits run shorter than entrances, and luxury never bounces.
7. **Texture has real physics** (B §5):
   - **Grain:** 3 octaves weighted 50/33/17%, at about 30% opacity, "felt rather than seen".
   - **Halation:** channel radii R 1.4, G 1.0, B 0.7, strength 0.5 at most.
   - **Bloom:** mixed at 0.03 to 0.15.
   - **Chromatic aberration:** tiny.
8. **Sound trails the picture, never leads it.** The detection window is about 45ms early to 125ms late, so put each sound 0 to 2 frames after its picture. The sound names the material: one sound per event (B §9).
9. **The hook comes within 1.5s** (Google's ABCD research):
   - open mid-action or on a close-up, with bold sound and high contrast;
   - design for sound off: only 24% of 965 ads made sense muted (B §10).
10. **Real people type at a measured rhythm** (136M keystrokes):
    - the mean is 239ms a key (SD 112) and the floor about 60ms;
    - fast typists average about 120ms;
    - use 90 to 180ms with pauses at word breaks (B §1.10, M4).

## 2. Her taste, calibrated (lane C §3)

**Her strongest signals, in her own words:**
- "a lot of movement, things blending" (@himanshubuildss);
- "learn this video" (@workersio: white, one orange, zero cuts, one survivor);
- Parthiv's halftone-in-blue film (what "supermemory branded" means);
- the learner-1 brand film ("very intentional and deep");
- the KeshWelch globe (one orbit for the whole film);
- rajzmotion (material transitions);
- the rossaxbt morph films;
- LexnLin's tessel (polish);
- darel023 (precise curves);
- the glass-head pin (glow is allowed when the subject earns it);
- Miguel07Code's instrument (one object, focus as the edit);
- ascenta (one product, one shaft of light).

**Her standing asks still hold:** lots of movement, one thing blending into the next, polish, readable on a phone, the real product. The research varies the form, never these.

## 3. Premium versus cheap (C §1, premium web §3)

| Premium | Cheap (the tell) |
|---|---|
| one accent with a meaning; ink and paper carry the rest | rainbow, neon, a new colour per card |
| curves by role, from a named system; exits shorter | one curve everywhere, CSS defaults, linear |
| nothing grows from nothing: enter from scale 0.95 at the trigger point | pops from scale 0 at the centre |
| a real shutter whose sample count follows speed; or steps and smears | no blur (strobing), or a fixed blur on everything |
| depth by optics: thin-lens blur, focus pulls | one sharp plane; blur as decoration |
| type steps at 12 to 15fps while the world glides | every layer interpolated at 60 |
| line-masked reveals on a long expo-out (1.0 to 1.2s), rarely | fades; per-letter rises on every line |
| one real material per film | orbs, sparkles, glass on every card, dot grids as filler |
| a serif accent at display size, pairing one serif, one grotesk, one mono | one template sans at template sizes |
| colour held back for the payoff | full colour from frame 0 |
| a few large things in wide space | every corner used |
| zoom in log space | linear scale (rushes, then crawls) |
| a style anchor from outside tech | no anchor: centred text, gradient, fades |

**Template alarms** (shipped by 5 to 8 of the 10 component libraries she saved, so they read as AI):
- border beams;
- word-by-word blur-ins;
- scramble headings;
- shimmer and typewriter carets;
- rotating hero words;
- aurora blobs;
- space backdrops;
- hero spotlights;
- orbiting-icon hubs;
- logo marquees;
- count-ups from zero;
- cursor spotlights;
- liquid glass everywhere;
- full-screen dither backdrops.

Use each once and transformed, or never.

## 4. Decisions before code

Follow `anti-house-style.md` §2:
1. the 90-day check;
2. an 11-dimension style card checked against `style-log.md`;
3. a 5-panel colour script;
4. a first still, then name its defaults and ban them;
5. the recipe count (4 of 12 at most);
6. the logo-off test;
7. time budgeted for the look.

**Fonts:**
- **For brand words:** Geist and Geist Mono. They are variable (100 to 900). Geist Mono keeps its width at every weight; Geist grows 17% wider from 100 to 900, so reserve the space.
- **For published films:** macOS serif families (Didot, Bodoni 72 and others) need a licence check (B §13.11). Geist is always safe.

## 5. Moves for a style card

### The 25 signature moves (lane B §11 has full specs: timing, curves, parameters, sound, build, brand rule)

| # | Move | Use it for |
|---|---|---|
| M1 | Macro glyph lock: two fragments of a giant Geist letter lock, then a log pull-back reveals the word | a mystery hook |
| M2 | Weight tide: a wave of stroke weight across a Geist Mono line, resting heavy on the key word | the statement after a reveal |
| M3 | Trend odometer: digit columns roll in the direction of change and land right to left | a proof beat (never from zero) |
| M4 | Typed by a person: bursts, a breath before the key word, one typo fixed, the caret blinks only when idle | an input moment |
| M5 | Misregistration focus pull: out-of-focus planes as plates out of register that slide into register | moving attention near or far |
| M6 | Stepped world, smooth camera: objects on twos, camera at 60, one smear frame on fast moves | a whole act |
| M7 | Shutter swing: a crisp 45° shutter for "before", a soft 270° for "after" | the turn |
| M8 | Powers-of-eight pull: card, board, app, network, each 8x | the scale beat or the ending |
| M9 | Droste return: dive into a real framed screen that shows frame 0 | a loop ending |
| M10 | Slit-scan arrival: the new layout ripples across as a time smear | before to after |
| M11 | Fizzle into cells: 8px cells switch in an exact random order, each once | a scene change |
| M12 | Rack focus from statement to proof; the statement loses colour as it softens | proof |
| M13 | Tilt-shift system city: server blocks as a toy model, stepped | showing a system |
| M14 | Dolly-zoom realisation | the realisation beat |
| M15 | Shape match cut: round to round at the same place, size and speed | any seam |
| M16 | Map fold reveal: a card opens in four shaded panels | opening an item |
| M17 | Ink bloom wipe: reaction-diffusion grows into the mask for the next scene | a transition |
| M18 | Flow-field handwriting: strokes comb onto a word, then smooth | a title |
| M19 | Halation switch-on: a screen lights in the dark with a red-orange edge | product reveal |
| M20 | Datamosh handover, 14 frames, landing on the downbeat | a hard change |
| M21 | Pixel-sort decay | forgetting, decay |
| M22 | Type poster takeover: three sizes, one word full-bleed, one word blue | a statement act |
| M23 | Echo collapse: a verb leaves six outline echoes, which collapse into the word | verbs |
| M24 | Line boil to ink: a sketch boils, then fills to clean vector | idea to product |
| M25 | Archive versus now: a 4:3 inset with gate weave at 18fps, then full-bleed clean 60fps | the old way versus the new |

**Spares:**
- M26: Voronoi re-sort.
- M27: a bar-carried title (Saul Bass).

### Built and proven (the media reel)

- the gallery light;
- engraving;
- type as image;
- the survey drawing;
- riso;
- the infinity mirror room;
- the anamorphic lockup;
- light-sweep handovers;
- a log pull-back with speed-driven blur.

Engines are in `engine/media-reel/`.

### Ending devices

Not a logo slam (B §10.9; `anti-house-style.md` §5): anamorphic alignment, defocus under the lockup, return to frame 0, a light reveal, the last print, type resolves, through a window, or a cut to black.

## 6. What to build next (lane B §14, in order)

**Done (Oct 16):**
- Items 1 and 3 are now `engine/kit/motionkit.swift`: curve families, duration-and-bounce springs, stepped time, smears, speed-driven shutter samples, log zoom, typing rhythm, line reveals, SFX timing and film-finish numbers.
- The rules are enforced by `engine/tools/tells.py`.

1. **A curve-family switch with closed-form springs set by duration and bounce.** A damping ratio of exactly 1 minus bounce, as checked in SwiftUI on this Mac.
2. **Variable Geist:** a `geist(weight:)` helper with the fixed-slot layout rule. This unlocks M2 and M22.
3. **Per-layer time steps and a shutter-angle setting:** M6 and M7.
4. **A depth stack with focus** (`CIMaskedVariableBlur`): M5 and M12. This is lane C's biggest gap.
5. **The film-finish kernel:** grain on the AV1 model, halation by channel, gate weave.
6. **A match-cut helper:** M15.
7. **The editorial serif language.**

## 7. Studios and people to keep learning from

From lane A §3.4, lane B and premium web §2:
- DIA Studio (rhythm as system);
- Universal Everything (AI as one stage in a directed pipeline);
- Figma Brand Studio (imperfection on purpose);
- Raphaël Aubry (genre transplant);
- 3Blue1Brown (the motion is the mechanism);
- Zach Lieberman (seeded randomness);
- Spider-Verse (twos, smears, print colour);
- EPTA (flip the loudest trait);
- Tim Rodenbröker (one generative system per piece);
- Saul Bass and Art of the Title (restraint);
- Immersive Garden, Locomotive, Obys, Lusion, Active Theory, Cuberto and OFF+BRAND (premium web).

## 8. Proof that it works, and where it over-corrects (blind test, Oct 16)

**The test:** two fresh agents planned the same 20s brief, one with the pre-research skill and one with this one. Two blind critics judged them, with the order swapped.

| Score | Old skill | New skill |
|---|---|---|
| Generic | 8 | 2 |
| Craft | 6 to 7 | 8 |
| Memorability | 5 | 8 |
| Branding | 9 | 6 to 7 |
| Clarity | 9 | 6 |

- **Both critics would post the new one.**
- **The old skill rebuilt the whole house style** from a free brief: lattice, + grid, mono labels, pops, the hip-hop kit, the mark-to-lockup ending.
- **Where the new one over-corrected:** clarity and branding. The fix is the balance rules in `anti-house-style.md` §4b:
  - muted-phone clarity by 5s;
  - the brand in the first 3s;
  - nothing to read blurred;
  - grain on dark grounds;
  - an anchor that reads at once.
- **Record:** `research/motion-mastery/blind-test-2026-10-16.md`.

## 9. Still unknown (be honest about these)

- **Nothing in lanes A and B was watched frame by frame.** They are written sources; lane C measured her bookmarks.
- **Unreachable:**
  - the IG reel she shared (the browser pane was hidden);
  - her X bookmarks after Oct 8 (X logged out);
  - the "Motion Engineering" article (needs her X login);
  - most studios' numbers (they publish looks, not parameters).
- **"Most wanted" is not a craft property.** Views follow announcements, big accounts and people on screen (video-study). Her reaction and posting data are the test.
