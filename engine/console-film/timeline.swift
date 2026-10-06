// ================================================================ shared timeline (picture + sound)
// v3: everything sits on a 160 BPM grid (beat 0.375s, bar 1.5s, 16th 0.09375s) so the score can hit the picture.
let BPM = 160.0, BEAT = 60.0 / BPM, BAR = 4 * BEAT
func bt(_ bar: Double, _ beat: Double = 0) -> Double { bar * BAR + beat * BEAT }
let HOVER = bt(0, 3), CLICK = bt(1)                  // 1.125 hover, 1.5 copy
let FLY_A = bt(1, 0.5), FLY_B = bt(1, 3)             // 1.6875 lift-off, 2.625 lands as the pasted command
let TERM_IN = FLY_A + 0.1
let ENTER = bt(2)                                     // 3.0 enter: banner, first drop
let ROW0 = ENTER + 0.5625                             // terminal lines land on 16ths
func rowT(_ i: Int) -> Double { ROW0 + Double(i) * BEAT / 4 + (i >= 8 ? BEAT / 2 : 0) }
let CUT = bt(3, 1), OAUTH_A = bt(3, 1.5)              // 4.875 after install, 5.0625 one approval
let TABS_T = bt(4)                                    // 6.0 back up to the card (break)
let CLK: [Double] = [bt(5), bt(5, 2), bt(6), bt(6, 2)]   // 7.5 / 8.25 / 9.0 / 9.75 cursor, codex, opencode, muse code
let LIFT_A = bt(7), END = bt(7, 2)                    // 10.5 the logos lift out, 11.25 the card falls away
let LIFT_PILLS = [0, 1, 2, 3, 4, 6, 7]                // every plugin tab except AmpCode (its npm package is a 404)
func liftT(_ k: Int) -> Double { LIFT_A + Double(k) * BEAT / 4 }
let SPIN_A = bt(8)                                    // 12.0 second drop: the ring spins around supermemory
let COL_A = bt(9, 2), COL_B = COL_A + 0.3             // 14.25 the ring collapses into the tile
let HEAD_T = bt(9, 3)                                 // 14.625 final hit: give your agents persistent memory
let LOCK_T = bt(10)                                   // 15.0 lockup
let T_STILL = bt(11), T_END = bt(12)                  // 16.5 still, 18.0 end
