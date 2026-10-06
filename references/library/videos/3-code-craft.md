# Batch 3 · code craft: 35 entries, 34 unique videos

Sources: the per-video metrics JSON, 16-frame contact sheets with one exact frame at (k+0.5)·T/16 (T capped at 240s), 6-frame hook strips (0-2.5s) and 6-frame end strips (the last 4s). Audio was not heard; only presence and loudness are reported. For quoted clips, the view count is the quoting post's. #19 and #30 are the same file (byte-identical MP4, sheet and end strip), but their two metric runs disagree; the corrected sheet shows real clip switches after 23s, which supports #19's run. Cut counts are distorted in places: detection misses morphs and split screens (#8 reads 0 cuts) and over-counts stepped redraws (#2 reads 108.7/min).

### 1. @marina_uiux · product demo · 20.3s · ≈16:9 (1848×1080) · 2.25M views · [post](https://x.com/marina_uiux/status/2076410277109645741)
- **Hook (0-3s):** Frame 0 is a finished web page: a golden pagoda roof hangs over a curtain of tiny glyph strands, with a big serif headline at left. By ~1s the cursor enters the strands, and by 2.5s they swing into a sweeping arc behind it.
- **Beats:** the cursor drags through the China curtain and the strands swing and settle, with a moving cast shadow (0-5s) → a click on the right-hand thumbnail swaps the roof to a red Japanese eave as the headline rebuilds word by word with a blur-in (~6-8s) → the cursor plays through the new curtain (~8-11s) → a second click slides in a white Kazakh yurt from the right with its own headline (~12-16s) → the page pulls back into a horizontal row of every roof (a boat-shaped roof, the pagoda, the eave, the yurt, a red gabled roof), each with its curtain, panning left while the cursor keeps dragging strands (~16-20s).
- **Ending:** No card. It stops mid-pan on the pulled-back row of roofs with the cursor still in a curtain; there is no hold.
- **Look:**
  - ground: warm beige paper with long, soft drop shadows;
  - palette: beige, ink brown, and gold, red and white roofs;
  - type: large old-style serif headline in sentence case, stacked left; tiny mono body copy; per-word blur-in on each swap;
  - fills: rendered 3D roofs plus code-driven glyph strands on a work-in-progress site;
  - camera: static screen recording, though the page itself pulls back and pans at the end;
  - transitions: in-place swaps of roof and copy, then a pull-back into a scrolling overview row, with no cuts.
- **Made with:** Not stated; the post calls these work-in-progress design experiments.
- **Measured:** moving 91.0%, longest still 0.7s, 0 cuts/min (one 20.4s take), loudness -30.3 LUFS.
- **Why it works:** The text itself is the physical material, so one cursor pass produces rich, believable motion (rope physics plus a moving shadow), and the closing pull-back reveals the system: one curtain per destination.
- **Borrow:** Spring or verlet strands made of glyphs that part around a moving cursor or camera, a per-word blur-in for copy swaps, and a closing pull-back from one item to the row of all items. **Don't copy:** the roof renders, the beige palette or the page layout.

### 2. @kevin_t_ngo · explainer · 27s · 1:1 · 1.16M views · [post](https://x.com/kevin_t_ngo/status/2099858454043349342)
- **Hook (0-3s):** Frame 0 is a cross-hatched, colored-pencil fruit fly on an orange. At ~1s a black ink scribble eats its abdomen and floods the frame navy. By 2.5s a white-line egg diagram draws on, with nuclei dividing.
- **Beats:** fly on fruit (0-1s) → egg blueprint: nuclei divide beside a branching count diagram, a cell layer forms, green segment stripes appear (~2.5-6s) → larva in food (~7.6s) → brown pupa on navy with radiating lines (~9.3s) → adult on fruit (~11s) → compound-eye mosaic of a flower (~12.7s) → brain wiring diagram (~14.4s) → fly on a kitchen floor, then red target arcs on a table (~16-18s) → courtship on fruit under a sunset window (~19-21s) → egg-laying while tally marks in the corner count the days and the window flips from day to night (~22-24s) → a fly on a leaf beside a droplet that reflects the window (~24.5-25.5s) → the navy egg blueprint again (~26s).
- **Ending:** A loop. The final ~1.5s return to the egg blueprint from ~2.5s, with a small handwritten "opus" signature bottom-right, and then the lines fade to dark in the last half-second.
- **Look:**
  - ground: warm cream and orange scenes alternate with dark navy "lab" plates;
  - palette: orange, cream, red eyes, navy, pale-blue linework, green and pink accents;
  - type: none, apart from tally marks and the tiny "opus" signature at the end;
  - fills: illustration drawn entirely in code, with hatching and stipple;
  - camera: mostly static compositions with slight drift;
  - transitions: an ink-scribble wipe; hard cuts between the two registers; a closing fade.
- **Made with:** The post says Claude Opus 5 drew every frame in JavaScript.
- **Measured:** moving 69.9%, longest still 0.13s, 108.7 cuts/min (median shot 0.17s), loudness -12.7 LUFS (the loudest in the batch). Clusters of detected cuts two frames apart (~14-16s, ~23-24s), likely stepped redraws or strobing, inflate the count. The sheet shows about 14 distinct scenes, roughly one every 2s.
- **Why it works:** A life cycle is a ready-made arc that loops, and the two registers show the outside (the fly's world) and the inside (cells, eye, brain) of one subject.
- **Borrow:** A two-register system (a scene view and a blueprint view of the same thing, alternating every 1-2s), tally marks with a day/night flip to show time passing, an ink-scribble wipe, and hand-made hatching that hides the code look. **Don't copy:** the fly drawings or the orange/navy palette.

### 3. @Bencera · other (doc episode) · 895s · 16:9 4K · 507K views · [post](https://x.com/Bencera/status/2086855424318337191)
- **Hook (0-3s):** Frame 0 is a wide two-person interview in a dim room, framed inside a rounded old-TV vignette with a yellow italic subtitle. By 1-1.5s podcast and video-call clips slide in as overlapping cards. By 2.5s a guest is talking in the same rounded frame.
- **Beats (first 240s):** founder at a desk by a window (~7s) → street poster (~22s) → night freeway (~37s) → back at the desk (~52s) → dark living room (~67s) → white insert of an iPhone app demo (~82s) → brick loft titled "0 users" (~97s) → founder on the phone, then walking outside (~112-127s) → restaurant with a place-name card (~142s) → food close-up (~157s) → night work (~172s) → LA freeway at dusk (~187s) → Paris facade titled "100 paying users" (~202s) → sofa interview (~217s), with a chapter label appearing (~232s).
- **Ending:** No card. The full 15-minute file ends on the founder outdoors by the water, delivering a closing line in yellow subtitles, then cuts to black for well under a second.
- **Look:**
  - ground: real locations in warm natural light;
  - palette: warm filmic grade, with titles in golden yellow;
  - type: yellow italic sans subtitles; milestone, place and chapter titles in a condensed yellow serif with a soft shadow, placed in the scene;
  - fills: documentary footage with a few screen inserts;
  - camera: handheld or gimbal, plus a locked-off interview;
  - transitions: hard cuts, with a fast montage burst around 56-65s (cuts every 0.3-0.5s).
- **Made with:** Not stated for the video. The post says he used 10+ growth techniques to reach 10,000 paying customers, that starting a YouTube channel was the biggest lever, and that this is episode 4.
- **Measured (first 240s):** moving 72.7%, longest still 2.67s, 30.8 cuts/min (median shot 1.21s), loudness -19.3 LUFS.
- **Why it works:** Progress shows as numbers placed in real places ("0 users" in an empty loft, "100 paying users" over a landmark), which gives a vlog a scoreboard.
- **Borrow:** Milestone counters as in-scene chapter titles, and a stacked press-clip cold open that delivers social proof in 1.5s. **Don't copy:** the footage, the rounded-TV frame or the yellow serif styling.

### 4. @willyhopps · launch film · 90s · 4:3 · 365K views · [post](https://x.com/willyhopps/status/2085033689973711030)
- **Hook (0-3s):** Frame 0 is a woman at a desk at night, shot on a dutch angle. At ~1.4s it cuts to "Video Ideas" in crayon on cardboard with a fast pan. By 2.5s a pencil storyboard grid.
- **Beats:** storyboard sketches (~3s) → the macOS spinning wheel alone on black, the "stuck" beat (~8s) → eye macro (~14s) → laptop editor showing a title for a fictional skate brand (~20s) → a cluttered desk, a child painting on the floor, a hand in a paint bowl (~25-37s) → an eye through glasses, the woman at a window, dancing in the street at golden hour (~42-54s) → abstract ceiling projection (~59s) → couple in an elevator with UI selection boxes tracking them (~65s) → macro of a prompt being typed, with a live caret (~70s) → editor canvas tiling the video into size variants with an orange size badge (~76s) → woman and child at a laptop (~82s) → dark end (~87s).
- **Ending:** Credits and a lockup. A small red title word ("move") on black fades out, a two-column credits block and a cast list follow, and a small "osmo.inc" wordmark holds for under a second at the very end.
- **Look:**
  - ground: dark interiors and golden exteriors;
  - palette: teal-and-amber film grade, a red cardigan, one orange UI badge;
  - type: mostly in-world (crayon, screen text), then small credits type at the end;
  - fills: live-action footage, with product UI only as screen macros and overlay boxes;
  - camera: handheld, dutch angles, macro inserts;
  - transitions: hard cuts, plus a strobe burst at ~15-17s (cuts every three frames).
- **Made with:** Not stated for the film. The post launches Osmo (editable motion from Figma, code and reference videos) with a $5M seed and says the founder left A24.
- **Measured:** moving 79.5%, longest still 0.4s, 34.0 cuts/min (median shot 1.12s), loudness -14.6 LUFS.
- **Why it works:** It sells being stuck and then unstuck (the spinner, then dancing) before any UI appears, so the product moments land as relief, and the credits frame it as a film rather than an ad.
- **Borrow:** A universal "stuck" symbol (the OS spinner) as the problem beat, and product UI as huge macro inserts with a live caret. **Don't copy:** the footage or the A24-style grade.

### 5. @deedydas · launch film · 26s · 16:9 · 347K views · [post](https://x.com/deedydas/status/2102787937482252537)
- **Hook (0-3s):** Frame 0 types a request ("Summarize the q…") into a prompt pill. By 1s a "Thinking..." spinner sits over skeleton lines with a mono waiting timer at 0.36s. The timer reads 5.54s at 2.5s.
- **Beats:** the wait (0-4s) → flash cuts to a full-bleed violet card, "WASTE." (~4-4.5s) → a headline saying most of inference is waiting, over a GPU-grid heatmap with utilization climbing from 31% to 49% (~5.7-7.3s) → "Not anymore." as the grid dissolves to dots (~9s) → pastel token pills stream behind a stats card counting tok/s up (3,347 → 12,451) and first-token ms down (89 → 38) (~10.6-12.2s) → the name "muda" in light serif with huge pale kanji and a brush circle, then a dictionary card (it is Japanese for waste) (~13.8-15.5s) → the claim builds word by word, with a violet italic second line (~17-20.4s) → wordmark and tagline on a pastel diagonal gradient (~22s) → a receipt (~23.6s) → a small wordmark (~25s).
- **Ending:** A receipt, then the mark. After the logo card (~22-23.5s), a receipt compares "THIS FILM 26.000 s" with "YOUR ANSWER 0.038 s" and adds a line saying the answer was done before the logo was. Then a small centered wordmark with "done." holds about 1s.
- **Look:**
  - ground: white with light-gray UI, plus one violet full-bleed card;
  - palette: ink navy, saturated violet, pastel token pills, a peach-violet gradient;
  - type: heavy, tight grotesk headlines; a light serif for the name; mono counters; corner HUD chrome on every frame (film title, section name such as "THE WAIT", timecode, and a resolution/fps/BPM readout); word-by-word builds;
  - fills: rebuilt UI and data fields;
  - camera: static, with gentle pushes;
  - transitions: flash hard cuts, dissolves, and a grid that dissolves into dots.
- **Made with:** The post says Opus 5.5 made it in about a minute for about $2, and argues that code-made video explains technical ideas better than photoreal generators do.
- **Measured:** moving 41.6%, longest still 1.4s, 4.6 cuts/min (median shot 4.0s), loudness -19.5 LUFS.
- **Why it works:** You wait along with the timer before one word names the feeling, the brand name's meaning (waste) is the claim, and the closing receipt turns the film's own length into the proof.
- **Borrow:** A count-up latency timer as a 2s hook, one saturated full-bleed word card as punctuation, HUD chrome that labels each section, counters in a card floating over a live data field, and a closing receipt that measures something against the film's own runtime. **Don't copy:** the violet/pastel palette or the kanji treatment.

### 6. @sab8a · product demo · 60.2s · 1:1 · 338K views · [post](https://x.com/sab8a/status/2104627757766578399)
- **Hook (0-3s):** Frame 0 is a full-width talking-head clip with a giant red play logo behind the speaker. By 0.5s the clip shrinks into a card at right as "UNTIL" appears at left. By 1-2s it reads "UNTIL TODAY," and then "Claude made this", next to restyled variants of the clip. At 2.5s a blue variant appears with a big "2". Captions run word by word underneath.
- **Beats:** variants of one clip (0-6s) → a cream card, "NOT ANYMORE.", in black and red heavy caps (~9.4s) → the frame explodes into 3D layers linked by hairlines to a list (caption, cut-out, glyphs, arrow, music, footage), with selected layers outlined in lime (~13-17s) → screen recording of a browser video editor (~20.7-24.5s) → terminal with a highlighted command (~28s) → a lime result card with a "Done." sticker (~32s) → "HOW?" over a wall of code (~35.8s) → engine file grid (~39.5s) → a render card with frame thumbnails (~43.3s) → a skill file branching to tool names (~47s) → a node chain ending on a login node (~51s) → a lime end card (~54.6s) → this video opened in the editor (~58.4s).
- **Ending:** A recursive CTA. A lime end card (logo, a "powered by VEED" mark and a one-line description) appears at ~54-56s. Then this very video opens in the VEED editor with a "this video · in VEED" badge while "Open it in VEED" assembles over its exploded layers. The caption ends on "one." and the headline holds about 1.5s.
- **Look:**
  - ground: near-black, with cream and lime cards;
  - palette: black, lime, red, lilac;
  - type: heavy condensed grotesk caps with italic serif accents; bold sans captions, with the keyword in italic and a lime underline;
  - fills: a fixed three-band square (lockup header, stage, caption strip), with rebuilt cards plus screen recordings;
  - camera: 3D tilt for the exploded stack, otherwise static;
  - transitions: a full-bleed-to-card scale-down, plus hard cuts.
- **Made with:** The post says they built Open Edit, an open-source agent that turns Opus 5.5 videos into editable browser projects.
- **Measured:** moving 64.1%, longest still 0.8s, 10.0 cuts/min (median shot 3.07s), loudness -14.5 LUFS.
- **Why it works:** The exploded layer stack shows "editable" literally, the caption strip carries the story with the sound off, and the close proves the claim on the film itself.
- **Borrow:** An exploded z-layer teardown with hairline labels that highlights one layer at a time, the three-band square template for X, and an ending that opens the film itself in the product. **Don't copy:** the lime/black palette or the lockup header.

### 7. @MaxRovensky · product demo · 9.5s · 9:16 · 230K views · [post](https://x.com/MaxRovensky/status/2101319093592682959)
- **Hook (0-3s):** Frame 0 is a handheld phone shot of a man on a bench, looking at his laptop, which shows a blue window. At ~1.5-2s he turns his head away and the screen goes black.
- **Beats:** the screen is on while he looks at it (0-2s) → he looks away and it blacks out (~2-2.7s) → he looks back and it returns, briefly blurred (~3.3s) → the same cycle repeats about four more times as he turns between the laptop and the person filming (~3.9-9.3s).
- **Ending:** No card. It stops mid-cycle, as he looks back at the screen and it returns; there is no hold.
- **Look:**
  - ground: a street outside a shop window, in daylight;
  - palette: natural colour, a teal shirt;
  - type: none;
  - fills: real footage of the app in use;
  - camera: handheld, with roughly fixed framing over his shoulder;
  - transitions: none.
- **Made with:** Not stated; the post says he made this small privacy app a few days ago.
- **Measured:** moving 100%, longest still 0s, 0 cuts/min (one 9.6s take), loudness -26.3 LUFS.
- **Why it works:** His own gaze is the trigger: every glance away blanks the screen and every glance back restores it, so the feature repeats five times in 9.5s with no UI or caption.
- **Borrow:** Have the UI react to the subject's attention (look away: blank; look back: a blur-to-sharp restore), repeated on a rhythm. **Don't copy:** the footage.

### 8. @notdwd · launch film · 64.9s · 16:9 · 122K views · [post](https://x.com/notdwd/status/2103959324385300552)
- **Hook (0-3s):** Frame 0 shows two white panels, labeled "original" and "opus 5.5 copy", on light gray, each typing on a partner-logo lockup. By 1.5s a chat-style prompt box appears; by 2.5s the camera pushes into its input.
- **Beats (both panels in sync):** prompt box and cursor (~2-6s) → app icon tile (~6s) → a giant cropped @-mention typing into a zoomed input (~10s) → gradient-coloured phrases typed one after another (~14-18s) → scattered profile cards being analyzed (~22s) → a one-line value proposition (~26s) → chat windows and typing dots (~30-35s) → "Right here in ChatGPT" (~39s) → calendar with a dragged event (~47s) → logo on a node line (~51s) → an install-button click (~55s) → a giant cropped word with an arrow button (~59s) → logo end card (~63s).
- **Ending:** Logo and tagline. Both panels settle on a logo, with a tagline typed on word by word beneath it, held about 2.5s; there is no URL or CTA.
- **Look:**
  - ground: white cards on pale gray;
  - palette: one accent per brand (orange in the original, blue in the copy);
  - type: clean neutral sans with key words coloured; typing reveals; words pushed in until they crop off the frame;
  - fills: rebuilt UI;
  - camera: push-ins into fields and words;
  - transitions: cuts and zoom-throughs inside each panel.
- **Made with:** The post says Opus 5.5 rebuilt Gojiberry's launch video for his brand in 15 minutes, with the same motion and cuts, and that he is open-sourcing the prompt and process.
- **Measured:** moving 62.8%, longest still 2.8s, 0 cuts/min detected (median shot 64.94s; the side-by-side composite hides the cuts inside each panel), loudness -14.3 LUFS.
- **Why it works:** Playing both side by side in sync proves the copy is faithful, and white-UI grammar (typing, cursor clicks, push-ins) is exactly what code reproduces well.
- **Borrow:** The reference-remake method: transcribe a proven film's cut list and motion grammar, rebuild it with her brand, then check the result by rendering both side by side, in sync, with labels. **Don't copy:** either brand's palette, icons or copy.

### 9. @dabit3 · tutorial · 86.7s · 16:9 · 110K views · [post](https://x.com/dabit3/status/2104579506853785637)
- **Hook (0-3s):** Frame 0 is a small logo on white. At 0.5s the title builds word by word; by 1s it reads "Automating Tutorials with Devin", with a subtitle, and holds to 3s.
- **Beats:** app UI with a prompt being written and black pill callouts such as "Send it" (~8-14s) → the session and its plan doc, with callouts to approve it and find it under Automations (~19-30s) → the form path: "Prefer a form?" (~41s), "Give it a name" with typing (~41-46s), "Run it on a schedule" (~46s), a 7:00 daily time (~51.5s), a fresh session per run (~57s), instructions (~62s), picking the repository with @ (~68s) → "Save it" (~73s) → a callout that it now checks the changelog every morning (~79s) → end card (~84s).
- **Ending:** An end card with URLs. A last callout points at the "Run automation" button, the page shrinks into a card, and a white end card shows the logo, a one-line tagline and two URLs (app and docs), held about 2.4s.
- **Look:**
  - ground: white app UI;
  - palette: black, white and gray, with small accent icons;
  - type: black rounded pill callouts in white sans, imperative and 2-7 words long, placed beside the target;
  - fills: real UI recorded by the agent, with the account email masked with dots;
  - camera: auto zoom and pan to the active field;
  - transitions: none until the closing shrink; one continuous take with zooms.
- **Made with:** The post says a cloud agent with its own computer records itself using the app the way a human would, and that with Opus 5.5 the results beat his hand-made ones. Devin made this tutorial.
- **Measured:** moving 17.0%, longest still 4.23s, 0 cuts/min (one 86.8s take), loudness -18.1 LUFS.
- **Why it works:** Every step is one imperative callout plus a zoom onto the field, so it can be followed on mute, and it ends by telling you where to go.
- **Borrow:** Drive the zooms and callouts from a step list (time, target rectangle, 2-5 word imperative), mask personal data by default, and close with a shrink-to-card into a logo, tagline and URL. **Don't copy:** the pill style verbatim or the app UI.

### 10. @jake11moran · other (caption-effect demo) · 6s · 16:9 · 110K views · [post](https://x.com/jake11moran/status/2102544324445848031)
- **Hook (0-3s):** Frame 0 is a woman talking to camera in a warm library, with a small serif caption beside her. At 0.5s a huge italic serif "forget" appears behind her head (her hair hides the middle letters). By 2-2.5s the camera drifts and the word slides lower right, out of focus.
- **Beats:** the keyword behind her head (0-2s) → it settles lower right, out of focus (~2-2.5s) → a dark, soft shape wipes across the lens (~2.8-3.6s) → the next line curves in an arc around her chin (~4-4.4s) → a last line appears top-left as the arc fades (~4.4-5s) → the payoff word, a gold italic "feel", settles lower right, partly behind her (~5.1s).
- **Ending:** No card. The gold payoff word holds about 1s; it is the only colour change in the piece.
- **Look:**
  - ground: warm bokeh bookshelves;
  - palette: cream text on warm browns, with one gold word at the end;
  - type: classic serif; small roman running captions and giant italic keywords; text depth-sorted behind the subject; arc text;
  - fills: footage of a speaker (whether it is generated is unclear);
  - camera: slow drift with parallax and focus shifts;
  - transitions: a foreground occluder wipe.
- **Made with:** The post says a skill for a 3D camera and text effect is live, a HyperFrames community skill named camera-3d-captions. The earlier notes say it was made with Opus 5.5.
- **Measured:** moving 100%, longest still 0s, 0 cuts/min (one 6.1s take), loudness -22.9 LUFS.
- **Why it works:** The keyword lives in the room (behind the speaker, drifting in and out of focus), so the captions look filmed rather than pasted on, and the colour change marks the payoff.
- **Borrow:** A three-layer caption system: a small running caption near the subject, a giant keyword behind the subject (via a matte), and arc text, with an occluder wipe between phrases. Save the one accent colour for the payoff word. **Don't copy:** the footage or the serif pairing.

### 11. @jake11moran · talking head · 19.3s · 4:3 · 110K views · [post](https://x.com/jake11moran/status/2102544324445848031)
- **Hook (0-3s):** Frame 0 is a young man at a podcast mic in front of wooden shelves. At 0.5s a small white bold caption starts beside his head. By 1s a giant red "agent" sits behind him, his head hiding the middle letters. At 2.5s a giant red "whole job." sits behind him.
- **Beats:** red keywords behind him (0-3s) → a dark foreground occluder wipes in as red arc text ("Not a template,…") wraps around him, with the background racked soft (~4.2-5.4s) → white running captions (~6.6-7.9s), the next keyword out of focus (~9s) → "finished cut." giant behind him (~11.5s) → use cases on a curved baseline that rotates like a drum (~12.7-16.3s) → the product name, giant and red, behind his head (~17s).
- **Ending:** A name reveal plus a CTA. The product name sits giant and red behind his head with a small "is here." beside it, and the bottom caption reads "Give it your first prompt."; it holds about 2.4s.
- **Look:**
  - ground: warm wood shelving;
  - palette: white plus one red-orange;
  - type: bold grotesk; a small white running caption, a giant red keyword behind the subject, and ring and drum text;
  - fills: speaker footage;
  - camera: slow push and rack focus;
  - transitions: an occluder wipe; drum rotation with motion blur.
- **Made with:** Same post as #10 (the camera-3d-captions skill); this is the quoted original clip.
- **Measured:** moving 100%, longest still 0s, 0 cuts/min (one 19.3s take), loudness -15.9 LUFS.
- **Why it works:** One red keyword per sentence gives the viewer a skimmable spine, the drum lists use cases in one spot without a cut, and the close reuses the same system for the name and a one-line CTA.
- **Borrow:** A rotating word drum for lists, the hero word placed behind a UI card or object (z-order) instead of on top, and a closing name reveal with a single prompt-style CTA. **Don't copy:** the red-on-wood look or the footage.

### 12. @rossaxbt · launch film · 29.2s · 1:1 · 102K views · [post](https://x.com/rossaxbt/status/2106758817161597021)
- **Hook (0-3s):** Frame 0 is a wide, heavy lowercase wordmark, "develop.", with a small tagline on warm off-white. At 0.5s it smears right with motion blur; by ~0.9s it has collapsed into a small black dot at right, which stretches into a moving pill at 1s. At 1.5-2s the pill becomes a "Develop" button under the cursor, and at 2.5s the button turns into a circle showing a photo.
- **Beats:** photo iris (~2.7s) → a 3×3 grid of photo tiles (~4.6s) → one tile fills the frame, a stone arch on a hill with faint glassy letters in the sky (~6.4s) → push in as a liquid-glass toolbar rises and the cursor hits the adjust icon (~8.2s) → the toolbar morphs into a "Golden hour" slider, and dragging it regrades the photo to sunset (~10s) → the edited photo becomes a phone lock screen with a date and a big glass clock (~11.9s) → pull back to the phone floating on a blue swoosh (~13.7s) → the photo is dragged from the phone into a browser start page (~15.5s) → a shop page ("…to wall.") with the photo as a print (~17.4s) → product page with frame swatches, sizes, a price and "Order print", the cursor picking the largest size (~19.2s) → the order button becomes a "Printing 100%" bar (~21s) → the framed print on a wall with moving plant shadows (~22.9s) → hands hold it up (~24.7s) → push into the print (~26.5s) → the wordmark (~28.4s).
- **Ending:** A loop. After the print close-up, a black rounded container appears and smears into the "develop." wordmark with motion blur, and the wordmark and its tagline hold about 1.3s. This is identical to frame 0, so autoplay repeats seamlessly.
- **Look:**
  - ground: warm off-white, full-bleed photos, a blue swoosh backdrop, a plant-shadow wall;
  - palette: ink black and off-white, with colour coming only from the photos;
  - type: a wide, heavy grotesk wordmark and small UI sans for the toolbar, shop and print states;
  - fills: rebuilt UI (pill, toolbar, slider, lock screen, browser, shop page, print progress) over stills, plus the plant-shadow wall clip for the print;
  - camera: pushes into the photo and pull-backs to device shots;
  - transitions: one morph chain from wordmark to dot, pill, button, iris, grid, full-bleed photo, toolbar, slider, lock screen, phone, browser, shop page, print progress, framed print and back to the wordmark, with directional motion blur.
- **Made with:** The post says it cost $0 and is all code from Opus 5.5, with no external tools. Its prompt asks for a one-word verb as the brand name, 9-12 photos, a ~120 BPM royalty-free track with a drop and a breakdown, and a stock clip of plant shadows on a wall, under an Apple-keynote direction. The earlier notes add a 54-beat structure; iris, goo and liquid-glass recipes; seek(t) springs; SFX on peaks; and checking one frame per beat.
- **Measured:** moving 86.2%, longest still 1.03s, 0 cuts/min (one 29.3s take), loudness -14.2 LUFS.
- **Why it works:** Nothing resets: every element is the last one transformed. The story runs from screen to wall in one take (edit, lock screen, order, print, hang), so the tagline is proven rather than stated.
- **Borrow:** One container that carries the whole film; a UI control that rewrites the scene (the slider regrading the photo); following the object out of the screen into the physical world; and ending on frame 0 so it loops. **Don't copy:** the photos, the wordmark or the liquid-glass look.

### 13. @LexnLin · launch film · 33s · 16:9 · 96K views · [post](https://x.com/LexnLin/status/2104148233106723099)
- **Hook (0-3s):** Frame 0 is a big, soft red dot on white. By 0.5s it shrinks to a point, and by 1s it is the now-marker on a red calendar time line with a time badge. By 2-2.5s gray event chips and "Your week" fade in, with the second word blurring in.
- **Beats:** "Your week" among chips, some sharp and some depth-blurred (~3s) → the chips pile up and a huge black "doesn't fit." fills the bottom (~5s) → a hard cut (6.0s) to a black vignette with a white wordmark and a tile icon with a red dot, the tagline blurring in (~7s) → the wordmark collapses to the icon (~9s) → a blurred calendar behind a prompt bar being typed into (~11s) → the request ends with "Friday" as a token chip, and the cursor hits the red send button (~13.4s) → the full calendar app tilts in, rearranged with black deep-work blocks (~15.5-17.6s) → "Meetings move over." beside sliding event cards (~19.6s) → "Mornings stay yours." beside deep-work blocks marked "Protected" (~21.7s) → pull back to the whole app, then a tilted sea of weeks (~23.8-25.8s) → "Everything fits." (~27.9s) → the wordmark forms (~30s).
- **Ending:** Logo and URL, then a loop. "Everything fits." ends with the red dot as its full stop. The icon and wordmark assemble with "tessel.app" beneath (held about 1.5s), and then the mark shrinks back into the single red dot of frame 0.
- **Look:**
  - ground: white, with one black logo section;
  - palette: white, black and grays, plus one red;
  - type: bold neo-grotesk in tight sentence case; huge words cropped by the frame edge; per-word blur-in;
  - fills: a rebuilt calendar UI, logo, prompt bar and full app screens;
  - camera: static, with depth of field on the chips, a 3D tilt into the app, and pull-backs;
  - transitions: a dot-to-line morph, one hard cut to the black logo section at 6.0s, a collapse to the icon, a tilt into the app, a pull-back to a sea of weeks, and a collapse back to the dot.
- **Made with:** The post says Claude Code (Opus 5.5) made the name, logo, UI, animation, soundtrack and sound effects from one prompt in about 8 hours, all in code, and that the repo is open.
- **Measured:** moving 83.3%, longest still 1.0s, 1.8 cuts/min (median shot 27.05s), loudness -14.2 LUFS.
- **Why it works:** The red dot is the through-line (first frame, now-marker, logo dot, send button, final full stop), and the resolution line answers the problem line ("doesn't fit." → "Everything fits.").
- **Borrow:** One brand-coloured element that recurs as marker, logo, button and full stop; typed prompts with highlighted entity chips; and a resolution line that echoes the problem line. **Don't copy:** the made-up brand's name, logo or red-and-white calendar layout.

### 14. @gracewangdesign · product demo · 13.4s · ≈3:2 · 83K views · [post](https://x.com/gracewangdesign/status/2098506237901963620)
- **Hook (0-3s):** Frame 0 is her site as a floating card on a pale-blue gradient: an ink-wash penguin fishes from an ice floe, a handwritten note says to click when "!" appears, and her name sits below. By 1.5s the view zooms to the full page and a red "!" pops over the penguin, with a splash at the line.
- **Beats:** floating card (0-1.3s) → zoom to the full page as the red "!" bites, with a splash (~2s) → reel-in (~3s) → a small fact toast drops in at the top while the penguin holds the catch (~3.8s) → the line recasts in an arc (~4.6s) → idle (~5.5-7s) → a "the bucket" panel opens: a grid of 8 slots, with the caught item revealed, the rest locked, and hover tooltips such as "not yet caught" (~8-11.3s) → pull back to the floating card (~12.2s).
- **Ending:** A loop. It pulls back out to the floating card from frame 0, now with the bucket panel visible, and holds about 1.5s. There is no URL on screen (the link is in the post).
- **Look:**
  - ground: a white page on a pale-blue backdrop;
  - palette: ink-wash grays, one red "!", a small green icon;
  - type: light geometric sans for the name, a bold key phrase, a mono metadata row, and a handwritten note with an arrow;
  - fills: an illustrated live site;
  - camera: a zoom from floating card to full page, a pan to the bucket, and a pull-back to the card;
  - transitions: none beyond the zooms.
- **Made with:** Not stated; the post only says you can go fishing on her new portfolio site.
- **Measured:** moving 55.8%, longest still 1.3s, 0 cuts/min (one 13.4s take), no audio.
- **Why it works:** A tiny reward loop (wait, click, get a fact) makes a bio playable, the handwritten note explains the rule in one line, and the bucket turns the facts into a collection to complete.
- **Borrow:** A notification blip → click → fact card sequence as a recall beat, a collection grid with locked slots, and a zoom from floating card to full page that reverses at the end. **Don't copy:** the penguin or her layout.

### 15. @heysaik · product demo · 104.6s · ≈3:2 · 82K views · [post](https://x.com/heysaik/status/2105377008142463103)
- **Hook (0-3s):** Frame 0 is the finished site (photo, greeting, bio) in a browser on a blue desktop. By 1.5s the cursor hits reload. By 2-2.5s the page is blank and coloured cursor labels pairing a model name with a verb appear (for example "Gemini painting").
- **Beats:** labeled cursors paint a gradient strip across the top (~3s) → the greeting is drawn as outlines by an "outlining" cursor, and the nav is placed (~10s) → the photo frame is sketched in line while a "typing" cursor types the bio (~16s) → the photo is painted in (~23s) → scroll (~29s) → empty "signals" cards fill with live stats (local time, steps, heart rate, sleep, recent listening, photo count) (~36-56s) → a work-history section: the timeline line is drawn, then entries are typed in one by one with small company logos painted in (~62-101s) → the finished footer (~101s).
- **Ending:** No card. It ends on the finished page, whose footer carries a "Replay the build" link, then scrolls back up the work history; there is no hold.
- **Look:**
  - ground: a white page in a browser on a blue desktop;
  - palette: white, with coloured agent pills (pink, green, blue, red) and a rainbow strip;
  - type: clean geometric sans; cursor labels that pair a model name with a verb;
  - fills: the real site, screen-recorded;
  - camera: static, with page scrolls;
  - transitions: none; the page builds on progressively.
- **Made with:** The post says he made his site look as if agents were constructing it as you view it.
- **Measured:** moving 57.6%, longest still 1.73s, 0 cuts/min (one 104.6s take), loudness -61.7 LUFS (effectively silent).
- **Why it works:** Each model is a named cursor with a job, so a page load becomes a cast at work, the outline → paint → type stages show progress, and the footer's replay link makes the build itself the content.
- **Borrow:** Named agent cursors with verbs that build UI in stages (outline, fill, type), compressed to about 10s for a film, with a "replay the build" control as the closing beat. **Don't copy:** his page design, or the model-name labels as they are.

### 16. @tushaarmehtaa · tutorial · 135.4s · 16:9 4K · 81K views · [post](https://x.com/tushaarmehtaa/status/2068209228565918154)
- **Hook (0-3s):** Frame 0 is a dark one-page site (a skill list with red mono names) in a window on a purple-blue wallpaper, with a rounded-square facecam at right and a big white cursor. By 3s nothing has changed except the cursor and his talking.
- **Beats:** the site page while the cursor points at lines and at the install command (~4-47s) → switch to a terminal, invoking the skill from a selection menu (~55s) → the skill's output scrolls (~63-97s) → a numbered list of findings in coloured text (~106-131s), with a white URL caption flashing over it (~123s).
- **Ending:** No card. The last 4s hold on the static findings list with the facecam; the URL appeared about 12s earlier.
- **Look:**
  - ground: a dark page, then a dark terminal, on a gradient wallpaper;
  - palette: near-black, red mono accents, a blue-purple wallpaper;
  - type: small sans and mono, unreadable at phone size, plus one white URL caption;
  - fills: a real screen recording plus a facecam bubble;
  - camera: static;
  - transitions: one switch to the terminal (~55s) and a caption overlay.
- **Made with:** Not stated for the video. The post says he made a /remove-ai-slop skill that strips generic AI tells from design and copy, inspired by Emil's review skill and Cursor's code-quality skill.
- **Measured:** moving 13.4%, longest still 11.53s, 0 cuts/min (one 135.4s take), loudness -36.3 LUFS.
- **Why it works:** As motion it mostly doesn't. The skill is the payload, and the video is proof of a person running it.
- **Borrow:** A slop-removal pass in the pipeline before render, not the video style. **Don't copy:** the facecam-over-page layout.

### 17. @emilkowalski · product demo · 31.1s · ≈16:10 · 81K views · [post](https://x.com/tushaarmehtaa/status/2068209228565918154)
- **Hook (0-3s):** Frame 0 is Claude Code (light theme) on a lavender wallpaper, with "/revi" typed and the command menu open. By 0.5s /review-animations is chosen, and by 1s a modal component file is picked. By 2-2.5s the run starts and says it will read the modal's CSS module.
- **Beats:** it reads the component, the stylesheet and the skill's standards file (~1-7s) → it reports several feel-breaking issues (~8.7s) → Part 1, Before/After/Why findings (~10.7-12.6s) → Part 2, a verdict on regressions, performance and timing (~14.6s) → accessibility and "Decision: Block." (~16.5s) → the user scrolls back through the report (~18-28s) → the closing lines (~30s).
- **Ending:** No card. It ends on the agent's last lines: a tip to check the motion in slow motion at 25% in DevTools, and a question offering to apply the fixes, with "apply these fixes" suggested in the prompt. This holds about 3s.
- **Look:**
  - ground: a light terminal window on a lavender wallpaper;
  - palette: white, gray, blue links, an orange mascot;
  - type: small mono;
  - fills: a real terminal recording;
  - camera: static, with scrolling;
  - transitions: none.
- **Made with:** The clip shows Emil's /review-animations skill running in Claude Code (#16's post credits it as inspiration). Its legible findings, paraphrased: change the overlay's 400ms ease-in to about 200ms ease-out; stop transitioning "all" and animate only opacity and transform, with a strong ease-out; replace scale(0) with scale(0.95) plus opacity; turn the symmetric 400ms open and close into about 200ms in and 150ms out; stop hand-syncing a JS timeout to the CSS duration; and add reduced-motion handling that keeps the fade and drops the scale. The verdict blocks the change because ease-in on UI and scale(0) on an entering element are hard triggers.
- **Measured:** moving 9.9%, longest still 2.8s, 0 cuts/min (one 31.1s take), no audio.
- **Why it works:** The payload is a readable rubric with concrete numbers and a clear verdict, which rewards pausing.
- **Borrow:** The rubric as a QA pass for her motion (including a 25%-speed check), and the Before/After/Why format for her director-notes log. **Don't copy:** the terminal recording as a video format.

### 18. @gregpr07 · launch film · 18s · 16:9 · 58K views · [post](https://x.com/gregpr07/status/2102984873351037161)
- **Hook (0-3s):** Frame 0 is charcoal, with a white bold "So," and a tiny dot-and-bar level meter under it. By 1s a gray "um" fades in. At 1.5s it has stretched into "ummmmmmm", letter by letter, as the meter under it grows. At 2s the line scrolls left, and at 2.5s a fresh "Let's" appears.
- **Beats:** the stumbling take as kinetic type (0-3.7s) → talking head with one-word caps captions (~3.7-7.6s) → a push in for a one-word groan (~7.3s) → a reaction-meme insert (~8.4s) → a dark terminal card showing the prompt (13 takes: find the clean one, then cut, grade and caption it) and the steps (transcripts read, top three compared, winner picked, rendered, done in about 2 minutes) (~9.5-10.7s) → talking head again (~11.8-15.3s) → end card (~15.3s).
- **Ending:** An end card with a URL. On a dark card the wordmark assembles (its orange hyphen closing up), with "Edit videos by talking to Claude Code." and a GitHub URL in mono beneath, held about 2s.
- **Look:**
  - ground: charcoal, then a warm room, then a dark end card;
  - palette: white and gray, warm orange room light, one orange hyphen;
  - type: bold sans, with the filler word stretching letter by letter over a level meter; one-word caps captions; a mono terminal and URL;
  - fills: speaker footage, a rebuilt terminal card, a meme;
  - camera: static, with one push-in;
  - transitions: hard cuts.
- **Made with:** The post says Opus 5.5 with video-use read the transcripts of 13 takes, compared the top three frame by frame, picked the clean one, and cut, graded and captioned it, rewriting its own captions, in 2 minutes for 90 cents. It then built this launch video around it.
- **Measured:** moving 88.8%, longest still 0.7s, 13.3 cuts/min (median shot 3.67s), loudness -14.9 LUFS.
- **Why it works:** The failure is visible as type that stretches with the level meter, the terminal card is the receipt (steps and elapsed time), and the end card says exactly where to get it.
- **Borrow:** Transcript-driven kinetic type in which fillers stretch to the length of the speech over a level meter, a terminal receipt card with the prompt, steps and time, and a wordmark + one-line + repo URL end card. **Don't copy:** the meme insert or his footage.

### 19. @VadimStrizheus · product demo · 34.2s · ≈16:9 4K · 55K views · [post](https://x.com/VadimStrizheus/status/2093141495658201368)
- **Hook (0-3s):** Frame 0 is a near-empty dark chat app ("Clip Bot") with a cursor. By 1s a bot greeting appears; by 2.5s the user is typing. The text is unreadable at sheet size.
- **Beats:** a greeting and a request with a video link (~1-5s) → the bot connects a tool and starts a clip job, posting status messages (~7-14s) → it lists the finished clips with titles and shows thumbnails (~16-20s) → a clip viewer opens (~22s) and plays generated clips with two-line bold caps captions (one line white, one coloured green, red or yellow), a sponsor tag and a filmstrip of clips below (~24.5-33s).
- **Ending:** No card. After a few captioned clips it cuts back to the chat, showing the clip list and thumbnails, for about 1s.
- **Look:**
  - ground: a dark gray chat UI, then a dark clip viewer;
  - palette: gray bubbles and a purple bot avatar; the clips add bright caption colours;
  - type: tiny white UI text, then big two-line caps captions inside the clips;
  - fills: a raw 4K screen recording of the chat and the clip viewer;
  - camera: static, with no zoom;
  - transitions: cuts when the viewer opens and between clips (~23-33s).
- **Made with:** The post says his Grok bot installed the vugola MCP server and now downloads YouTube videos, reframes them into other ratios, adds hooks and captions, schedules posts and reads clip analytics.
- **Measured:** moving 23.9%, longest still 2.4s, 12.3 cuts/min (7 cuts, all after 23s; median shot 1.93s), no audio. The file is byte-identical to #30, whose run measured 3.7% and 0 cuts; the corrected sheet shows real clip switches after 23s, which supports this run.
- **Why it works:** The post's claim does most of the work. The second half finally shows output (captioned clips playing back), which is the only part legible at phone size.
- **Borrow:** Show the output, not the chat: open the result full-screen as soon as it exists. Note the clips' house style, two-line caps captions with one coloured line. **Don't copy:** raw full-screen chat recordings or the clips' footage.

### 20. @jake11moran · other (film breakdown) · 48.9s · 16:9 · 42K views · [post](https://x.com/jake11moran/status/2084382572898070964)
- **Hook (0-3s):** Frame 0 is pink-cream, with a green hill strip along the bottom. At 0.5s a cream film card drops in with a green timecode badge. At 1s a top label appears and the hill fills with section markers. At 1.5s a dark-green spiral notebook slides into the card, and by 2.5s its cover has flipped to lined pages.
- **Beats:** the launch film plays inside the card while a small character walks the hill as a playhead, past act tags for hook (0:00-0:03), problem (0:03-0:10), products (0:10-0:33), value (0:33-0:36), offer (0:36-0:41) and cta (0:41-0:46). Inside the card: notebook pages with handwriting (~1.5-10s) → a sticky note, "the numbers" (~14s) → a dark card, "the editor" (~17s) → tool postcards (~20-23s) → an envelope, "the builder" (~26s) → a checklist, "the brain" (~29s) → a postcard, "the tracker" (~32s) → a postcard grid (~35s) → a swinging lanyard pass (~38s) → the pass with a line that it all comes with the pass, plus price chips (~41s) → a CTA card (~44s).
- **Ending:** A CTA inside, then a blank. The film in the card ends on a CTA card: a logo, one line, a black "Get Product Pass →" button with the cursor on it, and small print below. Then the card wipes to blank and holds about 2.5s, with the playhead parked at "cta".
- **Look:**
  - ground: pink-cream paper and a stylized green landscape;
  - palette: cream, forest green, orange, muted postcard colours;
  - type: handwritten script captions (two-word roles), small caps labels, a timecode badge;
  - fills: code-built paper-craft illustration and props;
  - camera: static, with props entering and exiting in flight;
  - transitions: page flips, prop swaps and a closing wipe, with no cuts.
- **Made with:** The post says the whole video took 5 prompt iterations. The earlier notes, from his linked article, add Fable and website-to-hyperframes, an HTML storyboard of stills first, one continuous camera, no idle motion, scenes that exit and enter in flight, and 12fps stop-motion over a smooth camera.
- **Measured:** moving 26.7%, longest still 2.9s, 0 cuts/min (one 49s take), loudness -13.3 LUFS. The low moving % despite constant action fits 12fps held frames.
- **Why it works:** The breakdown makes the act structure and its timings visible, each product gets one prop with a two-word role, and the film ends on one button.
- **Borrow:** The act-timing template (3s hook, 7s problem, 23s products, 3s value, 5s offer, 5s CTA) and the timeline-as-landscape breakdown for sharing her own process. **Don't copy:** the paper-craft look or Lenny's branding.

### 21. @lukaslevert · product demo · 13.4s · ≈16:9 4K · 39K views · [post](https://x.com/lukaslevert/status/2105063567062094000)
- **Hook (0-3s):** Frame 0 is a contact page: a pitch column at left and, at right, a filled form printed on continuous-feed tractor paper with an orange submit button. By 1s the paper scrolls; by 2.5s the cursor is on submit.
- **Beats:** scroll (0-2.5s) → click submit (~3-3.8s) → the white sheet peels away diagonally to reveal a pink carbon copy (~4.6s) → a "MESSAGE RECEIVED" rubber stamp lands (~5.5s) → more stamps (a dated one, a smiley thank-you) land at random angles with each click, one of them blurred mid-slam (~7-13s).
- **Ending:** No card. It ends mid-interaction on a page crowded with stamps, with no hold.
- **Look:**
  - ground: a warm gray page;
  - palette: white and pink paper, black ink, one orange button;
  - type: a grotesk headline, mono typewriter labels and stamp lettering;
  - fills: a real site recording;
  - camera: static;
  - transitions: a page curl.
- **Made with:** Not stated; the post only dares people to name a better contact form.
- **Measured:** moving 21.7%, longest still 1.73s, 0 cuts/min (one 13.4s take), no audio.
- **Why it works:** Submitting becomes an office ritual (tear-off, carbon copy, stamp), which is tactile and funny.
- **Borrow:** A page-curl reveal of a coloured copy, then stamps that slam in with overshoot, random rotation and motion blur and pile up with each click, for any "saved" or "received" beat. **Don't copy:** Parallel's page or its stamp artwork.

### 22. @mattyp · product demo · 22s · 16:9 4K · 38K views · [post](https://x.com/mattyp/status/2103507834009014459)
- **Hook (0-3s):** Frame 0 shows Cursor's agent log at left and a video editor at right (a talking-head clip over a purple waveform timeline), with the cursor near a take-control button. By 2.5s the editor panel has scaled up over the dimmed log.
- **Beats:** split view (0-2s) → the editor enlarged, showing the full speaker (~3.4s) → the preview switches to a document layout with the speaker as a corner picture-in-picture (~4.8-6.2s) → back to the full speaker as the agent drags on the timeline (~7.6-11.7s) → a second layout, a web page with the speaker as picture-in-picture (~13-16s) → zoom back out to the split view, where the log shows commit and draft-PR steps (~17-22s).
- **Ending:** No card. The last 4s hold on the split view (the log plus the web-page layout), with almost no motion.
- **Look:**
  - ground: dark app chrome;
  - palette: dark grays, warm footage, a purple waveform;
  - type: tiny UI text;
  - fills: a real screen recording;
  - camera: static;
  - transitions: a panel scale-up and a scale-down.
- **Made with:** The post says he is building a video editor by letting a Cursor cloud agent (Grok 4.7) edit his video over MCP and then test the UI, reflecting and fixing at each failure until one edit runs cleanly end to end.
- **Measured:** moving 8.2%, longest still 2.93s, 0 cuts/min (one 22s take), no audio.
- **Why it works:** Two layout swaps are the visible proof; the agent log carries the rest.
- **Borrow:** An agent-driven layout swap as a clean state-change beat, zoomed in so it reads. **Don't copy:** the raw recording format.

### 23. @rossaxbt · UI-morph reel · 14.1s · 1:1 · 35K views · [post](https://x.com/rossaxbt/status/2106396375269134597)
- **Hook (0-3s):** Frame 0 is a black "Generate" pill with a cursor, on warm light gray. At 0.5s it shrinks to a circle with a spinner; at 1s it shows a checkmark; at 1.5s it stretches into a wide now-playing pill (gradient art and level bars); at 2s it grows into a player card; at 2.5s the cursor hits pause.
- **Beats:** player card titled "motion study 02" (~2.2s) → scrubbing, with a knob that grows and timecodes that tick (~3s) → collapse into a volume pill, dragged to full as the speaker icon gains waves (~4-4.9s) → a toggle switch (~5.7s) → Day/Week/Month tabs (~6.6s) → the tabs grow into a stats card whose number rolls and blurs between values, with a line chart and a hover tooltip (~7.5-9.3s) → the card blurs into a command palette where "frame" is typed (~10-11s) → a toast (~11.9s) → the "Generate" pill (~12.8s).
- **Ending:** A loop. The palette result "Every frame is code" is selected, becomes a black toast with a check, and the toast morphs back into the opening "Generate" pill, which holds about 1.3s, identical to frame 0.
- **Look:**
  - ground: warm light gray;
  - palette: black and white containers, with orange-pink-violet album art as the only colour;
  - type: clean grotesk, mono timecodes, a rolling numeral;
  - fills: rebuilt UI, one element at a time;
  - camera: static;
  - transitions: a continuous morph with motion blur mid-resize, with no cuts.
- **Made with:** The post says the whole video is code with no After Effects, made with Opus 5.5, and shares a template: ask for 8-12 UI states, black-and-white or one accent, and a ~120 BPM royalty-free track; one shape and no cuts, with each state the same element changing size and radius. The earlier notes add separate springs for the leading and trailing edges, an action on every beat, and a last frame that equals the first.
- **Measured:** moving 78.1%, longest still 0.8s, 0 cuts/min (one 14.1s take), loudness -14.2 LUFS.
- **Why it works:** The container never cuts. It runs about 11 believable micro-interactions in 14s (one every ~1.3s), each triggered by the cursor, and the last state is the first.
- **Borrow:** Spring the container's width, height and radius between states; crossfade the content inside it (out early, in late); give the two edges different stiffness so it stretches; change state on the beat; end on the opening state. **Don't copy:** the player content or the album art.

### 24. @Miguel07Code · other (3D concept film) · 39s · 16:9 · 30K views · [post](https://x.com/Miguel07Code/status/2105453292008661458)
- **Hook (0-3s):** Frame 0 is black. From 0.5s to 2.5s a dark panel with three empty glass windows (round, rounded-square and notched cross) slowly lights up as the camera drifts.
- **Beats:** the dark instrument (~1-4s) → the windows power on in amber, with digits scrambling into place (~6s) → all three are live, showing the same reading at three levels of detail (~8.5-13.4s) → push into the round window with shallow focus (~16-18s) → focus pulls to the square window (range, high, rate) (~20.8-23.2s) → focus pulls to the cross window (a trend line and a table of readings) (~25.6-28s) → pull back to the whole instrument (~30.5-33s) → an engraved title types onto the panel (~35-38s).
- **Ending:** A title on the object, then black. An engraved title ("APERTURES") and the concept line ("DEPTH IS THE HIERARCHY") type onto the instrument above the windows and hold about 2s, and the whole frame fades to black in the final second.
- **Look:**
  - ground: black, with low-key light;
  - palette: black glass plus a single amber;
  - type: light sans numerals with dot-matrix mono labels; a digit scramble; engraved caps typed on at the end;
  - fills: a 3D render of one object;
  - camera: slow dolly and rack focus;
  - transitions: focus pulls instead of cuts, and a closing fade.
- **Made with:** The post says Sonnet 5.5 (max) made the 39s film in 17 hours with HyperFrames. The concept is depth as hierarchy: one glass instrument, three windows showing the same tide reading at three levels of detail, and focus deciding what you read. The earlier notes add three.js glass, HTML-in-Canvas text, thin-lens depth of field and deterministic frames.
- **Measured:** moving 84.7%, longest still 1.3s, 0 cuts/min (one 39.1s take), loudness -16.1 LUFS.
- **Why it works:** It is progressive disclosure through optics: the same number at three depths, with focus doing the editing, and the title lands on the object instead of on a card.
- **Borrow:** Rack focus between z-layers as an information hierarchy (summary → detail → full table), and a closing title engraved onto the hero object. Avoid its 2.5s near-black opening, which is risky in a feed. **Don't copy:** the instrument design or the amber palette.

### 25. @claudeai · launch film · 13.3s · 16:9 · 30K views · [post](https://x.com/Miguel07Code/status/2105453292008661458)
- **Hook (0-3s):** Frame 0 is Earth through a spacecraft window. By 1s an amber VU meter; at 1.5s a metronome; at 2-2.5s a drafting pen drawing a line.
- **Beats (~0.8s each):** window → VU meter → metronome (0-1.5s) → a charcoal stroke on paper → a compass drawing a circle (~2-3s) → rotary dial showing 3-2-1 (~3.8s) → spinning pink-and-white disc (~4.6s) → starling murmuration (~5.4s) → a liquid swirl (~6.3s) → precision dial (~7.1s) → numbered dial (~7.9s) → back to the window, now with "Sonnet 5.5" (~8.7-10s) → the wordmark as Earth brightens into view (~10.4-12s) → a fade (~12.9s).
- **Ending:** A bookend and a logo. The opening window returns with the model name (~1.5s), the wordmark replaces it as Earth brightens (about 2.5s), and the wordmark fades out in the final half-second.
- **Look:**
  - ground: dark, filmic macro;
  - palette: black, amber, Earth blue, cream;
  - type: small white serif, centered, fading in and out;
  - fills: photoreal footage of objects;
  - camera: slow drifts;
  - transitions: hard cuts (only 8 detected for about 12 shots, so some changes are probably dissolves), plus a bookend.
- **Made with:** Not stated; this is the Anthropic clip that #24's post quotes.
- **Measured:** moving 80.8%, longest still 0.13s, 36.0 cuts/min (median shot 1.16s), loudness -23.1 LUFS.
- **Why it works:** Precision instruments say "measured and careful" without a feature list, the dial hides a countdown, and the last shot repeats the first.
- **Borrow:** A bookend (open and close on one shot, adding the name the second time), and a themed object montage at under 1s per shot with a countdown hidden in one object. **Don't copy:** the footage, the serif or the wordmark.

### 26. @camiinthisthang · talking head · 73.2s · 9:16 · 24K views · [post](https://x.com/camiinthisthang/status/2099888043746562185)
- **Hook (0-3s):** Frame 0 has her leaning into the lens, holding a laptop. A top label in white serif caps names the three tools, with a yellow italic serif line saying the video was edited by AI, and the bottom caption repeats the point. By 2s there is a jump back to a seated wide shot.
- **Beats:** the top label changes with each point (for example "A TEAM OF EDITORS" at ~16s, "YOUR STYLE, YOUR RULES" at ~39s, "ON-SCREEN HOOK" at ~57s, and a reference-a-creator tip at ~62s) while verbatim captions run along the bottom → the CTA label (~66-73s).
- **Ending:** A comment CTA. For the last ~7s the top label reads "COMMENT "VIDEO"" with a yellow italic "for the guide + prompt", while the verbatim captions finish her outro; there is no end card.
- **Look:**
  - ground: a pink-lit room with a globe lamp and a bookshelf;
  - palette: pink and red light, a green chair, yellow accent text;
  - type: all serif: small-caps top keywords, yellow italic for emphasis, white sentence-case captions;
  - fills: talking-head footage;
  - camera: locked off, with reframes;
  - transitions: jump cuts.
- **Made with:** The post says she combined GPT-6 Astra and Gemini's agentic video understanding into an editing workflow that turns raw footage into on-brand edits. The on-screen label also names CapCut.
- **Measured:** moving 77.7%, longest still 0.9s, 2.5 cuts/min (median shot 21.06s), loudness -35.6 LUFS (quiet).
- **Why it works:** The video is its own proof, the top keyword label gives a sound-off outline of the argument, and the same label slot becomes the CTA.
- **Borrow:** Two-tier captions, with a top chapter keyword in small caps over verbatim bottom captions and one accent colour reserved for emphasis; reuse the chapter slot for the closing CTA. **Don't copy:** her set or the serif styling.

### 27. @juliafedorin · talking head · 385.8s · 16:9 · 19K views · [post](https://x.com/juliafedorin/status/2078132625479254521)
- **Hook (0-3s):** Frame 0 is a two-shot on a couch by a bright window, with a boxed serif caption ("We were only doing memory."). At 1s a tighter angle on Dhravya; at 2s a halftone dot-screen dissolve; at 2.5s B-roll of someone at a monitor.
- **Beats (first 240s):** quick cuts between the two-shot, close-ups and B-roll, with all 16 detected cuts before ~60s and a dark product-graph UI insert near 52s → an uncut two-shot conversation from ~60s to 240s.
- **Ending:** No card. The 6.4-minute file ends mid-conversation in the two-shot on a casual "So yeah." caption, with no hold or fade.
- **Look:**
  - ground: bright daylight, with trees outside;
  - palette: natural colour, white captions on black boxes;
  - type: boxed white serif captions, centered, with a Composio watermark top-right;
  - fills: event interview footage plus one UI insert;
  - camera: handheld;
  - transitions: a halftone dissolve and hard cuts.
- **Made with:** Not stated; the post says she bumped into Dhravya at an event and started filming, and it lists chapters.
- **Measured (first 240s):** moving 76.6%, longest still 1.73s, 4.0 cuts/min (median shot 3.5s), loudness -24.2 LUFS.
- **Why it works:** The cold open front-loads the most quotable line and a textured transition, then lets a real conversation breathe.
- **Borrow:** The halftone dot dissolve as a code-renderable transition, and cuts concentrated in the first minute. **Don't copy:** the footage or the watermark placement.

### 28. @supermemory · talking head · 1195.4s · 16:9 · 15K views · [post](https://x.com/supermemory/status/2080542605360902263)
- **Hook (0-3s):** Frame 0 has giant stacked white condensed caps ("THATS NOT") over the guest's webcam shot, and by 0.5s it reads "THATS NOT GONNA WORK" over four lines. At 1-1.5s there is a clean shot of him gesturing; at 2-2.5s "People are trying" builds word by word at top-left.
- **Beats (first 240s):** a giant lowercase "how" at top-left that seems to sit partly behind his head (unclear, ~7s) → single webcam with small captions (~22s) → split screen with the host (~37-52s) → mostly the guest full-frame (~67-202s) → split screen with a white question card about how the brain decides which memories to keep (~217s).
- **Ending:** No card. The full 20-minute episode ends on the split screen with thank-yous and a promise of more podcasts in the captions, then cuts to black with the last caption still on screen for under a second.
- **Look:**
  - ground: daylight webcam, with a building facade behind;
  - palette: natural colour, white type, the logo top-right;
  - type: a condensed caps pull-quote, small sans captions, and white rounded question cards with bold black text;
  - fills: remote-call footage;
  - camera: static webcam;
  - transitions: cuts between single and split screen.
- **Made with:** Not stated; the post lists the episode's topics (forgetting as a feature, the hippocampus, dreaming, why a bigger context window isn't memory) and gives a pull-quote.
- **Measured (first 240s):** moving 79.4%, longest still 1.5s, 1.8 cuts/min (median shot 34.17s), loudness -20.2 LUFS.
- **Why it works:** The cold open sets a contrarian line as giant type, and the question cards give the episode chapters.
- **Borrow:** Question cards as chapter markers, and keywords depth-sorted behind the guest (as in #10 and #11) to lift remote-call footage. A closing card pointing to the next episode would turn the verbal promise into an action. **Don't copy:** the static webcam framing for anything shorter than an episode.

### 29. @sudo_kiran · explainer · 30.1s · 16:9 · 10K views · [post](https://x.com/sudo_kiran/status/2104194783178785203)
- **Hook (0-3s):** Frame 0 is an orange hand-drawn splat on paper texture. At 0.5s it squashes and grows; at 1s it becomes the icon in a hand-drawn prompt pill; at 1.5-2s "turn this into a video" is typed next to a colourful send button; at 2.5s sketchy ripple rings burst from the button.
- **Beats:** cut to a navy starfield with a fan of document pages (~4.7s) → one page, with green, blue and pink highlighter strokes on key lines (~6.6s) → the highlights lift off into three pills with icons and waveforms (~8.5s) → a pencil draws the waveforms together (~10.3s) → back on paper, doc → bulb → monitor drawn as a pencil sketch (~12-14s) → the same diagram snaps into clean flat vector on lavender (~16s) → a glowing play triangle full of thumbnails (~17.9s) → a target (~19.8s) → a blank paper player card with a pencil (~21.6s), which fills with a hand-drawn explainer diagram (~23.5s) → a small finished card floating on paper inside sketchy rings (~25.4s) → the splat mascot beside three coloured bars (~27.3s).
- **Ending:** A mascot finale. The result cards fan out, then the splat hops along a sparkle trail onto the top of three coloured bars (the send button's stripes) and settles with sparkles, held about 1s. There is no wordmark, URL or CTA.
- **Look:**
  - ground: paper texture and a navy starfield;
  - palette: orange; green, blue and pink highlighter; lavender; navy;
  - type: minimal, with small hand lettering and a clean sans in the prompt;
  - fills: hand-drawn and flat-vector illustration;
  - camera: static;
  - transitions: hard cuts (4, between ~14.8s and 19.4s) and a sketch-to-clean style switch.
- **Made with:** The post shares the prompt: research the product, make a dynamic 40-second motion-graphics video "like it's your showreel", and go all out.
- **Measured:** moving 93.2%, longest still 0.07s, 8.0 cuts/min (median shot 3.93s), loudness -13.8 LUFS.
- **Why it works:** The pipeline is told with objects (pages → highlights → voice pills → video), and the sketch-to-clean switch is the transformation. The wordless finale is charming but never names the product.
- **Borrow:** Highlighter strokes that lift off a page into labeled pills (an extraction metaphor that fits supermemory), a snap from pencil sketch to clean vector, and a mascot that lands on the mark, plus the name and URL it omits. **Don't copy:** the splat mascot or the starfield.

### 30. @VadimStrizheus · product demo · 34.2s · ≈16:9 4K · 9.4K views · [post](https://x.com/VadimStrizheus/status/2094194476252016861)
- **Hook (0-3s):** The same recording as #19 (byte-identical file, sheet and end strip): a near-empty dark chat app, a bot greeting by 1s, typing by 2.5s.
- **Beats:** as in #19: a request with a link → the bot connects a tool and starts a clip job → it lists the finished clips → a clip viewer plays captioned clips (~22-33s).
- **Ending:** As in #19: no card; it cuts back to the chat and its clip list for about 1s.
- **Look:**
  - ground: a dark chat UI, then a clip viewer;
  - palette: grays and a purple avatar, plus the clips' caption colours;
  - type: tiny UI text, then two-line caps captions inside the clips;
  - fills: a raw 4K screen recording;
  - camera: static;
  - transitions: cuts in the viewer.
- **Made with:** This later post says the Grok bot with the vugola MCP server now cuts dead space, clips videos, adds captions and posts to social media.
- **Measured:** moving 3.7%, longest still 2.27s, 0 cuts/min (one 34.2s take), no audio. This disagrees with #19's run on the same file, and the corrected sheet's clip switches favour #19's numbers.
- **Why it works:** It reposts the same proof with a new feature list.
- **Borrow:** Nothing new (see #19). **Don't copy:** reusing one raw clip across launches.

### 31. @shiri_shh · product demo · 24.9s · ≈4:3 (1388×1080) · 5.5K views · [post](https://x.com/shiri_shh/status/2064983887017836631)
- **Hook (0-3s):** Frame 0 is a dark terminal full of Claude Code session text, with a small black hole (a white-hot photon ring) left of center bending the nearby lines around it. Through 2.5s it drifts, and the bending follows it.
- **Beats:** the hole drifts and grows until its lensing bends most of the terminal (~0-17s) → it shrinks back over a few seconds (~19-21s) → it stays small near the top to the end (~21-25s).
- **Ending:** No card. The hole has shrunk back to a small size near the top and drifts gently, so the last 4s barely change.
- **Look:**
  - ground: a dark terminal;
  - palette: near-black; white, blue and green mono text; a white-hot ring;
  - type: monospace terminal text, distorted by the effect;
  - fills: a shader over real terminal text (on-screen text names a blackhole.glsl file);
  - camera: static;
  - transitions: none.
- **Made with:** The post, which shares someone else's build, says a developer made a black hole that sits in the terminal, grows the longer you code without stopping, bends text like gravity and shrinks only when you take a break.
- **Measured:** moving 88.0%, longest still 1.07s, 0 cuts/min (one 24.9s take), no audio.
- **Why it works:** One physical metaphor applied to real text reads without any words, and the grow-then-shrink arc acts out the post's premise in 25s.
- **Borrow:** Screen-space radial displacement on a rendered text layer, with its strength tied to a variable, as a "gravity" beat that grows and relaxes (for example, memories pulled toward a node). **Don't copy:** the black-hole visual itself.

### 32. @austinh___ · ad · 90.8s · 16:9 4K · 4.0K views · [post](https://x.com/austinh___/status/2104941773420122177)
- **Hook (0-3s):** Frame 0 is a macro of hands typing, with a white wordmark over it. At ~1s a hand on a glass of water, with "presents" in small serif. At ~1.8s a hand on a trackpad under the title "Unify MCP (ASMR Edition)" in red and white serif. At 2.5s a wide two-shot in the office, still under the title.
- **Beats:** the title with a names lower-third (~3s) → someone eating in the kitchen (~8s) → two people at a laptop, with an assistant permission bar composited at the bottom (~14-20s) → a floating table card beside a face (~26s) → a laptop lid closing under a table overlay (~31s) → coffee-machine knob macro (~37s) → someone strikes a gong (~43-48s) → two people at their laptops (~54s) → a drafts-for-review card floating over the desk (~60s) → close-ups and focus pulls (~65-82s) → a man at his desk turns to camera (~87s).
- **Ending:** A logo, then black. The man at his desk turns to camera with a small gesture, the focus pulls to a blur, and the orange-red wordmark holds over the defocused office for about 2s before a cut to black.
- **Look:**
  - ground: a bright modern office;
  - palette: neutral whites with an orange-red brand accent;
  - type: red and white serif titles, a heavy rounded wordmark, small UI text in the cards;
  - fills: live action with rebuilt UI cards composited into the scene;
  - camera: macros, shallow focus, slow moves;
  - transitions: hard cuts, each shot showing one sound-making action (typing, a glass, a knob, a gong), per the ASMR premise, and a closing focus pull.
- **Made with:** Not stated; the post says the marketer made the team do ASMR, announces that Unify now works in Claude, Codex and Cursor, and asks viewers to turn the sound on.
- **Measured:** moving 78.3%, longest still 0.5s, 15.2 cuts/min (median shot 2.79s), loudness -26.9 LUFS (quiet, which fits ASMR).
- **Why it works:** A sound-first concept gives every shot a reason to exist, and the product appears as cards floating in the room rather than as a screen recording.
- **Borrow:** One sound-making action per shot as the beat rule, UI cards composited next to the subject, and a focus pull that turns the last shot into the logo's background. **Don't copy:** the footage, the gong gag or their brand colours.

### 33. @MaheshtheDev · other (UI hero loop) · 11.7s · ≈1.15:1 · 3.0K views · [post](https://x.com/MaheshtheDev/status/2070949197013217393)
- **Hook (0-3s):** Frame 0 is a deep-blue radial glow, with a central dark tile bearing the supermemory mark, ringed by about 16 smaller dark tiles with tool logos. By 2-2.5s a soft ring pulses out of the center and a thin beam reaches one tile at lower right, which glows red.
- **Beats:** the tiles drift (0-1.5s) → a pulse ring and a beam to one tile at lower right, which glows red (~1.8-4s) → the ring fades as the constellation slowly orbits (~4.8-8.4s) → a second pulse and beam, this time to a tile at upper right (~9.1-10.6s) → the ring fades (~11.3s).
- **Ending:** No card. It ends mid-loop as the second pulse fades, with no hold.
- **Look:**
  - ground: a deep-blue radial gradient;
  - palette: blue glow, dark glassy tiles, logo colours;
  - type: one tiny caption line at the bottom (illegible);
  - fills: rebuilt UI (an icon constellation);
  - camera: static, with a slow orbit of the tiles;
  - transitions: none.
- **Made with:** Not stated; the post credits the team's designer.
- **Measured:** moving 23.8%, longest still 1.53s, 0 cuts/min (one 11.7s take), no audio.
- **Why it works:** A hub and spokes read instantly as "connects to everything", each pulse plus beam shows one sync, and hitting a different tile each time implies many.
- **Borrow:** The hub pulse and beam-to-tile as a connectors beat, with a slow orbit, a different target per pulse, and a sound on the beam. **Don't copy:** nothing to avoid, since it is in-house, but credit the designer and keep it on brand.

### 34. @kunalbagaria · launch film · 30s · 16:9 · 3.0K views · [post](https://x.com/kunalbagaria/status/2105992661903761572)
- **Hook (0-3s):** Frame 0 is a macro of an orange-red "esc" keycap with a rim of backlight, and at 0.5s it is pressed. At 1s it cuts to "command"; at 1.5s to an orange "return"; at 2-2.5s a low dolly across the QWERTY keys with shallow focus.
- **Beats:** key macros and dollies (0-3s) → a black card, "Click." (~4.7s) → pull back from the esc key (~6.6s) → the full keyboard in perspective as "Rust" drops in letter by letter (~8.5s) → keycaps lift off to reveal red-lit switches, with "Linear." in red (~10.3s) → a big "2" with a switch label (~12.2s) → cut (14s) to a real macOS desktop: a notes window being typed in (~14.1s) → the menu-bar dropdown with sound settings, under "Always a click away." (~16s) → "0.0%" over "CPU when you're not typing." on a dark keyboard (~17.9s) → "It hears keys. Never" followed by redacted blocks (~19.7s) → "Free and open source." with a GitHub URL over code (~21.6s) → a curl install command typed over the keyboard (~23.5-25.4s) → app icon and wordmark (~27.2s) → end card (~29.1s).
- **Ending:** An end card with a URL. The install command gives way to an orange shape that shrinks into the app icon, and the name assembles with "Free for Mac." and the URL beneath. A ring pulses around the icon, the card holds about 2s, and it fades to black.
- **Look:**
  - ground: black, plus an orange macOS desktop;
  - palette: charcoal keys, orange-red accents, red switch glow;
  - type: bold neo-grotesk one-word cards ending in a period, a per-letter drop-in, claim cards, a mono install command, and redacted blocks;
  - fills: a 3D CG keyboard (first 12s), then real macOS UI (notes window, menu-bar app) and claim cards over the keyboard;
  - camera: macro dollies, rack focus, pull-backs;
  - transitions: hard cuts; the claim section cuts on an exact 2s grid (14, 16, 18, 20, 22s).
- **Made with:** Not stated for the video; the post says he built a tool years ago that gives any keyboard a mechanical feel (13,000+ downloads), and this is a faster menu-bar version for macOS.
- **Measured:** moving 95.6%, longest still 0.5s, 18.0 cuts/min (median shot 2.0s), loudness -13.9 LUFS.
- **Why it works:** The first half sells the feel (keys moving, one-word cards). The second half answers every objection on a strict 2s beat (where it lives, CPU cost, privacy via the redacted word, price, install) and ends on how to get it.
- **Borrow:** Claim cards cut on an even grid; redacting the very word you promise never to record; the install command on screen right before the end card; and an exploded view for the "how it works" beat. **Don't copy:** the keyboard renders or the orange/charcoal palette.

### 35. @nidhisinghattri · talking head · 646.5s · 16:9 · 2.2K views · [post](https://x.com/nidhisinghattri/status/2098453574573539807)
- **Hook (0-3s):** A webcam talking head (white top, teal wall, red sofa), gesturing, with no text through 3s.
- **Beats (first 240s):** talking head (~7-37s) → the benchmark table, first full-width and then pillarboxed (~52-68s) → talking head (~82s) → terminal: listing the raw clips and launching Claude Code (~97-157s) → the Claude Code splash with a cheap-model and effort badge (~172-187s) → her editing brief, the skill loading, and setup and transcription notes (~202s) → talking head (~217s) → the agent retrying failed filmstrips (~232s).
- **Ending:** No card. The 10.8-minute video ends on her webcam outro, smiling and waving goodbye.
- **Look:**
  - ground: a home room;
  - palette: natural colour, a white table, a dark terminal;
  - type: none on the talking head; plain table text; small terminal mono;
  - fills: webcam footage plus a static table and a terminal recording;
  - camera: static;
  - transitions: hard cuts.
- **Made with:** The post says she tested DeepSeek V4.1 Flash inside Claude Code to edit her raw clips and that the run cost $0.33; it lists chapters.
- **Measured (first 240s):** moving 40.8%, longest still 3.93s, 1.2 cuts/min (median shot 27.61s), loudness -15.3 LUFS.
- **Why it works:** The cost figure and the chapters in the post carry it. The video opens on talk, and the real proof (the terminal run) only starts about 1.5 minutes in.
- **Borrow:** Put the cost receipt on screen within the first 3s and show the run before the explanation. **Don't copy:** the long talk-first opening.

## Batch patterns

**Formats:** 35 entries, 34 unique. Product demo 11 (#1, 6, 7, 14, 15, 17, 19, 21, 22, 30, 31; #30 repeats #19), launch film 8 (#4, 5, 8, 12, 13, 18, 25, 34), talking head 5 (#11, 26, 27, 28, 35), other 5 (#3 doc episode, #10 caption demo, #20 film breakdown, #24 3D concept film, #33 hero loop), explainer 2 (#2, 29), tutorial 2 (#9, 16), UI-morph reel 1 (#23), ad 1 (#32). Twelve unique posts say a model or agent made or edited the video shown (#2, 5, 8, 9, 12, 13, 18, 20, 23, 24, 26, 29).
**Data caveats:** beat times come from exact frames, so they are good to one tile spacing (T/16: under 2s for clips up to 30s, 15s in the 240s windows). Cut detection misses morphs and split screens (#8 reads 0) and over-counts stepped redraws (#2 reads 108.7/min), and 12fps holds lower the moving % (#20). #19 and #30 are one file with conflicting runs; only #19 is counted below.

**Hooks:**
- **Prompt typed by 1-2s:** #5, #8, #29 (and #13 types one at ~11s). **A brand mark that becomes the UI:** #12 (wordmark → dot → button → photo), #23 (button → spinner → player), #13 (red dot → now-line), #29 (splat → prompt bar).
- **The problem made measurable in type:** #5's count-up timer, #18's stretched "ummmm", #28's stacked pull-quote.
- **Proof first:** #3 (a stack of press clips), #26 (the video says it was AI-edited), #27 (a quote, then a halftone dissolve to B-roll). **Tactile macro montage at ~0.5s a shot:** #25, #32, #34. **Interaction from frame 0:** #1, #7, #14, #31.
- **Weak:** static 4K recordings with tiny text (#16, #19/#30, #22), a silent talking head (#35), and a 2.5s fade up from black (#24).

**Pacing per format** (medians of duration · moving · cuts/min · median shot; videos over 240s measured on their first 240s):
- **Launch film (8):** 29.7s · 82% · 9.0 · 3.8s. The code-made ones (#5, 8, 12, 13) are near-continuous takes (median 0.9 cuts/min); the footage and 3D ones (#4, 18, 25, 34) cut at a median 26/min with ~1.6s shots, and #34's claim section cuts on an exact 2s grid.
- **Product demo (10):** 23.5s · 57% · 0 · 16.9s. Interaction demos (#1, 7, 14, 21, 31) have a median of 88% moving; agent screen recordings (#15, 17, 19, 22) have 17%.
- **Talking head (5):** 386s · 78% · 1.8 · 21.1s. **Other (5):** 39s · 73% · 0 · 11.7s. **Explainer (2):** 28.6s · 82% · 58.4 (inflated by #2) · 2.1s. **Tutorial (2):** 111s · 15% · 0. **UI-morph reel (1):** 14.1s · 78% · 0. **Ad (1):** 90.9s · 78% · 15.2 · 2.8s.
- **Whole batch:** median 30.6s, 77% moving, 0 cuts/min. 18 of 34 have no detected cut, including 12 of the 20 clips of 35s or less. Finished social cuts cluster at -13.8 to -14.9 LUFS; the 7 silent clips are all screen or UI recordings.

**Transitions, morphs and camera:**
- **One container through many states, no cuts:** #6, #12 (about 17 states, wordmark to framed print and back), #13, #23 (about 11 states in 14s), #29. **Depth as structure:** keywords behind people (#10, #11), rack focus as hierarchy (#24), depth-blurred chips (#13), shallow-focus macros (#25, #34).
- **Exploded views:** #6 (frame layers), #34 (keycaps). **Push in until a word crops:** #8, #9, #14, #22. **Pull back to reveal the system:** #1 (a row of every roof), #12 (the phone on a backdrop), #13 (a sea of weeks), #9 (the page shrinks to a card). **Out of the screen into the world:** #12 (photo → lock screen → shop → print on a wall).
- **Material transitions:** page curl and stamps (#21), notebook flip and closing wipe (#20), sketch → clean vector (#29), ink scribble (#2), halftone dissolve (#27), foreground occluder wipe (#10, #11), focus pull into the logo (#32). Directional motion blur on fast moves (#11, #12, #23).

**Type animation:**
- **Word-by-word builds with blur-in:** #1, #5, #9, #13, #28; taglines typed under a logo (#8). **One-word cards ending in a period:** #5, #12, #13, #34. **Numbers as story:** count-ups (#5), a rolling stat (#23), a digit scramble (#24), milestone titles (#3), a closing runtime receipt (#5), tally marks for days (#2).
- **Keyword systems:** a giant accent word behind the speaker (#10, #11, including #11's product-name reveal), an italic, underlined keyword in captions (#6), a top keyword label over verbatim captions (#26), one-word caps captions (#18), and a single gold payoff word (#10).
- **Type driven by data, physics or objects:** fillers stretched with the level meter (#18), shader lensing (#31), glyph ropes (#1), ring and drum text (#10, #11), per-letter drops (#34), redacted words (#34), a title engraved onto the object (#24).

**Endings and CTAs** (34 unique, from the end strips):
- **Logo or wordmark card, 9:** #4 (credits, then a small lockup), #5 (logo, a runtime receipt, then "done."), #8, #9, #13, #18, #25, #32, #34. Four carry a URL (#9, #13, #18, #34); #34 also adds "Free for Mac." and shows its install command just before. Holds run from under 1s (#4) to about 2.5s, median about 2s.
- **Explicit CTA, 4:** #6 ("Open it in VEED" over this very video), #11 ("Give it your first prompt." under the name reveal), #20 (a "Get Product Pass →" button inside the film), #26 (comment a keyword for the guide, held ~7s).
- **Loop back to frame 0, 4:** #2, #12, #14, #23; #13 also collapses back into its opening dot after its logo card. **Designed close without a logo, 3:** #10 (gold payoff word), #24 (engraved concept line, then black), #29 (mascot lands on the mark). **Spoken sign-off, then black, 2:** #3, #28.
- **No ending, 12:** #1, 7, 15, 16, 17, 19, 21, 22, 27, 31, 33, 35, almost all raw recordings that stop mid-action; #15 at least closes on a "Replay the build" link and #17 on an offer to apply the fixes. All 8 launch films end on the brand mark (7 as a card, #12 as a loop), but only 3 of them give a URL or install path (#13, #18, #34).

**Workflows (from the posts):**
- **One prompt to a frontier model that writes frame code,** from about a minute and $2 (#5) to 8 hours with music and SFX in code (#13) or 17 hours on HyperFrames (#24). #2 drew every frame in JavaScript.
- **Open prompt templates** with inputs, direction, beats and build rules (#12, #23, #29), and a remake prompt plus process (#8). **Skills as motion modules:** a HyperFrames community skill (#10, #11), /review-animations (#17), /remove-ai-slop (#16), video-use (#18), and Fable with website-to-hyperframes in 5 prompts (#20, per the earlier notes).
- **Agents on real footage and UIs:** transcript-first take selection (#18), video understanding paired with an editor (#26), a cheap-model edit (#35), MCP clip bots (#19, #30), an agent building an editor through test-and-fix loops (#22), agent-recorded tutorials (#9), and editable renders (#6, plus Osmo in #4).

**Lessons:**
1. **Let one element carry the film, and bring it home.** Spring a single container's size and radius between states and crossfade what's inside, instead of cutting (#12, #23, the red dot in #13). Then end on the frame you started on (#12, #13, #14, #23), so autoplay loops seamlessly.
2. **Make the problem felt within 2s, name it in one word, and answer it in kind.** #5 runs a count-up timer, says "WASTE.", and closes on a receipt setting the film's 26s against a 0.038s answer. #13 says "doesn't fit." and resolves with "Everything fits.". #18 stretches "ummmm", then shows a terminal receipt.
3. **Turn the claim into a physical object.** Editable becomes exploded layers (#6), agents building become named cursors with verbs (#15), received becomes a carbon copy and stamps (#21), extraction becomes highlights lifting into pills (#29), privacy becomes a redacted word (#34), and "from screen to wall" becomes a print hung on a wall (#12). For supermemory: facts lifting off a document into memory pills, and #33's hub pulse for connectors.
4. **Put type inside the scene's depth.** Place keywords and even the product name behind the subject (#10, #11), use focus pulls as hierarchy (#24), and blur the chips behind a headline (#13). In code this is z-order, blur and slow parallax.
5. **Borrow timing before style.** Remake a proven film beat for beat and check it side by side in sync (#8). Start from act timings like #20's (3/7/23/3/5/5s, CTA included), and cut claim cards on an even grid (#34 cuts every 2.0s).
6. **Design for a phone screen and show the output.** Raw 4K recordings with no zoom (#16, #19/#30, #22) read as 4-24% motion with unreadable text; #9 stays followable on mute with auto-zoom and 2-5 word callouts, and #19's only legible part is its full-screen clip viewer.
7. **Finish with a QA pass and a mix.** Use #17's rubric: ease-out on enter, about 200ms in and 150ms out for UI, scale from 0.95 rather than 0, animate only transform and opacity, keep a reduced-motion fade, and check at 25% speed. Then mix to about -14 LUFS (#6, 8, 12, 13, 18, 23, 29 and 34 sit at -13.8 to -14.9) and give each beat one sound (#32, #34).
8. **End on the mark plus one action, held about 2s.** The clearest closes put a URL or install line under the logo (#9, #18, #34) or ask for exactly one thing (#6, #11, #20, #26). 12 of 34 simply stop, and 5 of the 8 launch films show no URL.
