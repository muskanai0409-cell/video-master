// ================================================================ console series, part 1 · connect: the film
// One continuous take over the vector console, keyed to the voiceover's word clock (vo_times.swift, made by
// audio/vo_build.py from the timed Bella read). Every visual hit is a spoken word's onset minus VLEAD.
//
// Build:   cat lib.swift console.swift vo_times.swift film.swift > render.swift && swiftc -O render.swift -o render
// Stills:  ./render stills 0 1.5 3 ...          (SCALE=1 default: 1920x1080 PNGs + stills/sheet.png)
// Video:   SCALE=2 ./render raw | ffmpeg ...     (see make.sh)
// Sound:   ./render events > audio/events.json  (every click, key and tick the mix lays sound on)
//
// World = console page CSS px (0..1470 x 0..835); everything outside the console is placed in the same world so
// the camera can travel between them. Screen = the 1920x1080 design frame (lift-outs, cursor, captions, HUD, end).

let SC: CGFloat = CGFloat(Double(ProcessInfo.processInfo.environment["SCALE"] ?? "1") ?? 1)
let PW = Int(1920 * SC), PH = Int(1080 * SC)
let SUBFRAMES = Int(ProcessInfo.processInfo.environment["SUB"] ?? "6") ?? 6
let SHUTTER = 0.35
let CAPTIONS_ON = (ProcessInfo.processInfo.environment["CAPS"] ?? "1") == "1"
TS = 1.12

// ================================================================ the word clock
/// Sync rule (research spec, ../README.md "Voice timing"): the picture lands 2 frames before the word is heard, on the
/// frame at or before its audible onset (rounded down, never toward the audio), so sound trails picture by 33-50 ms,
/// where listeners place perceived sync; sound never leads. Effects follow the same rule (SFX_LAG after the contact).
let VLEAD = 2.0 / FPS, SFX_LAG = 2.0 / FPS
func w(_ l: Int, _ i: Int) -> Double { VO_AON[l - 1][i] }
func hit(_ l: Int, _ i: Int) -> Double { (VO_AON[l - 1][i] * FPS).rounded(.down) / FPS - VLEAD }
func pauseAfter(_ l: Int, _ i: Int) -> (a: Double, b: Double) {
	let p = VO_PAUSE.first { $0.l == l - 1 && $0.w == i }!
	return (p.a, p.b)
}
func lineEnd(_ l: Int) -> Double { VO_END[l - 1] }
func hitAt(_ onset: Double) -> Double { (onset * FPS).rounded(.down) / FPS - VLEAD }

// ---- B1 · frame 0: the plugin command and a connected row (the thumbnail)
let B1_KEY = 0.05                                  // Enter on the typed command
let B1_ROW = hit(1, 1) + 0.24                      // the row lands while she says "command,"
let B1_PUSH = 1.15
// ---- B2 · every session starts from zero
let B2_OUT = lineEnd(1) + 0.15
let CARD_IN: [Double] = [B2_OUT + 0.28, hit(2, 6) - 0.02, pauseAfter(2, 15).a + 0.12]   // "zero." / before "Again."
let TYPE1: [Double] = (0..<10).map { hit(2, 2) + Double($0) * 0.1 }                    // through "every session starts from"
let TYPE2: [Double] = (0..<6).map { hit(2, 7) + Double($0) * 0.12 } + [hit(2, 12), hit(2, 13), hit(2, 14), hit(2, 15)]  // p n p m on P N P M
let TYPE3: [Double] = (0..<10).map { hit(2, 16) + Double($0) * 0.032 }                  // "Again." fast and tired
// ---- B3 · open Agents & MCP
let MORPH_A = lineEnd(2) + 0.05, MORPH_B = MORPH_A + 0.7
let NAV_AGENTS = hit(3, 3)                         // "agents"
let PLUGIN_PUSH = hit(3, 8) - 0.25                 // "start with the plugin"
// ---- B4 · one command covers the four, browser sign-in, there's your agent
let NAME_T: [Double] = [hit(4, 3), hit(4, 5), hit(4, 6), hit(4, 8)]
let CMD_COPY = pauseAfter(4, 9).a + 0.03           // the copy click as she finishes "Code."
let CMD_PAN = NAME_T[3] + 0.1                    // after "OpenCode" brightens, pan to the command box
let CMD_HOVER = CMD_COPY - 0.28
let PULL_A = CMD_COPY + 0.08
let FLY_A = CMD_COPY + 0.12, FLY_B = FLY_A + 0.30
let T4_KEY = FLY_B + 0.04                          // Enter in the docked terminal
let BROWSER_IN = max(hit(4, 10), T4_KEY + 0.1)     // "Browser"
let BROWSER_OK = hit(4, 11)                        // "sign-in": one approval
let BROWSER_OUT = BROWSER_OK + 0.34
let GLIDE_A = BROWSER_OK + 0.18
let ROW_LAND = hit(4, 17)                          // "there's your agent"
let GLIDE_B = ROW_LAND - 0.3
// ---- B5 · MCP and CLI
let B5_A = lineEnd(4) + 0.12
let MCP_LIFT = hit(5, 0) - 0.12                    // "Other"
let MCP_COPY = hit(5, 8)                           // "U R L"
let MCP_DROP = pauseAfter(5, 10).a + 0.04
let CLI_LIFT = hit(5, 12) - 0.1                    // "there's a C L I"
let CLI_HOVER = hit(5, 14)
let B5_END = lineEnd(5) + 0.12
// ---- B6 · your own app: the setup prompt
let NAV_OVERVIEW = hit(6, 2) + 0.05                // during "your own"
let ONB_LIFT = pauseAfter(6, 4).a + 0.04           // after "memory?"
let ONB_HOVER = hit(6, 5)                          // "Paste"
let ONB_CLICK = hit(6, 8)                          // "prompt"
let CLIP_A = hit(6, 11) - 0.12, CLIP_B = hit(6, 13) // "into your agent."
let B6_END = lineEnd(6) + 0.12
// ---- B7 · API Keys
let NAV_KEYS = max(hit(7, 0), B6_END + 0.42)       // "This part needs a key"
let CREATE_CLICK = hit(7, 4)                       // "key."
let SCOPED_HOVER = hit(7, 5)                       // "Pick its access"
let SUBMIT_CLICK = pauseAfter(7, 7).a - 0.04       // as "access," ends
let KEY_COPY = hit(7, 8)                           // "copy it"
let KEY_PUSH = hit(7, 10)                          // "it only shows once"
let B7_END = lineEnd(7) + 0.1
// ---- B8 · Requests
let DLG_CLOSE = B7_END
let NAV_REQ = max(hit(8, 0), DLG_CLOSE + 0.3)
let LANDS = hit(8, 3)                              // "lands"
let STATUS_T = hit(8, 8), DUR_T = hit(8, 10)       // "status", "how long it took"
// ---- B9 · thesis, B10 · next + lockup
let B9_A = lineEnd(8) + 0.15
/// The music's bar: downbeats land on the console opening (MORPH_A) and on "New session", with the whole number of
/// bars between them that keeps the loops nearest their native 90 BPM.
let BAR_N = ((hit(9, 0) - MORPH_A) / (240.0 / 90)).rounded()
let BAR = (hit(9, 0) - MORPH_A) / BAR_N
let THESIS_CLEAR = hit(10, 0) - 0.32
let CHIP_A = hit(10, 0) - 0.08                     // "Next,"
let LOCK_A = lineEnd(10) + 0.12
let T_STILL = LOCK_A + 0.62
let T_END = T_STILL + 1.4

// ================================================================ world layout
func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y) }
func center(_ r: CGRect) -> CGPoint { CGPoint(x: r.midX, y: r.midY) }
/// B1: the Connected card is the page cropped to the title + the AGENT and ACCESS columns (right edge on the
/// separator before DEVICE), drawn where it sits on the page; the plugin terminal sits to its left.
let CROP = CGRect(x: 355, y: 132, width: 446, height: 196)
let T1R = CGRect(x: -90, y: 146, width: 400, height: 168)
let B1_CAM = P((T1R.minX + CROP.maxX) / 2, CROP.midY)
let B1_ROWC = P(AG_TABLE.minX + 216, AG_ROW.midY)
/// B2: three new sessions stacked; the front one sits where the console's top-left will be framed.
func cardRect(_ i: Int) -> CGRect { CGRect(x: 85 + 60 * CGFloat(i), y: 29 + 80 * CGFloat(i), width: 600, height: 190) }
/// B4: the terminal docks left of the console window, the sign-in window opens above it.
let T4_SIZE: CGFloat = 21
let T4R = CGRect(x: -660, y: 492 - 38 - 18 - T4_SIZE * 1.7 / 2, width: 600, height: 176)
let BRR = CGRect(x: -580, y: 196, width: 440, height: 200)

// ================================================================ camera
struct Cam { let t: Double; let c: CGPoint; let z: Double; let dur: Double; var drift: Bool = false }
/// Keep a full-bleed frame inside the console window (no ground showing at the edges).
func bleed(_ c: CGPoint, _ z: Double) -> CGPoint {
	let hw = 960 / CGFloat(z) + 1.5, hh = 540 / CGFloat(z) + 1.5
	let x = PAGE.width > 2 * hw ? min(max(c.x, hw), PAGE.width - hw) : PAGE.width / 2
	let y = PAGE.height > 2 * hh ? min(max(c.y, hh), PAGE.height - hh) : PAGE.height / 2
	return P(x, y)
}
let RQ_ROWC = P(650, RQ_TOP_ROW.midY)
let CAMS: [Cam] = [
	Cam(t: 0, c: B1_CAM, z: 1.9, dur: 0),
	Cam(t: 0, c: P(B1_CAM.x + 6, B1_CAM.y), z: 1.94, dur: B1_PUSH, drift: true),
	Cam(t: B1_PUSH, c: P(B1_ROWC.x - 30, B1_ROWC.y + 8), z: 2.45, dur: B2_OUT - B1_PUSH),                 // push onto the row
	Cam(t: B2_OUT - 0.05, c: P(475, 206), z: 1.62, dur: 0.75),                                             // the sessions
	Cam(t: B2_OUT + 0.7, c: P(505, 290), z: 1.86, dur: MORPH_A - B2_OUT - 0.7, drift: true),
	Cam(t: MORPH_A - 0.05, c: bleed(P(512, 289), 1.9), z: 1.9, dur: 0.85),                                // into the console
	Cam(t: MORPH_A + 0.8, c: bleed(P(540, 290), 1.92), z: 1.92, dur: PLUGIN_PUSH - MORPH_A - 0.8, drift: true),
	Cam(t: PLUGIN_PUSH, c: bleed(P(721, 520), 2.5), z: 2.5, dur: 1.0),                                    // the plugin row: its label
	Cam(t: PLUGIN_PUSH + 1.0, c: bleed(P(729, 521), 2.53), z: 2.53, dur: CMD_PAN - PLUGIN_PUSH - 1.0, drift: true),
	Cam(t: CMD_PAN, c: bleed(P(1010, 520), 2.5), z: 2.5, dur: CMD_COPY - 0.08 - CMD_PAN),                // over to its command box
	Cam(t: CMD_COPY - 0.08, c: bleed(P(1016, 521), 2.52), z: 2.52, dur: PULL_A - CMD_COPY + 0.08, drift: true),
	Cam(t: PULL_A, c: P(215, 452), z: 1.0, dur: 0.55),                                                     // the terminal docks
	Cam(t: PULL_A + 0.55, c: P(205, 444), z: 1.02, dur: GLIDE_A - PULL_A - 0.55, drift: true),
	Cam(t: GLIDE_A, c: bleed(P(700, 252), 2.2), z: 2.2, dur: GLIDE_B - GLIDE_A),                         // up to Connected
	Cam(t: GLIDE_B, c: bleed(P(712, 254), 2.24), z: 2.24, dur: B5_A - GLIDE_B, drift: true),
	Cam(t: B5_A, c: P(735, 430), z: 1.05, dur: 0.55),                                                      // the whole page, dimmed
	Cam(t: B5_A + 0.55, c: P(735, 424), z: 1.07, dur: B5_END - B5_A - 0.55, drift: true),
	Cam(t: B5_END, c: bleed(P(600, 300), 1.45), z: 1.45, dur: 0.6),                                       // Overview
	Cam(t: B5_END + 0.6, c: bleed(P(612, 306), 1.47), z: 1.47, dur: B6_END - B5_END - 0.6, drift: true),
	Cam(t: B6_END, c: bleed(P(735, 418), 1.32), z: 1.32, dur: 0.55),                                      // API Keys: sidebar + Create key
	Cam(t: CREATE_CLICK + 0.04, c: bleed(P(735, 420), 2.0), z: 2.0, dur: 0.6),                            // the dialog
	Cam(t: SUBMIT_CLICK + 0.1, c: bleed(P(735, 418), 2.3), z: 2.3, dur: 0.45),
	Cam(t: KEY_PUSH - 0.1, c: bleed(P(706, 396), 2.6), z: 2.6, dur: 0.7),                                 // "Copy this key now."
	Cam(t: KEY_PUSH + 0.6, c: bleed(P(712, 398), 2.63), z: 2.63, dur: DLG_CLOSE - KEY_PUSH - 0.6, drift: true),
	Cam(t: DLG_CLOSE, c: bleed(P(735, 418), 1.32), z: 1.32, dur: 0.5),                                    // Requests
	Cam(t: LANDS - 0.32, c: bleed(RQ_ROWC, 2.0), z: 2.0, dur: 0.62),                                      // the top row
	Cam(t: STATUS_T - 0.32, c: bleed(P(740, RQ_TOP_ROW.midY), 2.3), z: 2.3, dur: 0.6),                   // status
	Cam(t: DUR_T - 0.3, c: bleed(P(940, RQ_TOP_ROW.midY), 2.3), z: 2.3, dur: 0.62),                      // how long it took
	Cam(t: DUR_T + 0.32, c: bleed(P(950, RQ_TOP_ROW.midY + 2), 2.33), z: 2.33, dur: B9_A - DUR_T - 0.32, drift: true),
	Cam(t: B9_A, c: P(735, 417), z: 0.55, dur: 0.55),                                                      // pull out to the ground
]
func camera(_ t: Double) -> (CGPoint, Double) {
	var c = CAMS[0].c, z = CAMS[0].z
	for k in CAMS where t >= k.t {
		let x = k.dur == 0 ? 1.0 : (t - k.t) / k.dur
		let e = k.dur == 0 ? 1.0 : (k.drift ? smooth(x) : ease2(x))
		c = lerpP(c, k.c, e); z = lerp(z, k.z, e)
	}
	return (c, z)
}
/// Two small tilt accents (degrees): the push onto the first row, and the push onto the request.
func roll(_ t: Double) -> CGFloat {
	-1.1 * CGFloat(smooth(seg(t, B1_PUSH, B1_PUSH + 0.9)) - smooth(seg(t, B1_PUSH + 1.0, B2_OUT))) +
	 0.8 * CGFloat(smooth(seg(t, LANDS - 0.3, LANDS + 0.5)) - smooth(seg(t, STATUS_T - 0.3, STATUS_T + 0.4)))
}
func toScreen(_ p: CGPoint, _ t: Double) -> CGPoint {
	let (c, z) = camera(t), r = roll(t) * .pi / 180
	let dx = (p.x - c.x) * CGFloat(z), dy = (p.y - c.y) * CGFloat(z)
	return P(960 + dx * cos(r) - dy * sin(r), 540 + dx * sin(r) + dy * cos(r))
}
func toScreen(_ rc: CGRect, _ t: Double) -> CGRect {
	let o = toScreen(rc.origin, t), z = CGFloat(camera(t).1)
	return CGRect(x: o.x, y: o.y, width: rc.width * z, height: rc.height * z)
}

// ================================================================ background: supermemory.ai's hero film
// The plate (tinted like the site, 1.1x the frame) is built by ../one-command-v2-src/make.sh from its bg/field.mp4.
let PLATE_W = 2112, PLATE_H = 1188
let PLATE_MX: Float = 96, PLATE_MY: Float = 54
let FILM_FPS = 25.0
let PLATE_BYTES = PLATE_W * PLATE_H * 3
let PLATE: (UnsafePointer<UInt8>, Int) = {
	let path = URL(fileURLWithPath: HERE.path).standardizedFileURL.deletingLastPathComponent()
		.appendingPathComponent("one-command-v2-src/bg/plate_2112x1188.rgb").path
	let fd = open(path, O_RDONLY)
	precondition(fd >= 0, "missing \(path): run ../one-command-v2-src/make.sh once")
	let size = Int(lseek(fd, 0, SEEK_END))
	let p = mmap(nil, size, PROT_READ, MAP_PRIVATE, fd, 0)!
	return (UnsafePointer(p.assumingMemoryBound(to: UInt8.self)), size / PLATE_BYTES)
}()
struct Cut { let t0: Double; let t1: Double; let f0: Double; let f1: Double; var settle = false }
/// Scene per section, cut on the section change (the music marks each one). Film times avoid the film's own cuts.
let EDL: [Cut] = [
	Cut(t0: 0, t1: B2_OUT, f0: 22.05, f1: 22.05 + B2_OUT),                   // cosmos, the site's hero
	Cut(t0: B2_OUT, t1: MORPH_A, f0: 2.1, f1: 5.9),                          // blossoms behind the sessions (0.6x)
	Cut(t0: MORPH_A, t1: B9_A, f0: 25.0, f1: 31.9),                          // cosmos, slow, at the console's edges
	Cut(t0: B9_A, t1: T_STILL, f0: 14.15, f1: 17.85, settle: true),          // mountain (film 14-18s), slowing to the still
]
let FILM_CUTS: Set<Int> = [50, 150, 250, 350, 450, 550]
func filmTime(_ t: Double) -> Double {
	for c in EDL where t < c.t1 {
		let u = max(0, t - c.t0) / (c.t1 - c.t0)
		return c.f0 + (c.f1 - c.f0) * (c.settle ? u * (2 - u) : u)
	}
	return EDL.last!.f1
}
func bgXform(_ t: Double) -> (off: CGPoint, zb: CGFloat) {
	let cam = camera(t), ce = camera(T_END)
	let k = 0.05 * CGFloat(cam.1)
	return (P(-(cam.0.x - ce.0.x) * k, -(cam.0.y - ce.0.y) * k), CGFloat(pow(cam.1 / ce.1, 0.12)))
}
let DITHER: UnsafeMutablePointer<Float> = {
	let p = UnsafeMutablePointer<Float>.allocate(capacity: 256 * 256)
	var s: UInt64 = 0x9E3779B97F4A7C15
	func r() -> Float { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return Float(s % 1_000_000) / 1_000_000 }
	for i in 0..<(256 * 256) { p[i] = (r() + r() - 1) * 1.6 }
	return p
}()
func paintBackground(_ out: UnsafeMutablePointer<UInt8>, _ t: Double) {
	let ft = filmTime(t) * FILM_FPS
	let i0 = min(PLATE.1 - 1, max(0, Int(ft.rounded(.down)))), i1 = min(PLATE.1 - 1, i0 + 1)
	let wf = FILM_CUTS.contains(i1) ? 0 : Float(ft - Double(i0))
	let fa = PLATE.0 + i0 * PLATE_BYTES, fb = PLATE.0 + i1 * PLATE_BYTES
	let (off, zb) = bgXform(t)
	let ox = Float(off.x), oy = Float(off.y), z = Float(zb), sc = Float(SC)
	let xs0 = UnsafeMutablePointer<Int>.allocate(capacity: PW), xs1 = UnsafeMutablePointer<Int>.allocate(capacity: PW)
	let wxs = UnsafeMutablePointer<Float>.allocate(capacity: PW)
	defer { xs0.deallocate(); xs1.deallocate(); wxs.deallocate() }
	for X in 0..<PW {
		let x = (Float(X) + 0.5) / sc
		let px = max(0, min(Float(PLATE_W - 1), 960 + (x - ox - 960) / z + PLATE_MX - 0.5))
		let x0 = min(Int(px), PLATE_W - 2)
		xs0[X] = x0 * 3; xs1[X] = (x0 + 1) * 3; wxs[X] = px - Float(x0)
	}
	DispatchQueue.concurrentPerform(iterations: PH) { Y in
		let y = (Float(Y) + 0.5) / sc
		let py = max(0, min(Float(PLATE_H - 1), 540 + (y - oy - 540) / z + PLATE_MY - 0.5))
		let y0 = min(Int(py), PLATE_H - 2), wy = py - Float(y0)
		let a0 = fa + y0 * PLATE_W * 3, a1 = a0 + PLATE_W * 3
		let b0 = fb + y0 * PLATE_W * 3, b1 = b0 + PLATE_W * 3
		let row = out + Y * PW * 4
		let dr = DITHER + (Y & 255) * 256
		for X in 0..<PW {
			let p = xs0[X], q = xs1[X], wx = wxs[X], n = dr[X & 255]
			let o = row + X * 4
			for ch in 0..<3 {
				let ta = Float(a0[p + ch]) + (Float(a0[q + ch]) - Float(a0[p + ch])) * wx
				let ba = Float(a1[p + ch]) + (Float(a1[q + ch]) - Float(a1[p + ch])) * wx
				let tb = Float(b0[p + ch]) + (Float(b0[q + ch]) - Float(b0[p + ch])) * wx
				let bb = Float(b1[p + ch]) + (Float(b1[q + ch]) - Float(b1[p + ch])) * wx
				let va = ta + (ba - ta) * wy, vb = tb + (bb - tb) * wy
				o[2 - ch] = UInt8(max(0, min(255, (va + (vb - va) * wf + n).rounded())))
			}
			o[3] = 255
		}
	}
}

// ================================================================ console state over time
struct NavEvent { let t: Double; let nav: Nav; let page: Page }
let NAVS: [NavEvent] = [
	NavEvent(t: -1, nav: .agents, page: .agents),            // B1's cropped card
	NavEvent(t: MORPH_A, nav: .overview, page: .overview),   // the console opens on Overview (no click: a cut inside the morph)
	NavEvent(t: NAV_AGENTS, nav: .agents, page: .agents),
	NavEvent(t: NAV_OVERVIEW, nav: .overview, page: .overview),
	NavEvent(t: NAV_KEYS, nav: .keys, page: .keys),
	NavEvent(t: NAV_REQ, nav: .requests, page: .requests),
]
let CLICKED_NAVS: [NavEvent] = Array(NAVS.dropFirst(2))
func liftK(_ t: Double, _ a: Double, _ b: Double) -> Double {
	eout(seg(t, a, a + 0.45)) * (1 - ease(seg(t, b, b + 0.34)))
}
func mcpLift(_ t: Double) -> Double { liftK(t, MCP_LIFT, MCP_DROP) }
func cliLift(_ t: Double) -> Double { liftK(t, CLI_LIFT, B5_END - 0.2) }
func onbLift(_ t: Double) -> Double { liftK(t, ONB_LIFT, B6_END - 0.3) }
func hoverK(_ t: Double, _ a: Double, _ b: Double, _ d: Double = 0.18) -> Double { ease(seg(t, a, a + d)) * (1 - ease(seg(t, b, b + d))) }

func consoleState(_ t: Double) -> ConsoleState {
	var s = ConsoleState()
	s.topBar = false                                        // never the org switcher or plan badge
	var cur = NAVS[0], prev = NAVS[0]
	for e in NAVS where t >= e.t { prev = cur; cur = e }
	s.page = cur.page
	let since = t - cur.t
	s.nav.from = prev.nav; s.nav.to = cur.nav
	s.nav.k = cur.t == MORPH_A ? 1 : seg(since, 0, 0.28)
	if cur.t > MORPH_A { s.enterT = since < 1.2 ? since : nil; s.prev = prev.page; s.prevA = 1 - seg(since, 0, 0.07) }
	if let next = CLICKED_NAVS.first(where: { $0.t > t }), next.t - t < 0.3 {
		s.nav.hover = next.nav; s.nav.hoverK = ease(seg(t, next.t - 0.28, next.t - 0.08))
	}
	// Agents
	if t < MORPH_A { s.ag.rowT = t >= B1_ROW ? t - B1_ROW : nil; s.ag.emptyText = false }
	else { s.ag.rowT = t >= ROW_LAND ? t - ROW_LAND : nil; s.ag.proof = ease(seg(t, ROW_LAND, ROW_LAND + 0.3)) }
	s.ag.names = NAME_T.map { ease(seg(t, $0, $0 + 0.16)) }
	s.ag.cmd = CopyBox(hover: hoverK(t, CMD_HOVER, CMD_COPY + 0.55), copiedT: t >= CMD_COPY ? t - CMD_COPY : nil)
	s.ag.mcp = CopyBox(hover: hoverK(t, MCP_COPY - 0.42, MCP_DROP - 0.1), copiedT: t >= MCP_COPY ? t - MCP_COPY : nil)
	s.ag.cli = CopyBox(hover: hoverK(t, CLI_HOVER - 0.05, B5_END - 0.3), copiedT: nil)
	// Keys
	s.keys.createHover = hoverK(t, CREATE_CLICK - 0.22, CREATE_CLICK + 0.1, 0.14)
	s.keys.dialogT = t >= CREATE_CLICK ? t - CREATE_CLICK : nil
	s.keys.scopedHover = hoverK(t, SCOPED_HOVER, SCOPED_HOVER + 0.55, 0.12)
	s.keys.submitHover = hoverK(t, SUBMIT_CLICK - 0.16, SUBMIT_CLICK + 0.3, 0.12)
	s.keys.createdT = t >= SUBMIT_CLICK ? t - SUBMIT_CLICK : nil
	s.keys.key = CopyBox(hover: hoverK(t, KEY_COPY - 0.16, DLG_CLOSE - 0.1, 0.12), copiedT: t >= KEY_COPY ? t - KEY_COPY : nil)
	s.keys.closeK = seg(t, DLG_CLOSE, DLG_CLOSE + 0.22)
	// Requests: the newest call is already on top when the page opens; "lands" gives it the proof edge
	s.req.newRowT = 9
	s.req.proof = ease(seg(t, LANDS, LANDS + 0.3))
	// lift-outs: hide the page copy, dim the page
	let ml = mcpLift(t), cl = cliLift(t), ol = onbLift(t)
	if ml > 0.001 { s.hidden.insert("mcp") }
	if cl > 0.001 { s.hidden.insert("cli") }
	if ol > 0.001 { s.hidden.insert("onboard") }
	s.dim = max(max(ml, cl), ol)
	return s
}

// ================================================================ terminals and windows outside the console
func typed(_ t: Double, _ times: [Double]) -> Int { times.filter { $0 <= t }.count }
func blink(_ t: Double) -> Bool { Int((t * 1.9).rounded(.down)) % 2 == 0 }

func drawB1Terminal(_ c: CGContext, _ t: Double, dx: CGFloat) {
	var s = TermState(rect: T1R.offsetBy(dx: dx, dy: 0))
	s.size = 16
	s.typed = 1
	s.caret = t < B1_KEY
	s.dim = ease(seg(t, B1_KEY, B1_KEY + 0.22))
	drawTerminal(c, s)
}
func drawSessions(_ c: CGContext, _ t: Double) {
	let texts = [TYPE1, TYPE2, TYPE3]
	for i in 0..<3 {
		let a = CARD_IN[i]
		if t < a { continue }
		let k = eout(seg(t, a, a + 0.5))
		let out = seg(t, MORPH_A, MORPH_A + 0.3)            // cards 1-2 leave as the third becomes the console
		if i == 2 && t >= MORPH_A { continue }               // the third is drawn by the morph
		var s = TermState(rect: cardRect(i).offsetBy(dx: 900 * CGFloat(1 - k), dy: 0))
		s.title = "~/acme-app"
		s.tag = "new session"
		s.prompt = ">"
		s.cmd = "i use pnpm"
		let n = typed(t, texts[i])
		s.typed = Double(n) / 10
		let typing = n < 10
		s.caret = typing ? true : blink(t - (texts[i].last ?? 0))
		let newer = (i + 1 < 3) ? eout(seg(t, CARD_IN[i + 1], CARD_IN[i + 1] + 0.4)) : 0
		s.alpha = k * (1 - 0.5 * newer) * (1 - out)
		s.size = 18
		drawTerminal(c, s)
	}
}
func drawT4(_ c: CGContext, _ t: Double) {
	let k = eout(seg(t, PULL_A + 0.05, PULL_A + 0.5))
	let out = ease(seg(t, GLIDE_A + 0.2, GLIDE_A + 0.7))
	if k <= 0.003 || out >= 0.997 { return }
	var s = TermState(rect: T4R.offsetBy(dx: -110 * CGFloat(1 - k), dy: 0))
	s.size = T4_SIZE
	s.typed = t >= FLY_B ? 1 : 0
	s.caret = t < T4_KEY
	s.dim = ease(seg(t, T4_KEY, T4_KEY + 0.22))
	s.alpha = k * (1 - out)
	drawTerminal(c, s)
}
/// The command lifts off the copy box and lands at the docked terminal's prompt.
func drawCommandFlight(_ c: CGContext, _ t: Double) {
	if t < FLY_A || t >= FLY_B + 0.02 { return }
	let k = ease(seg(t, FLY_A, FLY_B))
	let from = P(AG_CMD_BOX.minX + 12, AG_CMD_BOX.midY)
	let cw = textW("M", mono(T4_SIZE, 500))
	let to = P(T4R.minX + 24 + 2 * cw, T4R.minY + 38 + 18 + T4_SIZE * 1.7 / 2)
	var p = lerpP(from, to, k)
	p.y -= 110 * CGFloat(sin(k * .pi))
	let size = lerpC(12.5 * TS, T4_SIZE, k)
	let f = mono(size, 500)
	let s = "npx supermemory plugin"
	let r = CGRect(x: p.x - 10, y: p.y - size * 0.95, width: textW(s, f) + 20, height: size * 1.9)
	rrect(c, r, 7, fill: C_BG2, fa: 0.96, stroke: WHITE, sa: 0.16)
	ctext(c, s, f, p.x, p.y, C_TEXT, 1)
}
/// An empty browser window outline: no page, no URL, no brand. One approval press, then it folds away.
func drawBrowser(_ c: CGContext, _ t: Double) {
	if t < BROWSER_IN || t > BROWSER_OUT + 0.3 { return }
	let inK = spring(t, BROWSER_IN, freq: 2.6, zeta: 0.7), outK = ease(seg(t, BROWSER_OUT, BROWSER_OUT + 0.26))
	let sc = CGFloat(0.86 + 0.14 * inK) * CGFloat(1 - 0.08 * outK)
	let a = CGFloat(min(1, seg(t, BROWSER_IN, BROWSER_IN + 0.12))) * CGFloat(1 - outK)
	c.saveGState()
	c.translateBy(x: BRR.midX, y: BRR.midY); c.scaleBy(x: sc, y: sc); c.translateBy(x: -BRR.midX, y: -BRR.midY)
	layer(c, a) {
		rrect(c, BRR, 12, fill: C_BG, stroke: WHITE, sa: 0.14)
		for i in 0..<3 { dot(c, P(BRR.minX + 20 + CGFloat(i) * 18, BRR.minY + 19), 5.5, WHITE, 0.16) }
		rrect(c, CGRect(x: BRR.minX + 84, y: BRR.minY + 9, width: BRR.width - 104, height: 20), 10, stroke: WHITE, sa: 0.1)
		rect(c, CGRect(x: BRR.minX + 1, y: BRR.minY + 38, width: BRR.width - 2, height: 1), fill: WHITE, fa: 0.07)
		// placeholder lines and one approve button (shapes only)
		rrect(c, CGRect(x: BRR.midX - 110, y: BRR.minY + 70, width: 220, height: 9), 4.5, fill: WHITE, fa: 0.1)
		rrect(c, CGRect(x: BRR.midX - 78, y: BRR.minY + 90, width: 156, height: 9), 4.5, fill: WHITE, fa: 0.07)
		let press = bump(t, BROWSER_OK - 0.02, 0.2)
		let ok = t >= BROWSER_OK
		let br = CGRect(x: BRR.midX - 64, y: BRR.minY + 124, width: 128, height: 36)
		rrect(c, br, 9, fill: ok ? C_OK : C_ACCENT, fa: 1 - 0.2 * press)
		if ok {
			let ik = spring(t, BROWSER_OK, freq: 3.2, zeta: 0.6)
			strokeIcon(c, IC_CHECK, CGRect(x: br.midX - 10, y: br.midY - 10, width: 20, height: 20), WHITE, CGFloat(min(1, ik * 1.4)), scale: CGFloat(0.3 + 0.7 * ik), lw: 2.2)
		}
		drawRipple(c, center(br), seg(t, BROWSER_OK, BROWSER_OK + 0.45), size: 1.2)
	}
	c.restoreGState()
}

// ================================================================ the console window
struct Win { var clip: CGRect; var radius: CGFloat; var off: CGPoint; var contentA: CGFloat }
func windowAt(_ t: Double) -> Win? {
	if t < B2_OUT + 0.6 {
		let dx = -1400 * CGFloat(pow(seg(t, B2_OUT, B2_OUT + 0.55), 2))
		return Win(clip: CROP.offsetBy(dx: dx, dy: 0), radius: 12, off: P(dx, 0), contentA: 1)
	}
	if t < MORPH_A { return nil }
	let k = ease(seg(t, MORPH_A, MORPH_B))
	var w = Win(clip: lerpR(cardRect(2), PAGE, k), radius: lerpC(12, 14, k), off: .zero, contentA: CGFloat(seg(k, 0.12, 0.55)))
	let away = pow(seg(t, B9_A, B9_A + 0.5), 2)
	w.off.y = 1250 * CGFloat(away); w.clip = w.clip.offsetBy(dx: 0, dy: w.off.y)
	return away >= 1 ? nil : w
}
func drawWindow(_ c: CGContext, _ t: Double) {
	guard let w = windowAt(t) else { return }
	let p = rrPath(w.clip, w.radius)
	c.saveGState()
	c.addPath(p); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(p); c.clip()
	layer(c, w.contentA) {
		c.translateBy(x: w.off.x, y: w.off.y)
		drawConsole(c, consoleState(t))
	}
	// B3: the third session card fades out inside the growing window
	if t >= MORPH_A && t < MORPH_B {
		let k = ease(seg(t, MORPH_A, MORPH_B))
		var s = TermState(rect: cardRect(2))
		s.title = "~/acme-app"; s.tag = "new session"; s.prompt = ">"; s.cmd = "i use pnpm"; s.typed = 1; s.size = 18
		s.caret = false
		s.alpha = 1 - seg(k, 0, 0.3)
		drawTerminal(c, s)
	}
	c.restoreGState()
	c.addPath(p); c.setStrokeColor(col(WHITE, 0.12)); c.setLineWidth(1); c.strokePath()
}

// ================================================================ screen layer: lift-outs, agent input, toast
/// A lift-out: the card leaves its page position (through the camera) for a screen rect.
func drawLift(_ c: CGContext, _ t: Double, k: Double, page: CGRect, target: CGRect, _ body: (CGContext) -> Void) {
	if k <= 0.001 { return }
	let from = toScreen(page, t)
	let r = lerpR(from, target, k)
	let s = r.width / page.width
	c.saveGState()
	c.translateBy(x: r.minX, y: r.minY); c.scaleBy(x: s, y: s)
	body(c)
	c.restoreGState()
}
func liftTarget(_ size: CGSize, scale: CGFloat, cy: CGFloat) -> CGRect {
	CGRect(x: 960 - size.width * scale / 2, y: cy - size.height * scale / 2, width: size.width * scale, height: size.height * scale)
}
let MCP_T = liftTarget(AG_MCP.size, scale: 1.7, cy: 500)
let CLI_T = liftTarget(AG_CLI.size, scale: 1.7, cy: 500)
let ONB_SCALE: CGFloat = 2.4
let ONB_PAD = CGSize(width: 18, height: 24)
func onbCardSize() -> CGSize { let s = onboardSize(); return CGSize(width: s.width + 2 * ONB_PAD.width, height: 2 * ONB_PAD.height) }
let ONB_T = liftTarget(onbCardSize(), scale: ONB_SCALE, cy: 372)
func onbPageRect() -> CGRect { onboardRect().insetBy(dx: -ONB_PAD.width, dy: -(ONB_PAD.height - onboardRect().height / 2)) }
/// Screen point of a point in the lifted Onboard card's own units.
func onbScreen(_ p: CGPoint) -> CGPoint { P(ONB_T.minX + p.x * ONB_SCALE, ONB_T.minY + p.y * ONB_SCALE) }

func drawOnboardCard(_ c: CGContext, _ t: Double) {
	let size = onbCardSize()
	rrect(c, CGRect(origin: .zero, size: size), 10, fill: C_BG, stroke: WHITE, sa: 0.12)
	let hov = ease(seg(t, ONB_HOVER - 0.1, ONB_HOVER + 0.08))
	drawOnboardLine(c, P(ONB_PAD.width, size.height / 2), hover: hov)
	let tip = ease(seg(t, ONB_HOVER + 0.06, ONB_HOVER + 0.22)) * (1 - ease(seg(t, CLIP_A - 0.1, CLIP_A + 0.1)))
	drawTooltip(c, at: P(ONB_PAD.width, size.height + 6), OV_TOOLTIP_LINES, tip)
}
let AGENT_SIZE = CGSize(width: 560, height: 120), AGENT_SCALE: CGFloat = 1.6, AGENT_Y: CGFloat = 560
func drawAgentCard(_ c: CGContext, _ t: Double) {
	let a = eout(seg(t, CLIP_A - 0.2, CLIP_A + 0.2)) * (1 - ease(seg(t, B6_END - 0.3, B6_END)))
	if a <= 0.003 { return }
	var s = AgentInputState(rect: CGRect(origin: .zero, size: AGENT_SIZE))
	if t >= CLIP_B { s.text = "# You are onboarding this project to Supermemory"; s.pill = "pasted text" }
	s.caret = t < CLIP_B ? blink(t) : blink(t - CLIP_B)
	s.alpha = a
	c.saveGState()
	c.translateBy(x: 960 - AGENT_SIZE.width * AGENT_SCALE / 2, y: AGENT_Y + 14 * CGFloat(1 - a)); c.scaleBy(x: AGENT_SCALE, y: AGENT_SCALE)
	drawAgentInput(c, s)
	c.restoreGState()
}
/// The copied prompt travels from the Onboard line into the agent input.
func drawClipFlight(_ c: CGContext, _ t: Double) {
	if t < CLIP_A || t >= CLIP_B + 0.02 { return }
	let k = ease(seg(t, CLIP_A, CLIP_B))
	let from = onbScreen(P(ONB_PAD.width + 120, onbCardSize().height / 2))
	let to = P(960 - AGENT_SIZE.width * AGENT_SCALE / 2 + 150 * AGENT_SCALE, AGENT_Y + 30 * AGENT_SCALE)
	var p = lerpP(from, to, k)
	p.y -= 70 * CGFloat(sin(k * .pi))
	let f = mono(19, 500)
	let s = "setup prompt"
	let w = 16 + 18 + 8 + textW(s, f) + 16
	let r = CGRect(x: p.x - w / 2, y: p.y - 21, width: w, height: 42)
	rrect(c, r, 10, fill: C_FLOAT, fa: 0.97, stroke: WHITE, sa: 0.16)
	icon(c, IC_COPY, r.minX + 16 + 9, r.midY, 18, C_TEXT2, 1)
	ctext(c, s, f, r.minX + 16 + 18 + 8, r.midY, C_TEXT, 1)
}
func drawScreenToast(_ c: CGContext, _ t: Double) {
	let k = eout(seg(t, ONB_CLICK + 0.05, ONB_CLICK + 0.35)) * (1 - ease(seg(t, B6_END - 0.45, B6_END - 0.15)))
	if k <= 0.003 { return }
	let sc: CGFloat = 1.5
	let f = ui(13, 500)
	let w = (16 + 16 * TS + 10 + textW(TOAST_COPIED, f) + 18) * sc
	c.saveGState()
	c.translateBy(x: 1920 - 56 - w - (MAIN_R - (MAIN_R - w / sc)) * sc + (MAIN_R - w / sc) * 0, y: 0)
	c.restoreGState()
	// drawToast positions itself at the page's bottom right; map that corner to the screen's
	c.saveGState()
	let pageX = MAIN_R, pageY = PAGE.height - 24
	c.translateBy(x: 1920 - 56 - pageX * sc, y: 1080 - 168 - pageY * sc)
	c.scaleBy(x: sc, y: sc)
	drawToast(c, TOAST_COPIED, k)
	c.restoreGState()
}

// ================================================================ cursor
struct CK { let t: Double; let d: Double; let at: (Double) -> CGPoint }    // arrive at `at` by t, moving for d
func onWorld(_ p: CGPoint) -> (Double) -> CGPoint { { toScreen(p, $0) } }
func onLift(_ target: CGRect, _ page: CGRect, _ p: CGPoint) -> (Double) -> CGPoint {
	{ _ in P(target.minX + (p.x - page.minX) * target.width / page.width, target.minY + (p.y - page.minY) * target.height / page.height) }
}
func navPt(_ n: Nav) -> CGPoint { P(navRect(n).minX + 64, navRect(n).midY + 2) }
let DLG_TOP = DLG_CY - DLG_FORM_H / 2
let SCOPED_PT = P(DLG_SCOPED.midX + 6, DLG_SCOPED.midY + 3)
let SUBMIT_PT = P(DLG_SUBMIT.midX + 10, DLG_SUBMIT.midY + 3)
let KEYCOPY_PT = P(DLG_KEYCOPY.midX + 1, DLG_KEYCOPY.midY + 2)
let CURSOR: [CK] = [
	// B3: in from the right, click Agents & MCP, rest
	CK(t: NAV_AGENTS - 0.8, d: 0, at: onWorld(P(760, 560))),
	CK(t: NAV_AGENTS, d: 0.62, at: onWorld(navPt(.agents))),
	CK(t: CMD_PAN, d: 0, at: onWorld(navPt(.agents))),
	// B4: onto the command box with the camera, copy
	CK(t: CMD_COPY, d: CMD_COPY - CMD_PAN, at: onWorld(P(copyIconCenter(AG_CMD_BOX).x + 1, copyIconCenter(AG_CMD_BOX).y + 2))),
	// B5: the MCP URL box on the lifted card, then the CLI box
	CK(t: MCP_COPY - 0.5, d: 0, at: onLift(MCP_T, AG_MCP, P(AG_MCP.midX + 380, AG_MCP.maxY + 60))),
	CK(t: MCP_COPY, d: 0.42, at: onLift(MCP_T, AG_MCP, copyIconCenter(AG_MCP_BOX))),
	CK(t: CLI_HOVER - 0.02, d: 0.36, at: onLift(CLI_T, AG_CLI, copyIconCenter(AG_CLI_BOX))),
	// B6: Overview in the sidebar, then the lifted Onboard line
	CK(t: B5_END + 0.25, d: 0.5, at: onWorld(P(520, 420))),
	CK(t: NAV_OVERVIEW, d: 0.45, at: onWorld(navPt(.overview))),
	CK(t: ONB_HOVER - 0.02, d: 0.5, at: { _ in onbScreen(P(ONB_PAD.width + 150, onbCardSize().height / 2 + 4)) }),
	CK(t: ONB_CLICK, d: 0.1, at: { _ in onbScreen(P(ONB_PAD.width + 156, onbCardSize().height / 2 + 4)) }),
	// B7: API Keys, Create key, hover Scoped, Create, copy
	CK(t: NAV_KEYS, d: 0.48, at: onWorld(navPt(.keys))),
	CK(t: CREATE_CLICK, d: 0.62, at: onWorld(P(keysCreateButton().midX + 8, keysCreateButton().midY + 3))),
	CK(t: SCOPED_HOVER + 0.02, d: 0.5, at: onWorld(SCOPED_PT)),
	CK(t: SUBMIT_CLICK, d: 0.26, at: onWorld(SUBMIT_PT)),
	CK(t: KEY_COPY, d: 0.24, at: onWorld(KEYCOPY_PT)),
	// B8: Requests, then out of the way of the row
	CK(t: NAV_REQ, d: 0.5, at: onWorld(navPt(.requests))),
	CK(t: LANDS - 0.1, d: 0.5, at: onWorld(P(1180, 560))),
]
/// When the cursor is on screen (fade 0.15s at each end).
let CURSOR_ON: [(Double, Double)] = [(NAV_AGENTS - 0.75, NAV_AGENTS + 0.9), (CMD_PAN + 0.05, FLY_A), (MCP_COPY - 0.5, B5_END + 0.05), (B5_END + 0.1, CLIP_A - 0.05),
                                     (B6_END - 0.25, LANDS + 0.25)]
let PRESSES: [Double] = [NAV_AGENTS, CMD_COPY, MCP_COPY, NAV_OVERVIEW, ONB_CLICK, NAV_KEYS, CREATE_CLICK, SUBMIT_CLICK, KEY_COPY, NAV_REQ]
func cursorAlpha(_ t: Double) -> CGFloat {
	var a = 0.0
	for (s, e) in CURSOR_ON { a = max(a, seg(t, s, s + 0.15) * (1 - seg(t, e - 0.15, e))) }
	return CGFloat(a)
}
func cursorPos(_ t: Double) -> CGPoint {
	var prev = CURSOR[0]
	for k in CURSOR {
		if t < k.t {
			let start = k.t - k.d
			if t <= start || k.d == 0 { return prev.at(t) }
			let u = ease(seg(t, start, k.t))
			let a = prev.at(t), b = k.at(t)
			var p = lerpP(a, b, u)
			// a slight arc, like a hand
			let dx = b.x - a.x, dy = b.y - a.y, len = max(1, hypot(dx, dy))
			let bow = 0.07 * len * CGFloat(sin(u * .pi))
			p.x += -dy / len * bow; p.y += dx / len * bow
			return p
		}
		prev = k
	}
	return prev.at(t)
}
func drawCursorLayer(_ c: CGContext, _ t: Double) {
	let a = cursorAlpha(t)
	for pt in PRESSES where pt != SUBMIT_CLICK { drawRipple(c, cursorPos(pt), seg(t, pt, pt + 0.45), size: 1.3) }   // the dialog itself answers that click
	if a <= 0.003 { return }
	var press: CGFloat = 0
	for pt in PRESSES { press = max(press, bump(t, pt - 0.05, 0.16)) }
	drawCursor(c, cursorPos(t), a, press: press, size: 1.3)
}

// ================================================================ HUD, URL chip, captions, thesis, end
let HUD_TEXT = "01 / 03 · connect", CHIP_TEXT = "next: part 2 · remember"
func pill(_ c: CGContext, _ s: String, _ f: CTFont, center p: CGPoint, a: CGFloat, padX: CGFloat = 16, h: CGFloat = 40, fill: UInt32 = C_BG2, fa: CGFloat = 0.86) -> CGRect {
	let w = textW(s, f, track: 0.4) + 2 * padX
	let r = CGRect(x: p.x - w / 2, y: p.y - h / 2, width: w, height: h)
	rrect(c, r, h / 2, fill: fill, fa: fa * a, stroke: WHITE, sa: 0.16 * a)
	ctext(c, s, f, r.minX + padX, p.y, C_TEXT, a, track: 0.4)
	return r
}
func drawHUDandChip(_ c: CGContext, _ t: Double) {
	let k = ease(seg(t, CHIP_A, CHIP_A + 0.55))
	let gone = ease(seg(t, LOCK_A, LOCK_A + 0.32))
	if gone >= 0.997 { return }
	let f0 = mono(17, 500), f1 = mono(30, 500)
	let w0 = textW(HUD_TEXT, f0, track: 0.4) + 32
	let p0 = P(1920 - 48 - w0 / 2, 52), p1 = P(960, 520)
	let p = lerpP(p0, p1, k)
	let a = CGFloat(1 - gone)
	c.saveGState()
	c.translateBy(x: p.x, y: p.y)
	let sc = 1 + 0.06 * bump(t, CHIP_A + 0.45, 0.3) - 0.12 * CGFloat(gone)
	c.scaleBy(x: sc, y: sc)
	layer(c, a * CGFloat(1 - seg(k, 0.2, 0.55))) { _ = pill(c, HUD_TEXT, f0, center: .zero, a: 1, h: 38) }
	layer(c, a * CGFloat(seg(k, 0.35, 0.75))) { _ = pill(c, CHIP_TEXT, f1, center: .zero, a: 1, padX: 32, h: 72) }
	c.restoreGState()
}
func drawLockupEnd(_ c: CGContext, _ t: Double) {
	let k = eout(seg(t, LOCK_A + 0.08, LOCK_A + 0.55))
	if k <= 0.003 { return }
	let markH: CGFloat = 70
	let s = markH / CGFloat(G_MH)
	let total = (CGFloat(G_MW) + CGFloat(G_GAP) + CGFloat(G_WW)) * s
	let a = CGFloat(min(1, k * 1.2))
	let dy = 16 * CGFloat(1 - k)
	drawLockup(c, x: 960 - total / 2, y: 470 - markH / 2 + dy, markH: markH, color: WHITE, a: a)
	let uk = eout(seg(t, LOCK_A + 0.2, LOCK_A + 0.62))
	ctext(c, "console.supermemory.ai", mono(26, 500), 960, 566 + 10 * CGFloat(1 - uk), WHITE, 0.82 * CGFloat(uk), .center, track: 0.3)
}
func drawURLChipLayer(_ c: CGContext, _ t: Double) {
	let a = seg(t, MORPH_B - 0.15, MORPH_B + 0.15) * (1 - seg(t, NAV_AGENTS + 1.1, NAV_AGENTS + 1.4))
	if a <= 0.003 { return }
	c.saveGState()
	c.translateBy(x: 960, y: 54 - 6 * CGFloat(1 - eout(seg(t, MORPH_B - 0.15, MORPH_B + 0.25)))); c.scaleBy(x: 1.55, y: 1.55)
	drawURLChip(c, .zero, CGFloat(a))
	c.restoreGState()
}
// captions: one line, bottom band, words brighten as they are spoken
let CAP_F = sans(40, 520)
func capWords(_ ci: Int) -> [(CapTok, Double)] { [] }
func drawCaptions(_ c: CGContext, _ t: Double) {
	if !CAPTIONS_ON { return }
	for L in CAPS where L.burn {
		let ons = VO_AON[L.line], offs = VO_OFF[L.line]
		for (ci, ch) in L.chunks.enumerated() {
			let a0 = ons[ch.first!.w0] - 0.12
			var a1 = offs[ch.last!.w1] + 0.3
			if ci + 1 < L.chunks.count { a1 = min(a1, ons[L.chunks[ci + 1].first!.w0] - 0.12) }
			else if L.line + 1 < VO_AON.count { a1 = min(a1, VO_AON[L.line + 1][0] - 0.12) }
			if t < a0 || t > a1 + 0.1 { continue }
			let ca = CGFloat(seg(t, a0, a0 + 0.1) * (1 - seg(t, a1, a1 + 0.1)))
			let space = textW(" ", CAP_F)
			let widths = ch.map { textW($0.text, CAP_F) }
			let total = widths.reduce(0, +) + space * CGFloat(ch.count - 1)
			let r = CGRect(x: 960 - total / 2 - 24, y: 986 - 30, width: total + 48, height: 60)
			rrect(c, r, 14, fill: 0x07090c, fa: 0.66 * ca)
			var x = 960 - total / 2
			for (k, tok) in ch.enumerated() {
				let spoken = ease(seg(t, hitAt(ons[tok.w0]), hitAt(ons[tok.w0]) + 0.08))
				ctext(c, tok.text, CAP_F, x, 986, WHITE, ca * CGFloat(0.5 + 0.5 * spoken))
				x += widths[k] + space
			}
		}
	}
}
// the thesis: each word sets on the frame it is spoken; "pnpm" types itself on P N P M
let THESIS_F = sans(78, 600)
func drawThesis(_ c: CGContext, _ t: Double) {
	if t < VO_AON[8][0] - 0.3 || t > THESIS_CLEAR + 0.4 { return }
	let words: [(String, Int)] = [("new", 0), ("session,", 1), ("it", 2), ("already", 3), ("knows", 4), ("you", 5), ("use", 6)]
	let letters: [(String, Int)] = [("p", 7), ("n", 8), ("p", 9), ("m", 10)]
	let sp = textW(" ", THESIS_F, track: -2)
	let total = words.map { textW($0.0, THESIS_F, track: -2) }.reduce(0, +) + sp * CGFloat(words.count) + textW("pnpm", THESIS_F, track: -2)
	let clear = ease(seg(t, THESIS_CLEAR, THESIS_CLEAR + 0.3))
	var x = 960 - total / 2
	let y: CGFloat = 520 - 20 * CGFloat(clear)
	for (s, i) in words {
		let k = eout(seg(t, hit(9, i), hit(9, i) + 0.22))
		text(c, s, THESIS_F, x, y + 26 + 14 * CGFloat(1 - k), WHITE, CGFloat(k) * CGFloat(1 - clear), track: -2)
		x += textW(s, THESIS_F, track: -2) + sp
	}
	for (s, i) in letters {
		let k = eout(seg(t, hit(9, i), hit(9, i) + 0.14))
		text(c, s, THESIS_F, x, y + 26 + 8 * CGFloat(1 - k), WHITE, CGFloat(k) * CGFloat(1 - clear), track: -2)
		x += textW(s, THESIS_F, track: -2)
	}
}

// ================================================================ frame
func renderScene(_ c: CGContext, _ t: Double) {
	let (cc, z) = camera(t)
	c.saveGState()
	c.translateBy(x: 960, y: 540); c.rotate(by: roll(t) * .pi / 180); c.scaleBy(x: CGFloat(z), y: CGFloat(z)); c.translateBy(x: -cc.x, y: -cc.y)
	// world
	if t < B2_OUT + 0.6 { drawB1Terminal(c, t, dx: -1400 * CGFloat(pow(seg(t, B2_OUT, B2_OUT + 0.55), 2))) }
	drawSessions(c, t)
	drawT4(c, t)
	drawBrowser(c, t)
	drawWindow(c, t)
	drawCommandFlight(c, t)
	c.restoreGState()
	// screen
	drawLift(c, t, k: mcpLift(t), page: AG_MCP, target: MCP_T) { drawMCPCard($0, .zero, consoleState(t).ag.mcp) }
	drawLift(c, t, k: cliLift(t), page: AG_CLI, target: CLI_T) { drawCLICard($0, .zero, consoleState(t).ag.cli) }
	drawLift(c, t, k: onbLift(t), page: onbPageRect(), target: ONB_T) { drawOnboardCard($0, t) }
	drawAgentCard(c, t)
	drawClipFlight(c, t)
	drawScreenToast(c, t)
	drawURLChipLayer(c, t)
	drawCursorLayer(c, t)
	drawThesis(c, t)
	drawCaptions(c, t)
	drawHUDandChip(c, t)
	drawLockupEnd(c, t)
}

func frameContext(_ data: UnsafeMutableRawPointer?) -> CGContext { makeContext(1920, 1080, scale: SC, data: data) }
func renderFrame(_ i: Int, into out: UnsafeMutablePointer<UInt8>) {
	let n = PW * PH * 4
	let t0 = min(Double(i) / FPS, T_STILL)
	let bg = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { bg.deallocate() }
	paintBackground(bg, t0)
	if t0 >= T_STILL || SUBFRAMES == 1 { memcpy(out, bg, n); renderScene(frameContext(out), t0); return }
	let acc = UnsafeMutablePointer<UInt16>.allocate(capacity: n); acc.initialize(repeating: 0, count: n)
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { acc.deallocate(); buf.deallocate() }
	for k in 0..<SUBFRAMES {
		let t = t0 + (Double(k) / Double(SUBFRAMES - 1) - 0.5) * SHUTTER / FPS
		memcpy(buf, bg, n)
		renderScene(frameContext(buf), max(0, t))
		DispatchQueue.concurrentPerform(iterations: 32) { q in
			for p in (q * n / 32)..<((q + 1) * n / 32) { acc[p] &+= UInt16(buf[p]) }
		}
	}
	let half = UInt16(SUBFRAMES / 2)
	DispatchQueue.concurrentPerform(iterations: 32) { q in
		for p in (q * n / 32)..<((q + 1) * n / 32) { out[p] = UInt8((acc[p] + half) / UInt16(SUBFRAMES)) }
	}
}

// ================================================================ main
let args = Array(CommandLine.arguments.dropFirst())
if args.first == "stills" {
	try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("stills"), withIntermediateDirectories: true)
	let times = args.dropFirst().compactMap(Double.init)
	var imgs: [CGImage] = []
	for t in times {
		let mem = UnsafeMutablePointer<UInt8>.allocate(capacity: PW * PH * 4)
		renderFrame(Int((t * FPS).rounded()), into: mem)
		let img = frameContext(mem).makeImage()!
		imgs.append(img)
		writePNG(img, HERE.appendingPathComponent(String(format: "stills/t_%05.2f.png", t)))
		mem.deallocate()
	}
	let cols = 3, tw = 640, th = 360
	let rows = (imgs.count + cols - 1) / cols
	let sw = cols * tw + (cols + 1) * 12, sh = rows * (th + 30) + 12
	let s = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	s.interpolationQuality = .high
	s.setFillColor(col(0xd8d8dc)); s.fill(CGRect(x: 0, y: 0, width: sw, height: sh))
	for (i, img) in imgs.enumerated() {
		let x = 12 + (i % cols) * (tw + 12), y = sh - (12 + (i / cols) * (th + 30) + th)
		s.draw(img, in: CGRect(x: x, y: y, width: tw, height: th))
		s.textPosition = CGPoint(x: CGFloat(x), y: CGFloat(y - 20)); CTLineDraw(ctline(String(format: "%.2fs", times[i]), mono(16), col(INK)), s)
	}
	writePNG(s.makeImage()!, HERE.appendingPathComponent("stills/sheet.png"))
	print("wrote \(imgs.count) stills + sheet")
} else if args.first == "raw" {
	let total = Int((T_END * FPS).rounded())
	let n = PW * PH * 4
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	let out = FileHandle.standardOutput
	var hold: Data? = nil
	for i in 0..<total {
		if Double(i) / FPS >= T_STILL {
			if hold == nil { renderFrame(i, into: buf); hold = Data(bytes: buf, count: n) }
			out.write(hold!)
		} else {
			renderFrame(i, into: buf)
			out.write(Data(bytesNoCopy: buf, count: n, deallocator: .none))
		}
		if i % 30 == 0 { FileHandle.standardError.write("\r\(i)/\(total)".data(using: .utf8)!) }
	}
	FileHandle.standardError.write("\n".data(using: .utf8)!)
} else if args.first == "events" {
	// everything the mix lays a sound on, on the film clock
	var ev: [[String: Any]] = []
	func add(_ t: Double, _ kind: String, _ note: String) {
		let at = kind == "hit" ? t : t + SFX_LAG          // a sound's sharp onset lands 2 frames after its visual contact
		ev.append(["t": (at * 10000).rounded() / 10000, "kind": kind, "note": note, "visual": (t * 10000).rounded() / 10000])
	}
	add(B1_KEY, "key_enter", "B1 Enter"); add(B1_ROW, "tick", "B1 row lands")
	for (i, ts) in [TYPE1, TYPE2, TYPE3].enumerated() { for x in ts { add(x, "key", "B2 card \(i + 1) types") } }
	add(NAV_AGENTS, "click", "Agents & MCP"); add(CMD_COPY, "copy", "copy plugin command"); add(T4_KEY, "key_enter", "B4 Enter")
	add(BROWSER_OK, "click", "browser approve"); add(ROW_LAND, "tick", "B4 row lands (proof)")
	add(MCP_COPY, "copy", "copy MCP URL"); add(NAV_OVERVIEW, "click", "Overview"); add(ONB_CLICK, "copy", "copy setup prompt")
	add(NAV_KEYS, "click", "API Keys"); add(CREATE_CLICK, "click", "Create key"); add(SUBMIT_CLICK, "click", "dialog Create key")
	add(KEY_COPY, "copy", "copy key"); add(NAV_REQ, "click", "Requests"); add(LANDS, "tick", "request row proof")
	let hits: [(Double, String)] = [(B2_OUT, "sessions"), (MORPH_A, "console opens"), (B9_A, "thesis"), (LOCK_A, "lockup")]
	for (t, n) in hits { add(t, "hit", n) }
	let doc: [String: Any] = ["t_still": T_STILL, "t_end": T_END, "events": ev.sorted { ($0["t"] as! Double) < ($1["t"] as! Double) },
	                          "grid": ["t0": MORPH_A, "bar": BAR, "drop": hit(9, 0), "sessions": B2_OUT, "pull": B9_A, "lock": LOCK_A]]
	let data = try! JSONSerialization.data(withJSONObject: doc, options: [.prettyPrinted, .sortedKeys])
	FileHandle.standardOutput.write(data)
} else if args.first == "times" {
	for (n, v) in [("B1_ROW", B1_ROW), ("B2_OUT", B2_OUT), ("MORPH_A", MORPH_A), ("NAV_AGENTS", NAV_AGENTS), ("PLUGIN_PUSH", PLUGIN_PUSH),
	               ("CMD_HOVER", CMD_HOVER), ("CMD_COPY", CMD_COPY), ("FLY_B", FLY_B), ("T4_KEY", T4_KEY), ("BROWSER_IN", BROWSER_IN),
	               ("BROWSER_OK", BROWSER_OK), ("GLIDE_A", GLIDE_A), ("GLIDE_B", GLIDE_B), ("ROW_LAND", ROW_LAND), ("B5_A", B5_A),
	               ("MCP_LIFT", MCP_LIFT), ("MCP_COPY", MCP_COPY), ("MCP_DROP", MCP_DROP), ("CLI_LIFT", CLI_LIFT), ("B5_END", B5_END),
	               ("NAV_OVERVIEW", NAV_OVERVIEW), ("ONB_LIFT", ONB_LIFT), ("ONB_HOVER", ONB_HOVER), ("ONB_CLICK", ONB_CLICK),
	               ("CLIP_A", CLIP_A), ("CLIP_B", CLIP_B), ("B6_END", B6_END), ("NAV_KEYS", NAV_KEYS), ("CREATE_CLICK", CREATE_CLICK),
	               ("SCOPED_HOVER", SCOPED_HOVER), ("SUBMIT_CLICK", SUBMIT_CLICK), ("KEY_COPY", KEY_COPY), ("KEY_PUSH", KEY_PUSH),
	               ("DLG_CLOSE", DLG_CLOSE), ("NAV_REQ", NAV_REQ), ("LANDS", LANDS), ("STATUS_T", STATUS_T), ("DUR_T", DUR_T),
	               ("B9_A", B9_A), ("THESIS_CLEAR", THESIS_CLEAR), ("CHIP_A", CHIP_A), ("LOCK_A", LOCK_A), ("T_STILL", T_STILL), ("T_END", T_END)] {
		print(String(format: "%-14@ %7.3f", n as NSString, v))
	}
}
