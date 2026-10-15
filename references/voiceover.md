# Voiceover films (built Oct 14, 2026: console series part 1)

For any film with a spoken explainer. Her notes: "we gotta make them have voice explainer as well", then "bella's voice is nice, just make sure you make it super crisp, polished and smooth, there should be no latency", then "i meant the latency should be perfect" (lessons #93). The worked example is `engine/voiceover-film/`, from `~/personal-supermemory/reports/videos/console-part1-src/`.

## The voice

**Kokoro-82M** (Apache-2.0) via `kokoro-onnx`, local and free, with no account. Voice `af_bella` is her pick.
- **Location:** `~/personal-supermemory/tools/kokoro/` (`tts.py` and `tts_timed.py`). The models (about 350 MB) were downloaded with her OK on Oct 14. They are not in git.
- **Never clone a real person's voice.**
- **Spell out letters** the model would read as a word: "P N P M", "M C P", "U R L", "C L I".
- **Exact timings:** Kokoro computes per-phoneme durations but doesn't output them. `expose_duration.py` copies the graph with that tensor exposed. The audio is bit-identical to the stock model.

## Timing spec (from a 3-lane research run, 89 sourced findings)

| Item | Research range | Use |
|---|---|---|
| Comma where the read pauses | 200-500 ms (about half of commas get no pause) | 200-300 ms. Leave run-through commas alone unless they separate steps |
| List comma | may be silent | 200 ms (the audible floor) |
| Sentence stop inside a line | 500-750 ms | 500 ms |
| Question | as a sentence | 550 ms |
| Line gap inside a scene | 600-750 ms | 600 ms |
| Line gap at a scene change | 833-1400 ms | 800 ms (the tight end, for pace) |
| Before the payoff line | 1000-1400 ms | 1000 ms |
| Picture vs word | land 2 to 3 frames before the audible onset, never sound first | the frame at or before the onset, minus 2 frames |
| Click sound vs its visual | sharp onset 33-50 ms after contact | 2 frames (33 ms) after |

**Sources:**
- ITU-R BT.1359: detectability at +45 / -125 ms.
- EBU R37: 5 ms early / 15 ms late per stage.
- Heide and Maempel 2010: 105 listeners perceived sync at 39 to 45 ms of audio lag, and recommend 0 to 80 ms of lag with no lead.
- Conrey and Pisoni 2006; Vatakis and Spence 2006; Liu et al. and Strangert on pause lengths; Cardoen: pauses over 1.4s disrupt.

## How the picture keys to the voice

1. **Pause conform.** Each pause is measured as the quiet run around its punctuation (-40 dB under the line's loudest frame). It is cut or padded in its middle, never into sound, with 6 ms fades.
2. **Audible onsets, not phoneme times.**
   - After a pause, the onset is the first frame above the quiet line.
   - Inside connected speech, it is the strongest spectral rise near the phoneme start.
   - Onsets differ from the phoneme clock by -88 to +69 ms (median -19). For example, "Cursor" is heard 52 ms early and the P of pnpm 37 ms late.
3. **A word clock for the picture.** `audio/vo_build.py` writes `vo_times.swift` (every word's onset on the film clock, caption chunks, pauses). The film reads only from it, so after any script or voice change `make.sh` re-keys the whole picture.
4. **Ducking with look-ahead.**
   - The bed is keyed from the voice 80 ms early, so it is already down on the first syllable.
   - It holds 300 ms across pauses and releases over 450 ms.
   - It sits 19 LU under the voice while she speaks and 12 LU under it in gaps.
5. **Music grid.** Pick the bed's tempo so the big visual moments land on downbeats (Part 1: 15 bars at 91.4 BPM).
6. **Captions:** `captions.srt` is written from the final read, for LinkedIn and YouTube.

## QA for sync

Render a test with a one-frame flash and a click 2 frames later, through the same x264 + AAC mux as delivery, and measure the lag.
- Part 1 measured +33.3 ms with the edit list honoured (ffmpeg, browsers, QuickTime) and +54.7 ms with it ignored.
- Both are inside the perceived-sync window, and sound never leads.

**Known issue:** on a dithered film plate, the q=1 zone made the held end frames alternate by about 1 level. Next time, use an IDR at q=1 and then P-frames at a high QP, so they decode as exact skips.
