// console series, part 1: shared drawing library (CoreGraphics + CoreText, y-down, vector).
// Copied and extended from ../one-command-v2-src/lib.swift + film.swift helpers (tokens, text, shapes, masks,
// logos, svgPath, strokeIcon, cssText). Nothing here is console-specific; see console.swift for the console.
//
// Build (test):  cat lib.swift console.swift pages_test.swift > test.swift && swiftc -O test.swift -o test && ./test

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let FPS = 60.0

// ================================================================ colour
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
func col(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
	CGColor(colorSpace: sRGB, components: [CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a])!
}
let WHITE: UInt32 = 0xffffff, BLACK: UInt32 = 0x000000, INK: UInt32 = 0x0b1015
func mix(_ a: UInt32, _ b: UInt32, _ k: Double) -> UInt32 {
	let kk = max(0, min(1, k))
	func ch(_ v: UInt32, _ s: UInt32) -> Double { Double((v >> s) & 255) }
	let r = UInt32((ch(a, 16) + (ch(b, 16) - ch(a, 16)) * kk).rounded())
	let g = UInt32((ch(a, 8) + (ch(b, 8) - ch(a, 8)) * kk).rounded())
	let bl = UInt32((ch(a, 0) + (ch(b, 0) - ch(a, 0)) * kk).rounded())
	return (r << 16) | (g << 8) | bl
}

// ================================================================ time helpers
func bezier(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> (Double) -> Double {
	return { x in
		if x <= 0 { return 0 }
		if x >= 1 { return 1 }
		var lo = 0.0, hi = 1.0, t = x
		for _ in 0..<32 {
			t = (lo + hi) / 2
			let bx = 3 * (1 - t) * (1 - t) * t * x1 + 3 * (1 - t) * t * t * x2 + t * t * t
			if bx < x { lo = t } else { hi = t }
		}
		return 3 * (1 - t) * (1 - t) * t * y1 + 3 * (1 - t) * t * t * y2 + t * t * t
	}
}
let ease = bezier(0.2, 0, 0, 1)         // moves
let eout = bezier(0.22, 1, 0.36, 1)     // arrivals
let ease2 = bezier(0.5, 0, 0.2, 1)      // camera moves
let enterEase = bezier(0.23, 1, 0.32, 1) // the console's own section/row enter curve (0.26s)
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }
func lerpC(_ a: CGFloat, _ b: CGFloat, _ k: Double) -> CGFloat { a + (b - a) * CGFloat(k) }
func lerpP(_ a: CGPoint, _ b: CGPoint, _ k: Double) -> CGPoint { CGPoint(x: lerp(a.x, b.x, k), y: lerp(a.y, b.y, k)) }
func lerpR(_ a: CGRect, _ b: CGRect, _ k: Double) -> CGRect {
	CGRect(x: lerp(a.minX, b.minX, k), y: lerp(a.minY, b.minY, k), width: lerp(a.width, b.width, k), height: lerp(a.height, b.height, k))
}
func smooth(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }
/// Closed-form step response with slight overshoot.
func spring(_ t: Double, _ start: Double, freq: Double = 2.4, zeta: Double = 0.62) -> Double {
	let tau = t - start
	if tau <= 0 { return 0 }
	let w = 2 * Double.pi * freq, wd = w * sqrt(1 - zeta * zeta)
	return 1 - exp(-zeta * w * tau) * (cos(wd * tau) + (zeta * w / wd) * sin(wd * tau))
}
/// 0 -> 1 -> 0 over d seconds.
func bump(_ t: Double, _ t0: Double, _ d: Double = 0.5) -> CGFloat { CGFloat(sin(seg(t, t0, t0 + d) * Double.pi)) }
/// Frame-locked time for typing and rolling digits.
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
/// Text at a baseline.
func text(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ color: UInt32, _ a: CGFloat, _ al: Align = .left, track: CGFloat = 0) {
	if a <= 0.003 || s.isEmpty { return }
	let l = ctline(s, f, col(color, a), track: track)
	let w = CGFloat(CTLineGetTypographicBounds(l, nil, nil, nil))
	let x0: CGFloat = al == .left ? x : (al == .center ? x - w / 2 : x - w)
	c.textPosition = CGPoint(x: x0, y: y)
	CTLineDraw(l, c)
}
/// Baseline that centres a line box on cy, the way the browser centres a single line.
func midBase(_ f: CTFont, _ cy: CGFloat) -> CGFloat { cy + (CTFontGetAscent(f) - CTFontGetDescent(f)) / 2 }
/// Text vertically centred on cy (CSS line-box centring).
func ctext(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ cy: CGFloat, _ color: UInt32, _ a: CGFloat, _ al: Align = .left, track: CGFloat = 0) {
	text(c, s, f, x, midBase(f, cy), color, a, al, track: track)
}
/// Text positioned by its CSS line box (top + line-height).
func cssText(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ top: CGFloat, _ lh: CGFloat, _ color: UInt32, _ a: CGFloat, _ al: Align = .left) {
	ctext(c, s, f, x, top + lh / 2, color, a, al)
}
/// Several coloured runs on one line (left aligned), returns the end x.
@discardableResult
func runs(_ c: CGContext, _ parts: [(String, UInt32)], _ f: CTFont, _ x: CGFloat, _ cy: CGFloat, _ a: CGFloat, track: CGFloat = 0) -> CGFloat {
	var xx = x
	for (s, colr) in parts {
		ctext(c, s, f, xx, cy, colr, a, track: track)
		xx += textW(s, f, track: track)
	}
	return xx
}
var truncCache: [String: String] = [:]
let truncLock = NSLock()
func truncated(_ s: String, _ f: CTFont, _ maxW: CGFloat) -> String {
	let key = s + "|\(CTFontGetSize(f))|\(maxW)"
	truncLock.lock(); if let v = truncCache[key] { truncLock.unlock(); return v }; truncLock.unlock()
	var out = s
	if textW(s, f) > maxW {
		var t = s
		while !t.isEmpty && textW(t + "…", f) > maxW { t.removeLast() }
		out = t + "…"
	}
	truncLock.lock(); truncCache[key] = out; truncLock.unlock()
	return out
}

// ================================================================ shapes
func rect(_ c: CGContext, _ r: CGRect, fill: UInt32? = nil, fa: CGFloat = 1, stroke: UInt32? = nil, sa: CGFloat = 1, lw: CGFloat = 1, dash: [CGFloat] = []) {
	if let f = fill, fa > 0.003 { c.setFillColor(col(f, fa)); c.fill(r) }
	if let s = stroke, sa > 0.003 {
		c.setStrokeColor(col(s, sa)); c.setLineWidth(lw); c.setLineDash(phase: 0, lengths: dash)
		c.stroke(r.insetBy(dx: lw / 2, dy: lw / 2)); c.setLineDash(phase: 0, lengths: [])
	}
}
/// Rounded rect; the stroke sits inside the box (CSS border-box).
func rrect(_ c: CGContext, _ r: CGRect, _ rad: CGFloat, fill: UInt32? = nil, fa: CGFloat = 1, stroke: UInt32? = nil, sa: CGFloat = 1, lw: CGFloat = 1) {
	if r.width <= 0.01 || r.height <= 0.01 { return }
	if let f = fill, fa > 0.003 {
		let rr = max(0, min(rad, r.width / 2 - 0.01, r.height / 2 - 0.01))
		c.setFillColor(col(f, fa)); c.addPath(CGPath(roundedRect: r, cornerWidth: rr, cornerHeight: rr, transform: nil)); c.fillPath()
	}
	if let s = stroke, sa > 0.003 {
		let ri = r.insetBy(dx: lw / 2, dy: lw / 2)
		let rr = max(0, min(rad - lw / 2, ri.width / 2 - 0.01, ri.height / 2 - 0.01))
		c.setStrokeColor(col(s, sa)); c.setLineWidth(lw)
		c.addPath(CGPath(roundedRect: ri, cornerWidth: rr, cornerHeight: rr, transform: nil)); c.strokePath()
	}
}
func rrPath(_ r: CGRect, _ rad: CGFloat) -> CGPath {
	let rr = max(0, min(rad, r.width / 2 - 0.01, r.height / 2 - 0.01))
	return CGPath(roundedRect: r, cornerWidth: rr, cornerHeight: rr, transform: nil)
}
func segLine(_ c: CGContext, _ a: CGPoint, _ b: CGPoint, _ color: UInt32, _ alpha: CGFloat, lw: CGFloat = 1, dash: [CGFloat] = []) {
	if alpha <= 0.003 { return }
	c.setStrokeColor(col(color, alpha)); c.setLineWidth(lw); c.setLineDash(phase: 0, lengths: dash)
	c.move(to: a); c.addLine(to: b); c.strokePath(); c.setLineDash(phase: 0, lengths: [])
}
func dot(_ c: CGContext, _ p: CGPoint, _ r: CGFloat, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setFillColor(col(color, a)); c.fillEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
}
/// Draw `body` with a group opacity (a transparency layer only when partly transparent) and a y offset.
func layer(_ c: CGContext, _ alpha: CGFloat, dx: CGFloat = 0, dy: CGFloat = 0, _ body: () -> Void) {
	if alpha <= 0.003 { return }
	c.saveGState()
	c.translateBy(x: dx, y: dy)
	if alpha < 0.997 {
		c.setAlpha(alpha); c.beginTransparencyLayer(auxiliaryInfo: nil); body(); c.endTransparencyLayer()
	} else { body() }
	c.restoreGState()
}

// ================================================================ assets
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
/// Gray mask from an RGBA image's alpha (white = opaque), for tinting single-colour logos.
func alphaMask(_ img: CGImage) -> CGImage {
	let w = img.width, h = img.height
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: w * h * 4)
	defer { buf.deallocate() }
	buf.initialize(repeating: 0, count: w * h * 4)
	let ctx = CGContext(data: buf, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
	ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h))
	var g = [UInt8](repeating: 0, count: w * h)
	for i in 0..<(w * h) { g[i] = buf[i * 4 + 3] }
	let prov = CGDataProvider(data: Data(g) as CFData)!
	return CGImage(width: w, height: h, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: w, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGBitmapInfo(rawValue: 0), provider: prov, decode: nil, shouldInterpolate: true, intent: .defaultIntent)!
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
func drawImg(_ c: CGContext, _ img: CGImage, _ r: CGRect, _ a: CGFloat = 1, clip: CGRect? = nil) {
	if a <= 0.003 { return }
	c.saveGState()
	if let cl = clip { c.clip(to: cl) }
	c.setAlpha(a)
	c.translateBy(x: 0, y: r.maxY + r.minY); c.scaleBy(x: 1, y: -1)
	c.draw(img, in: r)
	c.restoreGState()
}
// the supermemory lockup (mark + wordmark masks), proportions from the official lockup
let MARK = grayMask("lock_mark.png"), WORD = grayMask("lock_word.png")
let G_MW = 588.0, G_MH = 480.0, G_GAP = 230.0, G_WW = 3182.0, G_WH = 381.0, G_WOFF = 99.0
/// Horizontal lockup with its mark `markH` tall, top-left at (x, y). Returns the wordmark's rect.
@discardableResult
func drawLockup(_ c: CGContext, x: CGFloat, y: CGFloat, markH: CGFloat, color: UInt32, a: CGFloat) -> CGRect {
	let s = markH / CGFloat(G_MH)
	let mw = CGFloat(G_MW) * s
	paintMask(c, MARK, CGRect(x: x, y: y, width: mw, height: markH), color, a)
	let wr = CGRect(x: x + mw + CGFloat(G_GAP) * s, y: y + CGFloat(G_WOFF) * s, width: CGFloat(G_WW) * s, height: CGFloat(G_WH) * s)
	paintMask(c, WORD, wr, color, a)
	return wr
}
// logos: the SVG marks the console itself serves on /agents, rasterised with alpha
struct Logo { let img: CGImage; let mask: CGImage; let mono: Bool }
func loadLogo(_ n: String, mono: Bool) -> Logo {
	let img = loadImage(HERE.appendingPathComponent("logos/\(n).png"))!
	return Logo(img: img, mask: alphaMask(img), mono: mono)
}
/// Fit a logo inside r (mono logos are tinted, colour logos drawn as is).
func drawLogoIn(_ c: CGContext, _ l: Logo, _ r: CGRect, _ tint: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	let iw = CGFloat(l.img.width), ih = CGFloat(l.img.height)
	let k = min(r.width / iw, r.height / ih)
	let rr = CGRect(x: r.midX - iw * k / 2, y: r.midY - ih * k / 2, width: iw * k, height: ih * k)
	if l.mono { paintMask(c, l.mask, rr, tint, a) } else { drawImg(c, l.img, rr, a) }
}

// ================================================================ icons (24-unit viewBox, round 1.5 stroke)
/// SVG path subset: M L H V C Q Z (absolute) and m l h v c (relative), plus three shorthands of our own:
/// "O cx cy r" circle, "E cx cy rx ry" ellipse, "R x y w h r" rounded rect.
func svgPath(_ d: String) -> CGPath {
	var tokens: [String] = []
	var cur = ""
	func flush() { if !cur.isEmpty { tokens.append(cur); cur = "" } }
	for ch in d {
		if ch.isLetter { flush(); tokens.append(String(ch)) }
		else if ch == " " || ch == "," || ch == "\n" || ch == "\t" { flush() }
		else if ch == "-" { flush(); cur = "-" }
		else if ch == "." && cur.contains(".") { flush(); cur = "." }
		else { cur.append(ch) }
	}
	flush()
	let p = CGMutablePath()
	var i = 0
	var cmd: Character = "M"
	var pt = CGPoint.zero, start = CGPoint.zero
	func num() -> CGFloat { guard i < tokens.count else { return 0 }; let v = CGFloat(Double(tokens[i]) ?? 0); i += 1; return v }
	while i < tokens.count {
		if let f = tokens[i].first, f.isLetter {
			cmd = f; i += 1
			if cmd == "Z" || cmd == "z" { p.closeSubpath(); pt = start; continue }
		}
		switch cmd {
		case "M": pt = CGPoint(x: num(), y: num()); p.move(to: pt); start = pt; cmd = "L"
		case "m": pt = CGPoint(x: pt.x + num(), y: pt.y + num()); p.move(to: pt); start = pt; cmd = "l"
		case "L": pt = CGPoint(x: num(), y: num()); p.addLine(to: pt)
		case "l": pt = CGPoint(x: pt.x + num(), y: pt.y + num()); p.addLine(to: pt)
		case "H": pt.x = num(); p.addLine(to: pt)
		case "h": pt.x += num(); p.addLine(to: pt)
		case "V": pt.y = num(); p.addLine(to: pt)
		case "v": pt.y += num(); p.addLine(to: pt)
		case "C":
			let c1 = CGPoint(x: num(), y: num()), c2 = CGPoint(x: num(), y: num())
			pt = CGPoint(x: num(), y: num()); p.addCurve(to: pt, control1: c1, control2: c2)
		case "c":
			let o = pt
			let c1 = CGPoint(x: o.x + num(), y: o.y + num()), c2 = CGPoint(x: o.x + num(), y: o.y + num())
			pt = CGPoint(x: o.x + num(), y: o.y + num()); p.addCurve(to: pt, control1: c1, control2: c2)
		case "Q":
			let c1 = CGPoint(x: num(), y: num())
			pt = CGPoint(x: num(), y: num()); p.addQuadCurve(to: pt, control: c1)
		case "O":
			let cx = num(), cy = num(), r = num()
			p.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r))
		case "E":
			let cx = num(), cy = num(), rx = num(), ry = num()
			p.addEllipse(in: CGRect(x: cx - rx, y: cy - ry, width: 2 * rx, height: 2 * ry))
		case "R":
			let x = num(), y = num(), w = num(), h = num(), r = num()
			p.addPath(rrPath(CGRect(x: x, y: y, width: w, height: h), r))
		default: i += 1
		}
	}
	return p
}
/// Stroke 24-unit icon paths into r.
func strokeIcon(_ c: CGContext, _ paths: [CGPath], _ r: CGRect, _ color: UInt32, _ a: CGFloat, scale: CGFloat = 1, lw: CGFloat = 1.5) {
	if a <= 0.003 || scale <= 0.01 { return }
	c.saveGState()
	c.translateBy(x: r.midX, y: r.midY); c.scaleBy(x: r.width / 24 * scale, y: r.height / 24 * scale); c.translateBy(x: -12, y: -12)
	c.setStrokeColor(col(color, a)); c.setLineWidth(lw); c.setLineCap(.round); c.setLineJoin(.round)
	for p in paths { c.addPath(p) }
	c.strokePath()
	c.restoreGState()
}
/// Icon of `size` centred on (cx, cy).
func icon(_ c: CGContext, _ paths: [CGPath], _ cx: CGFloat, _ cy: CGFloat, _ size: CGFloat, _ color: UInt32, _ a: CGFloat, scale: CGFloat = 1, lw: CGFloat = 1.5) {
	strokeIcon(c, paths, CGRect(x: cx - size / 2, y: cy - size / 2, width: size, height: size), color, a, scale: scale, lw: lw)
}

// ================================================================ output
/// A y-down bitmap context: w x h design units rendered at `scale` px per unit.
func makeContext(_ w: CGFloat, _ h: CGFloat, scale: CGFloat, data: UnsafeMutableRawPointer? = nil) -> CGContext {
	let pw = Int((w * scale).rounded()), ph = Int((h * scale).rounded())
	let c = CGContext(data: data, width: pw, height: ph, bitsPerComponent: 8, bytesPerRow: pw * 4, space: sRGB,
	                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.translateBy(x: 0, y: CGFloat(ph)); c.scaleBy(x: 1, y: -1)
	c.scaleBy(x: scale, y: scale)
	c.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
	c.interpolationQuality = .high
	c.setShouldSmoothFonts(false)
	return c
}
func writePNG(_ img: CGImage, _ url: URL) {
	let d = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}
