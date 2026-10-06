# Tools

Small helpers made during the films. Each one was used for real and needs no installs.

| Tool | What it does | Use |
|---|---|---|
| `study_video.py` | Measures a reference video (motion with the `qa.md` 2.3 metric, longest still, cuts, median shot, loudness) and makes an exact 16-frame sheet, a strip of the first 2.5s and a strip of the last 4s | `python3 study_video.py ref.mp4 [out_dir]`. Built for the 2026-10-06 video study (`../../references/video-study.md`); each sheet frame comes from its own seek, because a `select` window bunches frames at 60fps |
| `framehash.py` | Prints an md5 for every raw frame of a `./render raw` stream | The determinism check: two runs must give identical hashes. In v4, 85 of the first 400 frames differed while CoreGraphics drew frames in parallel; after the one-thread fix 0 differ |
| `raster.swift` | Rasterises any image NSImage can read (SVG, PDF, PNG) to a PNG with real alpha, at a given max side | `swiftc -O raster.swift -o raster && ./raster logo.svg logo.png 512`. `sips` flattens onto white, so it can't be used for this |
| `fixarc.py` | Rewrites compact SVG arc flags (`a1 1 0 0110 10` style) into spaced form before rasterising | Some logos (Codex, Hermes) drew wrong until their arc flags were spaced out |
| `capture-inbox/` | A localhost-only page with a file input, plus a tiny Python server that saves each upload into `caps/` | Gets screenshots from her Chrome onto disk when the desktop app has no screen-recording permission: Claude in Chrome's `upload_image` sends a capture into the page's file input and the server writes it. Run `python3 server.py`, open http://127.0.0.1:8765/, and set the page title to `capture inbox | name.png` to name the file. It listens on 127.0.0.1 only |

Element captures: isolate the element with `position:fixed` and CSS `zoom` over a plain backdrop, then screenshot it. A background tab repaints only when it is screenshotted, so take a small screenshot before reading its DOM. For product UI, prefer the vector rebuild from the measured DOM (`../../references/lessons.md` 3.7) over captures.
