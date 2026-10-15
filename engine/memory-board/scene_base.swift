// ================================================================ the frame: the brand book's memory field (same system as learner-1 v9)
// blue 600 field, Bayer-dithered light, a screen-fixed dot lattice (stored = square, recalled = 45° diamond), a hairline
// grid with + marks, Geist type in a caption band, tokens as short sharp bars. Here the subject is a board of memories,
// and the film is about which ones supermemory lets go of.

let PITCH = 7.0
let LCOLS = Int((Double(DW) / PITCH).rounded(.up)), LROWS = Int((Double(DH) / PITCH).rounded(.up))
let BAND_Y: CGFloat = 868                                   // the caption band starts here
let BAYER: [Float] = {
	let m: [Int] = [0, 32, 8, 40, 2, 34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44, 4, 36, 14, 46, 6, 38, 60, 28, 52, 20, 62, 30, 54, 22,
	                3, 35, 11, 43, 1, 33, 9, 41, 51, 19, 59, 27, 49, 17, 57, 25, 15, 47, 7, 39, 13, 45, 5, 37, 63, 31, 55, 23, 61, 29, 53, 21]
	return m.map { (Float($0) + 0.5) / 64 }
}()
let CELL_RND: [Double] = (0..<(LCOLS * LROWS)).map { hash01($0 &* 7919, 104729) }
let MARK_C = CGPoint(x: 960, y: 470), MARK_H_DOTS: CGFloat = 330
let MARK_PIX: (w: Int, h: Int, px: [UInt8]) = {
	let w = MARK.width, h = MARK.height
	var px = [UInt8](repeating: 0, count: w * h)
	px.withUnsafeMutableBytes { raw in
		let g = CGContext(data: raw.baseAddress, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		g.draw(MARK, in: CGRect(x: 0, y: 0, width: w, height: h))
	}
	return (w, h, px)
}()
func markAt(_ sx: Double, _ sy: Double, _ r: CGRect) -> Double {
	let u = (sx - Double(r.minX)) / Double(r.width), v = (sy - Double(r.minY)) / Double(r.height)
	if u < 0 || v < 0 || u >= 1 || v >= 1 { return 0 }
	return Double(MARK_PIX.px[Int(v * Double(MARK_PIX.h)) * MARK_PIX.w + Int(u * Double(MARK_PIX.w))]) / 255
}
func markDots(_ t: Double) -> Double { smooth(seg(t, T_END0 + b(0.8), T_MARK + b(0.5))) }

// ---------------------------------------------------------------- shockwaves and the lattice pass
struct Wave { let t: Double; let x: Double; let y: Double; let speed: Double; let amp: Double }
var WAVES: [Wave] = []
func setWaves() {
	var w: [Wave] = []
	let p = scr(977, 436, camAt(T_DROP + 0.1)); w.append(Wave(t: T_DROP, x: Double(p.x), y: Double(p.y), speed: 2200, amp: 1))
	let anchors: [(Double, Double)] = [(545, 228), (975, 228), (977, 436), (977, 300)]
	for (i, o) in OPS_T.enumerated() { let q = scr(anchors[i].0, anchors[i].1, camAt(o + 0.2)); w.append(Wave(t: o + 0.04, x: Double(q.x), y: Double(q.y), speed: 1500, amp: 0.7)) }
	let qa = scr(815, 644, camAt(T_APPLY + 0.2)); w.append(Wave(t: T_APPLY + 0.04, x: Double(qa.x), y: Double(qa.y), speed: 1400, amp: 0.6))
	let qr = scr(975, 228, camAt(T_ASK2 + 1.0)); w.append(Wave(t: T_ASK2 + 1.0, x: Double(qr.x), y: Double(qr.y), speed: 1100, amp: 0.45))
	w.append(Wave(t: WORD_T - b(1.15), x: Double(MARK_C.x), y: Double(MARK_C.y), speed: 2000, amp: 0.8))
	WAVES = w
}
/// the lattice breathes with the kit's kick while the drums play
func latticePulse(_ t: Double) -> Double {
	if t < b(8) || t > b(48) { return 0 }
	let u = (t - b(8)).truncatingRemainder(dividingBy: 2 * BEAT)
	return 0.4 * (1 - exp(-u / 0.02)) * exp(-u / 0.12)
}
func paintField(_ out: UnsafeMutablePointer<UInt8>, _ t: Double, _ cam: Cam) {
	if WAVES.isEmpty { setWaves() }
	let base = 0.032 * (1 + latticePulse(t))
	let sc = Double(SC)
	let fieldC = rgb(FIELD), b500 = rgb(BLUE500), paperC = rgb(PAPER)
	let latC: (Float, Float, Float) = (fieldC.0 + (148 - fieldC.0) * 0.32, fieldC.1 + (182 - fieldC.1) * 0.32, fieldC.2 + (255 - fieldC.2) * 0.32)
	var tone = [Float](repeating: 0, count: LCOLS * LROWS), rot = [Float](repeating: 0, count: LCOLS * LROWS), kind = [UInt8](repeating: 0, count: LCOLS * LROWS)
	let markR = markRect(center: MARK_C, height: MARK_H_DOTS)
	let md = markDots(t), mdOut = smooth(seg(t, WORD_T - 0.05, WORD_T + 0.5))
	tone.withUnsafeMutableBufferPointer { T in rot.withUnsafeMutableBufferPointer { Rr in kind.withUnsafeMutableBufferPointer { K in
		DispatchQueue.concurrentPerform(iterations: LROWS) { r in
			let sy = (Double(r) + 0.5) * PITCH
			for c in 0..<LCOLS {
				let i = r * LCOLS + c
				let sx = (Double(c) + 0.5) * PITCH
				let rnd = CELL_RND[i]
				var tv = base, rv = 0.0, kv: UInt8 = 0
				// the drop: an ordered-dither band sweeps across the lattice (the brand's own Bayer texture as the transition)
				if t > T_DROP && t < T_DROP + 0.7 {
					let p = (t - T_DROP) / 0.55 - sx / Double(DW) * 0.45
					let band = max(0, 1 - abs(p - 0.5) / 0.32)
					if band > 0 && Double(BAYER[(r & 7) * 8 + (c & 7)]) < band {
						let tt = tv + 0.42 * band
						if tt > tv { tv = min(1, tt); rv = max(rv, band) }
					}
				}
				for w in WAVES where t > w.t && t < w.t + 0.75 {
					let rad = (t - w.t) * w.speed
					let dd = abs(hypot(sx - w.x, sy - w.y) - rad)
					if dd < 60 {
						let a = (1 - (t - w.t) / 0.75) * exp(-dd * dd / 900) * w.amp * min(1, (t - w.t) / 0.05)
						let tt = tv + a * 0.55
						if tt > tv { tv = min(1, tt); rv = max(rv, min(1, a * 1.4)) }
					}
				}
				if md > 0.001 && mdOut < 0.999 {
					let m = markAt(sx, sy, markR)
					if m > 0.4 {
						let a = smooth((md * 1.35 - 0.35 * rnd) / 0.5) * (1 - smooth((mdOut * 1.35 - 0.35 * rnd) / 0.5))
						let tt = base + (0.9 - base) * a
						if tt > tv { tv = tt; rv = a; kv = 1 }
					}
				}
				T[i] = Float(tv); Rr[i] = Float(rv); K[i] = kv
			}
		}
	} } }

	// the light in the field: soft, dithered toward blue 500 (two broad pools, drifting slowly)
	let gx0 = 1500.0 - 60 * sin(t * 0.25), gy0 = 180.0, gx1 = 380.0, gy1 = 760.0 + 40 * cos(t * 0.2)
	tone.withUnsafeBufferPointer { T in rot.withUnsafeBufferPointer { Rr in kind.withUnsafeBufferPointer { K in
		DispatchQueue.concurrentPerform(iterations: PH) { Y in
			let y = (Double(Y) + 0.5) / sc
			let r = min(LROWS - 1, Int(y / PITCH))
			let cy = (Double(r) + 0.5) * PITCH
			let row = out + Y * PW * 4
			let by = (Int(y / 2) & 7) * 8
			for X in 0..<PW {
				let x = (Double(X) + 0.5) / sc
				// field + dithered light
				let g = 0.36 * exp(-(((x - gx0) * (x - gx0)) / (700 * 700) + ((y - gy0) * (y - gy0)) / (420 * 420)))
				      + 0.22 * exp(-(((x - gx1) * (x - gx1)) / (620 * 620) + ((y - gy1) * (y - gy1)) / (380 * 380)))
				let on = Float(g) > BAYER[by + (Int(x / 2) & 7)]
				var col = on ? b500 : fieldC
				// the dot in this lattice cell
				let c = min(LCOLS - 1, Int(x / PITCH))
				let cx = (Double(c) + 0.5) * PITCH
				let i = r * LCOLS + c
				let tv = Double(T[i])
				let th = Double(Rr[i]) * Double.pi / 4
				let dx = x - cx, dy = y - cy
				let u = dx * cos(th) + dy * sin(th), v = -dx * sin(th) + dy * cos(th)
				let hh = 0.5 * PITCH * tv.squareRoot() * (0.92 - 0.2 * Double(Rr[i]))
				let k = Float(max(0, min(1, (hh - max(abs(u), abs(v))) * sc + 0.5)))
				if k > 0 {
					let dc = K[i] == 1 ? paperC : latC
					col = (col.0 + (dc.0 - col.0) * k, col.1 + (dc.1 - col.1) * k, col.2 + (dc.2 - col.2) * k)
				}
				let o = row + X * 4
				o[2] = UInt8(max(0, min(255, col.0))); o[1] = UInt8(max(0, min(255, col.1))); o[0] = UInt8(max(0, min(255, col.2))); o[3] = 255
			}
		}
	} } }
}

// ---------------------------------------------------------------- dots for memories (world-anchored)
/// draw a memory's pixel art as dots: `rot` 0 squares (stored) to 1 diamonds (recalled); `grow` 0..1 scales each dot
func dotArt(_ c: CGContext, _ a: PixArt, frame: Int, centre: CGPoint, cell: CGFloat, rot: Double, grow: (Cell) -> Double, alpha: CGFloat = 1) {
	if alpha <= 0.003 { return }
	let cells = a.frames[min(frame, a.frames.count - 1)]
	let ox = centre.x - CGFloat(a.w) * cell / 2, oy = centre.y - CGFloat(a.h) * cell / 2
	let th = CGFloat(rot * Double.pi / 4)
	for cl in cells {
		let g = grow(cl)
		if g <= 0.01 { continue }
		let s = cell * CGFloat(0.84 - 0.08 * rot) * CGFloat(g)
		let p = CGPoint(x: ox + (CGFloat(cl.x) + 0.5) * cell, y: oy + (CGFloat(cl.y) + 0.5) * cell)
		c.saveGState()
		c.translateBy(x: p.x, y: p.y); c.rotate(by: th)
		c.setFillColor(col(PAL[cl.ch] ?? PAPER, alpha))
		c.fill(CGRect(x: -s / 2, y: -s / 2, width: s, height: s))
		c.restoreGState()
	}
}
@inline(__always) func bez(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint, _ d: CGPoint, _ u: Double) -> CGPoint {
	let v = 1 - u
	return CGPoint(x: CGFloat(v * v * v) * a.x + CGFloat(3 * v * v * u) * b.x + CGFloat(3 * v * u * u) * c.x + CGFloat(u * u * u) * d.x,
	               y: CGFloat(v * v * v) * a.y + CGFloat(3 * v * v * u) * b.y + CGFloat(3 * v * u * u) * c.y + CGFloat(u * u * u) * d.y)
}
func strokeBez(_ c: CGContext, _ p: (CGPoint, CGPoint, CGPoint, CGPoint), _ u0: Double, _ u1: Double) {
	if u1 - u0 <= 0.001 { return }
	c.beginPath()
	for i in 0...40 {
		let q = bez(p.0, p.1, p.2, p.3, u0 + (u1 - u0) * Double(i) / 40)
		if i == 0 { c.move(to: q) } else { c.addLine(to: q) }
	}
	c.strokePath()
}
func diamond(_ c: CGContext, _ p: CGPoint, _ s: CGFloat, _ color: UInt32, _ a: CGFloat, rot: Double = 1) {
	if a <= 0.003 || s <= 0.2 { return }
	c.saveGState(); c.translateBy(x: p.x, y: p.y); c.rotate(by: CGFloat(rot * Double.pi / 4))
	c.setFillColor(col(color, a)); c.fill(CGRect(x: -s / 2, y: -s / 2, width: s, height: s)); c.restoreGState()
}

// ---------------------------------------------------------------- type
let STATE_F = sans(66, 500), LABEL_F = mono(22, 500), NUM_F = mono(54, 400), OP_F = sans(124, 500), TAG_F = mono(32, 500)
let LEFT_X: CGFloat = 120
func riseText(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ color: UInt32, _ t: Double, _ t0: Double, _ t1: Double, _ al: Align = .left) {
	if t < t0 || t > t1 + 0.5 || s.isEmpty { return }
	let size = CTFontGetSize(f)
	let chars = Array(s)
	let w = textW(s, f)
	let x0: CGFloat = al == .left ? x : (al == .center ? x - w / 2 : x - w)
	c.saveGState()
	c.clip(to: CGRect(x: 0, y: y - size * 1.05, width: DW, height: size * 1.38))
	for (j, ch) in chars.enumerated() where ch != " " {
		let xj = x0 + textW(String(chars[0..<j]), f)
		let u = eout(seg(t, t0 + 0.012 * Double(j), t0 + 0.012 * Double(j) + 0.42))
		let v = ease(seg(t, t1 + 0.006 * Double(j), t1 + 0.006 * Double(j) + 0.26))
		let dy = (1 - CGFloat(u)) * size * 0.95 - CGFloat(v) * size * 0.95
		text(c, String(ch), f, xj, y + dy, color, CGFloat(min(1, u * 1.5)) * CGFloat(1 - v))
	}
	c.restoreGState()
}

func drawGrid(_ c: CGContext, _ t: Double) {
	// the brand book's covers: a hairline grid, + marks at the crossings
	let a = CGFloat(1 - 0.6 * smooth(seg(t, T_END0, T_END0 + b(2))))
	c.setStrokeColor(col(PAPER, 0.07 * a)); c.setLineWidth(1)
	var x: CGFloat = 0
	while x <= DW { c.move(to: CGPoint(x: x, y: 0)); c.addLine(to: CGPoint(x: x, y: BAND_Y)); x += 160 }
	var y: CGFloat = 28
	while y < BAND_Y { c.move(to: CGPoint(x: 0, y: y)); c.addLine(to: CGPoint(x: DW, y: y)); y += 160 }
	c.strokePath()
	c.setStrokeColor(col(PAPER, 0.42 * a)); c.setLineWidth(1.2)
	x = 0
	while x <= DW {
		y = 28
		while y < BAND_Y { c.move(to: CGPoint(x: x - 5, y: y)); c.addLine(to: CGPoint(x: x + 5, y: y)); c.move(to: CGPoint(x: x, y: y - 5)); c.addLine(to: CGPoint(x: x, y: y + 5)); y += 160 }
		x += 160
	}
	c.strokePath()
}

/// one token: a short sharp bar laid along its path (lengths vary like words)
func tokenBar(_ c: CGContext, _ p: CGPoint, _ dir: CGPoint, _ len: CGFloat, _ h: CGFloat, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.saveGState(); c.translateBy(x: p.x, y: p.y); c.rotate(by: atan2(dir.y, dir.x))
	c.setFillColor(col(color, a)); c.fill(CGRect(x: -len / 2, y: -h / 2, width: len, height: h))
	c.restoreGState()
}
/// a stream of n tokens along a bezier: token i leaves at t0 + i * gap and takes `dur` to arrive
func tokenStream(_ c: CGContext, _ t: Double, _ p: (CGPoint, CGPoint, CGPoint, CGPoint), t0: Double, n: Int, gap: Double, dur: Double, k: CGFloat, seed: Int, alpha: CGFloat = 1, lead: Bool = true, size: CGFloat = 1, fadeOut: Double = 0.12) {
	if n <= 0 || t < t0 || t > t0 + Double(n) * gap + dur { return }
	for i in 0..<n {
		let u = (t - (t0 + Double(i) * gap)) / dur
		if u <= 0 || u >= 1 { continue }
		let e = ease(u)
		let q = bez(p.0, p.1, p.2, p.3, e), q2 = bez(p.0, p.1, p.2, p.3, min(1, e + 0.01))
		let h = hash01(seed &* 131 &+ i, 7)
		let a = alpha * CGFloat(min(1, u / 0.08) * min(1, (1 - u) / fadeOut) * (0.55 + 0.45 * hash01(i, seed &+ 3)))
		tokenBar(c, q, CGPoint(x: q2.x - q.x, y: q2.y - q.y), CGFloat(5 + 11 * h) * k * size, 3.2 * k * size, (lead && i == 0) ? GOLD : PAPER, a)
	}
}

let END_LOCK_H: CGFloat = 80
let LOCK_W = END_LOCK_H * CGFloat((G_MW + G_GAP + G_WW) / G_MH)
let LOCK_X = DW / 2 - LOCK_W / 2, LOCK_Y: CGFloat = 470
let LOCK_MARK_C = CGPoint(x: LOCK_X + END_LOCK_H * CGFloat(G_MW / G_MH) / 2, y: LOCK_Y)
let WORD_R = CGRect(x: LOCK_X + END_LOCK_H * CGFloat((G_MW + G_GAP) / G_MH), y: LOCK_Y - END_LOCK_H / 2 + END_LOCK_H * CGFloat(G_WOFF / G_MH),
                    width: END_LOCK_H * CGFloat(G_WW / G_MH), height: END_LOCK_H * CGFloat(G_WH / G_MH))
func solidMarkK(_ t: Double) -> Double { smooth(seg(t, WORD_T - b(1.3), WORD_T - b(1.0))) }
func drawEnd(_ c: CGContext, _ t: Double) {
	let solid = solidMarkK(t)
	if solid <= 0 { return }
	let k = ease(seg(t, WORD_T, WORD_T + 0.75))
	let mc = lerpP(MARK_C, LOCK_MARK_C, k)
	let h = lerpC(MARK_H_DOTS, END_LOCK_H, k)
	paintMask(c, MARK, markRect(center: mc, height: h), PAPER, CGFloat(solid))
	if t >= WORD_T {
		let front = lerpC(WORD_R.minX, WORD_R.maxX + 200, ease(seg(t, WORD_T + 0.08, WORD_T + 0.9)))
		paintMaskRamp(c, WORD, WORD_R, PAPER) { x in
			let behind = CGFloat(smooth(Double((x - mc.x - h * CGFloat(G_MW / G_MH) * 0.5 - 8) / 30)))
			return behind * max(0, min(1, (front - x) / 200))
		}
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
