// ================================================================ the world: camera, where things are, the memories
// World units: the skull's 1000-unit box. The camera is 2D (a centre and a scale). The dot lattice is fixed to the screen,
// as the brand's textures are: subjects are "recalled out of" it as they move under it.

// ---------------------------------------------------------------- brand colours (Supermemory Brand Guidelines, colour system)
let FIELD: UInt32 = 0x0100f5           // blue 600: "the field, kept for surfaces the brand owns outright"
let BLUE500: UInt32 = 0x0562ef         // blue 500
let PAPER: UInt32 = 0xf4f8ff
let SKY: UInt32 = 0x94b6ff, DAWN: UInt32 = 0xcde5ff, GOLD: UInt32 = 0xf3c77a, GLOW: UInt32 = 0xfaebcf
@inline(__always) func rgb(_ v: UInt32) -> (Float, Float, Float) { (Float((v >> 16) & 255), Float((v >> 8) & 255), Float(v & 255)) }

// ---------------------------------------------------------------- camera
struct Cam { let cx: Double; let cy: Double; let k: Double }
struct CamKey { let t: Double; let cx: Double; let cy: Double; let k: Double; var stop = false }
let L1_W = (x: 1720.0, y: 449.0)                       // learner-1, beside the skull (off screen until the drop)
let RING: [(Double, Double)] = [-150.0, -90, -30, 30, 90, 150].map { d in
	let a = d * Double.pi / 180; return (L1_W.x + 330 * cos(a), L1_W.y + 215 * sin(a))
}
let MERGE_W = (L1_W.x + 286, 449.0), INFER_W = (L1_W.x - 520, 449.0)     // the inferred memory sits out to the left of its two sources
let CAM: [CamKey] = [
	CamKey(t: b(-2.5), cx: 560, cy: 352, k: 1.42),
	CamKey(t: b(7.6), cx: 650, cy: 520, k: 1.0),
	CamKey(t: b(8.4), cx: 640, cy: 515, k: 1.02),                                 // the chat: a slow push into the skull
	CamKey(t: b(14.4), cx: 598, cy: 452, k: 1.17),
	CamKey(t: b(15.5), cx: 606, cy: 466, k: 1.13, stop: true),
	CamKey(t: b(16.25), cx: L1_W.x + 100, cy: L1_W.y, k: 1.06, stop: true),     // the drop: a whip to learner-1
	CamKey(t: b(23.7), cx: L1_W.x + 30, cy: L1_W.y + 6, k: 1.1, stop: true),
	CamKey(t: b(24.3), cx: RING[1].0, cy: RING[1].1 + 40, k: 1.75, stop: true),  // updates
	CamKey(t: b(25.7), cx: RING[1].0 + 8, cy: RING[1].1 + 44, k: 1.8, stop: true),
	CamKey(t: b(26.3), cx: MERGE_W.0 - 40, cy: MERGE_W.1 + 30, k: 1.6, stop: true),  // merges
	CamKey(t: b(27.7), cx: MERGE_W.0 - 48, cy: MERGE_W.1 + 30, k: 1.65, stop: true),
	CamKey(t: b(28.3), cx: INFER_W.0 + 140, cy: INFER_W.1 + 30, k: 1.42, stop: true),  // infers
	CamKey(t: b(29.7), cx: INFER_W.0 + 148, cy: INFER_W.1 + 34, k: 1.47, stop: true),
	CamKey(t: b(30.3), cx: RING[4].0, cy: RING[4].1 + 10, k: 1.75, stop: true),   // forgets
	CamKey(t: b(31.6), cx: RING[4].0, cy: RING[4].1 + 4, k: 1.8, stop: true),
	CamKey(t: b(32.6), cx: 1135, cy: 520, k: 0.87, stop: true),                   // back out: the skull and learner-1
	CamKey(t: b(37.2), cx: 1120, cy: 515, k: 0.9),
	CamKey(t: b(39.8), cx: 840, cy: 462, k: 1.1, stop: true),                    // in on the skull, context restored
	CamKey(t: T_STILL, cx: 836, cy: 460, k: 1.11),
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
@inline(__always) func scr(_ x: Double, _ y: Double, _ c: Cam) -> CGPoint {
	CGPoint(x: (x - c.cx) * c.k + Double(DW) / 2, y: (y - c.cy) * c.k + Double(DH) / 2)
}
@inline(__always) func world(_ sx: Double, _ sy: Double, _ c: Cam) -> (Double, Double) {
	((sx - Double(DW) / 2) / c.k + c.cx, (sy - Double(DH) / 2) / c.k + c.cy)
}
/// the drop shakes the frame for a moment
func shake(_ t: Double) -> CGPoint {
	let u = t - T_DROP
	if u < 0 || u > 0.35 { return .zero }
	let a = 9 * exp(-u / 0.09)
	return CGPoint(x: a * sin(u * 97), y: a * cos(u * 83))
}

/// a quick zoom punch on the big hits (the drop, each verb); a soft attack, so
/// nothing jumps on a single frame
func punch(_ t: Double) -> Double {
	var p = 0.0
	func hit(_ h: Double, _ a: Double) { if t > h && t < h + 1.2 { let u = t - h; p += a * (1 - exp(-u / 0.03)) * exp(-u / 0.13) } }
	hit(T_DROP, 0.07)
	for o in OPS_T { hit(o, 0.05) }
	// (none on the skull's beats: a zoom re-samples the skull's dots through the screen-fixed lattice and shimmers)
	return p
}

// ---------------------------------------------------------------- the memories
struct Memory { let art: PixArt; let frame: Int; let mind: (Double, Double); let ring: Int }
// what the agent learns in the chat: home, its dog, the bike, the dog again (a duplicate), a kite, a rainy day
let MEMS: [Memory] = [
	Memory(art: ART_HOUSE, frame: 1, mind: (290, 240), ring: 1),
	Memory(art: ART_DOG, frame: 0, mind: (440, 200), ring: 2),
	Memory(art: ART_BIKE, frame: 0, mind: (600, 250), ring: 0),
	Memory(art: ART_DOG, frame: 1, mind: (300, 368), ring: 3),
	Memory(art: ART_KITE, frame: 0, mind: (452, 340), ring: 5),
	Memory(art: SMALL_ARTS[6], frame: 0, mind: (596, 372), ring: 4),
]
let MIND_CELL = 7.0, CARD_CELL = 6.8
/// after learner-1 is done: what comes back into the skull (memory index or a new one) and where it lands
let RECALLED: [(PixArt, Int, (Double, Double))] = [
	(ART_HOUSE2, 0, (290, 232)), (ART_DOG, 0, (448, 200)), (ART_BIKE, 0, (602, 250)), (ART_KITE, 0, (340, 356)), (ART_BEACH, 0, (520, 360)),
]
