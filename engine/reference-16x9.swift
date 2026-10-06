// "the file the model never read", v2: 16:9 explainer for supermemory's MCP App upload.
// 1920x1080, 60fps, ~37s, silent. supermemory.ai light surface + website patterns
// (square corners, hairlines, mono uppercase labels, ink-45 statements with ink key words,
// dot-grid figure, blue tile with the white mark, blue field film at the turn).
// One continuous take: every scene grows out of the last. 4-subframe motion blur.
//
// Build:  swiftc -O render.swift -o render
// Stills: ./render stills 0 4 7.5 ...      -> stills/t_*.png + stills/sheet.png
// Video:  ./render raw | ffmpeg ... (see README.md)

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let W = 1920, H = 1080
let FPS = 60.0
let SUBFRAMES = 4
let SHUTTER = 0.5            // fraction of a frame the shutter is open (180 degrees)

// ================================================================ tokens (supermemory.ai)
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
func col(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
	CGColor(colorSpace: sRGB, components: [CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a])!
}
let WHITE: UInt32 = 0xffffff, PAPER: UInt32 = 0xf4f4f6, INK: UInt32 = 0x0b1015
let BLUE: UInt32 = 0x0562ef, ONBLUE: UInt32 = 0xf4f8ff, LOGO_INK: UInt32 = 0x141b34
let RED: UInt32 = 0xd9363e   // one bounded "poisoned" window only (pack rule)
let A86: CGFloat = 0.86, A68: CGFloat = 0.68, A60: CGFloat = 0.60, A45: CGFloat = 0.45
let A30: CGFloat = 0.30, A20: CGFloat = 0.20, A14: CGFloat = 0.14, A10: CGFloat = 0.10

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
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }
func lerpP(_ a: CGPoint, _ b: CGPoint, _ k: Double) -> CGPoint { CGPoint(x: lerp(a.x, b.x, k), y: lerp(a.y, b.y, k)) }
func lerpR(_ a: CGRect, _ b: CGRect, _ k: Double) -> CGRect {
	CGRect(x: lerp(a.minX, b.minX, k), y: lerp(a.minY, b.minY, k), width: lerp(a.width, b.width, k), height: lerp(a.height, b.height, k))
}
/// Closed-form step response, slight overshoot (one spring family for the whole piece).
func spring(_ t: Double, _ start: Double, freq: Double = 2.4, zeta: Double = 0.62) -> Double {
	let tau = t - start
	if tau <= 0 { return 0 }
	let w = 2 * Double.pi * freq, wd = w * sqrt(1 - zeta * zeta)
	return 1 - exp(-zeta * w * tau) * (cos(wd * tau) + (zeta * w / wd) * sin(wd * tau))
}

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
/// Uppercase mono label in the site's letter-spaced style.
func label(_ c: CGContext, _ s: String, _ x: CGFloat, _ y: CGFloat, _ color: UInt32 = INK, _ a: CGFloat = A60, _ al: Align = .left, size: CGFloat = 15) {
	text(c, s.uppercased(), mono(size, 450), x, y, color, a, al, track: size * 0.12)
}

// ================================================================ shapes
func rect(_ c: CGContext, _ r: CGRect, fill: UInt32? = nil, fa: CGFloat = 1, stroke: UInt32? = nil, sa: CGFloat = 1, lw: CGFloat = 1.5, dash: [CGFloat] = []) {
	if let f = fill, fa > 0.003 { c.setFillColor(col(f, fa)); c.fill(r) }
	if let s = stroke, sa > 0.003 {
		c.setStrokeColor(col(s, sa)); c.setLineWidth(lw); c.setLineDash(phase: 0, lengths: dash)
		c.stroke(r.insetBy(dx: lw / 2, dy: lw / 2)); c.setLineDash(phase: 0, lengths: [])
	}
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
	return CGImageSourceCreateImageAtIndex(src, 0, nil)
}
func grayMask(_ name: String) -> CGImage {
	let img = loadImage(HERE.appendingPathComponent(name))!
	let g = CGContext(data: nil, width: img.width, height: img.height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
	g.draw(img, in: CGRect(x: 0, y: 0, width: img.width, height: img.height))
	return g.makeImage()!
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
func markRect(center: CGPoint, height: CGFloat) -> CGRect {
	let w = height * CGFloat(G_MW / G_MH)
	return CGRect(x: center.x - w / 2, y: center.y - height / 2, width: w, height: height)
}
var fieldCache: [Int: CGImage] = [:]
let fieldLock = NSLock()
func fieldFrame(_ i: Int) -> CGImage? {
	let k = max(0, min(155, i))
	fieldLock.lock(); defer { fieldLock.unlock() }
	if let f = fieldCache[k] { return f }
	let img = loadImage(HERE.appendingPathComponent(String(format: "field/f%04d.jpg", k)))
	fieldCache[k] = img
	return img
}

// Real base64 of PDF-like bytes so the texture is honest.
let B64: [Character] = {
	var s = "%PDF-1.7\n%\u{e2}\u{e3}\u{cf}\u{d3}\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n"
	for i in 2..<40 { s += "\(i) 0 obj\n<< /Type /Page /Parent 1 0 R /MediaBox [0 0 612 792] >>\nstream\nBT /F1 11 Tf 72 \(720 - i * 9) Td (q3 report, section \(i)) Tj ET\nendstream\nendobj\n" }
	return Array(s.data(using: .isoLatin1)!.base64EncodedString())
}()

// ================================================================ timeline (v3: 26.0s)
let B0 = 0.0, B1 = 2.6, B2 = 5.6, B3 = 8.6
let TURN = 11.2
let B4 = 12.4, B5 = 15.2, B6 = 18.0, B7 = 20.8
let END = 23.4
let T_STILL = 24.7
let T_END = 26.0

struct Statement { let t: Double; let lines: [String] }   // *word* = key word (full ink)
let STATEMENTS: [Statement] = [
	Statement(t: B0, lines: ["you want your agent", "to *remember* *a* *file*"]),
	Statement(t: B1, lines: ["mcp has *no* *standard*", "*way* to send one"]),
	Statement(t: B2, lines: ["so the model types", "*your* *file* *out* *as* *text*"]),
	Statement(t: B3, lines: ["*one* *wrong* *character*", "corrupts the file"]),
	Statement(t: B4, lines: ["supermemory opens a", "*small* *app* *in* *your* *chat*"]),
	Statement(t: B5, lines: ["one click gets a", "*one-time* *ticket*,", "valid for 2 minutes"]),
	Statement(t: B6, lines: ["the file goes", "*straight* *to*", "*supermemory*"]),
	Statement(t: B7, lines: ["the model only gets", "*a* *receipt*"]),
]
let STATEMENT_ENDS: [Double] = [B1, B2, B3, TURN, B5, B6, B7, END]

struct Chapter { let t0: Double; let t1: Double; let n: String; let title: String }
let CHAPTERS: [Chapter] = [
	Chapter(t0: B0, t1: B2, n: "01", title: "the problem"),
	Chapter(t0: B2, t1: TURN, n: "02", title: "the old way"),
	Chapter(t0: B4, t1: B7, n: "03", title: "the fix"),
	Chapter(t0: B7, t1: END, n: "04", title: "what the model sees"),
]

// ================================================================ layout (screen)
let COL_X: CGFloat = 112
let LABEL_Y: CGFloat = 404
let STMT_Y: CGFloat = 484, STMT_LH: CGFloat = 66, STMT_PX: CGFloat = 56
let FIG = CGRect(x: 800, y: 110, width: 1040, height: 860)

// figure world (0..944 x 0..800)
let DEVICE = CGRect(x: 40, y: 200, width: 380, height: 520)
let MODEL = CGRect(x: 590, y: 60, width: 160, height: 160)
let SERVER = CGRect(x: 590, y: 520, width: 160, height: 160)
let LANE_Y: CGFloat = 600
let LANE_A = CGPoint(x: 420, y: 600), LANE_B = CGPoint(x: 590, y: 600)
let LANE_MID: CGFloat = 505
let DOC_W: CGFloat = 96, DOC_H: CGFloat = 124
let DOC_A = CGPoint(x: 182, y: 372)          // home, loose in the chat
let DOC_B = CGPoint(x: 182, y: 538)          // inside the app (centre y = lane)
let DRAG_END = CGPoint(x: 457, y: 498)       // where the problem-chapter drag gives up (top-left)
let APP = CGRect(x: 64, y: 410, width: 332, height: 290)
let BUTTON = CGRect(x: 292, y: 646, width: 92, height: 36)
let PATH1_A = CGPoint(x: 278, y: 380), PATH1_B = CGPoint(x: 590, y: 140)
let PATH2_A = CGPoint(x: 670, y: 264), PATH2_B = CGPoint(x: 670, y: 520)
let CHIP = CGRect(x: 772, y: 88, width: 196, height: 104)
let BAD_DOC = CGRect(x: 782, y: 548, width: 64, height: 84)
let TAG_W: CGFloat = 180, TAG_H: CGFloat = 40
let RECEIPT = CGRect(x: 272, y: 92, width: 296, height: 100)

// ================================================================ camera (inside the figure)
let DRAG1_A = B1 + 0.85, DRAG1_B = B1 + 1.5, SNAP = B1 + 1.55
let DRAG2_A = B4 + 1.45, DRAG2_B = B4 + 2.05
let RIDE_A = B6 + 1.0, RIDE_B = B6 + 1.5
struct Cam { let t: Double; let c: CGPoint; let z: Double; let dur: Double; var drift: Bool = false }
let POST_T = TURN + 0.5      // the old world is gone once the flood covers the frame
func smooth(_ x: Double) -> Double { let k = max(0, min(1, x)); return k * k * (3 - 2 * k) }
// The camera is almost never still: a quick move at each beat (ease), then a slow drift that
// follows the action (smoothstep), screen-studio style. Every key starts from where the last left off.
let CAMS: [Cam] = [
	Cam(t: B0, c: CGPoint(x: 236, y: 440), z: 2.0, dur: 0),
	Cam(t: B0, c: CGPoint(x: 252, y: 452), z: 2.5, dur: 2.6, drift: true),
	Cam(t: B1 + 0.02, c: CGPoint(x: 430, y: 470), z: 1.25, dur: 0.7),
	Cam(t: B1 + 0.72, c: CGPoint(x: 455, y: 500), z: 1.36, dur: 1.03, drift: true),        // follows the drag
	Cam(t: B1 + 1.75, c: CGPoint(x: 500, y: 585), z: 1.75, dur: 0.7),                     // into the gap
	Cam(t: B1 + 2.45, c: CGPoint(x: 506, y: 592), z: 1.92, dur: 0.6, drift: true),
	Cam(t: B2 + 0.03, c: CGPoint(x: 430, y: 400), z: 1.15, dur: 0.75),
	Cam(t: B2 + 0.78, c: CGPoint(x: 470, y: 372), z: 1.27, dur: 0.67, drift: true),
	Cam(t: B2 + 1.45, c: CGPoint(x: 745, y: 200), z: 1.75, dur: 0.75),                    // model + counter
	Cam(t: B2 + 2.2, c: CGPoint(x: 762, y: 196), z: 1.98, dur: 0.8, drift: true),
	Cam(t: B3 + 0.03, c: CGPoint(x: 715, y: 500), z: 1.6, dur: 0.75),                     // red character falls
	Cam(t: B3 + 0.78, c: CGPoint(x: 738, y: 565), z: 1.9, dur: 1.85, drift: true),        // lands on the corrupted file
	Cam(t: POST_T, c: CGPoint(x: 430, y: 420), z: 1.15, dur: 0),                          // reset under the flood
	Cam(t: B4, c: CGPoint(x: 380, y: 450), z: 1.27, dur: 1.2, drift: true),               // watch the app arrive
	Cam(t: B4 + 1.2, c: CGPoint(x: 240, y: 545), z: 1.7, dur: 0.75),                      // into the app for the drag
	Cam(t: B4 + 1.95, c: CGPoint(x: 242, y: 566), z: 1.88, dur: 0.85, drift: true),
	Cam(t: B5 + 0.03, c: CGPoint(x: 300, y: 600), z: 1.7, dur: 0.7),                      // cursor to upload
	Cam(t: 16.1, c: CGPoint(x: 430, y: 540), z: 1.3, dur: 0.45),                          // pull out: ticket pops
	Cam(t: 16.5, c: CGPoint(x: 300, y: 520), z: 1.6, dur: 0.6),                           // follow the ticket
	Cam(t: 17.1, c: CGPoint(x: 268, y: 548), z: 2.05, dur: 0.9, drift: true),             // push into the countdown
	Cam(t: B6 + 0.03, c: CGPoint(x: 430, y: 600), z: 1.3, dur: 0.7),                      // the lane heals
	Cam(t: B6 + 0.73, c: CGPoint(x: 445, y: 600), z: 1.36, dur: 0.27, drift: true),
	Cam(t: RIDE_A, c: CGPoint(x: 600, y: 600), z: 1.5, dur: 0.5),                         // ride along
	Cam(t: RIDE_B - 0.05, c: CGPoint(x: 670, y: 615), z: 1.85, dur: 0.6),                 // absorbed
	Cam(t: RIDE_B + 0.55, c: CGPoint(x: 672, y: 622), z: 2.1, dur: 0.75, drift: true),
	Cam(t: B7 + 0.03, c: CGPoint(x: 522, y: 170), z: 1.9, dur: 0.75),                     // receipt + model
	Cam(t: B7 + 0.78, c: CGPoint(x: 500, y: 152), z: 2.25, dur: 1.82, drift: true),
]
func camera(_ t: Double) -> (CGPoint, Double) {
	var c = CAMS[0].c, z = CAMS[0].z
	for k in CAMS where t >= k.t {
		let x = k.dur == 0 ? 1.0 : (t - k.t) / k.dur
		let e = k.dur == 0 ? 1.0 : (k.drift ? smooth(x) : ease(x))
		c = lerpP(c, k.c, e); z = lerp(z, k.z, e)
	}
	return (c, z)
}

// ================================================================ statement + labels (screen space)
func drawStatements(_ c: CGContext, _ t: Double) {
	for (i, s) in STATEMENTS.enumerated() {
		let tIn = s.t + (i == 0 ? -1 : 0.2), tOut = STATEMENT_ENDS[i]
		if t < s.t || t > tOut + 0.25 { continue }
		for (j, ln) in s.lines.enumerated() {
			let base = STMT_Y + CGFloat(j) * STMT_LH
			let kIn = i == 0 ? 1.0 : eout(seg(t, tIn + Double(j) * 0.06, tIn + Double(j) * 0.06 + 0.42))
			let kOut = ease(seg(t, tOut + Double(j) * 0.03, tOut + Double(j) * 0.03 + 0.18))
			if kIn <= 0 || kOut >= 1 { continue }
			let dy = STMT_LH * CGFloat(1 - kIn) - STMT_LH * CGFloat(kOut)
			c.saveGState()
			c.clip(to: CGRect(x: COL_X - 10, y: base - STMT_PX - 4, width: 680, height: STMT_LH + 2))   // mask line
			var x = COL_X
			let f = sans(STMT_PX, 500)
			for (wi, w) in ln.split(separator: " ").enumerated() {
				let emph = w.contains("*")
				let word = w.replacingOccurrences(of: "*", with: "")
				let piece = (wi == 0 ? "" : " ") + word
				text(c, piece, f, x, base + dy, INK, emph ? 1.0 : A45)
				x += textW(piece, f)
			}
			c.restoreGState()
		}
	}
}

func drawChapterLabel(_ c: CGContext, _ t: Double) {
	for (i, ch) in CHAPTERS.enumerated() {
		let tIn = ch.t0 + (i == 0 ? -1 : 0.1), tOut = ch.t1
		let kIn = i == 0 ? 1.0 : eout(seg(t, tIn, tIn + 0.4)), kOut = ease(seg(t, tOut, tOut + 0.2))
		if kIn <= 0 || kOut >= 1 { continue }
		let dy = 26 * CGFloat(1 - kIn) - 26 * CGFloat(kOut)
		c.saveGState()
		c.clip(to: CGRect(x: COL_X - 4, y: LABEL_Y - 26, width: 620, height: 34))
		let numColor = i >= 2 ? BLUE : INK
		label(c, ch.n, COL_X, LABEL_Y + dy, numColor, 1.0, size: 20)
		label(c, "·  " + ch.title, COL_X + 40, LABEL_Y + dy, INK, A60, size: 20)
		c.restoreGState()
	}
	c.setFillColor(col(INK, A10)); c.fill(CGRect(x: COL_X, y: LABEL_Y + 22, width: 600, height: 1))
}

func drawHUD(_ c: CGContext, _ t: Double) {
	label(c, "mcp apps  /  file upload", COL_X, 76, INK, A45, size: 15)
	var idx = 0
	for (i, ch) in CHAPTERS.enumerated() where t >= ch.t0 - 0.001 { idx = i }
	label(c, CHAPTERS[idx].n, 1840 - 54, 76, INK, 1.0, .right, size: 15)
	label(c, "/ 04", 1840, 76, INK, A45, .right, size: 15)
	for (i, ch) in CHAPTERS.enumerated() {
		let x = COL_X + CGFloat(i) * 92
		c.setFillColor(col(INK, A14)); c.fill(CGRect(x: x, y: 1010, width: 80, height: 3))
		let p = seg(t, ch.t0, ch.t1)
		if p > 0 { c.setFillColor(col(INK, A86)); c.fill(CGRect(x: x, y: 1010, width: 80 * CGFloat(p), height: 3)) }
	}
	paintMask(c, MARK, markRect(center: CGPoint(x: 1826, y: 1012), height: 20), LOGO_INK, 0.86)
}

// ================================================================ figure pieces (world space)
func drawDoc(_ c: CGContext, _ o: CGPoint, _ a: CGFloat, scale: CGFloat = 1, showLabel: Bool = true) {
	if a <= 0.003 || scale <= 0.01 { return }
	let w = DOC_W * scale, h = DOC_H * scale
	let r = CGRect(x: o.x + (DOC_W - w) / 2, y: o.y + (DOC_H - h) / 2, width: w, height: h)
	rect(c, r, fill: WHITE, fa: a, stroke: INK, sa: A45 * a, lw: 1.5)
	c.setFillColor(col(PAPER, a)); c.move(to: CGPoint(x: r.maxX - 18 * scale, y: r.minY)); c.addLine(to: CGPoint(x: r.maxX, y: r.minY + 18 * scale)); c.addLine(to: CGPoint(x: r.maxX - 18 * scale, y: r.minY + 18 * scale)); c.closePath(); c.fillPath()
	for (i, lw) in [60.0, 48.0, 60.0, 36.0].enumerated() {
		c.setFillColor(col(INK, A10 * a))
		c.fill(CGRect(x: r.minX + 16 * scale, y: r.minY + (28 + CGFloat(i) * 16) * scale, width: CGFloat(lw) * scale, height: 5 * scale))
	}
	label(c, "pdf", r.midX, r.maxY - 14 * scale, INK, A68 * a, .center, size: 14 * scale)
	if showLabel { text(c, "report.pdf", mono(17), r.midX, r.maxY + 26, INK, A68 * a, .center) }
}

func drawTile(_ c: CGContext, _ r: CGRect, _ a: CGFloat, kind: Int) {
	if a <= 0.003 { return }
	rect(c, r, fill: PAPER, fa: a, stroke: INK, sa: A20 * a, lw: 1.5)
	let cx = r.midX, cy = r.midY, s = r.width / 160
	c.setStrokeColor(col(INK, A68 * a)); c.setLineWidth(2.2 * s)
	if kind == 0 {
		let q = CGRect(x: cx - 28 * s, y: cy - 28 * s, width: 56 * s, height: 56 * s)
		c.stroke(q)
		for k in 0..<3 {
			let o = (CGFloat(k) - 1) * 15 * s
			c.move(to: CGPoint(x: cx + o, y: q.minY)); c.addLine(to: CGPoint(x: cx + o, y: q.minY - 11 * s))
			c.move(to: CGPoint(x: cx + o, y: q.maxY)); c.addLine(to: CGPoint(x: cx + o, y: q.maxY + 11 * s))
			c.move(to: CGPoint(x: q.minX, y: cy + o)); c.addLine(to: CGPoint(x: q.minX - 11 * s, y: cy + o))
			c.move(to: CGPoint(x: q.maxX, y: cy + o)); c.addLine(to: CGPoint(x: q.maxX + 11 * s, y: cy + o))
		}
		c.strokePath()
		c.stroke(q.insetBy(dx: 15 * s, dy: 15 * s))
	} else {
		for k in 0..<3 {
			let y = cy - 30 * s + CGFloat(k) * 21 * s
			c.stroke(CGRect(x: cx - 32 * s, y: y, width: 64 * s, height: 15 * s))
		}
	}
}

func drawTicket(_ c: CGContext, _ o: CGPoint, _ secs: Int, _ a: CGFloat, scale: CGFloat = 1, strike: CGFloat = 0) {
	if a <= 0.003 || scale <= 0.01 { return }
	let w = TAG_W * scale, h = TAG_H * scale
	let r = CGRect(x: o.x + (TAG_W - w) / 2, y: o.y + (TAG_H - h) / 2, width: w, height: h)
	rect(c, r, fill: WHITE, fa: a, stroke: INK, sa: A68 * a, lw: 1.5)
	c.setStrokeColor(col(INK, A60 * a)); c.setLineWidth(1.5)
	c.strokeEllipse(in: CGRect(x: r.minX + 12 * scale, y: r.midY - 5 * scale, width: 10 * scale, height: 10 * scale))
	label(c, "ticket", r.minX + 31 * scale, r.midY + 5 * scale, INK, A60 * a, size: 14 * scale)
	text(c, String(format: "%d:%02d", secs / 60, secs % 60), mono(19 * scale, 500), r.maxX - 12 * scale, r.midY + 7 * scale, INK, A86 * a, .right)
	if strike > 0 { segLine(c, CGPoint(x: r.minX + 8, y: r.midY), CGPoint(x: r.minX + 8 + (r.width - 16) * strike, y: r.midY), INK, A86 * a, lw: 2) }
}

/// Classic arrow pointer, tip at p, drawn in world space so it scales with the camera.
func drawCursor(_ c: CGContext, _ p: CGPoint, _ a: CGFloat, press: CGFloat) {
	if a <= 0.003 { return }
	let s: CGFloat = 1.15 * (1 - 0.12 * press)
	let pts: [(CGFloat, CGFloat)] = [(0, 0), (0, 25), (6, 19.5), (10.5, 29.5), (14.5, 27.8), (10.2, 18), (17.8, 18)]
	c.saveGState()
	c.translateBy(x: p.x, y: p.y); c.scaleBy(x: s, y: s)
	c.move(to: CGPoint(x: pts[0].0, y: pts[0].1))
	for q in pts.dropFirst() { c.addLine(to: CGPoint(x: q.0, y: q.1)) }
	c.closePath()
	c.setFillColor(col(INK, a)); c.setStrokeColor(col(WHITE, a)); c.setLineWidth(2)
	c.setLineJoin(.round)
	c.drawPath(using: .fillStroke)
	c.restoreGState()
}
func ripple(_ c: CGContext, _ p: CGPoint, _ t: Double, _ t0: Double) {
	let k = seg(t, t0, t0 + 0.42)
	if k <= 0 || k >= 1 { return }
	let r = CGFloat(6 + 26 * eout(k))
	c.setStrokeColor(col(INK, 0.5 * CGFloat(1 - k))); c.setLineWidth(1.5)
	c.strokeEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
}

func pathPoint(_ s: CGFloat) -> (CGPoint, Bool, CGFloat) {
	let l1 = hypot(PATH1_B.x - PATH1_A.x, PATH1_B.y - PATH1_A.y), gap: CGFloat = 110
	let l2 = PATH2_B.y - PATH2_A.y
	if s < 0 { return (PATH1_A, false, 0) }
	if s <= l1 {
		let fade = min(1, s / 26, (l1 - s) / 18)
		return (lerpP(PATH1_A, PATH1_B, Double(s / l1)), true, fade)
	}
	if s < l1 + gap { return (PATH1_B, false, 0) }
	let s2 = s - l1 - gap
	if s2 <= l2 { return (CGPoint(x: PATH2_A.x, y: PATH2_A.y + s2), true, min(1, s2 / 18, (l2 - s2) / 20)) }
	return (PATH2_B, false, 0)
}
let STREAM_T0 = B2 + 0.85, STREAM_V: Double = 240, STREAM_SP: CGFloat = 15
let L_TO_SEG2 = Double(hypot(PATH1_B.x - PATH1_A.x, PATH1_B.y - PATH1_A.y)) + 110
let RED_I: Int = Int(((B3 + 0.35 - STREAM_T0) * STREAM_V - L_TO_SEG2) / 15)   // emerges as statement 4 lands
let RED_T = STREAM_T0 + (L_TO_SEG2 + Double(PATH2_B.y - PATH2_A.y) + Double(RED_I) * 15) / STREAM_V

func counterString(_ v: Int) -> String {
	let d = Array(String(v)); var s = ""
	for (i, ch) in d.enumerated() { if i > 0 && (d.count - i) % 3 == 0 { s.append(",") }; s.append(ch) }
	return s
}
func drawCounter(_ c: CGContext, _ value: Int, right: CGFloat, base: CGFloat, size: CGFloat, _ a: CGFloat) {
	let f = sans(size, 500)
	let cell = (0...9).map { textW(String($0), f) }.max()!, comma = textW(",", f)
	var x = right
	for ch in counterString(value).reversed() {
		let w = ch == "," ? comma : cell
		x -= w
		text(c, String(ch), f, x + w / 2, base, INK, a, .center)
	}
}

// ---------------------------------------------------------------- the document's path
func docPos(_ t: Double) -> CGPoint {
	if t < DRAG1_A { return DOC_A }
	if t < SNAP { return lerpP(DOC_A, DRAG_END, ease(seg(t, DRAG1_A, DRAG1_B))) }
	if t < DRAG2_A { return lerpP(DRAG_END, DOC_A, spring(t, SNAP, freq: 2.2, zeta: 0.55)) }   // springs back home
	if t < RIDE_A {
		let k = ease(seg(t, DRAG2_A, DRAG2_B))
		var p = lerpP(DOC_A, DOC_B, k)
		p.y += CGFloat(4 * (spring(t, DRAG2_B, freq: 3, zeta: 0.4) - (t >= DRAG2_B ? 1 : 0)))   // drop settle
		return p
	}
	return CGPoint(x: lerp(DOC_B.x, SERVER.midX - DOC_W / 2, ease(seg(t, RIDE_A, RIDE_B))), y: DOC_B.y)
}

// ---------------------------------------------------------------- the cursor's path (tip, world space)
struct CK { let t: Double; let p: CGPoint }
let GRAB = CGPoint(x: 6, y: 12)   // tip offset from the doc centre while holding it
let CURSOR_KEYS: [CK] = [
	CK(t: 0.9, p: CGPoint(x: 360, y: 640)),
	CK(t: 1.6, p: CGPoint(x: 236, y: 446)),
	CK(t: 3.4, p: CGPoint(x: 236, y: 446)),
	CK(t: 13.1, p: CGPoint(x: 330, y: 770)),
	CK(t: 13.75, p: CGPoint(x: 236, y: 446)),
	CK(t: 14.55, p: CGPoint(x: 236, y: 612)),
	CK(t: 15.45, p: CGPoint(x: 236, y: 612)),
	CK(t: 15.95, p: CGPoint(x: BUTTON.midX - 4, y: BUTTON.midY - 6)),
	CK(t: 18.25, p: CGPoint(x: BUTTON.midX - 4, y: BUTTON.midY - 6)),
	CK(t: 18.8, p: CGPoint(x: 140, y: 790)),
]
let PRESSES: [Double] = [DRAG1_A - 0.05, DRAG2_A - 0.05, 16.05]
func cursorState(_ t: Double) -> (CGPoint, CGFloat, CGFloat) {
	// visible in the problem chapter (until B2) and in the fix (13.1 .. 18.8)
	var a: CGFloat = 0
	if t >= 0.9 && t < B2 + 0.2 { a = CGFloat(ease(seg(t, 0.9, 1.15)) * (1 - ease(seg(t, B2, B2 + 0.2)))) }
	if t >= 13.1 && t < 18.8 { a = CGFloat(ease(seg(t, 13.1, 13.35)) * (1 - ease(seg(t, 18.55, 18.8)))) }
	var p = CURSOR_KEYS[0].p
	for i in 1..<CURSOR_KEYS.count where t >= CURSOR_KEYS[i - 1].t {
		let a0 = CURSOR_KEYS[i - 1], a1 = CURSOR_KEYS[i]
		p = lerpP(a0.p, a1.p, ease(seg(t, a0.t, a1.t)))
	}
	// while holding the doc, the cursor rides with it
	let d = docPos(t)
	if (t >= DRAG1_A - 0.05 && t < SNAP) || (t >= DRAG2_A - 0.05 && t < DRAG2_B + 0.08) {
		p = CGPoint(x: d.x + DOC_W / 2 + GRAB.x, y: d.y + DOC_H / 2 + GRAB.y)
	} else if t >= SNAP && t < B2 + 0.2 {
		p = CGPoint(x: DRAG_END.x + DOC_W / 2 + GRAB.x, y: DRAG_END.y + DOC_H / 2 + GRAB.y)   // left holding nothing
	}
	var press: CGFloat = 0
	for pt in PRESSES { press = max(press, CGFloat(1 - seg(abs(t - pt - 0.06), 0, 0.12))) }
	if (t >= DRAG1_A && t < SNAP) || (t >= DRAG2_A && t < DRAG2_B) { press = 1 }
	return (p, a, press)
}

// ================================================================ the figure
let TURN_FILL = TURN + 0.12, FLOOD_A = TURN + 0.15, FLOOD_B = TURN + 0.45, SHRINK_A = TURN + 0.82, SHRINK_B = TURN + 1.2

func worldToScreen(_ p: CGPoint, _ cam: (CGPoint, Double)) -> CGPoint {
	CGPoint(x: FIG.midX + (p.x - cam.0.x) * CGFloat(cam.1), y: FIG.midY + (p.y - cam.0.y) * CGFloat(cam.1))
}
func worldRectToScreen(_ r: CGRect, _ cam: (CGPoint, Double)) -> CGRect {
	let a = worldToScreen(CGPoint(x: r.minX, y: r.minY), cam), b = worldToScreen(CGPoint(x: r.maxX, y: r.maxY), cam)
	return CGRect(x: a.x, y: a.y, width: b.x - a.x, height: b.y - a.y)
}

func drawFigure(_ c: CGContext, _ t: Double) {
	let cam = camera(t)
	let post = t >= POST_T
	rect(c, FIG, fill: WHITE, fa: 1, stroke: INK, sa: A10, lw: 1)
	c.saveGState(); c.clip(to: FIG.insetBy(dx: 1, dy: 1))
	c.setFillColor(col(INK, 0.11))
	var gy = FIG.minY + 12
	while gy < FIG.maxY { var gx = FIG.minX + 12; while gx < FIG.maxX { c.fill(CGRect(x: gx, y: gy, width: 1.6, height: 1.6)); gx += 24 }; gy += 24 }

	c.translateBy(x: FIG.midX, y: FIG.midY); c.scaleBy(x: CGFloat(cam.1), y: CGFloat(cam.1)); c.translateBy(x: -cam.0.x, y: -cam.0.y)

	// ---- the chat window
	rect(c, DEVICE, fill: WHITE, fa: 1, stroke: INK, sa: A20, lw: 1.5)
	c.setFillColor(col(INK, A10)); c.fill(CGRect(x: DEVICE.minX, y: DEVICE.minY + 46, width: DEVICE.width, height: 1))
	for k in 0..<3 { dot(c, CGPoint(x: DEVICE.minX + 22 + CGFloat(k) * 17, y: DEVICE.minY + 23), 4.5, INK, A14) }
	label(c, "your chat", DEVICE.maxX - 18, DEVICE.minY + 30, INK, A45, .right, size: 15)

	let dp = docPos(t)

	// ---- the direct line: drawn by the drag, snaps (no standard), dims, heals into the blue lane
	if t >= DRAG1_A {
		let gap = 82 * CGFloat(max(0, spring(t, SNAP, freq: 2.6, zeta: 0.5) * (1 - spring(t, B6 + 0.15))))
		let dragX = min(LANE_MID, max(LANE_A.x, dp.x + DOC_W / 2))
		let leftEnd = t < SNAP ? dragX : LANE_MID - gap / 2
		let rightK = ease(seg(t, SNAP, SNAP + 0.25))
		let dim = CGFloat(1 - 0.6 * ease(seg(t, B2, B2 + 0.4)))
		segLine(c, LANE_A, CGPoint(x: leftEnd, y: LANE_Y), INK, A60 * dim, lw: 2, dash: [7, 6])
		if rightK > 0 {
			let rx = LANE_B.x - (LANE_B.x - (LANE_MID + gap / 2)) * CGFloat(rightK)
			segLine(c, CGPoint(x: rx, y: LANE_Y), LANE_B, INK, A60 * dim, lw: 2, dash: [7, 6])
		}
		// the tag in the gap
		let tagK = spring(t, SNAP + 0.4) * (1 - ease(seg(t, B2, B2 + 0.25)))
		if tagK > 0.003 {
			let sc = CGFloat(min(1.08, tagK))
			let w: CGFloat = 176 * sc, h: CGFloat = 34 * sc
			let r = CGRect(x: LANE_MID - w / 2, y: LANE_Y - 50 - h / 2, width: w, height: h)
			rect(c, r, fill: WHITE, fa: 1, stroke: INK, sa: A60, lw: 1.5)
			label(c, "no standard yet", r.midX, r.midY + 5 * sc, INK, A86, .center, size: 14 * sc)
			segLine(c, CGPoint(x: LANE_MID, y: r.maxY), CGPoint(x: LANE_MID, y: LANE_Y - 8), INK, A30, lw: 1.5, dash: [3, 4])
		}
		// healed: blue sweep chat -> supermemory
		let blueK = ease(seg(t, B6 + 0.45, B6 + 0.85))
		if blueK > 0 {
			let xb = LANE_A.x + (LANE_B.x - LANE_A.x) * CGFloat(blueK)
			segLine(c, LANE_A, CGPoint(x: xb, y: LANE_Y), BLUE, 1, lw: 3.5)
			if blueK >= 1 {
				c.setFillColor(col(BLUE)); c.move(to: CGPoint(x: LANE_B.x - 1, y: LANE_Y)); c.addLine(to: CGPoint(x: LANE_B.x - 14, y: LANE_Y - 8)); c.addLine(to: CGPoint(x: LANE_B.x - 14, y: LANE_Y + 8)); c.closePath(); c.fillPath()
			} else { dot(c, CGPoint(x: xb, y: LANE_Y), 5.5, BLUE, 1) }
		}
	}

	// ---- memory server -> supermemory tile
	let sIn = spring(t, B1 + 0.3)
	if sIn > 0.001 {
		var sc = CGFloat(sIn)
		if post { sc *= 1 + 0.07 * CGFloat(spring(t, RIDE_B - 0.02, freq: 3.4, zeta: 0.32) - spring(t, RIDE_B + 0.1, freq: 3.4, zeta: 0.32)) }
		let r = CGRect(x: SERVER.midX - SERVER.width * sc / 2, y: SERVER.midY - SERVER.height * sc / 2, width: SERVER.width * sc, height: SERVER.height * sc)
		if !post {
			drawTile(c, r, 1, kind: 1)
			let fillK = ease(seg(t, TURN, TURN_FILL))
			if fillK > 0 { rect(c, r, fill: BLUE, fa: CGFloat(fillK)) }
			let lk = eout(seg(t, B1 + 0.55, B1 + 0.95))
			label(c, "memory server", SERVER.midX, SERVER.maxY + 32 + 8 * CGFloat(1 - lk), INK, A60 * CGFloat(lk), .center, size: 16)
		} else {
			rect(c, r, fill: BLUE, fa: 1)
			paintMask(c, MARK, markRect(center: CGPoint(x: r.midX, y: r.midY), height: 56 * sc), WHITE, CGFloat(ease(seg(t, SHRINK_B - 0.15, SHRINK_B + 0.1))))
			let lk = eout(seg(t, SHRINK_B, SHRINK_B + 0.4))
			text(c, "supermemory", sans(24, 500), SERVER.midX, SERVER.maxY + 38 + 8 * CGFloat(1 - lk), INK, CGFloat(lk), .center)
		}
	}

	// ---- model tile
	let mIn = spring(t, B2 + 0.3)
	if mIn > 0.001 {
		let sc = CGFloat(mIn)
		let r = CGRect(x: MODEL.midX - MODEL.width * sc / 2, y: MODEL.midY - MODEL.height * sc / 2, width: MODEL.width * sc, height: MODEL.height * sc)
		drawTile(c, r, 1, kind: 0)
		let lk = eout(seg(t, B2 + 0.55, B2 + 0.95))
		label(c, "model", MODEL.midX, MODEL.maxY + 32 + 8 * CGFloat(1 - lk), INK, A60 * CGFloat(lk), .center, size: 16)
	}

	if !post {
		// ---- old path + base64 stream
		let p1 = ease(seg(t, B2 + 0.45, B2 + 0.9)), p2 = ease(seg(t, B2 + 0.7, B2 + 1.15))
		if p1 > 0 { segLine(c, PATH1_A, lerpP(PATH1_A, PATH1_B, p1), INK, A30, lw: 1.5, dash: [5, 6]) }
		if p2 > 0 { segLine(c, PATH2_A, lerpP(PATH2_A, PATH2_B, p2), INK, A30, lw: 1.5, dash: [5, 6]) }
		if t > STREAM_T0 {
			let head = CGFloat((t - STREAM_T0) * STREAM_V)
			let first = max(0, Int((head - 1000) / STREAM_SP)), last = Int(head / STREAM_SP)
			if last >= first {
				for i in first...last {
					let (p, vis, fa) = pathPoint(head - CGFloat(i) * STREAM_SP)
					if !vis { continue }
					let ch = String(B64[i % B64.count])
					if i == RED_I && t >= B3 { text(c, ch, mono(24, 650), p.x, p.y + 8, RED, fa, .center) }
					else { text(c, ch, mono(17), p.x, p.y + 6, INK, A60 * fa, .center) }
				}
			}
		}
		// ---- counter chip grows out of the model
		let chipK = ease(seg(t, B2 + 1.6, B2 + 1.9)), chipH = ease(seg(t, B2 + 1.85, B2 + 2.1))
		if chipK > 0 {
			let r = CGRect(x: CHIP.minX, y: CHIP.midY - 4 - (CHIP.height / 2 - 4) * CGFloat(chipH), width: CHIP.width * CGFloat(chipK), height: 8 + (CHIP.height - 8) * CGFloat(chipH))
			segLine(c, CGPoint(x: MODEL.maxX, y: CHIP.midY), CGPoint(x: r.minX, y: CHIP.midY), INK, A30 * CGFloat(chipK), lw: 1.5, dash: [4, 5])
			rect(c, r, fill: WHITE, fa: 1, stroke: INK, sa: A45, lw: 1.5)
			if chipH > 0 {
				let tq = (t * FPS).rounded() / FPS   // digits change per frame, never blur
				let v = Int((6_666_668.0 * eout(seg(tq, B2 + 2.0, B2 + 2.8))).rounded())
				c.saveGState(); c.clip(to: r)
				label(c, "base64 · 5 mb pdf", r.minX + 16, r.minY + 28, INK, A60 * CGFloat(chipH), size: 13)
				drawCounter(c, v, right: r.maxX - 16, base: r.maxY - 20, size: 32, CGFloat(chipH))
				c.restoreGState()
			}
		}
		// ---- corrupted file (bounded red window)
		let bad = spring(t, RED_T)
		if bad > 0.001 {
			let sc = CGFloat(bad)
			let r = CGRect(x: BAD_DOC.midX - BAD_DOC.width * sc / 2, y: BAD_DOC.midY - BAD_DOC.height * sc / 2, width: BAD_DOC.width * sc, height: BAD_DOC.height * sc)
			rect(c, r, fill: WHITE, fa: 1, stroke: RED, sa: 0.9, lw: 1.5)
			c.saveGState(); c.clip(to: r)
			c.setStrokeColor(col(RED, 0.55)); c.setLineWidth(1.5)
			var x = r.minX - r.height
			while x < r.maxX { c.move(to: CGPoint(x: x, y: r.maxY)); c.addLine(to: CGPoint(x: x + r.height, y: r.minY)); x += 9 }
			c.strokePath(); c.restoreGState()
			let lk = eout(seg(t, RED_T + 0.2, RED_T + 0.55))
			label(c, "corrupted", BAD_DOC.midX, BAD_DOC.maxY + 28, RED, CGFloat(lk), .center, size: 14)
			segLine(c, CGPoint(x: SERVER.maxX, y: BAD_DOC.midY), CGPoint(x: r.minX, y: BAD_DOC.midY), RED, 0.5 * CGFloat(lk), lw: 1.5, dash: [4, 5])
		}
	}

	// ---- the app: a square leaves supermemory, arcs into the chat, unfolds like a map
	if post {
		let travel = ease(seg(t, B4 + 0.2, B4 + 0.7))
		let unfoldX = ease(seg(t, B4 + 0.7, B4 + 0.95)), unfoldY = ease(seg(t, B4 + 0.9, B4 + 1.2))
		if travel > 0 {
			let from = CGPoint(x: SERVER.minX, y: SERVER.minY + 20), to = CGPoint(x: APP.midX, y: APP.midY)
			let ctrl = CGPoint(x: (from.x + to.x) / 2, y: min(from.y, to.y) - 160)
			let k = CGFloat(travel)
			let p = CGPoint(x: (1 - k) * (1 - k) * from.x + 2 * (1 - k) * k * ctrl.x + k * k * to.x, y: (1 - k) * (1 - k) * from.y + 2 * (1 - k) * k * ctrl.y + k * k * to.y)
			var r = lerpR(CGRect(x: p.x - 13, y: p.y - 13, width: 26, height: 26), CGRect(x: APP.minX, y: APP.midY - 13, width: APP.width, height: 26), unfoldX)
			r = lerpR(r, APP, unfoldY)
			rect(c, r, fill: WHITE, fa: 1, stroke: INK, sa: A20, lw: 1.5)
			c.setFillColor(col(BLUE)); c.fill(CGRect(x: r.minX, y: r.minY, width: r.width, height: 3))
			if travel < 1 { rect(c, r, stroke: BLUE, sa: 1, lw: 2) }
			let hk = eout(seg(t, DRAG2_B - 0.15, DRAG2_B + 0.25))   // header waits until the file has moved out of the way
			label(c, "app · sandboxed", r.minX + 16, r.minY + 31 + 6 * CGFloat(1 - hk), INK, A60 * CGFloat(hk), size: 13)
			text(c, "from supermemory", mono(13, 450), r.maxX - 14, r.minY + 31 + 6 * CGFloat(1 - hk), BLUE, CGFloat(hk), .right)
			// drop zone hint until the file lands, then the upload button
			let dz = CGFloat(ease(seg(t, B4 + 1.2, B4 + 1.5)) * (1 - ease(seg(t, DRAG2_B, DRAG2_B + 0.2))))
			if dz > 0.003 { rect(c, CGRect(x: DOC_B.x - 14, y: DOC_B.y - 14, width: DOC_W + 28, height: DOC_H + 28), stroke: INK, sa: A30 * dz, lw: 1.5, dash: [6, 5]) }
			let bt = spring(t, DRAG2_B + 0.1)
			if bt > 0.001 {
				let sc = CGFloat(bt)
				let pressed = CGFloat(1 - seg(abs(t - 16.11), 0, 0.12))
				let br = CGRect(x: BUTTON.midX - BUTTON.width * sc / 2, y: BUTTON.midY - BUTTON.height * sc / 2, width: BUTTON.width * sc, height: BUTTON.height * sc).insetBy(dx: 3 * pressed, dy: 2 * pressed)
				rect(c, br, fill: INK, fa: 1)
				label(c, "upload", br.midX, br.midY + 5, WHITE, 1, .center, size: 13)
			}
		}
	}

	// the document (above the app)
	let absorb = ease(seg(t, RIDE_B - 0.05, RIDE_B + 0.2))
	drawDoc(c, dp, 1, scale: CGFloat(1 - absorb), showLabel: t < RIDE_A)

	if post {
		// ---- ticket: springs out of supermemory on the click, clips onto the file, rides, burns
		let pop = spring(t, 16.15)
		if pop > 0.001 {
			let fly = ease(seg(t, 16.45, 17.05))
			let start = CGPoint(x: SERVER.minX - TAG_W + 40, y: SERVER.minY - 58)
			let attach = CGPoint(x: dp.x + 28, y: dp.y - 24)
			let p = fly >= 1 ? attach : lerpP(start, attach, fly)
			let left = 120 - Int(max(0, (t * FPS).rounded() / FPS - 17.05))
			let strike = CGFloat(ease(seg(t, RIDE_B - 0.15, RIDE_B + 0.05)))
			let burn = ease(seg(t, RIDE_B + 0.05, RIDE_B + 0.35))
			if burn < 1 { drawTicket(c, CGPoint(x: p.x, y: p.y - 12 * CGFloat(burn)), max(0, left), CGFloat(1 - burn), scale: CGFloat(min(1.06, pop)) * CGFloat(1 - 0.3 * burn), strike: strike) }
		}
		// ---- status after absorption
		let st = spring(t, RIDE_B + 0.3)
		if st > 0.001 {
			let a = CGFloat(min(1, st))
			let r = CGRect(x: SERVER.midX - 90, y: SERVER.maxY + 58 + 10 * (1 - a), width: 180, height: 34)
			rect(c, r, fill: WHITE, fa: a, stroke: INK, sa: A30 * a, lw: 1)
			text(c, "status: queued", mono(16), r.midX, r.midY + 6, INK, A68 * a, .center)
		}
		// ---- receipt unfolds out of the app, docks beside the model, types itself
		let rx = ease(seg(t, B7 + 0.2, B7 + 0.45)), ry = ease(seg(t, B7 + 0.4, B7 + 0.65))
		if rx > 0 {
			let dock = ease(seg(t, B7 + 0.7, B7 + 1.3))
			let birth = CGRect(x: APP.midX - RECEIPT.width / 2, y: APP.minY - RECEIPT.height - 14, width: RECEIPT.width, height: RECEIPT.height)
			var r = CGRect(x: birth.midX - birth.width * CGFloat(rx) / 2, y: birth.maxY - 3 - (birth.height - 3) * CGFloat(ry), width: birth.width * CGFloat(rx), height: 3 + (birth.height - 3) * CGFloat(ry))
			r = lerpR(r, RECEIPT, dock)
			rect(c, r, fill: WHITE, fa: 1, stroke: INK, sa: A45, lw: 1.5)
			c.setFillColor(col(BLUE)); c.fill(CGRect(x: r.minX, y: r.minY, width: 3.5, height: r.height))
			c.saveGState(); c.clip(to: r)
			let lab = CGFloat(seg(t, B7 + 0.55, B7 + 0.75))
			label(c, "receipt", r.minX + 20, r.minY + 28, BLUE, lab, size: 13)
			let l1 = "\"report.pdf\" uploaded", l2 = "do not upload it again"
			let tq = (t * FPS).rounded() / FPS
			let n1 = Int(Double(l1.count) * seg(tq, B7 + 0.9, B7 + 1.3)), n2 = Int(Double(l2.count) * seg(tq, B7 + 1.25, B7 + 1.65))
			text(c, String(l1.prefix(n1)), mono(17), r.minX + 20, r.minY + 58, INK, A86)
			text(c, String(l2.prefix(n2)), mono(17), r.minX + 20, r.minY + 84, INK, A60)
			c.restoreGState()
			let link = ease(seg(t, B7 + 1.6, B7 + 1.9))
			if link > 0 { segLine(c, CGPoint(x: RECEIPT.maxX, y: RECEIPT.midY), CGPoint(x: RECEIPT.maxX + (MODEL.minX - RECEIPT.maxX) * CGFloat(link), y: RECEIPT.midY), INK, A60, lw: 1.5) }
		}
	}

	// ---- the cursor, on top of everything in the figure
	let cs = cursorState(t)
	for pt in PRESSES { ripple(c, cs.0, t, pt) }
	drawCursor(c, cs.0, cs.1, press: cs.2)

	c.restoreGState()
	// figure caption on its plate
	let cap = "fig. " + (t < POST_T ? "01  ·  how a file reaches memory today" : "02  ·  a direct lane for files")
	let capW = textW(cap.uppercased(), mono(14, 450), track: 14 * 0.12)
	rect(c, CGRect(x: FIG.minX + 1, y: FIG.minY + 1, width: capW + 40, height: 52), fill: WHITE, fa: 1)
	c.setFillColor(col(INK, A10)); c.fill(CGRect(x: FIG.minX + 1, y: FIG.minY + 52, width: capW + 40, height: 1)); c.fill(CGRect(x: FIG.minX + capW + 40, y: FIG.minY + 1, width: 1, height: 52))
	label(c, cap, FIG.minX + 20, FIG.minY + 33, INK, A45, size: 14)
}

// ================================================================ turn flood + end card (screen space)
func drawFlood(_ c: CGContext, _ t: Double) {
	if t < FLOOD_A || t > SHRINK_B { return }
	let tileOld = worldRectToScreen(SERVER, camera(FLOOD_A - 0.001)), tileNew = worldRectToScreen(SERVER, camera(SHRINK_B + 0.001))
	let full = CGRect(x: -260, y: -260, width: CGFloat(W) + 520, height: CGFloat(H) + 520)   // overshoot the corners
	let grow = ease(seg(t, FLOOD_A, FLOOD_B)), shrink = ease(seg(t, SHRINK_A, SHRINK_B))
	var r = lerpR(tileOld, full, grow)
	if shrink > 0 { r = lerpR(full, tileNew, shrink) }
	c.saveGState(); c.clip(to: r)
	c.setFillColor(col(BLUE)); c.fill(r)
	let filmA = CGFloat(ease(seg(t, FLOOD_A + 0.05, FLOOD_B)) * (1 - ease(seg(t, SHRINK_A + 0.05, SHRINK_B - 0.05))))
	if filmA > 0.003, let img = fieldFrame(Int((t - FLOOD_A) * 60)) {
		c.saveGState(); c.setAlpha(filmA)
		c.translateBy(x: 0, y: CGFloat(H)); c.scaleBy(x: 1, y: -1)
		c.draw(img, in: CGRect(x: 0, y: 0, width: W, height: H))
		c.restoreGState()
	}
	let ka = eout(seg(t, FLOOD_B - 0.1, FLOOD_B + 0.22)) * (1 - ease(seg(t, SHRINK_A - 0.05, SHRINK_A + 0.1)))
	if ka > 0.003 {
		let dy = 40 * CGFloat(1 - ka)
		c.saveGState(); c.clip(to: CGRect(x: 0, y: 400, width: CGFloat(W), height: 260))
		label(c, "03  /  04", CGFloat(W) / 2, 462 + dy, ONBLUE, 0.85 * CGFloat(ka), .center, size: 20)
		text(c, "the fix", sans(132, 500), CGFloat(W) / 2, 606 + dy, ONBLUE, CGFloat(ka), .center)
		c.restoreGState()
	}
	c.restoreGState()
}

func drawEnd(_ c: CGContext, _ t: Double) {
	if t < END { return }
	let from = worldRectToScreen(RECEIPT, camera(END - 0.001))
	let full = CGRect(x: -200, y: -200, width: CGFloat(W) + 400, height: CGFloat(H) + 400)
	let g = ease(seg(t, END, END + 0.38))
	let r = lerpR(from, full, g)
	rect(c, r, fill: WHITE, fa: 1, stroke: INK, sa: A45 * CGFloat(1 - g), lw: 1.5)
	c.setFillColor(col(BLUE, CGFloat(1 - g))); c.fill(CGRect(x: r.minX, y: r.minY, width: 3.5, height: r.height))
	let f = sans(88, 500)
	let l1a = "the file ", l1b = "never", l1c = " passes"
	let w1 = textW(l1a, f) + textW(l1b, f) + textW(l1c, f)
	for (j, base) in [CGFloat(476), CGFloat(576)].enumerated() {
		let k = eout(seg(t, END + 0.42 + Double(j) * 0.07, END + 0.92 + Double(j) * 0.07))
		if k <= 0 { continue }
		let dy = 100 * CGFloat(1 - k)
		c.saveGState(); c.clip(to: CGRect(x: 0, y: base - 88, width: CGFloat(W), height: 106))
		if j == 0 {
			var x = CGFloat(W) / 2 - w1 / 2
			text(c, l1a, f, x, base + dy, INK, 1); x += textW(l1a, f)
			text(c, l1b, f, x, base + dy, BLUE, 1); x += textW(l1b, f)
			text(c, l1c, f, x, base + dy, INK, 1)
		} else {
			text(c, "through the model", f, CGFloat(W) / 2, base + dy, INK, 1, .center)
		}
		c.restoreGState()
	}
	let lk = eout(seg(t, END + 0.78, END + 1.28))
	if lk > 0.003 {
		let lockW = 430.0, s = lockW / (G_MW + G_GAP + G_WW)
		let mw = G_MW * s, mh = G_MH * s, ww = G_WW * s, wh = G_WH * s, gap = G_GAP * s, woff = G_WOFF * s
		let x0 = Double(W) / 2 - lockW / 2, top = 700.0 + 16 * Double(1 - lk)
		paintMask(c, MARK, CGRect(x: x0, y: top, width: mw, height: mh), LOGO_INK, CGFloat(lk))
		paintMask(c, WORD, CGRect(x: x0 + mw + gap, y: top + woff, width: ww, height: wh), LOGO_INK, CGFloat(lk))
		text(c, "supermemory.ai", mono(17), CGFloat(W) / 2, CGFloat(top + mh + 56), INK, A45 * CGFloat(lk), .center)
	}
}


// ================================================================ frame
func renderScene(_ c: CGContext, _ t: Double) {
	c.setFillColor(col(WHITE)); c.fill(CGRect(x: 0, y: 0, width: W, height: H))
	// the left rail, like the site
	c.setFillColor(col(INK, A10)); c.fill(CGRect(x: 72, y: 0, width: 1, height: H))
	drawHUD(c, t)
	drawChapterLabel(c, t)
	drawStatements(c, t)
	drawFigure(c, t)
	drawFlood(c, t)
	drawEnd(c, t)
}

func makeContext(_ data: UnsafeMutableRawPointer?) -> CGContext {
	let c = CGContext(data: data, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * 4, space: sRGB,
	                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.translateBy(x: 0, y: CGFloat(H)); c.scaleBy(x: 1, y: -1)
	c.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
	c.interpolationQuality = .high
	return c
}

/// One output frame: SUBFRAMES renders across the shutter, averaged (motion blur).
func renderFrame(_ i: Int, into out: UnsafeMutablePointer<UInt8>) {
	let n = W * H * 4
	let t0 = min(Double(i) / FPS, T_STILL)
	if t0 >= T_STILL || SUBFRAMES == 1 {
		let c = makeContext(out); renderScene(c, t0); return
	}
	let acc = UnsafeMutablePointer<UInt16>.allocate(capacity: n); acc.initialize(repeating: 0, count: n)
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { acc.deallocate(); buf.deallocate() }
	for k in 0..<SUBFRAMES {
		let t = t0 + (Double(k) / Double(SUBFRAMES) - 0.5) * SHUTTER / FPS
		let c = makeContext(buf)
		renderScene(c, max(0, t))
		DispatchQueue.concurrentPerform(iterations: 32) { q in
			for p in (q * n / 32)..<((q + 1) * n / 32) { acc[p] &+= UInt16(buf[p]) }
		}
	}
	let half = UInt16(SUBFRAMES / 2)
	DispatchQueue.concurrentPerform(iterations: 32) { q in
		for p in (q * n / 32)..<((q + 1) * n / 32) { out[p] = UInt8((acc[p] + half) / UInt16(SUBFRAMES)) }
	}
}

func writePNG(_ img: CGImage, _ url: URL) {
	let d = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}

let args = Array(CommandLine.arguments.dropFirst())
if args.first == "stills" {
	let times = args.dropFirst().compactMap(Double.init)
	var imgs: [CGImage] = []
	for t in times {
		let mem = UnsafeMutablePointer<UInt8>.allocate(capacity: W * H * 4)
		renderFrame(Int((t * FPS).rounded()), into: mem)
		let c = makeContext(mem)
		let img = c.makeImage()!
		imgs.append(img)
		writePNG(img, HERE.appendingPathComponent(String(format: "stills/t_%05.2f.png", t)))
		mem.deallocate()
	}
	let cols = 3, sc = 0.3, tw = Int(Double(W) * sc), th = Int(Double(H) * sc)
	let rows = (imgs.count + cols - 1) / cols
	let sw = cols * tw + (cols + 1) * 12, sh = rows * (th + 30) + 12
	let s = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	s.setFillColor(col(0xd8d8dc)); s.fill(CGRect(x: 0, y: 0, width: sw, height: sh))
	for (i, img) in imgs.enumerated() {
		let x = 12 + (i % cols) * (tw + 12), y = sh - (12 + (i / cols) * (th + 30) + th)
		s.draw(img, in: CGRect(x: x, y: y, width: tw, height: th))
		s.textPosition = CGPoint(x: CGFloat(x), y: CGFloat(y - 20)); CTLineDraw(ctline(String(format: "%.2fs", times[i]), mono(16), col(INK)), s)
	}
	writePNG(s.makeImage()!, HERE.appendingPathComponent("stills/sheet.png"))
	print("wrote \(imgs.count) stills + sheet")
} else if args.first == "raw" {
	let total = Int((T_END * FPS).rounded())
	let n = W * H * 4
	// One frame at a time (2026-10-06): CoreGraphics drawing on several threads at once sometimes got shape edges, and
	// once a colour, wrong, so renders were not repeatable (85 of 400 frames differed between two runs of the MCP video).
	// Only pure maths (motion-blur averaging) runs in parallel. Check: hash two `raw` runs, expect 0 differing frames.
	let batch = Int(ProcessInfo.processInfo.environment["BATCH"] ?? "") ?? 1
	let bufs = (0..<batch).map { _ in UnsafeMutablePointer<UInt8>.allocate(capacity: n) }
	let out = FileHandle.standardOutput
	var hold: Data? = nil
	var i0 = 0
	while i0 < total {
		let cnt = min(batch, total - i0)
		DispatchQueue.concurrentPerform(iterations: cnt) { k in
			let i = i0 + k
			if Double(i) / FPS >= T_STILL && hold != nil { return }
			renderFrame(i, into: bufs[k])
		}
		for k in 0..<cnt {
			let i = i0 + k
			if Double(i) / FPS >= T_STILL {
				if hold == nil { hold = Data(bytes: bufs[k], count: n) }
				out.write(hold!)
			} else {
				out.write(Data(bytesNoCopy: bufs[k], count: n, deallocator: .none))
			}
		}
		i0 += cnt
		FileHandle.standardError.write("\r\(i0)/\(total)".data(using: .utf8)!)
	}
	FileHandle.standardError.write("\n".data(using: .utf8)!)
}
