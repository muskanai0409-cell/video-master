// ================================================================ timeline, on the beat grid (the edit is cut to the music)
// "forgetting on purpose": the memory field guide, film 1. Each section is 8 film beats = one bar of the Apple Loops kit
// ("Regrets", F minor, 80 BPM; the film runs at 160).
//  S0 b0-8    01 · REMEMBERING   the board floods: the meeting, the old address, every lol
//  S1 b8-16   02 · THE PROBLEM   "where do i live?" pulls back nyc AND sf: things that stopped being true
//  S2 b16     the drop           supermemory forgets on purpose
//  b20        { expires }        temporary facts drop after they expire (the meeting, the flight)
//  b24        { updates }        updates win for what's true now (nyc steps aside for sf)
//  b28        { filters }        casual chatter is less likely to stick (lol, ok, thanks, brb vanish)
//  S4 b32-40  04 · ON COMMAND    forgetMatching("forget everything about Project Titan", dryRun: true), then forget the ids
//  S5 b40-48  05 · RECALL        the same question, one clean answer; the history rail is still there
//  S6 b48-    the board gathers into the mark; the lockup
let BPM = Double(ProcessInfo.processInfo.environment["BPM"] ?? "160") ?? 160
let BEAT = 60.0 / BPM, BAR = 4 * BEAT
@inline(__always) func b(_ n: Double) -> Double { n * BEAT }
let T_DROP = b(16)
let T_EXPIRE = b(20), T_UPDATE = b(24), T_FILTER = b(28)
let T_CODE = b(32), T_PREVIEW = b(35), T_APPLY = b(37)
let T_RECALL = b(40)
let T_ASK1 = b(9), T_ASK2 = b(41)
let T_END0 = b(48), T_MARK = b(50), WORD_T = b(52)
let T_STILL = b(55), T_END = b(55) + 1.3
let OPS_T: [Double] = [T_EXPIRE, T_UPDATE, T_FILTER, T_CODE]
// captions (top statement in, bottom statement in, out)
let CAP: [(String, String, Double, Double, Double)] = [
	("your agent saved all of it", "the meeting, the old address, every lol", -0.8, -0.55, b(7.4)),
	("so it answers with things", "that stopped being true", b(8.4), b(9.2), b(15.4)),
	("supermemory forgets", "on purpose", b(16.3), b(16.9), b(19.5)),
	("or tell it what to forget", "and preview it first", b(32.3), b(33.0), b(39.4)),
	("forgets when information expires", "the history is not erased", b(42.0), b(42.8), b(47.6)),
	("forgetting, on purpose", "memory that keeps learning", b(49.5), b(50.3), 1e9),
]
let SECTIONS: [(String, Double, Double)] = [("01 · remembering", -1, b(7.6)), ("02 · the problem", b(8.2), b(15.6)),
                                           ("03 · forgetting on purpose", b(16.1), b(31.6)), ("04 · on command", b(32.1), b(39.6)),
                                           ("05 · recall", b(40.1), b(47.6))]
