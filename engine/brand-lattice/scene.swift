// ================================================================ the frame (the Supermemory brand book, imagery and texture)
// "Every texture is a memory field: a quiet lattice of stored dots, and a subject recalled out of it."
// - the ground is blue 600, the field, with its light dithered (an 8x8 Bayer matrix, never blurred) toward blue 500;
// - a hairline grid with + marks, as on the brand book's section covers;
// - a screen-fixed lattice of stored dots: squares at rest; subjects are recalled out of it as dots rotated 45°;
// - memories are dots too: squares when stored (learner-1's), diamonds when recalled (in the agent's context).

let PITCH = 7.0
let LCOLS = Int((Double(DW) / PITCH).rounded(.up)), LROWS = Int((Double(DH) / PITCH).rounded(.up))
let BAND_Y: CGFloat = 868                                   // the caption band starts here
let BAYER: [Float] = {
	let m: [Int] = [0, 32, 8, 40, 2, 34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44, 4, 36, 14, 46, 6, 38, 60, 28, 52, 20, 62, 30, 54, 22,
	                3, 35, 11, 43, 1, 33, 9, 41, 51, 19, 59, 27, 49, 17, 57, 25, 15, 47, 7, 39, 13, 45, 5, 37, 63, 31, 55, 23, 61, 29, 53, 21]
	return m.map { (Float($0) + 0.5) / 64 }
}()
let CELL_RND: [Double] = (0..<(LCOLS * LROWS)).map { hash01($0 &* 7919, 104729) }

// ---------------------------------------------------------------- the skull, recalled out of the lattice
/// when each lattice cell turns from a stored square into a recalled diamond (a sweep down the skull, with jitter)
@inline(__always) func skullIn(_ sx: Double, _ sy: Double, _ rnd: Double) -> Double { b(-7.5) + b(5.6) * (sy / Double(DH)) * 0.9 + b(0.9) * rnd }
/// "weights freeze": a sweep down the skull turns its recalled diamonds back into stored squares, at rest (the weights)
@inline(__always) func freezeAt(_ sy: Double, _ rnd: Double) -> Double { FREEZE0 + (FREEZE1 - FREEZE0 - b(0.5)) * (sy / Double(BAND_Y)) + b(0.35) * rnd }
func freezeLine(_ t: Double) -> Double { lerp(-40, Double(BAND_Y) + 40, seg(t, FREEZE0, FREEZE1 - b(0.5) + b(0.35))) }
/// the skull leaves at the end the same way it came, from the outside toward the mark
@inline(__always) func skullOut(_ sx: Double, _ sy: Double, _ rnd: Double) -> Double {
	let d = hypot(sx - 960, sy - 470) / 900
	return T_END0 + b(1.6) * (1 - min(1, d)) + b(0.5) * rnd
}
func relight(_ t: Double) -> Double { smooth(seg(t, RECALL_AT[0], RECALL_AT[4] + 0.5)) * (1 - smooth(seg(t, T_END0, T_END0 + b(1)))) }
/// v11: the mind's light. It glows while training pours in, settles as the weights freeze, rises with each memory in the
/// chat, goes out at the reset, and comes back as the memories are recalled
func mindLight(_ t: Double) -> Double {
	let train = 0.75 * (1 - smooth(seg(t, FREEZE0 - b(0.4), FREEZE1)))
	var chat = 0.0
	for la in LEARN_AT { chat += 0.11 * smooth(seg(t, la, la + 0.3)) }
	chat *= 1 - smooth(seg(t, T_RESET, T_RESET + 0.45))
	let breathe = 1 + 0.07 * sin(2 * Double.pi * t / 2.4)
	return (0.1 + train + chat + 0.8 * relight(t)) * breathe * (1 - smooth(seg(t, T_END0, T_END0 + b(1.2))))
}
/// the reset: a scan band runs down the skull and context collapses behind it
func resetBand(_ t: Double) -> Double { lerp(-200, 1300, seg(t, T_RESET, T_RESET + 0.42)) }

// ---------------------------------------------------------------- the end mark, built of recalled diamonds (as in the brand book)
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

// ---------------------------------------------------------------- the lattice pass (pure maths; rows in parallel)
struct Wave { let t: Double; let x: Double; let y: Double; let speed: Double; let amp: Double }
var WAVES: [Wave] = []
func setWaves(_ t: Double, _ cam: Cam) {
	var w: [Wave] = []
	let l1 = scr(L1_W.x, L1_W.y, camAt(T_DROP + 0.15))
	w.append(Wave(t: T_DROP, x: Double(l1.x), y: Double(l1.y), speed: 2200, amp: 1))
	let anchors = [RING[1], MERGE_W, INFER_W, RING[4]]
	for (i, o) in OPS_T.enumerated() {
		let p = scr(anchors[i].0, anchors[i].1, camAt(o + 0.2))
		w.append(Wave(t: o + 0.04, x: Double(p.x), y: Double(p.y), speed: 1500, amp: 0.7))
	}
	for (j, tj) in RECALL_AT.enumerated() {
		let p = scr(RECALLED[j].2.0, RECALLED[j].2.1, camAt(tj + 0.6))
		w.append(Wave(t: tj + 0.62, x: Double(p.x), y: Double(p.y), speed: 1100, amp: 0.45))
	}
	w.append(Wave(t: WORD_T - b(1.15), x: Double(MARK_C.x), y: Double(MARK_C.y), speed: 2000, amp: 0.8))
	for (i, m) in MEMS.enumerated() {
		let p = scr(m.mind.0, m.mind.1, camAt(LEARN_AT[i] + 0.1))
		w.append(Wave(t: LEARN_AT[i] + 0.08, x: Double(p.x), y: Double(p.y), speed: 1000, amp: 0.42))
	}
	for bt in [b(22), b(23)] {
		let p = scr(L1_W.x, L1_W.y, camAt(bt + 0.1))
		w.append(Wave(t: bt, x: Double(p.x), y: Double(p.y), speed: 1300, amp: 0.45))
	}
	WAVES = w
	_ = t; _ = cam
}
/// the lattice breathes with the kit's kick: a soft swell on every kit beat (two film beats) while the drums play
func latticePulse(_ t: Double) -> Double {
	if t < b(8) || t > b(40) || (t > b(14.5) && t < b(16)) { return 0 }
	let u = (t - b(8)).truncatingRemainder(dividingBy: 2 * BEAT)
	return 0.4 * (1 - exp(-u / 0.02)) * exp(-u / 0.12)
}
func paintField(_ out: UnsafeMutablePointer<UInt8>, _ t: Double, _ cam: Cam) {
	if WAVES.isEmpty { setWaves(t, cam) }
	let base = 0.032 * (1 + latticePulse(t))
	let sc = Double(SC)
	let fieldC = rgb(FIELD), b500 = rgb(BLUE500), paperC = rgb(PAPER)
	let latC: (Float, Float, Float) = (fieldC.0 + (148 - fieldC.0) * 0.32, fieldC.1 + (182 - fieldC.1) * 0.32, fieldC.2 + (255 - fieldC.2) * 0.32)
	// per cell: tone, rotation (0 square, 1 diamond), colour (0 lattice; 1-255 sky to paper), warmth (toward gold)
	var tone = [Float](repeating: 0, count: LCOLS * LROWS), rot = [Float](repeating: 0, count: LCOLS * LROWS), kind = [UInt8](repeating: 0, count: LCOLS * LROWS)
	var warmth = [UInt8](repeating: 0, count: LCOLS * LROWS)
	let ml = mindLight(t)
	// where each memory sits in the brain right now: (centre, radii, strength); the brain clears around it so the memory
	// floats in a window of its own
	var pockets: [(Double, Double, Double, Double, Double)] = []
	for (i, m) in MEMS.enumerated() where t >= LEARN_AT[i] - 0.05 && t < T_DROP {
		let s = smooth(seg(t, LEARN_AT[i], LEARN_AT[i] + 0.3))
		pockets.append((m.mind.0, m.mind.1, Double(m.art.w) * MIND_CELL / 2 + 16, Double(m.art.h) * MIND_CELL / 2 + 16, s))
	}
	for (j, r) in RECALLED.enumerated() where t >= RECALL_AT[j] + RECALL_LAND - 0.15 {
		let s = smooth(seg(t, RECALL_AT[j] + RECALL_LAND - 0.15, RECALL_AT[j] + RECALL_LAND + 0.2))
		pockets.append((r.2.0, r.2.1, Double(r.0.w) * MIND_CELL / 2 + 16, Double(r.0.h) * MIND_CELL / 2 + 16, s))
	}
	let band = resetBand(t)
	let rl = relight(t)
	let markR = markRect(center: MARK_C, height: MARK_H_DOTS)
	let md = markDots(t), mdOut = smooth(seg(t, WORD_T - 0.05, WORD_T + 0.5))
	tone.withUnsafeMutableBufferPointer { T in rot.withUnsafeMutableBufferPointer { Rr in kind.withUnsafeMutableBufferPointer { K in warmth.withUnsafeMutableBufferPointer { Wm in
		DispatchQueue.concurrentPerform(iterations: LROWS) { r in
			let sy = (Double(r) + 0.5) * PITCH
			for c in 0..<LCOLS {
				let i = r * LCOLS + c
				let sx = (Double(c) + 0.5) * PITCH
				let rnd = CELL_RND[i]
				var tv = base, rv = 0.0, kv: UInt8 = 0, wv: UInt8 = 0
				if sy < Double(BAND_Y) {
					// the head: glass, with the brain as the lit part (mind.swift)
					let (wx, wy) = world(sx, sy, cam)
					if wx > 100 && wx < 920 && wy > 60 && wy < 1000 {
						let st = mindTone(wx, wy)
						if st > 0.004 {
							let tin = skullIn(sx, sy, rnd), tout = skullOut(sx, sy, rnd)
							let a = smooth((t - tin) / b(0.6)) * (1 - smooth((t - tout) / b(0.6)))
							if a > 0.001 {
								let fz = smooth((t - freezeAt(sy, rnd)) / b(0.45))
								let gl = mindSample(MIND.glow, wx, wy), wm = mindSample(MIND.warm, wx, wy)
								var v = st * (1 - 0.08 * fz) + 0.22 * gl * ml
								var pk = 0.0
								for p in pockets {
									let du = (wx - p.0) / p.2, dv = (wy - p.1) / p.3
									let d2 = du * du + dv * dv
									if d2 < 1.7 {
										var s = p.4 * (1 - smooth((d2 - 0.75) / 0.9))
										if t > T_RESET && t < T_DROP { s *= 1 - smooth((band - wy) / 30) }   // the reset closes the pocket too
										pk = max(pk, s)
									}
								}
								v *= 1 - 0.82 * pk
								// the freeze front glints as it passes
								if t > FREEZE0 && t < FREEZE1 + b(0.5) { v += 0.3 * st * exp(-pow((sy - freezeLine(t)) / 26, 2)) }
								if t > T_RESET && t < T_RESET + 0.6 { v *= 1 - 0.45 * exp(-pow((wy - band) / 40, 2)) }
								let tt = min(1, v) * a + base * (1 - a)
								if tt > tv {
									tv = tt; rv = a * (1 - fz)
									kv = UInt8(1 + 254 * smooth((v - 0.12) / 0.48))
									wv = UInt8(255 * min(0.9, wm * ml * 1.6) * a * (1 - pk))
								}
							}
						}
					}
				}
				// shockwaves: rings of recalled dots running out from each hit
				for w in WAVES where t > w.t && t < w.t + 0.75 {
					let rad = (t - w.t) * w.speed
					let dd = abs(hypot(sx - w.x, sy - w.y) - rad)
					if dd < 60 {
						let a = (1 - (t - w.t) / 0.75) * exp(-dd * dd / 900) * w.amp * min(1, (t - w.t) / 0.05)   // a soft attack: no one-frame flash
						let tt = tv + a * 0.55
						if tt > tv { tv = min(1, tt); rv = max(rv, min(1, a * 1.4)) }
					}
				}
				// the mark, assembling out of the lattice at the end
				if md > 0.001 && mdOut < 0.999 {
					let m = markAt(sx, sy, markR)
					if m > 0.4 {
						let a = smooth((md * 1.35 - 0.35 * rnd) / 0.5) * (1 - smooth((mdOut * 1.35 - 0.35 * rnd) / 0.5))
						let tt = base + (0.9 - base) * a
						if tt > tv { tv = tt; rv = a; kv = 255; wv = 0 }
					}
				}
				T[i] = Float(tv); Rr[i] = Float(rv); K[i] = kv; Wm[i] = wv
			}
		}
	} } } }
	// the light in the field: soft, dithered toward blue 500 (two broad pools, drifting slowly)
	let gx0 = 1500.0 - 60 * sin(t * 0.25), gy0 = 180.0, gx1 = 380.0, gy1 = 760.0 + 40 * cos(t * 0.2)
	let bc = scr(480, 330, cam), br2 = pow(330 * cam.k, 2)                      // the brain's light, behind it in the field
	let skyC = rgb(SKY), goldC = rgb(GOLD), glowC = rgb(GLOW)
	tone.withUnsafeBufferPointer { T in rot.withUnsafeBufferPointer { Rr in kind.withUnsafeBufferPointer { K in warmth.withUnsafeBufferPointer { Wm in
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
				      + 0.34 * ml * exp(-((x - Double(bc.x)) * (x - Double(bc.x)) + (y - Double(bc.y)) * (y - Double(bc.y))) / br2)
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
					var dc = latC
					if K[i] > 0 {
						let pm = Float(K[i] - 1) / 254                                   // sky in the shadows, paper in the light
						dc = (skyC.0 + (paperC.0 - skyC.0) * pm, skyC.1 + (paperC.1 - skyC.1) * pm, skyC.2 + (paperC.2 - skyC.2) * pm)
						if Wm[i] > 0 {                                                   // the brain's warm light
							let w = Float(Wm[i]) / 255, wc = (glowC.0 + (goldC.0 - glowC.0) * 0.72, glowC.1 + (goldC.1 - glowC.1) * 0.72, glowC.2 + (goldC.2 - glowC.2) * 0.72)
							dc = (dc.0 + (wc.0 - dc.0) * w, dc.1 + (wc.1 - dc.1) * w, dc.2 + (wc.2 - dc.2) * w)
						}
					}
					col = (col.0 + (dc.0 - col.0) * k, col.1 + (dc.1 - col.1) * k, col.2 + (dc.2 - col.2) * k)
				}
				let o = row + X * 4
				o[2] = UInt8(max(0, min(255, col.0))); o[1] = UInt8(max(0, min(255, col.1))); o[0] = UInt8(max(0, min(255, col.2))); o[3] = 255
			}
		}
	} } } }
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

// ---------------------------------------------------------------- learner-1 and its cards
func learnerTile(_ c: CGContext, _ p: CGPoint, _ side: CGFloat, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setFillColor(col(PAPER, a)); c.fill(CGRect(x: p.x - side / 2, y: p.y - side / 2, width: side, height: side))
	paintMask(c, MARK, markRect(center: p, height: side * 0.5), FIELD, a)
}
struct CardState { let p: CGPoint; let s: CGFloat; let a: CGFloat; let depth: Double }
/// where card i (memory i) is during the dream: a fanned stack that shuffles on the beat (the front card flies round to
/// the back), then dealt out into a ring around learner-1
func cardState(_ i: Int, _ t: Double, _ cam: Cam) -> CardState? {
	if t < T_DROP - b(0.5) { return nil }
	let k = CGFloat(cam.k)
	let stackC = scr(L1_W.x + 300, L1_W.y + 10, cam)
	func pos(_ o: Double) -> (CGPoint, CGFloat) {
		(CGPoint(x: stackC.x - CGFloat(o) * 18 * k, y: stackC.y - CGFloat(o) * 15 * k), 172 * k * CGFloat(1 - 0.045 * o))
	}
	var o = Double(i)
	for s in 0..<4 { o -= ease(seg(t, b(17 + Double(s)), b(17 + Double(s)) + 0.24)) }
	var p: CGPoint, sz: CGFloat, depth: Double
	if o <= -1 { o += 6 }
	if o < 0 {
		let f = -o
		let (a0, s0) = pos(0), (a1, s1) = pos(5)
		p = CGPoint(x: a0.x + (a1.x - a0.x) * CGFloat(f) + CGFloat(sin(Double.pi * f)) * 190 * k, y: a0.y + (a1.y - a0.y) * CGFloat(f) - CGFloat(sin(Double.pi * f)) * 40 * k)
		sz = s0 + (s1 - s0) * CGFloat(f)
		depth = f < 0.5 ? -1 : 6
	} else {
		(p, sz) = pos(o); depth = o
	}
	// the deal: from the stack to the ring
	let d = ease(seg(t, b(20.4) + 0.07 * Double(i), b(21.6) + 0.07 * Double(i)))
	if d > 0 {
		let ring = RING[MEMS[i].ring]
		let rp = scr(ring.0, ring.1, cam)
		p = CGPoint(x: p.x + (rp.x - p.x) * CGFloat(d), y: p.y + (rp.y - p.y) * CGFloat(d))
		sz = sz + (164 * k - sz) * CGFloat(d)
		if d > 0.5 { depth = 0 }
	}
	let a = CGFloat(smooth(seg(t, T_DROP - b(0.4), T_DROP)))
	return CardState(p: p, s: sz, a: a, depth: depth)
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
let SECTIONS: [(String, Double, Double)] = [("01 · weights", -1, b(7.6)), ("02 · context window", b(8.2), b(15.7)), ("03 · learner-1", b(16.1), b(23.7)),
                                           ("04 · dreaming", b(24), b(31.7)), ("05 · recall", b(32.2), b(39.7))]
func drawType(_ c: CGContext, _ t: Double) {
	// the band: a hairline, statements on the left, the section number on the right (as on the brand book's covers)
	let bandA = CGFloat(1 - smooth(seg(t, T_END0, T_END0 + b(1))))
	c.setStrokeColor(col(PAPER, 0.32 * bandA)); c.setLineWidth(1)
	c.move(to: CGPoint(x: 0, y: BAND_Y)); c.addLine(to: CGPoint(x: DW, y: BAND_Y)); c.strokePath()
	for (i, cap) in CAP.enumerated() where i != 3 {
		riseText(c, cap.0, STATE_F, LEFT_X, BAND_Y + 80, PAPER, t, cap.2, cap.4)
		riseText(c, cap.1, STATE_F, LEFT_X, BAND_Y + 158, PAPER, t, cap.3, cap.4 + 0.04)
	}
	for (k, s) in SECTIONS.enumerated() {
		let parts = s.0.split(separator: " ", maxSplits: 2).map(String.init)
		riseText(c, s.0.uppercased(), LABEL_F, LEFT_X, 108, PAPER, t, s.1, s.2)
		riseText(c, parts[0], NUM_F, DW - LEFT_X, BAND_Y + 158, PAPER, t, s.1 + 0.05, s.2, .right)
		_ = k
	}
	// the four verbs, one per hit, big, in braces
	let ops = ["updates", "merges", "infers", "forgets"]
	for (i, w) in ops.enumerated() {
		let t0 = OPS_T[i], t1 = t0 + (i == 3 ? b(1.5) : b(1.75))
		riseText(c, "{ \(w) }", OP_F, LEFT_X - 8, BAND_Y + 150, PAPER, t, t0 + 0.02, t1)
	}
}

// ---------------------------------------------------------------- everything drawn as vectors over the lattice
let LINK_A: CGFloat = 0.5
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
func capturePath(_ i: Int, _ cam: Cam) -> (CGPoint, CGPoint, CGPoint, CGPoint) {
	let m = MEMS[i].mind
	let a = scr(m.0 + Double(MEMS[i].art.w) * MIND_CELL / 2 + 6, m.1, cam), d = scr(L1_W.x - 46, L1_W.y, cam)
	let k = CGFloat(cam.k)
	return (a, CGPoint(x: a.x + 260 * k, y: a.y), CGPoint(x: d.x - 300 * k, y: d.y + (a.y - d.y) * 0.4), d)
}
func recallPath(_ j: Int, _ from: CGPoint, _ cam: Cam) -> (CGPoint, CGPoint, CGPoint, CGPoint) {
	let to = scr(RECALLED[j].2.0, RECALLED[j].2.1, cam)
	let k = CGFloat(cam.k)
	return (from, CGPoint(x: from.x - 220 * k, y: from.y + 120 * k), CGPoint(x: to.x + 320 * k, y: to.y + 160 * k), to)
}
/// where the end gathers everything: toward the mark, which is built in the centre
func gatherTo(_ p: CGPoint, _ t: Double, _ d: Double) -> (CGPoint, CGFloat) {
	let g = einout(seg(t, T_END0 + d, T_END0 + b(1.4) + d))
	return (CGPoint(x: p.x + (MARK_C.x - p.x) * CGFloat(g), y: p.y + (MARK_C.y - p.y) * CGFloat(g)), CGFloat(1 - smooth(seg(t, T_END0 + b(0.8) + d, T_END0 + b(1.5) + d))))
}
// ---------------------------------------------------------------- tokens: the film's unit of context
// The site: learner-1 is "brought to the model by injecting tokens into its context in real time". So context moves as
// tokens everywhere: training pours them into the weights (until they freeze), the chat's memories leave as tokens,
// the reset drains them, and learner-1 injects them back.
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
/// the training run before the freeze: tokens pour into the skull from above, and the stream stops as training ends
func trainingStream(_ c: CGContext, _ t: Double, _ cam: Cam) {
	if t > FREEZE0 + 1.3 { return }
	let k = CGFloat(cam.k)
	for lane in 0..<9 {
		let lf = Double(lane)
		let pa = scr(1180 + 70 * lf, -260 - 30 * lf, cam), pb = scr(980 - 20 * lf, -60 + 10 * lf, cam)
		let ex = 320 + 40 * lf, ey = 380 - (78400 - (ex - 480) * (ex - 480)).squareRoot() + 6      // a point on the crown
		let pc = scr(ex + 160, ey - 170, cam), pd = scr(ex, ey, cam)
		let gap = 0.03 + 0.008 * hash01(lane, 41), t0 = -1.6 + 0.11 * hash01(lane, 17)
		let n = max(0, Int((FREEZE0 - 0.05 - t0) / gap))
		tokenStream(c, t, (pa, pb, pc, pd), t0: t0, n: n, gap: gap, dur: 0.9 + 0.2 * hash01(lane, 5), k: k, seed: 900 + lane, alpha: 0.9, lead: false, fadeOut: 0.22)
	}
}
/// the brain's synapses: gold diamonds (recalled dots) that twinkle, linked by hairlines with pulses running along them;
/// they shine as much as the mind is lit
func drawSynapses(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let ml = mindLight(t)
	if ml < 0.03 { return }
	let k = CGFloat(cam.k)
	let band = resetBand(t)
	func reset(_ y: Double) -> Double { t > T_RESET && t < T_RESET + 1.2 ? 1 - smooth((band - y) / 40) * smooth(seg(t, T_RESET, T_RESET + 0.5)) : 1 }
	for (i, s) in SYNAPSES.enumerated() {
		for j in s.links {
			let o = SYNAPSES[j]
			let p = scr(s.x, s.y, cam), q = scr(o.x, o.y, cam)
			let a = CGFloat(0.3 * ml * reset(min(s.y, o.y)))
			if a < 0.01 { continue }
			c.setStrokeColor(col(GOLD, a)); c.setLineWidth(1.1 * k)
			c.move(to: p); c.addLine(to: q); c.strokePath()
			// a pulse runs along the link now and then
			let ph = (t * 0.55 + hash01(i &* 17 &+ j, 3)).truncatingRemainder(dividingBy: 1)
			if ph < 0.35 {
				let u = ph / 0.35
				let pp = CGPoint(x: p.x + (q.x - p.x) * CGFloat(u), y: p.y + (q.y - p.y) * CGFloat(u))
				let z = 3.2 * k
				c.setFillColor(col(GLOW, a * 2.6 * CGFloat(sin(u * Double.pi)))); c.fill(CGRect(x: pp.x - z / 2, y: pp.y - z / 2, width: z, height: z))
			}
		}
	}
	for s in SYNAPSES {
		let tw = 0.55 + 0.45 * sin(2 * Double.pi * (t * 0.8 + s.phase))
		let a = CGFloat(min(1, ml * 1.15) * tw * reset(s.y))
		if a < 0.01 { continue }
		let p = scr(s.x, s.y, cam), z = CGFloat(5.5 + 3.5 * s.phase) * k
		c.saveGState(); c.translateBy(x: p.x, y: p.y); c.rotate(by: .pi / 4)
		c.setFillColor(col(s.phase > 0.5 ? GLOW : GOLD, a)); c.fill(CGRect(x: -z / 2, y: -z / 2, width: z, height: z))
		c.restoreGState()
	}
}
func drawWorld(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let k = CGFloat(cam.k)
	c.saveGState()
	c.clip(to: CGRect(x: 0, y: 0, width: DW, height: BAND_Y))
	c.setLineCap(.round)
	let band = resetBand(t)
	trainingStream(c, t, cam)
	drawSynapses(c, t, cam)
	// ---- the chat: memories form in the skull (recalled into context: diamonds), and each one's copy leaves along a branch
	for (i, m) in MEMS.enumerated() where t >= LEARN_AT[i] && t < T_DROP + b(1) {
		let centre = scr(m.mind.0, m.mind.1, cam)
		let t0 = LEARN_AT[i]
		let pop = 0.55 + 0.45 * spring(t, t0, freq: 3.0, zeta: 0.45)
		dotArt(c, m.art, frame: m.frame, centre: centre, cell: CGFloat(MIND_CELL * pop) * k, rot: 1, grow: { cl in
			let order = Double(cl.y * 3 + cl.x) / Double(m.art.w * 3 + m.art.h * 3)
			var g = eout(seg(t, t0 + 0.25 * order, t0 + 0.25 * order + 0.18))
			if t > T_RESET {
				let wy = m.mind.1 + (Double(cl.y) - Double(m.art.h) / 2) * MIND_CELL
				g *= 1 - smooth((band - wy) / 30)
			}
			return g
		})
		// the branch to learner-1, and the copy riding it (stored: squares)
		let p = capturePath(i, cam)
		let grow = ease(seg(t, t0 + 0.15, t0 + 0.55)), cut = ease(seg(t, T_RESET, T_RESET + 0.3))
		if grow - cut > 0.002 { c.setStrokeColor(col(PAPER, 0.45)); c.setLineWidth(1.3); strokeBez(c, p, cut, grow) }
		tokenStream(c, t, p, t0: t0 + 0.18, n: 14, gap: 0.03, dur: 0.75, k: k, seed: 100 + i, size: 1.2)     // its copy leaves as tokens
	}
	// the reset: the context window drains, each memory falling out of the skull as tokens
	if t > T_RESET && t < T_RESET + 1.4 {
		for (i, m) in MEMS.enumerated() {
			let tb = T_RESET + 0.42 * (m.mind.1 + 200) / 1500
			if t < tb { continue }
			let u = t - tb
			for q in 0..<16 {
				let h1 = hash01(i &* 37 &+ q, 11), h2 = hash01(i &* 53 &+ q, 29)
				let wx = m.mind.0 + (h1 - 0.5) * Double(m.art.w) * MIND_CELL, wy0 = m.mind.1 + (h2 - 0.5) * Double(m.art.h) * MIND_CELL
				let vx = (h2 - 0.5) * 90, vy = 30 + 90 * h1
				let sp = scr(wx + vx * u, wy0 + vy * u + 350 * u * u, cam)
				let a = CGFloat(max(0, 1 - u / 0.75)) * CGFloat(min(1, u / 0.04)) * 0.9
				tokenBar(c, sp, CGPoint(x: vx, y: vy + 700 * u), CGFloat(5 + 10 * h1) * k, 3.2 * k, PAPER, a)
			}
		}
	}
	// ---- learner-1, its links and its cards
	let l1 = scr(L1_W.x, L1_W.y, cam)
	let cards = MEMS.indices.compactMap { i -> (Int, CardState)? in cardState(i, t, cam).map { (i, $0) } }
	let opMerge = ease(seg(t, OPS_T[1], OPS_T[1] + 0.35)), opForget = seg(t, OPS_T[3], OPS_T[3] + 0.7)
	func cardPos(_ i: Int, _ cs: CardState) -> CGPoint {
		var p = cs.p
		if (i == 1 || i == 3) && opMerge > 0 { let mp = scr(MERGE_W.0, MERGE_W.1, cam); p = CGPoint(x: p.x + (mp.x - p.x) * CGFloat(opMerge), y: p.y + (mp.y - p.y) * CGFloat(opMerge)) }
		if i == 5 && opForget > 0 {
			// forgets: the expired memory steps aside, out of recall; it is not erased ("The history is not erased.")
			let dx = p.x - l1.x, dy = p.y - l1.y, d = max(1, hypot(dx, dy))
			let st = CGFloat(ease(seg(t, OPS_T[3] + 0.15, OPS_T[3] + 0.65))) * 52 * CGFloat(cam.k)
			p = CGPoint(x: p.x + dx / d * st, y: p.y + dy / d * st)
		}
		return gatherTo(p, t, 0.03 * Double(i)).0
	}
	let gatherA = gatherTo(.zero, t, 0).1
	if t > T_DROP - b(0.5) {
		let dealt = smooth(seg(t, b(21.4), b(22.2)))
		for (i, cs) in cards {
			var a = LINK_A * CGFloat(dealt) * gatherA
			if i == 3 { a *= CGFloat(1 - smooth(seg(t, OPS_T[1] + 0.3, OPS_T[1] + 0.5))) }
			let gone = i == 5 && t > OPS_T[3] + 0.2
			if i == 5 { a *= CGFloat(1 - 0.72 * smooth(seg(t, OPS_T[3] + 0.2, OPS_T[3] + 0.7))) }
			if a > 0.003 {
				c.saveGState(); if gone { c.setLineDash(phase: 0, lengths: [4, 6]) }
				c.setStrokeColor(col(PAPER, a)); c.setLineWidth(1.2); c.move(to: l1); c.addLine(to: cardPos(i, cs)); c.strokePath()
				c.restoreGState()
			}
		}
		// infers: learner-1 links the new card (the gold links from its two sources are drawn over the cards, below)
		let inf = smooth(seg(t, OPS_T[2], OPS_T[2] + 0.3))
		if inf > 0 {
			let ip = gatherTo(scr(INFER_W.0, INFER_W.1, cam), t, 0.1).0
			c.setStrokeColor(col(PAPER, LINK_A * CGFloat(inf) * gatherA)); c.move(to: l1); c.addLine(to: ip); c.strokePath()
		}
		// the cards, back to front
		for (i, cs) in cards.sorted(by: { $0.1.depth > $1.1.depth }) {
			let p = cardPos(i, cs)
			var a = cs.a * gatherA
			if i == 3 { a *= CGFloat(1 - smooth(seg(t, OPS_T[1] + 0.3, OPS_T[1] + 0.48))) }
			let fz = i == 5 ? smooth(seg(t, OPS_T[3] + 0.3, OPS_T[3] + 0.8)) : 0
			a *= CGFloat(1 - 0.58 * fz)
			if a <= 0.003 { continue }
			let w = cs.s, h = cs.s * 0.84
			let r = CGRect(x: p.x - w / 2, y: p.y - h / 2, width: w, height: h)
			let cell = CGFloat(CARD_CELL) * k * (cs.s / (164 * k))
			if i == 0 && t > OPS_T[0] {
				// updates: the old version stays behind as history, dimmed and dashed ("the old one stays as history")
				let e = ease(seg(t, OPS_T[0], OPS_T[0] + 0.4))
				let gp = CGPoint(x: p.x + 62 * k * CGFloat(e), y: p.y - 40 * k * CGFloat(e))
				let ga = a * CGFloat(0.45 * e)
				let gr = CGRect(x: gp.x - w / 2, y: gp.y - h / 2, width: w, height: h)
				c.setFillColor(col(FIELD, 0.92 * ga)); c.fill(gr)
				c.saveGState(); c.setLineDash(phase: 0, lengths: [5, 5]); c.setStrokeColor(col(PAPER, 0.8 * ga)); c.setLineWidth(1.2); c.stroke(gr); c.restoreGState()
				dotArt(c, ART_HOUSE, frame: 0, centre: gp, cell: cell, rot: 0, grow: { _ in 1 }, alpha: ga)
			}
			c.setFillColor(col(FIELD, 0.92 * a)); c.fill(r)
			c.saveGState(); if fz > 0.5 { c.setLineDash(phase: 0, lengths: [5, 5]) }
			c.setStrokeColor(col(PAPER, 0.62 * a)); c.setLineWidth(1.2); c.stroke(r)
			c.restoreGState()
			// recall: the icon turns 45° as its copy is sent back into context
			var rot = 0.0
			if let j = [0: 0, 1: 1, 2: 2, 4: 3][i] { let tj = RECALL_AT[j]; rot = smooth(seg(t, tj, tj + 0.18)) * (1 - smooth(seg(t, tj + 0.75, tj + 0.95))) }
			if i == 0 {
				// updates: the house turns into the new one, dot by dot
				let u0 = OPS_T[0] + 0.05
				dotArt(c, ART_HOUSE, frame: 0, centre: p, cell: cell, rot: rot, grow: { cl in 1 - smooth(seg(t, u0 + 0.02 * Double(cl.y), u0 + 0.02 * Double(cl.y) + 0.16)) }, alpha: a)
				dotArt(c, ART_HOUSE2, frame: 0, centre: p, cell: cell, rot: rot, grow: { cl in smooth(seg(t, u0 + 0.14 + 0.02 * Double(cl.y), u0 + 0.3 + 0.02 * Double(cl.y))) }, alpha: a)
			} else if i == 5 {
				// forgets: the rainy day dims and shrinks a little as it steps out of recall (kept as history, never erased)
				dotArt(c, MEMS[i].art, frame: 0, centre: p, cell: cell, rot: 0, grow: { _ in 1 - 0.25 * fz }, alpha: a)
			} else {
				dotArt(c, MEMS[i].art, frame: MEMS[i].frame, centre: p, cell: cell, rot: rot, grow: { _ in 1 }, alpha: a)
			}
		}
		// infers: a new card appears out of the two, dashed first, then whole
		if inf > 0 {
			let p = gatherTo(scr(INFER_W.0, INFER_W.1, cam), t, 0.1).0
			let s = 164 * k * CGFloat(0.7 + 0.3 * eout(seg(t, OPS_T[2], OPS_T[2] + 0.4)))
			let r = CGRect(x: p.x - s / 2, y: p.y - s * 0.42, width: s, height: s * 0.84)
			let solid = smooth(seg(t, OPS_T[2] + 0.45, OPS_T[2] + 0.7))
			c.setFillColor(col(FIELD, 0.92 * gatherA)); c.fill(r)
			c.saveGState(); if solid < 1 { c.setLineDash(phase: 0, lengths: [6, 5]) }
			c.setStrokeColor(col(solid < 1 ? GOLD : PAPER, 0.75 * gatherA)); c.setLineWidth(1.4); c.stroke(r); c.restoreGState()
			let cell = CGFloat(CARD_CELL) * k * (s / (164 * k))
			let rj = smooth(seg(t, RECALL_AT[4], RECALL_AT[4] + 0.18)) * (1 - smooth(seg(t, RECALL_AT[4] + 0.75, RECALL_AT[4] + 0.95)))
			dotArt(c, ART_BEACH, frame: 0, centre: p, cell: cell, rot: rj, grow: { cl in smooth(seg(t, OPS_T[2] + 0.1 + 0.015 * Double(cl.x), OPS_T[2] + 0.35 + 0.015 * Double(cl.x))) }, alpha: gatherA)
		}
		// infers: dashed gold links from the bike and the kite to the new card, between the cards, a spark down each
		if inf > 0 {
			let ip = gatherTo(scr(INFER_W.0, INFER_W.1, cam), t, 0.1).0
			let hw = 82 * k, hh = 69 * k
			func exitFrac(_ dx: CGFloat, _ dy: CGFloat) -> CGFloat { min(abs(dx) > 0.01 ? hw / abs(dx) : 1, abs(dy) > 0.01 ? hh / abs(dy) : 1) }
			var segs: [(CGPoint, CGPoint)] = []
			c.saveGState(); c.setLineDash(phase: 0, lengths: [6, 6]); c.setStrokeColor(col(GOLD, 0.9 * CGFloat(inf) * gatherA)); c.setLineWidth(2)
			for j in [0, 5] {
				let rp = gatherTo(scr(RING[j].0, RING[j].1, cam), t, 0.05).0
				let dx = ip.x - rp.x, dy = ip.y - rp.y
				let f0 = exitFrac(dx, dy), f1 = 1 - exitFrac(dx, dy)
				if f1 > f0 {
					let a = CGPoint(x: rp.x + dx * f0, y: rp.y + dy * f0), z = CGPoint(x: rp.x + dx * f1, y: rp.y + dy * f1)
					c.move(to: a); c.addLine(to: z); segs.append((a, z))
				}
			}
			c.strokePath(); c.restoreGState()
			let u = seg(t, OPS_T[2] + 0.02, OPS_T[2] + 0.32)
			if u > 0 && u < 1 {
				for (a, z) in segs { diamond(c, CGPoint(x: a.x + (z.x - a.x) * CGFloat(ease(u)), y: a.y + (z.y - a.y) * CGFloat(ease(u))), 11 * k, GOLD, 1) }
			}
		}
		// learner-1 itself, with a beat in its scale on each arrival
		if t < T_MARK {
			var pulse = 0.0
			for o in OPS_T where t > o { pulse += 0.08 * exp(-(t - o) / 0.14) }
			if t > T_DROP { pulse += 0.5 * exp(-(t - T_DROP) / 0.12) }
			let (gp, ga) = gatherTo(l1, t, 0)
			learnerTile(c, gp, 92 * k * CGFloat(1 + pulse), ga)
		}
		// tags: what each operation did
		for (i, tag) in ["v12 → v13", "2 → 1", "inferred", "expired"].enumerated() {
			let t0 = OPS_T[i] + 0.2, a = CGFloat(smooth(seg(t, t0, t0 + 0.15)) * (1 - smooth(seg(t, OPS_T[i] + b(1.7), OPS_T[i] + b(2)))))
			if a <= 0.003 { continue }
			let anchor = [scr(RING[1].0, RING[1].1, cam), scr(MERGE_W.0, MERGE_W.1, cam), scr(INFER_W.0, INFER_W.1, cam), scr(RING[4].0, RING[4].1, cam)][i]
			text(c, tag.uppercased(), TAG_F, anchor.x - 82 * k, anchor.y - 76 * k, i == 3 ? SKY : GOLD, a)
		}
	}
	// ---- recall: the current memories are injected back into the skull as token streams and land as recalled diamonds
	let sources: [Int: (Double, Double)] = [0: RING[1], 1: MERGE_W, 2: RING[0], 3: RING[5], 4: INFER_W]
	for j in RECALLED.indices {
		let tj = RECALL_AT[j]
		if t < tj { continue }
		let src = sources[j]!
		let from = scr(src.0, src.1, cam)
		let u = seg(t, tj + 0.15, tj + 0.65)
		let p = recallPath(j, from, cam)
		if u > 0 {
			let grow = ease(u), fade = smooth(seg(t, T_END0, T_END0 + b(1)))
			if grow - fade > 0.002 { c.setStrokeColor(col(PAPER, 0.45)); c.setLineWidth(1.3); strokeBez(c, p, fade, grow) }
		}
		tokenStream(c, t, p, t0: tj + 0.05, n: 30, gap: 0.02, dur: 0.85, k: k, seed: 300 + j, size: 1.8)     // injected as tokens into context
		if t > tj + 0.6 {
			let (gp, ga) = gatherTo(p.3, t, 0.05 * Double(j))
			let landed = RECALLED[j]
			dotArt(c, landed.0, frame: landed.1, centre: gp, cell: CGFloat(MIND_CELL) * k, rot: 1, grow: { cl in
				eout(seg(t, tj + 0.6 + 0.01 * Double(cl.x), tj + 0.8 + 0.01 * Double(cl.x)))
			}, alpha: ga)
		}
	}
	c.restoreGState()
}

// ---------------------------------------------------------------- the end: the dotted mark becomes the mark, then the lockup
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
