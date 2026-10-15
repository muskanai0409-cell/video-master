// ================================================================ the mind: a glass head with a glowing brain (v11, Oct 15)
// Shardul found the v9 skull a bit off-putting, and she pointed at a glowing glass head with a brain lit by its synapses
// (a Pinterest pin, used as direction only: nothing traced, nothing downloaded). Drawn here from proportions:
// - a serene profile facing learner-1, eyes closed (it dreams), as glass: a luminous rim and a faint, airy volume;
// - the cerebrum with its folds (the isolines of a warped noise field: ridges lit, sulci dark), the lateral and central
//   sulci, the cerebellum's fine folia, the brainstem and the spinal cord;
// - the brain is the lit part: its light (warm, toward gold) rises and falls with the story (mindLight in scene.swift).
// Units: the skull's 1000-unit box, y down, facing right, so the memories, the camera and the token streams still fit.
// Everything is computed once into fields, then sampled per lattice cell.

let MD_N = 1000
struct PT { let x: Double; let y: Double; let sharp: Bool }
func P(_ x: Double, _ y: Double, _ s: Bool = false) -> PT { PT(x: x, y: y, sharp: s) }
/// a smooth path through points (Catmull-Rom as cubic Béziers); a sharp point keeps its corner
func spline(_ pts: [PT], closed: Bool) -> CGPath {
	let p = CGMutablePath()
	let n = pts.count
	func at(_ i: Int) -> PT { closed ? pts[(i % n + n) % n] : pts[max(0, min(n - 1, i))] }
	p.move(to: CGPoint(x: pts[0].x, y: pts[0].y))
	for i in 0..<(closed ? n : n - 1) {
		let a = at(i - 1), b0 = at(i), c = at(i + 1), d = at(i + 2)
		let t1 = b0.sharp ? (0.0, 0.0) : ((c.x - a.x) / 6, (c.y - a.y) / 6)
		let t2 = c.sharp ? (0.0, 0.0) : ((d.x - b0.x) / 6, (d.y - b0.y) / 6)
		p.addCurve(to: CGPoint(x: c.x, y: c.y), control1: CGPoint(x: b0.x + t1.0, y: b0.y + t1.1), control2: CGPoint(x: c.x - t2.0, y: c.y - t2.1))
	}
	if closed { p.closeSubpath() }
	return p
}
func raster(_ draw: (CGContext) -> Void) -> [Float] {
	var buf = [UInt8](repeating: 0, count: MD_N * MD_N)
	buf.withUnsafeMutableBytes { raw in
		let g = CGContext(data: raw.baseAddress, width: MD_N, height: MD_N, bitsPerComponent: 8, bytesPerRow: MD_N,
		                  space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		g.translateBy(x: 0, y: CGFloat(MD_N)); g.scaleBy(x: 1, y: -1)
		g.setFillColor(gray: 1, alpha: 1); g.setStrokeColor(gray: 1, alpha: 1)
		draw(g)
	}
	return buf.map { Float($0) / 255 }
}
func fillMask(_ path: CGPath) -> [Float] { raster { $0.addPath(path); $0.fillPath() } }
func strokeMask(_ paths: [CGPath], _ w: CGFloat) -> [Float] {
	raster { g in g.setLineWidth(w); g.setLineCap(.round); g.setLineJoin(.round); for p in paths { g.addPath(p) }; g.strokePath() }
}
/// exact Euclidean distance (box units) to the nearest seed pixel (Felzenszwalb and Huttenlocher, two 1D passes)
func edt(_ seed: [Bool]) -> [Float] {
	let N = MD_N, INF = 1e12
	var g = seed.map { $0 ? 0.0 : INF }
	var f = [Double](repeating: 0, count: N), d = f, z = [Double](repeating: 0, count: N + 1)
	var v = [Int](repeating: 0, count: N)
	func dt1() {
		var k = 0; v[0] = 0; z[0] = -INF; z[1] = INF
		for q in 1..<N {
			var s = ((f[q] + Double(q * q)) - (f[v[k]] + Double(v[k] * v[k]))) / Double(2 * q - 2 * v[k])
			while s <= z[k] { k -= 1; s = ((f[q] + Double(q * q)) - (f[v[k]] + Double(v[k] * v[k]))) / Double(2 * q - 2 * v[k]) }
			k += 1; v[k] = q; z[k] = s; z[k + 1] = INF
		}
		k = 0
		for q in 0..<N { while z[k + 1] < Double(q) { k += 1 }; d[q] = Double((q - v[k]) * (q - v[k])) + f[v[k]] }
	}
	for x in 0..<N { for y in 0..<N { f[y] = g[y * N + x] }; dt1(); for y in 0..<N { g[y * N + x] = d[y] } }
	for y in 0..<N { for x in 0..<N { f[x] = g[y * N + x] }; dt1(); for x in 0..<N { g[y * N + x] = d[x] } }
	return g.map { Float($0.squareRoot()) }
}
/// distance inside a filled mask to its edge
func insideDist(_ m: [Float]) -> [Float] { edt(m.map { $0 < 0.5 }) }
/// distance to a stroked line
func lineDist(_ paths: [CGPath]) -> [Float] { edt(strokeMask(paths, 1.6).map { $0 > 0.35 }) }
@inline(__always) func ss(_ a: Double, _ b: Double, _ x: Double) -> Double { let k = max(0, min(1, (x - a) / (b - a))); return k * k * (3 - 2 * k) }
func hash01(_ a: Int, _ b: Int = 0) -> Double {
	var x = UInt64(bitPattern: Int64(a &* 73856093 ^ b &* 19349663)) &+ 0x9e3779b97f4a7c15
	x = (x ^ (x >> 30)) &* 0xbf58476d1ce4e5b9; x = (x ^ (x >> 27)) &* 0x94d049bb133111eb; x ^= x >> 31
	return Double(x >> 11) / Double(1 << 53)
}
/// gradient noise, for the folds
func gnoise(_ x: Double, _ y: Double) -> Double {
	let ix = Int(floor(x)), iy = Int(floor(y)), fx = x - floor(x), fy = y - floor(y)
	func grad(_ i: Int, _ j: Int, _ dx: Double, _ dy: Double) -> Double { let a = hash01(i &* 1619 &+ j &* 31337, 7) * 2 * Double.pi; return cos(a) * dx + sin(a) * dy }
	func fade(_ t: Double) -> Double { t * t * t * (t * (t * 6 - 15) + 10) }
	let u = fade(fx), w = fade(fy)
	let a = grad(ix, iy, fx, fy), b = grad(ix + 1, iy, fx - 1, fy), c = grad(ix, iy + 1, fx, fy - 1), d = grad(ix + 1, iy + 1, fx - 1, fy - 1)
	return (a + (b - a) * u) + ((c + (d - c) * u) - (a + (b - a) * u)) * w
}
func fbm(_ x: Double, _ y: Double) -> Double { gnoise(x, y) + 0.5 * gnoise(2.03 * x + 17, 2.03 * y + 9) + 0.25 * gnoise(4.1 * x + 3, 4.1 * y + 41) }

// ---------------------------------------------------------------- the drawing (box units, y down, facing right)
// the head and neck: a serene profile (forehead, a soft brow, the bridge, the nose, the lips, the chin, the throat)
let HEAD_PTS: [PT] = [
	P(470, 100), P(590, 114), P(690, 158), P(758, 226), P(794, 298), P(808, 358), P(812, 396), P(806, 424, true),
	P(820, 458), P(840, 498), P(862, 534), P(876, 552), P(870, 566), P(852, 573), P(838, 577, true),
	P(843, 592), P(851, 607), P(843, 619, true), P(846, 632), P(843, 648), P(834, 659),
	P(825, 670, true), P(831, 690), P(834, 712), P(824, 732), P(796, 748), P(752, 756),
	P(718, 768), P(708, 820), P(706, 900), P(712, 1040, true), P(372, 1040, true),
	P(352, 940), P(338, 850), P(318, 770), P(286, 698), P(240, 630), P(200, 552), P(174, 472), P(166, 392),
	P(178, 306), P(212, 226), P(268, 166), P(350, 120),
]
// the cerebrum
let BRAIN_PTS: [PT] = [
	P(470, 142), P(590, 152), P(688, 196), P(748, 266), P(772, 340), P(766, 400), P(738, 428), P(702, 442),
	P(688, 460), P(698, 484), P(684, 504), P(636, 514), P(560, 512), P(494, 500), P(452, 482), P(404, 470),
	P(340, 466), P(272, 452), P(226, 418), P(206, 348), P(214, 274), P(250, 208), P(312, 164), P(386, 144),
]
// the cerebellum, under the back of the brain
let CEREB_PTS: [PT] = [
	P(258, 466), P(330, 474), P(404, 480), P(448, 498), P(454, 534), P(426, 566), P(364, 580), P(300, 568), P(258, 538), P(244, 500),
]
let SYLVIAN: [PT] = [P(690, 462), P(640, 446), P(588, 424), P(534, 406), P(486, 394)]
let CENTRAL: [PT] = [P(500, 146), P(512, 200), P(530, 256), P(546, 310), P(560, 364), P(566, 406)]
let STEM: [PT] = [P(470, 480), P(466, 540), P(456, 610), P(444, 700), P(432, 800), P(424, 900), P(420, 1040)]
let EAR: [PT] = [P(520, 412), P(492, 414), P(472, 438), P(466, 478), P(474, 520), P(492, 552), P(512, 562)]
let EAR_IN: [PT] = [P(510, 440), P(494, 452), P(492, 486), P(502, 516)]
let EYE: [PT] = [P(752, 437), P(768, 444), P(784, 445), P(796, 440)]          // the closed lid: a soft downward arc
let LASH: [PT] = [P(756, 441), P(770, 448), P(786, 448)]
let NOSTRIL: [PT] = [P(842, 560), P(852, 566), P(864, 563)]
let LIPS: [PT] = [P(842, 619), P(826, 620), P(812, 618)]
let JAW: [PT] = [P(790, 748), P(724, 735), P(660, 714), P(612, 690), P(588, 664)]

struct MindField { let tone: [Float]; let warm: [Float]; let glow: [Float] }
let MIND: MindField = {
	let N = MD_N
	let head = fillMask(spline(HEAD_PTS, closed: true)), brain = fillMask(spline(BRAIN_PTS, closed: true)), cereb = fillMask(spline(CEREB_PTS, closed: true))
	let dHead = insideDist(head), dBrain = insideDist(brain), dCereb = insideDist(cereb)
	let dMajor = lineDist([spline(SYLVIAN, closed: false), spline(CENTRAL, closed: false)])
	let dStem = lineDist([spline(STEM, closed: false)])
	let dEye = lineDist([spline(EYE, closed: false)]), dLash = lineDist([spline(LASH, closed: false)])
	let dFace = lineDist([spline(NOSTRIL, closed: false), spline(LIPS, closed: false)])
	let dJaw = lineDist([spline(JAW, closed: false)])
	// the folds: grown with Gray-Scott reaction-diffusion (Karl Sims' coral settings) on a coarse grid, so the gyri come
	// out evenly spaced and winding, like a real cortex; then the sulci are the boundaries of the grown pattern
	let G = 250, CELL = Double(N) / Double(G)
	let majorCells = edt(strokeMask([spline(SYLVIAN, closed: false), spline(CENTRAL, closed: false)], 2).map { $0 > 0.3 })
	var A = [Float](repeating: 1, count: G * G), B = [Float](repeating: 0, count: G * G)
	var inside = [Bool](repeating: false, count: G * G)
	for gy in 0..<G { for gx in 0..<G {
		let px = Int((Double(gx) + 0.5) * CELL), py = Int((Double(gy) + 0.5) * CELL)
		inside[gy * G + gx] = brain[py * N + px] > 0.2 && majorCells[py * N + px] > Float(1.6 * CELL)   // the folds grow around the two fissures
		if inside[gy * G + gx] && hash01(gx &* 7 &+ gy &* 1301, 4242) < 0.06 { B[gy * G + gx] = 1 }
	} }
	// ping-pong buffers; each pass writes whole rows in parallel through raw pointers (rows never overlap)
	let pa = UnsafeMutablePointer<Float>.allocate(capacity: G * G), pb = UnsafeMutablePointer<Float>.allocate(capacity: G * G)
	let qa = UnsafeMutablePointer<Float>.allocate(capacity: G * G), qb = UnsafeMutablePointer<Float>.allocate(capacity: G * G)
	defer { pa.deallocate(); pb.deallocate(); qa.deallocate(); qb.deallocate() }
	for i in 0..<(G * G) { pa[i] = A[i]; pb[i] = B[i]; qa[i] = 1; qb[i] = 0 }
	for iter in 0..<5200 {
		let (a, bb, a2, b2) = iter % 2 == 0 ? (pa, pb, qa, qb) : (qa, qb, pa, pb)
		DispatchQueue.concurrentPerform(iterations: G - 2) { r in
			let gy = r + 1
			for gx in 1..<(G - 1) {
				let i = gy * G + gx
				if !inside[i] { a2[i] = 1; b2[i] = 0; continue }
				let la = -a[i] + 0.2 * (a[i - 1] + a[i + 1] + a[i - G] + a[i + G]) + 0.05 * (a[i - G - 1] + a[i - G + 1] + a[i + G - 1] + a[i + G + 1])
				let lb = -bb[i] + 0.2 * (bb[i - 1] + bb[i + 1] + bb[i - G] + bb[i + G]) + 0.05 * (bb[i - G - 1] + bb[i - G + 1] + bb[i + G - 1] + bb[i + G + 1])
				let rr = a[i] * bb[i] * bb[i]
				a2[i] = max(0, min(1, a[i] + 1.0 * la - rr + 0.055 * (1 - a[i])))
				b2[i] = max(0, min(1, bb[i] + 0.5 * lb + rr - (0.062 + 0.055) * bb[i]))
			}
		}
	}
	for i in 0..<(G * G) { B[i] = pb[i] }                                   // 5200 passes: the result is back in pb
	// up to the full grid (bilinear), then the gyri are where B is high
	var fold = [Int8](repeating: 0, count: N * N)
	for y in 0..<N {
		for x in 0..<N where brain[y * N + x] > 0.01 {
			let gx = (Double(x) + 0.5) / CELL - 0.5, gy = (Double(y) + 0.5) / CELL - 0.5
			let x0 = max(0, min(G - 2, Int(gx))), y0 = max(0, min(G - 2, Int(gy)))
			let wx = Float(max(0, min(1, gx - Double(x0)))), wy = Float(max(0, min(1, gy - Double(y0))))
			let p = B[y0 * G + x0] * (1 - wx) + B[y0 * G + x0 + 1] * wx, q = B[(y0 + 1) * G + x0] * (1 - wx) + B[(y0 + 1) * G + x0 + 1] * wx
			fold[y * N + x] = (p * (1 - wy) + q * wy) > 0.2 ? 1 : 0
		}
	}
	var sulcus = [Bool](repeating: false, count: N * N)
	for y in 1..<(N - 1) {
		for x in 1..<(N - 1) where brain[y * N + x] > 0.01 {
			let f = fold[y * N + x]
			if f != fold[y * N + x + 1] || f != fold[(y + 1) * N + x] { sulcus[y * N + x] = true }
			if majorCells[y * N + x] < 1.2 { sulcus[y * N + x] = true }
		}
	}
	let dSulc = edt(sulcus)
	var tone = [Float](repeating: 0, count: N * N), warm = tone, glow = tone
	let L = (0.42, -0.72, -0.55)
	for y in 0..<N {
		for x in 0..<N {
			let i = y * N + x
			let hm = Double(head[i])
			if hm < 0.01 { continue }
			let fx = Double(x), fy = Double(y)
			// glass: a luminous rim (Fresnel) and a faint volume, a little lighter toward the key light
			let dh = Double(dHead[i])
			var v = 0.042 + 0.02 * ss(900, 100, fy) + 0.62 * exp(-pow(dh / 7, 2)) + 0.1 * exp(-dh / 26)
			let face = ss(700, 760, fx)                                                  // the face side catches the light
			v += 0.02 * face
			// the face's quiet features: the closed eye, the ear, the nostril and the lips, the line of the jaw
			v += 0.42 * exp(-pow(Double(dEye[i]) / 3.4, 2)) + 0.1 * exp(-pow(Double(dLash[i]) / 2.4, 2))
			v += 0.26 * exp(-pow(Double(dFace[i]) / 3.2, 2))
			v += 0.07 * exp(-pow(Double(dJaw[i]) / 5, 2))
			// the spinal cord and brainstem: a glass tube with a lit core
			let ds = Double(dStem[i])
			v += 0.42 * exp(-pow(ds / 5, 2)) + 0.08 * exp(-pow(ds / 16, 2))
			var w = 0.0, gl = 0.0
			let bm = Double(brain[i])
			if bm > 0.01 {
				// the brain: lit from above and in front, its gyri as ridges (bright) and its sulci as grooves (dark)
				let db = Double(dBrain[i])
				let ridge = ss(0.5, 11, Double(dSulc[i]))
				let shade = 0.8 + 0.3 * ss(540, 150, fy) * (0.7 + 0.3 * ss(200, 760, fx))
				var bv = (0.08 + 0.46 * ridge) * shade
				bv *= 1 - 0.5 * exp(-pow(Double(dMajor[i]) / 5, 2))                     // the lateral and central sulci, a little deeper
				bv += 0.4 * exp(-pow(db / 6, 2))                                         // its edge glows
				v = max(v, v * (1 - bm) + bv * bm + 0.04)
				w = bm * (0.25 + 0.75 * ridge) * ss(0, 14, db)
				gl = bm * ss(4, 70, db)
			}
			let cm = Double(cereb[i])
			if cm > 0.01 {
				// the cerebellum: fine folia, arcs around a point below the brain
				let r = hypot(fx - 352, fy - 360)
				let folia = 0.5 + 0.5 * cos(2 * Double.pi * r / 19)
				let dc = Double(dCereb[i])
				let cv = 0.08 + 0.3 * folia + 0.36 * exp(-pow(dc / 6, 2))
				v = max(v, v * (1 - cm) + cv * cm + 0.03)
				w = max(w, cm * 0.5 * folia)
				gl = max(gl, cm * 0.6 * ss(3, 30, dc))
			}
			tone[i] = Float(hm * min(0.92, v)); warm[i] = Float(w); glow[i] = Float(gl)
		}
	}
	_ = L
	return MindField(tone: tone, warm: warm, glow: glow)
}()
@inline(__always) func mindSample(_ a: [Float], _ x: Double, _ y: Double) -> Double {
	let fx = x - 0.5, fy = y - 0.5
	if fx < 0 || fy < 0 || fx >= Double(MD_N - 1) || fy >= Double(MD_N - 1) { return 0 }
	let x0 = Int(fx), y0 = Int(fy), wx = Float(fx - Double(x0)), wy = Float(fy - Double(y0))
	let p = a[y0 * MD_N + x0] * (1 - wx) + a[y0 * MD_N + x0 + 1] * wx
	let q = a[(y0 + 1) * MD_N + x0] * (1 - wx) + a[(y0 + 1) * MD_N + x0 + 1] * wx
	return Double(p * (1 - wy) + q * wy)
}
/// the head's tone at a point (0..1): the dot's size, and (through the colour ramp) its colour
@inline(__always) func mindTone(_ x: Double, _ y: Double) -> Double { mindSample(MIND.tone, x, y) }

// ---------------------------------------------------------------- synapses: gold points across the brain, linked
struct Synapse { let x: Double; let y: Double; let phase: Double; let links: [Int] }
let SYNAPSES: [Synapse] = {
	var pts: [(Double, Double)] = []
	var q = 0
	while pts.count < 64 && q < 5000 {
		let x = 220 + 540 * hash01(q, 501), y = 150 + 380 * hash01(q, 777)
		q += 1
		let i = Int(y) * MD_N + Int(x)
		if MIND.glow[i] < 0.5 { continue }
		if pts.contains(where: { hypot($0.0 - x, $0.1 - y) < 38 }) { continue }
		pts.append((x, y))
	}
	return pts.enumerated().map { (i, p) in
		let near = pts.indices.filter { $0 != i }.sorted { hypot(pts[$0].0 - p.0, pts[$0].1 - p.1) < hypot(pts[$1].0 - p.0, pts[$1].1 - p.1) }
		return Synapse(x: p.0, y: p.1, phase: hash01(i, 913), links: Array(near.prefix(2)).filter { $0 > i && hypot(pts[$0].0 - p.0, pts[$0].1 - p.1) < 110 })
	}
}()
