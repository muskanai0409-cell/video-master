// score_forget.swift: the score for "forgetting on purpose", arranged from Apple Loops on the picture's beat grid.
// The kit is GarageBand's "Regrets" (01 Hip Hop pack): F minor, 80 BPM, so each 8-beat section of the film (160) is one
// bar of the kit and the kit's bar 1 sits at t = 0. Real recorded parts: beat, piano, sub bass, a strings phrase.
// Licence: the GarageBand licence lets us use its loops "on a royalty-free basis, to create your own original
// soundtracks for your video and audio projects". The decoded loops stay in ~/Library/Caches/video-master/loops, never in a repo.
// Sound effects: Kenney UI clicks (CC0, sfx/KENNEY_LICENSE.txt) for typing and pops; the rest is synthesised (dsp.swift).
import Foundation

let ENVV = ProcessInfo.processInfo.environment
let LOOPDIR = ENVV["LOOPDIR"] ?? ""
let PRIME = 2112.0 / 44100.0

var drums = Bus(NS), bass = Bus(NS), mel = Bus(NS), fx = Bus(NS), revSend = Bus(NS)

struct Loop { let L: [Float]; let R: [Float]; let len: Int }
func loadLoop(_ name: String, beats: Int) -> Loop {
	let d = try! Data(contentsOf: URL(fileURLWithPath: LOOPDIR + "/" + name + ".f32"))
	let f: [Float] = d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
	let n = f.count / 2, off = Int((PRIME * SR).rounded())
	let len = Int((Double(beats) * 2 * BEAT * SR).rounded())
	var L = [Float](repeating: 0, count: len), R = L
	for i in 0..<len where off + i < n { L[i] = f[2 * (off + i)]; R[i] = f[2 * (off + i) + 1] }
	return Loop(L: L, R: R, len: len)
}
func layer(_ lp: Loop, _ t0: Double, _ t1: Double, _ g: Double, into b: inout Bus, fadeIn: Double = 0.01, fadeOut: Double = 0.04, rev: Double = 0, offset: Double = 0) {
	let a = max(0, Int(t0 * SR)), z = min(NS, Int(t1 * SR))
	if z <= a { return }
	let fi = max(1, Int(fadeIn * SR)), fo = max(1, Int(fadeOut * SR)), o = Int(offset * SR)
	for i in a..<z {
		let j = ((i - o) % lp.len + lp.len) % lp.len
		var e = Float(g)
		if i - a < fi { e *= Float(i - a) / Float(fi) }
		if z - i < fo { e *= Float(z - i) / Float(fo) }
		b.L[i] += lp.L[j] * e; b.R[i] += lp.R[j] * e
		if rev > 0 { revSend.L[i] += lp.L[j] * e * Float(rev); revSend.R[i] += lp.R[j] * e * Float(rev) }
	}
}
func sec(_ k: Int) -> Double { k >= 7 ? T_END : b(Double(8 * k)) }
func part(_ lp: Loop, _ g: Double, _ secs: [Int], into b: inout Bus, rev: Double = 0.12, fadeOut: Double = 0.04) {
	var spans: [(Int, Int)] = []
	for s in secs.sorted() { if let l = spans.last, l.1 == s { spans[spans.count - 1].1 = s + 1 } else { spans.append((s, s + 1)) } }
	for (s0, s1) in spans { layer(lp, sec(s0), sec(s1), g, into: &b, fadeOut: fadeOut, rev: rev) }
}

// ---------------------------------------------------------------- the kit
let BEATL = loadLoop("Regrets_Beat", beats: 32), PIANO = loadLoop("Regrets_Piano", beats: 32)
let SUB = loadLoop("Regrets_Sub_Bass", beats: 32), STR = loadLoop("Regrets_Strings", beats: 4)
//  S0 remembering · S1 the problem · S2 the drop + expires · S3 updates + filters · S4 on command · S5 recall · S6 end
part(PIANO, 0.42, [0, 1, 2, 3, 4, 5, 6], into: &mel, rev: 0.16, fadeOut: 0.3)
part(BEATL, 0.5, [0], into: &drums, rev: 0.03, fadeOut: 0.02)
part(BEATL, 0.62, [1, 2, 3, 5], into: &drums, rev: 0.03, fadeOut: 0.02)
part(SUB, 0.5, [1, 2, 3, 4, 5], into: &bass, rev: 0)
for t0 in [T_DROP, b(40)] { layer(STR, t0, t0 + b(8), 0.36, into: &mel, fadeOut: 0.2, rev: 0.3, offset: t0) }   // a strings swell on the drop and on recall
// the turn: the drums drop out for the last beat and a half of S1, a snare roll and a riser pull into the drop
for i in Int(b(14.5) * SR)..<Int(b(16) * SR) { drums.L[i] = 0; drums.R[i] = 0 }
for k in 0..<12 { let tt = b(14.5) + b(0.125) * Double(k); fx.add(snare(1, pitch: 1.05), at: tt, gain: 0.03 + 0.012 * Double(k)) }
let (r1L, r1R) = riser(b(1.6), 0.06, f0: 400, f1: 9000)
fx.addSt(r1L, r1R, at: b(14.4), gain: 1)
let (c1L, c1R) = crash(0.4)
fx.addSt(c1L, c1R, at: T_DROP, gain: 1); fx.add(boom(1), at: T_DROP, gain: 0.32)
let (c2L, c2R) = crash(0.32)
fx.addSt(c2L, c2R, at: b(40), gain: 1)

// ---------------------------------------------------------------- sound effects on the picture's events
// (mirrors of the picture's data in world.swift and scene_film.swift; the audio build has no CoreGraphics)
let CARD_BORN: [(Double, Double)] = [(b(2), 760), (b(3), 1620), (b(4), 1620)]
let CHAT_BORN: [(Double, Double)] = [(b(0.25), 975), (b(0.75), 545), (b(1.25), 1405), (b(1.75), 545), (b(2.25), 975), (b(2.75), 1405), (b(3.25), 128), (b(3.75), 1800), (b(4.25), 1800)]
let CODE1 = ["memories.forgetMatching(\"user_123\", {", "  query: \"forget everything about Project Titan\",", "  dryRun: true,", "})"]
let CODE2 = ["memories.forget(\"user_123\", {", "  ids: preview.matches.map((m) => m.id),", "})"]
let SW = ["switch11", "switch12", "switch13", "switch14", "switch24", "switch26"].map { sample($0) }
let CL = ["click_002", "click_003", "click_005"].map { sample($0) }
for (i, (t, x)) in CARD_BORN.enumerated() { fx.add(SW[i % SW.count], at: t, gain: 0.32, pan: (x - 960) / 1200) }
for (i, (t, x)) in CHAT_BORN.enumerated() { fx.add(SW[(i + 3) % SW.count], at: t, gain: 0.22, pan: (x - 960) / 1200) }
// the clocks run down: a tick each beat, then the stamp
for k in 0..<5 { fx.add(CL[0], at: T_EXPIRE - b(2.5) + b(Double(k) * 0.5), gain: 0.34 + 0.06 * Double(k), pan: -0.4) }
for (t, g) in [(T_EXPIRE, 0.32), (T_EXPIRE + 0.12, 0.22), (T_UPDATE + 0.05, 0.3)] { drums.add(thump(1), at: t, gain: g) }
fx.add(bell(84, 1, decay: 0.6), at: T_UPDATE, gain: 0.07, pan: 0.4)                       // the latest fact wins
for j in 0..<3 { for q in 0..<2 { fx.add(CL[(j + q) % 3], at: T_UPDATE + 0.07 * Double(j) + 0.08 * Double(q), gain: 0.16, pan: 0.45) } }   // the split-flap
for j in 0..<3 { fx.add(CL[2], at: T_PREVIEW + 0.08 * Double(j) + 0.05, gain: 0.18, pan: -0.1 + 0.1 * Double(j)) }   // the ticks draw
// the chatter vanishes: a short fizz falling away, and a scatter of grains
var fz = [Float](repeating: 0, count: Int(SR * 0.7)); var bpf = SVF()
for i in 0..<fz.count { let x = Double(i) / SR; fz[i] = Float(bpf.step(rnd(), 9000 * pow(0.25, x / 0.7), 2.5).bp * exp(-x / 0.22) * min(1, x / 0.01)) }
fx.add(fz, at: T_FILTER + 0.1, gain: 0.5)
for k in 0..<26 { let g = Double(k) / 26; fx.add(CL[k % 3], at: T_FILTER + 0.12 + 0.6 * g * g, gain: 0.08 * (1 - g), pan: (rnd() * 0.8)) }
// typing: one click per character as the code types itself
func typeClicks(_ lines: [String], _ start: Double, _ cps: Double) {
	var n = 0
	for line in lines { for ch in line { if ch != " " { fx.add(CL[n % 3], at: start + Double(n) / cps, gain: 0.07 + 0.03 * rnd(), pan: 0.1 * rnd()) }; n += 1 } }
}
typeClicks(CODE1, T_CODE + 0.1, 46); typeClicks(CODE2, b(36.1), 60)
for k in 0..<3 { fx.add(CL[1], at: T_PREVIEW + 0.11 * Double(k), gain: 0.2) }             // the preview counts to 3
drums.add(thump(1), at: T_APPLY, gain: 0.34); fx.add(boom(1), at: T_APPLY, gain: 0.12)
// the answers: a doubtful pair, then one clean note
fx.add(bell(80, 1, decay: 0.5), at: b(12.2), gain: 0.06, pan: -0.2); fx.add(bell(79, 1, decay: 0.5), at: b(12.2) + 0.16, gain: 0.06, pan: 0.2)
fx.add(bell(84, 1, decay: 0.9), at: T_ASK2 + 1.05, gain: 0.08)

// v3: the bar appears, the question types itself, the split-flap shuffles and lands, the bar opens into the editor
// and folds back
fx.add(SW[0], at: T_ASK1 - 0.45, gain: 0.2)
func typeQ(_ start: Double) { for (n, ch) in "where do i live?".enumerated() where ch != " " { fx.add(CL[n % 3], at: start + Double(n) / 26, gain: 0.06 + 0.02 * rnd()) } }
typeQ(T_ASK1 + 0.1); typeQ(T_ASK2 + 0.1)
func flutter(_ from: Double, _ to: Double) { var tt = from; var n = 0; while tt < to { fx.add(CL[n % 3], at: tt, gain: 0.045 + 0.02 * rnd(), pan: 0.05 * rnd()); tt += 0.055; n += 1 } }
flutter(b(12.2) - 0.1, b(12.2) + 0.46); flutter(T_ASK2 + 0.5, T_ASK2 + 1.16)
for j in 0..<3 { fx.add(CL[1], at: b(12.2) + 0.3 + 0.08 * Double(j), gain: 0.14); fx.add(CL[1], at: T_ASK2 + 1.0 + 0.08 * Double(j), gain: 0.14) }
fx.add(SW[1], at: T_CODE - 0.35, gain: 0.22); fx.add(SW[3], at: b(38.2), gain: 0.18)

// ---------------------------------------------------------------- the end: drums out, a riser, the lockup
lowpassSweep(&mel, b(48), WORD_T - 0.01, 4200, 700)
let (r3L, r3R) = riser(WORD_T - b(48) - 0.02, 0.075, f0: 300, f1: 9500)
fx.addSt(r3L, r3R, at: b(48), gain: 1)
let revC2 = reversed(crash(0.32))
fx.addSt(revC2.0, revC2.1, at: WORD_T - Double(revC2.0.count) / SR, gain: 0.45)
fx.add(boom(1), at: WORD_T, gain: 0.34)
let (c4L, c4R) = crash(0.3)
fx.addSt(c4L, c4R, at: WORD_T, gain: 1)
layer(SUB, WORD_T, T_END, 0.5, into: &bass)

// ---------------------------------------------------------------- mix
highpass(&mel, 90)
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
highpass(&rev, 200)
var music = Bus(NS)
music.mix(drums, 1.0); music.mix(bass, 1.0); music.mix(mel, 1.0); music.mix(fx, 1.0); music.mix(rev, 0.9)
highpass(&music, 28)
compress(&music, thr: -14, ratio: 2.0, att: 0.008, rel: 0.2)
let fadeA = Int((T_STILL - 0.1) * SR), fadeZ = Int((T_END - 0.1) * SR)
for i in fadeA..<NS {
	let kk = i >= fadeZ ? Float(0) : Float(1 - Double(i - fadeA) / Double(fadeZ - fadeA))
	music.L[i] *= kk * kk; music.R[i] *= kk * kk
}
limit(&music, ceiling: 0.89)
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav("mix", music)
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(music.L[i]), abs(music.R[i])) }
print(String(format: "BPM %.0f, %.2fs, peak %.2f dBFS", BPM, T_END, 20 * log10(Double(pk))))
