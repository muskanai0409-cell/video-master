// learner-1 teaser v4: your agent's memories, as supermemory draws memory (halftone on blue, orange memory tiles,
// hairline branches). They fade when the chat ends; learner-1 keeps them learning.
// 16:9 (1920x1080 design frame), 60fps, 15.5s. Everything is a pure function of t. The only images are crops of supermemory.ai's own hero film.
//
// Build:  ./make.sh (cat lib.swift timeline.swift figure.swift world.swift scene.swift main.swift > render.swift)
// Stills: SCALE=1 SUBFRAMES=1 ./render stills 0 1.5 ...   -> stills/t_*.png + stills/sheet.png

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let ENV = ProcessInfo.processInfo.environment
let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let VERTICAL = (ProcessInfo.processInfo.environment["ASPECT"] ?? "") == "9x16"
let DW: CGFloat = VERTICAL ? 1080 : 1920, DH: CGFloat = VERTICAL ? 1920 : 1080   // design frame (16:9, or 9:16 with ASPECT=9x16)
let SC: CGFloat = CGFloat(Double(ENV["SCALE"] ?? "2") ?? 2)
let PW = Int(DW * SC), PH = Int(DH * SC)
let FPS = 60.0
let SUBFRAMES = max(1, Int(ENV["SUBFRAMES"] ?? "4") ?? 4)
let SHUTTER = 0.5                                    // share of a frame the shutter is open

// ================================================================ tokens
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
func col(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
	CGColor(colorSpace: sRGB, components: [CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a])!
}
let WHITE: UInt32 = 0xffffff, INK: UInt32 = 0x0b1015, BLUE: UInt32 = 0x0a26ef   // Parthiv's blue (his film), one blue everywhere
let MUTED: UInt32 = 0x5b6270

// ================================================================ time
func bezier(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> (Double) -> Double {
	return { x in
		if x <= 0 { return 0 }
		if x >= 1 { return 1 }
		var lo = 0.0, hi = 1.0, t = x
		for _ in 0..<28 {
			t = (lo + hi) / 2
			let bx = 3 * (1 - t) * (1 - t) * t * x1 + 3 * (1 - t) * t * t * x2 + t * t * t
			if bx < x { lo = t } else { hi = t }
		}
		return 3 * (1 - t) * (1 - t) * t * y1 + 3 * (1 - t) * t * t * y2 + t * t * t
	}
}
let ease = bezier(0.2, 0, 0, 1)        // moves
let eout = bezier(0.22, 1, 0.36, 1)    // arrivals
let einout = bezier(0.65, 0, 0.35, 1)  // travel
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }
func lerpC(_ a: CGFloat, _ b: CGFloat, _ k: Double) -> CGFloat { a + (b - a) * CGFloat(k) }
func lerpP(_ a: CGPoint, _ b: CGPoint, _ k: Double) -> CGPoint { CGPoint(x: lerpC(a.x, b.x, k), y: lerpC(a.y, b.y, k)) }
func smooth(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }
func clamp01(_ x: Double) -> Double { max(0, min(1, x)) }
/// Closed-form step response with slight overshoot: one spring family for every arrival.
func spring(_ t: Double, _ start: Double, freq: Double = 2.4, zeta: Double = 0.62) -> Double {
	let tau = t - start
	if tau <= 0 { return 0 }
	let w = 2 * Double.pi * freq, wd = w * sqrt(1 - zeta * zeta)
	return 1 - exp(-zeta * w * tau) * (cos(wd * tau) + (zeta * w / wd) * sin(wd * tau))
}
/// Frame-locked time for typing, so motion blur never smears characters.
func quant(_ t: Double) -> Double { (t * FPS).rounded() / FPS }

// ================================================================ fonts + text
for f in ["Geist.ttf", "GeistMono.ttf"] {
	CTFontManagerRegisterFontsForURL(HERE.appendingPathComponent("fonts/\(f)") as CFURL, .process, nil)
}
var fontCache: [String: CTFont] = [:]
let fontLock = NSLock()
func font(_ family: String, _ size: CGFloat, _ wght: Double) -> CTFont {
	let key = "\(family)|\(size)|\(wght)"
	fontLock.lock(); defer { fontLock.unlock() }
	if let f = fontCache[key] { return f }
	let desc = CTFontDescriptorCreateWithAttributes([
		kCTFontFamilyNameAttribute: family,
		kCTFontVariationAttribute: [0x77676874: wght],
	] as CFDictionary)
	let f = CTFontCreateWithFontDescriptor(desc, size, nil)
	fontCache[key] = f
	return f
}
func sans(_ s: CGFloat, _ w: Double = 500) -> CTFont { font("Geist", s, w) }
func mono(_ s: CGFloat, _ w: Double = 400) -> CTFont { font("Geist Mono", s, w) }
func ctline(_ s: String, _ f: CTFont, _ c: CGColor, track: CGFloat = 0) -> CTLine {
	var attrs: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key(kCTFontAttributeName as String): f,
		NSAttributedString.Key(kCTForegroundColorAttributeName as String): c,
	]
	if track != 0 { attrs[NSAttributedString.Key(kCTKernAttributeName as String)] = track }
	return CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: attrs))
}
func textW(_ s: String, _ f: CTFont, track: CGFloat = 0) -> CGFloat {
	CGFloat(CTLineGetTypographicBounds(ctline(s, f, col(INK), track: track), nil, nil, nil))
}
enum Align { case left, center, right }
func text(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ color: UInt32, _ a: CGFloat, _ al: Align = .left, track: CGFloat = 0) {
	if a <= 0.003 || s.isEmpty { return }
	let l = ctline(s, f, col(color, a), track: track)
	let w = CGFloat(CTLineGetTypographicBounds(l, nil, nil, nil))
	let x0: CGFloat = al == .left ? x : (al == .center ? x - w / 2 : x - w)
	c.textPosition = CGPoint(x: x0, y: y)
	CTLineDraw(l, c)
}
/// Cut a string to fit a width, ending in an ellipsis (the console truncates long commands the same way).
func fit(_ s: String, _ f: CTFont, _ maxW: CGFloat) -> String {
	if textW(s, f) <= maxW { return s }
	var t = s
	while !t.isEmpty && textW(t + "…", f) > maxW { t.removeLast() }
	return t + "…"
}

// ================================================================ shapes
func dot(_ c: CGContext, _ p: CGPoint, _ r: CGFloat, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setFillColor(col(color, a)); c.fillEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
}
func rrectPath(_ r: CGRect, _ rad: CGFloat) -> CGPath {
	let rr = max(0, min(rad, r.width / 2 - 0.01, r.height / 2 - 0.01))
	return CGPath(roundedRect: r, cornerWidth: rr, cornerHeight: rr, transform: nil)
}
/// The macOS icon shape: a superellipse (n = 5), which is close to Apple's continuous-corner squircle.
func squircle(_ r: CGRect) -> CGPath {
	let p = CGMutablePath()
	let cx = r.midX, cy = r.midY, a = r.width / 2, b = r.height / 2
	let n = 5.0, N = 96
	for i in 0...N {
		let th = Double(i) / Double(N) * 2 * Double.pi
		let ct = cos(th), st = sin(th)
		let x = cx + a * CGFloat(copysign(pow(abs(ct), 2 / n), ct))
		let y = cy + b * CGFloat(copysign(pow(abs(st), 2 / n), st))
		if i == 0 { p.move(to: CGPoint(x: x, y: y)) } else { p.addLine(to: CGPoint(x: x, y: y)) }
	}
	p.closeSubpath()
	return p
}

// ================================================================ images
func loadImage(_ url: URL) -> CGImage? {
	guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
	return CGImageSourceCreateImageAtIndex(src, 0, [kCGImageSourceShouldCacheImmediately: true] as CFDictionary)
}
func grayMask(_ name: String) -> CGImage {
	let img = loadImage(HERE.appendingPathComponent(name))!
	let g = CGContext(data: nil, width: img.width, height: img.height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
	g.draw(img, in: CGRect(x: 0, y: 0, width: img.width, height: img.height))
	return g.makeImage()!
}
/// Paint a luminance mask (white = ink) upright in a y-down context.
func paintMask(_ c: CGContext, _ m: CGImage, _ r: CGRect, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.saveGState()
	c.translateBy(x: 0, y: r.maxY + r.minY); c.scaleBy(x: 1, y: -1)
	c.clip(to: r, mask: m)
	c.setFillColor(col(color, a)); c.fill(r)
	c.restoreGState()
}
/// Draw an image upright in a y-down context.
func drawImg(_ c: CGContext, _ img: CGImage, _ r: CGRect, _ a: CGFloat = 1) {
	if a <= 0.003 { return }
	c.saveGState()
	c.setAlpha(a)
	c.translateBy(x: 0, y: r.maxY + r.minY); c.scaleBy(x: 1, y: -1)
	c.draw(img, in: r)
	c.restoreGState()
}
// the official supermemory lockup masks (from the brand kit; same files as the earlier films)
let MARK = grayMask("lock_mark.png"), WORD = grayMask("lock_word.png")
let G_MW = 588.0, G_MH = 480.0, G_GAP = 230.0, G_WW = 3182.0, G_WH = 381.0, G_WOFF = 99.0
func markRect(center: CGPoint, height: CGFloat) -> CGRect {
	let w = height * CGFloat(G_MW / G_MH)
	return CGRect(x: center.x - w / 2, y: center.y - height / 2, width: w, height: height)
}

func makeContext(_ data: UnsafeMutableRawPointer?) -> CGContext {
	let c = CGContext(data: data, width: PW, height: PH, bitsPerComponent: 8, bytesPerRow: PW * 4, space: sRGB,
	                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.translateBy(x: 0, y: CGFloat(PH)); c.scaleBy(x: 1, y: -1)
	c.scaleBy(x: SC, y: SC)
	c.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
	c.interpolationQuality = .high
	c.setShouldSmoothFonts(false)
	return c
}
func writePNG(_ img: CGImage, _ url: URL) {
	let d = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}
