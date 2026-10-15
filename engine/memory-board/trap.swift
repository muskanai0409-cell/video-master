// trap.swift: voices for the v3 score, an original melodic-trap / psychedelic R&B track (no song, melody, sample or
// real voice is used: everything is synthesised here or in dsp.swift).
// - voiceLine: a wordless sung line. A breathy saw through natural vowel formants (darker than the plugins film's
//   chipmunk chops), with the quick note-to-note glides of hard pitch correction and a late, light vibrato.
// - riser: a filtered-noise swell that climbs into the drop.
// - roll: trap hi-hat rolls (16ths, triplets, 32nds).

struct VNote { let t: Double; let m: Double; let dur: Double; let v: Vowel }
func formantsN(_ v: Vowel, _ k: Double) -> [(Double, Double, Double)] {   // (Hz, Q, gain): natural values, scaled by k
	switch v {
	case .a: return [(730 * k, 6, 1.0), (1090 * k, 8, 0.55), (2440 * k, 12, 0.22)]
	case .o: return [(570 * k, 6, 1.0), (840 * k, 8, 0.5), (2410 * k, 12, 0.14)]
	case .e: return [(530 * k, 6, 1.0), (1840 * k, 9, 0.42), (2480 * k, 12, 0.22)]
	case .i: return [(300 * k, 6, 1.0), (2290 * k, 10, 0.34), (3010 * k, 12, 0.2)]
	case .u: return [(320 * k, 6, 1.0), (800 * k, 8, 0.3), (2240 * k, 12, 0.08)]
	}
}
/// One continuous sung phrase: notes glide into each other (hard-tune slides); breath noise under the voice.
func voiceLine(_ notes: [VNote], _ g: Double, glide: Double = 0.035, k: Double = 0.94, detune: Double = 0, breath: Double = 0.16, seed: Double = 0.3) -> [Float] {
	guard let first = notes.first, let last = notes.last else { return [] }
	let t0 = first.t, t1 = last.t + last.dur
	let n = Int(SR * (t1 - t0 + 0.25))
	var o = [Float](repeating: 0, count: n)
	var saw = Saw(seed), saw2 = Saw(seed + 0.37)
	var f = [SVF(), SVF(), SVF()], br = SVF()
	var idx = 0
	var mPrev = first.m, mStart = first.m, tStart = t0
	for i in 0..<n {
		let t = t0 + Double(i) / SR
		while idx + 1 < notes.count && t >= notes[idx + 1].t { mStart = mPrev; tStart = notes[idx + 1].t; idx += 1 }
		let note = notes[idx]
		// the slide: an exponential snap from the last pitch (hard pitch correction's signature)
		let m = idx == 0 ? note.m : note.m + (mStart - note.m) * exp(-(t - tStart) / glide)
		mPrev = m
		let held = t - note.t
		let vib = held > 0.32 ? 14 * sin(2 * Double.pi * 5.3 * held) * min(1, (held - 0.32) / 0.25) : 0
		let hz = mtof(m) * cents(vib + detune)
		let src = saw.next(hz) * 0.75 + saw2.next(hz * cents(-9)) * 0.25 + breath * rnd()
		// vowels blend over 70ms at each note change
		let prevV = idx > 0 ? notes[idx - 1].v : note.v
		let w = min(1, (t - note.t) / 0.07)
		let fa = formantsN(prevV, k), fb = formantsN(note.v, k)
		var y = 0.0
		for q in 0..<3 { y += f[q].step(src, lerp(fa[q].0, fb[q].0, w), fa[q].1).bp * lerp(fa[q].2, fb[q].2, w) }
		y += br.step(rnd(), 5200, 0.8).bp * breath * 0.25          // air on top
		// envelope: a soft attack per phrase, gentle dips between notes, a release at the end
		let gap = idx > 0 ? (note.t - (notes[idx - 1].t + notes[idx - 1].dur)) : 1
		let att = min(1, (t - t0) / 0.05) * (gap > 0.02 ? min(1, held / 0.03) : 1)
		let end = note.t + note.dur
		let rel = idx == notes.count - 1 && t > end ? exp(-(t - end) / 0.09) : (gap > 0.02 || t <= end ? 1 : 1)
		let swell = 0.85 + 0.15 * min(1, held / 0.4)
		o[i] = Float(tanh(1.4 * y * att * rel * swell) * g)
	}
	return o
}
/// Filtered noise climbing into the drop (not a stock riser: a band-pass sweep with a pitched ring).
func riser(_ dur: Double, _ g: Double, f0: Double = 300, f1: Double = 7000) -> ([Float], [Float]) {
	let n = Int(SR * dur)
	var L = [Float](repeating: 0, count: n), R = L
	var bl = SVF(), brr = SVF()
	for i in 0..<n {
		let x = Double(i) / Double(n)
		let fc = f0 * pow(f1 / f0, x * x)
		let env = pow(x, 1.8)
		L[i] = Float(bl.step(rnd(), fc, 2.2).bp * env * g)
		R[i] = Float(brr.step(rnd(), fc * 1.03, 2.2).bp * env * g)
	}
	return (L, R)
}
/// High-pass a whole bus (keeps pads and arps out of the 808's sub range).
func highpass(_ b: inout Bus, _ fc: Double) {
	var fl = SVF(), fr = SVF()
	for i in 0..<b.L.count { b.L[i] = Float(fl.step(Double(b.L[i]), fc, 0.7).hp); b.R[i] = Float(fr.step(Double(b.R[i]), fc, 0.7).hp) }
}
