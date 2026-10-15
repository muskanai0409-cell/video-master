// ================================================================ the skull: an anatomical human skull in lateral view
// Drawn here from anatomy (no image traced): the cranium, the brow ridge and nasal bones, the maxilla and teeth, the
// mandible with its angle and ramus, the zygomatic arch, the ear canal, the mastoid process. Units are a 1000-unit box,
// y down, facing right. It is rasterised once into a mask; a blurred copy gives the relief that the key light shades,
// and the features (the orbit, the arch, the teeth, the sutures) are painted into the tone field on top.

let SK_W = 1000, SK_H = 1000
func skullPath() -> CGPath {
	let p = CGMutablePath()
	func c(_ x: CGFloat, _ y: CGFloat, _ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) {
		p.addCurve(to: CGPoint(x: x, y: y), control1: CGPoint(x: x1, y: y1), control2: CGPoint(x: x2, y: y2))
	}
	p.move(to: CGPoint(x: 450, y: 95))                         // vertex
	c(735, 215, 590, 92, 690, 145)                            // frontal bone
	c(792, 368, 775, 270, 795, 320)                           // forehead
	c(806, 412, 800, 385, 812, 400)                           // brow ridge
	c(788, 434, 802, 425, 794, 434)                           // nasion
	c(842, 499, 805, 455, 828, 480)                           // nasal bones
	c(812, 511, 846, 506, 826, 511)                           // tip of the nasal bones, edge of the aperture
	c(838, 558, 810, 534, 826, 552)                           // anterior nasal spine
	c(828, 591, 842, 570, 832, 582)                           // maxilla
	c(836, 640, 828, 605, 838, 624)                           // upper incisors
	c(830, 652, 834, 647, 832, 650)                           // the bite
	c(838, 693, 832, 663, 840, 679)                           // lower incisors
	c(846, 809, 830, 730, 852, 782)                           // the mandible's front to the chin
	c(790, 842, 842, 831, 815, 844)                           // under the chin
	c(590, 800, 720, 837, 640, 819)                           // the lower border of the mandible
	c(545, 760, 562, 790, 546, 775)                           // the angle
	c(548, 615, 540, 712, 540, 650)                           // the ramus
	c(522, 580, 552, 596, 538, 578)                           // the condyle
	c(468, 633, 505, 593, 480, 620)                           // down to the mastoid process
	c(430, 615, 455, 642, 438, 628)
	c(300, 624, 395, 605, 345, 626)                           // the cranial base
	c(180, 558, 245, 624, 205, 593)                           // occipital
	c(150, 400, 160, 518, 148, 457)                           // the back of the skull
	c(255, 170, 152, 300, 190, 210)                           // parietal
	c(450, 95, 310, 125, 380, 95)
	p.closeSubpath()
	return p
}
let SK_MASK: [UInt8] = {
	var buf = [UInt8](repeating: 0, count: SK_W * SK_H)
	buf.withUnsafeMutableBytes { raw in
		let g = CGContext(data: raw.baseAddress, width: SK_W, height: SK_H, bitsPerComponent: 8, bytesPerRow: SK_W,
		                  space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
		g.translateBy(x: 0, y: CGFloat(SK_H)); g.scaleBy(x: 1, y: -1)
		g.setFillColor(gray: 1, alpha: 1); g.addPath(skullPath()); g.fillPath()
	}
	return buf
}()
@inline(__always) func skMask(_ x: Double, _ y: Double) -> Double {
	let fx = x - 0.5, fy = y - 0.5
	let x0 = Int(fx.rounded(.down)), y0 = Int(fy.rounded(.down)), wx = fx - Double(x0), wy = fy - Double(y0)
	func m(_ a: Int, _ b: Int) -> Double { (a < 0 || b < 0 || a >= SK_W || b >= SK_H) ? 0 : Double(SK_MASK[b * SK_W + a]) / 255 }
	return (m(x0, y0) * (1 - wx) + m(x0 + 1, y0) * wx) * (1 - wy) + (m(x0, y0 + 1) * (1 - wx) + m(x0 + 1, y0 + 1) * wx) * wy
}
/// the mask blurred heavily at low resolution: the skull's dome, for the relief shading
let SKB_N = 125
let SK_BLUR: [Float] = {
	var a = [Float](repeating: 0, count: SKB_N * SKB_N)
	let step = Double(SK_W) / Double(SKB_N)
	for y in 0..<SKB_N { for x in 0..<SKB_N { a[y * SKB_N + x] = Float(skMask((Double(x) + 0.5) * step, (Double(y) + 0.5) * step)) } }
	var b = a
	for _ in 0..<4 {
		for y in 0..<SKB_N { for x in 0..<SKB_N { var s: Float = 0; for k in -3...3 { s += a[y * SKB_N + max(0, min(SKB_N - 1, x + k))] }; b[y * SKB_N + x] = s / 7 } }
		for y in 0..<SKB_N { for x in 0..<SKB_N { var s: Float = 0; for k in -3...3 { s += b[max(0, min(SKB_N - 1, y + k)) * SKB_N + x] }; a[y * SKB_N + x] = s / 7 } }
	}
	return a
}()
@inline(__always) func skBlur(_ fx: Double, _ fy: Double) -> Double {
	let gx = fx / Double(SK_W) * Double(SKB_N) - 0.5, gy = fy / Double(SK_H) * Double(SKB_N) - 0.5
	if gx < 0 || gy < 0 || gx >= Double(SKB_N - 1) || gy >= Double(SKB_N - 1) { return 0 }
	let x0 = Int(gx), y0 = Int(gy), wx = gx - Double(x0), wy = gy - Double(y0)
	let a = Double(SK_BLUR[y0 * SKB_N + x0]) * (1 - wx) + Double(SK_BLUR[y0 * SKB_N + x0 + 1]) * wx
	let b = Double(SK_BLUR[(y0 + 1) * SKB_N + x0]) * (1 - wx) + Double(SK_BLUR[(y0 + 1) * SKB_N + x0 + 1]) * wx
	return a * (1 - wy) + b * wy
}
@inline(__always) func ell(_ x: Double, _ y: Double, _ cx: Double, _ cy: Double, _ rx: Double, _ ry: Double) -> Double {
	let dx = (x - cx) / rx, dy = (y - cy) / ry
	return (dx * dx + dy * dy).squareRoot()
}
/// distance from a point to a segment
@inline(__always) func segD(_ x: Double, _ y: Double, _ ax: Double, _ ay: Double, _ bx: Double, _ by: Double) -> Double {
	let vx = bx - ax, vy = by - ay, wx = x - ax, wy = y - ay
	let u = max(0, min(1, (wx * vx + wy * vy) / (vx * vx + vy * vy)))
	let dx = wx - vx * u, dy = wy - vy * u
	return (dx * dx + dy * dy).squareRoot()
}
let SK_LIGHT: (Double, Double, Double) = { let v = (0.5, -0.62, -0.6); let n = (v.0 * v.0 + v.1 * v.1 + v.2 * v.2).squareRoot(); return (v.0 / n, v.1 / n, v.2 / n) }()
/// How much light the skull returns at a point (0..1): bone lit from the upper front, with the orbit, the temporal
/// fossa, the gaps around the zygomatic arch, the ear canal and the gaps between the teeth in shadow.
func skullTone(_ x: Double, _ yIn: Double) -> Double {
	let m = skMask(x, yIn)
	if m <= 0.001 { return 0 }
	let y = yIn <= 434 ? yIn : 434 + (yIn - 434) / 0.88          // features are placed in the uncompressed face
	let e = 7.0, R = 140.0
	let hx = (skBlur(x + e, yIn) - skBlur(x - e, yIn)) / (2 * e), hy = (skBlur(x, yIn + e) - skBlur(x, yIn - e)) / (2 * e)
	var n = (-R * hx * 1.5, -R * hy * 1.5, -1.0)
	let nl = (n.0 * n.0 + n.1 * n.1 + n.2 * n.2).squareRoot(); n = (n.0 / nl, n.1 / nl, n.2 / nl)
	let lam = max(0, n.0 * SK_LIGHT.0 + n.1 * SK_LIGHT.1 + n.2 * SK_LIGHT.2)
	let h = skBlur(x, yIn)
	var l = 0.16 + 0.66 * pow(lam, 1.3)
	l += 0.22 * pow(max(0, 1 - h), 2) * max(0, -n.0 * 1.2 - n.1 * 0.2)      // a rim on the back of the skull
	// the temporal fossa: a soft shadow on the side of the head, above the arch
	l *= 1 - 0.32 * max(0, 1 - ell(x, y, 560, 470, 120, 80))
	// the orbit: deep shadow, with a lit margin
	let o = ell(x, y, 714, 470, 64, 54)
	l *= o < 1 ? 0.08 + 0.25 * smooth((o - 0.7) / 0.3) : 1
	l += 0.16 * exp(-pow((o - 1.1) / 0.12, 2))
	// the nasal aperture's edge
	let na = ell(x, y, 815, 545, 16, 28)
	if na < 1 { l *= 0.2 + 0.6 * smooth((na - 0.6) / 0.4) }
	// the zygomatic arch: a bright bar, with shadow above and below it
	let za = segD(x, y, 652, 552, 468, 576)
	l += 0.26 * exp(-pow(za / 8, 2))
	l *= 1 - 0.32 * exp(-pow((za - 19) / 8, 2)) * (x > 470 && x < 650 ? 1 : 0)
	// the cheekbone under the orbit
	l += 0.25 * max(0, 1 - ell(x, y, 690, 548, 48, 26))
	// the ear canal and the mastoid process
	let ea = ell(x, y, 488, 598, 17, 19)
	if ea < 1.0 { l *= 0.12 + 0.6 * smooth((ea - 0.55) / 0.45) }
	l += 0.18 * max(0, 1 - ell(x, y, 470, 640, 18, 26))
	// the notch between the coronoid and the condyle, and the ramus edge
	l *= 1 - 0.35 * max(0, 1 - ell(x, y, 575, 640, 26, 32))
	// teeth: upper and lower rows of crowns (narrow incisors at the front, wide molars at the back), rounded at the bite,
	// set in a darker band of alveolar bone
	if x > 690 && x < 840 && y > 600 && y < 742 {
		let edges: [Double] = [840, 826, 811, 795, 778, 759, 737, 714, 690]
		var j = 0
		while j < edges.count - 1 && x < edges[j + 1] { j += 1 }
		let x1 = edges[j], x0 = edges[min(j + 1, edges.count - 1)]
		let u = (x - x0) / max(1, x1 - x0)                                // 0..1 across this tooth
		let upper = y < 677
		let crownY = upper ? (y - 612) / 58 : (734 - y) / 50              // 0 at the gum, 1 at the bite
		if crownY > -0.25 && crownY < 1.0 {
			let round = 1 - pow(max(0, crownY - 0.7) / 0.3, 2) * pow(abs(u - 0.5) * 2, 2) * 1.6
			let body = smooth((0.5 - abs(u - 0.5)) / 0.08) * max(0, round)
			let gum = crownY < 0 ? 0.55 : 1
			l = (0.18 + 0.7 * body) * gum
		}
	}
	if x > 690 && x < 840 { l *= 1 - 0.65 * exp(-pow((y - 676) / 4, 2)) }
	// the mental foramen
	if ell(x, y, 790, 800, 9, 7) < 1 { l *= 0.4 }
	// sutures: the coronal (front of the parietal) and squamosal (the arc over the temporal bone), thin and faint
	let cs = abs(x - (560 + 0.12 * (y - 105) + 6 * sin(y * 0.11)))
	if y > 105 && y < 420 { l *= 1 - 0.2 * exp(-pow(cs / 2.2, 2)) }
	return m * max(0, min(1, l))
}
func hash01(_ a: Int, _ b: Int = 0) -> Double {
	var x = UInt64(bitPattern: Int64(a &* 73856093 ^ b &* 19349663)) &+ 0x9e3779b97f4a7c15
	x = (x ^ (x >> 30)) &* 0xbf58476d1ce4e5b9; x = (x ^ (x >> 27)) &* 0x94d049bb133111eb; x ^= x >> 31
	return Double(x >> 11) / Double(1 << 53)
}
