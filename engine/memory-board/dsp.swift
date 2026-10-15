// dsp.swift: the synth voices and effects (shared with the plugins film, copied unchanged).
// Everything is synthesised (no stock music, no generative audio model) except the keyboard and mouse clicks, which
// are real CC0 recordings (Kenney UI SFX, sfx/KENNEY_LICENSE.txt). The drum, pad, stab, pluck, reverb and mix code
// comes from the one-command film (one-command-v2-src/snd.swift); the 808 glide, the formant vocal chop, the clap,
// the squeak and the liquid-glass effects (bubble, gulp, boing, slosh) are new for this film.
//
// Build: see make_audio.sh (cat timeline.swift dsp.swift score.swift > snd.swift).

import Foundation

let SR = 48000.0
let NS = Int(SR * T_END)
let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let S16 = BEAT / 4

// ================================================================ basics
var rs: UInt64 = 0x2545F4914F6CDD1D
@inline(__always) func rnd() -> Double {
	rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17
	return Double(rs >> 11) / 4503599627370496.0 - 1.0
}
func mtof(_ m: Double) -> Double { 440 * pow(2, (m - 69) / 12) }
func cents(_ c: Double) -> Double { pow(2, c / 1200) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func smooth(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }

struct Bus {
	var L: [Float], R: [Float]
	init(_ n: Int) { L = [Float](repeating: 0, count: n); R = [Float](repeating: 0, count: n) }
	mutating func add(_ x: [Float], at t: Double, gain: Double, pan: Double = 0) {
		let s0 = Int((t * SR).rounded())
		let a = (pan + 1) * Double.pi / 4
		let gl = Float(gain * cos(a) * sqrt(2.0)), gr = Float(gain * sin(a) * sqrt(2.0))
		for i in 0..<x.count {
			let j = s0 + i
			if j < 0 { continue }
			if j >= L.count { break }
			L[j] += x[i] * gl; R[j] += x[i] * gr
		}
	}
	mutating func addSt(_ l: [Float], _ r: [Float], at t: Double, gain: Double) {
		let s0 = Int((t * SR).rounded()), g = Float(gain)
		for i in 0..<l.count {
			let j = s0 + i
			if j < 0 { continue }
			if j >= L.count { break }
			L[j] += l[i] * g; R[j] += r[i] * g
		}
	}
	mutating func mix(_ o: Bus, _ g: Double) {
		let gg = Float(g)
		for i in 0..<L.count { L[i] += o.L[i] * gg; R[i] += o.R[i] * gg }
	}
	/// Silence a span with short fades at both ends.
	mutating func gate(_ t0: Double, _ t1: Double, fade: Double = 0.006) {
		let a = Int(t0 * SR), b = Int(t1 * SR), f = Int(fade * SR)
		for i in max(0, a - f)..<min(L.count, b + f) {
			var g: Float = 0
			if i < a { g = Float(a - i) / Float(f) } else if i >= b { g = Float(i - b) / Float(f) }
			L[i] *= g; R[i] *= g
		}
	}
}

/// Zavalishin / Simper trapezoidal state-variable filter.
struct SVF {
	var ic1 = 0.0, ic2 = 0.0
	@inline(__always) mutating func step(_ v0: Double, _ fc: Double, _ q: Double) -> (lp: Double, bp: Double, hp: Double) {
		let g = tan(Double.pi * min(max(fc, 10), SR * 0.45) / SR), k = 1 / q
		let a1 = 1 / (1 + g * (g + k)), a2 = g * a1, a3 = g * a2
		let v3 = v0 - ic2
		let v1 = a1 * ic1 + a2 * v3
		let v2 = ic2 + a2 * ic1 + a3 * v3
		ic1 = 2 * v1 - ic1; ic2 = 2 * v2 - ic2
		return (v2, v1, v0 - k * v1 - v2)
	}
}
@inline(__always) func blep(_ t: Double, _ dt: Double) -> Double {
	if t < dt { let x = t / dt; return x + x - x * x - 1 }
	if t > 1 - dt { let x = (t - 1) / dt; return x * x + x + x + 1 }
	return 0
}
/// Band-limited (polyBLEP) saw.
struct Saw {
	var ph: Double
	init(_ p: Double) { ph = p }
	@inline(__always) mutating func next(_ f: Double) -> Double {
		let dt = f / SR
		let v = 2 * ph - 1 - blep(ph, dt)
		ph += dt; if ph >= 1 { ph -= 1 }
		return v
	}
}

// ================================================================ drums
func kick(_ g: Double = 1) -> [Float] {
	let n = Int(SR * 0.42); var o = [Float](repeating: 0, count: n)
	var ph = 0.0; var f1 = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (50 + 140 * exp(-t * 38)) / SR
		let body = sin(ph) * min(1, t / 0.0008) * exp(-t / 0.16)
		let click = f1.step(rnd() * exp(-t / 0.003), 3200, 0.6).bp
		o[i] = Float(tanh(2.0 * (body + 0.55 * click)) / tanh(2.0) * g)
	}
	return o
}
/// A tight, bright clap: three bursts and a short room tail.
func clap(_ g: Double = 1, pitch: Double = 1) -> [Float] {
	let n = Int(SR * 0.3); var o = [Float](repeating: 0, count: n)
	var bp = SVF(), hp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		var e = 0.0
		for d in [0.0, 0.009, 0.018] where t >= d { e += exp(-(t - d) / 0.0045) }
		if t >= 0.018 { e += 0.6 * exp(-(t - 0.018) / 0.075) }
		let s = bp.step(rnd(), 1350 * pitch, 1.3).bp * e * 2.2
		o[i] = Float(tanh(1.4 * hp.step(s, 380, 0.7).hp) * g)
	}
	return o
}
func snare(_ g: Double = 1, pitch: Double = 1) -> [Float] {
	let n = Int(SR * 0.3); var o = [Float](repeating: 0, count: n)
	var ph = 0.0; var bp = SVF(), hp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (210 + 50 * exp(-t * 40)) * pitch / SR
		let tone = sin(ph) * exp(-t / 0.05) * 0.5
		let noise = bp.step(rnd(), 2400 * pitch, 0.7).bp * exp(-t / 0.09) * 1.5
		o[i] = Float(tanh(1.3 * hp.step(tone + noise, 200, 0.7).hp) * g)
	}
	return o
}
func hat(_ open: Bool, _ g: Double) -> [Float] {
	let n = Int(SR * (open ? 0.3 : 0.06)); var o = [Float](repeating: 0, count: n)
	var a = SVF(), b = SVF(), pk = SVF()
	for i in 0..<n {
		let t = Double(i) / SR, x = rnd()
		var y = a.step(x, 8000, 0.7).hp
		y = b.step(y, 8000, 0.7).hp
		let m = pk.step(x, 11000, 3).bp * 0.3
		o[i] = Float((y + m) * min(1, t / 0.0004) * exp(-t / (open ? 0.1 : 0.018)) * g * 0.9)
	}
	return o
}
func crash(_ g: Double) -> ([Float], [Float]) {
	let n = Int(SR * 2.2)
	var out: [[Float]] = []
	for ch in 0..<2 {
		var o = [Float](repeating: 0, count: n); var hp1 = SVF(), hp2 = SVF()
		let fr: [Double] = [1980, 2730, 3620, 4870, 6040, 7230].map { $0 * (ch == 0 ? 1.0 : 1.013) }
		for i in 0..<n {
			let t = Double(i) / SR
			var metal = 0.0
			for f in fr { metal += sin(2 * Double.pi * f * t) > 0 ? 1 : -1 }
			let s = hp1.step(rnd(), 3400, 0.7).hp * exp(-t / 0.95) + hp2.step(metal / 6, 2600, 0.7).hp * exp(-t / 0.5) * 0.35
			o[i] = Float(s * min(1, t / 0.0015) * g)
		}
		out.append(o)
	}
	return (out[0], out[1])
}
func boom(_ g: Double) -> [Float] {
	let n = Int(SR * 1.4); var o = [Float](repeating: 0, count: n); var ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (36 + 40 * exp(-t * 3.5)) / SR
		o[i] = Float(tanh(1.5 * sin(ph) * min(1, t / 0.002) * exp(-t / 0.55)) * g)
	}
	return o
}
/// The jersey-club bed squeak: a rubbery chirp.
func squeak(_ g: Double, up: Bool = true) -> [Float] {
	let n = Int(SR * 0.09); var o = [Float](repeating: 0, count: n); var ph = 0.0; var bp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR, x = t / 0.09
		let f = (up ? lerp(1500, 2500, x) : lerp(2500, 1600, x)) * (1 + 0.04 * sin(2 * Double.pi * 38 * t))
		ph += 2 * Double.pi * f / SR
		let s = bp.step(sin(ph) + 0.3 * sin(2 * ph), f * 1.1, 3).bp
		o[i] = Float(s * min(1, t / 0.004) * exp(-t / 0.03) * g)
	}
	return o
}

// ================================================================ tonal voices
/// An 808: sine with a little drive, an optional glide up from `from` (semitones away), and a short release.
func bass808(_ m: Double, _ dur: Double, _ g: Double, from: Double? = nil, glide: Double = 0.06) -> [Float] {
	let n = Int(SR * (dur + 0.06))
	var o = [Float](repeating: 0, count: n); var ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		var mm = m
		if let f0 = from { mm = m + (f0 - m) * exp(-t / (glide / 3)) }
		let f = mtof(mm) * (1 + 0.6 * exp(-t / 0.012))           // a pitch blip at the start for the attack
		ph += 2 * Double.pi * f / SR
		let osc = sin(ph) + 0.18 * sin(2 * ph)
		let env = min(1, t / 0.003) * (t < dur ? 1 : exp(-(t - dur) / 0.02))
		o[i] = Float(tanh(1.9 * osc * env) / tanh(1.9) * g)
	}
	return o
}
/// A formant "vocal chop": a saw voice through three vowel formants, pitched up (hyperpop), with a scoop and vibrato.
enum Vowel { case a, o, e, i, u }
func formants(_ v: Vowel) -> [(Double, Double, Double)] {   // (Hz, Q, gain), shifted up 1.22x for the chipmunk colour
	let k = 1.22
	switch v {
	case .a: return [(800 * k, 7, 1.0), (1200 * k, 9, 0.62), (2800 * k, 14, 0.28)]
	case .o: return [(470 * k, 7, 1.0), (820 * k, 9, 0.5), (2830 * k, 14, 0.16)]
	case .e: return [(530 * k, 7, 1.0), (1840 * k, 10, 0.5), (2480 * k, 14, 0.3)]
	case .i: return [(320 * k, 7, 1.0), (2300 * k, 11, 0.42), (3000 * k, 14, 0.3)]
	case .u: return [(330 * k, 7, 1.0), (700 * k, 9, 0.36), (2530 * k, 14, 0.1)]
	}
}
func vox(_ m: Double, _ dur: Double, _ v: Vowel, _ g: Double, scoop: Double = -70, to: Vowel? = nil) -> ([Float], [Float]) {
	let n = Int(SR * (dur + 0.05))
	var L = [Float](repeating: 0, count: n), R = L
	var sL = Saw(0.21), sR = Saw(0.67)
	var fl = [SVF(), SVF(), SVF()], fr = [SVF(), SVF(), SVF()]
	let fa = formants(v), fb = formants(to ?? v)
	for i in 0..<n {
		let t = Double(i) / SR
		let sc = scoop * exp(-t / 0.018)
		let vib = t > 0.12 ? 22 * sin(2 * Double.pi * 5.6 * t) * min(1, (t - 0.12) / 0.1) : 0
		let f = mtof(m) * cents(sc + vib)
		let xl = sL.next(f * cents(5)) + 0.05 * rnd(), xr = sR.next(f * cents(-5)) + 0.05 * rnd()
		let w = to == nil ? 0 : min(1, t / max(0.05, dur * 0.7))
		var yl = 0.0, yr = 0.0
		for k in 0..<3 {
			let fc = lerp(fa[k].0, fb[k].0, w), q = fa[k].1, gk = lerp(fa[k].2, fb[k].2, w)
			yl += fl[k].step(xl, fc, q).bp * gk; yr += fr[k].step(xr, fc, q).bp * gk
		}
		let env = min(1, t / 0.006) * (t < dur ? 1 - 0.15 * min(1, t / 0.2) : exp(-(t - dur) / 0.018))
		L[i] = Float(tanh(1.2 * yl * env) * g); R[i] = Float(tanh(1.2 * yr * env) * g)
	}
	return (L, R)
}
func pluck(_ m: Double, _ dur: Double, bright: Double, _ g: Double) -> ([Float], [Float]) {
	let f = mtof(m), n = Int(SR * (dur + 0.4))
	var L = [Float](repeating: 0, count: n), R = L
	var s1 = Saw(0.11), s2 = Saw(0.63), s3 = Saw(0.37); var lL = SVF(), lR = SVF(); var sp = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		let a = s1.next(f * cents(7)), b = s2.next(f * cents(-7)), c = s3.next(f)
		sp += 2 * Double.pi * f / 2 / SR
		let sub = sin(sp) * 0.3
		let fc = 350 + bright * 6500 * exp(-t / 0.11)
		let env = min(1, t / 0.002) * exp(-t / 0.23) * (t < dur ? 1 : exp(-(t - dur) / 0.05))
		L[i] = Float(lL.step(a * 0.8 + c * 0.6 + sub, fc, 1.2).lp * env * g)
		R[i] = Float(lR.step(b * 0.8 + c * 0.6 + sub, fc, 1.2).lp * env * g)
	}
	return (L, R)
}
/// Supersaw chord stab (four detuned saws per note) with a filter envelope.
func stab(_ ms: [Double], _ dur: Double, peak: Double, _ g: Double, decay: Double = 0.17) -> ([Float], [Float]) {
	let n = Int(SR * (dur + 0.5))
	var L = [Float](repeating: 0, count: n), R = L
	let det: [Double] = [-18, -7, 7, 18]
	var saws: [Saw] = []
	for (k, _) in ms.enumerated() { for j in 0..<4 { saws.append(Saw(Double((k * 4 + j) * 37 % 100) / 100)) } }
	var lL = SVF(), lR = SVF()
	let norm = 1.0 / Double(ms.count * 2)
	for i in 0..<n {
		let t = Double(i) / SR
		var l = 0.0, r = 0.0, idx = 0
		for m in ms {
			let f = mtof(m)
			for (j, d) in det.enumerated() {
				let v = saws[idx].next(f * cents(d)); idx += 1
				if j % 2 == 0 { l += v } else { r += v }
			}
		}
		let fc = 300 + peak * exp(-t / 0.09)
		let env = min(1, t / 0.003) * exp(-t / decay) * (t < dur ? 1 : exp(-(t - dur) / 0.08))
		L[i] = Float(lL.step(l * norm, fc, 0.9).lp * env * g)
		R[i] = Float(lR.step(r * norm, fc, 0.9).lp * env * g)
	}
	return (L, R)
}
func pad(_ ms: [Double], _ dur: Double, cutoff: Double, _ g: Double, attack: Double = 0.25, cutoff1: Double? = nil) -> ([Float], [Float]) {
	let n = Int(SR * (dur + 0.6))
	var L = [Float](repeating: 0, count: n), R = L
	let det: [Double] = [-11, 0, 11]
	var saws: [Saw] = []
	for k in 0..<(ms.count * 3) { saws.append(Saw(Double(k * 29 % 100) / 100)) }
	var lL = SVF(), lR = SVF()
	let norm = 1.0 / Double(ms.count * 2)
	for i in 0..<n {
		let t = Double(i) / SR
		var l = 0.0, r = 0.0, idx = 0
		for m in ms {
			let f = mtof(m)
			for (j, d) in det.enumerated() {
				let v = saws[idx].next(f * cents(d)); idx += 1
				if j == 0 { l += v } else if j == 2 { r += v } else { l += v * 0.5; r += v * 0.5 }
			}
		}
		let fc = cutoff1 == nil ? cutoff : cutoff * pow(cutoff1! / cutoff, min(1, t / dur))
		let env = min(1, t / attack) * (t < dur ? 1 : exp(-(t - dur) / 0.25))
		L[i] = Float(lL.step(l * norm, fc, 0.7).lp * env * g)
		R[i] = Float(lR.step(r * norm, fc, 0.7).lp * env * g)
	}
	return (L, R)
}

// ================================================================ liquid glass sound effects (tuned, no stock whooshes)
func sample(_ name: String) -> [Float] {
	let d = try! Data(contentsOf: HERE.appendingPathComponent("sfx/\(name).f32"))
	return d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
}
/// A bubble: pitch rises as it closes (up) or falls as it swallows (down), with a wet resonance.
func bubble(_ m: Double, _ g: Double, up: Bool = true, len: Double = 0.11) -> [Float] {
	let f = mtof(m), n = Int(SR * (len + 0.06)); var o = [Float](repeating: 0, count: n); var ph = 0.0; var bp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR, x = min(1, t / (len * 0.45))
		let k = up ? lerp(0.62, 1.18, 1 - pow(1 - x, 2)) : lerp(1.35, 0.7, 1 - pow(1 - x, 2))
		ph += 2 * Double.pi * f * k / SR
		let s = sin(ph) + 0.25 * sin(2 * ph)
		let wet = bp.step(rnd(), f * k * 2, 9).bp * 0.35
		o[i] = Float((s + wet) * min(1, t / 0.0015) * exp(-t / (len * 0.42)) * g)
	}
	return o
}
/// A rubbery hop: up, overshoot, settle.
func boing(_ m: Double, _ g: Double) -> [Float] {
	let f = mtof(m), n = Int(SR * 0.2); var o = [Float](repeating: 0, count: n); var ph = 0.0; var lp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		let k = 1 + 0.45 * sin(min(1, t / 0.07) * Double.pi) * exp(-t / 0.08) - 0.2 * exp(-t / 0.012)
		ph += 2 * Double.pi * f * k / SR
		let tri = asin(sin(ph)) * 2 / Double.pi
		o[i] = Float(lp.step(tri, 4000, 0.8).lp * min(1, t / 0.002) * exp(-t / 0.06) * g)
	}
	return o
}
/// Glass being poured or reshaped: a tuned resonant sweep plus two glassy partials. Never a noise whoosh.
func slosh(_ m: Double, _ dur: Double, _ g: Double, up: Bool) -> ([Float], [Float]) {
	let n = Int(SR * (dur + 0.25)); var L = [Float](repeating: 0, count: n), R = L
	var bl = SVF(), br = SVF(); var p1 = 0.0, p2 = 0.0
	let f = mtof(m)
	for i in 0..<n {
		let t = Double(i) / SR, x = min(1, t / dur)
		let k = up ? pow(2, -1 + 1.6 * x) : pow(2, 0.6 - 1.4 * x)
		let fc = f * k
		let env = sin(min(1, t / dur) * Double.pi) * (t < dur ? 1 : exp(-(t - dur) / 0.06))
		p1 += 2 * Double.pi * fc / SR; p2 += 2 * Double.pi * fc * 2.76 / SR
		let glass = (sin(p1) * 0.5 + sin(p2) * 0.18) * env
		let l = bl.step(rnd(), fc * 1.5, 14).bp * 0.9 + glass, r = br.step(rnd(), fc * 1.52, 14).bp * 0.9 + glass
		L[i] = Float(l * env * g); R[i] = Float(r * env * g)
	}
	return (L, R)
}
/// A soft mallet bell (partials 1, 2.76, 5.4).
func bell(_ m: Double, _ g: Double, decay: Double = 0.9) -> [Float] {
	let f = mtof(m), n = Int(SR * decay * 3.5); var o = [Float](repeating: 0, count: n)
	for i in 0..<n {
		let t = Double(i) / SR
		let s = sin(2 * Double.pi * f * t) * exp(-t / decay) + 0.32 * sin(2 * Double.pi * f * 2.76 * t) * exp(-t / (decay * 0.35)) + 0.12 * sin(2 * Double.pi * f * 5.4 * t) * exp(-t / (decay * 0.15))
		o[i] = Float(s * min(1, t / 0.003) * g)
	}
	return o
}
/// A felt thump (a low body with a pitch drop and a soft knock).
func thump(_ g: Double) -> [Float] {
	let n = Int(SR * 0.6); var o = [Float](repeating: 0, count: n); var ph = 0.0; var lp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (52 + 26 * exp(-t / 0.03)) / SR
		let body = sin(ph) * min(1, t / 0.002) * exp(-t / 0.26)
		let knock = lp.step(rnd(), 260, 0.8).lp * exp(-t / 0.03) * 1.4
		o[i] = Float(tanh(1.4 * (body + knock)) * g)
	}
	return o
}

// ================================================================ effects
func freeverb(_ inL: [Float], _ inR: [Float]) -> ([Float], [Float]) {
	let sc = SR / 44100
	let combT = [1116, 1188, 1277, 1356, 1422, 1491, 1557, 1617].map { Int(Double($0) * sc) }
	let apT = [556, 441, 341, 225].map { Int(Double($0) * sc) }
	let spread = Int(23 * sc), fb: Float = 0.84, damp: Float = 0.28
	func run(_ x: [Float], _ off: Int) -> [Float] {
		var combs = combT.map { [Float](repeating: 0, count: $0 + off) }
		var ci = [Int](repeating: 0, count: combs.count), store = [Float](repeating: 0, count: combs.count)
		var aps = apT.map { [Float](repeating: 0, count: $0 + off) }
		var ai = [Int](repeating: 0, count: aps.count)
		var y = [Float](repeating: 0, count: x.count)
		for i in 0..<x.count {
			let inp = x[i] * 0.015
			var s: Float = 0
			for k in 0..<combs.count {
				let o = combs[k][ci[k]]
				store[k] = o * (1 - damp) + store[k] * damp
				combs[k][ci[k]] = inp + store[k] * fb
				ci[k] += 1; if ci[k] >= combs[k].count { ci[k] = 0 }
				s += o
			}
			for k in 0..<aps.count {
				let bo = aps[k][ai[k]]
				let o = -s + bo
				aps[k][ai[k]] = s + bo * 0.5
				ai[k] += 1; if ai[k] >= aps[k].count { ai[k] = 0 }
				s = o
			}
			y[i] = s
		}
		return y
	}
	return (run(inL, 0), run(inR, spread))
}
func pingpong(_ inL: [Float], _ inR: [Float], time: Double, fb: Float) -> ([Float], [Float]) {
	let d = Int(time * SR), n = inL.count
	var bL = [Float](repeating: 0, count: d), bR = bL
	var oL = [Float](repeating: 0, count: n), oR = oL
	var i = 0, lpL: Float = 0, lpR: Float = 0
	let a: Float = 0.35
	for s in 0..<n {
		let yl = bL[i], yr = bR[i]
		lpL += a * (yl - lpL); lpR += a * (yr - lpR)
		bL[i] = (inL[s] + inR[s]) * 0.5 + lpR * fb
		bR[i] = lpL * fb
		oL[s] = yl; oR[s] = yr
		i += 1; if i >= d { i = 0 }
	}
	return (oL, oR)
}
func compress(_ b: inout Bus, thr: Double, ratio: Double, att: Double, rel: Double) {
	var env = 0.0
	let aA = exp(-1 / (att * SR)), aR = exp(-1 / (rel * SR))
	for i in 0..<b.L.count {
		let x = Double(max(abs(b.L[i]), abs(b.R[i])))
		env = x > env ? aA * env + (1 - aA) * x : aR * env + (1 - aR) * x
		let over = 20 * log10(env + 1e-9) - thr
		let g = Float(over > 0 ? pow(10, -over * (1 - 1 / ratio) / 20) : 1)
		b.L[i] *= g; b.R[i] *= g
	}
}
func limit(_ b: inout Bus, ceiling: Double) {
	let n = b.L.count, la = Int(0.003 * SR)
	var req = [Float](repeating: 1, count: n)
	for i in 0..<n { let p = max(abs(b.L[i]), abs(b.R[i])); if Double(p) > ceiling { req[i] = Float(ceiling / Double(p)) } }
	var g: Float = 1
	let relK = Float(1 - exp(-1 / (0.08 * SR)))
	for i in 0..<n {
		var m: Float = 1
		for j in i..<min(n, i + la) { m = min(m, req[j]) }
		if m < g { g = m } else { g += (m - g) * relK }
		b.L[i] *= g; b.R[i] *= g
	}
}
/// Sidechain: everything melodic breathes with the kick.
var KICKS: [Double] = []
func duck(_ b: inout Bus, depth: Double, rel: Double = 0.11) {
	for k in KICKS {
		let s0 = Int(k * SR), len = Int(0.32 * SR)
		for i in 0..<len {
			let j = s0 + i
			if j < 0 || j >= b.L.count { continue }
			let g = Float(1 - depth * exp(-Double(i) / SR / rel))
			b.L[j] *= g; b.R[j] *= g
		}
	}
}
/// A low-pass whose cutoff sweeps over [t0, t1] (the "from the next room" intro). Outside the span, untouched.
func lowpassSweep(_ b: inout Bus, _ t0: Double, _ t1: Double, _ f0: Double, _ f1: Double) {
	var fl = SVF(), fr = SVF()
	let a = Int(t0 * SR), z = min(b.L.count, Int(t1 * SR))
	for i in a..<z {
		let x = Double(i - a) / Double(z - a)
		let fc = f0 * pow(f1 / f0, x * x)
		b.L[i] = Float(fl.step(Double(b.L[i]), fc, 0.8).lp); b.R[i] = Float(fr.step(Double(b.R[i]), fc, 0.8).lp)
	}
}
/// Tape stop: from t0 the bus slows to a halt over `dur` (pitch and speed fall together), then silence.
func tapeStop(_ b: inout Bus, _ t0: Double, _ dur: Double) {
	let a = Int(t0 * SR), n = Int(dur * SR)
	let srcL = b.L, srcR = b.R
	var pos = Double(a)
	for i in 0..<n {
		let j = a + i
		if j >= b.L.count { break }
		let u = Double(i) / Double(n)
		let speed = pow(1 - u, 1.6)
		let p0 = Int(pos), fr = Float(pos - Double(p0))
		if p0 + 1 < srcL.count {
			let fade = Float(min(1, (1 - u) * 6))
			b.L[j] = (srcL[p0] * (1 - fr) + srcL[p0 + 1] * fr) * fade
			b.R[j] = (srcR[p0] * (1 - fr) + srcR[p0 + 1] * fr) * fade
		}
		pos += speed
	}
	for j in (a + n)..<b.L.count { b.L[j] = 0; b.R[j] = 0 }
}
/// Stutter: repeat the slice [t0, t0 + len) `count` times from t0 (with tiny fades), in place.
func stutter(_ b: inout Bus, _ t0: Double, _ len: Double, _ count: Int) {
	let a = Int(t0 * SR), l = Int(len * SR), f = Int(0.002 * SR)
	let sl = Array(b.L[a..<min(b.L.count, a + l)]), sr = Array(b.R[a..<min(b.R.count, a + l)])
	for c in 0..<count {
		for i in 0..<sl.count {
			let j = a + c * l + i
			if j >= b.L.count { break }
			let g: Float = i < f ? Float(i) / Float(f) : (i > sl.count - f ? Float(sl.count - i) / Float(f) : 1)
			b.L[j] = sl[i] * g; b.R[j] = sr[i] * g
		}
	}
}
func reversed(_ x: ([Float], [Float])) -> ([Float], [Float]) { (Array(x.0.reversed()), Array(x.1.reversed())) }

func writeWav(_ name: String, _ b: Bus) {
	var d = Data()
	func u32(_ v: UInt32) { var x = v.littleEndian; withUnsafeBytes(of: &x) { d.append(contentsOf: $0) } }
	func u16(_ v: UInt16) { var x = v.littleEndian; withUnsafeBytes(of: &x) { d.append(contentsOf: $0) } }
	let n = b.L.count, bytes = n * 8
	d.append(contentsOf: Array("RIFF".utf8)); u32(UInt32(36 + bytes)); d.append(contentsOf: Array("WAVE".utf8))
	d.append(contentsOf: Array("fmt ".utf8)); u32(16); u16(3); u16(2); u32(48000); u32(48000 * 8); u16(8); u16(32)
	d.append(contentsOf: Array("data".utf8)); u32(UInt32(bytes))
	var inter = [Float](repeating: 0, count: n * 2)
	for i in 0..<n { inter[2 * i] = b.L[i]; inter[2 * i + 1] = b.R[i] }
	inter.withUnsafeBufferPointer { d.append(Data(buffer: $0)) }
	try! d.write(to: HERE.appendingPathComponent("audio/\(name).wav"))
}
