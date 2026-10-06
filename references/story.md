# Story template for explainers

Her current rule: **explain the problem first.** The viewer should know what is being solved, and feel it, before any mechanism or product appears.

**Sources:** her direction of 2026-10-05; the pack's story rules (`reference/feedback-rules.md` "Story", `skills/voice-and-copy` section 1 on Dhravya's method); the memory-graph v3 lesson that full plain sentences read better for her than short display lines; the shipped mcp-upload explainer (`/Users/muskan/supermemory/reports/videos/mcp-upload-src/README.md`).

---

## 1. Rules for the story

- **One mechanism, proved.** Not five asserted ones. A cut that tried to carry seven captions and five mechanisms was rebuilt (brief 24).
- **Dhravya's order:** a moment or person, then an analogy, then the mechanism, then a hard number. He uses numbers to back up an argument, never to open one. So the hook is the problem, and the number comes second.
- **One statement per beat.** One sentence: subject, verb, what you can see happen. Full plain sentences, not 2 to 4 word slogans.
- **Key words in full ink, the rest at ink 45%** (the site's statement style). One to three key words per statement. At most one word in the whole film goes blue, and only the word that names the proof (mcp-upload used blue only on the direct lane and the word "never").
- **Technical words exactly as in the docs** (containerTag, updates, extends, derives, dreamingStatus). Product names lowercase.
- **Never before its subject.** A statement appears only once the thing it describes is on screen. It never counts something the screen does not show.
- **The thesis once, at the end.** Do not preview it.
- **The tweet and the video agree.** If they disagree, fix the video.
- **No not-X-but-Y lines.** Her voice rules ban positive-negative restatement. The site uses it ("not just the kind that tops a benchmark"). Do not copy that construction.

---

## 2. The 16:9 explainer (about 36s, 1920x1080, 60fps)

On a 120 BPM grid (0.5s beats) this is 72 beats. Every statement holds 2.5s or more. The figure moves on every beat underneath.

| # | Section label | Time | Statement does | Figure does | Survivor into next |
|---|---|---|---|---|---|
| 01 | `01 · THE PROBLEM` | 0.0-4.0 | names the problem as something the viewer has felt | frame 0 is composed and already shows the situation; motion from frame 1 | the object that fails |
| 02 | `02 · WHY IT MATTERS` | 4.0-8.5 | gives one number and its condition | characters stream and collapse into a counter, it lands, 0.5s pause; a mono source line sits under it | the counter box |
| 03 | `03 · THE OLD WAY` | 8.5-14.0 | says how it is done today and where it breaks | ink and grey only, no blue; a line breaks or a pile grows | the broken end or the pile |
| 04 | `04 · THE TURN` | 14.0-17.0 | names supermemory and the idea in one line | flood and shrink; the first blue | the blue tile |
| 05 to 07 | `05 · HOW IT WORKS` | 17.0-29.0 | one step per statement, 3 or 4 steps | state morphs, a map unfold, a heal; camera pushes on each step | the proved element |
| 08 | `06 · WHAT YOU SEE` | 29.0-32.5 | what the user or the model actually gets | the receipt, the injected context, the answer; a real capture if it is product UI | the proved element |
| 09 | none, or keep `06` | 32.5-35.0 | the thesis, thesis register | everything else clears; the survivor holds and drifts | the survivor |
| 10 | none | 35.0-37.0 | none | the survivor expands into the lockup; still from about 35.8s | |

Lengths: **25 to 26s max for 16:9 explainers** (her cap, 2026-10-05; the 36.8s v2 was too long). The 36s template above compresses by merging statements, see the mcp-upload v3 beat table in `/Users/muskan/supermemory/reports/videos/mcp-upload-16x9-src/README.md`. Older guidance said 30 to 40s. Her smfs v4 cut (27.5s) and memory-graph v3 (20s) are on the short side; the X benchmark's explainer-length references run 26 to 40s (pack `reference/x-motion-benchmark.md`).

**Chapter progress.** The bottom rule has one segment per section label. The active segment fills with time in ink. Blue stays reserved for the proof.

---

## 3. The square social cut (15 to 25s, 1080x1080, 60fps)

Re-frame from the same timeline and the same facts. Never letterbox the 16:9 film.

| # | Time | Statement does | Figure does |
|---|---|---|---|
| 01 | 0.0-3.0 | the problem | frame 0 composed |
| 02 | 3.0-6.0 | the number, or the old way breaking | counter lands, or the line breaks |
| 03 | 6.0-8.5 | the turn, naming supermemory | flood and shrink, first blue |
| 04 to 05 | 8.5-14.0 | the new way in two steps | morphs, camera pushes |
| 06 | 14.0-17.0 | what you see, or the thesis | the proved element |
| 07 | 17.0-20.0 | none | expands into the lockup; still 1.2 to 2s |

Square layout follows the pack's square grammar: statements in a bottom band with a fixed first-line baseline, 96px gutters, statements 44 to 56px, labels 26px or more, checked at 360px wide. The 16:9 type sizes do not carry over directly. Memory-graph v3 found 16:9 needs about 1.5x the square sizes, because 16:9 shows smaller in feeds.

---

## 4. Worked example: the mcp-upload explainer (shipped 2026-10-05)

`reports/videos/mcp-upload-explainer.mp4`, 1080x1080, 60fps, 24.8s, silent. Mapped onto the template:

| Template slot | What it said | Figure |
|---|---|---|
| problem | "many mcp tools make the model / type your file out as text" | real base64 scrolls from report.pdf up into the model |
| why it matters | "as base64, a 5 mb pdf is / 6.7 million characters" | counter climbs to 6,666,668 and lands |
| turn | "supermemory opens a small app / inside the chat instead" | the stream clears, "app · sandboxed" arrives, the file moves into it |
| new way 1 | "the app gets a one-time ticket / that expires in 2 minutes" | a ticket travels and clips onto the file, countdown starts |
| new way 2 | "your browser sends the file / straight to supermemory" | first blue: the direct lane draws; the file rides it |
| what you see | "the model only gets a receipt" | the receipt rises to the model |
| thesis | "the file never passes through the model" | stage clears, thesis, lockup, 1.6s still |

Its README lists the source for every claim (the MCP working-group charter, RFC 4648, the MCP Apps spec, file and line references in `apps/mcp`). Do the same.

What a 16:9 version would change under the current direction: the statements move into the text column with section labels; the figure moves to the stage; the problem beat gets its own "old way" step; the camera pushes on each step. Note also that its own README claims 72% moving, but the pack's metric measures 31% on that file (see `qa.md` section 2.3), so a re-cut needs much more large-area motion.

---

## 5. Story checks before any rendering

- [ ] Is the problem on screen before supermemory is named?
- [ ] Is there exactly one mechanism, and is it proved on screen, not only stated?
- [ ] Does every number have a source written next to it, with the date checked?
- [ ] Would a muted viewer follow it from the figure alone? (brief 24: "watch it cold with sound off")
- [ ] Does each statement describe something already on screen?
- [ ] Does the thesis appear exactly once?
- [ ] Does the tweet say the same thing?
- [ ] Are there any claim landmines? Check section 1 of `/Users/muskan/supermemory/.claude/reference/dhravya-explainer-research.md`, and never imply weight updates.
