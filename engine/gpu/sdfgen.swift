// sdfgen.swift: a signed distance field of a mask image (white = inside), for 3D extrusion in a shader.
// Output: raw float32, size N x N, distances in units of the field's width (so 1.0 = full width), inside negative.
// Usage: ./sdfgen <mask.png> <out.f32> <N> [pad=0.12]
import Foundation
import CoreGraphics
import ImageIO
let a = CommandLine.arguments
let N = Int(a[3])!, pad = a.count > 4 ? Double(a[4])! : 0.12
let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: a[1]) as CFURL, nil)!
let img = CGImageSourceCreateImageAtIndex(src, 0, nil)!
// draw the mask centred into an N x N grey canvas with padding, aspect kept
var m = [UInt8](repeating: 0, count: N * N)
m.withUnsafeMutableBytes { raw in
	let g = CGContext(data: raw.baseAddress, width: N, height: N, bitsPerComponent: 8, bytesPerRow: N, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
	g.setFillColor(gray: 0, alpha: 1); g.fill(CGRect(x: 0, y: 0, width: N, height: N))
	let inner = Double(N) * (1 - 2 * pad)
	let s = inner / Double(max(img.width, img.height))
	let w = Double(img.width) * s, h = Double(img.height) * s
	g.interpolationQuality = .high
	g.draw(img, in: CGRect(x: (Double(N) - w) / 2, y: (Double(N) - h) / 2, width: w, height: h))
}
func edt(_ seed: [Bool]) -> [Double] {
	let INF = 1e12
	var g = seed.map { $0 ? 0.0 : INF }
	var f = [Double](repeating: 0, count: N), d = f, z = [Double](repeating: 0, count: N + 1), v = [Int](repeating: 0, count: N)
	func dt1() {
		var k = 0; v[0] = 0; z[0] = -INF; z[1] = INF
		for q in 1..<N {
			var s = ((f[q] + Double(q * q)) - (f[v[k]] + Double(v[k] * v[k]))) / Double(2 * q - 2 * v[k])
			while s <= z[k] { k -= 1; s = ((f[q] + Double(q * q)) - (f[v[k]] + Double(v[k] * v[k]))) / Double(2 * q - 2 * v[k]) }
			k += 1; v[k] = q; z[k] = s; z[k + 1] = INF
		}
		k = 0
		for q in 0..<N { while z[k + 1] < Double(q) { k += 1 }; d[q] = Double((q - v[k]) * (q - v[k])) + f[v[k]] }
	}
	for x in 0..<N { for y in 0..<N { f[y] = g[y * N + x] }; dt1(); for y in 0..<N { g[y * N + x] = d[y] } }
	for y in 0..<N { for x in 0..<N { f[x] = g[y * N + x] }; dt1(); for x in 0..<N { g[y * N + x] = d[x] } }
	return g.map { $0.squareRoot() }
}
let inside = m.map { $0 > 127 }
let dOut = edt(inside), dIn = edt(inside.map { !$0 })
var out = [Float](repeating: 0, count: N * N)
for i in 0..<(N * N) { out[i] = Float((inside[i] ? -(dIn[i] - 0.5) : (dOut[i] - 0.5)) / Double(N)) }
out.withUnsafeBufferPointer { try! Data(buffer: $0).write(to: URL(fileURLWithPath: a[2])) }
print("sdf \(N)x\(N) written, inside px:", inside.filter { $0 }.count)
