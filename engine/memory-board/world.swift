// ================================================================ the world: the memory board, its cards, the camera
// World units are screen pixels at k = 1 with the camera at (960, 540). Everything sits above the caption band.

// ---------------------------------------------------------------- brand colours (Supermemory Brand Guidelines)
let FIELD: UInt32 = 0x0100f5           // blue 600, the field
let BLUE500: UInt32 = 0x0562ef
let PAPER: UInt32 = 0xf4f8ff
let SKY: UInt32 = 0x94b6ff, DAWN: UInt32 = 0xcde5ff, GOLD: UInt32 = 0xf3c77a, GLOW: UInt32 = 0xfaebcf
@inline(__always) func rgb(_ v: UInt32) -> (Float, Float, Float) { (Float((v >> 16) & 255), Float((v >> 8) & 255), Float(v & 255)) }

// ---------------------------------------------------------------- the board
// Twelve facts in a 4 x 3 grid with chatter bubbles in the gaps. When a fact leaves (it steps aside into the history
// row), the board reflows so it never has holes: the top row re-centres, sf slides into nyc's place, the grid closes up
// once the chatter is gone, and the last row re-centres after the forget call. Every change is a glide, never a cut.
enum Kind { case stay, expire, oldFact, newFact, titan, nearMiss }
struct MemCard { let art: PixArt?; let tag: String; let kind: Kind; let born: Double }
struct Chatter { let text: String; let pos: (Double, Double); let born: Double }
let CARD_W: CGFloat = 250, CARD_H: CGFloat = 186
let COLS: [Double] = [330, 760, 1190, 1620], ROWS: [Double] = [228, 436, 644]
let COLS_T: [Double] = [495, 815, 1135, 1455]                  // the closed-up grid, once the chatter has gone
let BOARD_CX = 975.0
let RAIL_Y = 798.0, HUD_Y: CGFloat = 120
// nine facts are on the board at frame 0 (the thumbnail); three more land on the beats of the first bar
let CARDS: [MemCard] = [
	MemCard(art: ART_CLOCK, tag: "meeting 3pm today", kind: .expire, born: -0.9),
	MemCard(art: ART_PLANE, tag: "flight fri 6am", kind: .expire, born: b(2)),
	MemCard(art: ART_SKYLINE, tag: "lives in nyc", kind: .oldFact, born: -0.75),
	MemCard(art: ART_BRIDGE, tag: "moved to sf", kind: .newFact, born: b(4)),
	MemCard(art: ART_DOG, tag: "dog: biscuit", kind: .stay, born: -0.6),
	MemCard(art: ART_KITE, tag: "kites on sundays", kind: .stay, born: -0.45),
	MemCard(art: ART_CAKE, tag: "birthday: mar 3", kind: .stay, born: -0.3),
	MemCard(art: ART_SUNSET, tag: "likes sunsets", kind: .stay, born: b(3)),
	MemCard(art: ART_DOC, tag: "titan launch plan", kind: .titan, born: -0.82),
	MemCard(art: ART_DOC, tag: "titan budget v2", kind: .titan, born: -0.52),
	MemCard(art: ART_DOC, tag: "titan kickoff notes", kind: .titan, born: -0.22),
	MemCard(art: ART_BIKE, tag: "titanium bike frame", kind: .nearMiss, born: -0.1),
]
let CHATTER: [Chatter] = [
	Chatter(text: "lol", pos: (545, 228), born: -0.7), Chatter(text: "ok", pos: (975, 228), born: b(0.25)),
	Chatter(text: "brb", pos: (1405, 228), born: -0.4), Chatter(text: "thanks!", pos: (545, 436), born: b(0.75)),
	Chatter(text: "hmm", pos: (975, 436), born: -0.2), Chatter(text: "haha", pos: (1405, 436), born: b(1.25)),
	Chatter(text: "k", pos: (545, 644), born: b(1.75)), Chatter(text: "ty", pos: (975, 644), born: b(2.25)),
	Chatter(text: "lmao", pos: (1405, 644), born: b(2.75)), Chatter(text: "np", pos: (150, 332), born: b(3.25)),
	Chatter(text: "omg", pos: (1800, 332), born: b(3.75)), Chatter(text: "nice", pos: (1800, 540), born: b(4.25)),
]
// the board's five layouts: A the start, B after { expires }, C after { updates } (sf takes nyc's place),
// D after { filters } (the gaps close), E after the forget call. nil = the card has left the board.
let LAYOUTS: [[Int: (Double, Double)]] = {
	var A: [Int: (Double, Double)] = [:]
	for i in 0..<12 { A[i] = (COLS[i % 4], ROWS[i / 4]) }
	var B = A; B[0] = nil; B[1] = nil; B[2] = (COLS[1], ROWS[0]); B[3] = (COLS[2], ROWS[0])
	var C = B; C[2] = nil; C[3] = (COLS[1], ROWS[0])
	var D = C; D[3] = (BOARD_CX, ROWS[0])
	for j in 0..<4 { D[4 + j] = (COLS_T[j], ROWS[1]); D[8 + j] = (COLS_T[j], ROWS[2]) }
	var E = D; E[8] = nil; E[9] = nil; E[10] = nil; E[11] = (BOARD_CX, ROWS[2])
	return [A, B, C, D, E]
}()
/// when each reflow starts and how long it takes
let REFLOW: [(Double, Double)] = [(T_EXPIRE + 0.36, 0.72), (T_UPDATE + 0.62, 0.85), (T_FILTER + 1.0, 0.9), (T_APPLY + 0.75, 0.8)]
/// a card's place on the board at time t (a left-to-right wave of glides between the layouts)
func boardPos(_ i: Int, _ t: Double) -> (Double, Double) {
	var p = LAYOUTS[0][i]!
	for (j, (t0, d)) in REFLOW.enumerated() {
		guard let q = LAYOUTS[j + 1][i] else { break }
		if q.0 == p.0 && q.1 == p.1 { continue }
		let st = 0.04 * max(0, min(4, (q.0 - 300) / 330))
		let u = einout(seg(t, t0 + st, t0 + st + d))
		if u <= 0 { break }
		p = (lerp(p.0, q.0, u), lerp(p.1, q.1, u))
	}
	return p
}
/// when a card steps aside into the history row, and which slot it takes
let STEP: [Int: (Double, Int)] = [0: (T_EXPIRE + 0.12, 0), 1: (T_EXPIRE + 0.24, 1), 2: (T_UPDATE + 0.42, 2),
                                  8: (T_APPLY + 0.25, 3), 9: (T_APPLY + 0.36, 4), 10: (T_APPLY + 0.47, 5)]
let FLY = 0.75                                                   // a card's trip into history (s)
func railSlot(_ k: Int) -> (Double, Double) { (BOARD_CX + (Double(k) - 2.5) * 150, RAIL_Y) }

// ---------------------------------------------------------------- camera
// One continuous take: a slow push toward each change, a pull back so every glide into history is seen, and room at
// the top while the code editor is open. No shake, no zoom punches (her v1 note: smooth).
struct Cam { let cx: Double; let cy: Double; let k: Double }
struct CamKey { let t: Double; let cx: Double; let cy: Double; let k: Double; var stop = false }
let CAM: [CamKey] = [
	CamKey(t: b(-2.5), cx: 977, cy: 482, k: 1.06),
	CamKey(t: b(7.6), cx: 977, cy: 486, k: 1.0),
	CamKey(t: b(9.0), cx: 980, cy: 482, k: 1.02),
	CamKey(t: b(15.4), cx: 990, cy: 470, k: 1.07, stop: true),                    // toward the answer and its two sources
	CamKey(t: b(16.8), cx: 977, cy: 486, k: 1.0, stop: true),                     // the drop: settle
	CamKey(t: b(19.0), cx: 630, cy: 380, k: 1.2),                                 // the clocks run down
	CamKey(t: b(20.2), cx: 640, cy: 388, k: 1.22, stop: true),
	CamKey(t: b(22.0), cx: 977, cy: 534, k: 0.99),                               // follow them into history; the top row re-centres
	CamKey(t: b(22.5), cx: 977, cy: 530, k: 1.0, stop: true),
	CamKey(t: b(23.9), cx: 977, cy: 364, k: 1.19),                               // { updates }
	CamKey(t: b(24.6), cx: 977, cy: 366, k: 1.2, stop: true),
	CamKey(t: b(26.0), cx: 977, cy: 534, k: 0.99, stop: true),                    // ... nyc into history, sf into its place
	CamKey(t: b(27.8), cx: 977, cy: 518, k: 1.02),                                // { filters }
	CamKey(t: b(31.4), cx: 977, cy: 526, k: 1.0, stop: true),
	CamKey(t: b(32.6), cx: 977, cy: 462, k: 0.84, stop: true),                    // room for the editor
	CamKey(t: b(37.8), cx: 977, cy: 462, k: 0.84, stop: true),
	CamKey(t: b(39.4), cx: 977, cy: 534, k: 0.99, stop: true),                    // recall: a slow push while the answer lands
	CamKey(t: b(47.6), cx: 977, cy: 526, k: 1.025, stop: true),
	CamKey(t: T_STILL, cx: 977, cy: 526, k: 1.025),
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
func shake(_ t: Double) -> CGPoint { .zero }
func punch(_ t: Double) -> Double { 0 }
