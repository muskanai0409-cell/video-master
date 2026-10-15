# Blind test: does the research change the films? (2026-10-16)

**Question:** she asked "what did you learn from the skills? are they even useful". To find out, two fresh agents planned the same film. One had the video-master skill from before the research (commit 740a8cb). The other had the skill after it (commit 37b7dc6). Neither saw the other.

**The brief they shared:** a 20s 16:9 supermemory film, "your agent remembers what you told it last week", for developers.

**How it was judged:** two blind critics. Each got both plans as A and B, with the order swapped between them, plus the 12-move viral recipe and the common default styles. Neither knew which skill wrote which plan.

## Result

| | Generic / "Claude-made" (lower is better) | Craft | Branding | Clarity of the one idea | Memorability | Recipe moves used |
|---|---|---|---|---|---|---|
| Old skill (blue lattice, YOU/AGENT cards, springs, Yearning kit, mark-to-lockup) | 8, 8 | 6, 7 | 9, 9 | 9, 9 | 5, 5 | 6 to 8 of 12 |
| New skill (overhead projector: the sheets are context, the projector is the model) | 2, 2 | 8, 8 | 6, 7 | 6, 6 | 8, 8 | 1 to 2 of 12 |

**Both critics would post the new-skill plan:**
- One said: "A will get scrolled past as one more Claude film, while B is the one a developer could describe to someone else."
- The other: "a memory company that looks like everyone else's prompt is forgettable by definition."

## What it shows

1. **The research works on what she asked for.** Genericness fell from 8 to 2. Recipe moves fell from 6 to 8 down to 1 to 2. Craft and memorability went up. The old skill, given a free brief, rebuilt the house style on its own (lattice, + grid, mono YOU/AGENT labels, a pop, an event on every beat, 8-subframe blur, the hip-hop kit, the mark-to-lockup ending).
2. **It over-corrected on clarity.** The new plan:
   - never says who is talking or when;
   - pulls focus onto 15px text no phone can read;
   - holds "last week" back until 14s;
   - plays muted as "a retro slideshow" for 14 seconds.
3. **It also over-corrected on brand.** With colour held for the payoff, blue doesn't appear for 8 seconds and never fills the frame. Branding fell from 9 to 6 or 7.
4. **One craft risk:** a near-black ground with a corner falloff and no grain will band in X's compression.

## What changed in the skill because of this

The balance rules in `anti-house-style.md` §4b:
- the idea must be clear when muted on a phone;
- the brand must be on screen early;
- nothing a viewer must read goes out of focus or below phone size;
- dark grounds get grain.

These are QA gates in SKILL.md §7 too.

## The two plans (verbatim)

### Old skill
**1. The look**

Brand book memory field (engine/morph-chain): blue 600 #0100F5, light Bayer-dithered toward blue 500 #0562EF, screen-fixed 7px lattice (stored dots square, recalled 45°), world-locked 160px hairline grid with + marks.

Square paper #F4F8FF cards, ink #0b1015. Geist 500: messages 72px, paper title 64px top left. Geist Mono caps 28px: YOU, AGENT.

One accent: "pnpm" in blue 500, after recall. No glow, gradients, 3D, see-through fades or colour tweens.

**2. Beat map**

140 BPM, timed in b(n).

0.00 frame 0 composed: title "last week", card YOU "i use pnpm".
0.86 card AGENT "got it" springs in.
1.71 "pnpm" lifts off into a 200px paper tile.
2.36 the chat ends: both cards fall into the lattice, the tile stays square (stored).
3.43-6.86 the week. Camera tracks past seven + marks, each firing a ring of recalled dots, tile anchored. 6.43 title rolls to "today".
7.29 card YOU "install the deps" rises below, 8.14 card AGENT opens with typing squares.
8.57 the tile turns 45° (recalled), ringing the lattice.
9.00-10.00 "running " types, paper tokens pour from the diamond into the gap, "pnpm" lands blue, then " install". 9.86 tile squares again, still stored.
10.00-12.86 proof hold, pulling back at 11.57 to tile, cards and dashed token path.
12.86 everything but the tile falls into the lattice, the tile rises to centre.
13.50-16.93 thesis, centred, 96px: "your agent remembers / what you told it last week", "remembers" and "last week" full paper, rest 62%.
17.14-20.00 the ending.

**3. Camera**

One take on one fixed map: no cuts, whip pans, shake or zoom punches. Moves 0.6-0.9s on cubic-bezier(.5,0,.2,1), then 1-2% drift: 1.35x last week, 1.5x lift, 1.35x track, 1.8x reply, 1.3x pull-back, 1.0x thesis. 60fps, 8-subframe blur. 70%+ moving, no still over 1s.

**4. The ending**

17.14 thesis exits, the tile carves into the mark. 17.79 official horizontal lockup, paper on blue, wordmark sweeping out from behind the mark. 18.09 "supermemory.ai", Geist Mono 44px. Field eases to a stop. Still 18.69-20.00s.

**5. Sound**

Apple Loops, Yearning kit (A minor, 70 BPM, film at 140). Keys alone for last week, drums and lattice pulses through the week, drums out before the recall, crash and strings on it, low-pass sweep and sub into the lockup. Effects with on-screen causes: pop on "got it", keys per character, pentatonic pops as cells fall, ticks on + marks, bell on recall, thumps only on recall and lockup, no whooshes. -14 LUFS.

### New skill
**1. The look**
1920x1080, 60fps. Anchor: an overhead projector in a dark room. What's on the glass is what the agent sees; the sheets change, the projector never does (memory goes into context, not the model).
Ground: ink room #0b1015; a 4:3 projected rectangle 1160px wide, left of centre; a plain black projector cropped into the right foreground.
Palette: light #f4f4f6, ink #0b1015 at alphas, one blue #0562ef. Blue first appears at 8.16 and only grows after.
Type: lowercase Geist printed on the sheets, never animated. Wall lines Geist 500 92px, the thesis Geist 600 96px, tracking -2%. The sheet on the glass reads at 15px (a physical 6x scale contrast). The only blue word is "pnpm" in the reply.
Texture: lens falloff only, corners 10% darker. No grain, bloom, springs or blur.

**2. Beat map** (125 BPM, sections of 8/4/5/7/5/8 beats)
The lit rectangle carries through every scene change. Sheets move on twos: in over one beat on (0.4, 0.14, 0.3, 1), out in 0.3s with one smear frame. Holding sheets creep up 20px/s, so no hold runs past 1.2s.
0.00 Last week. Frame 0 is mid-action: a sheet slides its last 60px onto the glass, the wall reads "i use pnpm" (made-up example, flag for OK). At 3.0 the sheet is pulled off to the left and the wall empties.
3.84 Gap. The lamp clunks off: near-black for 0.96s, the projector a faint silhouette. At 4.80 the lamp comes on to an empty lit rectangle.
5.76 This week. A sheet slides in from the right: "set up the new repo", ink 60%, top third.
8.16 Turn. From the left, where the old sheet went, a blue diazo slide lands mid-rectangle: "i use pnpm" in paper letters, with the exact mark in its corner.
11.52 Proof. A sheet slides in from the right below the blue band: "running pnpm install", its blue "pnpm" directly under the band's "pnpm".
13.92 Thesis. The ink sheets exit right as a full blue slide enters from the left: "your agent remembers / what you told it / last week", paper on blue.

**3. Camera**
Locked tripod behind the projector. Focus does the editing: thin-lens blur up to 16px, 1.2s focus pulls on (0.16, 1, 0.3, 1). Pull to the glass at 1.8 and 7.0, to the wall at 4.8 and 8.9.

**4. The ending**
The last sheet: at 17.76 the lockup slide pushes the thesis out, carrying the official horizontal lockup from the mask files, paper on blue, 900px wide. Lands 18.24, then a still with identical frames to 20.0.

**5. Sound**
Apple Loops Indie Disco kit at 125 BPM. Bass and keys from frame 0. The lamp clunk cuts everything as the fan spins down: the film's one impact and one silence. Bass back at 4.80, the full kit as the blue slide lands, one chord rings into the final still. Projector foley: acetate hiss and a tap on each landing, the lamp switch, fan hum, each 0 to 2 frames after its picture. No whooshes or risers. -14 LUFS.
