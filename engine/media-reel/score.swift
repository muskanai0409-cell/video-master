// score.swift: the media reel's soundtrack. GarageBand's Chillwave "Chill Melody" kit (100 BPM, E major) and its
// "Pastel Colors" beats, arranged on the picture's bars, plus one small sound for each medium as it arrives.
// Licence: GarageBand's loops may be used royalty-free in your own original soundtracks (GarageBand licence, see the
// learner film's score_loops.swift note). The decoded loops live in ~/Library/Caches/video-master/loops, never in the repo.
// Build: make_audio.sh (cat timeline_audio.swift dsp.swift score.swift > snd.swift).
import Foundation

let ENVV = ProcessInfo.processInfo.environment
let LOOPDIR = ENVV["LOOPDIR"] ?? (NSHomeDirectory() + "/Library/Caches/video-master/loops")
let PRIME = 2112.0 / 44100.0                                     // AAC priming at the head of each decoded loop

struct Loop { let L: [Float]; let R: [Float]; let len: Int }
func loadLoop(_ name: String, beats: Int) -> Loop {
	let d = try! Data(contentsOf: URL(fileURLWithPath: LOOPDIR + "/" + name + ".f32"))
	let f: [Float] = d.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
	let n = f.count / 2, off = Int((PRIME * SR).rounded())
	let len = Int((Double(beats) * BEAT * SR).rounded())
	var L = [Float](repeating: 0, count: len), R = L
	for i in 0..<len where off + i < n { L[i] = f[2 * (off + i)]; R[i] = f[2 * (off + i) + 1] }
	return Loop(L: L, R: R, len: len)
}
var revSend = Bus(NS)
/// a loop locked to the film's grid (its bar 1 at t = 0), audible from t0 to t1
func layer(_ lp: Loop, _ t0: Double, _ t1: Double, _ g: Double, into b: inout Bus, fadeIn: Double = 0.01, fadeOut: Double = 0.05, rev: Double = 0.1) {
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

var intro = Bus(NS), drums = Bus(NS), bass = Bus(NS), mel = Bus(NS), fx = Bus(NS)
let pad = loadLoop("Chill_Melody_Synth_01", beats: 16), pad2 = loadLoop("Chill_Melody_Synth_02", beats: 16)
let chords = loadLoop("Chill_Melody_Guitar_Chords", beats: 16), lead = loadLoop("Chill_Melody_Lead_Guitar", beats: 8)
let bass1 = loadLoop("Chill_Melody_Bass_01", beats: 16)
let beat1 = loadLoop("Pastel_Colors_Beat_01", beats: 8), beat2 = loadLoop("Pastel_Colors_Beat_02", beats: 8)

// ---------------------------------------------------------------- the arrangement
// bar 0: the room, heard as if from the next room (pad and chords opening up); bar 1 the groove arrives with the
// engraving; bars 3-4 the lead; bar 5 (the mirror room) the second synth joins; bar 7 the lockup lands and the
// groove stops, leaving the chord to ring under the held frame.
layer(pad, 0, bar(7.0), 0.42, into: &intro, fadeIn: 0.002, rev: 0.12)
layer(chords, 0, bar(1), 0.40, into: &intro, fadeIn: 0.002)
lowpassSweep(&intro, 0, bar(1), 700, 14000)
layer(chords, bar(1), bar(7.0), 0.34, into: &mel)
layer(beat1, bar(1), bar(3), 0.62, into: &drums, rev: 0.03)
layer(beat2, bar(3), bar(5), 0.62, into: &drums, rev: 0.03)
layer(beat1, bar(5), bar(7.0), 0.66, into: &drums, rev: 0.03)
layer(bass1, bar(1), bar(7.0), 0.55, into: &bass, rev: 0)
layer(lead, bar(3), bar(5), 0.34, into: &mel, rev: 0.16)
layer(pad2, bar(5), bar(7.0), 0.30, into: &mel, rev: 0.16)
// the last chord: the kit's first bar again from bar 7, held and fading under the still frame
var tail = Bus(NS)
layer(pad, bar(7.0), T_END, 0.40, into: &tail, fadeIn: 0.004, fadeOut: 0.6, rev: 0.25)
layer(chords, bar(7.0), bar(7.5), 0.30, into: &tail, fadeIn: 0.004, fadeOut: 0.5, rev: 0.25)

// ---------------------------------------------------------------- one sound per medium, quiet, on the cut
func noiseShape(_ dur: Double, _ g: Double, f0: Double, f1: Double, q: Double, attack: Double, decay: Double, grain: Double = 0) -> [Float] {
	let n = Int(SR * dur); var o = [Float](repeating: 0, count: n); var bp = SVF()
	for i in 0..<n {
		let t = Double(i) / SR, x = t / dur
		let fc = f0 * pow(f1 / f0, x)
		var s = bp.step(rnd(), fc, q).bp
		if grain > 0 { s *= 1 + grain * (rnd() > 0.92 ? 3.0 : 0.0) }               // the tooth of paper under a tool
		o[i] = Float(s * min(1, t / attack) * exp(-t / decay) * g)
	}
	return o
}
// bar 1, engraving: a burin cutting a line
fx.add(noiseShape(0.22, 0.55, f0: 5200, f1: 2600, q: 3.0, attack: 0.004, decay: 0.09, grain: 0.8), at: bar(1), gain: 0.22, pan: -0.2)
// bar 2, type: four keystrokes on the sixteenths
for k in 0..<4 {
	let t = bar(2) + Double(k) * BEAT / 4
	fx.add(noiseShape(0.05, 0.9, f0: 3400 - 300 * Double(k), f1: 2600, q: 4.0, attack: 0.0006, decay: 0.008), at: t, gain: 0.20, pan: -0.3 + 0.2 * Double(k))
	fx.add(thump(0.25), at: t, gain: 0.05)
}
// bar 3, survey: two pencil strokes
for k in 0..<2 { fx.add(noiseShape(0.32, 0.5, f0: 2400, f1: 3600, q: 1.6, attack: 0.05, decay: 0.12, grain: 0.5), at: bar(3) + Double(k) * BEAT * 0.75, gain: 0.16, pan: 0.25 - 0.5 * Double(k)) }
// bar 4, riso: the print drum turns and a sheet lands
fx.add(thump(0.8), at: bar(4), gain: 0.16)
fx.add(noiseShape(0.18, 0.6, f0: 1800, f1: 6000, q: 0.9, attack: 0.01, decay: 0.05), at: bar(4) + 0.04, gain: 0.16, pan: 0.2)
// bar 5, the mirror room: glass
for (k, m) in [88.0, 95.0, 100.0].enumerated() {
	fx.add(bell(m, 0.5, decay: 1.4), at: bar(5) + Double(k) * 0.045, gain: 0.07, pan: -0.5 + 0.5 * Double(k))
	revSend.add(bell(m, 0.5, decay: 1.4), at: bar(5) + Double(k) * 0.045, gain: 0.25)
}
// bars 6.35-7: the brush laying the paint on, left to right
do {
	let dur = PAINT_T1 - PAINT_T0, n = Int(SR * dur)
	var o = [Float](repeating: 0, count: n); var bp = SVF(), lp = SVF()
	for i in 0..<n {
		let x = Double(i) / Double(n)
		let bristle = 0.6 + 0.4 * sin(2 * Double.pi * 31 * x * dur) * sin(2 * Double.pi * 7 * x * dur)
		let s = lp.step(bp.step(rnd(), 1400 + 900 * x, 0.8).bp, 5200, 0.7).lp
		o[i] = Float(s * bristle * sin(Double.pi * x) * 0.9)
	}
	fx.add(o, at: PAINT_T0, gain: 0.15, pan: 0)
}
// bar 7: the lockup lands: a soft E-major bell chord
for (k, m) in [76.0, 80.0, 83.0, 88.0].enumerated() {
	fx.add(bell(m, 0.5, decay: 1.6), at: bar(7.0) + Double(k) * 0.02, gain: 0.08, pan: -0.3 + 0.2 * Double(k))
	revSend.add(bell(m, 0.5, decay: 1.6), at: bar(7.0), gain: 0.2)
}

// ---------------------------------------------------------------- mix
highpass(&mel, 90); highpass(&intro, 60); highpass(&fx, 120)
let (rL, rR) = freeverb(revSend.L, revSend.R)
var rev = Bus(NS); rev.L = rL; rev.R = rR
highpass(&rev, 200)
var music = Bus(NS)
music.mix(intro, 1.0); music.mix(drums, 1.0); music.mix(bass, 1.0); music.mix(mel, 1.0); music.mix(tail, 1.0); music.mix(fx, 1.0); music.mix(rev, 0.9)
highpass(&music, 28)
compress(&music, thr: -14, ratio: 2.0, att: 0.008, rel: 0.2)
let fadeA = Int((HOLD_T + 0.6) * SR), fadeZ = Int((T_END - 0.02) * SR)
for i in fadeA..<NS {
	let kk = i >= fadeZ ? Float(0) : Float(1 - Double(i - fadeA) / Double(fadeZ - fadeA))
	music.L[i] *= kk * kk; music.R[i] *= kk * kk
}
limit(&music, ceiling: 0.89)
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("audio"), withIntermediateDirectories: true)
writeWav("mix", music)
var pk: Float = 0
for i in 0..<NS { pk = max(pk, abs(music.L[i]), abs(music.R[i])) }
print(String(format: "score: %.0f BPM, %.2fs, peak %.2f dBFS", BPM, T_END, 20 * log10(Double(pk))))
