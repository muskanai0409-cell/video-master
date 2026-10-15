// score_loops.swift: the local v0.0.9 score, arranged from GarageBand's "Rise Up" kit (01 Hip Hop, C major, 81 BPM) on
// the picture's beat grid (162 BPM), plus physical effects that each have a cause on screen.
// Licence: the GarageBand licence (/Applications/GarageBand.app/Contents/Resources/GarageBand License Agreement.pdf)
// lets us use its loops "on a royalty-free basis, to create your own original soundtracks for your video and audio
// projects" and to "broadcast and/or distribute" those soundtracks. The loops themselves are never shipped on their own.
// The decoded loops live in ~/Library/Caches/video-master, not in the repo.
//
// The kit runs at half the film's BPM, so each 8-beat section is one bar of the kit; the loops are aligned to t = 0.
//  S0 b0-8    the hook: piano alone, filtered and opening up; a bell dyad on the solid version, typing, a riser
//  S1 b8-16   ENTER on the drop: drums, bass, piano, plucks, the organ's phrase
//  S2 b16-24  api v5: strings and brass come in
//  S3 b24-32  security: plucks back, the kit's own FX riser climbing into b32
//  S4 b32-40  speed: everything
//  S5 b40-48  next: the drums drop out; nine tuned pops as the squares fall away; the organ phrase again, closing down
//  S6 b48-    the lockup: the hit, a bell dyad, the kit back for one breath, then the fade into the still
import Foundation

let ENVV = ProcessInfo.processInfo.environment
let LOOPDIR = ENVV["LOOPDIR"] ?? ""
let PRIME = 2112.0 / 44100.0                                     // AAC priming at the head of every decoded loop

var drums = Bus(NS), bass = Bus(NS), mel = Bus(NS), intro = Bus(NS), fx = Bus(NS), sfx = Bus(NS), revSend = Bus(NS)

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
let PIANO = loadLoop("Rise_Up_Piano", beats: 16), BASS = loadLoop("Rise_Up_Bass", beats: 16), BEATL = loadLoop("Rise_Up_Beat", beats: 16)
let PLUCKS = loadLoop("Rise_Up_Plucks", beats: 16), ORGAN = loadLoop("Rise_Up_Organ", beats: 16)
let STRINGS = loadLoop("Rise_Up_Strings_and_Brass", beats: 16), KITFX = loadLoop("Rise_Up_FX", beats: 16)

// ---------------------------------------------------------------- the arrangement
layer(PIANO, 0, b(8), 0.5, into: &intro, fadeIn: 0.004, rev: 0.16)                      // S0: piano alone
layer(PIANO, b(8), b(48) - 0.02, 0.4, into: &mel, rev: 0.12)
layer(BEATL, b(8), b(40), 0.62, into: &drums, fadeOut: 0.02, rev: 0.04)
layer(BASS, b(8), b(40), 0.5, into: &bass)
layer(PLUCKS, b(8), b(16), 0.3, into: &mel, rev: 0.14)
layer(PLUCKS, b(24), b(40), 0.3, into: &mel, rev: 0.14)
layer(ORGAN, b(8), b(24), 0.42, into: &mel, rev: 0.12)                                  // the organ's phrase (loop beats 8-24)
layer(STRINGS, b(16), b(40), 0.36, into: &mel, rev: 0.12)
layer(KITFX, b(24), b(40), 0.5, into: &fx, rev: 0.2)                                    // its riser climbs into b32
layer(ORGAN, b(40), b(48) - 0.02, 0.38, into: &mel, fadeOut: 0.1, rev: 0.2)             // S5: the breakdown
layer(STRINGS, b(40), b(48) - 0.02, 0.3, into: &mel, fadeOut: 0.1, rev: 0.2)
// S6: the kit back for one breath under the lockup (b48 is a downbeat of the loop), then the fade
layer(BEATL, WORD_T, T_END, 0.5, into: &drums, fadeIn: 0.002, fadeOut: 0.02, rev: 0.04)
layer(BASS, WORD_T, T_END, 0.46, into: &bass, fadeIn: 0.002)
layer(STRINGS, WORD_T, T_END, 0.34, into: &mel, fadeIn: 0.002, rev: 0.2)
layer(PIANO, WORD_T, T_END, 0.36, into: &mel, fadeIn: 0.002, rev: 0.2)

// the hook opens up; the breakdown closes down
lowpassSweep(&intro, 0, b(7.6), 500, 4200)
lowpassSweep(&mel, b(40), WORD_T - 0.02, 5000, 700)
let (r0L, r0R) = riser(b(3.4), 0.05, f0: 300, f1: 7500)
fx.addSt(r0L, r0R, at: b(4.6), gain: 1)
let rc0 = reversed(crash(0.35))
fx.addSt(rc0.0, rc0.1, at: T_ENTER - Double(rc0.0.count) / SR, gain: 0.32)
let (r1L, r1R) = riser(b(7.6), 0.06, f0: 250, f1: 9000)
fx.addSt(r1L, r1R, at: b(40.3), gain: 1)
let rc1 = reversed(crash(0.32))
fx.addSt(rc1.0, rc1.1, at: WORD_T - Double(rc1.0.count) / SR, gain: 0.42)

// ---------------------------------------------------------------- effects (each has a cause on screen)
func pop(_ m: Double, _ g: Double) -> [Float] {
	let f = mtof(m), n = Int(SR * 0.14); var o = [Float](repeating: 0, count: n); var ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * f * (0.72 + 0.36 * min(1, t / 0.025)) / SR
		o[i] = Float((sin(ph) + 0.22 * sin(2 * ph)) * min(1, t / 0.001) * exp(-t / 0.045) * g)
	}
	return o
}
func fxs(_ x: [Float], _ t: Double, _ g: Double, pan: Double = 0, rev: Double = 0.12) {
	sfx.add(x, at: t, gain: g, pan: pan); revSend.add(x, at: t, gain: g * rev)
}
let CLICK2 = sample("click_002"), CLICK3 = sample("click_003"), CLICK5 = sample("click_005")
let KEYS = ["switch12", "switch13", "switch14"].map { sample($0) }
// the hook: the version goes solid (a bell dyad, C and G), the prompt chip pops
fxs(bell(84, 1, decay: 0.5), T_SOLID + 0.02, 0.1, pan: -0.1, rev: 0.3); fxs(bell(91, 1, decay: 0.45), T_SOLID + 0.05, 0.07, pan: 0.15, rev: 0.3)
fxs(pop(79, 1), T_CHIP + 0.01, 0.26); fxs(CLICK3, T_CHIP, 0.16)
// typing, one key per character, then ENTER on the drop (a felt thump, the first of two)
for j in 0..<TYPED.count {
	let tt = T_TYPE0 + Double(j) * TYPE_DT
	fxs(KEYS[Int(abs(rnd()) * 2.999)], tt, 0.3 + 0.05 * rnd(), pan: -0.15 + 0.3 * Double(j) / Double(TYPED.count), rev: 0.04)
}
fxs(KEYS[1], T_ENTER - 0.006, 0.85, rev: 0.05)
let (c1L, c1R) = crash(0.38)
fx.addSt(c1L, c1R, at: T_ENTER, gain: 1); fx.add(thump(1), at: T_ENTER, gain: 0.5)
// api v5: a light crash on the morph; the memory comes back with a pop
let (c2L, c2R) = crash(0.22)
fx.addSt(c2L, c2R, at: T_V5, gain: 1)
fxs(pop(84, 1), T_RESULT + 0.02, 0.36, pan: 0.1); fxs(bell(88, 1, decay: 0.35), T_RESULT + 0.05, 0.09, rev: 0.25)
// security: the lock clacks shut on the 401; the key row; the lock opens on the 200
let (c3L, c3R) = crash(0.22)
fx.addSt(c3L, c3R, at: T_SEC, gain: 1)
fxs(CLICK5, T_401 - 0.004, 0.62, pan: -0.2); fxs(KEYS[0], T_401 + 0.012, 0.44, pan: -0.2)
fxs(CLICK2, T_AUTH + 0.05, 0.3)
fxs(CLICK3, T_200 - 0.004, 0.5, pan: -0.2); fxs(pop(88, 1), T_200 + 0.03, 0.32, pan: -0.2)
// speed: the full kit lands with a crash
let (c4L, c4R) = crash(0.32)
fx.addSt(c4L, c4R, at: T_SPD, gain: 1)
// next: the card is cut into ten (ten soft clicks), then nine squares fall back into the lattice, a descending run in
// C major pentatonic, as the drums drop out
for i in 0..<10 { fxs(CLICK2, sliceT0(i), 0.12 + 0.015 * Double(i % 3), pan: -0.5 + 0.11 * Double(i), rev: 0.06) }
let RUN: [Double] = [93, 91, 88, 86, 84, 81, 79, 76, 74]
for (k, i) in DISSOLVE_ORDER.enumerated() {
	if let td = dissolveT(i) { fxs(pop(RUN[k], 1), td + 0.01, 0.3 - 0.01 * Double(k), pan: i < 5 ? -0.35 : 0.35, rev: 0.22) }
}
fxs(bell(72, 1, decay: 0.6), T_MARK + 0.02, 0.12, rev: 0.3)                             // the last square becomes the mark
// the lockup: the hit (the second felt thump), a bell dyad (C and E), the command chip
let (c5L, c5R) = crash(0.36)
fx.addSt(c5L, c5R, at: WORD_T, gain: 1); fx.add(thump(1), at: WORD_T, gain: 0.48)
fxs(bell(84, 1, decay: 0.8), WORD_T + 0.02, 0.15, pan: -0.1, rev: 0.35); fxs(bell(88, 1, decay: 0.8), WORD_T + 0.05, 0.12, pan: 0.1, rev: 0.35)
fxs(CLICK3, T_CMD, 0.28)

// ---------------------------------------------------------------- mix
highpass(&mel, 90); highpass(&intro, 60); highpass(&sfx, 120)
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
highpass(&rev, 200)
var music = Bus(NS)
music.mix(intro, 1.0); music.mix(drums, 1.0); music.mix(bass, 1.0); music.mix(mel, 1.0); music.mix(fx, 1.0); music.mix(rev, 0.9)
highpass(&music, 28)
compress(&music, thr: -14, ratio: 2.0, att: 0.008, rel: 0.2)
if ENVV["NOSFX"] == nil { music.mix(sfx, 1.0) }                                           // effects ride over the bus compressor
let fadeA = Int((T_STILL - 0.1) * SR), fadeZ = Int((T_END - 0.1) * SR)
for i in fadeA..<NS {
	let kk = i >= fadeZ ? Float(0) : Float(1 - Double(i - fadeA) / Double(fadeZ - fadeA))
	music.L[i] *= kk * kk; music.R[i] *= kk * kk
}
limit(&music, ceiling: 0.74)
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav(ENVV["NOSFX"] == nil ? "mix_riseup" : "mix_riseup_nosfx", music)
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(music.L[i]), abs(music.R[i])) }
print(String(format: "rise up, BPM %.0f, %.2fs, peak %.2f dBFS", BPM, T_END, 20 * log10(Double(pk))))
