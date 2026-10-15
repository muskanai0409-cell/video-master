// ================================================================ timeline, on the beat grid (the edit is cut to the music)
// The score is GarageBand's "Rise Up" kit, which runs at 81 BPM. The film counts at twice that, 162 BPM (a film beat is
// 0.370s), so every 8-beat section is one bar of the kit. Every morph, line and hit lands on a beat.
//  b0-8    hook       "v0.0.9" recalled out of the dot lattice, solid on b2; a prompt chip pops (b3); the version flies
//                     up into the corner and the chip stretches into the command bar; `docker compose up -d` is typed
//  b8-16   01 docker  ENTER on the drop: the bar opens into a terminal, two output lines on the beat
//  b16-24  02 api v5  the terminal becomes a v5 call, namespace first; the memory comes back as a chip
//  b24-32  03 security the call becomes a request: 401 without the key (the lock closes), the key row goes in, 200
//  b32-39  04 speed   the request becomes a counter, 0 to 40%, while the lattice streaks past
//  b39-46  05 next    the counter slices into 10 squares; 9 fall back into the lattice on the breakdown (b40); one is left
//  b46-    the end    the last square carves itself into the mark; the lockup lands on b48; the install command; a still
let BPM = Double(ProcessInfo.processInfo.environment["BPM"] ?? "162") ?? 162
let BEAT = 60.0 / BPM, BAR = 4 * BEAT
@inline(__always) func b(_ n: Double) -> Double { n * BEAT }
let T_SOLID = b(2), T_CHIP = b(3), T_FLY = b(4.2), T_TYPE0 = b(5.3), T_TYPE1 = b(7.4)
let T_ENTER = b(8), T_OUT1 = b(10), T_OUT2 = b(11)
let T_V5 = b(16), T_NS = b(18), T_RESULT = b(19)
let T_SEC = b(24), T_FIRE1 = b(25), T_401 = b(26), T_AUTH = b(27), T_FIRE2 = b(29), T_200 = b(30)
let T_SPD = b(32), T_COUNT1 = b(34)
let T_SLICE = b(39), T_DROPOUT = b(40), T_SURV = b(41.6)
let T_MARK = b(46), WORD_T = b(48), T_CMD = WORD_T + 0.26
let T_STILL = b(50.2), T_END = b(50.2) + 1.25
let TYPED = "docker compose up -d"
let TYPE_DT = (T_TYPE1 - T_TYPE0) / Double(TYPED.count)
/// the squares dissolve from the outside in on the breakdown; square 4 is the one left
let DISSOLVE_ORDER = [0, 9, 1, 8, 2, 7, 3, 6, 5]
let SURVIVOR = 4
func dissolveT(_ i: Int) -> Double? { DISSOLVE_ORDER.firstIndex(of: i).map { T_DROPOUT + 0.055 * Double($0) } }
func sliceT0(_ i: Int) -> Double { T_SLICE + 0.022 * (4.5 - abs(Double(i) - 4.5)) }
/// the drum hits every score shares (measured from the Rise Up, Legend, Sophistication and Sympathy beats, in film beats
/// inside a 32-beat cycle): bar downbeats and the backbeat snares. The lattice pulses on them while the drums play
/// (b8 to b40), so the picture stays in sync whichever score goes on it
let KICKS_LOOP: [Double] = [0, 8, 16, 24], SNARES_LOOP: [Double] = [2, 6, 10, 14, 18, 22, 26, 30]
let DRUM_HITS: [(Double, Double)] = {
	var h: [(Double, Double)] = []
	for k in 0..<2 {
		for x in KICKS_LOOP { let bt = x + 32 * Double(k); if bt >= 8 && bt < 40 { h.append((b(bt), 1.0)) } }
		for x in SNARES_LOOP { let bt = x + 32 * Double(k); if bt >= 8 && bt < 40 { h.append((b(bt), 0.7)) } }
	}
	return h.sorted { $0.0 < $1.0 }
}()
