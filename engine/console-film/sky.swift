// ================================================================ background: supermemory dawn, computed (v5)
// Rebuilt in code from supermemory.ai's own art (supermemory.ai/brand/media/cta-dawn.jpg, colours sampled 2026-10-06):
// a blue dawn sky, a warm sun, and a dot-matrix sun on a regular grid. Nothing here is a photo. Every pixel is computed,
// so it stays sharp at 4K, and the sun rises through the film into the middle of the plugin ring. The dots follow the
// brand memory field: squares at rest, turned 45° when recalled. The sun's dotted edge is the brand halftone (8x8 Bayer,
// by threshold, never blurred).

struct RGBf { var r: Float; var g: Float; var b: Float }
func rgbf(_ v: UInt32) -> RGBf { RGBf(r: Float((v >> 16) & 255) / 255, g: Float((v >> 8) & 255) / 255, b: Float(v & 255) / 255) }
@inline(__always) func mixf(_ a: RGBf, _ b: RGBf, _ k: Float) -> RGBf {
	RGBf(r: a.r + (b.r - a.r) * k, g: a.g + (b.g - a.g) * k, b: a.b + (b.b - a.b) * k)
}

// cta-dawn.jpg: sky #587eb5 / #5c8ac0 / #729ac6, glow #cfcdd9 / #e4dbda / #e7dac8, sun #dfa454
let SKY_TOP = (rgbf(0x36578f), rgbf(0x4f76b0))      // (before dawn, dawn)
let SKY_MID = (rgbf(0x5070a6), rgbf(0x6a93c6))
let SKY_LOW = (rgbf(0x6a7398), rgbf(0x98b2d6))
let GLOW_HALO = rgbf(0xcfcdd9), GLOW_MID = rgbf(0xe7dac8), GLOW_CORE = rgbf(0xf1e7da), GLOW_AMBER = rgbf(0xdfa454)

/// The sun: low behind the console for the first 11s, then up into the ring as the card falls away.
func sunY(_ t: Double) -> Double {
	1130 - 210 * smooth(seg(t, 0, END)) - 392 * ease2(seg(t, END - 0.1, SPIN_A + 0.35))
}
func sunGain(_ t: Double) -> Double {
	0.62 + 0.38 * smooth(seg(t, 0, SPIN_A + 0.4)) + beatPulse(t, from: SPIN_A, to: COL_A - 0.01, depth: 0.05)
}
func dawnK(_ t: Double) -> Float { Float(smooth(seg(t, 0, SPIN_A + 0.4))) }

/// Parallax: the sky moves 6% as far as the world on screen and zooms by the 0.2 power of the camera, so camera moves
/// keep their depth. Zero at the end, where the sun sits exactly behind the ring.
func bgXform(_ t: Double) -> (off: CGPoint, zb: CGFloat) {
	let cam = camera(t), ce = camera(T_END)
	let k = 0.06 * CGFloat(cam.1)
	return (CGPoint(x: -(cam.0.x - ce.0.x) * k, y: -(cam.0.y - ce.0.y) * k), CGFloat(pow(cam.1 / ce.1, 0.2)))
}

@inline(__always) func skyAt(_ x: Float, _ y: Float, _ sx: Float, _ sy: Float, _ g: Float, _ d: Float) -> RGBf {
	let v = max(0, min(1, y / 1080))
	let top = mixf(SKY_TOP.0, SKY_TOP.1, d), mid = mixf(SKY_MID.0, SKY_MID.1, d), low = mixf(SKY_LOW.0, SKY_LOW.1, d)
	var c = v < 0.55 ? mixf(top, mid, v / 0.55) : mixf(mid, low, (v - 0.55) / 0.45)
	let dx = x - sx, dy = y - sy, dx2 = dx * dx
	c = mixf(c, GLOW_HALO, min(1, g * 0.8 * expf(-(dx2 / 1_210_000 + dy * dy / 409_600) * 1.6)))
	c = mixf(c, GLOW_MID, min(1, g * 0.85 * expf(-(dx2 / 313_600 + dy * dy / 115_600) * 1.8)))
	let ay = dy - 150
	c = mixf(c, GLOW_AMBER, min(1, g * 0.5 * expf(-dx2 / 184_900 - ay * ay / 12_100)))
	c = mixf(c, GLOW_CORE, min(1, g * expf(-(dx2 / 57_600 + dy * dy / 25_600) * 2.2)))
	return c
}

/// Triangular dither, 256x256, about 1.6 levels: kills 8-bit banding in the gradient and reads as a fine film grain.
let DITHER: UnsafeMutablePointer<Float> = {
	let p = UnsafeMutablePointer<Float>.allocate(capacity: 256 * 256)
	var s: UInt64 = 0x9E3779B97F4A7C15
	func r() -> Float { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return Float(s % 1_000_000) / 1_000_000 }
	for i in 0..<(256 * 256) { p[i] = (r() + r() - 1) * 1.6 }
	return p
}()

/// The sky at time t into a BGRA buffer (PW x PH): computed at quarter resolution, then bilinear up with dither.
func fillSky(_ out: UnsafeMutablePointer<UInt8>, _ t: Double) {
	let LW = PW / 4, LH = PH / 4
	let lo = UnsafeMutablePointer<Float>.allocate(capacity: LW * LH * 3)
	defer { lo.deallocate() }
	let (off, zb) = bgXform(t)
	let ox = Float(off.x), oy = Float(off.y), z = Float(zb)
	let sx: Float = 960, sy = Float(sunY(t)), g = Float(sunGain(t)), d = dawnK(t)
	let step = Float(1920) / Float(LW)
	DispatchQueue.concurrentPerform(iterations: LH) { j in
		let py = (Float(j) + 0.5) * step
		let by = 540 + (py - oy - 540) / z
		let uy = (py - 540) / 540
		for i in 0..<LW {
			let px = (Float(i) + 0.5) * step
			let c = skyAt(960 + (px - ox - 960) / z, by, sx, sy, g, d)
			let ux = (px - 960) / 960
			let vig = 255 * (1 - 0.07 * (ux * ux * 0.7 + uy * uy * 0.5))
			let k = (j * LW + i) * 3
			lo[k] = c.r * vig; lo[k + 1] = c.g * vig; lo[k + 2] = c.b * vig
		}
	}
	let xs0 = UnsafeMutablePointer<Int>.allocate(capacity: PW), xs1 = UnsafeMutablePointer<Int>.allocate(capacity: PW)
	let wxs = UnsafeMutablePointer<Float>.allocate(capacity: PW)
	defer { xs0.deallocate(); xs1.deallocate(); wxs.deallocate() }
	for X in 0..<PW {
		let fx = max(0, (Float(X) + 0.5) / 4 - 0.5)
		let x0 = min(Int(fx), LW - 1)
		xs0[X] = x0 * 3; xs1[X] = min(x0 + 1, LW - 1) * 3; wxs[X] = min(1, fx - Float(x0))
	}
	DispatchQueue.concurrentPerform(iterations: PH) { Y in
		let fy = max(0, (Float(Y) + 0.5) / 4 - 0.5)
		let y0 = min(Int(fy), LH - 1), y1 = min(y0 + 1, LH - 1), wy = min(1, fy - Float(y0))
		let r0 = lo + y0 * LW * 3, r1 = lo + y1 * LW * 3
		let row = out + Y * PW * 4
		let dr = DITHER + (Y & 255) * 256
		for X in 0..<PW {
			let a = xs0[X], b = xs1[X], wx = wxs[X], n = dr[X & 255]
			let q = row + X * 4
			for ch in 0..<3 {
				let tp = r0[a + ch] + (r0[b + ch] - r0[a + ch]) * wx
				let bt = r1[a + ch] + (r1[b + ch] - r1[a + ch]) * wx
				q[2 - ch] = UInt8(max(0, min(255, (tp + (bt - tp) * wy + n).rounded())))
			}
			q[3] = 255
		}
	}
}

// ---- the dot field
let BAYER8: [Int] = [0, 32, 8, 40, 2, 34, 10, 42, 48, 16, 56, 24, 50, 18, 58, 26, 12, 44, 4, 36, 14, 46, 6, 38,
	60, 28, 52, 20, 62, 30, 54, 22, 3, 35, 11, 43, 1, 33, 9, 41, 51, 19, 59, 27, 49, 17, 57, 25,
	15, 47, 7, 39, 13, 45, 5, 37, 63, 31, 55, 23, 61, 29, 53, 21]
@inline(__always) func hash2(_ i: Int, _ j: Int, _ s: Int) -> Double {
	var h = UInt32(truncatingIfNeeded: i &* 374_761_393 &+ j &* 668_265_263 &+ s &* 1_442_695_041)
	h = (h ^ (h >> 13)) &* 1_274_126_177
	h ^= h >> 16
	return Double(h) / 4_294_967_296
}
let DOT_PITCH: CGFloat = 12, DOT_SIZE: CGFloat = 2.9
let RECALLS: [Double] = [ENTER, CLK[0], CLK[1], CLK[2], CLK[3], SPIN_A, HEAD_T]
/// 1 inside r, falling to 0 at `feather` outside it.
func softIn(_ p: CGPoint, _ r: CGRect, _ feather: CGFloat) -> Double {
	let dx = max(r.minX - p.x, 0, p.x - r.maxX), dy = max(r.minY - p.y, 0, p.y - r.maxY)
	return 1 - smooth(Double(hypot(dx, dy) / feather))
}
/// Keep the logo's clearspace and the headline free of dots.
func clearMask(_ p: CGPoint, _ t: Double) -> Double {
	var m = 1.0
	if t < END + 0.3 { m *= 1 - softIn(p, CGRect(x: 1800, y: 990, width: 80, height: 64), 12) }
	let ts = tileSize(t)
	if ts > 1 { m *= 1 - softIn(p, CGRect(x: RING_C.x - ts * 0.75, y: RING_C.y - ts * 0.75, width: ts * 1.5, height: ts * 1.5), 30) }
	let hk = ease(seg(t, HEAD_T, HEAD_T + 0.4))
	if hk > 0 { m *= 1 - 0.8 * hk * softIn(p, CGRect(x: 400, y: 340, width: 1120, height: 290), 40) }
	let lk = ease(seg(t, LOCK_T - 0.1, LOCK_T + 0.3))
	if lk > 0 { m *= 1 - lk * softIn(p, CGRect(x: 700, y: 640, width: 520, height: 230), 30) }
	return m
}
func drawDots(_ c: CGContext, _ t: Double) {
	let (off, zb) = bgXform(t)
	let S = CGPoint(x: 960, y: CGFloat(sunY(t))), g = sunGain(t)
	func toScreen(_ p: CGPoint) -> CGPoint { CGPoint(x: 960 + (p.x - 960) * zb + off.x, y: 540 + (p.y - 540) * zb + off.y) }
	let sunS = toScreen(S)
	let i0 = Int(((960 + (-off.x - 960) / zb) / DOT_PITCH).rounded(.down)) - 1
	let i1 = Int(((960 + (1920 - off.x - 960) / zb) / DOT_PITCH).rounded(.up)) + 1
	let j0 = Int(((540 + (-off.y - 540) / zb) / DOT_PITCH).rounded(.down)) - 1
	let j1 = Int(((540 + (1080 - off.y - 540) / zb) / DOT_PITCH).rounded(.up)) + 1
	let rx = 440 * (0.8 + 0.2 * g), ry = 270 * (0.8 + 0.2 * g)
	let twk = 1 - seg(t, T_STILL - 1.2, T_STILL)
	let waves = RECALLS.filter { t > $0 && t < $0 + 1.4 }
	let buckets = (0..<17).map { _ in CGMutablePath() }
	let hs0 = DOT_SIZE * zb / 2
	for j in j0...j1 {
		for i in i0...i1 {
			let bp = CGPoint(x: (CGFloat(i) + 0.5) * DOT_PITCH, y: (CGFloat(j) + 0.5) * DOT_PITCH)
			var a = 0.0
			// the sun's dots: every grid point in the middle, a Bayer-ordered edge (the brand halftone)
			let ex = Double(bp.x - S.x) / rx, ey = Double(bp.y - S.y) / ry
			let tone = max(0, min(1, (1 - sqrt(ex * ex + ey * ey)) * 1.6)) * min(1, g)
			if tone > 0 {
				let b = (Double(BAYER8[(j & 7) * 8 + (i & 7)]) + 0.5) / 64
				a = 0.92 * smooth((tone - b) / 0.08 + 0.5)
			}
			// a sparse field of memories across the sky, written one by one through the film
			if hash2(i, j, 1) < 0.022 {
				let ta = 0.4 + hash2(i, j, 2) * 11.5
				a = max(a, 0.42 * ease(seg(t, ta, ta + 0.5)))
			}
			// recall: a ring runs out from the sun on each hit; the dots it crosses turn 45° and light up
			let p = toScreen(bp)
			var w = 0.0
			if !waves.isEmpty {
				let dist = Double(hypot(p.x - sunS.x, p.y - sunS.y))
				for r0 in waves {
					let x = (dist - (t - r0) * 1250) / 46
					w = max(w, exp(-x * x) * (1 - (t - r0) / 1.4))
				}
				a = max(a, 0.42 * w)
			}
			if a < 0.01 { continue }
			a *= 1 - 0.2 * twk * (0.5 + 0.5 * sin(2 * Double.pi * (0.6 * t + hash2(i, j, 3))))
			a *= clearMask(p, t)
			if a < 0.01 { continue }
			let hs = hs0 * CGFloat(1 + 0.45 * w)
			let ang = Double.pi / 4 * min(1, w * 1.6)
			let ca = CGFloat(cos(ang)) * hs, sa = CGFloat(sin(ang)) * hs
			let path = buckets[min(16, Int((a * 16).rounded()))]
			path.move(to: CGPoint(x: p.x - ca + sa, y: p.y - sa - ca))
			path.addLine(to: CGPoint(x: p.x + ca + sa, y: p.y + sa - ca))
			path.addLine(to: CGPoint(x: p.x + ca - sa, y: p.y + sa + ca))
			path.addLine(to: CGPoint(x: p.x - ca - sa, y: p.y - sa + ca))
			path.closeSubpath()
		}
	}
	for (k, path) in buckets.enumerated() where k > 0 && !path.isEmpty {
		c.addPath(path); c.setFillColor(col(WHITE, CGFloat(k) / 16)); c.fillPath()
	}
}

/// The whole background for one frame (the dots don't need motion blur: they barely move within a frame).
func paintBackground(_ buf: UnsafeMutablePointer<UInt8>, _ t: Double) {
	fillSky(buf, t)
	drawDots(makeContext(buf), t)
}
