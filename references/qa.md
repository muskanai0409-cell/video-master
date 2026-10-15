# QA: what to check, with commands that run on this Mac

No numpy here, so every check below uses the bundled ffmpeg, awk, or the Swift renderer itself. Every command in section 2 was run on 2026-10-05 against `/Users/muskan/personal-supermemory/reports/videos/mcp-upload-explainer.mp4` (and, where noted, its renderer). Results from that run are quoted so you know what normal output looks like.

```bash
FF=/Applications/Cardboard.app/Contents/Resources/bin/ffmpeg
FP=/Applications/Cardboard.app/Contents/Resources/bin/ffprobe
V=/Users/muskan/personal-supermemory/reports/videos/<name>.mp4
```

"A render that exits 0 proves nothing" (claude-animation-skill, via code-motion-graphics). Look at pixels with the Read tool, then measure.

---

## 1. Before the full render

1. **One frame per beat.** Render a still at every beat time (0.5s apart at 120 BPM) with the engine's `stills` mode and read the contact sheet. Fix anything cramped, off-grid, overlapping or hard to read (rossaxbt). Also render the four key stills (open, turn, new way, end card) and show her.
2. **Mid-transition frames.** For every seam, render stills at -0.2, -0.1, 0, +0.1 and +0.2s around it. Rest states hide the bugs: half-built elements, text over text, cards crossing, clipping mid-zoom (pack `tools/handoff_check.py` samples -0.34, -0.22, -0.14 and 0s).
3. **The hardest 2 to 4 seconds.** Render every frame of it once and read a strip.
4. **Arithmetic.** Measure every statement's width against the text column and every stack against the stage, in the engine, before rendering. Flag each contradiction with numbers (pack `supermemory-explainers` section 8).
5. **Statements as data.** Captions and statements live in the timeline, so assert in code that at every frame at most one has alpha above 0, that each holds at least 2.5s (or the brief's floor), and that none starts before its subject's arrival time.

---

## 2. The decoded MP4

### 2.1 Format and colour tags

```bash
$FP -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,nb_frames,pix_fmt,color_space,color_primaries,color_transfer,color_range:format=duration -of default=nw=1 "$V"
```

Expect the spec's size, `r_frame_rate=60/1`, `nb_frames` equal to duration times fps, `pix_fmt=yuv420p`, `color_space`, `color_primaries` and `color_transfer` all `bt709`, `color_range=tv`. An untagged encode decoded `#0562ef` as `#065dff` (pack).

### 2.2 Sampled hex against the tokens

```bash
# one pixel at x:y, t seconds in
$FF -v error -ss 2.0 -i "$V" -frames:v 1 -vf "scale=in_color_matrix=bt709:in_range=tv:out_range=pc,format=rgb24,crop=1:1:20:20" -f rawvideo - | xxd -p
# the average of an 8x8 patch (safer)
$FF -v error -ss 2.0 -i "$V" -frames:v 1 -vf "scale=in_color_matrix=bt709:in_range=tv:out_range=pc,format=rgb24,crop=8:8:16:16,scale=1:1:flags=area" -f rawvideo - | xxd -p
```

On mcp-upload this gave `f3f3f5` for paper `#f4f4f6` and `fdfdfd` for white `#ffffff`. Accept 2 to 3 levels of drift on solid areas. Sample solid fills at least 8px across. Thin lines drift more because of 4:2:0 chroma: its 3px blue lane decoded as `#0460eb`. If every hex in a feedback note is a lightened version of a token (`#007af5`, `#fdfdfd`), she eyedropped a scaled preview. Fix the tagging, not the colours (pack).

### 2.3 Motion share and longest still (the pack's metric, without numpy)

```bash
$FF -v error -i "$V" -vf "fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=motion.txt" -f null -
# % moving and longest still before the end card (set ENDT to the end-card start; BSD awk rejects a variable named END)
awk -F= -v thr=0.15 -v fps=30 -v ENDT=20.4 '/YAVG/{n++; t=n/fps; if ($2<thr){run++; if (t<ENDT && run>best) best=run} else {mv++; run=0}} END{printf "moving %.1f%%  longest still before end card %.2fs\n", 100*mv/n, best/fps}' motion.txt
# list every still stretch of 1s or more
awk -F= -v thr=0.15 -v fps=30 '/YAVG/{n++; if ($2<thr){if(!run) st=n; run++} else {if (run/fps>=1) printf "still %.2f-%.2fs (%.2fs)\n", (st-1)/fps, n/fps, run/fps; run=0}} END{if (run/fps>=1) printf "still %.2f-end (%.2fs)\n", (st-1)/fps, run/fps}' motion.txt
```

This is the pack's `motion_density.py` method (30fps, 160x90 grey, a frame pair is still when its mean absolute difference is below 0.15 on a 0 to 255 scale). It was cross-checked against a Swift re-implementation: both gave a first value of 0.176042 and 31.4% moving on mcp-upload. So numbers from this command compare directly with the pack's X benchmark table.

**Targets (her current direction):** 60% or more moving, and no still stretch over about 1s before the end card. The pack's benchmark: top reels 80 to 100% moving, explainers 42 to 45%, smfs v3 and v4 27 to 29%.

**Measured on her recent cuts with this command:**

| Cut | Its README says | This metric |
|---|---|---|
| mcp-upload explainer (2026-10-05) | 72% moving, longest still 0.93s | 31.4% moving, longest still 2.83s (17.57 to 20.43s), stills of 1.27 to 2.07s at 8.13, 12.33 and 15.27s |
| memory-graph v3 (2026-10-02) | 59% moving, longest still 1.23s | 56.3% moving, longest still 1.60s (end card included) |

The metric only counts change over a sizable area of the frame (memory note on memory-graph). A small chip moving on paper reads as still. That matches what she reacts to: make big things move. Always say which metric you used.

### 2.4 Single-frame pops

A pop is a frame whose difference is about 3x its neighbours (rossaxbt, twoclipping). Measure at the native frame rate, because a one-frame pop at 60fps can vanish at 30fps sampling:

```bash
$FF -v error -i "$V" -vf "scale=320:180,format=gray,tblend=all_mode=difference,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=pops.txt" -f null -
awk -F= '/pts_time/{split($0,a,"pts_time:"); t=a[2]} /YAVG/{n++; d[n]=$2; tt[n]=t} END{for(i=2;i<n;i++){m=(d[i-1]>d[i+1]?d[i-1]:d[i+1]); if(d[i]>=0.5 && d[i]>3*m) printf "pop? %.3fs diff %.2f (neighbours %.2f, %.2f)\n", tt[i], d[i], d[i-1], d[i+1]}}' pops.txt
```

On mcp-upload this listed 6 candidates in 1487 frame pairs (for example 10.567s and 21.400s). They are candidates, not defects. Pull a strip at each and look. The pack warns that more than half of automatically flagged "defects" were the detector's fault. Expected pops: a statement or counter digit that appears in one frame. Fix those with a mask rise or a short arrival.

### 2.5 Still ending identical

```bash
# decoded: how many identical frames end the file
$FF -v error -i "$V" -f framemd5 - | grep -v '^#' | awk -F, '{h[NR]=$NF} END{n=NR; k=1; while(k<n && h[n-k]==h[n]) k++; printf "frames %d, trailing identical run %d frames\n", n, k}'
# source: where the renderer's final identical run starts (use it to place the x264 zone)
./render raw | $FF -v error -f rawvideo -pix_fmt bgra -s 1080x1080 -r 60 -i - -f framemd5 - | grep -v '^#' | awk -F, '{h[NR]=$NF} END{n=NR; k=1; while(k<n && h[n-k]==h[n]) k++; printf "source: %d frames, final identical run starts at frame %d (%d frames)\n", n, n-k, k}'
```

mcp-upload: the source run starts at frame 1379 (109 frames); the shipped file has 93 decoded-identical frames because its zone started at 1392. Starting the zone about 10 frames before the source run gave 110 (`pipelines.md` section 2). The decoded run must cover the brief's hold (1.2 to 2s, so 72 to 120 frames at 60fps).

### 2.6 Whole-film contact sheet

```bash
D=$($FP -v error -show_entries format=duration -of csv=p=0 "$V"); $FF -v error -y -i "$V" -vf "fps=24/$D,scale=480:-2,tile=6x4" -frames:v 1 sheet.png
```

The sample rate comes from the duration, so the 24 tiles span the whole file including the end card. A fixed fps with `-frames:v 1` silently drops the end (code-motion-graphics `qa.md`). Write each sheet to a new file name, because a cached image makes a fix look like it failed.

### 2.7 Phone size

```bash
$FF -v error -y -i "$V" -vf "select='lt(abs(t-2.5)\,0.009)+lt(abs(t-7.4)\,0.009)+lt(abs(t-14.95)\,0.009)+lt(abs(t-23.0)\,0.009)',scale=390:-2,tile=4x1:padding=8:color=white" -fps_mode passthrough -frames:v 1 phone_sheet.png
```

Each tile is 390px wide, which is how a phone shows it. Include the busiest frame. Every statement, label and number must read. Squares: also check 360px (pack).

### 2.8 Statement changes and seams

```bash
T=10.2; $FF -v error -y -ss $(echo "$T-0.3" | bc) -t 0.6 -i "$V" -vf "fps=20,scale=480:-2,tile=6x2" -frames:v 1 strip_$T.png
```

One strip per statement change and per seam. Look for two statements on one frame, text over text, a lone half-built element, an empty frame.

### 2.9 Loudness (only when there is audio)

```bash
$FF -hide_banner -i "$V" -af ebur128=peak=true -f null - 2>&1 | tail -12
```

House target -16 LUFS integrated, true peak at or below -1 dBTP, measured after the AAC encode (pack `skills/sound-design`). You cannot hear the mix. Say so.

### 2.10 Copy

```bash
grep -n -P '\x{2014}|;' <beat-table-or-script.md>
```

Zero em dashes and zero semicolons in on-screen copy. Run it on the script or beat table, or on the statement strings only, because Swift source uses semicolons in code. Check "supermemory", "supermemory.ai" and "smfs" are lowercase everywhere, including label rows. Check every statement character by character against the brief.

---

## 3. Watch it

- Cold, muted, at phone size. The figure alone should tell the story (brief 24).
- Hand a **fresh critic subagent** the MP4 (it extracts its own frames), the brief, her own words and the previous critic report. Never your reasoning or your fix list. It marks earlier items FIXED, PARTLY or STILL PRESENT and ends with SHIP or ONE MORE PASS (code-motion-graphics section 5).
- Do not chase metrics. A version that hit every on-beat count still looked cramped (guizang, via code-motion-graphics). Never add meaningless wobble to pass the motion check.

---

## 4. Gate before showing her

- [ ] Every number has a written source; no weight-update claim; caveats on screen for about 3s
- [ ] Frame 0 is a composed thumbnail
- [ ] Format and bt709 tags correct (2.1); hex within 2 to 3 levels on solid areas (2.2)
- [ ] 60%+ moving, longest still about 1s or less before the end card (2.3)
- [ ] Pop candidates looked at (2.4)
- [ ] Final hold identical for the brief's duration (2.5)
- [ ] Contact sheet and phone sheet read (2.6, 2.7)
- [ ] Never two statements on a frame; each 2.5s+; strips read (1.5, 2.8)
- [ ] End card: official horizontal lockup, no debris
- [ ] Copy grep clean (2.10)

**Delivery note** (pack `reference/qa-checklist.md`): what changed and why, mapped to each note; every deviation from the brief with its arithmetic; what was measured, what you looked at, what nobody has listened to; what still needs her eyes; the busiest frame as a PNG.
