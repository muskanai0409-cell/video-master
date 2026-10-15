// markfield.swift: an exact signed distance field of the supermemory mark, from its vector path
// (supermemory/apps/docs/images/supermemory.svg, viewBox 206 x 168). Exact distances to the polygon edges, so the
// extruded 3D sides come out smooth (an EDT of a pixel mask leaves stair-step ribs on 45-degree faces).
// Units: mark height = 1.0, mark centred on the origin, y up. The field covers [-R, R] x [-R, R], row 0 = top.
// Usage: swiftc -O markfield.swift -o markfield && ./markfield mark_exact.f32 1024
import Foundation
import simd

let a = CommandLine.arguments
let N = Int(a[2])!, R = 0.75
typealias P2 = SIMD2<Double>
func cubic(_ p0: P2, _ p1: P2, _ p2: P2, _ p3: P2, _ n: Int) -> [P2] {
	(1...n).map { i in
		let t = Double(i) / Double(n), u = 1 - t
		return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3
	}
}
// path 1 (the upper right piece), absolute SVG coordinates
var A: [P2] = [P2(205.864, 66.263), P2(129.463, 66.263), P2(129.463, 0), P2(104.779, 0), P2(104.779, 71.897)]
A += cubic(P2(104.779, 71.897), P2(104.779, 79.533), P2(107.8, 86.867), P2(113.17, 92.27), 24)
A += [P2(175.553, 155.047), P2(193.007, 137.483), P2(146.931, 91.118), P2(205.879, 91.118), P2(205.879, 66.278)]
// path 2 (the lower left piece)
var B: [P2] = [P2(12.872, 30.517), P2(58.947, 76.882), P2(0, 76.882), P2(0, 101.722), P2(76.4, 101.722), P2(76.4, 167.986),
               P2(101.085, 167.986), P2(101.085, 96.089)]
B += cubic(P2(101.085, 96.089), P2(101.085, 88.452), P2(98.064, 81.119), P2(92.695, 75.715), 24)
B += [P2(30.325, 12.953)]
// to mark units: centre (103, 84), height 168 -> 1, y up
func conv(_ p: [P2]) -> [P2] { p.map { P2(($0.x - 103.0) / 168.0, -($0.y - 84.0) / 168.0) } }
let polys = [conv(A), conv(B)]

func sdPoly(_ v: [P2], _ p: P2) -> Double {
	var d = simd_length_squared(p - v[0]), s = 1.0
	var j = v.count - 1
	for i in 0..<v.count {
		let e = v[j] - v[i], w = p - v[i]
		let h = max(0, min(1, simd_dot(w, e) / simd_dot(e, e)))
		let b = w - e * h
		d = min(d, simd_dot(b, b))
		let c1 = p.y >= v[i].y, c2 = p.y < v[j].y, c3 = e.x * w.y > e.y * w.x
		if (c1 && c2 && c3) || (!c1 && !c2 && !c3) { s = -s }
		j = i
	}
	return s * d.squareRoot()
}
var out = [Float](repeating: 0, count: N * N)
DispatchQueue.concurrentPerform(iterations: N) { row in
	let y = R - (Double(row) + 0.5) / Double(N) * 2 * R
	var line = [Float](repeating: 0, count: N)
	for col in 0..<N {
		let x = -R + (Double(col) + 0.5) / Double(N) * 2 * R
		line[col] = Float(min(sdPoly(polys[0], P2(x, y)), sdPoly(polys[1], P2(x, y))))
	}
	out.withUnsafeMutableBufferPointer { b in for c in 0..<N { b[row * N + c] = line[c] } }
}
try! out.withUnsafeBytes { Data($0) }.write(to: URL(fileURLWithPath: a[1]))
// report the extents so the scene can stand the mark on its plinth exactly
var minY = 1.0, minX = 1.0, maxX = -1.0, maxY = -1.0
for p in polys.flatMap({ $0 }) { minY = min(minY, p.y); maxY = max(maxY, p.y); minX = min(minX, p.x); maxX = max(maxX, p.x) }
print(String(format: "extent x %.4f..%.4f  y %.4f..%.4f  inside at origin: %.4f", minX, maxX, minY, maxY, out[(N / 2) * N + N / 2]))
