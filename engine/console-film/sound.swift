// sound.swift: the score and sound design for one-command v3.
// Everything is synthesised here (no stock music, no generative audio model) except the keys and clicks,
// which are real CC0 recordings (Kenney UI SFX, from the supermemory video pack). 160 BPM, F minor,
// arranged to the picture's beat grid in timeline.swift.
//
// Build: cat timeline.swift sound.swift > snd.swift && swiftc -O snd.swift -o snd && ./snd
// Writes: audio/music.wav, audio/sfx.wav, audio/mix.wav (pre-loudness), then ffmpeg normalises to -14 LUFS.

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
func cents(_ c: Double) -> Double { pow(2, c / 1200) }

// ================================================================ drums (808/909-style synthesis)
func kick(_ g: Double = 1) -> [Float] {
	let n = Int(SR * 0.45); var o = [Float](repeating: 0, count: n)
	var ph = 0.0; var f1 = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (47 + 125 * exp(-t * 34)) / SR
		let body = sin(ph) * min(1, t / 0.0008) * exp(-t / 0.19)
		let click = f1.step(rnd() * exp(-t / 0.003), 2500, 0.6).bp
		o[i] = Float(tanh(1.8 * (body + 0.45 * click)) / tanh(1.8) * g)
	}
	return o
}
func snare(_ g: Double = 1, pitch: Double = 1) -> [Float] {
	let n = Int(SR * 0.36); var o = [Float](repeating: 0, count: n)
	var ph = 0.0; var bp = SVF(), cl = SVF(), hp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (190 + 40 * exp(-t * 40)) * pitch / SR
		let tone = sin(ph) * exp(-t / 0.06) * 0.55
		let nz = rnd()
		let noise = bp.step(nz, 1900 * pitch, 0.65).bp * exp(-t / 0.13) * 1.6
		var ce = 0.0
		for d in [0.0, 0.010, 0.021] where t >= d { ce += exp(-(t - d) / 0.005) }
		if t >= 0.021 { ce += 0.55 * exp(-(t - 0.021) / 0.09) }
		let clap = cl.step(nz, 1250 * pitch, 1.1).bp * ce * 1.1
		let s = hp.step(tone + noise + clap, 170, 0.7).hp
		o[i] = Float(tanh(1.3 * s) * g)
	}
	return o
}
func hat(_ open: Bool, _ g: Double) -> [Float] {
	let n = Int(SR * (open ? 0.32 : 0.07)); var o = [Float](repeating: 0, count: n)
	var a = SVF(), b = SVF(), pk = SVF()
	for i in 0..<n {
		let t = Double(i) / SR, x = rnd()
		var y = a.step(x, 7600, 0.7).hp
		y = b.step(y, 7600, 0.7).hp
		let m = pk.step(x, 10500, 3).bp * 0.3
		o[i] = Float((y + m) * min(1, t / 0.0004) * exp(-t / (open ? 0.11 : 0.022)) * g * 0.9)
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
	let n = Int(SR * 1.3); var o = [Float](repeating: 0, count: n); var ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * (32 + 36 * exp(-t * 3.5)) / SR
		o[i] = Float(tanh(1.5 * sin(ph) * min(1, t / 0.002) * exp(-t / 0.5)) * g)
	}
	return o
}
/// A filtered noise sweep that stops dead on the downbeat.
func riser(_ dur: Double, _ g: Double) -> ([Float], [Float]) {
	let n = Int(SR * dur)
	var L = [Float](repeating: 0, count: n), R = L
	var fl = SVF(), fr = SVF()
	for i in 0..<n {
		let x = Double(i) / Double(n)
		let fc = 380 * pow(18, x), a = pow(x, 1.8) * g
		L[i] = Float(fl.step(rnd(), fc, 1.6).bp * a); R[i] = Float(fr.step(rnd(), fc * 1.04, 1.6).bp * a)
	}
	return (L, R)
}

// ================================================================ tonal voices
func bassNote(_ m: Double, _ dur: Double, _ g: Double) -> [Float] {
	let f = mtof(m), n = Int(SR * (dur + 0.08))
	var o = [Float](repeating: 0, count: n); var ph = 0.0; var lp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * f / SR
		let osc = tanh(1.6 * (sin(ph) + 0.5 * sin(2 * ph) + 0.25 * sin(3 * ph)))
		let y = lp.step(osc, 260 + 1500 * exp(-t / 0.07), 1.0).lp + 0.42 * sin(0.5 * ph)
		let env = min(1, t / 0.005) * (t < dur ? 1 : exp(-(t - dur) / 0.025))
		o[i] = Float(y * env * g)
	}
	return o
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
func stab(_ ms: [Double], _ dur: Double, peak: Double, _ g: Double, decay: Double = 0.17) -> ([Float], [Float]) {
	let n = Int(SR * (dur + 0.5))
	var L = [Float](repeating: 0, count: n), R = L
	let det: [Double] = [-16, -6, 6, 16]
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
func pad(_ ms: [Double], _ dur: Double, cutoff: Double, _ g: Double, attack: Double = 0.25) -> ([Float], [Float]) {
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
		let env = min(1, t / attack) * (t < dur ? 1 : exp(-(t - dur) / 0.25))
		L[i] = Float(lL.step(l * norm, cutoff, 0.7).lp * env * g)
		R[i] = Float(lR.step(r * norm, cutoff, 0.7).lp * env * g)
	}
	return (L, R)
}

// ================================================================ sound effects
func sample(_ name: String) -> [Float] {
	let d = try! Data(contentsOf: HERE.appendingPathComponent("sfx/\(name).f32"))
	return d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
}
func pop(_ m: Double, _ g: Double) -> [Float] {
	let f = mtof(m), n = Int(SR * 0.14); var o = [Float](repeating: 0, count: n); var ph = 0.0
	for i in 0..<n {
		let t = Double(i) / SR
		ph += 2 * Double.pi * f * (0.72 + 0.36 * min(1, t / 0.025)) / SR
		o[i] = Float((sin(ph) + 0.22 * sin(2 * ph)) * min(1, t / 0.001) * exp(-t / 0.045) * g)
	}
	return o
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
/// The felt thump (56 Hz body with a pitch drop + a 260 Hz knock), used exactly twice.
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
func duck(_ b: inout Bus, depth: Double) {
	for k in KICKS {
		let s0 = Int(k * SR), len = Int(0.32 * SR)
		for i in 0..<len {
			let j = s0 + i
			if j < 0 || j >= b.L.count { continue }
			let g = Float(1 - depth * exp(-Double(i) / SR / 0.11))
			b.L[j] *= g; b.R[j] *= g
		}
	}
}

// ================================================================ the score
enum Chord { case fm, db, ab, eb }
let BAR_CH: [Chord] = [.fm, .db, .fm, .db, .ab, .fm, .db, .eb, .fm, .db, .fm, .fm]
func padNotes(_ c: Chord) -> [Double] {
	switch c { case .fm: return [53, 56, 60, 63, 65]; case .db: return [49, 53, 56, 60, 65]; case .ab: return [56, 60, 63, 67, 68]; case .eb: return [51, 55, 58, 61, 63] }
}
func root(_ c: Chord) -> Double { switch c { case .fm: return 41; case .db: return 37; case .ab: return 44; case .eb: return 39 } }
func lead(_ c: Chord) -> [Double] {
	switch c { case .fm: return [77, 80, 84, 87]; case .db: return [77, 80, 85, 84]; case .ab: return [75, 79, 80, 84]; case .eb: return [75, 79, 82, 85] }
}
func st(_ bar: Int, _ step: Double) -> Double { bt(Double(bar)) + step * S16 }

var drums = Bus(NS), bass = Bus(NS), chords = Bus(NS), leadB = Bus(NS), fx = Bus(NS)
var revSend = Bus(NS), dlySend = Bus(NS), sfx = Bus(NS)

let KICK = kick(), CLOSED = hat(false, 1), OPEN = hat(true, 1)
func k(_ t: Double, _ g: Double) { drums.add(KICK, at: t, gain: g); KICKS.append(t) }
func sn(_ t: Double, _ g: Double, pitch: Double = 1) {
	let s = snare(1, pitch: pitch)
	drums.add(s, at: t, gain: g, pan: -0.05); revSend.add(s, at: t, gain: g * 0.25)
}
func hh(_ t: Double, _ g: Double, open: Bool = false) { drums.add(open ? OPEN : CLOSED, at: t, gain: g, pan: 0.25) }
func hats16(_ bar: Int, _ g: Double, openAt: [Int] = [14]) {
	let acc: [Double] = [1.0, 0.45, 0.72, 0.45]
	for s in 0..<16 {
		if openAt.contains(s) { hh(st(bar, Double(s)), g * 0.65, open: true); continue }
		hh(st(bar, Double(s)), g * acc[s % 4] * (1 + 0.08 * rnd()))
	}
}
func plk(_ t: Double, _ m: Double, _ len: Double, bright: Double, _ g: Double, pan: Double = 0) {
	let (l, r) = pluck(m, len, bright: bright, 1)
	let gl = g * (1 - max(0, pan)), gr = g * (1 + min(0, pan))
	leadB.addSt(l.map { $0 * Float(gl) }, r.map { $0 * Float(gr) }, at: t, gain: 1)
	dlySend.addSt(l, r, at: t, gain: g * 0.35); revSend.addSt(l, r, at: t, gain: g * 0.18)
}
func chordStab(_ t: Double, _ ms: [Double], _ dur: Double, peak: Double, _ g: Double, decay: Double = 0.17) {
	let (l, r) = stab(ms, dur, peak: peak, 1, decay: decay)
	chords.addSt(l, r, at: t, gain: g); revSend.addSt(l, r, at: t, gain: g * 0.2); dlySend.addSt(l, r, at: t, gain: g * 0.08)
}
func chordPad(_ t: Double, _ ms: [Double], _ dur: Double, cutoff: Double, _ g: Double, attack: Double = 0.25) {
	let (l, r) = pad(ms, dur, cutoff: cutoff, 1, attack: attack)
	chords.addSt(l, r, at: t, gain: g); revSend.addSt(l, r, at: t, gain: g * 0.25)
}
func arp(_ bar: Int, bright0: Double, bright1: Double, _ g: Double) {
	let tones = lead(BAR_CH[bar]).map { $0 - 12 }
	let order = [0, 1, 2, 3, 2, 1, 2, 3]
	for s in 0..<16 {
		let b = lerp(bright0, bright1, Double(s) / 15)
		plk(st(bar, Double(s)), tones[order[s % 8]], S16 * 0.9, bright: b, g, pan: s % 2 == 0 ? -0.3 : 0.3)
	}
}
func hook(_ bar: Int, _ g: Double, bright: Double, octave: Double = 0) {
	let tones = lead(BAR_CH[bar])
	let steps: [Double] = [0, 3, 6, 8, 10, 12, 14], idx = [0, 1, 2, 1, 3, 2, 1], lens: [Double] = [3, 3, 2, 2, 2, 2, 2]
	for (i, s) in steps.enumerated() { plk(st(bar, s), tones[idx[i]] + octave, lens[i] * S16, bright: bright, g) }
}
func bassline(_ bar: Int, _ pattern: [(Double, Double, Double)], _ g: Double) {
	let r = root(BAR_CH[bar])
	for (s, len, oct) in pattern { bass.add(bassNote(r + oct, len * S16 * 0.78, 1), at: st(bar, s), gain: g) }
}
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }

// ---- bar 0: intro, at level from the first frame
chordPad(0, padNotes(.fm), BAR, cutoff: 1500, 0.75, attack: 0.02)
arp(0, bright0: 0.35, bright1: 0.55, 0.21)
for s in stride(from: 0, to: 16, by: 2) { hh(st(0, Double(s)), 0.16) }
// ---- bar 1: the copy click is the first kick; a snare roll and a sweep build to the enter key
k(st(1, 0), 0.85)
chordPad(st(1, 0), padNotes(.db), BAR - S16, cutoff: 1900, 0.7, attack: 0.05)
arp(1, bright0: 0.55, bright1: 0.85, 0.22)
for s in 0..<15 { hh(st(1, Double(s)), s % 2 == 0 ? 0.2 : 0.11) }
for (i, s) in (8..<15).enumerated() { sn(st(1, Double(s)), 0.15 + 0.07 * Double(i), pitch: 1 + 0.04 * Double(i)) }
do { let (l, r) = riser(st(1, 15) - st(1, 5), 0.22); fx.addSt(l, r, at: st(1, 5), gain: 1) }
// ---- bars 2-3: first drop on enter (the banner)
for bar in [2, 3, 8, 9] {
	let big = bar >= 8
	let last = bar == 9 ? 8 : 16                     // bar 9 hands over to the final hit
	if bar == 2 || bar == 8 {
		let (l, r) = crash(big ? 0.42 : 0.34); fx.addSt(l, r, at: st(bar, 0), gain: 1)
		fx.add(boom(big ? 0.42 : 0.3), at: st(bar, 0), gain: 1)
	}
	for s in [0.0, 10.0] where s < Double(last) { k(st(bar, s), 0.88) }
	for s in [4.0, 12.0] where s < Double(last) { sn(st(bar, s), 0.72) }
	let acc: [Double] = [1.0, 0.45, 0.72, 0.45]
	for s in 0..<last {
		if s == 14 || (big && s == 6) { hh(st(bar, Double(s)), 0.17, open: true); continue }
		hh(st(bar, Double(s)), 0.32 * acc[s % 4] * (1 + 0.08 * rnd()))
	}
	bassline(bar, [(0, 6, 0), (7, 2, 0), (10, 4, 0), (14, 2, 12)].filter { $0.0 < Double(last) }, 0.62)
	for s in [2.0, 6.0, 10.0, 14.0] where s < Double(last) { chordStab(st(bar, s), padNotes(BAR_CH[bar]).map { $0 + 12 }, S16 * 1.5, peak: 4400, 0.5) }
	if bar == 9 {
		hook(bar, 0.2, bright: 0.85)
	} else {
		hook(bar, 0.25, bright: 0.9)
		if big { hook(bar, 0.08, bright: 0.9, octave: 12) }
	}
}
// ---- bar 4: break under "or one by one"
chordPad(st(4, 0), padNotes(.ab), BAR, cutoff: 1600, 0.6, attack: 0.08)
arp(4, bright0: 0.45, bright1: 0.6, 0.15)
for s in stride(from: 0, to: 16, by: 2) { hh(st(4, Double(s)), 0.15) }
for s in [4.0, 12.0] { sn(st(4, s), 0.3, pitch: 1.1) }
bass.add(bassNote(root(.ab), BAR * 0.8, 1), at: st(4, 0), gain: 0.45)
for (i, s) in (12..<16).enumerated() { sn(st(4, Double(s)), 0.22 + 0.08 * Double(i), pitch: 1.05 + 0.03 * Double(i)) }
// ---- bars 5-6: groove; every agent tab is clicked on a kick
for bar in [5, 6] {
	for s in [0.0, 8.0, 11.0] { k(st(bar, s), 0.95) }
	for s in [4.0, 12.0] { sn(st(bar, s), 0.66) }
	hats16(bar, 0.26)
	bassline(bar, [(0, 4, 0), (8, 3, 0), (11, 3, 0), (14, 2, 12)], 0.58)
	for s in [2.0, 6.0, 10.0, 14.0] { chordStab(st(bar, s), padNotes(BAR_CH[bar]).map { $0 + 12 }, S16 * 1.4, peak: 2800, 0.42) }
	hook(bar, 0.17, bright: 0.7)
}
// ---- bar 7: build while the plugins lift out; the card falls on the last kick
for s in [0.0, 4.0, 8.0, 12.0] { k(st(7, s), 0.9) }
for (i, s) in stride(from: 0, to: 8, by: 2).enumerated() { sn(st(7, Double(s)), 0.22 + 0.04 * Double(i)) }
for (i, s) in (8..<15).enumerated() { sn(st(7, Double(s)), 0.4 + 0.07 * Double(i), pitch: 1 + 0.05 * Double(i)) }
for (i, s) in [0.0, 4.0, 8.0, 12.0].enumerated() { chordStab(st(7, s), padNotes(.eb).map { $0 + 12 }, S16 * 2, peak: 1500 + 1500 * Double(i), 0.38) }
bass.add(bassNote(root(.eb), BEAT * 1.9, 1), at: st(7, 0), gain: 0.55)
bass.add(bassNote(root(.eb), BEAT * 1.9, 1), at: st(7, 8), gain: 0.55)
do { let (l, r) = riser(st(7, 15) - st(7, 3), 0.3); fx.addSt(l, r, at: st(7, 3), gain: 1) }
// ---- bar 9 tail: a roll into the final hit
for (i, s) in (8..<11).enumerated() { sn(st(9, Double(s)), 0.45 + 0.15 * Double(i), pitch: 1.1 + 0.08 * Double(i)) }
// ---- the final hit on "give your agents persistent memory"
do {
	let (l, r) = crash(0.5); fx.addSt(l, r, at: HEAD_T, gain: 1)
	fx.add(boom(0.5), at: HEAD_T, gain: 1)
	KICKS.append(HEAD_T); drums.add(KICK, at: HEAD_T, gain: 1)
	let fm9: [Double] = [53, 56, 60, 63, 67]
	chordStab(HEAD_T, fm9, 2.4, peak: 2600, 0.55, decay: 1.1)
	chordPad(HEAD_T, fm9.map { $0 + 12 }, 2.4, cutoff: 2200, 0.35, attack: 0.02)
	bass.add(bassNote(root(.fm), 0.9, 1), at: HEAD_T, gain: 0.45)
	plk(HEAD_T, 77, 0.6, bright: 0.8, 0.22)
	plk(HEAD_T + 2 * S16, 84, 0.4, bright: 0.7, 0.12)
	plk(HEAD_T + 4 * S16, 89, 0.6, bright: 0.6, 0.1)
}

// ================================================================ sound effects, on the picture's events
let CLICK2 = sample("click_002"), CLICK3 = sample("click_003"), CLICK5 = sample("click_005")
let KEYS = ["switch12", "switch13", "switch14"].map { sample($0) }
let PASTE_KEY = sample("switch12"), ENTER_KEY = sample("switch33")
func fxs(_ x: [Float], _ t: Double, _ g: Double, pan: Double = 0, rev: Double = 0.12) {
	sfx.add(x, at: t, gain: g, pan: pan); revSend.add(x, at: t, gain: g * rev)
}
fxs(CLICK2, CLICK - 0.004, 0.8)                                        // copy
fxs(bell(96, 1, decay: 0.12), CLICK + 0.03, 0.10, pan: 0.2)              // the check
fxs(PASTE_KEY, FLY_B - 0.004, 0.7)                                      // lands as the pasted command
fxs(ENTER_KEY, ENTER - 0.168, 0.85)                                     // enter (the sample's thock is 168 ms in)
for i in 0..<4 { fxs(pop([84, 87, 89, 92][i], 1), rowT(2 + i) + 0.06, 0.32, pan: 0.35) }   // each detected agent
fxs(CLICK3, rowT(9), 0.35)                                              // install all ready integrations
fxs(bell(89, 1, decay: 0.6), OAUTH_A, 0.21, pan: -0.1, rev: 0.25)      // one approval
fxs(bell(96, 1, decay: 0.5), OAUTH_A + 0.07, 0.14, pan: 0.1, rev: 0.25)
for i in 0..<4 { fxs(pop([77, 80, 84, 87][i], 1), OAUTH_A + BEAT + Double(i) * S16, 0.3, pan: -0.3 + 0.2 * Double(i)) }
fxs(pop(84, 1), TABS_T + 3 * BEAT, 0.3)                                // claude code pops out
for (i, ct) in CLK.enumerated() {
	fxs(CLICK5, ct - 0.004, 0.75)                                       // the tab click
	fxs(pop([87, 89, 92, 96][i], 1), ct + 0.02, 0.28, pan: 0.15)        // its logo pops
	for j in 0..<8 {                                                    // its commands type themselves
		let tt = ct + 0.15 + Double(j) * 0.046 + 0.006 * rnd()
		fxs(KEYS[Int(abs(rnd()) * 2.999)], tt, 0.36 + 0.06 * rnd(), pan: 0.1 * rnd(), rev: 0.04)
	}
}
for kk in 0..<LIFT_PILLS.count { fxs(pop([77, 80, 82, 84, 87, 89, 92][kk], 1), liftT(kk), 0.32, pan: -0.6 + 0.2 * Double(kk)) }
fxs(thump(1), END, 0.55)                                                // the card drops (thump 1 of 2)
fxs(thump(1), HEAD_T, 0.5)                                              // the line lands (thump 2 of 2)
fxs(bell(77, 1, decay: 1.2), LOCK_T, 0.19, rev: 0.3)                    // lockup
fxs(bell(84, 1, decay: 1.0), LOCK_T + 0.05, 0.12, rev: 0.3)

// ================================================================ mix
duck(&bass, depth: 0.55); duck(&chords, depth: 0.6); duck(&leadB, depth: 0.25)
let (dL, dR) = pingpong(dlySend.L, dlySend.R, time: 3 * S16, fb: 0.38)
var dly = Bus(NS); dly.L = dL; dly.R = dR
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
duck(&rev, depth: 0.35)

var music = Bus(NS)
music.mix(drums, 0.95); music.mix(bass, 0.6); music.mix(chords, 1.15); music.mix(leadB, 1.25); music.mix(fx, 0.75)
music.mix(dly, 0.28); music.mix(rev, 1.0)
compress(&music, thr: -12, ratio: 2.2, att: 0.005, rel: 0.12)
for i in 0..<NS { music.L[i] = Float(tanh(1.1 * Double(music.L[i])) / tanh(1.1)); music.R[i] = Float(tanh(1.1 * Double(music.R[i])) / tanh(1.1)) }
// fade the tail so the held end card closes in silence
let fadeA = Int((T_END - 1.2) * SR)
for i in fadeA..<NS { let k = Float(1 - Double(i - fadeA) / Double(NS - fadeA)); music.L[i] *= k * k; music.R[i] *= k * k; sfx.L[i] *= k; sfx.R[i] *= k }

var master = Bus(NS)
master.mix(music, 0.82); master.mix(sfx, 1.0)
limit(&master, ceiling: 0.89)

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
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav("music", music); writeWav("sfx", sfx); writeWav("mix", master)
// report: peak, and loudness per half second so the drops are visibly the loudest parts
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(master.L[i]), abs(master.R[i])) }
print(String(format: "peak %.2f dBFS, kicks %d", 20 * log10(Double(pk)), KICKS.count))
var line = ""
let w = Int(0.5 * SR)
for s in stride(from: 0, to: NS - w, by: w) {
	var e = 0.0
	for i in s..<(s + w) { e += Double(master.L[i] * master.L[i] + master.R[i] * master.R[i]) / 2 }
	line += String(format: "%4.1f:%5.1f  ", Double(s) / SR, 10 * log10(e / Double(w) + 1e-12))
}
print(line)
