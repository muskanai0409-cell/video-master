// "one command, every agent": short console film for supermemory's coding plugins (v2).
// 1920x1080, 60fps, 45s, silent. supermemory.ai light surface (square corners, hairlines, mono labels,
// ink-45 statements with ink key words, dot grid, blue tile with the white mark, blue field film at the
// turn) plus real console captures (console.supermemory.ai/agents, 2026-10-05) and the real agent logos
// served by the console. One continuous take; the camera flies from the diagram into the console.
//
// Build:  swiftc -O render.swift -o render
// Stills: ./render stills 0 4 7.5 ...      -> stills/t_*.png + stills/sheet.png
// Video:  ./render raw | ffmpeg ... (see README.md)

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers
import CryptoKit

let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let W = 1920, H = 1080
let FPS = 60.0
let SUBFRAMES = 4
let SHUTTER = 0.35           // fraction of a frame the shutter is open

// ================================================================ tokens (supermemory.ai + console)
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
func col(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
	CGColor(colorSpace: sRGB, components: [CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a])!
}
let WHITE: UInt32 = 0xffffff, PAPER: UInt32 = 0xf4f4f6, INK: UInt32 = 0x0b1015
let BLUE: UInt32 = 0x0562ef, ONBLUE: UInt32 = 0xf4f8ff, LOGO_INK: UInt32 = 0x141b34
let A86: CGFloat = 0.86, A68: CGFloat = 0.68, A60: CGFloat = 0.60, A45: CGFloat = 0.45
let A30: CGFloat = 0.30, A20: CGFloat = 0.20, A14: CGFloat = 0.14, A10: CGFloat = 0.10
// console (measured from the page: card bg rgb(10,10,10), border rgba(255,255,255,0.07))
let CON_BG: UInt32 = 0x0a0a0a
// terminal colours: the cli prints chalk cyan / green / bold / dim; the banner hexes are the cli's own
let T_CYAN: UInt32 = 0x22d3ee, T_GREEN: UInt32 = 0x4ade80, T_TEXT: UInt32 = 0xededed
let BANNER_FILL: [UInt32] = [0xD6FBFF, 0x67E8F9, 0x22D3EE, 0x0EA5E9, 0x2563EB, 0x1D4ED8, 0x123B9A]
let BANNER_SHADOW: UInt32 = 0x071D82

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
let ease = bezier(0.2, 0, 0, 1)        // moves
let eout = bezier(0.22, 1, 0.36, 1)    // arrivals
let ease2 = bezier(0.5, 0, 0.2, 1)     // camera moves
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }
func lerpC(_ a: CGFloat, _ b: CGFloat, _ k: Double) -> CGFloat { a + (b - a) * CGFloat(k) }
func lerpP(_ a: CGPoint, _ b: CGPoint, _ k: Double) -> CGPoint { CGPoint(x: lerp(a.x, b.x, k), y: lerp(a.y, b.y, k)) }
func lerpR(_ a: CGRect, _ b: CGRect, _ k: Double) -> CGRect {
	CGRect(x: lerp(a.minX, b.minX, k), y: lerp(a.minY, b.minY, k), width: lerp(a.width, b.width, k), height: lerp(a.height, b.height, k))
}
func smooth(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }
/// Closed-form step response, slight overshoot (one spring family for the whole piece).
func spring(_ t: Double, _ start: Double, freq: Double = 2.4, zeta: Double = 0.62) -> Double {
	let tau = t - start
	if tau <= 0 { return 0 }
	let w = 2 * Double.pi * freq, wd = w * sqrt(1 - zeta * zeta)
	return 1 - exp(-zeta * w * tau) * (cos(wd * tau) + (zeta * w / wd) * sin(wd * tau))
}
/// 0 -> 1 -> 0 over d seconds.
func bump(_ t: Double, _ t0: Double, _ d: Double = 0.5) -> CGFloat { CGFloat(sin(seg(t, t0, t0 + d) * Double.pi)) }
/// Frame-locked time for typing and rolling digits, so motion blur never smears them.
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
/// Uppercase mono label in the site's letter-spaced style (never for the word "supermemory").
func label(_ c: CGContext, _ s: String, _ x: CGFloat, _ y: CGFloat, _ color: UInt32 = INK, _ a: CGFloat = A60, _ al: Align = .left, size: CGFloat = 15) {
	text(c, s.uppercased(), mono(size, 450), x, y, color, a, al, track: size * 0.12)
}
func labelW(_ s: String, size: CGFloat) -> CGFloat { textW(s.uppercased(), mono(size, 450), track: size * 0.12) }

// ================================================================ shapes
func rect(_ c: CGContext, _ r: CGRect, fill: UInt32? = nil, fa: CGFloat = 1, stroke: UInt32? = nil, sa: CGFloat = 1, lw: CGFloat = 1.5, dash: [CGFloat] = []) {
	if let f = fill, fa > 0.003 { c.setFillColor(col(f, fa)); c.fill(r) }
	if let s = stroke, sa > 0.003 {
		c.setStrokeColor(col(s, sa)); c.setLineWidth(lw); c.setLineDash(phase: 0, lengths: dash)
		c.stroke(r.insetBy(dx: lw / 2, dy: lw / 2)); c.setLineDash(phase: 0, lengths: [])
	}
}
func rrect(_ c: CGContext, _ r: CGRect, _ rad: CGFloat, fill: UInt32? = nil, fa: CGFloat = 1, stroke: UInt32? = nil, sa: CGFloat = 1, lw: CGFloat = 1) {
	let rr = max(0, min(rad, r.width / 2 - 0.01, r.height / 2 - 0.01))
	let p = CGPath(roundedRect: r.insetBy(dx: lw / 2, dy: lw / 2), cornerWidth: rr, cornerHeight: rr, transform: nil)
	if let f = fill, fa > 0.003 { c.setFillColor(col(f, fa)); c.addPath(p); c.fillPath() }
	if let s = stroke, sa > 0.003 { c.setStrokeColor(col(s, sa)); c.setLineWidth(lw); c.addPath(p); c.strokePath() }
}
func segLine(_ c: CGContext, _ a: CGPoint, _ b: CGPoint, _ color: UInt32, _ alpha: CGFloat, lw: CGFloat = 1.5, dash: [CGFloat] = []) {
	if alpha <= 0.003 { return }
	c.setStrokeColor(col(color, alpha)); c.setLineWidth(lw); c.setLineDash(phase: 0, lengths: dash)
	c.move(to: a); c.addLine(to: b); c.strokePath(); c.setLineDash(phase: 0, lengths: [])
}
func dot(_ c: CGContext, _ p: CGPoint, _ r: CGFloat, _ color: UInt32, _ a: CGFloat) {
	if a <= 0.003 { return }
	c.setFillColor(col(color, a)); c.fillEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
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
let MARK = grayMask("lock_mark.png"), WORD = grayMask("lock_word.png")
let G_MW = 588.0, G_MH = 480.0, G_GAP = 230.0, G_WW = 3182.0, G_WH = 381.0, G_WOFF = 99.0
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
func markRect(center: CGPoint, height: CGFloat) -> CGRect {
	let w = height * CGFloat(G_MW / G_MH)
	return CGRect(x: center.x - w / 2, y: center.y - height / 2, width: w, height: height)
}
// logos: the SVG marks the console itself serves on /agents, rasterised with alpha
struct Logo { let img: CGImage; let mask: CGImage; let mono: Bool }
func loadLogo(_ n: String, mono: Bool) -> Logo {
	let img = loadImage(HERE.appendingPathComponent("logos/\(n).png"))!
	return Logo(img: img, mask: alphaMask(img), mono: mono)
}
struct Agent { let name: String; let logo: Logo }
// 0 claude code, 1 codex, 2 opencode, 3 cursor, 4 muse code
let AG: [Agent] = [
	Agent(name: "claude code", logo: loadLogo("claude-code", mono: false)),
	Agent(name: "codex", logo: loadLogo("codex", mono: true)),
	Agent(name: "opencode", logo: loadLogo("opencode", mono: true)),
	Agent(name: "cursor", logo: loadLogo("cursor", mono: true)),
	Agent(name: "muse code", logo: loadLogo("muse-code", mono: false)),
]
func drawLogo(_ c: CGContext, _ l: Logo, _ ctr: CGPoint, _ box: CGFloat, _ a: CGFloat, tint: UInt32 = INK) {
	if a <= 0.003 || box <= 0.5 { return }
	let iw = CGFloat(l.img.width), ih = CGFloat(l.img.height)
	let k = box / max(iw, ih)
	let r = CGRect(x: ctr.x - iw * k / 2, y: ctr.y - ih * k / 2, width: iw * k, height: ih * k)
	if l.mono { paintMask(c, l.mask, r, tint, a) } else { drawImg(c, l.img, r, a) }
}

