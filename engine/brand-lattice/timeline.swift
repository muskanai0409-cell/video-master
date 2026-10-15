// ================================================================ timeline, on the beat grid (the edit is cut to the music)
// 12 bars of 4 beats, then a held end card. Every scene change, pop and word lands on a beat.
//  bars 1-2   01 · WEIGHTS    the skull, recalled out of the dot lattice (diamonds); when training ends it freezes: a sweep
//                             turns its dots back to stored squares, at rest. Context will be the only thing that moves
//  bars 3-4   02 · CONTEXT    a chat: memories form in the skull and stream out of frame; then the context resets
//  bar  5     the drop        the camera whips to learner-1, which has every memory: it was extracting all along
//  bars 5-6   03 · LEARNER-1  it dreams on them: memory cards shuffle into a stack and settle into its lattice
//  bars 7-8   04 · DREAMING   updates · merges · infers · forgets, one hit each
//  bars 9-10  05 · RECALL     the next chat: memories turn 45° (recalled) and pour back into the skull, which relights
//  bars 11-12 the skull's dots gather into the supermemory mark, built of recalled diamonds; the lockup
let BPM = Double(ProcessInfo.processInfo.environment["BPM"] ?? "150") ?? 150
let BEAT = 60.0 / BPM, BAR = 4 * BEAT
@inline(__always) func b(_ n: Double) -> Double { n * BEAT }
let T_INTRO = 0.0
let T_CHAT = b(8), T_RESET = b(14.5), T_DROP = b(16)
let T_DREAM = b(16), T_OPS = b(24), T_RECALL = b(32), T_END0 = b(40)
let OPS_T: [Double] = [b(24), b(26), b(28), b(30)]          // updates, merges, infers, forgets
let T_MARK = b(42), WORD_T = b(44)                        // the lockup lands on a beat of the half-time loop kits
let T_STILL = b(47), T_END = b(47) + 1.3
// captions (top statement in, bottom statement in, out)
let CAP: [(String, String, Double, Double, Double)] = [
	("weights freeze", "the day training ends", -0.8, -0.55, b(7.5)),
	("the context window", "resets every session", b(8.5), b(9.5), b(15.6)),
	("learner-1 extracts and dreams", "on the context of any user, task, or tenant", b(16.3), b(17.3), b(22.9)),
	("", "", b(24), b(24), b(31.7)),                                  // the four verbs carry their own type
	("injected as tokens into context", "in real time", b(32.3), b(33.3), b(39.6)),
	("learner-1", "memory that keeps learning", b(41), b(42), 1e9),
]
// shared with the score: when each memory forms in the skull, when the weights freeze, when each memory is recalled
let LEARN_AT: [Double] = (0..<6).map { b(8.5 + Double($0)) }
let FREEZE0 = b(4.2), FREEZE1 = b(6.8)                            // the training stream stops at FREEZE0
let RECALL_AT: [Double] = (0..<5).map { b(33 + Double($0)) }
let RECALL_LAND = 0.6                                              // a recalled copy lands this long after it leaves
