// hp.swift: a 12 dB/oct high-pass over a whole bus (the same helper as the learner film's trap.swift)
func highpass(_ b: inout Bus, _ fc: Double) {
	var fl = SVF(), fr = SVF()
	for i in 0..<b.L.count { b.L[i] = Float(fl.step(Double(b.L[i]), fc, 0.7).hp); b.R[i] = Float(fr.step(Double(b.R[i]), fc, 0.7).hp) }
}
