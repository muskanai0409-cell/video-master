// score_loops.swift: the v8 score, arranged from Apple Loops on the picture's beat grid. Muskan rejected the code-made
// v7 track ("I DONT LIKE THE SONG AT ALL"), so these are real recorded and produced parts: drums, sub bass, keys,
// guitars, synths.
// Licence: the GarageBand licence (/Applications/GarageBand.app/Contents/Resources/GarageBand License Agreement.pdf)
// lets us use its loops "on a royalty-free basis, to create your own original soundtracks for your video and audio
// projects" and to "broadcast and/or distribute" those soundtracks. The loops themselves are never shipped on their own.
// The decoded loops live in ~/Library/Caches/video-master/loops, never in a repo.
//
// The kits run at half the film's BPM, so each 8-beat section of the film is one bar of the kit, and the kit's bar 1
// sits at t = 0:
//  S0 b0-8    intro: keys only, filtered and opening up; "weights freeze" tape-stops it
//  S1 b8-16   the chat: the drums come in; the reset (b14.5) muffles and cuts everything, with a riser into the drop
//  S2 b16-24  the drop: the full kit, sub bass and lead, a crash and a boom on the whip
//  S3 b24-32  the four verbs: the kit's second colour
//  S4 b32-40  recall: the full kit again
//  S5 b40-    the gather: drums out, the keys close down under a riser; the lockup (b44) opens them back up with the sub
import Foundation

let ENVV = ProcessInfo.processInfo.environment
let KIT = ENVV["KIT"] ?? "yearning"
let LOOPDIR = ENVV["LOOPDIR"] ?? ""
let PRIME = 2112.0 / 44100.0                                     // AAC priming at the head of every decoded loop

var drums = Bus(NS), bass = Bus(NS), mel = Bus(NS), intro = Bus(NS), fx = Bus(NS), revSend = Bus(NS)

struct Loop { let L: [Float]; let R: [Float]; let len: Int }
func loadLoop(_ name: String, beats: Int) -> Loop {
	let d = try! Data(contentsOf: URL(fileURLWithPath: LOOPDIR + "/" + name + ".f32"))
	let f: [Float] = d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
	let n = f.count / 2, off = Int((PRIME * SR).rounded())
	let len = Int((Double(beats) * 2 * BEAT * SR).rounded())     // one kit beat = two film beats
	var L = [Float](repeating: 0, count: len), R = L
	for i in 0..<len where off + i < n { L[i] = f[2 * (off + i)]; R[i] = f[2 * (off + i) + 1] }
	return Loop(L: L, R: R, len: len)
}
/// a loop running in time with the film, audible from t0 to t1 (short fades at the edges)
func layer(_ lp: Loop, _ t0: Double, _ t1: Double, _ g: Double, into b: inout Bus, fadeIn: Double = 0.01, fadeOut: Double = 0.04, rev: Double = 0) {
	let a = max(0, Int(t0 * SR)), z = min(NS, Int(t1 * SR))
	if z <= a { return }
	let fi = max(1, Int(fadeIn * SR)), fo = max(1, Int(fadeOut * SR))
	for i in a..<z {
		let j = i % lp.len
		var e = Float(g)
		if i - a < fi { e *= Float(i - a) / Float(fi) }
		if z - i < fo { e *= Float(z - i) / Float(fo) }
		b.L[i] += lp.L[j] * e; b.R[i] += lp.R[j] * e
		if rev > 0 { revSend.L[i] += lp.L[j] * e * Float(rev); revSend.R[i] += lp.R[j] * e * Float(rev) }
	}
}
func sec(_ k: Int) -> Double { k >= 6 ? T_END : b(Double(8 * k)) }
/// a part plays in the listed sections (contiguous ones join into one span)
func part(_ name: String, _ beats: Int, _ g: Double, _ secs: [Int], into b: inout Bus, rev: Double = 0.12, fadeOut: Double = 0.04) {
	let lp = loadLoop(name, beats: beats)
	var spans: [(Int, Int)] = []
	for s in secs.sorted() { if let l = spans.last, l.1 == s { spans[spans.count - 1].1 = s + 1 } else { spans.append((s, s + 1)) } }
	for (s0, s1) in spans { layer(lp, sec(s0), sec(s1), g, into: &b, fadeOut: fadeOut, rev: rev) }
}

// ---------------------------------------------------------------- the kits (GarageBand "01 Hip Hop" pack)
switch KIT {
case "longing":                                                   // C minor, 82 BPM (film 164): lush R&B
	part("Longing_Piano", 16, 0.42, [0], into: &intro); part("Longing_Pad", 16, 0.4, [0], into: &intro)
	part("Longing_Beat", 16, 0.62, [1, 2, 3, 4], into: &drums, rev: 0.04, fadeOut: 0.02)
	part("Longing_Bass", 16, 0.55, [2, 3, 4], into: &bass, rev: 0)
	part("Longing_Piano", 16, 0.34, [1, 5], into: &mel); part("Longing_Guitar", 16, 0.36, [1, 2, 4], into: &mel)
	part("Longing_Electric_Piano", 16, 0.36, [2, 4], into: &mel); part("Longing_Synth_01", 16, 0.3, [2, 4], into: &mel)
	part("Longing_Strings_01", 16, 0.3, [2, 4], into: &mel); part("Longing_Synth_02", 16, 0.34, [3], into: &mel)
	part("Longing_Strings_02", 16, 0.32, [3, 5], into: &mel); part("Longing_Pad", 16, 0.3, [3, 5], into: &mel, fadeOut: 0.3)
case "fullmoon":                                                  // F# minor, 77 BPM (film 154): dark piano and a lead
	part("Full_Moon_Piano", 32, 0.45, [0], into: &intro); part("Full_Moon_FX_Synth", 32, 0.35, [0], into: &intro)
	part("Full_Moon_Beat", 32, 0.62, [1, 2, 3, 4], into: &drums, rev: 0.04, fadeOut: 0.02)
	part("Full_Moon_Sub_Bass", 32, 0.55, [2, 3, 4], into: &bass, rev: 0)
	part("Full_Moon_Piano", 32, 0.38, [1, 2, 4, 5], into: &mel); part("Full_Moon_Synth_Lead", 32, 0.34, [2, 3, 4], into: &mel)
	part("Full_Moon_FX_Synth", 32, 0.32, [3, 5], into: &mel, fadeOut: 0.3)
default:                                                          // "yearning": A minor, 70 BPM (film 140): guitar and keys
	part("Yearning_Electric_Piano", 16, 0.4, [0], into: &intro); part("Yearning_Synth_Pad", 16, 0.36, [0], into: &intro)
	part("Yearning_Beat", 16, 0.6, [1, 2, 3, 4], into: &drums, rev: 0.04, fadeOut: 0.02)
	part("Yearning_Sub_Bass", 16, 0.55, [2, 3, 4], into: &bass, rev: 0)
	part("Yearning_Electric_Piano", 16, 0.34, [1, 2, 4, 5], into: &mel); part("Yearning_Acoustic_Guitar", 16, 0.34, [1, 2, 4], into: &mel)
	part("Yearning_Synth_Arp", 16, 0.26, [1, 3], into: &mel); part("Yearning_Synth_Lead", 16, 0.28, [2, 4], into: &mel)
	part("Yearning_Synth_Drone", 16, 0.26, [2], into: &mel); part("Yearning_Synth_Guitar", 16, 0.3, [3], into: &mel)
	part("Yearning_Gated_Synth", 16, 0.24, [3], into: &mel); part("Yearning_Synth_Pad", 16, 0.3, [3, 4, 5], into: &mel, fadeOut: 0.3)
}

// ---------------------------------------------------------------- b0-8: the intro opens up, then "weights freeze"
lowpassSweep(&intro, 0, b(6.2), 650, 3200)
tapeStop(&intro, b(6.2), b(1.3))
let revCrash = reversed(crash(0.45))
fx.addSt(revCrash.0, revCrash.1, at: b(8) - Double(revCrash.0.count) / SR, gain: 0.3)

// ---------------------------------------------------------------- b14.5: the context window resets
var cut = Bus(NS)
cut.mix(drums, 1); cut.mix(bass, 1); cut.mix(mel, 1)
for i in Int(b(14.5) * SR)..<Int(b(16) * SR) { drums.L[i] = 0; drums.R[i] = 0; bass.L[i] = 0; bass.R[i] = 0; mel.L[i] = 0; mel.R[i] = 0 }
lowpassSweep(&cut, b(14.5), b(15.6), 2400, 160)
for i in 0..<NS where Double(i) / SR < b(14.5) || Double(i) / SR >= b(15.6) { cut.L[i] = 0; cut.R[i] = 0 }
let fadeStart = Int(b(15.25) * SR), fadeLen = Double(Int(b(15.6) * SR) - fadeStart)
for i in fadeStart..<Int(b(15.6) * SR) { let u = Float(Double(i - fadeStart) / fadeLen); cut.L[i] *= 1 - u; cut.R[i] *= 1 - u }
let (r1L, r1R) = riser(b(1.7), 0.07, f0: 400, f1: 9000)
fx.addSt(r1L, r1R, at: b(14.3), gain: 1)

// ---------------------------------------------------------------- b16: the drop; the shuffle; the verbs
let (c1L, c1R) = crash(0.4)
fx.addSt(c1L, c1R, at: b(16), gain: 1); fx.add(boom(1), at: b(16), gain: 0.32)
for s in 0..<4 {                                                  // a paper flick per card shuffled
	let t = b(17 + Double(s)), n = Int(SR * 0.09)
	var o = [Float](repeating: 0, count: n); var bp = SVF()
	for i in 0..<n { let x = Double(i) / SR; o[i] = Float(bp.step(rnd(), 2800 + 9000 * x, 1.1).bp * exp(-x / 0.03) * min(1, x / 0.004) * 1.2) }
	fx.add(o, at: t, gain: 0.08, pan: 0.3 - 0.1 * Double(s))
}
let (c2L, c2R) = crash(0.26)
fx.addSt(c2L, c2R, at: b(24), gain: 1)
let (c3L, c3R) = crash(0.3)
fx.addSt(c3L, c3R, at: b(32), gain: 1)

// ---------------------------------------------------------------- b40: the gather and the lockup
lowpassSweep(&mel, b(40), WORD_T - 0.01, 4200, 650)
let (r3L, r3R) = riser(WORD_T - b(40) - 0.02, 0.075, f0: 300, f1: 9500)
fx.addSt(r3L, r3R, at: b(40), gain: 1)
let revC2 = reversed(crash(0.32))
fx.addSt(revC2.0, revC2.1, at: WORD_T - Double(revC2.0.count) / SR, gain: 0.45)
fx.add(boom(1), at: WORD_T, gain: 0.34)
let (c4L, c4R) = crash(0.3)
fx.addSt(c4L, c4R, at: WORD_T, gain: 1)
let subName = KIT == "longing" ? "Longing_Bass" : (KIT == "fullmoon" ? "Full_Moon_Sub_Bass" : "Yearning_Sub_Bass")
layer(loadLoop(subName, beats: KIT == "fullmoon" ? 32 : 16), WORD_T, T_END, 0.5, into: &bass)    // the sub comes back under the lockup

// ---------------------------------------------------------------- mix
highpass(&mel, 90); highpass(&intro, 60)
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
highpass(&rev, 200)
var music = Bus(NS)
music.mix(intro, 1.0); music.mix(drums, 1.0); music.mix(bass, 1.0); music.mix(mel, 1.0); music.mix(fx, 1.0); music.mix(cut, 0.9); music.mix(rev, 0.9)
highpass(&music, 28)
compress(&music, thr: -14, ratio: 2.0, att: 0.008, rel: 0.2)
let fadeA = Int((T_STILL - 0.1) * SR), fadeZ = Int((T_END - 0.1) * SR)
for i in fadeA..<NS {
	let kk = i >= fadeZ ? Float(0) : Float(1 - Double(i - fadeA) / Double(fadeZ - fadeA))
	music.L[i] *= kk * kk; music.R[i] *= kk * kk
}
limit(&music, ceiling: 0.89)
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav("mix_\(KIT)", music)
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(music.L[i]), abs(music.R[i])) }
print(String(format: "%@ BPM %.0f, %.2fs, peak %.2f dBFS", KIT as NSString, BPM, T_END, 20 * log10(Double(pk))))
