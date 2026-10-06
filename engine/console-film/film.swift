// ================================================================ output scale: 2 = 3840x2160 master (design space stays 1920x1080)
let SC: CGFloat = CGFloat(Double(ProcessInfo.processInfo.environment["SCALE"] ?? "2") ?? 2)
let PW = Int(1920 * SC), PH = Int(1080 * SC)

// ================================================================ the console, rebuilt from the live page's spec
// console.supermemory.ai/agents, measured 2026-10-05 (getBoundingClientRect + computed styles + the icons' SVG paths).
// Coordinates are the card's css px. Everything is vector, so it stays sharp at any zoom.
let C_BG: UInt32 = 0x0a0a0a, C_BG2: UInt32 = 0x101010, C_MUTED: UInt32 = 0x121212
let C_TEXT: UInt32 = 0xf5f5f5, C_TEXT2: UInt32 = 0xa2a2a2, C_ICON: UInt32 = 0x838383
let C_PILL_BG: UInt32 = 0x0d131a, C_PILL_BORDER: UInt32 = 0x1e3973, C_CHECK: UInt32 = 0x4fb877
let BORDER_A: CGFloat = 0.07

func mix(_ a: UInt32, _ b: UInt32, _ k: Double) -> UInt32 {
	let kk = max(0, min(1, k))
	func ch(_ v: UInt32, _ s: UInt32) -> Double { Double((v >> s) & 255) }
	let r = UInt32(lerp(ch(a, 16), ch(b, 16), kk).rounded()), g = UInt32(lerp(ch(a, 8), ch(b, 8), kk).rounded()), bl = UInt32(lerp(ch(a, 0), ch(b, 0), kk).rounded())
	return (r << 16) | (g << 8) | bl
}
/// Text positioned by its CSS line box (top + line-height), like the browser lays it out.
func cssText(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ top: CGFloat, _ lh: CGFloat, _ color: UInt32, _ a: CGFloat, _ al: Align = .left) {
	let asc = CTFontGetAscent(f), desc = CTFontGetDescent(f)
	text(c, s, f, x, top + (lh - (asc + desc)) / 2 + asc, color, a, al)
}
func cssBase(_ f: CTFont, _ top: CGFloat, _ lh: CGFloat) -> CGFloat {
	let asc = CTFontGetAscent(f), desc = CTFontGetDescent(f)
	return top + (lh - (asc + desc)) / 2 + asc
}
var truncCache: [String: String] = [:]
let truncLock = NSLock()
func truncated(_ s: String, _ f: CTFont, _ maxW: CGFloat) -> String {
	let key = s + "|\(CTFontGetSize(f))"
	truncLock.lock(); if let v = truncCache[key] { truncLock.unlock(); return v }; truncLock.unlock()
	var out = s
	if textW(s, f) > maxW {
		var t = s
		while !t.isEmpty && textW(t + "…", f) > maxW { t.removeLast() }
		out = t + "…"
	}
	truncLock.lock(); truncCache[key] = out; truncLock.unlock()
	return out
}

// ---- icons (the page's own SVG paths, 24-unit viewBox, 1.5 stroke)
func svgPath(_ d: String) -> CGPath {
	var tokens: [String] = []
	var cur = ""
	for ch in d {
		if ch.isLetter { if !cur.isEmpty { tokens.append(cur); cur = "" }; tokens.append(String(ch)) }
		else if ch == " " || ch == "," { if !cur.isEmpty { tokens.append(cur); cur = "" } }
		else if ch == "-" { if !cur.isEmpty { tokens.append(cur) }; cur = "-" }
		else if ch == "." && cur.contains(".") { tokens.append(cur); cur = "." }
		else { cur.append(ch) }
	}
	if !cur.isEmpty { tokens.append(cur) }
	let p = CGMutablePath()
	var i = 0, cmd = "M", pt = CGPoint.zero
	func num() -> CGFloat { let v = CGFloat(Double(tokens[i]) ?? 0); i += 1; return v }
	while i < tokens.count {
		if let f = tokens[i].first, f.isLetter {
			cmd = tokens[i]; i += 1
			if cmd == "Z" || cmd == "z" { p.closeSubpath(); continue }
		}
		switch cmd {
		case "M": pt = CGPoint(x: num(), y: num()); p.move(to: pt); cmd = "L"
		case "L": pt = CGPoint(x: num(), y: num()); p.addLine(to: pt)
		case "H": pt.x = num(); p.addLine(to: pt)
		case "V": pt.y = num(); p.addLine(to: pt)
		case "C":
			let c1 = CGPoint(x: num(), y: num()), c2 = CGPoint(x: num(), y: num())
			pt = CGPoint(x: num(), y: num()); p.addCurve(to: pt, control1: c1, control2: c2)
		default: i += 1
		}
	}
	return p
}
let ICON_COPY = [
	svgPath("M9 15C9 12.1716 9 10.7574 9.87868 9.87868C10.7574 9 12.1716 9 15 9L16 9C18.8284 9 20.2426 9 21.1213 9.87868C22 10.7574 22 12.1716 22 15V16C22 18.8284 22 20.2426 21.1213 21.1213C20.2426 22 18.8284 22 16 22H15C12.1716 22 10.7574 22 9.87868 21.1213C9 20.2426 9 18.8284 9 16L9 15Z"),
	svgPath("M16.9999 9C16.9975 6.04291 16.9528 4.51121 16.092 3.46243C15.9258 3.25989 15.7401 3.07418 15.5376 2.90796C14.4312 2 12.7875 2 9.5 2C6.21252 2 4.56878 2 3.46243 2.90796C3.25989 3.07417 3.07418 3.25989 2.90796 3.46243C2 4.56878 2 6.21252 2 9.5C2 12.7875 2 14.4312 2.90796 15.5376C3.07417 15.7401 3.25989 15.9258 3.46243 16.092C4.51121 16.9528 6.04291 16.9975 9 16.9999"),
]
let ICON_CHECK = [svgPath("M5 14L8.5 17.5L19 6.5")]
let ICON_ARROW = [svgPath("M9 6.65032C9 6.65032 15.9383 6.10759 16.9154 7.08463C17.8924 8.06167 17.3496 15 17.3496 15M16.5 7.5L6.5 17.5")]
func strokeIcon(_ c: CGContext, _ paths: [CGPath], _ r: CGRect, _ color: UInt32, _ a: CGFloat, scale: CGFloat = 1) {
	if a <= 0.003 || scale <= 0.01 { return }
	c.saveGState()
	c.translateBy(x: r.midX, y: r.midY); c.scaleBy(x: r.width / 24 * scale, y: r.height / 24 * scale); c.translateBy(x: -12, y: -12)
	c.setStrokeColor(col(color, a)); c.setLineWidth(1.5); c.setLineCap(.round); c.setLineJoin(.round)
	for p in paths { c.addPath(p) }
	c.strokePath()
	c.restoreGState()
}

// ---- the eight agent pills: the page's layout rules (11px padding, 7px icon gap, 6px between pills), re-packed at
// the larger type so all eight still fit inside the card
let US: CGFloat = 1.12      // console type, icons and row heights set 12% larger than the page for legibility; widths unchanged
struct Pill { let name: String; let x: CGFloat; let w: CGFloat; let icon: CGRect; let logo: Logo }
let PILLS: [Pill] = {
	let defs: [(String, CGFloat, CGFloat, String, Bool)] = [
		("Claude Code", 14, 14, "claude-code", false), ("Cursor", 14, 14, "cursor", true), ("Codex", 14, 14, "codex", true),
		("OpenCode", 11.2, 14, "opencode", true), ("Muse Code", 14, 14, "muse-code", false), ("AmpCode", 24.92, 11, "ampcode", true),
		("OpenClaw", 14, 14, "openclaw", false), ("Hermes", 14, 14, "hermes", false)]
	var x: CGFloat = 13, out: [Pill] = []
	for (name, iw, ih, file, mono) in defs {
		let tw = textW(name, sans(12.5 * US, 500))
		let w = 29 * US + iw * US + tw
		let icon = CGRect(x: x + 11 * US, y: 147 * US - ih * US / 2, width: iw * US, height: ih * US)
		out.append(Pill(name: name, x: x, w: w, icon: icon, logo: loadLogo(file, mono: mono)))
		x += w + 6 * US
	}
	return out
}()
func drawLogoIn(_ c: CGContext, _ l: Logo, _ r: CGRect, _ tint: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	let iw = CGFloat(l.img.width), ih = CGFloat(l.img.height)
	let k = min(r.width / iw, r.height / ih)
	let rr = CGRect(x: r.midX - iw * k / 2, y: r.midY - ih * k / 2, width: iw * k, height: ih * k)
	if l.mono { paintMask(c, l.mask, rr, tint, a) } else { drawImg(c, l.img, rr, a) }
}

// ---- tabs and their steps (text exactly as the console shows it)
struct Row { let y: CGFloat; let h: CGFloat; let label: String; let sub: String?; let cmd: String }
struct TabDef { let pill: Int; let docs: String; let rows: [Row] }
let TABS: [TabDef] = [
	TabDef(pill: 0, docs: "Claude Code docs", rows: [
		Row(y: 173, h: 57.75, label: "1. Add the marketplace", sub: nil, cmd: "/plugin marketplace add supermemoryai/claude-supermemory"),
		Row(y: 230.75, h: 64, label: "2. Install", sub: "Restart Claude Code and it opens your browser to sign in.", cmd: "/plugin install supermemory")]),
	TabDef(pill: 1, docs: "Cursor docs", rows: [
		Row(y: 173, h: 57.75, label: "1. Install", sub: nil, cmd: "/add-plugin cursor-supermemory"),
		Row(y: 230.75, h: 57.75, label: "2. Sign in", sub: nil, cmd: "/supermemory-setup")]),
	TabDef(pill: 2, docs: "Codex docs", rows: [
		Row(y: 173, h: 57.75, label: "1. Install", sub: nil, cmd: "npx codex-supermemory@latest install"),
		Row(y: 230.75, h: 57.75, label: "2. Sign in", sub: nil, cmd: "/supermemory-login")]),
	TabDef(pill: 3, docs: "OpenCode docs", rows: [
		Row(y: 173, h: 57.75, label: "1. Install", sub: nil, cmd: "bunx opencode-supermemory@latest install"),
		Row(y: 230.75, h: 57.75, label: "2. Sign in", sub: nil, cmd: "bunx opencode-supermemory@latest login")]),
	TabDef(pill: 4, docs: "Muse Code docs", rows: [
		Row(y: 173, h: 64, label: "1. Add the marketplace", sub: "Requires Muse Code 1.3+ with MUSE_EXPERIMENTAL_PLUGINS=1.", cmd: "muse plugins marketplace add supermemory https://github.com/supermemoryai/muse-supermemory"),
		Row(y: 237, h: 57.75, label: "2. Install", sub: nil, cmd: "muse plugins install supermemory@supermemory"),
		Row(y: 294.75, h: 64, label: "3. Approve", sub: "Restart Muse Code and it opens your browser to sign in.", cmd: "muse plugins approve supermemory")]),
]
func tabHeight(_ i: Int) -> CGFloat { let r = TABS[i].rows.last!; return (r.y + r.h) * US + 1.25 }
let CMD = CGRect(x: 503, y: 72.13 * US, width: 460, height: 32.75 * US)
func boxY(_ r: Row) -> CGFloat { r.y * US + 1 + (r.h * US - 1 - 32.75 * US) / 2 }
let COPY_ICON = CGRect(x: 963 - 21 * US, y: CMD.midY - 6.5 * US, width: 13 * US, height: 13 * US)

// ================================================================ terminal (below the card in the same world)
let TR = CGRect(x: -8, y: 560, width: 992, height: 616)
let T_X0: CGFloat = TR.minX + 30, T_Y0: CGFloat = TR.minY + 38 + 38

// ================================================================ camera (world = card css px; design screen 1920x1080)
struct Cam { let t: Double; let c: CGPoint; let z: Double; let dur: Double; var drift: Bool = false }
func P(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x, y: y) }
let OAUTH_C = P(352, T_Y0 + 18)
let CAMS: [Cam] = [
	Cam(t: 0, c: P(488, 150 * US), z: 1.86, dur: 0),
	Cam(t: 0, c: P(560, 116 * US), z: 2.05, dur: HOVER - 0.05, drift: true),
	Cam(t: HOVER - 0.05, c: P(735, CMD.midY), z: 2.6, dur: 0.5),                    // onto the one command
	Cam(t: HOVER + 0.45, c: P(741, CMD.midY + 2), z: 2.74, dur: FLY_A - HOVER - 0.45, drift: true),
	Cam(t: FLY_A, c: P(496, T_Y0 + 150), z: 1.62, dur: FLY_B - FLY_A + 0.15),       // follow it down to the terminal
	Cam(t: FLY_B + 0.15, c: P(488, T_Y0 + 234), z: 1.7, dur: CUT - 0.1 - FLY_B - 0.15, drift: true),
	Cam(t: CUT - 0.1, c: OAUTH_C, z: 2.16, dur: 0.55),                              // one approval
	Cam(t: CUT + 0.45, c: P(OAUTH_C.x + 12, OAUTH_C.y + 2), z: 2.28, dur: TABS_T - CUT - 0.45, drift: true),
	Cam(t: TABS_T, c: P(488, 165 * US), z: 1.9, dur: 2 * BEAT),                     // back to every agent's tab
	Cam(t: TABS_T + 2 * BEAT, c: P(488, 172 * US), z: 1.93, dur: CLK[3] - TABS_T - 2 * BEAT, drift: true),
	Cam(t: CLK[3], c: P(488, 196 * US), z: 1.88, dur: 0.45),
	Cam(t: CLK[3] + 0.45, c: P(488, 190 * US), z: 1.92, dur: LIFT_A - 0.2 - CLK[3] - 0.45, drift: true),
	Cam(t: LIFT_A - 0.2, c: P(488, 128 * US), z: 1.72, dur: 0.5),
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
func worldToScreen(_ p: CGPoint, _ cam: (CGPoint, Double)) -> CGPoint {
	CGPoint(x: 960 + (p.x - cam.0.x) * CGFloat(cam.1), y: 540 + (p.y - cam.0.y) * CGFloat(cam.1))
}

// ================================================================ the card
func activeTabAt(_ t: Double) -> (Int, Int, Double) {   // current, previous, seconds since the switch
	var cur = 0, prev = 0, since = 99.0
	for (i, ct) in CLK.enumerated() where t >= ct { prev = cur; cur = i + 1; since = t - ct }
	return (cur, prev, since)
}
func pillHover(_ p: Int, _ t: Double) -> Double {
	guard p >= 1 && p <= 4 else { return 0 }
	let ct = CLK[p - 1]
	return ease(seg(t, ct - 0.2, ct - 0.02)) * (1 - ease(seg(t, ct + 0.35, ct + 0.53)))
}
func pillActive(_ p: Int, _ t: Double) -> Double {
	let (cur, prev, since) = activeTabAt(t)
	let k = ease(seg(since, 0, 0.18))
	if TABS[cur].pill == p { return since > 50 ? 1 : k }
	if TABS[prev].pill == p && since < 50 { return 1 - k }
	return 0
}
func hline(_ c: CGContext, _ y: CGFloat, _ a: CGFloat) {
	c.setFillColor(col(WHITE, BORDER_A * a)); c.fill(CGRect(x: 1, y: y, width: 974, height: 1))
}
func drawRows(_ c: CGContext, _ tab: TabDef, _ a: CGFloat, enterSince: Double?, exitK: Double) {
	for (j, r) in tab.rows.enumerated() {
		var ra = a, dy: CGFloat = 0, typed = 1.0
		if let s = enterSince {   // rows come in one after another, the command types itself
			let k = eout(seg(s, 0.08 + Double(j) * 0.06, 0.4 + Double(j) * 0.06))
			ra *= CGFloat(k); dy = 12 * CGFloat(1 - k)
			typed = seg(quant(s), 0.14 + Double(j) * 0.06, 0.52 + Double(j) * 0.06)
		}
		if exitK > 0 { ra *= CGFloat(1 - exitK); dy -= 8 * CGFloat(exitK) }
		if ra <= 0.003 { continue }
		hline(c, r.y * US, ra)
		let block: CGFloat = (r.sub == nil ? 18.75 : 39) * US
		let top = r.y * US + 1 + (r.h * US - 1 - block) / 2 + dy
		cssText(c, r.label, sans(12.5 * US, 500), 13, top, 18.75 * US, C_TEXT, ra)
		if let sub = r.sub { cssText(c, sub, sans(11.5 * US, 400), 13, top + 21.75 * US, 17.25 * US, C_TEXT2, ra) }
		let by = boxY(r) + dy
		rrect(c, CGRect(x: 503, y: by, width: 460, height: 32.75 * US), 8 * US, fill: C_BG2, fa: ra, lw: 0)
		let f = mono(12.5 * US)
		let full = truncated(r.cmd, f, 460 - 41 * US)
		let n = Int((Double(full.count) * typed).rounded(.down))
		cssText(c, String(full.prefix(n)), f, 503 + 12 * US, by + 7 * US, 18.75 * US, C_TEXT, ra)
	}
}
func drawCard(_ c: CGContext, _ t: Double, hoverU: Double, copiedSince: Double?) {
	let (cur, prev, since) = activeTabAt(t)
	let hk = since > 50 ? 1.0 : spring(since, 0, freq: 3.2, zeta: 0.8)
	let h = lerpC(tabHeight(prev), tabHeight(cur), hk)
	let card = CGRect(x: 0, y: 0, width: 976, height: h)
	c.saveGState()
	let path = CGPath(roundedRect: card, cornerWidth: 10, cornerHeight: 10, transform: nil)
	c.addPath(path); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(path); c.clip()
	// header
	c.setFillColor(col(C_BG2)); c.fill(CGRect(x: 1, y: 1, width: 974, height: 56 * US))
	hline(c, 57 * US, 1)
	cssText(c, "Connect an agent", sans(13 * US, 500), 13, 18.75 * US, 19.5 * US, C_TEXT, 1)
	let docsK = since > 50 ? 1.0 : ease(seg(since, 0.02, 0.2))
	let arrow = CGRect(x: 955 - 12 * US, y: 28.5 * US - 6 * US, width: 12 * US, height: 12 * US)
	if docsK < 1 { cssText(c, TABS[prev].docs, sans(12 * US, 400), arrow.minX - 4 * US, 19.5 * US - 6 * CGFloat(docsK), 18 * US, C_TEXT2, CGFloat(1 - docsK), .right) }
	cssText(c, TABS[cur].docs, sans(12 * US, 400), arrow.minX - 4 * US, 19.5 * US + 6 * CGFloat(1 - docsK), 18 * US, C_TEXT2, CGFloat(docsK), .right)
	strokeIcon(c, ICON_ARROW, arrow, C_TEXT2, 1)
	if let s = copiedSince, s < 0.7 {
		let pa = CGFloat(1 - seg(s, 0.05, 0.7))
		c.addPath(CGPath(roundedRect: CMD.insetBy(dx: -1.5, dy: -1.5), cornerWidth: 9.5, cornerHeight: 9.5, transform: nil))
		c.setStrokeColor(col(BLUE, pa)); c.setLineWidth(1.5); c.strokePath()
	}
	// all editor plugins at once + the one command
	cssText(c, "All editor plugins at once", sans(12.5 * US, 500), 13, 69 * US, 18.75 * US, C_TEXT, 1)
	cssText(c, "Claude Code, Cursor, Codex and OpenCode.", sans(11.5 * US, 400), 13, 90.75 * US, 17.25 * US, C_TEXT2, 1)
	rrect(c, CMD, 8 * US, fill: mix(C_BG2, C_MUTED, hoverU), fa: 1, lw: 0)
	cssText(c, "npx supermemory plugin", mono(12.5 * US), 503 + 12 * US, 79.13 * US, 18.75 * US, C_TEXT, 1)
	let icon = COPY_ICON
	if let s = copiedSince {
		let out = ease(seg(s, 0, 0.18)), inn = spring(s, 0.02, freq: 3.2, zeta: 0.6)
		strokeIcon(c, ICON_COPY, icon, C_ICON, CGFloat(hoverU * (1 - out)), scale: CGFloat(1 - 0.75 * out))
		strokeIcon(c, ICON_CHECK, icon, C_CHECK, CGFloat(hoverU * min(1, inn * 1.4)), scale: CGFloat(0.25 + 0.75 * inn))
	} else {
		strokeIcon(c, ICON_COPY, icon, C_ICON, CGFloat(hoverU))
	}
	// the agents strip
	hline(c, 120 * US, 1)
	for (i, p) in PILLS.enumerated() {
		let act = pillActive(i, t), hov = pillHover(i, t) * (1 - act)
		let r = CGRect(x: p.x, y: 133 * US, width: p.w, height: 28 * US)
		let pr = (r.height - 1) / 2
		let pp = CGPath(roundedRect: r.insetBy(dx: 0.5, dy: 0.5), cornerWidth: pr, cornerHeight: pr, transform: nil)
		if act > 0.003 { c.addPath(pp); c.setFillColor(col(C_PILL_BG, CGFloat(act))); c.fillPath() }
		if hov > 0.003 { c.addPath(pp); c.setFillColor(col(C_MUTED, CGFloat(hov))); c.fillPath() }
		c.addPath(pp); c.setStrokeColor(col(WHITE, BORDER_A * CGFloat(1 - act))); c.setLineWidth(1); c.strokePath()
		if act > 0.003 { c.addPath(pp); c.setStrokeColor(col(C_PILL_BORDER, CGFloat(act))); c.setLineWidth(1); c.strokePath() }
		let tc = mix(C_TEXT2, C_TEXT, max(act, hov))
		drawLogoIn(c, p.logo, p.icon, tc, 1)
		let wght = (400 + 100 * act).rounded()
		cssText(c, p.name, sans(12.5 * US, wght), p.icon.maxX + 7 * US, 137.63 * US, 18.75 * US, tc, 1)
	}
	// steps
	if since < 50 {
		let exitK = ease(seg(since, 0, 0.14))
		if exitK < 1 { drawRows(c, TABS[prev], 1, enterSince: nil, exitK: exitK) }
		drawRows(c, TABS[cur], 1, enterSince: since, exitK: 0)
	} else {
		drawRows(c, TABS[cur], 1, enterSince: nil, exitK: 0)
	}
	c.restoreGState()
	c.addPath(CGPath(roundedRect: card.insetBy(dx: 0.5, dy: 0.5), cornerWidth: 10, cornerHeight: 10, transform: nil))
	c.setStrokeColor(col(WHITE, BORDER_A)); c.setLineWidth(1); c.strokePath()
}

// ================================================================ chips, cursor
func drawWhiteChip(_ c: CGContext, _ ctr: CGPoint, _ size: CGFloat, _ pill: Int, _ a: CGFloat) {
	if a <= 0.003 || size <= 1 { return }
	let r = CGRect(x: ctr.x - size / 2, y: ctr.y - size / 2, width: size, height: size)
	rect(c, r, fill: WHITE, fa: a, stroke: INK, sa: A20 * a, lw: max(0.6, size / 60))
	drawLogoIn(c, PILLS[pill].logo, r.insetBy(dx: size * 0.22, dy: size * 0.22), INK, a)
}
func pillIcon(_ p: Int) -> CGPoint { CGPoint(x: PILLS[p].icon.midX, y: PILLS[p].icon.midY) }
func popChip(_ c: CGContext, _ pill: Int, _ t: Double, _ t0: Double, hold: Double = 0.48) {
	if t < t0 || t > t0 + hold + 0.3 { return }
	let up = spring(t, t0, freq: 2.6, zeta: 0.55), down = ease(seg(t, t0 + hold, t0 + hold + 0.26))
	let k = up * (1 - down)
	let b = pillIcon(pill)
	drawWhiteChip(c, CGPoint(x: b.x, y: b.y - 70 * CGFloat(k)), CGFloat(16 + 48 * k), pill, CGFloat(min(1, up * 3)) * CGFloat(1 - seg(t, t0 + hold + 0.2, t0 + hold + 0.3)))
}
func liftPos(_ k: Int, _ t: Double) -> (CGPoint, CGFloat, CGFloat) {
	let t0 = liftT(k)
	let up = spring(t, t0, freq: 2.4, zeta: 0.6)
	let b = pillIcon(LIFT_PILLS[k])
	let row = CGPoint(x: 488 + CGFloat(k - 3) * 126, y: -72)
	return (lerpP(b, row, up), CGFloat(16 + 56 * up), CGFloat(min(1, up * 3)))
}
struct CK { let t: Double; let p: CGPoint }
let PILL_CX: [CGFloat] = PILLS.map { $0.x + $0.w / 2 }
let CURSOR_KEYS: [CK] = [
	CK(t: 0.3, p: P(1110, 300)), CK(t: HOVER, p: P(COPY_ICON.midX - 2, COPY_ICON.midY + 2)), CK(t: FLY_A + 0.2, p: P(COPY_ICON.midX - 2, COPY_ICON.midY + 2)),
	CK(t: TABS_T + 2 * BEAT, p: P(700, 370)),
	CK(t: CLK[0] - 0.12, p: P(PILL_CX[1] + 6, 151 * US)), CK(t: CLK[0] + 0.12, p: P(PILL_CX[1] + 6, 151 * US)),
	CK(t: CLK[1] - 0.12, p: P(PILL_CX[2] + 6, 151 * US)), CK(t: CLK[1] + 0.12, p: P(PILL_CX[2] + 6, 151 * US)),
	CK(t: CLK[2] - 0.12, p: P(PILL_CX[3] + 6, 151 * US)), CK(t: CLK[2] + 0.12, p: P(PILL_CX[3] + 6, 151 * US)),
	CK(t: CLK[3] - 0.12, p: P(PILL_CX[4] + 6, 151 * US)), CK(t: CLK[3] + 0.12, p: P(PILL_CX[4] + 6, 151 * US)),
	CK(t: LIFT_A, p: P(720, 380)),
]
let PRESSES: [Double] = [CLICK] + CLK
func cursorState(_ t: Double) -> (CGPoint, CGFloat, CGFloat) {
	var a: CGFloat = 0
	if t < FLY_A + 0.5 { a = CGFloat(ease(seg(t, 0.3, 0.5)) * (1 - ease(seg(t, FLY_A + 0.15, FLY_A + 0.4)))) }
	if t >= TABS_T + 2 * BEAT && t < LIFT_A + 0.1 { a = CGFloat(ease(seg(t, TABS_T + 2 * BEAT, TABS_T + 2 * BEAT + 0.25)) * (1 - ease(seg(t, LIFT_A - 0.25, LIFT_A)))) }
	var p = CURSOR_KEYS[0].p
	for i in 1..<CURSOR_KEYS.count where t >= CURSOR_KEYS[i - 1].t {
		let a0 = CURSOR_KEYS[i - 1], a1 = CURSOR_KEYS[i]
		if a0.t >= FLY_A && a1.t <= TABS_T + 2 * BEAT + 0.01 { p = a1.p; continue }
		p = lerpP(a0.p, a1.p, ease(seg(t, a0.t, a1.t)))
	}
	var press: CGFloat = 0
	for pt in PRESSES { press = max(press, CGFloat(1 - seg(abs(t - pt), 0, 0.1))) }
	return (p, a, press)
}
func drawCursor(_ c: CGContext, _ p: CGPoint, _ a: CGFloat, press: CGFloat, z: Double) {
	if a <= 0.003 { return }
	let s = CGFloat(1.6 / z) * (1 - 0.14 * press)
	let pts: [(CGFloat, CGFloat)] = [(0, 0), (0, 25), (6, 19.5), (10.5, 29.5), (14.5, 27.8), (10.2, 18), (17.8, 18)]
	c.saveGState()
	c.translateBy(x: p.x, y: p.y); c.scaleBy(x: s, y: s)
	c.move(to: CGPoint(x: pts[0].0, y: pts[0].1))
	for q in pts.dropFirst() { c.addLine(to: CGPoint(x: q.0, y: q.1)) }
	c.closePath()
	c.setFillColor(col(WHITE, a)); c.setStrokeColor(col(INK, a)); c.setLineWidth(2)
	c.setLineJoin(.round)
	c.drawPath(using: .fillStroke)
	c.restoreGState()
}
func ripple(_ c: CGContext, _ p: CGPoint, _ t: Double, _ t0: Double, z: Double) {
	let k = seg(t, t0, t0 + 0.45)
	if k <= 0 || k >= 1 { return }
	let r = CGFloat(4 + 22 * eout(k)) * CGFloat(1.6 / z)
	c.setStrokeColor(col(WHITE, 0.75 * CGFloat(1 - k))); c.setLineWidth(2.2 / CGFloat(z))
	c.strokeEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
}

// ================================================================ the terminal
func drawTerminal(_ c: CGContext, _ t: Double) {
	let k = spring(t, TERM_IN, freq: 2.2, zeta: 0.75)
	if k <= 0.001 { return }
	let a = CGFloat(min(1, k * 1.6))
	c.saveGState()
	c.translateBy(x: 0, y: 46 * CGFloat(1 - k))
	rrect(c, TR, 12, fill: C_BG, fa: a, stroke: WHITE, sa: 0.1 * a, lw: 1)
	for i in 0..<3 { dot(c, CGPoint(x: TR.minX + 22 + CGFloat(i) * 21, y: TR.minY + 19), 6.5, WHITE, 0.16 * a) }
	text(c, "~/supermemory", mono(14), TR.midX, TR.minY + 24, C_TEXT2, 0.8 * a, .center)
	c.setFillColor(col(WHITE, 0.07 * a)); c.fill(CGRect(x: TR.minX + 1, y: TR.minY + 38, width: TR.width - 2, height: 1))
	let tq = quant(t)
	let aA = a * CGFloat(1 - ease(seg(t, CUT, CUT + 0.14)))
	if aA > 0.003 {
		text(c, "$", mono(T_FS), T_X0, T_Y0, T_TEXT, 0.45 * aA)
		let caretOn = (Int(tq * 2.5) % 2 == 0) || (t >= FLY_B - 0.1 && t < ENTER)
		if t < ENTER && caretOn {
			let cx = T_X0 + (t >= FLY_B ? 24 : 2) * T_CW
			rect(c, CGRect(x: cx, y: T_Y0 - 14, width: T_CW, height: 18), fill: T_TEXT, fa: 0.8 * aA)
		}
		if t >= FLY_B { text(c, "npx supermemory plugin", mono(T_FS, 500), T_X0 + 2 * T_CW, T_Y0, T_TEXT, aA) }
		// the banner sweeps in column by column
		if tq >= ENTER {
			for row in 0..<6 {
				let base = T_Y0 + CGFloat(2 + row) * T_LH
				let fill = BANNER_FILL[min(row, BANNER_FILL.count - 1)]
				for colI in 0...BANNER_COLS {
					let ta = ENTER + 0.04 + Double(colI) * 0.0055 + Double(row) * 0.012
					if tq < ta { continue }
					let pk = CGFloat(eout(seg(t, ta, ta + 0.16)))
					let x = T_X0 + CGFloat(2 + colI) * T_CW
					let cell = CGRect(x: x, y: base - T_LH + 6 + 6 * (1 - pk), width: T_CW + 0.4, height: T_LH + 0.4)
					if bannerFilled(row, colI) { rect(c, cell, fill: fill, fa: aA * pk) }
					else if bannerFilled(row - 1, colI - 1) { rect(c, cell, fill: BANNER_SHADOW, fa: 0.55 * aA * pk) }
				}
			}
		}
		if tq >= ENTER + BEAT {
			let pad = max(2, BANNER_COLS + 1 - 9)
			let base = T_Y0 + 8 * T_LH
			text(c, ">", mono(T_FS, 400), T_X0 + CGFloat(pad) * T_CW, base, 0x18BFFF, aA)
			text(c, " PLUGINS", mono(T_FS, 700), T_X0 + CGFloat(pad + 1) * T_CW, base, 0x1775EF, aA)
		}
		for (i, l) in PHASE_A.enumerated() {
			let ta = rowT(i)
			if tq < ta { continue }
			let lk = CGFloat(eout(seg(t, ta, ta + 0.12)))
			c.saveGState(); c.translateBy(x: 10 * (1 - lk), y: 0)
			drawTLine(c, l, T_Y0 + CGFloat(10 + i) * T_LH, aA * lk)
			c.restoreGState()
		}
		// each detected agent's logo lands at the end of its own [ready] row
		for (i, d) in DETECT.enumerated() {
			let ta = rowT(2 + i) + 0.06
			let kk = spring(t, ta, freq: 2.6, zeta: 0.55)
			let chars = 1 + 3 + 7 + 1 + d.0.count + 1 + d.1.count
			let x = T_X0 + CGFloat(chars) * T_CW + 26
			drawWhiteChip(c, CGPoint(x: x, y: T_Y0 + CGFloat(12 + i) * T_LH - 6), CGFloat(23 * kk), [0, 1, 3, 2][i], CGFloat(min(1, kk * 2)) * aA)
		}
	}
	if t >= OAUTH_A - 0.05 {
		label(c, "after install", TR.maxX - 20, TR.minY + 25, WHITE, 0.5 * a * CGFloat(eout(seg(t, OAUTH_A, OAUTH_A + 0.2))), .right, size: 13)
		for (i, l) in PHASE_B.enumerated() {
			let ta = OAUTH_A + Double(i) * BEAT / 4
			if tq < ta { continue }
			let lk = CGFloat(eout(seg(t, ta, ta + 0.14)))
			c.saveGState(); c.translateBy(x: 10 * (1 - lk), y: 0)
			drawTLine(c, l, T_Y0 + CGFloat(i) * T_LH, a * lk)
			c.restoreGState()
		}
		// underline "One approval", then the four it connects
		let uk = ease(seg(t, OAUTH_A + BEAT, OAUTH_A + 2 * BEAT))
		if uk > 0 {
			let x0 = T_X0 + 2 * T_CW, x1 = T_X0 + 14 * T_CW
			c.setFillColor(col(BLUE, a)); c.fill(CGRect(x: x0, y: T_Y0 + T_LH + 7, width: (x1 - x0) * CGFloat(uk), height: 2.5))
		}
		for i in 0..<4 {
			let kk = spring(t, OAUTH_A + BEAT + Double(i) * BEAT / 4, freq: 2.6, zeta: 0.55)
			drawWhiteChip(c, CGPoint(x: T_X0 + 20 + CGFloat(i) * 56, y: T_Y0 + 4 * T_LH), CGFloat(42 * kk), [0, 1, 3, 2][i], CGFloat(min(1, kk * 2)) * a)
		}
	}
	c.restoreGState()
}

// the copied command lifts off the box and flies to the prompt, becoming the pasted text
func drawFlight(_ c: CGContext, _ t: Double) {
	if t < FLY_A || t >= FLY_B { return }
	let k = ease2(seg(t, FLY_A, FLY_B))
	let s = "npx supermemory plugin"
	let f0 = mono(12.5 * US), b0 = cssBase(f0, 79.13 * US, 18.75 * US)
	let x0: CGFloat = 503 + 12 * US, x1 = T_X0 + 2 * T_CW
	let termDy = 46 * CGFloat(1 - spring(t, TERM_IN, freq: 2.2, zeta: 0.75))
	let y1 = T_Y0 + termDy
	let size = lerpC(12.5 * US, T_FS, k), wght = lerp(400, 500, k).rounded()
	let f = mono(size, wght)
	// arc: out to the right, then down
	let p0 = CGPoint(x: x0, y: b0), p2 = CGPoint(x: x1, y: y1), p1 = CGPoint(x: 900, y: 470)
	let u = CGFloat(k)
	let bx = (1 - u) * (1 - u) * p0.x + 2 * (1 - u) * u * p1.x + u * u * p2.x
	let by = (1 - u) * (1 - u) * p0.y + 2 * (1 - u) * u * p1.y + u * u * p2.y
	let tw = textW(s, f)
	let lift = CGFloat(bump(t, FLY_A, FLY_B - FLY_A)) * 1
	let chipA = CGFloat(1 - seg(k, 0.85, 1))
	let r = CGRect(x: bx - 12, y: by - size - 6, width: tw + 24, height: size + 16)
	rrect(c, r, 8, fill: C_BG2, fa: chipA, stroke: WHITE, sa: 0.16 * chipA * (0.5 + 0.5 * lift), lw: 1)
	text(c, s, f, bx, by, C_TEXT, 1)
}

// ================================================================ the end: every plugin orbits supermemory, then one line
let RING_C = CGPoint(x: 960, y: 528), RING_R: CGFloat = 336, RING_CHIP: CGFloat = 122, TILE_S: CGFloat = 204
func ringAngle(_ k: Int, _ t: Double) -> Double {
	let n = Double(LIFT_PILLS.count)
	let base = -90.0 + 360.0 / n * Double(k)
	let drift = 26.0 * smooth(seg(t, END, SPIN_A))              // settles while it forms
	let spin = 300.0 * ease2(seg(t, SPIN_A, COL_A))             // spins on the drop
	let swirl = 140.0 * ease(seg(t, COL_A, COL_B))              // and swirls in
	return (base + drift + spin + swirl) * Double.pi / 180
}
/// A kick-synced pulse: decays after every beat in [from, to].
func beatPulse(_ t: Double, from: Double, to: Double, depth: Double) -> Double {
	if t < from || t > to + 0.4 { return 0 }
	let n = ((t - from) / BEAT).rounded(.down)
	if from + n * BEAT > to { return 0 }
	return depth * exp(-(t - from - n * BEAT) / 0.09)
}
func ringPunch(_ t: Double) -> CGFloat { t >= SPIN_A ? CGFloat(1 + 0.045 * exp(-(t - SPIN_A) / 0.2)) : 1 }
/// The blue supermemory tile at the ring's centre (also read by the background, to keep its clearspace free of dots).
func tileSize(_ t: Double) -> CGFloat {
	if t < END { return 0 }
	let tileIn = spring(t, END + 0.08, freq: 2.2, zeta: 0.6)
	let tileOut = ease(seg(t, HEAD_T - 0.04, HEAD_T + 0.22))
	let pulse = beatPulse(t, from: SPIN_A, to: COL_A - 0.01, depth: 0.065) + 0.16 * Double(bump(t, COL_B - 0.06, 0.3))
	return TILE_S * CGFloat(tileIn) * CGFloat(1 + pulse) * CGFloat(1 - tileOut) * ringPunch(t)
}
func drawRing(_ c: CGContext, _ t: Double) {
	if t < END { return }
	let camE = camera(END - 0.001)
	let punch = ringPunch(t)
	let ts = tileSize(t)
	let collapse = ease(seg(t, COL_A, COL_B))
	var chips: [(CGPoint, CGFloat, Int, CGFloat)] = []
	for k in 0..<LIFT_PILLS.count {
		let ang = ringAngle(k, t)
		let dir = CGPoint(x: CGFloat(cos(ang)), y: CGFloat(sin(ang)))
		let r = RING_R * CGFloat(1 - collapse) * punch
		let target = CGPoint(x: RING_C.x + dir.x * r, y: RING_C.y + dir.y * r)
		let (wp, ws, _) = liftPos(k, END - 0.001)
		let p0 = worldToScreen(wp, camE), s0 = ws * CGFloat(camE.1)
		let fk = spring(t, END + 0.05 + Double(k) * 0.035, freq: 1.9, zeta: 0.72)
		let p = lerpP(p0, target, fk)
		let size = lerpC(s0, RING_CHIP, fk) * CGFloat(1 - 0.8 * collapse) * punch
		// the line from supermemory to this plugin, with memory flowing in along it
		let lk = ease(seg(t, END + 0.4 + Double(k) * 0.03, END + 0.75 + Double(k) * 0.03)) * (1 - collapse)
		if lk > 0.003 && ts > 1 {
			let a = CGPoint(x: RING_C.x + dir.x * ts * 0.62, y: RING_C.y + dir.y * ts * 0.62)
			let b = CGPoint(x: p.x - dir.x * size * 0.62, y: p.y - dir.y * size * 0.62)
			segLine(c, a, lerpP(a, b, lk), WHITE, 0.9, lw: 2.5)     // v6: white on the blue film
			if t > SPIN_A - 0.25 {
				var ph = (t - SPIN_A) * 1.8 + Double(k) / Double(LIFT_PILLS.count)
				ph -= ph.rounded(.down)
				dot(c, lerpP(b, a, ph), 5.5, WHITE, CGFloat(sin(ph * Double.pi)) * CGFloat(lk))
			}
		}
		chips.append((p, size, LIFT_PILLS[k], CGFloat(1 - seg(collapse, 0.8, 1))))
	}
	for (p, size, pill, a) in chips { drawWhiteChip(c, p, size, pill, a) }
	if ts > 0.5 {
		// v6: the brand's inverse colourway (blue mark on paper), so the tile reads on the blue film
		rect(c, CGRect(x: RING_C.x - ts / 2, y: RING_C.y - ts / 2, width: ts, height: ts), fill: WHITE, fa: 1)
		paintMask(c, MARK, markRect(center: RING_C, height: ts * 0.36), BLUE, 1)
	}
}
func drawEnd(_ c: CGContext, _ t: Double) {
	if t < END { return }
	drawRing(c, t)
	let f = sans(128, 500)
	// v6: paper on blue. The statement at 78% white, the key words full white.
	let lines: [(String, CGFloat, CGFloat, Double)] = [("give your agents", 0.78, 448, HEAD_T), ("persistent memory", 1, 590, HEAD_T + BEAT / 2)]
	for (s, la, base, t0) in lines {
		let k = eout(seg(t, t0, t0 + 0.5))
		if k <= 0 { continue }
		c.saveGState(); c.clip(to: CGRect(x: 0, y: base - 128, width: CGFloat(W), height: 162))
		text(c, s, f, 960, base + 140 * CGFloat(1 - k), WHITE, la, .center)
		c.restoreGState()
	}
	let lk = eout(seg(t, LOCK_T, LOCK_T + 0.5))
	if lk > 0.003 {
		let lockW = 430.0, s = lockW / (G_MW + G_GAP + G_WW)
		let mw = G_MW * s, mh = G_MH * s, ww = G_WW * s, wh = G_WH * s, gap = G_GAP * s, woff = G_WOFF * s
		let x0 = 960 - lockW / 2, top = 676.0 + 14 * Double(1 - lk)
		paintMask(c, MARK, CGRect(x: x0, y: top, width: mw, height: mh), WHITE, CGFloat(lk))
		paintMask(c, WORD, CGRect(x: x0 + mw + gap, y: top + woff, width: ww, height: wh), WHITE, CGFloat(lk))
	}
	let ck = CGFloat(eout(seg(t, LOCK_T + BEAT, LOCK_T + BEAT + 0.5)))
	if ck > 0.003 {
		let cmd = "npx supermemory plugin"
		let fm = mono(27, 450)
		let cw = textW(cmd, fm) + 52
		let cr = CGRect(x: 960 - cw / 2, y: 782 + 12 * (1 - ck), width: cw, height: 62)
		rect(c, cr, fill: WHITE, fa: ck)
		text(c, cmd, fm, cr.midX, cr.midY + 10, INK, A86 * ck, .center)
	}
}

// ================================================================ frame
func drawGrid(_ c: CGContext, _ cam: (CGPoint, Double)) {
	let z = CGFloat(cam.1), sp: CGFloat = 26
	let vis = CGRect(x: cam.0.x - 960 / z, y: cam.0.y - 540 / z, width: 1920 / z, height: 1080 / z)
	let r = 1.2 / z
	c.setFillColor(col(INK, 0.1))
	var y = (vis.minY / sp).rounded(.down) * sp
	while y <= vis.maxY {
		var x = (vis.minX / sp).rounded(.down) * sp
		while x <= vis.maxX { c.fillEllipse(in: CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r)); x += sp }
		y += sp
	}
}
func renderScene(_ c: CGContext, _ t: Double) {
	// v5: the background (sky.swift) is already in the buffer; the white ground and the dot grid are gone
	let cam = camera(t)
	c.saveGState()
	c.translateBy(x: 960, y: 540); c.scaleBy(x: CGFloat(cam.1), y: CGFloat(cam.1)); c.translateBy(x: -cam.0.x, y: -cam.0.y)
	drawTerminal(c, t)
	// the card falls away at the end
	let out = pow(seg(t, END, END + 0.42), 2.2)        // drops out of frame, no grey fade
	if out < 1 {
		c.saveGState()
		c.translateBy(x: 0, y: 1000 * CGFloat(out))
		c.beginTransparencyLayer(auxiliaryInfo: nil)
		let hoverU = ease(seg(t, HOVER - 0.15, HOVER + 0.03)) * (1 - ease(seg(t, FLY_A + 0.15, FLY_A + 0.33)))
		drawCard(c, t, hoverU: hoverU, copiedSince: t >= CLICK ? t - CLICK : nil)
		c.endTransparencyLayer()
		c.restoreGState()
	}
	drawFlight(c, t)
	popChip(c, 1, t, CLK[0] + 0.02); popChip(c, 2, t, CLK[1] + 0.02); popChip(c, 3, t, CLK[2] + 0.02); popChip(c, 4, t, CLK[3] + 0.02)
	popChip(c, 0, t, TABS_T + 3 * BEAT)
	if t >= LIFT_A && t < END { for k in 0..<LIFT_PILLS.count { let (p, s, a) = liftPos(k, t); drawWhiteChip(c, p, s, LIFT_PILLS[k], a) } }
	let (p, a, press) = cursorState(t)
	for pt in PRESSES { ripple(c, cursorState(pt).0, t, pt, z: cam.1) }
	drawCursor(c, p, a, press: press, z: cam.1)
	c.restoreGState()
	// screen: the one label, the mark, the end
	let lk = eout(seg(t, TABS_T + 2 * BEAT, TABS_T + 2 * BEAT + 0.35)) * (1 - ease(seg(t, LIFT_A - 0.2, LIFT_A)))
	if lk > 0.003 {
		let s = "or one by one", size: CGFloat = 26
		let w = labelW(s, size: size)
		let dy = 22 * CGFloat(1 - lk)
		c.saveGState(); c.clip(to: CGRect(x: 960 - w / 2 - 50, y: 50, width: w + 100, height: 96))
		rect(c, CGRect(x: 960 - w / 2 - 26, y: 66 + dy, width: w + 52, height: 56), fill: WHITE, fa: 1)     // v6: inverse on the film
		label(c, s, 960, 103 + dy, BLUE, 1, .center, size: size)
		c.restoreGState()
	}
	if t < END + 0.3 { paintMask(c, MARK, markRect(center: CGPoint(x: 1840, y: 1022), height: 22), WHITE, 0.86 * CGFloat(1 - seg(t, END, END + 0.3))) }
	drawEnd(c, t)
}

func makeContext(_ data: UnsafeMutableRawPointer?) -> CGContext {
	let c = CGContext(data: data, width: PW, height: PH, bitsPerComponent: 8, bytesPerRow: PW * 4, space: sRGB,
	                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.translateBy(x: 0, y: CGFloat(PH)); c.scaleBy(x: 1, y: -1)
	c.scaleBy(x: SC, y: SC)
	c.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
	c.interpolationQuality = .high
	c.setShouldSmoothFonts(false)
	return c
}
func renderFrame(_ i: Int, into out: UnsafeMutablePointer<UInt8>) {
	let n = PW * PH * 4
	let t0 = min(Double(i) / FPS, T_STILL)
	let sky = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { sky.deallocate() }
	paintBackground(sky, t0)
	if t0 >= T_STILL || SUBFRAMES == 1 { memcpy(out, sky, n); let c = makeContext(out); renderScene(c, t0); return }
	let acc = UnsafeMutablePointer<UInt16>.allocate(capacity: n); acc.initialize(repeating: 0, count: n)
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { acc.deallocate(); buf.deallocate() }
	for k in 0..<SUBFRAMES {
		let t = t0 + (Double(k) / Double(SUBFRAMES) - 0.5) * SHUTTER / FPS
		memcpy(buf, sky, n)
		let c = makeContext(buf)
		renderScene(c, max(0, t))
		DispatchQueue.concurrentPerform(iterations: 32) { q in
			for p in (q * n / 32)..<((q + 1) * n / 32) { acc[p] &+= UInt16(buf[p]) }
		}
	}
	let half = UInt16(SUBFRAMES / 2)
	DispatchQueue.concurrentPerform(iterations: 32) { q in
		for p in (q * n / 32)..<((q + 1) * n / 32) { out[p] = UInt8((acc[p] + half) / UInt16(SUBFRAMES)) }
	}
}
func writePNG(_ img: CGImage, _ url: URL) {
	let d = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}

let args = Array(CommandLine.arguments.dropFirst())
if args.first == "stills" {
	let times = args.dropFirst().compactMap(Double.init)
	var imgs: [CGImage] = []
	for t in times {
		let mem = UnsafeMutablePointer<UInt8>.allocate(capacity: PW * PH * 4)
		renderFrame(Int((t * FPS).rounded()), into: mem)
		let img = makeContext(mem).makeImage()!
		imgs.append(img)
		writePNG(img, HERE.appendingPathComponent(String(format: "stills/t_%05.2f.png", t)))
		mem.deallocate()
	}
	let cols = 3, tw = 576, th = 324
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
	// v5: one frame at a time. CoreGraphics filling shapes on several threads at once sometimes got edge coverage (and
	// once a colour) wrong on the card and terminal outlines, so renders were not repeatable (v4 had it too). Only the
	// pure maths (sky pixels, motion-blur averaging) runs in parallel now.
	let batch = Int(ProcessInfo.processInfo.environment["BATCH"] ?? "") ?? 1
	let bufs = (0..<batch).map { _ in UnsafeMutablePointer<UInt8>.allocate(capacity: n) }
	let out = FileHandle.standardOutput
	var hold: Data? = nil
	var i0 = 0
	while i0 < total {
		let cnt = min(batch, total - i0)
		DispatchQueue.concurrentPerform(iterations: cnt) { k in
			let i = i0 + k
			if Double(i) / FPS >= T_STILL && hold != nil { return }
			renderFrame(i, into: bufs[k])
		}
		for k in 0..<cnt {
			let i = i0 + k
			if Double(i) / FPS >= T_STILL {
				if hold == nil { hold = Data(bytes: bufs[k], count: n) }
				out.write(hold!)
			} else {
				out.write(Data(bytesNoCopy: bufs[k], count: n, deallocator: .none))
			}
		}
		i0 += cnt
		FileHandle.standardError.write("\r\(i0)/\(total)".data(using: .utf8)!)
	}
	FileHandle.standardError.write("\n".data(using: .utf8)!)
}
