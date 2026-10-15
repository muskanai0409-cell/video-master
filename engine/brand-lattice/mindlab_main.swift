// mind lab: the head's tone field, and film-like dot previews (at rest, and lit) on the blue field
let t0 = Date()
_ = MIND.tone.count
FileHandle.standardError.write(String(format: "fields in %.1fs, %d synapses\n", Date().timeIntervalSince(t0), SYNAPSES.count).data(using: .utf8)!)
var grey = MIND.tone.map { UInt8(max(0, min(255, $0 * 255))) }
let gctx = grey.withUnsafeMutableBytes { raw in CGContext(data: raw.baseAddress, width: MD_N, height: MD_N, bitsPerComponent: 8, bytesPerRow: MD_N, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)! }
writePNG(gctx.makeImage()!, HERE.appendingPathComponent("stills/mind_tone.png"))
func mixc(_ a: (Double, Double, Double), _ b: (Double, Double, Double), _ t: Double) -> (Double, Double, Double) { (a.0 + (b.0 - a.0) * t, a.1 + (b.1 - a.1) * t, a.2 + (b.2 - a.2) * t) }
func hex(_ v: UInt32) -> (Double, Double, Double) { (Double((v >> 16) & 255), Double((v >> 8) & 255), Double(v & 255)) }
func preview(_ name: String, _ ml: Double, _ diamonds: Bool, _ k: Double, _ cx: Double, _ cy: Double, _ SW: Int, _ SH: Int) {
	let c = CGContext(data: nil, width: SW, height: SH, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.setFillColor(col(0x0100f5)); c.fill(CGRect(x: 0, y: 0, width: SW, height: SH))
	let P = 7.0
	let sky = hex(0x94b6ff), paper = hex(0xf4f8ff), gold = hex(0xf3c77a), latc = (48.0, 58.0, 248.0)
	var yy = P / 2
	while yy < Double(SH) {
		var xx = P / 2
		while xx < Double(SW) {
			let wx = (xx - Double(SW) / 2) / k + cx, wy = (yy - Double(SH) / 2) / k + cy
			var v = mindTone(wx, wy)
			let gl = mindSample(MIND.glow, wx, wy), wm = mindSample(MIND.warm, wx, wy)
			v += 0.2 * gl * ml
			let on = v > 0.01
			let tv = max(0.032, min(1, v))
			let s = P * (0.92 - (diamonds && on ? 0.2 : 0)) * tv.squareRoot()
			var cc = on ? mixc(sky, paper, ss(0.14, 0.6, v)) : latc
			if on { cc = mixc(cc, gold, min(0.85, wm * ml * 1.2)) }
			c.saveGState()
			c.translateBy(x: CGFloat(xx), y: CGFloat(Double(SH) - yy)); if diamonds && on { c.rotate(by: .pi / 4) }
			c.setFillColor(CGColor(colorSpace: sRGB, components: [CGFloat(cc.0 / 255), CGFloat(cc.1 / 255), CGFloat(cc.2 / 255), 1])!)
			c.fill(CGRect(x: -s / 2, y: -s / 2, width: s, height: s))
			c.restoreGState()
			xx += P
		}
		yy += P
	}
	// synapses (overlay): gold diamonds and hairline links, when lit
	if ml > 0.2 {
		c.translateBy(x: 0, y: CGFloat(SH)); c.scaleBy(x: 1, y: -1)
		func sp(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: (x - cx) * k + Double(SW) / 2, y: (y - cy) * k + Double(SH) / 2) }
		c.setStrokeColor(col(0xf3c77a, CGFloat(0.55 * ml))); c.setLineWidth(1.4)
		for s in SYNAPSES { for j in s.links { c.move(to: sp(s.x, s.y)); c.addLine(to: sp(SYNAPSES[j].x, SYNAPSES[j].y)) } }
		c.strokePath()
		for s in SYNAPSES {
			let p = sp(s.x, s.y), z = CGFloat(6 + 4 * s.phase) * CGFloat(k)
			c.saveGState(); c.translateBy(x: p.x, y: p.y); c.rotate(by: .pi / 4)
			c.setFillColor(col(s.phase > 0.5 ? 0xfaebcf : 0xf3c77a, CGFloat(ml))); c.fill(CGRect(x: -z / 2, y: -z / 2, width: z, height: z)); c.restoreGState()
		}
	}
	writePNG(c.makeImage()!, HERE.appendingPathComponent("stills/\(name).png"))
}
preview("mind_rest", 0.08, false, 1.0, 520, 520, 1100, 1000)
preview("mind_lit", 0.85, true, 1.0, 520, 520, 1100, 1000)
preview("mind_frame0", 0.6, true, 1.42, 560, 352, 1920, 868)
print("lab written")
