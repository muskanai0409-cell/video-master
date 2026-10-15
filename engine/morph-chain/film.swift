// ================================================================ supermemory local v0.0.9: the launch film
// One continuous take on the brand book's own surface: blue 600 with its light dithered toward blue 500, a screen-fixed
// lattice of stored dots, a hairline grid with + marks. One paper container is the survivor (the workersio move) and
// changes state on the beat (the rossaxbt morph chain): a prompt chip, the command bar, a terminal, a v5 call, a request,
// a counter, ten squares, one square, then the mark.

// ---------------------------------------------------------------- colours (Supermemory Brand Guidelines, colour system)
let FIELD: UInt32 = 0x0100f5           // blue 600, the field
let BLUE500: UInt32 = 0x0562ef
let PAPER: UInt32 = 0xf4f8ff
let INK2: UInt32 = 0x5b6270            // secondary ink on paper
@inline(__always) func rgb(_ v: UInt32) -> (Float, Float, Float) { (Float((v >> 16) & 255), Float((v >> 8) & 255), Float(v & 255)) }
func hash01(_ a: Int, _ b: Int = 0) -> Double {
	var x = UInt64(bitPattern: Int64(a &* 73856093 ^ b &* 19349663)) &+ 0x9e3779b97f4a7c15
	x = (x ^ (x >> 30)) &* 0xbf58476d1ce4e5b9; x = (x ^ (x >> 27)) &* 0x94d049bb133111eb; x ^= x >> 31
	return Double(x >> 11) / Double(1 << 53)
}
func capH(_ f: CTFont) -> CGFloat { CTFontGetCapHeight(f) }
/// baseline that centres a font's capitals on y
func midBase(_ f: CTFont, _ y: CGFloat) -> CGFloat { y + capH(f) / 2 }

// ---------------------------------------------------------------- camera (stage = the 1920x1080 design frame at k = 1)
struct Cam { let cx: Double; let cy: Double; let k: Double }
struct CamKey { let t: Double; let cx: Double; let cy: Double; let k: Double; var stop = false }
let CAM: [CamKey] = [
	CamKey(t: -1, cx: 960, cy: 540, k: 1.0),
	CamKey(t: T_FLY, cx: 960, cy: 540, k: 1.0, stop: true),
	CamKey(t: T_FLY + 0.75, cx: 960, cy: 522, k: 1.0, stop: true),          // the fly: settle on the command bar
	CamKey(t: T_ENTER, cx: 960, cy: 522, k: 1.02, stop: true),
	CamKey(t: b(15.5), cx: 960, cy: 516, k: 1.09),                          // a slow push on the terminal
	CamKey(t: b(16.5), cx: 960, cy: 520, k: 1.0, stop: true),               // back out for each new state
	CamKey(t: b(23.5), cx: 960, cy: 505, k: 1.06),
	CamKey(t: b(24.5), cx: 960, cy: 512, k: 1.0, stop: true),
	CamKey(t: b(31.5), cx: 960, cy: 512, k: 1.05),
	CamKey(t: b(32.5), cx: 960, cy: 530, k: 1.0, stop: true),
	CamKey(t: b(38.7), cx: 960, cy: 520, k: 1.07),
	CamKey(t: b(39.7), cx: 960, cy: 530, k: 1.0, stop: true),
	CamKey(t: b(45.8), cx: 960, cy: 500, k: 1.12),                          // in on the last square
	CamKey(t: b(47.6), cx: 960, cy: 540, k: 1.0, stop: true),
	CamKey(t: T_STILL, cx: 960, cy: 540, k: 1.0),
]
func camAt(_ tIn: Double) -> Cam {
	let t = min(tIn, T_STILL), n = CAM.count
	func v(_ k: CamKey) -> [Double] { [k.cx, k.cy, log(k.k)] }
	if t <= CAM[0].t { return Cam(cx: CAM[0].cx, cy: CAM[0].cy, k: CAM[0].k) }
	var i = 0
	while i < n - 2 && CAM[i + 1].t < t { i += 1 }
	let a = CAM[i], bb = CAM[i + 1], dt = bb.t - a.t, u = min(1, (t - a.t) / dt)
	func tan(_ j: Int) -> [Double] {
		if j == 0 || j == n - 1 || CAM[j].stop { return [0, 0, 0] }
		let p = v(CAM[j - 1]), q = v(CAM[j + 1])
		return (0..<3).map { (q[$0] - p[$0]) / (CAM[j + 1].t - CAM[j - 1].t) }
	}
	let va = v(a), vb = v(bb), ma = tan(i), mb = tan(i + 1)
	let h00 = 2 * u * u * u - 3 * u * u + 1, h10 = u * u * u - 2 * u * u + u, h01 = -2 * u * u * u + 3 * u * u, h11 = u * u * u - u * u
	let r = (0..<3).map { h00 * va[$0] + h10 * dt * ma[$0] + h01 * vb[$0] + h11 * dt * mb[$0] }
	return Cam(cx: r[0], cy: r[1], k: exp(r[2]))
}
/// a quick zoom punch on the big hits; a soft attack, so nothing jumps on a single frame
func punch(_ t: Double) -> Double {
	var p = 0.0
	for (h, a) in [(T_ENTER, 0.05), (T_V5, 0.025), (T_SEC, 0.025), (T_SPD, 0.05), (T_COUNT1, 0.02), (T_MARK, 0.03)] where t > h && t < h + 1.2 {
		let u = t - h; p += a * (1 - exp(-u / 0.03)) * exp(-u / 0.13)
	}
	return p
}
/// the drop shakes the stage for a moment
func shake(_ t: Double) -> CGPoint {
	let u = t - T_ENTER
	if u < 0 || u > 0.35 { return .zero }
	let a = 6 * exp(-u / 0.08)
	return CGPoint(x: a * sin(u * 97), y: a * cos(u * 83))
}
func stageCam(_ t: Double) -> Cam {
	let c = camAt(t), s = shake(t)
	return Cam(cx: c.cx - Double(s.x) / c.k, cy: c.cy - Double(s.y) / c.k, k: c.k * (1 + punch(t)))
}
func applyCam(_ c: CGContext, _ cam: Cam) {
	c.translateBy(x: 960, y: 540); c.scaleBy(x: CGFloat(cam.k), y: CGFloat(cam.k)); c.translateBy(x: CGFloat(-cam.cx), y: CGFloat(-cam.cy))
}
func toScreen(_ x: CGFloat, _ y: CGFloat, _ cam: Cam) -> CGPoint {
	CGPoint(x: (Double(x) - cam.cx) * cam.k + 960, y: (Double(y) - cam.cy) * cam.k + 540)
}

// ---------------------------------------------------------------- the survivor: one paper box, morphing between states
struct Box {
	var cx: CGFloat, cy: CGFloat, w: CGFloat, h: CGFloat, r: CGFloat
	var rect: CGRect { CGRect(x: cx - w / 2, y: cy - h / 2, width: w, height: h) }
	var minX: CGFloat { cx - w / 2 }
	var minY: CGFloat { cy - h / 2 }
	var maxX: CGFloat { cx + w / 2 }
	var maxY: CGFloat { cy + h / 2 }
}
/// one spring for the whole box, stiffer (the end card's chip must be at rest before the still)
func morphF(_ a: Box, _ b: Box, _ t: Double, _ t0: Double, freq: Double) -> Box {
	let k = spring(t, t0, freq: freq, zeta: 0.7)
	return Box(cx: lerpC(a.cx, b.cx, k), cy: lerpC(a.cy, b.cy, k), w: max(1, lerpC(a.w, b.w, k)), h: max(1, lerpC(a.h, b.h, k)), r: max(0, lerpC(a.r, b.r, k)))
}
/// edge springs: each edge on its own small lag, so the shape stretches as it changes
func morph(_ a: Box, _ b: Box, _ t: Double, _ t0: Double, lag: Double = 0.022) -> Box {
	let kL = spring(t, t0), kT = spring(t, t0 + lag * 0.5), kR = spring(t, t0 + lag), kB = spring(t, t0 + lag * 1.5)
	let l = lerpC(a.minX, b.minX, kL), r = lerpC(a.maxX, b.maxX, kR)
	let tp = lerpC(a.minY, b.minY, kT), bt = lerpC(a.maxY, b.maxY, kB)
	return Box(cx: (l + r) / 2, cy: (tp + bt) / 2, w: max(1, r - l), h: max(1, bt - tp), r: max(0, lerpC(a.r, b.r, spring(t, t0))))
}
let K_CHIP = Box(cx: 960, cy: 668, w: 118, h: 66, r: 33)
let K_BAR = Box(cx: 960, cy: 470, w: 1000, h: 116, r: 30)
let K_TERM = Box(cx: 960, cy: 473, w: 1000, h: 310, r: 30)
let CODE_W = textW("  query: \"what food should I avoid?\",", mono(46, 400)) + 128
let K_CODE = Box(cx: 960, cy: 470, w: CODE_W, h: 320, r: 30)
let K_CODE_UP = Box(cx: 960, cy: 420, w: CODE_W, h: 320, r: 30)
let REQ_W = 40 + textW("POST", mono(28, 600)) + 34 + 26 + textW("localhost:6767/ns/user_dhravya/search", mono(44, 400)) + 48
let K_REQ = Box(cx: 960, cy: 410, w: REQ_W, h: 116, r: 30)
let K_REQ2 = Box(cx: 960, cy: 440, w: REQ_W, h: 204, r: 30)
let K_SPD = Box(cx: 960, cy: 464, w: 900, h: 420, r: 40)
let T_BAR = T_FLY + 0.14
let BOX_KEYS: [(Double, Box)] = [(T_CHIP, K_CHIP), (T_BAR, K_BAR), (T_ENTER, K_TERM), (T_V5, K_CODE), (T_RESULT, K_CODE_UP),
                                 (T_SEC, K_REQ), (T_AUTH, K_REQ2), (T_SPD, K_SPD)]
func boxAt(_ t: Double) -> Box? {
	if t < T_CHIP { return nil }
	var i = 0
	while i + 1 < BOX_KEYS.count && BOX_KEYS[i + 1].0 <= t { i += 1 }
	if i == 0 { return morph(Box(cx: K_CHIP.cx, cy: K_CHIP.cy, w: 24, h: 24, r: 12), K_CHIP, t, T_CHIP, lag: 0) }
	return morph(BOX_KEYS[i - 1].1, BOX_KEYS[i].1, t, BOX_KEYS[i].0)
}
func fillBox(_ c: CGContext, _ bx: Box, _ color: UInt32, _ a: CGFloat = 1) {
	if a <= 0.003 || bx.w < 0.5 || bx.h < 0.5 { return }
	c.setFillColor(col(color, a)); c.addPath(rrectPath(bx.rect, bx.r)); c.fillPath()
}

// ---------------------------------------------------------------- type that rises out of a mask line (one grammar)
@inline(__always) func riseU(_ t: Double, _ t0: Double, _ j: Int, fast: Bool = false) -> Double {
	let st = fast ? 0.005 : 0.012, d = fast ? 0.3 : 0.42
	return eout(seg(t, t0 + st * Double(j), t0 + st * Double(j) + d))
}
@inline(__always) func riseV(_ t: Double, _ t1: Double, _ j: Int) -> Double { ease(seg(t, t1 + 0.006 * Double(j), t1 + 0.006 * Double(j) + 0.26)) }
typealias Tok = (String, UInt32)
/// a line of coloured tokens; each character rises in on its own small lag and rises out the same way
func riseRich(_ c: CGContext, _ toks: [Tok], _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ t: Double, _ t0: Double, _ t1: Double,
              _ al: Align = .left, alpha: CGFloat = 1, j0: Int = 0, fast: Bool = false) {
	if t < t0 || t > t1 + 0.6 || alpha <= 0.003 { return }
	let size = CTFontGetSize(f)
	let full = toks.map { $0.0 }.joined()
	let w = textW(full, f)
	let x0: CGFloat = al == .left ? x : (al == .center ? x - w / 2 : x - w)
	c.saveGState()
	c.clip(to: CGRect(x: -4000, y: y - size * 1.05, width: 12000, height: size * 1.38))
	var j = j0
	var prefix = ""
	for (s, colr) in toks {
		for ch in s {
			if ch != " " {
				let u = riseU(t, t0, j, fast: fast), v = riseV(t, t1, j)
				if u > 0.001 && v < 0.999 {
					let dy = (1 - CGFloat(u)) * size * 0.95 - CGFloat(v) * size * 0.95
					text(c, String(ch), f, x0 + textW(prefix, f), y + dy, colr, alpha * CGFloat(min(1, u * 1.5)) * CGFloat(1 - v))
				}
			}
			prefix.append(ch); j += 1
		}
	}
	c.restoreGState()
}
func riseText(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ color: UInt32, _ t: Double, _ t0: Double, _ t1: Double,
              _ al: Align = .left, alpha: CGFloat = 1) {
	riseRich(c, [(s, color)], f, x, y, t, t0, t1, al, alpha: alpha)
}
/// an icon that rides the same rise as the line it starts
func riseIcon(_ c: CGContext, _ t: Double, _ t0: Double, _ t1: Double, _ size: CGFloat, _ body: (CGFloat) -> Void) {
	let u = riseU(t, t0, 0), v = riseV(t, t1, 0)
	if u <= 0.001 || v >= 0.999 { return }
	c.saveGState()
	c.translateBy(x: 0, y: (1 - CGFloat(u)) * size * 0.95 - CGFloat(v) * size * 0.95)
	body(CGFloat(min(1, u * 1.5)) * CGFloat(1 - v))
	c.restoreGState()
}

// ---------------------------------------------------------------- icons (vector, so no glyph fallback)
func checkMark(_ c: CGContext, _ p: CGPoint, _ s: CGFloat, _ color: UInt32, _ a: CGFloat, lw: CGFloat) {
	if a <= 0.003 { return }
	c.setStrokeColor(col(color, a)); c.setLineWidth(lw); c.setLineCap(.round); c.setLineJoin(.round)
	c.move(to: CGPoint(x: p.x - s * 0.42, y: p.y + s * 0.02))
	c.addLine(to: CGPoint(x: p.x - s * 0.12, y: p.y + s * 0.32))
	c.addLine(to: CGPoint(x: p.x + s * 0.44, y: p.y - s * 0.3))
	c.strokePath()
}
func checkDisc(_ c: CGContext, _ p: CGPoint, _ d: CGFloat, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setFillColor(col(FIELD, a)); c.fillEllipse(in: CGRect(x: p.x - d / 2, y: p.y - d / 2, width: d, height: d))
	checkMark(c, p, d * 0.5, PAPER, a, lw: d * 0.1)
}
func arrowIcon(_ c: CGContext, _ p: CGPoint, _ s: CGFloat, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setStrokeColor(col(color, a)); c.setLineWidth(s * 0.13); c.setLineCap(.round); c.setLineJoin(.round)
	c.move(to: CGPoint(x: p.x - s * 0.45, y: p.y)); c.addLine(to: CGPoint(x: p.x + s * 0.42, y: p.y))
	c.move(to: CGPoint(x: p.x + s * 0.08, y: p.y - s * 0.34)); c.addLine(to: CGPoint(x: p.x + s * 0.45, y: p.y)); c.addLine(to: CGPoint(x: p.x + s * 0.08, y: p.y + s * 0.34))
	c.strokePath()
}
/// a padlock; `open` lifts the shackle clear of the body
func lockIcon(_ c: CGContext, _ p: CGPoint, _ s: CGFloat, _ color: UInt32, _ a: CGFloat, open: Double) {
	if a <= 0.003 { return }
	let bw = s * 0.8, bh = s * 0.6
	let body = CGRect(x: p.x - bw / 2, y: p.y - bh * 0.18, width: bw, height: bh)
	c.setFillColor(col(color, a)); c.addPath(rrectPath(body, s * 0.13)); c.fillPath()
	let lift = CGFloat(open) * s * 0.2, sw = s * 0.5, lw = s * 0.12
	let top = body.minY - s * 0.3 - lift
	c.setStrokeColor(col(color, a)); c.setLineWidth(lw); c.setLineCap(.butt)
	let pth = CGMutablePath()
	pth.move(to: CGPoint(x: p.x + sw / 2, y: body.minY + 1))
	pth.addLine(to: CGPoint(x: p.x + sw / 2, y: top + sw / 2))
	pth.addArc(center: CGPoint(x: p.x, y: top + sw / 2), radius: sw / 2, startAngle: 0, endAngle: .pi, clockwise: true)
	pth.addLine(to: CGPoint(x: p.x - sw / 2, y: body.minY + 1 - lift * 1.6))
	c.addPath(pth); c.strokePath()
	// the keyhole
	c.setFillColor(col(PAPER, a)); c.fillEllipse(in: CGRect(x: p.x - s * 0.07, y: body.midY - s * 0.09, width: s * 0.14, height: s * 0.14))
}

// ---------------------------------------------------------------- the lattice (pure maths; rows in parallel)
let PITCH = 7.0
let LCOLS = Int((Double(DW) / PITCH).rounded(.up)), LROWS = Int((Double(DH) / PITCH).rounded(.up))
let BAND_Y: CGFloat = 868                                   // the caption band starts here
let BAYER: [Float] = {
	let m: [Int] = [0, 32, 8, 40, 2, 34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44, 4, 36, 14, 46, 6, 38, 60, 28, 52, 20, 62, 30, 54, 22,
	                3, 35, 11, 43, 1, 33, 9, 41, 51, 19, 59, 27, 49, 17, 57, 25, 15, 47, 7, 39, 13, 45, 5, 37, 63, 31, 55, 23, 61, 29, 53, 21]
	return m.map { (Float($0) + 0.5) / 64 }
}()
let CELL_RND: [Double] = (0..<(LCOLS * LROWS)).map { hash01($0 &* 7919, 104729) }

// the hook: "v0.0.9" as lattice coverage (rendered once at 1x, averaged over 4 points per cell)
let NUM_F = sans(300, 500), NUM_S = "v0.0.9"
let NUM_W = textW(NUM_S, NUM_F)
let NUM_X0 = 960 - NUM_W / 2, NUM_BASE: CGFloat = 560
let NUM_MID = CGPoint(x: 960, y: NUM_BASE - capH(NUM_F) / 2)
let NUM_CELLS: [Float] = {
	let w = Int(DW), h = Int(DH)
	var px = [UInt8](repeating: 0, count: w * h)
	px.withUnsafeMutableBytes { raw in
		let g = CGContext(data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		g.translateBy(x: 0, y: CGFloat(h)); g.scaleBy(x: 1, y: -1)
		g.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
		g.textPosition = CGPoint(x: NUM_X0, y: NUM_BASE)
		CTLineDraw(ctline(NUM_S, NUM_F, col(0xffffff)), g)
	}
	var out = [Float](repeating: 0, count: LCOLS * LROWS)
	for r in 0..<LROWS {
		for c in 0..<LCOLS {
			var s: Float = 0
			for (ox, oy) in [(0.3, 0.3), (0.7, 0.3), (0.3, 0.7), (0.7, 0.7)] {
				let x = min(w - 1, Int((Double(c) + ox) * PITCH)), y = min(h - 1, Int((Double(r) + oy) * PITCH))
				s += Float(px[y * w + x]) / 255
			}
			out[r * LCOLS + c] = s / 4
		}
	}
	return out
}()
func solidWipeX(_ t: Double) -> CGFloat { lerpC(NUM_X0 - 40, NUM_X0 + NUM_W + 60, ease(seg(t, T_SOLID, T_SOLID + 0.32))) }

// speed: streaks of recalled dots rush past while the counter runs
struct Streak { let row: Int; let t0: Double; let speed: Double; let len: Double }
let STREAKS: [Streak] = (0..<48).map { i in
	Streak(row: 7 + Int(hash01(i, 11) * 113), t0: T_SPD - 0.08 + pow(hash01(i, 12), 1.5) * b(5.4),
	       speed: 2600 + 1900 * hash01(i, 13), len: 170 + 330 * hash01(i, 14))
}
func streakEnv(_ t: Double) -> Double { smooth(seg(t, T_SPD - 0.08, T_SPD + 0.1)) * (1 - smooth(seg(t, b(37.4), b(38.7)))) }

// shockwaves: rings of recalled dots running out from each hit (screen space, where the hit is when it lands)
struct Wave { let t: Double; let x: Double; let y: Double; let speed: Double; let amp: Double }
var WAVES: [Wave] = []
func makeWaves() {
	func at(_ t: Double, _ x: CGFloat, _ y: CGFloat, _ sp: Double, _ amp: Double) {
		let p = toScreen(x, y, camAt(t)); WAVES.append(Wave(t: t, x: Double(p.x), y: Double(p.y), speed: sp, amp: amp))
	}
	at(T_SOLID + 0.1, NUM_MID.x, NUM_MID.y, 1900, 0.65)
	at(T_CHIP + 0.03, K_CHIP.cx, K_CHIP.cy, 1100, 0.35)
	at(T_ENTER + 0.02, K_TERM.cx, K_TERM.cy, 2300, 1.0)
	at(T_V5 + 0.03, K_CODE.cx, K_CODE.cy, 1700, 0.6)
	at(T_RESULT + 0.25, 960, K_CODE_UP.maxY + 84, 1200, 0.45)
	at(T_SEC + 0.03, K_REQ.cx, K_REQ.cy, 1700, 0.6)
	at(T_401 + 0.02, RESP_LOCK_X, RESP.cy, 1100, 0.45)
	at(T_200 + 0.02, RESP_LOCK_X, RESP.cy, 1100, 0.45)
	at(T_SPD + 0.02, K_SPD.cx, K_SPD.cy, 2500, 0.95)
	at(T_COUNT1, K_SPD.cx, K_SPD.cy, 1600, 0.5)
	at(T_SLICE + 0.05, K_SPD.cx, K_SPD.cy, 1500, 0.45)
	for i in DISSOLVE_ORDER { if let td = dissolveT(i) { at(td + 0.02, sqCenterX(i), K_SPD.cy, 900, 0.3) } }
	at(T_MARK + 0.05, MARK_C.x, MARK_C.y, 1900, 0.75)
	at(WORD_T + 0.02, LOCK_MARK_C.x, LOCK_Y, 2100, 0.85)
}
/// the lattice breathes with the kit: a soft swell on every kick and snare while the drums play
func latticePulse(_ t: Double) -> Double {
	if t < T_ENTER - 0.01 || t > T_DROPOUT + 0.6 { return 0 }
	var p = 0.0
	for (h, g) in DRUM_HITS where t > h && t < h + 0.6 { let u = t - h; p += 0.42 * g * (1 - exp(-u / 0.02)) * exp(-u / 0.12) }
	return p
}
/// the light's own clock: it slows to a stop over the last 0.8s before the still, so the ground never stops dead
func driftTime(_ t: Double) -> Double {
	let a = T_STILL - 0.8
	if t <= a { return t }
	let u = min(1, (t - a) / 0.8)
	return a + 0.8 * (u - u * u / 2)
}
func paintField(_ out: UnsafeMutablePointer<UInt8>, _ t: Double) {
	if WAVES.isEmpty { makeWaves() }
	let base = 0.032 * (1 + latticePulse(t))
	let sc = Double(SC)
	let fieldC = rgb(FIELD), b500 = rgb(BLUE500), paperC = rgb(PAPER)
	let latC: (Float, Float, Float) = (fieldC.0 + (148 - fieldC.0) * 0.32, fieldC.1 + (182 - fieldC.1) * 0.32, fieldC.2 + (255 - fieldC.2) * 0.32)
	var tone = [Float](repeating: 0, count: LCOLS * LROWS), rot = [Float](repeating: 0, count: LCOLS * LROWS), kind = [UInt8](repeating: 0, count: LCOLS * LROWS)
	// per frame: where things are
	let hookOn = t < T_SOLID + 0.45
	let wipe = Double(solidWipeX(t))
	let shimX = Double(lerpC(NUM_X0 - 160, NUM_X0 + NUM_W + 160, seg(t, -0.15, T_SOLID)))
	let sEnv = streakEnv(t)
	var dis: [(CGRect, Double)] = []
	if t > T_DROPOUT - 0.1 && t < T_DROPOUT + 1.6 {
		for i in DISSOLVE_ORDER {
			guard let td = dissolveT(i), t > td else { continue }
			let cam = camAt(td), bx = sliceBox(i, td)
			let p0 = toScreen(bx.minX, bx.minY, cam), p1 = toScreen(bx.maxX, bx.maxY, cam)
			dis.append((CGRect(x: p0.x, y: p0.y, width: p1.x - p0.x, height: p1.y - p0.y).insetBy(dx: -4, dy: -4), td))
		}
	}
	tone.withUnsafeMutableBufferPointer { T in rot.withUnsafeMutableBufferPointer { Rr in kind.withUnsafeMutableBufferPointer { K in
		DispatchQueue.concurrentPerform(iterations: LROWS) { r in
			let sy = (Double(r) + 0.5) * PITCH
			for c in 0..<LCOLS {
				let i = r * LCOLS + c
				let sx = (Double(c) + 0.5) * PITCH
				let rnd = CELL_RND[i]
				var tv = base, rv = 0.0, kv: UInt8 = 0
				// the hook: the version, recalled out of the lattice; the solid type wipes over it on b2
				if hookOn {
					let m = Double(NUM_CELLS[i])
					if m > 0.12 && sx > wipe - 6 {
						let tin = -b(3.2) + b(2.2) * (sx - Double(NUM_X0)) / Double(NUM_W) + b(0.5) * rnd
						let a = smooth((t - tin) / b(0.6))
						let sh = exp(-pow((sx - shimX) / 70, 2))
						let tt = base + (min(1, 0.72 + 0.28 * sh) - base) * a * min(1, m * 1.25)
						if tt > tv { tv = tt; rv = a * (1 - 0.5 * sh); kv = 1 }
					}
				}
				// speed: streaks of recalled dots
				if sEnv > 0.001 {
					for s in STREAKS where s.row == r && t > s.t0 {
						let head = 1920 + 40 - (t - s.t0) * s.speed
						let d = sx - head
						if d >= 0 && d < s.len {
							let a = (1 - d / s.len) * sEnv
							let tt = base + (0.85 - base) * a
							if tt > tv { tv = tt; rv = 1; kv = 1 }
						}
					}
				}
				// the nine squares fall back into the lattice: recalled, then stored, then gone
				for (rc, td) in dis where rc.contains(CGPoint(x: sx, y: sy)) {
					let u = t - td
					let a = exp(-u / 0.32) * min(1, u / 0.04)
					let tt = base + (0.9 - base) * a * (0.75 + 0.25 * rnd)
					if tt > tv { tv = tt; rv = 1 - smooth(u / 0.45); kv = 1 }
				}
				// shockwaves
				for w in WAVES where t > w.t && t < w.t + 0.75 {
					let rad = (t - w.t) * w.speed
					let dd = abs(hypot(sx - w.x, sy - w.y) - rad)
					if dd < 60 {
						let a = (1 - (t - w.t) / 0.75) * exp(-dd * dd / 900) * w.amp * min(1, (t - w.t) / 0.05)
						let tt = tv + a * 0.55
						if tt > tv { tv = min(1, tt); rv = max(rv, min(1, a * 1.4)) }
					}
				}
				T[i] = Float(tv); Rr[i] = Float(rv); K[i] = kv
			}
		}
	} } }
	// the light in the field: soft, dithered toward blue 500 (two broad pools, drifting slowly)
	let td = driftTime(t)
	let gx0 = 1500.0 - 60 * sin(td * 0.25), gy0 = 180.0, gx1 = 380.0, gy1 = 760.0 + 40 * cos(td * 0.2)
	tone.withUnsafeBufferPointer { T in rot.withUnsafeBufferPointer { Rr in kind.withUnsafeBufferPointer { K in
		DispatchQueue.concurrentPerform(iterations: PH) { Y in
			let y = (Double(Y) + 0.5) / sc
			let r = min(LROWS - 1, Int(y / PITCH))
			let cy = (Double(r) + 0.5) * PITCH
			let row = out + Y * PW * 4
			let by = (Int(y / 2) & 7) * 8
			let gyy0 = ((y - gy0) * (y - gy0)) / (420 * 420), gyy1 = ((y - gy1) * (y - gy1)) / (380 * 380)
			for X in 0..<PW {
				let x = (Double(X) + 0.5) / sc
				let g = 0.36 * exp(-(((x - gx0) * (x - gx0)) / (700 * 700) + gyy0)) + 0.22 * exp(-(((x - gx1) * (x - gx1)) / (620 * 620) + gyy1))
				let on = Float(g) > BAYER[by + (Int(x / 2) & 7)]
				var cl = on ? b500 : fieldC
				let c = min(LCOLS - 1, Int(x / PITCH))
				let cx = (Double(c) + 0.5) * PITCH
				let i = r * LCOLS + c
				let tv = Double(T[i])
				let rr = Double(Rr[i])
				let dx = x - cx, dy = y - cy
				var u = dx, v = dy
				if rr > 0.001 { let th = rr * Double.pi / 4, ct = cos(th), st = sin(th); u = dx * ct + dy * st; v = -dx * st + dy * ct }
				let hh = 0.5 * PITCH * tv.squareRoot() * (0.92 - 0.2 * rr)
				let k = Float(max(0, min(1, (hh - max(abs(u), abs(v))) * sc + 0.5)))
				if k > 0 {
					let dc = K[i] == 1 ? paperC : latC
					cl = (cl.0 + (dc.0 - cl.0) * k, cl.1 + (dc.1 - cl.1) * k, cl.2 + (dc.2 - cl.2) * k)
				}
				let o = row + X * 4
				o[2] = UInt8(max(0, min(255, cl.0))); o[1] = UInt8(max(0, min(255, cl.1))); o[0] = UInt8(max(0, min(255, cl.2))); o[3] = 255
			}
		}
	} } }
}

// ---------------------------------------------------------------- the frame: hairline grid with + marks (brand book covers)
func drawGrid(_ c: CGContext, _ t: Double) {
	let a = CGFloat(1 - 0.6 * smooth(seg(t, b(46.8), b(48))))
	let bottom = lerpC(BAND_Y, DH, smooth(seg(t, b(46.8), b(48))))
	c.setStrokeColor(col(PAPER, 0.07 * a)); c.setLineWidth(1)
	var x: CGFloat = 0
	while x <= DW { c.move(to: CGPoint(x: x, y: 0)); c.addLine(to: CGPoint(x: x, y: bottom)); x += 160 }
	var y: CGFloat = 28
	while y < bottom { c.move(to: CGPoint(x: 0, y: y)); c.addLine(to: CGPoint(x: DW, y: y)); y += 160 }
	c.strokePath()
	c.setStrokeColor(col(PAPER, 0.42 * a)); c.setLineWidth(1.2)
	x = 0
	while x <= DW {
		y = 28
		while y < bottom { c.move(to: CGPoint(x: x - 5, y: y)); c.addLine(to: CGPoint(x: x + 5, y: y)); c.move(to: CGPoint(x: x, y: y - 5)); c.addLine(to: CGPoint(x: x, y: y + 5)); y += 160 }
		x += 160
	}
	c.strokePath()
}

// ---------------------------------------------------------------- the hook: the version, then it flies into the corner
let EYE_F = mono(34, 500), EYE_S = "supermemory local"
let EYE_W = textW(EYE_S, EYE_F)
let EYE_BASE: CGFloat = 300
let HUD_X: CGFloat = 120, HUD_BASE: CGFloat = 110
let HUD_EYE_S: CGFloat = 28 / 34, HUD_NUM_S: CGFloat = 34 / 300
let HUD_NUM_X = HUD_X + EYE_W * HUD_EYE_S + 16
func hudFade(_ t: Double) -> CGFloat { CGFloat(1 - smooth(seg(t, b(46.6), b(47.4)))) }
func drawHook(_ c: CGContext, _ t: Double) {
	let flyE = ease(seg(t, T_FLY - 0.05, T_FLY + 0.5)), fly = ease(seg(t, T_FLY + 0.05, T_FLY + 0.65))
	let fade = hudFade(t)
	// the eyebrow becomes the HUD label (it leaves a moment ahead of the version, so the two never cross)
	let es = lerpC(1, HUD_EYE_S, flyE)
	let ex = lerpC(960 - EYE_W / 2, HUD_X, flyE), ey = lerpC(EYE_BASE, HUD_BASE, flyE)
	c.saveGState(); c.translateBy(x: ex, y: ey); c.scaleBy(x: es, y: es)
	text(c, EYE_S, EYE_F, 0, 0, PAPER, lerpC(0.9, 0.72, flyE) * fade)
	c.restoreGState()
	// the numerals: solid behind the wipe (the dots in front are the lattice's), a slow push, then the fly
	if t >= T_SOLID {
		let push = CGFloat(0.03 * smooth(seg(t, T_SOLID, T_FLY)))
		let s0 = 1 + push
		let ns = lerpC(s0, HUD_NUM_S, fly)
		// the left end of the baseline, under the push (about the numerals' middle), then flown to the HUD
		let px0 = NUM_MID.x + (NUM_X0 - NUM_MID.x) * s0, py0 = NUM_MID.y + (NUM_BASE - NUM_MID.y) * s0
		let nx = lerpC(px0, HUD_NUM_X, fly), ny = lerpC(py0, HUD_BASE, fly)
		c.saveGState()
		if t < T_SOLID + 0.4 { c.clip(to: CGRect(x: 0, y: 0, width: solidWipeX(t), height: DH)) }
		c.translateBy(x: nx, y: ny); c.scaleBy(x: ns, y: ns)
		text(c, NUM_S, NUM_F, 0, 0, PAPER, fade)
		c.restoreGState()
	}
}

// ---------------------------------------------------------------- 01 docker: the prompt chip, the command bar, the terminal
let T_TERM_OUT = b(15.3)
let OUT_F = mono(42, 400)
func drawTerminal(_ c: CGContext, _ bx: Box, _ t: Double) {
	if t > T_TERM_OUT + 0.7 { return }
	let k = Double(max(0, min(1, (bx.h - K_CHIP.h) / (K_BAR.h - K_CHIP.h))))
	let fs = CGFloat(lerp(32, 50, t < T_ENTER ? k : 1))
	let f = mono(fs, 450)
	let x = bx.minX + fs * 0.9
	let rowC = bx.minY + min(bx.h, K_BAR.h) / 2
	let base = midBase(f, rowC)
	// the prompt and what is typed
	let n = max(0, min(TYPED.count, Int(floor((quant(t) - T_TYPE0) / TYPE_DT)) + 1))
	let typed = String(TYPED.prefix(n))
	let outV = riseV(t, T_TERM_OUT, 0)
	let a = CGFloat(1 - outV)
	let dy = -CGFloat(outV) * fs * 0.95
	text(c, "$", f, x, base + dy, FIELD, a)
	let tx = x + textW("$ ", f)
	if t < T_TERM_OUT { riseRich(c, [(typed, INK)], f, tx, base, t, -1, T_TERM_OUT) } else { riseRich(c, [(TYPED, INK)], f, tx, base, t, -1, T_TERM_OUT) }
	// the caret: solid while typing, blinking when idle, gone after enter
	if t < T_ENTER {
		let typing = t > T_TYPE0 && t < T_TYPE1 + 0.08
		let on = typing || (quant(t).truncatingRemainder(dividingBy: 0.6) < 0.36)
		if on {
			let cw = fs * 0.55, ch = capH(f) * 1.3
			let cxp = tx + textW(typed, f) + (n > 0 ? fs * 0.06 : 0)
			c.setFillColor(col(INK, 0.9)); c.fill(CGRect(x: cxp, y: base - capH(f) - (ch - capH(f)) / 2, width: cw, height: ch))
		}
	}
	// the image pulls on the drop: a bar fills, then hands over to the first line
	let r2c = bx.minY + K_BAR.h / 2 + 104
	if t > T_ENTER + 0.15 && t < T_OUT1 + 0.4 {
		let u = eout(seg(t, T_ENTER + 0.2, T_ENTER + 0.5)), v = ease(seg(t, T_OUT1 - 0.1, T_OUT1 + 0.16))
		let a = CGFloat(u) * CGFloat(1 - v), dy = (1 - CGFloat(u)) * 30 - CGFloat(v) * 34
		let x0 = x + 4, x1 = bx.maxX - fs * 0.9 - 4, y0 = r2c - 5 + dy
		let fill = eout(seg(t, T_ENTER + 0.24, T_OUT1 - 0.06))
		c.setFillColor(col(INK, 0.08 * a)); c.addPath(rrectPath(CGRect(x: x0, y: y0, width: x1 - x0, height: 10), 5)); c.fillPath()
		c.setFillColor(col(FIELD, a)); c.addPath(rrectPath(CGRect(x: x0, y: y0, width: max(10, (x1 - x0) * CGFloat(fill)), height: 10), 5)); c.fillPath()
	}
	// the output, one line per beat
	if t >= T_OUT1 - 0.05 {
		let r2 = midBase(OUT_F, r2c), r3 = midBase(OUT_F, bx.minY + K_BAR.h / 2 + 182)
		let ix = x + 10, ox = x + 62
		riseIcon(c, t, T_OUT1, T_TERM_OUT + 0.02, 42) { a in checkMark(c, CGPoint(x: ix + 6, y: r2 - capH(OUT_F) / 2), 30, FIELD, a, lw: 5) }
		riseRich(c, [("supermemory", INK), ("   started", INK2)], OUT_F, ox, r2, t, T_OUT1, T_TERM_OUT + 0.02, j0: 1)
		riseIcon(c, t, T_OUT2, T_TERM_OUT + 0.04, 42) { a in arrowIcon(c, CGPoint(x: ix + 6, y: r3 - capH(OUT_F) / 2), 34, FIELD, a) }
		riseRich(c, [("127.0.0.1", INK), (":6767", FIELD)], OUT_F, ox, r3, t, T_OUT2, T_TERM_OUT + 0.04, j0: 1)
	}
}

// ---------------------------------------------------------------- 02 api v5: the call, namespace first, and the memory back
let CODE_F = mono(46, 400)
let T_CODE_IN = b(16.3), T_CODE_OUT = b(23.3)
let CODE_ROWS: [[Tok]] = [
	[("client.search(", INK), ("\"user_dhravya\"", FIELD), (", {", INK2)],
	[("  query: ", INK), ("\"what food should I avoid?\"", FIELD), (",", INK2)],
	[("})", INK2)],
]
func drawCode(_ c: CGContext, _ bx: Box, _ t: Double) {
	if t < T_CODE_IN || t > T_CODE_OUT + 0.8 { return }
	let x = bx.minX + 64
	for (i, row) in CODE_ROWS.enumerated() {
		let base = midBase(CODE_F, bx.minY + 86 + CGFloat(i) * 74)
		if i == 0 {
			// v5 is namespace first: the namespace lights up
			let k = ease(seg(t, T_NS, T_NS + 0.35)) * (1 - riseV(t, T_CODE_OUT, 0))
			if k > 0.001 {
				let x0 = x + textW("client.search(", CODE_F) - 10, w = textW("\"user_dhravya\"", CODE_F) + 20
				let r = CGRect(x: x0, y: base - capH(CODE_F) - 14, width: w * CGFloat(k), height: capH(CODE_F) + 28)
				c.setFillColor(col(FIELD, 0.1)); c.addPath(rrectPath(r, 10)); c.fillPath()
			}
		}
		riseRich(c, row, CODE_F, x, base, t, T_CODE_IN + 0.11 * Double(i), T_CODE_OUT + 0.05 * Double(i))
	}
}
let RES_F = sans(40, 500)
let RES_S = "Dhravya is allergic to peanuts"
let K_RES = Box(cx: 960, cy: K_CODE_UP.maxY + 84, w: textW(RES_S, RES_F) + 150, h: 94, r: 47)
let K_RES_IN = Box(cx: 960, cy: K_CODE_UP.maxY - 50, w: 320, h: 60, r: 30)
func resBox(_ t: Double) -> Box? {
	if t < T_RESULT || t > T_SEC + 0.1 { return nil }
	if t < T_CODE_OUT { return morph(K_RES_IN, K_RES, t, T_RESULT) }
	return morph(K_RES, Box(cx: 960, cy: K_REQ.cy, w: 320, h: 60, r: 30), t, T_CODE_OUT + 0.1)
}
func drawResult(_ c: CGContext, _ t: Double) {
	guard let bx = resBox(t) else { return }
	fillBox(c, bx, PAPER)
	c.saveGState(); c.addPath(rrectPath(bx.rect, bx.r)); c.clip()
	let base = midBase(RES_F, bx.cy)
	let t0 = T_RESULT + 0.12, t1 = T_CODE_OUT - 0.05
	riseIcon(c, t, t0, t1, 40) { a in checkDisc(c, CGPoint(x: bx.minX + 54, y: bx.cy), 44, a) }
	riseRich(c, [(RES_S, INK)], RES_F, bx.minX + 96, base, t, t0, t1, j0: 1)
	c.restoreGState()
}

// ---------------------------------------------------------------- 03 security: a request, a lock, the key, 200
let REQ_F = mono(44, 400), METHOD_F = mono(28, 600), AUTH_F = mono(40, 400)
let T_REQ_IN = b(24.3), T_REQ_OUT = b(31.3)
func fireLine(_ c: CGContext, _ bx: Box, _ t: Double, _ tf: Double) {
	if t < tf || t > tf + 0.6 { return }
	let x1 = lerpC(bx.minX, bx.maxX, eout(seg(t, tf, tf + 0.3)))
	let a = CGFloat(1 - seg(t, tf + 0.3, tf + 0.55))
	c.setFillColor(col(FIELD, a)); c.fill(CGRect(x: bx.minX, y: bx.maxY - 7, width: x1 - bx.minX, height: 7))
}
func drawRequest(_ c: CGContext, _ bx: Box, _ t: Double) {
	if t < T_REQ_IN || t > T_REQ_OUT + 0.8 { return }
	let x = bx.minX + 40
	let rowC = bx.minY + K_REQ.h / 2
	// the method pill
	let mw = textW("POST", METHOD_F) + 34, mh: CGFloat = 52
	let u = riseU(t, T_REQ_IN, 0), v = riseV(t, T_REQ_OUT, 0)
	if u > 0.001 && v < 0.999 {
		let dy = (1 - CGFloat(u)) * 50 - CGFloat(v) * 50, a = CGFloat(min(1, u * 1.5)) * CGFloat(1 - v)
		let r = CGRect(x: x, y: rowC - mh / 2 + dy, width: mw, height: mh)
		c.setFillColor(col(FIELD, a)); c.addPath(rrectPath(r, 12)); c.fillPath()
		text(c, "POST", METHOD_F, r.midX, midBase(METHOD_F, r.midY), PAPER, a, .center)
	}
	riseRich(c, [("localhost:6767", INK), ("/ns/user_dhravya/search", INK2)], REQ_F, x + mw + 26, midBase(REQ_F, rowC), t, T_REQ_IN + 0.04, T_REQ_OUT, j0: 2)
	// the key row
	if t > T_AUTH {
		let base2 = midBase(AUTH_F, rowC + 88)
		riseRich(c, [("Authorization: ", INK2), ("Bearer sm_", INK), ("••••••••••", FIELD)], AUTH_F, x + 6, base2, t, T_AUTH + 0.08, T_REQ_OUT + 0.03)
	}
	fireLine(c, bx, t, T_FIRE1)
	fireLine(c, bx, t, T_FIRE2)
}
let RESP_F = mono(40, 600), RESP2_F = sans(40, 500)
let RESP = Box(cx: 960, cy: 612, w: 660, h: 96, r: 48)
let RESP_LOCK_X = RESP.minX + 62
func respBox(_ t: Double) -> Box? {
	let t0 = T_401 - 0.3
	if t < t0 || t > T_SPD + 0.1 { return nil }
	let from = Box(cx: 960, cy: K_REQ.maxY - 40, w: 300, h: 60, r: 30)
	if t < T_REQ_OUT { return morph(from, RESP, t, t0) }
	return morph(RESP, Box(cx: 960, cy: K_REQ2.cy, w: 300, h: 60, r: 30), t, T_REQ_OUT + 0.1)
}
func drawResponse(_ c: CGContext, _ t: Double) {
	guard let bx = respBox(t) else { return }
	fillBox(c, bx, PAPER)
	c.saveGState(); c.addPath(rrectPath(bx.rect, bx.r)); c.clip()
	let base = midBase(RESP_F, bx.cy)
	let lockX = bx.minX + 62
	// the lock: it shuts on the 401 and opens on the 200
	let open = 1 - spring(t, T_401 - 0.02, freq: 3.2, zeta: 0.5) + spring(t, T_200 - 0.02, freq: 3.2, zeta: 0.5)
	let ok = smooth(seg(t, T_200 - 0.05, T_200 + 0.1))
	let lu = riseU(t, T_401 - 0.18, 0), lv = riseV(t, T_REQ_OUT - 0.05, 0)
	if lu > 0.001 && lv < 0.999 {
		c.saveGState(); c.translateBy(x: 0, y: (1 - CGFloat(lu)) * 40 - CGFloat(lv) * 40)
		let lc = ok > 0.5 ? FIELD : INK
		lockIcon(c, CGPoint(x: lockX, y: bx.cy + 2), 46, lc, CGFloat(min(1, lu * 1.5)) * CGFloat(1 - lv), open: open)
		c.restoreGState()
	}
	let tx = bx.minX + 110
	riseRich(c, [("401", INK), ("  ", INK), ("api key required", INK2)], RESP_F, tx, base, t, T_401 - 0.12, T_200 - 0.2)
	riseRich(c, [("200", FIELD), ("  ", INK), ("ok", INK2)], RESP_F, tx, base, t, T_200 + 0.04, T_REQ_OUT - 0.05)
	c.restoreGState()
}

// ---------------------------------------------------------------- 04 speed: a counter, 0 to 40%
let BIG_F = sans(250, 600), FASTER_F = sans(58, 500)
let T_SPD_IN = b(32.3), T_SPD_OUT = b(38.5)
let DIGIT_W: CGFloat = (0...9).map { textW(String($0), BIG_F) }.max()!
func counterValue(_ t: Double) -> Double { 40 * eout(seg(t, T_SPD_IN, T_COUNT1)) }
func drawSpeed(_ c: CGContext, _ bx: Box, _ t: Double) {
	if t < T_SPD_IN - 0.05 || t > T_SPD_OUT + 0.8 { return }
	let v = counterValue(t)
	let pctW = textW("%", BIG_F)
	let groupW = 2 * DIGIT_W + pctW
	let x0 = bx.cx - groupW / 2
	let base = bx.cy + 30
	let cap = capH(BIG_F), lineH = cap * 1.45
	let inU = eout(seg(t, T_SPD_IN - 0.05, T_SPD_IN + 0.35)), outV = ease(seg(t, T_SPD_OUT, T_SPD_OUT + 0.3))
	let a = CGFloat(min(1, inU * 1.4)) * CGFloat(1 - outV)
	let lift = (1 - CGFloat(inU)) * cap * 0.6 - CGFloat(outV) * cap * 0.9
	c.saveGState()
	c.clip(to: CGRect(x: bx.minX, y: base - cap - 26, width: bx.w, height: cap + 52))
	// an odometer: the ones roll through every number, the tens roll on the carry; a blank tens cell below 10
	func column(_ pos: Double, _ x: CGFloat, blankZero: Bool) {
		let lo = floor(pos), fr = CGFloat(pos - lo)
		for (d, off) in [(Int(lo), -fr), (Int(lo) + 1, 1 - fr)] {
			let digit = ((d % 10) + 10) % 10
			if blankZero && d == 0 { continue }
			let s = String(digit)
			text(c, s, BIG_F, x + (DIGIT_W - textW(s, BIG_F)) / 2, base + lift + off * lineH, FIELD, a)
		}
	}
	let ones = v, tens = floor(v / 10) + smooth((v.truncatingRemainder(dividingBy: 10) - 9))
	column(ones, x0 + DIGIT_W, blankZero: false)
	column(tens, x0, blankZero: true)
	text(c, "%", BIG_F, x0 + 2 * DIGIT_W, base + lift, FIELD, a)
	c.restoreGState()
	riseText(c, "faster", FASTER_F, bx.cx, base + 104, INK2, t, T_SPD_IN + 0.25, T_SPD_OUT, .center)
}

// ---------------------------------------------------------------- 05 next: ten squares, then one
let SQ: CGFloat = 84, SQ_GAP: CGFloat = 24
func sqCenterX(_ i: Int) -> CGFloat { 960 - (10 * SQ + 9 * SQ_GAP) / 2 + SQ / 2 + CGFloat(i) * (SQ + SQ_GAP) }
func sliceBox(_ i: Int, _ t: Double) -> Box {
	let sw = K_SPD.w / 10
	let from = Box(cx: K_SPD.minX + sw * (CGFloat(i) + 0.5), cy: K_SPD.cy, w: sw, h: K_SPD.h, r: 0)
	let to = Box(cx: sqCenterX(i), cy: K_SPD.cy, w: SQ, h: SQ, r: 6)
	return morph(from, to, t, sliceT0(i), lag: 0.03)
}
/// a rounded rect with its own radius at each corner (tl, tr, br, bl)
func rrect4(_ r: CGRect, _ tl: CGFloat, _ tr: CGFloat, _ br: CGFloat, _ bl: CGFloat) -> CGPath {
	let m = min(r.width, r.height) / 2 - 0.01
	let a = max(0, min(tl, m)), b2 = max(0, min(tr, m)), c2 = max(0, min(br, m)), d = max(0, min(bl, m))
	let p = CGMutablePath()
	p.move(to: CGPoint(x: r.minX + a, y: r.minY))
	p.addLine(to: CGPoint(x: r.maxX - b2, y: r.minY))
	if b2 > 0 { p.addArc(tangent1End: CGPoint(x: r.maxX, y: r.minY), tangent2End: CGPoint(x: r.maxX, y: r.minY + b2), radius: b2) }
	p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - c2))
	if c2 > 0 { p.addArc(tangent1End: CGPoint(x: r.maxX, y: r.maxY), tangent2End: CGPoint(x: r.maxX - c2, y: r.maxY), radius: c2) }
	p.addLine(to: CGPoint(x: r.minX + d, y: r.maxY))
	if d > 0 { p.addArc(tangent1End: CGPoint(x: r.minX, y: r.maxY), tangent2End: CGPoint(x: r.minX, y: r.maxY - d), radius: d) }
	p.addLine(to: CGPoint(x: r.minX, y: r.minY + a))
	if a > 0 { p.addArc(tangent1End: CGPoint(x: r.minX, y: r.minY), tangent2End: CGPoint(x: r.minX + a, y: r.minY), radius: a) }
	p.closeSubpath()
	return p
}
/// the corner radii of slice i: the card's 40 on its outer corners at the cut, 6 everywhere once it is a square
func sliceRadii(_ i: Int, _ t: Double) -> (CGFloat, CGFloat) {
	let k = spring(t, sliceT0(i))
	let outer = lerpC(K_SPD.r, 6, k), inner = lerpC(0, 6, k)
	return (i == 0 ? outer : inner, i == 9 ? outer : inner)          // (left corners, right corners)
}
let MARK_C = CGPoint(x: 960, y: 470), MARK_H: CGFloat = 176
let K_SURV = Box(cx: 960, cy: MARK_C.y, w: 116, h: 116, r: 6)
let K_MARKBOX = Box(cx: MARK_C.x, cy: MARK_C.y, w: MARK_H * CGFloat(G_MW / G_MH), h: MARK_H, r: 0)
func survivorBox(_ t: Double) -> Box {
	let s = sliceBox(SURVIVOR, t)
	if t < T_SURV { return s }
	if t < T_MARK { return morph(sliceBox(SURVIVOR, T_SURV), K_SURV, t, T_SURV, lag: 0.02) }
	return morph(K_SURV, K_MARKBOX, t, T_MARK, lag: 0.015)
}
func drawSlices(_ c: CGContext, _ t: Double) {
	for i in 0..<10 where i != SURVIVOR {
		var bx = sliceBox(i, t)
		var turn = 0.0
		if let td = dissolveT(i), t > td {
			let u = ease(seg(t, td, td + 0.17))
			if u >= 1 { continue }
			bx.w *= CGFloat(1 - u); bx.h *= CGFloat(1 - u); turn = u
		}
		let (rl, rr) = sliceRadii(i, t)
		let sh = CGFloat(1 - turn)
		c.saveGState(); c.translateBy(x: bx.cx, y: bx.cy); c.rotate(by: CGFloat(turn * Double.pi / 4))
		c.setFillColor(col(PAPER)); c.addPath(rrect4(CGRect(x: -bx.w / 2, y: -bx.h / 2, width: bx.w, height: bx.h), rl * sh, rr * sh, rr * sh, rl * sh)); c.fillPath()
		c.restoreGState()
	}
}
// the mark, carved out of the last square: a distance field of the mark, thresholded down to zero
let MARK_DIST: (w: Int, h: Int, d: [Float]) = {
	let w = MARK.width, h = MARK.height
	var px = [UInt8](repeating: 0, count: w * h)
	px.withUnsafeMutableBytes { raw in
		let g = CGContext(data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		g.draw(MARK, in: CGRect(x: 0, y: 0, width: w, height: h))
	}
	// chamfer distance (3-4), outside the ink; ink is 0
	let INF: Float = 1e9
	var d = px.map { $0 > 127 ? Float(0) : INF }
	for y in 0..<h { for x in 0..<w {
		var v = d[y * w + x]
		if x > 0 { v = min(v, d[y * w + x - 1] + 3) }
		if y > 0 { v = min(v, d[(y - 1) * w + x] + 3); if x > 0 { v = min(v, d[(y - 1) * w + x - 1] + 4) }; if x < w - 1 { v = min(v, d[(y - 1) * w + x + 1] + 4) } }
		d[y * w + x] = v
	} }
	for y in stride(from: h - 1, through: 0, by: -1) { for x in stride(from: w - 1, through: 0, by: -1) {
		var v = d[y * w + x]
		if x < w - 1 { v = min(v, d[y * w + x + 1] + 3) }
		if y < h - 1 { v = min(v, d[(y + 1) * w + x] + 3); if x < w - 1 { v = min(v, d[(y + 1) * w + x + 1] + 4) }; if x > 0 { v = min(v, d[(y + 1) * w + x - 1] + 4) } }
		d[y * w + x] = v
	} }
	return (w, h, d.map { $0 / 3 })
}()
let MARK_DMAX: Float = MARK_DIST.d.max()!
func carvedMark(_ thr: Float) -> CGImage {
	let w = MARK_DIST.w, h = MARK_DIST.h
	var px = [UInt8](repeating: 0, count: w * h)
	for i in 0..<(w * h) { px[i] = UInt8(max(0, min(255, (thr - MARK_DIST.d[i] + 0.5) * 255))) }
	return px.withUnsafeMutableBytes { raw -> CGImage in
		let g = CGContext(data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		return g.makeImage()!
	}
}
let END_LOCK_H: CGFloat = 84
let LOCK_W = END_LOCK_H * CGFloat((G_MW + G_GAP + G_WW) / G_MH)
let LOCK_X = DW / 2 - LOCK_W / 2, LOCK_Y: CGFloat = 446
let LOCK_MARK_C = CGPoint(x: LOCK_X + END_LOCK_H * CGFloat(G_MW / G_MH) / 2, y: LOCK_Y)
let WORD_R = CGRect(x: LOCK_X + END_LOCK_H * CGFloat((G_MW + G_GAP) / G_MH), y: LOCK_Y - END_LOCK_H / 2 + END_LOCK_H * CGFloat(G_WOFF / G_MH),
                    width: END_LOCK_H * CGFloat(G_WW / G_MH), height: END_LOCK_H * CGFloat(G_WH / G_MH))
let T_CARVE = T_MARK + 0.1
func drawSurvivor(_ c: CGContext, _ t: Double) {
	if t < T_SURV {
		let bx = survivorBox(t), (rl, rr) = sliceRadii(SURVIVOR, t)
		c.setFillColor(col(PAPER)); c.addPath(rrect4(bx.rect, rl, rr, rr, rl)); c.fillPath()
		return
	}
	if t < T_CARVE {
		var bx = survivorBox(t)
		// the last square breathes on the piano while the caption reads
		if t > T_SURV + 0.4 && t < T_MARK {
			let p = 0.035 * (bump(t, b(42), 0.03, 0.2) + bump(t, b(44), 0.03, 0.2))
			bx.w *= CGFloat(1 + p); bx.h *= CGFloat(1 + p)
		}
		fillBox(c, bx, PAPER)
		return
	}
	// the carve, then the move into the lockup
	let thr = Float(1 - ease(seg(t, T_CARVE, T_CARVE + 0.42))) * MARK_DMAX
	let k = ease(seg(t, WORD_T, WORD_T + 0.7))
	let bx = survivorBox(t)
	let lock = markRect(center: LOCK_MARK_C, height: END_LOCK_H)
	let r = CGRect(x: lerpC(bx.minX, lock.minX, k), y: lerpC(bx.minY, lock.minY, k), width: lerpC(bx.w, lock.width, k), height: lerpC(bx.h, lock.height, k))
	c.saveGState(); c.addPath(rrectPath(r, bx.r)); c.clip()
	if thr > 0.5 { paintMask(c, carvedMark(thr), r, PAPER, 1) } else { paintMask(c, MARK, r, PAPER, 1) }
	c.restoreGState()
}
func bump(_ t: Double, _ t0: Double, _ up: Double, _ down: Double) -> Double {
	if t < t0 { return 0 }
	let u = t - t0
	return (1 - exp(-u / up)) * exp(-u / down)
}

// ---------------------------------------------------------------- the stage (under the camera)
func drawStage(_ c: CGContext, _ t: Double) {
	if t < T_SLICE {
		drawResult(c, t)                  // the chips slide out from under the box, so they are drawn first
		drawResponse(c, t)
		if let bx = boxAt(t) {
			fillBox(c, bx, PAPER)
			c.saveGState(); c.addPath(rrectPath(bx.rect, bx.r)); c.clip()
			drawTerminal(c, bx, t)
			drawCode(c, bx, t)
			drawRequest(c, bx, t)
			drawSpeed(c, bx, t)
			c.restoreGState()
		}
	} else {
		drawSlices(c, t)
		drawSurvivor(c, t)
	}
}

// ---------------------------------------------------------------- the end: the wordmark, the version, the command
let VER_F = mono(36, 500), CMD_F = mono(44, 450)
let CMD_S = "npx supermemory local"
let K_CMD = Box(cx: 960, cy: 656, w: textW("$ " + CMD_S, CMD_F) + 84, h: 94, r: 47)
func drawEnd(_ c: CGContext, _ t: Double) {
	if t < WORD_T { return }
	let mx = lerpC(MARK_C.x, LOCK_MARK_C.x, ease(seg(t, WORD_T, WORD_T + 0.7)))
	let mh = lerpC(MARK_H, END_LOCK_H, ease(seg(t, WORD_T, WORD_T + 0.7)))
	let front = lerpC(WORD_R.minX, WORD_R.maxX + 200, ease(seg(t, WORD_T + 0.06, WORD_T + 0.7)))
	paintMaskRamp(c, WORD, WORD_R, PAPER) { x in
		let behind = CGFloat(smooth(Double((x - mx - mh * CGFloat(G_MW / G_MH) * 0.5 - 8) / 30)))
		return behind * max(0, min(1, (front - x) / 200))
	}
	riseRich(c, [("local v0.0.9", PAPER)], VER_F, 960, 560, t, WORD_T + 0.18, 1e9, .center, alpha: 0.8, fast: true)
	if t > T_CMD {
		let bx = morphF(Box(cx: 960, cy: K_CMD.cy, w: 60, h: 20, r: 10), K_CMD, t, T_CMD, freq: 3.2)
		fillBox(c, bx, PAPER)
		c.saveGState(); c.addPath(rrectPath(bx.rect, bx.r)); c.clip()
		riseRich(c, [("$ ", FIELD), (CMD_S, INK)], CMD_F, 960, midBase(CMD_F, bx.cy), t, T_CMD + 0.04, 1e9, .center, fast: true)
		c.restoreGState()
	}
}
func paintMaskRamp(_ c: CGContext, _ m: CGImage, _ r: CGRect, _ color: UInt32, _ alphaAt: (CGFloat) -> CGFloat) {
	let n = max(2, Int(r.width * SC))
	var px = [UInt8](repeating: 0, count: n)
	var any = false
	for j in 0..<n {
		let a = max(0, min(1, alphaAt(r.minX + (CGFloat(j) + 0.5) / SC)))
		px[j] = UInt8((a * 255).rounded()); if px[j] > 0 { any = true }
	}
	if !any { return }
	let ramp = px.withUnsafeMutableBytes { buf -> CGImage in
		let g = CGContext(data: buf.baseAddress, width: n, height: 1, bitsPerComponent: 8, bytesPerRow: n, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		return g.makeImage()!
	}
	c.saveGState()
	c.translateBy(x: 0, y: r.maxY + r.minY); c.scaleBy(x: 1, y: -1)
	c.clip(to: r, mask: m)
	c.clip(to: r, mask: ramp)
	c.setFillColor(col(color)); c.fill(r)
	c.restoreGState()
}

// ---------------------------------------------------------------- the band: captions on the left, the section on the right
let CAP_F = sans(68, 500), SEC_F = mono(54, 400)
let LEFT_X: CGFloat = 120
// (statement, second line, in, second in, out, section)
let CAPS: [(String, String, Double, Double, Double, String)] = [
	("you can run it with docker now", "we heard you", b(8.3), b(8.9), b(15.3), "01"),
	("api v5 support", "the v5 sdks run on local", b(16.3), b(16.9), b(23.3), "02"),
	("better security", "localhost now needs your api key", b(24.3), b(24.9), b(31.3), "03"),
	("about 40% faster", "", b(32.3), b(32.3), b(38.6), "04"),
	("next version of local", "10x less resource intensive", b(39.6), b(40.2), b(46.7), "05"),
]
func drawHUD(_ c: CGContext, _ t: Double) {
	// the band's hairline draws in on the drop and leaves before the lockup
	let inK = ease(seg(t, T_ENTER, T_ENTER + 0.5)), outA = CGFloat(1 - smooth(seg(t, b(46.7), b(47.5))))
	if inK > 0 {
		c.setStrokeColor(col(PAPER, 0.32 * outA)); c.setLineWidth(1)
		c.move(to: CGPoint(x: 0, y: BAND_Y)); c.addLine(to: CGPoint(x: DW * CGFloat(inK), y: BAND_Y)); c.strokePath()
	}
	for cap in CAPS {
		riseText(c, cap.0, CAP_F, LEFT_X, BAND_Y + 82, PAPER, t, cap.2, cap.4)
		riseText(c, cap.1, CAP_F, LEFT_X, BAND_Y + 164, PAPER, t, cap.3, cap.4 + 0.04, alpha: 0.62)
		riseText(c, cap.5, SEC_F, DW - LEFT_X, BAND_Y + 164, PAPER, t, cap.2 + 0.05, cap.4, .right)
	}
}
