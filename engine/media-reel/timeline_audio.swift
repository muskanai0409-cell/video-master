// timeline_audio.swift: the score's clock, shared with dsp.swift. Must match reel.swift: 100 BPM, one bar per medium.
//  bar 0 light · bar 1 engraving · bar 2 type · bar 3 survey · bar 4 riso · bar 5 mirror room · bars 6-7 the paint-on and lockup
import Foundation
let BPM = 100.0
let BEAT = 60.0 / BPM, BAR = 4 * BEAT
@inline(__always) func b(_ n: Double) -> Double { n * BEAT }
@inline(__always) func bar(_ n: Double) -> Double { n * BAR }
let PAINT_T0 = bar(6.35), PAINT_T1 = bar(7.0), HOLD_T = bar(7.4)
let T_END = bar(8) + 0.6
