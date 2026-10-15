// reel.swift: the media reel. One sunlit gallery (scene.metal), one continuous camera move, and the medium the
// room is rendered in changes on the bar: light, engraving, type (ASCII in Geist Mono), survey lines, risograph,
// recursion (Droste), then light again for the ending, where the official lockup is vinyl lettering on the wall.
// Usage: swiftc -O reel.swift -o reel
//   ./reel stills <t> [t ...]      PNG stills into stills/
//   ./reel raw [t0] [t1]           BGRA frames on stdout (W x H at FPS)
// Env: W, H (default 1920 x 1080), FPS (60), SPP (samples per pixel side, 2).
import Foundation
import Metal
import CoreGraphics
import CoreText
import CoreImage
import ImageIO
import UniformTypeIdentifiers

let ENV = ProcessInfo.processInfo.environment
let W = Int(ENV["W"] ?? "1920")!, H = Int(ENV["H"] ?? "1080")!
let FPS = Double(ENV["FPS"] ?? "60")!
let SPP = Float(ENV["SPP"] ?? "2")!
let SC = Double(H) / 1080.0
let HERE = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
func log(_ s: String) { FileHandle.standardError.write((s + "\n").data(using: .utf8)!) }

// ================================================================ timeline: 100 BPM (the Chill Melody kit); one bar per medium
let BPM = 100.0, BAR = 240.0 / BPM
func bar(_ k: Double) -> Double { k * BAR }
enum Medium: Int { case light = 0, engraving = 1, ascii = 2, survey = 3, riso = 4, droste = 5 }
struct Seg { let t0: Double; let t1: Double; let m: Medium }
let SEGS: [Seg] = [
	Seg(t0: 0, t1: bar(1), m: .light),
	Seg(t0: bar(1), t1: bar(2), m: .engraving),
	Seg(t0: bar(2), t1: bar(3), m: .ascii),
	Seg(t0: bar(3), t1: bar(4), m: .survey),
	Seg(t0: bar(4), t1: bar(5), m: .riso),
	Seg(t0: bar(5), t1: bar(6), m: .droste),
	Seg(t0: bar(6), t1: 1e9, m: .light),
]
let HOLD = bar(7.4)                       // camera and sun at rest from here: the decoded frames are identical
let END = bar(8) + 0.6
func segAt(_ t: Double) -> Seg {
	if let f = ENV["FORCE"], let m = Medium(rawValue: Int(f)!) { return Seg(t0: 0, t1: 1e9, m: m) }
	return SEGS.first { t >= $0.t0 && t < $0.t1 } ?? SEGS.last!
}

// ================================================================ the final camera (also the paint projector)
// The sculpture's front face is parallel to the final image plane, so the mark is imaged without distortion; the
// camera is shifted sideways (not turned) to put it on the left. Its size and place come from the lockup geometry
// (brand.md): mark 588x480, gap 230, wordmark 3182x381 with its top 99 below the mark top.
typealias V3 = SIMD3<Double>
let MROT = 0.34, MS = 1.30, HT = 0.115, PT = 0.40
let MC = V3(0, PT + 0.5 * MS - 0.003, 0)
let NM = V3(-sin(MROT), 0, cos(MROT))                       // the mark's front normal in world space
func cross3(_ a: V3, _ b: V3) -> V3 { V3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x) }
func norm3(_ a: V3) -> V3 { a / (a * a).sum().squareRoot() }
let FIN_F = Double(ENV["FIN_F"] ?? "1.45")!                  // final focal length (frame heights)
let MARK_PX = Double(ENV["MARK_PX"] ?? "176")! * SC          // the mark's height in the final frame
let LOCK_W = 4000.0 / 480.0 * MARK_PX
let MARK_LEFT = (Double(W) - LOCK_W) / 2, MARK_TOP = Double(H) * 0.43 - MARK_PX / 2
let FIN_FW = -NM, FIN_RT = norm3(cross3(-NM, V3(0, 1, 0))), FIN_UP = cross3(FIN_RT, -NM)
let FIN_RO: V3 = {
	let zFace = MS * FIN_F * Double(H) / MARK_PX
	let markCX = MARK_LEFT + 588.0 / 480.0 * MARK_PX / 2, markCY = MARK_TOP + MARK_PX / 2
	let lx = -(markCX - Double(W) / 2) / (FIN_F * Double(H)) * zFace
	let ly = (markCY - Double(H) / 2) / (FIN_F * Double(H)) * zFace
	return MC + (zFace + HT) * NM + FIN_RT * lx + FIN_UP * ly
}()
let FIN_TA = FIN_RO + FIN_FW * 8

// ================================================================ camera: a cubic through timed keys (C1 in time)
struct Key { let t: Double; let ro: V3; let ta: V3; let f: Double }
let KEYS: [Key] = [
	// the main section looks from the right towards the left half of the room, so the paint stays out of shot
	// the sculpture faces front-left; the main section stays within about 25 degrees of its face so the mark reads
	Key(t: 0.0,      ro: V3(-1.05, 0.72, 2.35), ta: V3(0.05, 1.12, 0.00), f: 2.20),
	Key(t: bar(1),   ro: V3(-1.18, 0.92, 2.85), ta: V3(0.03, 1.06, 0.00), f: 2.25),
	Key(t: bar(2),   ro: V3(-0.80, 1.08, 3.15), ta: V3(0.03, 1.04, -0.05), f: 2.30),
	Key(t: bar(3),   ro: V3(-0.28, 1.20, 3.30), ta: V3(0.04, 1.02, -0.10), f: 2.30),
	Key(t: bar(4),   ro: V3(0.22, 1.15, 3.22), ta: V3(0.06, 1.00, -0.15), f: 2.30),
	Key(t: bar(5),   ro: V3(0.42, 1.02, 3.40), ta: V3(0.08, 1.00, -0.25), f: 2.25),
	Key(t: bar(6),   ro: V3(0.42, 1.00, 3.75), ta: V3(0.10, 1.00, -0.35), f: 2.20),
]
// From the cut at bar 6 the camera pulls back to the final camera in log space (howseen's rule, via lane C): the
// distance to the sculpture grows by a constant ratio per frame, fast off the cut and settling into the hold.
let PULL_T0 = bar(6)
func pullBack(_ t: Double) -> (ro: V3, ta: V3, f: Double) {
	let a = KEYS.last!
	let u = max(0, min(1, (t - PULL_T0) / (HOLD - PULL_T0)))
	let e = 1 - pow(1 - u, 3)                                                   // ease out: quick off the cut, a long settle
	let d0 = ((a.ro - MC) * (a.ro - MC)).sum().squareRoot(), d1 = ((FIN_RO - MC) * (FIN_RO - MC)).sum().squareRoot()
	let d = d0 * pow(d1 / d0, e)
	let k = (d - d0) / (d1 - d0)                                                // log-spaced progress along the move
	let ro = a.ro + (FIN_RO - a.ro) * k, ta = a.ta + (FIN_TA - a.ta) * k
	let f = exp(log(a.f) + (log(FIN_F) - log(a.f)) * k)
	return (ro, ta, f)
}
func cam(_ t: Double) -> (ro: V3, ta: V3, f: Double) {
	if t >= PULL_T0 { return pullBack(t) }
	let tc = min(max(t, KEYS.first!.t), KEYS.last!.t)
	var i = 0
	while i < KEYS.count - 2 && tc > KEYS[i + 1].t { i += 1 }
	let a = KEYS[i], b = KEYS[i + 1]
	func tan(_ k: Int, _ v: (Key) -> V3) -> V3 {
		if k == 0 { return (v(KEYS[1]) - v(KEYS[0])) / (KEYS[1].t - KEYS[0].t) * 0.6 }
		if k == KEYS.count - 1 { return (v(KEYS[k]) - v(KEYS[k - 1])) / (KEYS[k].t - KEYS[k - 1].t) }
		return (v(KEYS[k + 1]) - v(KEYS[k - 1])) / (KEYS[k + 1].t - KEYS[k - 1].t)
	}
	let h = b.t - a.t, u = (tc - a.t) / h
	let h00 = 2 * u * u * u - 3 * u * u + 1, h10 = u * u * u - 2 * u * u + u, h01 = -2 * u * u * u + 3 * u * u, h11 = u * u * u - u * u
	func herm(_ v: (Key) -> V3) -> V3 { h00 * v(a) + h10 * h * tan(i, v) + h01 * v(b) + h11 * h * tan(i + 1, v) }
	let f = a.f + (b.f - a.f) * (h01)
	return (herm { $0.ro }, herm { $0.ta }, f)
}

// ================================================================ Metal
struct U {
	var ro: SIMD4<Float>; var ta: SIMD4<Float>; var lens: SIMD4<Float>; var misc: SIMD4<Float>; var look: SIMD4<Float>
	var pc: SIMD4<Float>; var pfw: SIMD4<Float>; var prt: SIMD4<Float>; var pup: SIMD4<Float>
	var rev: SIMD4<Float>
	var res: SIMD2<Float>; var pad: SIMD2<Float>
}
let dev = MTLCreateSystemDefaultDevice()!
let queue = dev.makeCommandQueue()!
let lib: MTLLibrary = {
	do { return try dev.makeLibrary(source: try String(contentsOf: HERE.appendingPathComponent("scene.metal"), encoding: .utf8), options: nil) }
	catch { log("shader compile error:\n\(error)"); exit(1) }
}()
let psoRender = try! dev.makeComputePipelineState(function: lib.makeFunction(name: "render")!)
let psoCells = try! dev.makeComputePipelineState(function: lib.makeFunction(name: "cells")!)
func tex(_ fmt: MTLPixelFormat, _ w: Int, _ h: Int, mips: Bool = false) -> MTLTexture {
	let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: fmt, width: w, height: h, mipmapped: mips)
	d.usage = [.shaderRead, .shaderWrite]; d.storageMode = .shared
	return dev.makeTexture(descriptor: d)!
}
// the mark's exact field (markfield.swift)
let FN = 1024
let fieldTex: MTLTexture = {
	let t = tex(.r32Float, FN, FN)
	let d = try! Data(contentsOf: HERE.appendingPathComponent("mark_exact.f32"))
	d.withUnsafeBytes { t.replace(region: MTLRegionMake2D(0, 0, FN, FN), mipmapLevel: 0, withBytes: $0.baseAddress!, bytesPerRow: FN * 4) }
	return t
}()

// ================================================================ type: Geist (the brand's face), registered from fonts/
for f in ["Geist.ttf", "GeistMono.ttf"] { CTFontManagerRegisterFontsForURL(HERE.appendingPathComponent("fonts/\(f)") as CFURL, .process, nil) }
func font(_ family: String, _ size: CGFloat, _ wght: Double) -> CTFont {
	let desc = CTFontDescriptorCreateWithAttributes([kCTFontFamilyNameAttribute: family, kCTFontVariationAttribute: [0x77676874: wght]] as CFDictionary)
	return CTFontCreateWithFontDescriptor(desc, size, nil)
}
func line(_ s: String, _ f: CTFont, _ c: CGColor, track: CGFloat = 0) -> CTLine {
	var a: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTFontAttributeName as String): f, NSAttributedString.Key(kCTForegroundColorAttributeName as String): c]
	if track != 0 { a[NSAttributedString.Key(kCTKernAttributeName as String)] = track }
	return CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: a))
}
func loadImage(_ name: String) -> CGImage {
	let src = CGImageSourceCreateWithURL(HERE.appendingPathComponent(name) as CFURL, nil)!
	return CGImageSourceCreateImageAtIndex(src, 0, nil)!
}

// the slide: the end card in final-frame pixels. R = the wordmark (painted in the sculpture's blue), G = the line
// under it (painted in ink). The mark itself is left empty: the sculpture stands there.
let slideTex: MTLTexture = {
	var px = [UInt8](repeating: 0, count: W * H * 2)
	var r = [UInt8](repeating: 0, count: W * H), g = r
	func draw(_ buf: inout [UInt8], _ body: (CGContext) -> Void) {
		buf.withUnsafeMutableBytes { raw in
			let c = CGContext(data: raw.baseAddress, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
			c.setFillColor(gray: 0, alpha: 1); c.fill(CGRect(x: 0, y: 0, width: W, height: H))
			c.interpolationQuality = .high
			body(c)
		}
	}
	let k = MARK_PX / 480.0
	draw(&r) { c in
		c.draw(loadImage("lock_word.png"), in: CGRect(x: MARK_LEFT + 818 * k, y: Double(H) - (MARK_TOP + 99 * k) - 381 * k, width: 3182 * k, height: 381 * k))
	}
	draw(&g) { c in
		let l = line("memory and continual learning for agents", font("Geist", CGFloat(40 * SC), 450), CGColor(gray: 1, alpha: 1), track: CGFloat(-0.3 * SC))
		let w = CTLineGetTypographicBounds(l, nil, nil, nil)
		c.textPosition = CGPoint(x: (Double(W) - w) / 2, y: Double(H) - (MARK_TOP + MARK_PX + 104 * SC))
		CTLineDraw(l, c)
	}
	for i in 0..<(W * H) { px[2 * i] = r[i]; px[2 * i + 1] = g[i] }
	let t = tex(.rg8Unorm, W, H, mips: true)
	t.replace(region: MTLRegionMake2D(0, 0, W, H), mipmapLevel: 0, withBytes: px, bytesPerRow: W * 2)
	let cb = queue.makeCommandBuffer()!, bl = cb.makeBlitCommandEncoder()!
	bl.generateMipmaps(for: t); bl.endEncoding(); cb.commit(); cb.waitUntilCompleted()
	return t
}()

let outTex = tex(.rgba16Float, W, H)
let CW = (15.0 * SC).rounded(), CH = (28.0 * SC).rounded()
let COLS = Int(Double(W) / CW), ROWS = Int(Double(H) / CH)
let cellTex0 = tex(.rgba16Float, COLS, ROWS), cellTex1 = tex(.rgba32Float, COLS, ROWS)

let PAINT_T0 = bar(6.35), PAINT_T1 = bar(7.0), LINE_T0 = bar(7.05), LINE_T1 = bar(7.35)
func ease(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }
func uniforms(_ t: Double, medium: Int, grainSeed: Double, spp: Float, rcam: Double? = nil, sunT: Double? = nil, risoSeed: Double = 0, mis: Double = 0) -> U {
	let c = cam(rcam ?? t)
	let kk = MARK_PX / 480.0
	let wx0 = MARK_LEFT + 818 * kk, wx1 = wx0 + 3182 * kk
	let pr = ease((t - PAINT_T0) / (PAINT_T1 - PAINT_T0)), lr = ease((t - LINE_T0) / (LINE_T1 - LINE_T0))
	let sunK = min(sunT ?? t, HOLD) / HOLD
	let f = medium == 5 ? 1.35 : c.f                                          // the mirror room cuts to a wide lens
	return U(ro: SIMD4(Float(c.ro.x), Float(c.ro.y), Float(c.ro.z), Float(f)),
	         ta: SIMD4(Float(c.ta.x), Float(c.ta.y), Float(c.ta.z), 0),
	         lens: SIMD4(0, 4, spp, Float(medium)),
	         misc: SIMD4(Float(min(t, HOLD)), Float(grainSeed), Float(CW), Float(CH)),
	         look: SIMD4(Float(sunK), 1.0, Float(risoSeed), Float(mis * SC)),
	         pc: SIMD4(Float(FIN_RO.x), Float(FIN_RO.y), Float(FIN_RO.z), Float(FIN_F)),
	         pfw: SIMD4(Float(FIN_FW.x), Float(FIN_FW.y), Float(FIN_FW.z), Float(W)),
	         prt: SIMD4(Float(FIN_RT.x), Float(FIN_RT.y), Float(FIN_RT.z), Float(H)),
	         pup: SIMD4(Float(FIN_UP.x), Float(FIN_UP.y), Float(FIN_UP.z), 0),
	         rev: SIMD4(Float(pr), Float(lr), Float(wx0), Float(wx1)),
	         res: SIMD2(Float(W), Float(H)), pad: SIMD2(0, 0))
}
func dispatch(_ pso: MTLComputePipelineState, _ u: U, w: Int, h: Int, extra: MTLTexture? = nil, out: MTLTexture) {
	var uu = u
	let cb = queue.makeCommandBuffer()!, enc = cb.makeComputeCommandEncoder()!
	enc.setComputePipelineState(pso)
	enc.setTexture(out, index: 0); enc.setTexture(fieldTex, index: 1); enc.setTexture(slideTex, index: 2)
	if let e = extra { enc.setTexture(e, index: 3) }
	enc.setBytes(&uu, length: MemoryLayout<U>.stride, index: 0)
	enc.dispatchThreadgroups(MTLSize(width: (w + 15) / 16, height: (h + 15) / 16, depth: 1), threadsPerThreadgroup: MTLSize(width: 16, height: 16, depth: 1))
	enc.endEncoding(); cb.commit(); cb.waitUntilCompleted()
}
// rgba16Float -> BGRA8, with a whisper of ordered dither against banding
let bayer: [Float] = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5].map { ($0 + 0.5) / 16 - 0.5 }
func readBGRA(_ t: MTLTexture) -> [UInt8] {
	var px = [Float16](repeating: 0, count: W * H * 4)
	t.getBytes(&px, bytesPerRow: W * 8, from: MTLRegionMake2D(0, 0, W, H), mipmapLevel: 0)
	var o = [UInt8](repeating: 255, count: W * H * 4)
	DispatchQueue.concurrentPerform(iterations: H) { y in
		for x in 0..<W {
			let i = (y * W + x) * 4, d = bayer[(y & 3) * 4 + (x & 3)]
			@inline(__always) func q(_ v: Float16) -> UInt8 { UInt8(max(0, min(255, Float(v) * 255 + 0.5 + d))) }
			o[i] = q(px[i + 2]); o[i + 1] = q(px[i + 1]); o[i + 2] = q(px[i])
		}
	}
	return o
}

// ================================================================ media in Swift: ASCII type, Droste recursion
let RGB = CGColorSpace(name: CGColorSpace.sRGB)!
func bgraContext(_ buf: UnsafeMutableRawPointer) -> CGContext {
	CGContext(data: buf, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * 4, space: RGB,
	          bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
}
let monoFont = font("Geist Mono", CGFloat(24.5 * SC), 400)
let monoBold = font("Geist Mono", CGFloat(24.5 * SC), 700)
func glyph(_ f: CTFont, _ ch: Character) -> CGGlyph {
	var u = Array(String(ch).utf16), g = [CGGlyph](repeating: 0, count: u.count)
	CTFontGetGlyphsForCharacters(f, &u, &g, u.count)
	return g[0]
}
let RAMP: [Character] = Array(" .:-=+*%#")
let RAMPG = RAMP.map { glyph(monoFont, $0) }
let WORD: [Character] = Array("supermemory")
let WORDG = WORD.map { glyph(monoBold, $0) }
let EDGEG = ["-", "\\", "|", "/"].map { glyph(monoFont, Character($0)) }
func asciiFrame(_ u: U) -> [UInt8] {
	dispatch(psoCells, u, w: COLS, h: ROWS, extra: cellTex1, out: cellTex0)
	var c0 = [Float16](repeating: 0, count: COLS * ROWS * 4), c1 = [Float](repeating: 0, count: COLS * ROWS * 4)
	cellTex0.getBytes(&c0, bytesPerRow: COLS * 8, from: MTLRegionMake2D(0, 0, COLS, ROWS), mipmapLevel: 0)
	cellTex1.getBytes(&c1, bytesPerRow: COLS * 16, from: MTLRegionMake2D(0, 0, COLS, ROWS), mipmapLevel: 0)
	var buf = [UInt8](repeating: 0, count: W * H * 4)
	buf.withUnsafeMutableBytes { raw in
		let g = bgraContext(raw.baseAddress!)
		g.setFillColor(CGColor(srgbRed: 0x0b / 255, green: 0x10 / 255, blue: 0x15 / 255, alpha: 1))     // ink #0b1015
		g.fill(CGRect(x: 0, y: 0, width: W, height: H))
		let ox = (Double(W) - Double(COLS) * CW) / 2, oy = (Double(H) - Double(ROWS) * CH) / 2
		let base = CH * 0.27
		for r in 0..<ROWS {
			for c in 0..<COLS {
				let i = (r * COLS + c) * 4
				let cr = Double(c0[i]), cg = Double(c0[i + 1]), cb = Double(c0[i + 2]), tone = Double(c0[i + 3])
				let edge = Double(c1[i]), ang = Double(c1[i + 1]), mk = Double(c1[i + 2])
				var gl: CGGlyph, f = monoFont
				var col: CGColor
				let paint = Double(c1[i + 3])
				if mk > 0.5 {
					// the sculpture is set in its own name, in blue 500, brighter where the sun is on it
					gl = WORDG[(c + r * 3) % WORDG.count]; f = monoBold
					let k = min(1, tone * 2.2)
					col = CGColor(srgbRed: 0.16 + 0.42 * k * k, green: 0.44 + 0.36 * k, blue: 1.0, alpha: 1)
				} else if paint > 0.35 {
					gl = glyph(monoBold, "#"); f = monoBold
					col = CGColor(srgbRed: 0.02, green: 0.38, blue: 0.94, alpha: 1)
				} else if edge > 0.16 {
					gl = EDGEG[Int((ang * 4).rounded()) % 4]
					let k = 0.35 + 0.5 * tone
					col = CGColor(srgbRed: k * 0.95, green: k * 0.93, blue: k * 0.9, alpha: 1)
				} else {
					let tt = pow(max(0, tone - 0.18) / 0.82, 1.6)
					let k = min(RAMPG.count - 1, max(0, Int(tt * Double(RAMPG.count - 1) + 0.5)))
					if k == 0 { continue }
					gl = RAMPG[k]
					// shade is a dim warm grey, sun is paper white
					let v = 0.40 + 0.58 * tt
					col = CGColor(srgbRed: min(1, v * (cr / max(0.01, tone)) * 0.5 + v * 0.5), green: min(1, v * 0.98), blue: min(1, v * 0.92), alpha: 1)
				}
				g.setFillColor(col)
				var gg = gl
				var pos = CGPoint(x: ox + Double(c) * CW + CW * 0.04, y: Double(H) - (oy + Double(r + 1) * CH) + base)
				CTFontDrawGlyphs(f, &gg, &pos, 1, g)
			}
		}
	}
	return buf
}

let ciCtx = CIContext(mtlDevice: dev, options: [.workingColorSpace: RGB, .outputColorSpace: RGB, .cacheIntermediates: false])
func drosteFrame(_ src: [UInt8], _ t: Double) -> [UInt8] {
	var s = src
	let img = s.withUnsafeMutableBytes { raw -> CIImage in
		CIImage(bitmapData: Data(bytes: raw.baseAddress!, count: W * H * 4), bytesPerRow: W * 4, size: CGSize(width: W, height: H), format: .BGRA8, colorSpace: RGB)
	}
	let k = (t - bar(5)) / (bar(6) - bar(5))
	let f = CIFilter(name: "CIDroste")!
	f.setValue(img, forKey: kCIInputImageKey)
	// the inset: a centred frame-within-the-frame around the sculpture; one turn of the spiral per period
	let cx = Double(W) * 0.5, cy = Double(H) * 0.52, hw = Double(W) * 0.2, hh = Double(H) * 0.2
	f.setValue(CIVector(x: cx - hw, y: cy - hh), forKey: "inputInsetPoint0")
	f.setValue(CIVector(x: cx + hw, y: cy + hh), forKey: "inputInsetPoint1")
	f.setValue(1, forKey: "inputStrands")
	f.setValue(1, forKey: "inputPeriodicity")
	f.setValue(0, forKey: "inputRotation")
	f.setValue(1.0 + 1.5 * k * k, forKey: "inputZoom")
	let o = f.outputImage!.cropped(to: CGRect(x: 0, y: 0, width: W, height: H))
	var out = [UInt8](repeating: 0, count: W * H * 4)
	out.withUnsafeMutableBytes { ciCtx.render(o, toBitmap: $0.baseAddress!, rowBytes: W * 4, bounds: CGRect(x: 0, y: 0, width: W, height: H), format: .BGRA8, colorSpace: RGB) }
	return out
}

// ================================================================ the photographic medium: speed-driven motion blur, soft bloom
// Subframes over a 180-degree shutter only while the camera moves fast (the pull-back), so slow drifts stay crisp.
func cameraSpeed(_ t: Double) -> Double {
	let a = cam(t - 0.5 / FPS), b = cam(t + 0.5 / FPS)
	let d = b.ro - a.ro, e = b.ta - a.ta
	return ((d * d).sum().squareRoot() + 0.25 * (e * e).sum().squareRoot()) * FPS
}
func lightFrame(_ t: Double, medium: Int, grain: Double) -> [UInt8] {
	let v = cameraSpeed(t)
	let n = t >= HOLD ? 1 : (v > 1.2 ? 5 : (v > 0.45 ? 3 : 1))
	if n == 1 {
		dispatch(psoRender, uniforms(t, medium: medium, grainSeed: grain, spp: SPP), w: W, h: H, out: outTex)
		return bloom(readBGRA(outTex))
	}
	var acc = [Float](repeating: 0, count: W * H * 4)
	var px = [Float16](repeating: 0, count: W * H * 4)
	for k in 0..<n {
		let ts = min(HOLD, t + ((Double(k) + 0.5) / Double(n) - 0.5) * 0.5 / FPS)
		dispatch(psoRender, uniforms(ts, medium: medium, grainSeed: grain, spp: SPP), w: W, h: H, out: outTex)
		outTex.getBytes(&px, bytesPerRow: W * 8, from: MTLRegionMake2D(0, 0, W, H), mipmapLevel: 0)
		for i in 0..<(W * H * 4) { acc[i] += Float(px[i]) }
	}
	var o = [UInt8](repeating: 255, count: W * H * 4)
	let k = 1 / Float(n)
	DispatchQueue.concurrentPerform(iterations: H) { y in
		for x in 0..<W {
			let i = (y * W + x) * 4, d = bayer[(y & 3) * 4 + (x & 3)]
			o[i] = UInt8(max(0, min(255, acc[i + 2] * k * 255 + 0.5 + d)))
			o[i + 1] = UInt8(max(0, min(255, acc[i + 1] * k * 255 + 0.5 + d)))
			o[i + 2] = UInt8(max(0, min(255, acc[i] * k * 255 + 0.5 + d)))
		}
	}
	return bloom(o)
}
// a soft photographic bloom: the window and the sun patches breathe a little light into the air around them
func bloom(_ src: [UInt8]) -> [UInt8] {
	var s = src
	let img = s.withUnsafeMutableBytes { raw -> CIImage in
		CIImage(bitmapData: Data(bytes: raw.baseAddress!, count: W * H * 4), bytesPerRow: W * 4, size: CGSize(width: W, height: H), format: .BGRA8, colorSpace: RGB)
	}
	let f = CIFilter(name: "CIBloom")!
	f.setValue(img.clampedToExtent(), forKey: kCIInputImageKey)
	f.setValue(18.0 * SC, forKey: kCIInputRadiusKey)
	f.setValue(0.20, forKey: kCIInputIntensityKey)
	let o = f.outputImage!.cropped(to: CGRect(x: 0, y: 0, width: W, height: H))
	var out = [UInt8](repeating: 0, count: W * H * 4)
	out.withUnsafeMutableBytes { ciCtx.render(o, toBitmap: $0.baseAddress!, rowBytes: W * 4, bounds: CGRect(x: 0, y: 0, width: W, height: H), format: .BGRA8, colorSpace: RGB) }
	return out
}

// ================================================================ one frame
// Media hand over through a band of window light that crosses the frame on the downbeat (top right to bottom left,
// the way the sun travels in the room): the new medium is left behind the band.
let CUTS: [Double] = (1...6).map { bar(Double($0)) }
let SWEEP = 0.34
func frame(_ t: Double, index: Int) -> [UInt8] {
	if ENV["FORCE"] == nil, let c = CUTS.first(where: { abs(t - $0) < SWEEP / 2 }) {
		let a = mediumFrame(segAt(c - 0.001), t, index: index), b = mediumFrame(segAt(c + 0.001), t, index: index)
		let u = (t - (c - SWEEP / 2)) / SWEEP
		return sweep(a, b, u)
	}
	return mediumFrame(segAt(t), t, index: index)
}
func sweep(_ a: [UInt8], _ b: [UInt8], _ u: Double) -> [UInt8] {
	let e = -0.12 + 1.24 * (u < 0.5 ? 4 * u * u * u : 1 - pow(-2 * u + 2, 3) / 2)     // ease in-out across the frame
	var o = [UInt8](repeating: 255, count: W * H * 4)
	DispatchQueue.concurrentPerform(iterations: H) { y in
		let fy = Double(y) / Double(H)
		for x in 0..<W {
			let sPos = (1 - Double(x) / Double(W)) * 0.62 + fy * 0.38                    // 0 at top right, 1 at bottom left
			let m = max(0, min(1, (e - sPos) / 0.035 + 0.5))                              // 1 = the new medium
			let g = exp(-pow((sPos - e) / 0.022, 2)) * 0.30                               // the band of light itself
			let i = (y * W + x) * 4
			for ch in 0..<3 {
				let v = Double(a[i + ch]) * (1 - m) + Double(b[i + ch]) * m
				let warm = ch == 0 ? 0.86 : (ch == 1 ? 0.95 : 1.0)                         // BGRA: blue is channel 0
				o[i + ch] = UInt8(max(0, min(255, v + (255 - v) * g * warm)))
			}
		}
	}
	return o
}
var risoCache: (Int, [UInt8])? = nil
func mediumFrame(_ seg: Seg, _ t: Double, index: Int) -> [UInt8] {
	let tt = min(t, HOLD)
	let grain = t >= HOLD ? HOLD * 60 : Double(index)
	switch seg.m {
	case .light:
		return lightFrame(tt, medium: 0, grain: grain)
	case .engraving, .survey:
		dispatch(psoRender, uniforms(tt, medium: seg.m.rawValue, grainSeed: grain, spp: SPP), w: W, h: H, out: outTex)
		return readBGRA(outTex)
	case .ascii:
		// two cadences: the type steps at 15 fps while the light and grade glide (lane C, row 7)
		let tq = (t * 15).rounded(.down) / 15
		return asciiFrame(uniforms(tq, medium: 2, grainSeed: grain, spp: 1))
	case .riso:
		// a print run: 12 prints a second, each a little out of register
		let step = Int((t * 12).rounded(.down))
		if let c = risoCache, c.0 == step { return c.1 }
		let tq = Double(step) / 12
		dispatch(psoRender, uniforms(tq, medium: 4, grainSeed: Double(step), spp: SPP, risoSeed: Double(step % 97) + 0.5, mis: 2.6), w: W, h: H, out: outTex)
		let b = readBGRA(outTex)
		risoCache = (step, b)
		return b
	case .droste:
		// the climax is the infinity mirror room (medium 5); CIDroste (drosteFrame) stays in the toolbox
		return lightFrame(tt, medium: 5, grain: grain)
	}
}

func writePNG(_ bytes: [UInt8], _ path: String) {
	var b = bytes
	let img: CGImage = b.withUnsafeMutableBytes { bgraContext($0.baseAddress!).makeImage()! }
	let d = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}

let args = CommandLine.arguments
let mode = args.count > 1 ? args[1] : "stills"
if mode == "stills" {
	try? FileManager.default.createDirectory(atPath: "stills", withIntermediateDirectories: true)
	for a in args.dropFirst(2) {
		guard let t = Double(a) else { continue }
		let t0 = Date()
		writePNG(frame(t, index: Int(t * FPS)), String(format: "stills/reel_%05.2f.png", t))
		log(String(format: "t=%.2f %@ %.2fs", t, "\(segAt(t).m)", Date().timeIntervalSince(t0)))
	}
} else if mode == "raw" {
	let t0 = args.count > 2 ? Double(args[2])! : 0, t1 = args.count > 3 ? Double(args[3])! : END
	let f0 = Int((t0 * FPS).rounded()), f1 = Int((t1 * FPS).rounded())
	let out = FileHandle.standardOutput
	let start = Date()
	for f in f0..<f1 {
		out.write(Data(frame(Double(f) / FPS, index: f)))
		if f % 60 == 0 { log(String(format: "frame %d/%d  %.0fs", f, f1, Date().timeIntervalSince(start))) }
	}
}
if mode == "paintcheck" {
	var worst = 0.0, worstT = 0.0, firstT = -1.0
	let small = tex(.rgba16Float, W, H)
	for f in stride(from: 0, to: Int(PAINT_T0 * FPS), by: 4) {
		let t = Double(f) / FPS
		dispatch(psoRender, uniforms(t, medium: 9, grainSeed: 0, spp: 1), w: W, h: H, out: small)
		var px = [Float16](repeating: 0, count: W * H * 4)
		small.getBytes(&px, bytesPerRow: W * 8, from: MTLRegionMake2D(0, 0, W, H), mipmapLevel: 0)
		var n = 0
		for i in 0..<(W * H) where Float(px[i * 4]) > 0.2 { n += 1 }
		let share = Double(n) / Double(W * H)
		if share > worst { worst = share; worstT = t }
		if share > 0.0005 && firstT < 0 { firstT = t }
	}
	log(String(format: "paint first visible at t=%.2f (bar %.2f)", firstT, firstT / BAR))
	log(String(format: "paint visible before it is painted on: max %.4f%% of the frame at t=%.2f", worst * 100, worstT))
}
if mode == "where" {
	// where the wordmark's paint lands: cast the slide rect's corners and edges from the projector onto the room
	log(String(format: "final camera ro (%.2f, %.2f, %.2f) f %.2f", FIN_RO.x, FIN_RO.y, FIN_RO.z, FIN_F))
	let k = MARK_PX / 480.0
	let x0 = MARK_LEFT + 818 * k, x1 = x0 + 3182 * k, y0 = MARK_TOP + 99 * k, y1 = y0 + 381 * k
	for (px, py) in [(x0, y0), (x0, y1), ((x0 + x1) / 2, y0), ((x0 + x1) / 2, y1), (x1, y0), (x1, y1), (MARK_LEFT, MARK_TOP)] {
		let uvx = (px - Double(W) / 2) / Double(H) / FIN_F, uvy = (Double(H) / 2 - py) / Double(H) / FIN_F
		let d = norm3(FIN_FW + FIN_RT * uvx + FIN_UP * uvy)
		var best = 1e9, what = ""
		for (name, tHit) in [("back z=-2", (-2.0 - FIN_RO.z) / d.z), ("right x=4", (4.0 - FIN_RO.x) / d.x), ("floor y=0", (0 - FIN_RO.y) / d.y), ("left x=-3.4", (-3.4 - FIN_RO.x) / d.x)] where tHit > 0 && tHit < best { best = tHit; what = name }
		let p = FIN_RO + d * best
		log(String(format: "screen (%4.0f, %4.0f) -> %@ at (%.2f, %.2f, %.2f)", px, py, what, p.x, p.y, p.z))
	}
}
if mode == "info" {
	// frames, the first held frame (identical from here on)
	print(Int((END * FPS).rounded()), Int((HOLD * FPS).rounded(.up)))
}
