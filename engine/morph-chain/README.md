> **Using this from the video-master skill (added 2026-10-15).** This is the local v0.0.9 launch film: one paper container that changes state on the beat, on the brand book's dot field. It builds on its own:
> ```bash
> mkdir -p fonts stills && cp ../assets/fonts/*.ttf fonts/ && cp ../assets/lock_*.png .
> ./make.sh && BPM=162 SCALE=1 SUBFRAMES=1 ./render stills 3 12
> ```
> Scores: `make_audio_loops.sh` (Rise Up kit) or `make_audio_v2.sh` with `KIT=legend|trap|sympathy` (three originals stretched to 81 BPM). The guide is in `references/motion-systems.md` §5.

# supermemory local v0.0.9: launch film

**Her brief (2026-10-14, typos kept):** "make an amazing short launch video on this … use evryhting from [the video-master repo] … one thign bledne dinto other … pick that from the repo … super duper polished in supermemory branding … shoudnt be longer than 20 seconds tho".

**Launch copy it illustrates (the team's post):** "supermemory local v0.0.9 is out! - API v5 support - Better security - about 40% faster - you can use it with docker now (we heard you! The next version of local will be 10x less resource intensive)".

**Outputs** (19.85s, 60fps, 16:9):
- `../local-v009-4k.mp4`: the 3840x2160 master;
- `../local-v009-1080.mp4`: the 1080 cut;
- `-silent` versions of both.

Rendered videos stay on the Mac (the root `.gitignore`).

## The idea

There is one continuous take on the brand book's own surface:
- blue 600 `#0100F5`, with its light dithered toward blue 500 on an 8x8 Bayer matrix;
- a screen-fixed lattice of stored dots;
- a hairline grid with + marks.

One paper container is the survivor of the whole film. It changes state on the beat and finally becomes the mark.

| Film beat | Time | The container | Caption (band) |
|---|---|---|---|
| b0 | 0.00s | Frame 0 is the thumbnail: "v0.0.9" recalled out of the dot lattice, under a mono "supermemory local" | |
| b2 | 0.74s | The version goes solid in a wipe; a ring runs out through the lattice | |
| b3 | 1.11s | A prompt chip `$ ▍` pops under it | |
| b4.2 | 1.56s | The version flies into the top-left corner and stays there as the HUD; the chip stretches into the command bar | |
| b5.3 to b7.4 | 1.96 to 2.74s | `docker compose up -d` is typed, one key sound per character | |
| b8 | 2.96s | ENTER on the drop: the bar opens into a terminal, a pull bar fills, then `✔ supermemory started` (b10) and `→ 127.0.0.1:6767` (b11) | 01 · you can run it with docker now / we heard you |
| b16 | 5.93s | The terminal becomes a v5 call, `client.search("user_dhravya", { query: "what food should I avoid?" })`; the namespace lights up (b18); the memory comes back as a chip, "Dhravya is allergic to peanuts" (b19) | 02 · api v5 support / the v5 sdks run on local |
| b24 | 8.89s | The call becomes a request bar, `POST localhost:6767/ns/user_dhravya/search`: 401 and the lock shuts (b26); the key row goes in (b27); 200 and the lock opens (b30) | 03 · better security / localhost now needs your api key |
| b32 | 11.85s | The request becomes a counter that rolls 0 to 40% while streaks of dots rush through the lattice | 04 · about 40% faster |
| b39 | 14.44s | The counter is cut into ten squares | 05 · next version of local / 10x less resource intensive |
| b40 | 14.81s | On the breakdown, nine squares fall back into the lattice, from the outside in; one is left and moves to the centre | |
| b46 | 17.04s | The last square carves itself into the supermemory mark (a distance field of the mark, thresholded down to zero) | |
| b48 | 17.78s | The lockup lands: the wordmark sweeps out from behind the mark, then `local v0.0.9` and the chip `$ npx supermemory local` | |
| b50.2 | 18.59s | A still hold of 1.25s with identical frames | |

**Moves taken from her library** (video-master, `library/`):
- **@rossaxbt morph chain** (UI-morph reel #23, launch film #12): one container through many states, edge springs, a state change on the beat, motion blur mid-resize.
- **@workersio** (`13-shared-oct.md` #1): the survivor object becomes the logo, a counter, and a mono HUD.
- **@LexnLin:** one brand element that recurs. Here the version flies into the HUD and returns under the lockup.

**The engine:**
- The field, lattice, rings, grid, type rise and lockup reveal come from `../learner-teaser-v7-src`, the brand-book engine.
- The morph chain, the counter, the slices and the carve are new, in `film.swift`.

## Claims

Every claim was checked on 2026-10-14. The full ledger is `research_notes/local-v0.0.9-launch/ledger.md`.

| On screen | Status | Source |
|---|---|---|
| supermemory local v0.0.9 | Supported | GitHub release `server-v0.0.9`, published 2026-10-12 |
| docker | Supported | Release: "Added prebuilt Docker images for Linux amd64 and arm64."; docs `/docs/self-hosting/docker` |
| `docker compose up -d` | Supported, shortened | Docs run `docker compose up -d --wait --wait-timeout 180` |
| `127.0.0.1:6767` | Supported | Docs: "The Compose file binds port `6767` to `127.0.0.1`" |
| api v5 | Supported | Release: "Added API v5 support."; quickstart: v5 SDKs need `supermemory-server` v0.0.9 or later |
| `client.search("user_dhravya", …)`, "what food should I avoid?" | Supported | The quickstart's own example |
| localhost now needs your api key | Supported | Release: "Localhost requests now require the key"; docs: "API requests require it even on localhost." |
| about 40% faster | **Unsupported publicly** | Only in the team's launch post |
| next version: 10x less resource intensive | **A promise** | Only in the team's launch post |
| `npx supermemory local` | Supported | Quickstart install tab |

**Illustrative, not captured:**
- The terminal output (`✔ supermemory started`) is stylised. Real Compose prints `✔ Container supermemory-supermemory-1  Started`. The first cut said "healthy", which was wrong: the release `compose.yaml` has no healthcheck, and plain `up -d` never reports health. Fixed on 2026-10-14; see the re-check in the ledger.
- The search result chip "Dhravya is allergic to peanuts" is the memory the docs' example implies. The docs do not show the response.
- The 401 and 200 pill is drawn, not captured. The 401 is the behaviour the release describes.

## Before posting

1. **"about 40% faster": ask the team** which operation, and measured how. Nothing public says. If no one can answer, cut beat 04 (b32 to b39) or change the line.
2. **"10x less resource intensive"** is a future promise. Confirm it is OK to show.
3. **Listen first.** I cannot hear the mix, so nobody has auditioned it yet. Check it on laptop speakers and headphones.
4. Per `video-master`, a launch film needs a yes from Dhravya or Prasanna before the main account posts it. Drafts only; I never post.

## Sound

**The music:**
- GarageBand's "Rise Up" kit (01 Hip Hop): C major, 81 BPM. The film counts at 162 (`score_loops.swift`, `make_audio_loops.sh`).
- The GarageBand licence allows loops in original soundtracks. The loops are decoded to ~/Library/Caches/video-master, never into the repo.
- The drum hits were measured from the Beat loop: kicks on film beats 0, 3, 7.5, 8, 11, 16, 19, 24 and 27; snares every 4 beats from beat 2. The small events land on them, and the lattice pulses on them.

**The arrangement:**
- b0 to 8: piano alone, filtered and opening up.
- b8: the drop, with drums, bass, piano, plucks and the organ's phrase.
- b16: strings and brass come in.
- b24: plucks return, and the kit's own FX riser climbs into b32.
- b32: everything.
- b40: the drums drop out for the breakdown, and the filter closes.
- b48: the hit, and the kit comes back for one breath under the lockup.

**Effects** (each has a cause on screen):
- a C and G bell dyad on the solid version;
- a pop for the prompt chip;
- one Kenney key per typed character, and the ENTER key on the drop;
- a pop and a bell for the memory chip;
- the lock clack on 401, the unlock click and a pop on 200;
- ten soft clicks as the card is cut;
- nine descending C-major-pentatonic pops as the squares fall away;
- a low bell on the carve;
- a C and E bell dyad, plus the chip click, on the lockup.

There is a felt thump exactly twice, on ENTER and on the lockup, and no whooshes.

**Master:** two-pass loudnorm to -14.0 LUFS and -1.0 dBTP.

## Build

```
./make.sh                                                 # cat lib timeline film main > render.swift; swiftc -O
SCALE=1 SUBFRAMES=1 ./render stills 0 0.74 1.11 ...       # stills/t_*.png + stills/sheet.png
./make_audio_loops.sh                                     # audio/master_riseup.wav
./parts/run.sh                                            # 4K master, 1080 cut, muxed (SUB=6 subframes, shutter 0.5)
./qa/run_qa.sh                                            # format, frames, hold, motion, pops, loudness, colour, contact sheet
```

## QA

Run on the delivered files, 2026-10-14 (`qa/run_qa.sh`):

| Check | Result |
|---|---|
| Format | 3840x2160 and 1920x1080, H.264 High, 60fps, bt709 tv range, AAC 256k 48kHz |
| Length | 19.85s, 1191 frames |
| Held end card | 75 frames (1.25s), 1 unique md5 in both the 4K and the 1080 cut |
| Motion (pack metric) | 78.5% moving |
| Stills before the end card | 0.57s at 5.13s, 0.50s at 15.93s and 0.60s at 16.47s, all under 1s |
| Pops (60fps, 3x both neighbours) | none |
| Loudness after the AAC mux | -14.2 LUFS, peak -1.2 dBFS, LRA 2.1 LU |
| Decoded field colour | `#0200F6` against `#0100F5` |
| Phone size (390px) | Captions, code, request and counter all read. The end-card command was 7px, so it went from 36 to 44px and its chip now matches the lockup's width (`qa/phone_end.png`). The HUD stays small |
| Bitrate | 4K 43 Mb/s (107 MB), 1080 14 Mb/s (35 MB). The dithered lattice is fine detail, so it costs bits |

The decoded contact sheet is `qa/contact.png`, and phone frames are `qa/phone_*.png`. Both are on the Mac only, because PNGs are ignored.

## Deviations

- **Length:** 19.85s, under her 20s cap. The changelog recipe suggests about 75s, but she asked for 20.
- **Legibility:** the HUD label (`supermemory local v0.0.9`, 28 and 34px) is small at 390px phone width; it is framing, not content. Captions are 68px, code 46px, and the terminal 50px.
- **Format:** 16:9 only, with no 9:16 cut and no voiceover.

## Score v2 (2026-10-14): three versions in the Don Toliver lane

**Her note on the Rise Up score:** "i think we can make the song better beats from some don toliver song but dont make it same like before and make the overall sounds betetr".

**The rule:** never his song, melody or voice (copyright and mute risk), so I built originals in that lane: hazy melodic trap, 808s with glides, rolling hats, washed pads, a muffled intro, half-beat silences before the drops.

**The source:**
- GarageBand's recorded Apple Loops, not code-made music, which she had rejected before.
- `prep_loops.py` stretches each loop to exactly 81 BPM (at most 1.3%, keeping pitch, with a seam-free loop point).
- It also measures each beat's kicks and snares.

**Three versions, mixed in `score_v2.swift`** (`KIT=legend|trap|sympathy ./make_audio_v2.sh`):

| Version | Key | Parts | Character |
|---|---|---|---|
| `legend` | C minor | Legend beat, sub bass, dark pad, FX pad, drone, lead | Dark and spacey, the closest to the Cactus Jack sound |
| `trap` | C minor | Legend harmony on the Sophistication beat (the most hat rolls in the library: 41 per loop), plus an 808 on every kick, gliding C2 to Ab1 where the bass moves | Hardest, 808-forward |
| `sympathy` | E minor | Sympathy beat, bass, piano, synth and lead, with the Caution beat's hat rolls in the full section | Melodic R&B |

**Arrangement, shared by all three:**
- A hazy intro with the beat muffled under it, 8 dB below the drop.
- Half a beat of silence, then ENTER alone, then the drop on b8.
- Into b32, the kick is filtered out of the beat for two beats while a riser climbs.
- From b40, the drums drop out and the music closes down.
- Another half-beat of silence, then the lockup hit on b48.
- The effects are tuned to each key: the bells, the pops, and the falling-squares run in minor pentatonic.

**What "sounds better" means in the mix:**
- **Bass and 808:** saturated so phone and laptop speakers can hear them through the harmonics. The Legend sub sits at 26 to 33 Hz, which those speakers cannot play.
- **Drums:** parallel compression, with an EQ cut of the mud and some air on top.
- **Music bus:**
  - high-passed out of the bass's way, with a 320 Hz dip;
  - widened (mid/side 1.35);
  - side-chained to the measured kicks.
- **Sends:** a dotted-eighth ping-pong delay and a hall on the lead.
- **Bus:** glue compression, then soft saturation, then a limiter, then two-pass loudnorm.

**Measured** (I can't hear it, so nobody has auditioned it):

| Version | <120 Hz | 120-400 | 400-2k | 2-8k | >8k | Crest | After AAC |
|---|---|---|---|---|---|---|---|
| Rise Up (v1) | -5.4 | -4.9 | -5.4 | -12.7 | -14.1 | 15.2 dB | -14.2 LUFS |
| legend | -2.8 | -7.0 | -9.9 | -9.5 | -12.9 | 13.3 dB | -14.3 LUFS, peak -1.0 |
| trap | -1.3 | -10.3 | -12.7 | -12.3 | -14.2 | 12.5 dB | -14.2 LUFS, peak -1.6 |
| sympathy | -1.6 | -8.2 | -11.2 | -13.0 | -15.2 | 12.2 dB | -14.1 LUFS, peak -2.4 |

Band columns are each band's share of the total energy, in dB.

- The first pass was 15 dB too sub-heavy, the trap I warned about in lessons, and was rebalanced.
- Effects peak 5 to 16 dB over the music around them.
- Both silences measure -48 to -70 dB.

**Files:** `../local-v009-1080-{legend,trap,sympathy}.mp4` are the same picture with each score.

**Once she picks:** re-render the picture with that beat's measured hits, then make the 4K and 1080 masters. Legend and trap already kick on b11, b19 and b27, where the small events land; sympathy's groove differs.
