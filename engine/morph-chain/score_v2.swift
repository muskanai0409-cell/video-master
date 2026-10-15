// score_v2.swift: the local v0.0.9 score, v2 (Oct 14). Her note on v1 (Rise Up): "make the song better beats from some
// don toliver song but dont make it same like before and make the overall sounds betetr".
// Never his song, melody or voice (copyright, mute risk): an original in that lane, built from GarageBand's recorded
// Apple Loops (prep_loops.py stretches them to 81 BPM; the film counts at 162), with a producer's mix chain. Three
// versions, KIT=legend | trap | sympathy:
//  legend    dark and spacey (C minor): the Legend kit's beat, sub bass (saturated, so phones can hear it), dark pad,
//            FX pad, drone and lead, with a ping-pong delay and a hall on the lead
//  trap      the same harmony on the Sophistication beat (the most hat rolls in the library), plus an 808 that follows
//            every kick and glides between notes, the lane's signature
//  sympathy  melodic R&B (E minor): the Sympathy kit's beat, bass, piano, synth and lead, with the Caution beat's hat
//            rolls on top in the full section
// Every version: a hazy intro with the beat muffled under it, half a beat of silence, ENTER alone, then the drop on b8;
// a build with the kick filtered out into b32; a breakdown from b40; half a beat of silence; the lockup hit on b48.
// Licence: the GarageBand licence lets us use its loops "on a royalty-free basis, to create your own original
// soundtracks for your video and audio projects". The decoded loops stay in ~/Library/Caches/video-master, never in the repo.
import Foundation

let ENVV = ProcessInfo.processInfo.environment
let KIT = ENVV["KIT"] ?? "legend"
let LOOPDIR = ENVV["LOOPDIR"] ?? ""

var drums = Bus(NS), hats = Bus(NS), bass = Bus(NS), b808 = Bus(NS), pads = Bus(NS), lead = Bus(NS), keys = Bus(NS)
var prev = Bus(NS), fx = Bus(NS), sfx = Bus(NS), revSend = Bus(NS), dlySend = Bus(NS)

// ---------------------------------------------------------------- loops (already 81 BPM, seamless; aligned to t = 0)
struct Loop { let L: [Float]; let R: [Float]; let len: Int }
func loadLoop(_ name: String) -> Loop {
	let d = try! Data(contentsOf: URL(fileURLWithPath: LOOPDIR + "/" + name + ".f32"))
	let f: [Float] = d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
	let n = f.count / 2
	var L = [Float](repeating: 0, count: n), R = L
	for i in 0..<n { L[i] = f[2 * i]; R[i] = f[2 * i + 1] }
	return Loop(L: L, R: R, len: n)
}
func hits(_ name: String) -> (kicks: [Double], snares: [Double]) {
	let s = (try? String(contentsOfFile: LOOPDIR + "/" + name + ".hits", encoding: .utf8)) ?? ""
	var k: [Double] = [], sn: [Double] = []
	for line in s.split(separator: "\n") {
		let parts = line.split(separator: ":")
		let v = parts.count > 1 ? parts[1].split(separator: " ").compactMap { Double($0) } : []
		if parts.first == "kicks" { k = v } else if parts.first == "snares" { sn = v }
	}
	return (k, sn)
}
func layer(_ lp: Loop, _ t0: Double, _ t1: Double, _ g: Double, into b: inout Bus, fadeIn: Double = 0.006, fadeOut: Double = 0.03, rev: Double = 0, dly: Double = 0) {
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
		if dly > 0 { dlySend.L[i] += lp.L[j] * e * Float(dly); dlySend.R[i] += lp.R[j] * e * Float(dly) }
	}
}

// ---------------------------------------------------------------- the mix tools
/// RBJ biquad, run over a whole bus (or a span)
struct Biquad {
	var b0 = 1.0, b1 = 0.0, b2 = 0.0, a1 = 0.0, a2 = 0.0
	init(_ kind: String, _ f: Double, _ q: Double, _ db: Double) {
		let A = pow(10, db / 40), w = 2 * Double.pi * f / SR, cw = cos(w), sw = sin(w)
		var a0 = 1.0
		switch kind {
		case "peak":
			let al = sw / (2 * q)
			b0 = 1 + al * A; b1 = -2 * cw; b2 = 1 - al * A; a0 = 1 + al / A; a1 = -2 * cw; a2 = 1 - al / A
		case "high":
			let al = sw / 2 * sqrt((A + 1 / A) * (1 / q - 1) + 2), sa = 2 * sqrt(A) * al
			b0 = A * ((A + 1) + (A - 1) * cw + sa); b1 = -2 * A * ((A - 1) + (A + 1) * cw); b2 = A * ((A + 1) + (A - 1) * cw - sa)
			a0 = (A + 1) - (A - 1) * cw + sa; a1 = 2 * ((A - 1) - (A + 1) * cw); a2 = (A + 1) - (A - 1) * cw - sa
		default:   // "low" shelf
			let al = sw / 2 * sqrt((A + 1 / A) * (1 / q - 1) + 2), sa = 2 * sqrt(A) * al
			b0 = A * ((A + 1) - (A - 1) * cw + sa); b1 = 2 * A * ((A - 1) - (A + 1) * cw); b2 = A * ((A + 1) - (A - 1) * cw - sa)
			a0 = (A + 1) + (A - 1) * cw + sa; a1 = -2 * ((A - 1) + (A + 1) * cw); a2 = (A + 1) + (A - 1) * cw - sa
		}
		b0 /= a0; b1 /= a0; b2 /= a0; a1 /= a0; a2 /= a0
	}
	func run(_ b: inout Bus) {
		for ch in 0..<2 {
			var x1 = 0.0, x2 = 0.0, y1 = 0.0, y2 = 0.0
			for i in 0..<b.L.count {
				let x = Double(ch == 0 ? b.L[i] : b.R[i])
				let y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
				x2 = x1; x1 = x; y2 = y1; y1 = y
				if ch == 0 { b.L[i] = Float(y) } else { b.R[i] = Float(y) }
			}
		}
	}
}
func eq(_ b: inout Bus, _ kind: String, _ f: Double, _ q: Double, _ db: Double) { Biquad(kind, f, q, db).run(&b) }
/// tape-style saturation: harmonics that let a sub bass speak on phone and laptop speakers
func saturate(_ b: inout Bus, drive: Double, mix: Double) {
	let k = Float(tanh(drive)), d = Float(drive), m = Float(mix)
	for i in 0..<b.L.count {
		b.L[i] = b.L[i] * (1 - m) + tanh(b.L[i] * d) / k * m
		b.R[i] = b.R[i] * (1 - m) + tanh(b.R[i] * d) / k * m
	}
}
func mono(_ b: inout Bus) { for i in 0..<b.L.count { let m = (b.L[i] + b.R[i]) * 0.5; b.L[i] = m; b.R[i] = m } }
/// mid/side width (bass stays mono elsewhere)
func widen(_ b: inout Bus, _ w: Float) {
	for i in 0..<b.L.count { let m = (b.L[i] + b.R[i]) * 0.5, s = (b.L[i] - b.R[i]) * 0.5 * w; b.L[i] = m + s; b.R[i] = m - s }
}
func lowpassSpan(_ b: inout Bus, _ t0: Double, _ t1: Double, _ fc: Double) { lowpassSweep(&b, t0, t1, fc, fc) }
/// a high-pass over a span: the build takes the kick out of the beat
func highpassSpan(_ b: inout Bus, _ t0: Double, _ t1: Double, _ fc: Double) {
	var fl = SVF(), fr = SVF()
	let a = Int(t0 * SR), z = min(b.L.count, Int(t1 * SR)), ramp = Int(0.02 * SR)
	for i in a..<z {
		let hl = Float(fl.step(Double(b.L[i]), fc, 0.7).hp), hr = Float(fr.step(Double(b.R[i]), fc, 0.7).hp)
		let k = Float(min(1, Double(min(i - a, z - i)) / Double(ramp)))
		b.L[i] += (hl - b.L[i]) * k; b.R[i] += (hr - b.R[i]) * k
	}
}
/// parallel compression: a crushed copy under the dry drums
func parallel(_ b: inout Bus, mixIn: Double) {
	var c = b
	compress(&c, thr: -26, ratio: 6, att: 0.002, rel: 0.09)
	b.mix(c, mixIn)
}

/// an 808 as producers use it: a sine with a click of pitch at the attack, a long natural decay, an optional glide in
/// from the previous note, a little drive
func eight08(_ m: Double, _ dur: Double, from: Double?, glide: Double) -> [Float] {
	let n = Int(SR * (dur + 0.04))
	var o = [Float](repeating: 0, count: n), ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		var mm = m
		if let f0 = from { mm = m + (f0 - m) * exp(-t / (glide / 3)) }
		ph += 2 * Double.pi * mtof(mm) * (1 + 0.5 * exp(-t / 0.008)) / SR
		let env = min(1, t / 0.002) * exp(-t / 0.75) * (t < dur ? 1 : exp(-(t - dur) / 0.025))
		o[i] = Float(tanh(2.0 * sin(ph) * env) / tanh(2.0))
	}
	return o
}

// ---------------------------------------------------------------- the kits
let FB = BEAT                                                 // one film beat
var kickSrc: [Double] = []                                    // the beat's kicks, in film beats inside its 64-beat cycle
var root = 0                                                  // the key's root (pitch class), for the tuned effects
var playKick = [(Double, Double)]()                           // where the beat actually plays (for the sidechain)

func ar(_ name: String) -> Loop { loadLoop(name) }
switch KIT {
case "sympathy":                                              // E minor, melodic R&B
	root = 4
	let BEATL = ar("Sympathy_Beat"), BASSL = ar("Sympathy_Bass"), PIANO = ar("Sympathy_Piano"), SYN = ar("Sympathy_Synth"), LEADL = ar("Sympathy_Lead"), XH = ar("Caution_Beat")
	kickSrc = hits("Sympathy_Beat").kicks
	layer(PIANO, 0, b(7.5), 0.5, into: &keys, fadeIn: 0.004, rev: 0.25)
	layer(BEATL, b(4), b(7.5), 0.5, into: &prev); layer(BASSL, b(4), b(7.5), 0.5, into: &prev)
	layer(BEATL, b(8), b(40), 0.72, into: &drums, fadeOut: 0.01)
	layer(BASSL, b(8), b(40), 0.34, into: &bass)
	layer(PIANO, b(8), b(16), 0.4, into: &keys, rev: 0.16); layer(PIANO, b(24), b(47.5), 0.4, into: &keys, rev: 0.16)
	layer(SYN, b(8), b(24), 0.34, into: &pads, rev: 0.2); layer(SYN, b(32), b(47.5), 0.34, into: &pads, rev: 0.2)
	layer(LEADL, b(16), b(40), 0.36, into: &lead, rev: 0.2, dly: 0.3)
	layer(XH, b(32), b(40), 0.5, into: &hats, fadeOut: 0.01)
	layer(BEATL, WORD_T, T_END, 0.62, into: &drums, fadeIn: 0.002); layer(BASSL, WORD_T, T_END, 0.32, into: &bass, fadeIn: 0.002)
	layer(PIANO, WORD_T, T_END, 0.4, into: &keys, fadeIn: 0.002, rev: 0.25); layer(LEADL, WORD_T, T_END, 0.32, into: &lead, fadeIn: 0.002, rev: 0.25, dly: 0.3)
	playKick = [(b(8), b(40)), (WORD_T, T_END)]
default:                                                      // "legend" and "trap": C minor, dark and spacey
	root = 0
	let trap = KIT == "trap"
	let beatName = trap ? "Sophistication_Beat" : "Legend_Beat"
	let BEATL = ar(beatName), SUB = ar("Legend_Sub_Bass"), DARK = ar("Legend_Dark_Synth_Pad"), FXP = ar("Legend_FX_Synth_Pad")
	let DRONE = ar("Legend_Synth_Drone"), LEADL = ar("Legend_Synth_Lead")
	kickSrc = hits(beatName).kicks
	layer(DARK, 0, b(7.5), 0.55, into: &pads, fadeIn: 0.004, rev: 0.3)
	layer(DRONE, b(2), b(7.5), 0.32, into: &pads, fadeIn: 0.3, rev: 0.3)
	layer(BEATL, b(4), b(7.5), 0.5, into: &prev); layer(SUB, b(4), b(7.5), 0.5, into: &prev)
	layer(BEATL, b(8), b(40), 0.72, into: &drums, fadeOut: 0.01)
	layer(SUB, b(8), b(40), trap ? 0.08 : 0.3, into: &bass)
	layer(DARK, b(8), b(40), 0.36, into: &pads, rev: 0.22)
	layer(FXP, b(8), b(16), 0.3, into: &pads, rev: 0.25); layer(FXP, b(24), b(40), 0.3, into: &pads, rev: 0.25)
	layer(LEADL, b(16), b(40), 0.36, into: &lead, rev: trap ? 0.3 : 0.24, dly: trap ? 0.42 : 0.3)
	layer(DRONE, b(24), b(40), 0.26, into: &pads, rev: 0.3)
	layer(DARK, b(40), b(47.5), 0.42, into: &pads, rev: 0.35); layer(DRONE, b(40), b(47.5), 0.3, into: &pads, rev: 0.35)
	layer(LEADL, b(40), b(47.5), 0.3, into: &lead, rev: 0.35, dly: 0.45)
	layer(BEATL, WORD_T, T_END, 0.64, into: &drums, fadeIn: 0.002); layer(SUB, WORD_T, T_END, trap ? 0.08 : 0.3, into: &bass, fadeIn: 0.002)
	layer(DARK, WORD_T, T_END, 0.36, into: &pads, fadeIn: 0.002, rev: 0.3); layer(LEADL, WORD_T, T_END, 0.3, into: &lead, fadeIn: 0.002, rev: 0.3, dly: 0.35)
	playKick = [(b(8), b(40)), (WORD_T, T_END)]
	if trap {
		// the 808: one hit per kick, held to the next, C2 over the C bars and Ab1 over the Ab bars (as the sub plays),
		// gliding in where the note changes
		func note(_ fb: Double) -> Double { Int(fb / 16) % 2 == 0 ? 36 : 32 }
		var last = 36.0
		for (t0, t1) in playKick {
			let k0 = Int(floor(t0 / FB / 64)), k1 = Int(ceil(t1 / FB / 64))
			var ks: [Double] = []
			for c in k0...k1 { for k in kickSrc { let fb = k + 64 * Double(c); if b(fb) >= t0 - 0.001 && b(fb) < t1 { ks.append(fb) } } }
			ks.sort()
			for (i, fb) in ks.enumerated() {
				let nx = i + 1 < ks.count ? ks[i + 1] : fb + 2
				let dur = min(b(nx - fb), b(2.5)) - 0.012
				let m = note(fb)
				b808.add(eight08(m, dur, from: m != last ? last : nil, glide: 0.09), at: b(fb), gain: 0.12)
				last = m
			}
		}
	}
}

// ---------------------------------------------------------------- transitions
// the hook: everything muffled ("from the next room") and opening up; half a beat of silence; ENTER; the drop
lowpassSpan(&prev, b(4), b(7.5), 330)
lowpassSweep(&pads, 0, b(7.5), 450, 3800); lowpassSweep(&keys, 0, b(7.5), 450, 3800)
let (r0L, r0R) = riser(b(3.3), 0.045, f0: 300, f1: 8000)
fx.addSt(r0L, r0R, at: b(4.2), gain: 1)
let rc0 = reversed(crash(0.3))
fx.addSt(rc0.0, rc0.1, at: b(7.5) - Double(rc0.0.count) / SR, gain: 0.3)
// the build into b32: the kick filtered out of the beat for two beats, a riser
highpassSpan(&drums, b(30), b(32), 260); highpassSpan(&bass, b(30), b(32), 2000); highpassSpan(&b808, b(30), b(32), 2000)
let (r1L, r1R) = riser(b(2), 0.05, f0: 400, f1: 9000)
fx.addSt(r1L, r1R, at: b(30), gain: 1)
// the breakdown: the drums drop out at b40, the music closes down, a riser, half a beat of silence, the hit on b48
lowpassSweep(&pads, b(40), b(47.5), 6000, 650); lowpassSweep(&lead, b(40), b(47.5), 6000, 650); lowpassSweep(&keys, b(40), b(47.5), 6000, 650)
let (r2L, r2R) = riser(b(6.8), 0.055, f0: 250, f1: 9500)
fx.addSt(r2L, r2R, at: b(40.6), gain: 1)
let rc1 = reversed(crash(0.32))
fx.addSt(rc1.0, rc1.1, at: b(47.5) - Double(rc1.0.count) / SR, gain: 0.4)

// ---------------------------------------------------------------- effects (each has a cause on screen), tuned to the key
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
let R0 = Double(root)
let PENT: [Double] = [0, 3, 5, 7, 10]                                   // minor pentatonic
func pent(_ k: Int) -> Double { let o = Int(floor(Double(k) / 5)); return 72 + R0 + 12 * Double(o) + PENT[((k % 5) + 5) % 5] }
let CLICK2 = sample("click_002"), CLICK3 = sample("click_003"), CLICK5 = sample("click_005")
let KEYS = ["switch12", "switch13", "switch14"].map { sample($0) }
fxs(bell(84 + R0, 1, decay: 0.5), T_SOLID + 0.02, 0.1, pan: -0.1, rev: 0.35); fxs(bell(91 + R0, 1, decay: 0.45), T_SOLID + 0.05, 0.07, pan: 0.15, rev: 0.35)
fxs(pop(79 + R0, 1), T_CHIP + 0.01, 0.26); fxs(CLICK3, T_CHIP, 0.16)
for j in 0..<TYPED.count {
	let tt = T_TYPE0 + Double(j) * TYPE_DT
	fxs(KEYS[Int(abs(rnd()) * 2.999)], tt, 0.3 + 0.05 * rnd(), pan: -0.15 + 0.3 * Double(j) / Double(TYPED.count), rev: 0.04)
}
fxs(KEYS[1], T_ENTER - 0.006, 0.85, rev: 0.08)                          // ENTER, alone in the half beat of silence
let (c1L, c1R) = crash(0.38)
fx.addSt(c1L, c1R, at: T_ENTER, gain: 1); fx.add(thump(1), at: T_ENTER, gain: 0.5)
let (c2L, c2R) = crash(0.2)
fx.addSt(c2L, c2R, at: T_V5, gain: 1)
fxs(pop(84 + R0, 1), T_RESULT + 0.02, 0.36, pan: 0.1); fxs(bell(91 + R0, 1, decay: 0.35), T_RESULT + 0.05, 0.09, rev: 0.3)
let (c3L, c3R) = crash(0.2)
fx.addSt(c3L, c3R, at: T_SEC, gain: 1)
fxs(CLICK5, T_401 - 0.004, 0.62, pan: -0.2); fxs(KEYS[0], T_401 + 0.012, 0.44, pan: -0.2)
fxs(CLICK2, T_AUTH + 0.05, 0.3)
fxs(CLICK3, T_200 - 0.004, 0.5, pan: -0.2); fxs(pop(91 + R0, 1), T_200 + 0.03, 0.32, pan: -0.2)
let (c4L, c4R) = crash(0.34)
fx.addSt(c4L, c4R, at: T_SPD, gain: 1)
for i in 0..<10 { fxs(CLICK2, sliceT0(i), 0.12 + 0.015 * Double(i % 3), pan: -0.5 + 0.11 * Double(i), rev: 0.06) }
for (k, i) in DISSOLVE_ORDER.enumerated() {
	if let td = dissolveT(i) { fxs(pop(pent(9 - k), 1), td + 0.01, 0.3 - 0.01 * Double(k), pan: i < 5 ? -0.35 : 0.35, rev: 0.3) }
}
fxs(bell(72 + R0, 1, decay: 0.6), T_MARK + 0.02, 0.12, rev: 0.35)
let (c5L, c5R) = crash(0.36)
fx.addSt(c5L, c5R, at: WORD_T, gain: 1); fx.add(thump(1), at: WORD_T, gain: 0.48)
fxs(bell(84 + R0, 1, decay: 0.8), WORD_T + 0.02, 0.15, pan: -0.1, rev: 0.4); fxs(bell(87 + R0, 1, decay: 0.8), WORD_T + 0.05, 0.12, pan: 0.1, rev: 0.4)
fxs(CLICK3, T_CMD, 0.28)

// ---------------------------------------------------------------- the mix
// drums: parallel compression for punch, a little air; extra hats high-passed so only the rolls come through
if KIT == "trap" { highpass(&drums, 95) }          // the beat's own boom out: the tuned 808 owns the low end
parallel(&drums, mixIn: 0.4)
eq(&drums, "high", 8000, 0.7, KIT == "trap" ? 5.0 : 3.0); eq(&drums, "peak", 250, 1.0, -2)
highpass(&hats, 6500); eq(&hats, "high", 10000, 0.7, 2)
// bass: saturated (phones can't play 30-60 Hz; the harmonics can), mono, then the 808 the same way
highpass(&bass, 38); saturate(&bass, drive: 3.0, mix: 0.9); mono(&bass); eq(&bass, "peak", 120, 0.9, 3.5); highpass(&bass, 32)
highpass(&b808, 34); saturate(&b808, drive: 1.8, mix: 0.8); mono(&b808); eq(&b808, "peak", 130, 0.9, 2.5)
// music: out of the bass's way, a dip in the mud, air on top, wider, breathing with the kick
var music = Bus(NS)
music.mix(pads, 1); music.mix(lead, 1); music.mix(keys, 1)
highpass(&music, 140)
eq(&music, "peak", 320, 0.9, -3); eq(&music, "high", 8000, 0.7, 2.5)
widen(&music, 1.35)
KICKS = []
for (t0, t1) in playKick {
	let k0 = Int(floor(t0 / FB / 64)), k1 = Int(ceil(t1 / FB / 64))
	for c in k0...k1 { for k in kickSrc { let t = b(k + 64 * Double(c)); if t >= t0 - 0.001 && t < t1 { KICKS.append(t) } } }
}
duck(&music, depth: 0.38, rel: 0.12)
duck(&bass, depth: KIT == "trap" ? 0.5 : 0.2, rel: 0.1)
// the hook's muffled beat stays mono and low
mono(&prev)
// sends: a dotted-eighth ping-pong (one and a half film beats) and a hall
let (dL, dR) = pingpong(dlySend.L, dlySend.R, time: b(1.5), fb: 0.38)
var dly = Bus(NS); dly.L = dL; dly.R = dR
highpass(&dly, 300); eq(&dly, "high", 6000, 0.7, -4)
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
highpass(&rev, 250)
// the half beats of silence before ENTER and before the lockup (the sends ring through, as a room would)
for (t0, t1) in [(b(7.5), b(8)), (b(47.5), b(48))] {
	drums.gate(t0, t1); hats.gate(t0, t1); bass.gate(t0, t1); b808.gate(t0, t1); music.gate(t0, t1); prev.gate(t0, t1)
}
var mixBus = Bus(NS)
mixBus.mix(drums, 1.0); mixBus.mix(hats, 0.9); mixBus.mix(bass, 1.0); mixBus.mix(b808, 1.0); mixBus.mix(music, 1.35)
mixBus.mix(prev, 0.42); mixBus.mix(fx, 1.0); mixBus.mix(rev, 0.85); mixBus.mix(dly, 0.6)
highpass(&mixBus, 25)
compress(&mixBus, thr: -13, ratio: 2.0, att: 0.01, rel: 0.15)        // glue
if ENVV["NOSFX"] == nil { mixBus.mix(sfx, 1.0) }                        // effects ride over the glue
saturate(&mixBus, drive: 1.15, mix: 0.5)
let fadeA = Int((T_STILL - 0.1) * SR), fadeZ = Int((T_END - 0.1) * SR)
for i in fadeA..<NS {
	let kk = i >= fadeZ ? Float(0) : Float(1 - Double(i - fadeA) / Double(fadeZ - fadeA))
	mixBus.L[i] *= kk * kk; mixBus.R[i] *= kk * kk
}
limit(&mixBus, ceiling: 0.74)
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav(ENVV["NOSFX"] == nil ? "mix_v2_\(KIT)" : "mix_v2_\(KIT)_nosfx", mixBus)
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(mixBus.L[i]), abs(mixBus.R[i])) }
print(String(format: "v2 %@, BPM %.0f, %.2fs, peak %.2f dBFS, %d kicks in the sidechain", KIT as NSString, BPM, T_END, 20 * log10(Double(pk)), KICKS.count))
