// "the file the model never read": supermemory MCP App upload explainer.
// 1080x1080, 60fps, ~25s, silent. Light ground, supermemory.ai tokens, Geist + Geist Mono.
// Build:  swiftc -O render.swift -o render
// Stills: ./render stills 0 3.9 7.0 ...   (writes stills/t_<sec>.png and stills/sheet.png)
// Video:  ./render video ../mcp-upload-explainer.mp4

import Foundation
import CoreGraphics
import CoreText
import ImageIO
import AVFoundation
import UniformTypeIdentifiers

let HERE = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let W = 1080, H = 1080
let FPS = 60.0
let T_END = 24.8
let T_STILL = 23.2

// ---------------------------------------------------------------- tokens
let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
func hex(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
	CGColor(colorSpace: sRGB, components: [CGFloat((v >> 16) & 255) / 255, CGFloat((v >> 8) & 255) / 255, CGFloat(v & 255) / 255, a])!
}
let PAPER: UInt32 = 0xf4f4f6, WHITE: UInt32 = 0xffffff, INK: UInt32 = 0x0b1015
let BLUE: UInt32 = 0x0562ef, LOGO_INK: UInt32 = 0x141b34
// ink alphas (never neutral grey)
let A86: CGFloat = 0.86, A68: CGFloat = 0.68, A60: CGFloat = 0.60, A45: CGFloat = 0.45, A40: CGFloat = 0.40, A20: CGFloat = 0.20, A10: CGFloat = 0.10

// ---------------------------------------------------------------- easing
func bezier(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> (Double) -> Double {
	return { x in
		if x <= 0 { return 0 }
		if x >= 1 { return 1 }
		var lo = 0.0, hi = 1.0, t = x
		for _ in 0..<40 {
			t = (lo + hi) / 2
			let bx = 3 * (1 - t) * (1 - t) * t * x1 + 3 * (1 - t) * t * t * x2 + t * t * t
			if bx < x { lo = t } else { hi = t }
		}
		return 3 * (1 - t) * (1 - t) * t * y1 + 3 * (1 - t) * t * t * y2 + t * t * t
	}
}
let ease = bezier(0.2, 0, 0, 1)       // moves
let eout = bezier(0.22, 1, 0.36, 1)   // arrivals
func seg(_ t: Double, _ a: Double, _ b: Double) -> Double { max(0, min(1, (t - a) / (b - a))) }
func lerp(_ a: Double, _ b: Double, _ k: Double) -> Double { a + (b - a) * k }

// ---------------------------------------------------------------- fonts
for f in ["Geist.ttf", "GeistMono.ttf"] {
	CTFontManagerRegisterFontsForURL(HERE.appendingPathComponent("fonts/\(f)") as CFURL, .process, nil)
}
var fontCache: [String: CTFont] = [:]
func font(_ family: String, _ size: CGFloat, _ wght: Double) -> CTFont {
	let key = "\(family)|\(size)|\(wght)"
	if let f = fontCache[key] { return f }
	let wghtTag = 0x77676874
	let desc = CTFontDescriptorCreateWithAttributes([
		kCTFontFamilyNameAttribute: family,
		kCTFontVariationAttribute: [wghtTag: wght],
	] as CFDictionary)
	let f = CTFontCreateWithFontDescriptor(desc, size, nil)
	fontCache[key] = f
	return f
}
func sans(_ s: CGFloat, _ w: Double = 500) -> CTFont { font("Geist", s, w) }
func mono(_ s: CGFloat, _ w: Double = 400) -> CTFont { font("Geist Mono", s, w) }

func line(_ s: String, _ f: CTFont, _ c: CGColor) -> CTLine {
	CTLineCreateWithAttributedString(NSAttributedString(string: s, attributes: [
		NSAttributedString.Key(kCTFontAttributeName as String): f,
		NSAttributedString.Key(kCTForegroundColorAttributeName as String): c,
	]))
}
func width(_ s: String, _ f: CTFont) -> CGFloat {
	CGFloat(CTLineGetTypographicBounds(line(s, f, hex(INK)), nil, nil, nil))
}
enum Align { case left, center, right }
/// Draw one line of text with its baseline at y (y grows downward).
func text(_ c: CGContext, _ s: String, _ f: CTFont, _ x: CGFloat, _ y: CGFloat, _ col: UInt32, _ a: CGFloat, _ al: Align = .left) {
	if a <= 0.002 { return }
	let l = line(s, f, hex(col, a))
	let w = CGFloat(CTLineGetTypographicBounds(l, nil, nil, nil))
	let x0: CGFloat = al == .left ? x : (al == .center ? x - w / 2 : x - w)
	c.textPosition = CGPoint(x: x0, y: y)
	CTLineDraw(l, c)
}

// ---------------------------------------------------------------- shapes
func rrect(_ c: CGContext, _ r: CGRect, _ rad: CGFloat, fill: UInt32? = nil, fillA: CGFloat = 1, stroke: UInt32? = nil, strokeA: CGFloat = 1, lw: CGFloat = 2, dash: [CGFloat]? = nil) {
	let p = CGPath(roundedRect: r, cornerWidth: rad, cornerHeight: rad, transform: nil)
	if let f = fill, fillA > 0.002 { c.setFillColor(hex(f, fillA)); c.addPath(p); c.fillPath() }
	if let s = stroke, strokeA > 0.002 {
		c.setStrokeColor(hex(s, strokeA)); c.setLineWidth(lw)
		if let d = dash { c.setLineDash(phase: 0, lengths: d) } else { c.setLineDash(phase: 0, lengths: []) }
		c.addPath(p); c.strokePath()
		c.setLineDash(phase: 0, lengths: [])
	}
}

// ---------------------------------------------------------------- content
// Real base64 of a PDF-like byte stream, so the texture is honest.
let pdfBytes: Data = {
	var s = "%PDF-1.7\n%\u{e2}\u{e3}\u{cf}\u{d3}\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 12 >>\nendobj\n"
	for i in 3..<60 { s += "\(i) 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents \(i + 100) 0 R >>\nstream\nBT /F1 11 Tf 72 \(700 - i) Td (quarterly report section \(i)) Tj ET\nendstream\nendobj\n" }
	return s.data(using: .isoLatin1)!
}()
let B64 = pdfBytes.base64EncodedString()
let ROW_CHARS = 19
let b64Rows: [String] = stride(from: 0, to: B64.count - ROW_CHARS, by: ROW_CHARS).map { i in
	let a = B64.index(B64.startIndex, offsetBy: i), b = B64.index(a, offsetBy: ROW_CHARS)
	return String(B64[a..<b])
}

// Lockup (official artwork, as luminance masks) and its geometry from the memory-graph cut.
func loadMask(_ name: String) -> CGImage {
	let src = CGImageSourceCreateWithURL(HERE.appendingPathComponent(name) as CFURL, nil)!
	let img = CGImageSourceCreateImageAtIndex(src, 0, nil)!
	// convert to an 8-bit gray image to use as an alpha mask
	let g = CGContext(data: nil, width: img.width, height: img.height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
	g.draw(img, in: CGRect(x: 0, y: 0, width: img.width, height: img.height))
	return g.makeImage()!
}
let LK_MARK = loadMask("lock_mark.png"), LK_WORD = loadMask("lock_word.png")
let G_MW = 588.0, G_MH = 480.0, G_GAP = 230.0, G_WW = 3182.0, G_WH = 381.0, G_WOFF = 99.0

// ---------------------------------------------------------------- timeline
// Captions: (start, lines). Each holds until the next starts. Final rule: outgoing fades 160ms
// rising 8px; incoming starts only after, fading in 220ms rising 8px. Never two on one frame.
let CAPS: [(Double, [String])] = [
	(0.00, ["many mcp tools make the model", "type your file out as text"]),
	(3.40, ["as base64, a 5 mb pdf is", "6.7 million characters"]),
	(6.80, ["supermemory opens a small app", "inside the chat instead"]),
	(10.20, ["the app gets a one-time ticket", "that expires in 2 minutes"]),
	(13.60, ["your browser sends the file", "straight to supermemory"]),
	(17.00, ["the model only gets a receipt"]),
]
let T_CLEAR = 20.40          // stage + caption clear to paper
let T_THESIS = 20.75
let T_LOCK = 22.35

// Stage geometry (world == screen before the camera push)
let CHAT = CGRect(x: 80, y: 130, width: 520, height: 670)
let MODEL = CGRect(x: 200, y: 196, width: 280, height: 100)
let APPBOX = CGRect(x: 110, y: 440, width: 460, height: 336)
let SM = CGRect(x: 660, y: 130, width: 340, height: 670)
let DOC_W: CGFloat = 110, DOC_H: CGFloat = 140
let DOC_A = CGPoint(x: 285, y: 520)   // beat 1-2, loose in the chat
let DOC_B = CGPoint(x: 170, y: 560)   // inside the app box
let DOC_C = CGPoint(x: 720, y: 560)   // landed in supermemory
let LANE_Y: CGFloat = 630
let TAG_OFF = CGPoint(x: 44, y: -24)  // ticket clips onto the doc's top edge
let TAG_W: CGFloat = 212, TAG_H: CGFloat = 46
let TAG_START = CGPoint(x: 744, y: 250)

func camera(_ t: Double) -> Double { 1.0 + 0.02 * seg(t, 0, T_CLEAR + 0.25) }   // linear push, keeps holds alive

// ---------------------------------------------------------------- frame
func drawDoc(_ c: CGContext, _ o: CGPoint, _ a: CGFloat) {
	let r = CGRect(x: o.x, y: o.y, width: DOC_W, height: DOC_H)
	rrect(c, r, 6, fill: WHITE, fillA: a, stroke: INK, strokeA: A45 * a, lw: 2)
	// folded page lines
	for (i, w) in [70.0, 58.0, 70.0, 44.0].enumerated() {
		rrect(c, CGRect(x: o.x + 20, y: o.y + 30 + CGFloat(i) * 18, width: CGFloat(w), height: 6), 3, fill: INK, fillA: A10 * a)
	}
	text(c, "pdf", mono(24, 500), o.x + DOC_W / 2, o.y + DOC_H - 22, INK, A68 * a, .center)
	text(c, "report.pdf", mono(26), o.x + DOC_W / 2, o.y + DOC_H + 36, INK, A68 * a, .center)
}

func drawTag(_ c: CGContext, _ o: CGPoint, _ secsLeft: Int, _ a: CGFloat) {
	let r = CGRect(x: o.x, y: o.y, width: TAG_W, height: TAG_H)
	rrect(c, r, 23, fill: WHITE, fillA: a, stroke: INK, strokeA: A60 * a, lw: 2)
	c.setFillColor(hex(INK, A60 * a))
	c.fillEllipse(in: CGRect(x: o.x + 16, y: o.y + TAG_H / 2 - 5, width: 10, height: 10))
	let mm = secsLeft / 60, ss = secsLeft % 60
	text(c, "ticket", mono(24), o.x + 36, o.y + 31, INK, A60 * a)
	text(c, String(format: "%d:%02d", mm, ss), mono(26, 500), o.x + TAG_W - 18, o.y + 31, INK, A86 * a, .right)
}

func counter(_ c: CGContext, _ value: Int, _ cx: CGFloat, _ baseline: CGFloat, _ a: CGFloat) {
	// tabular: every digit in a cell as wide as the widest digit, right-aligned at a fixed edge
	let f = sans(64, 500)
	let cell = (0...9).map { width(String($0), f) }.max()!
	let comma = width(",", f)
	let full = "6,666,668"
	let total = full.reduce(CGFloat(0)) { $0 + ($1 == "," ? comma : cell) }
	let digits = Array(String(value))
	var s = ""
	for (i, d) in digits.enumerated() {
		if i > 0 && (digits.count - i) % 3 == 0 { s.append(",") }
		s.append(d)
	}
	var x = cx + total / 2
	for ch in s.reversed() {
		let w = ch == "," ? comma : cell
		x -= w
		text(c, String(ch), f, x + w / 2, baseline, INK, a, .center)
	}
}

func drawCaption(_ c: CGContext, _ t: Double) {
	for (i, cap) in CAPS.enumerated() {
		let start = cap.0
		let end = i + 1 < CAPS.count ? CAPS[i + 1].0 : T_CLEAR
		var a = 0.0, dy = 0.0
		if t < start { continue }
		if i == 0 && t < start + 0.001 { a = 1 }
		let inStart = i == 0 ? -1.0 : start + 0.16
		let k = i == 0 ? 1.0 : eout(seg(t, inStart, inStart + 0.22))
		a = k; dy = 8 * (1 - k)
		if t >= end {
			let o = ease(seg(t, end, end + 0.16))
			a = 1 - o; dy = -8 * o
		}
		if a <= 0.002 { continue }
		for (j, l) in cap.1.enumerated() {
			text(c, l, sans(44, 500), 540, CGFloat(912 + j * 56) + CGFloat(dy), INK, CGFloat(a), .center)
		}
	}
}

func render(_ c: CGContext, _ tIn: Double) {
	let t = min(tIn, T_STILL)
	// ground
	c.setFillColor(hex(PAPER)); c.fill(CGRect(x: 0, y: 0, width: W, height: H))

	let clr = CGFloat(1 - ease(seg(t, T_CLEAR, T_CLEAR + 0.25)))   // stage opacity during the clear
	if clr > 0.002 {
		c.saveGState()
		let s = CGFloat(camera(t)), cx: CGFloat = 540, cy: CGFloat = 460
		c.translateBy(x: cx, y: cy); c.scaleBy(x: s, y: s); c.translateBy(x: -cx, y: -cy)

		// HUD
		text(c, "mcp app · file upload", mono(26), 80, 92, INK, A45 * clr)

		// chat scope
		rrect(c, CHAT, 16, fill: WHITE, fillA: clr, stroke: INK, strokeA: A10 * clr, lw: 2)
		text(c, "chat", mono(26), CHAT.minX + 24, CHAT.minY + 40, INK, A60 * clr)

		// model
		rrect(c, MODEL, 12, fill: PAPER, fillA: clr, stroke: INK, strokeA: A45 * clr, lw: 2)
		text(c, "model", mono(30, 500), MODEL.midX, MODEL.midY + 11, INK, A86 * clr, .center)

		// beats 1-2: base64 stream from the doc up into the model
		let sa = CGFloat(1 - ease(seg(t, 6.80, 7.05))) * clr
		if sa > 0.002 && t < 7.1 {
			let top: CGFloat = 316, bot: CGFloat = 500, rowH: CGFloat = 30
			let speed = 62.0   // px per second, upward
			let off = CGFloat((t * speed).truncatingRemainder(dividingBy: Double(rowH)))
			let base = Int(t * speed / Double(rowH))
			c.saveGState()
			c.clip(to: CGRect(x: 160, y: top, width: 360, height: bot - top))
			for r in 0..<9 {
				let y = bot + 6 - CGFloat(r) * rowH - off
				let fadeTop = max(0, min(1, (y - top) / 50)), fadeBot = max(0, min(1, (bot + 8 - y) / 40))
				let row = b64Rows[(base + r) % b64Rows.count]
				text(c, row, mono(23), 340, y, INK, A45 * fadeTop * fadeBot * sa, .center)
			}
			c.restoreGState()
		}
		// beat 2: counter on the right
		let ca = CGFloat(eout(seg(t, 3.56, 3.90))) * CGFloat(1 - ease(seg(t, 6.80, 7.05))) * clr
		if ca > 0.002 && t < 7.1 {
			let v = Int((6_666_668.0 * eout(seg(t, 3.70, 5.70))).rounded())
			text(c, "base64 characters", mono(26), 800, 414, INK, A60 * ca, .center)
			counter(c, v, 800, 494, ca)
			text(c, "for one 5 mb pdf", mono(26), 800, 546, INK, A45 * ca, .center)
		}

		// beat 3: the app box arrives inside the chat
		let ab = CGFloat(eout(seg(t, 7.05, 7.70)))
		if ab > 0.002 {
			let r = APPBOX.offsetBy(dx: 0, dy: 12 * (1 - ab))
			rrect(c, r, 12, fill: PAPER, fillA: ab * clr, stroke: INK, strokeA: A20 * ab * clr, lw: 2)
			text(c, "app · sandboxed", mono(26), r.minX + 22, r.minY + 40, INK, A60 * ab * clr)
		}

		// supermemory scope arrives at beat 4
		let sm = CGFloat(eout(seg(t, 10.40, 11.05)))
		if sm > 0.002 {
			let r = SM.offsetBy(dx: 0, dy: 12 * (1 - sm))
			rrect(c, r, 16, fill: WHITE, fillA: sm * clr, stroke: INK, strokeA: A10 * sm * clr, lw: 2)
			text(c, "supermemory", mono(26), r.minX + 24, r.minY + 40, INK, A60 * sm * clr)
		}

		// beat 5: the direct lane (first blue in the piece)
		let lane = ease(seg(t, 13.80, 14.40))
		if lane > 0.002 {
			let x0: CGFloat = DOC_B.x + DOC_W, x1: CGFloat = DOC_C.x
			let xe = x0 + (x1 - x0) * CGFloat(lane)
			c.setStrokeColor(hex(BLUE, clr)); c.setLineWidth(3)
			c.move(to: CGPoint(x: x0, y: LANE_Y)); c.addLine(to: CGPoint(x: xe, y: LANE_Y)); c.strokePath()
			// leading dot fades 120ms after the draw completes
			let dotA = CGFloat(1 - seg(t, 14.40, 14.52)) * clr
			if dotA > 0.002 { c.setFillColor(hex(BLUE, dotA)); c.fillEllipse(in: CGRect(x: xe - 5, y: LANE_Y - 5, width: 10, height: 10)) }
			// arrowhead lands with the line
			if lane >= 1 {
				c.setFillColor(hex(BLUE, clr))
				c.move(to: CGPoint(x: x1 - 2, y: LANE_Y)); c.addLine(to: CGPoint(x: x1 - 16, y: LANE_Y - 8)); c.addLine(to: CGPoint(x: x1 - 16, y: LANE_Y + 8)); c.closePath(); c.fillPath()
			}
		}

		// the document
		let mv1 = ease(seg(t, 7.80, 8.60))       // into the app box
		let mv2 = ease(seg(t, 14.50, 15.40))     // down the lane into supermemory
		var dp = CGPoint(x: lerp(Double(DOC_A.x), Double(DOC_B.x), mv1), y: lerp(Double(DOC_A.y), Double(DOC_B.y), mv1))
		if mv2 > 0 { dp = CGPoint(x: lerp(Double(DOC_B.x), Double(DOC_C.x), mv2), y: Double(DOC_B.y)) }
		drawDoc(c, dp, clr)

		// the ticket: minted in supermemory, flies to the app, clips onto the doc, burns on arrival
		let tagIn = eout(seg(t, 10.85, 11.30))
		if tagIn > 0.002 {
			let down = ease(seg(t, 11.30, 11.80)), across = ease(seg(t, 11.85, 12.50))
			let attach = CGPoint(x: dp.x + TAG_OFF.x, y: dp.y + TAG_OFF.y)
			var tp = CGPoint(x: lerp(Double(TAG_START.x), Double(attach.x), across), y: lerp(Double(TAG_START.y), Double(attach.y), down))
			if across >= 1 { tp = attach }
			let burn = ease(seg(t, 15.45, 15.75))
			tp.y -= CGFloat(8 * burn)
			let left = 120 - Int(max(0, t - 12.50))
			drawTag(c, tp, max(left, 0), CGFloat(tagIn) * CGFloat(1 - burn) * clr)
		}
		// status pill once it lands
		let st = CGFloat(eout(seg(t, 15.60, 16.15))) * clr
		if st > 0.002 {
			let r = CGRect(x: DOC_C.x - 6, y: DOC_C.y + DOC_H + 50 + 10 * (1 - st), width: 236, height: 40)
			rrect(c, r, 22, fill: PAPER, fillA: st, stroke: INK, strokeA: A20 * st, lw: 2)
			text(c, "status: queued", mono(24), r.midX, r.minY + 28, INK, A68 * st, .center)
		}

		// beat 6: the receipt rises from the app to the model
		let rIn = eout(seg(t, 17.20, 17.65))
		if rIn > 0.002 {
			let up = ease(seg(t, 17.20, 18.00))
			let y = lerp(372, 316, up)
			let r = CGRect(x: 150, y: y, width: 380, height: 92)
			rrect(c, r, 10, fill: WHITE, fillA: CGFloat(rIn) * clr, stroke: INK, strokeA: A45 * CGFloat(rIn) * clr, lw: 2)
			text(c, "\"report.pdf\" uploaded", mono(24), r.minX + 22, r.minY + 38, INK, A86 * CGFloat(rIn) * clr)
			text(c, "do not upload it again", mono(24), r.minX + 22, r.minY + 72, INK, A60 * CGFloat(rIn) * clr)
		}
		c.restoreGState()
	}

	// captions (screen space, no push)
	drawCaption(c, t)

	// end card: thesis, then the lockup, then a still hold
	let th = CGFloat(eout(seg(t, T_THESIS, T_THESIS + 0.70)))
	if th > 0.002 {
		let dy = 12 * (1 - th)
		let f = sans(68, 500)
		let l1a = "the file ", l1b = "never", l1c = " passes"
		let w1 = width(l1a, f) + width(l1b, f) + width(l1c, f)
		var x = 540 - w1 / 2
		let y1: CGFloat = 430 + dy
		text(c, l1a, f, x, y1, INK, th); x += width(l1a, f)
		text(c, l1b, f, x, y1, BLUE, th); x += width(l1b, f)
		text(c, l1c, f, x, y1, INK, th)
		text(c, "through the model", f, 540, 512 + dy, INK, th, .center)
	}
	let lk = CGFloat(eout(seg(t, T_LOCK, T_LOCK + 0.65)))
	if lk > 0.002 {
		let lockW = 430.0, s = lockW / (G_MW + G_GAP + G_WW)
		let mw = G_MW * s, mh = G_MH * s, ww = G_WW * s, wh = G_WH * s, gap = G_GAP * s, woff = G_WOFF * s
		let x0 = 540 - lockW / 2, top = 650.0 + 14 * Double(1 - lk)
		for (img, r) in [(LK_MARK, CGRect(x: x0, y: top, width: mw, height: mh)), (LK_WORD, CGRect(x: x0 + mw + gap, y: top + woff, width: ww, height: wh))] {
			c.saveGState()
			// masks are drawn in a flipped context: un-flip locally so the art is upright
			c.translateBy(x: 0, y: r.maxY + r.minY); c.scaleBy(x: 1, y: -1)
			c.clip(to: r, mask: img)
			c.setFillColor(hex(LOGO_INK, lk)); c.fill(r)
			c.restoreGState()
		}
		text(c, "supermemory.ai", mono(28), 540, CGFloat(top + mh + 66), INK, A60 * lk, .center)
	}
}

// ---------------------------------------------------------------- output
func makeContext(_ data: UnsafeMutableRawPointer?, _ bpr: Int) -> CGContext {
	let c = CGContext(data: data, width: W, height: H, bitsPerComponent: 8, bytesPerRow: bpr, space: sRGB,
	                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	c.translateBy(x: 0, y: CGFloat(H)); c.scaleBy(x: 1, y: -1)   // y grows downward
	c.textMatrix = CGAffineTransform(scaleX: 1, y: -1)
	c.setShouldSmoothFonts(false)
	c.interpolationQuality = .high
	return c
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
		let c = makeContext(nil, 0)
		render(c, t)
		let img = c.makeImage()!
		imgs.append(img)
		writePNG(img, HERE.appendingPathComponent(String(format: "stills/t_%05.2f.png", t)))
	}
	// contact sheet: 4 columns at 1/3 scale with time labels
	let cols = 4, sc = 1.0 / 3.0, tw = Int(Double(W) * sc), thh = Int(Double(H) * sc)
	let rows = (imgs.count + cols - 1) / cols
	let sw = cols * tw + (cols + 1) * 12, sh = rows * (thh + 34) + 12
	let s = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	s.setFillColor(hex(0xdddddf)); s.fill(CGRect(x: 0, y: 0, width: sw, height: sh))
	for (i, img) in imgs.enumerated() {
		let col = i % cols, row = i / cols
		let x = 12 + col * (tw + 12), y = sh - (12 + row * (thh + 34) + thh)
		s.draw(img, in: CGRect(x: x, y: y, width: tw, height: thh))
		let l = line(String(format: "%.2fs", times[i]), mono(18), hex(INK))
		s.textPosition = CGPoint(x: CGFloat(x), y: CGFloat(y - 22)); CTLineDraw(l, s)
	}
	writePNG(s.makeImage()!, HERE.appendingPathComponent("stills/sheet.png"))
	print("wrote \(imgs.count) stills + sheet")
} else if args.first == "raw" {
	// BGRA frames on stdout for ffmpeg/libx264 (identical bytes for the still ending)
	let n = Int((T_END * FPS).rounded())
	let bpr = W * 4
	let buf = UnsafeMutableRawPointer.allocate(byteCount: bpr * H, alignment: 64)
	var holdData: Data? = nil
	let out = FileHandle.standardOutput
	for i in 0..<n {
		let t = Double(i) / FPS
		if t >= T_STILL, let h = holdData { out.write(h); continue }
		let c = makeContext(buf, bpr)
		render(c, t)
		let d = Data(bytes: buf, count: bpr * H)
		if t >= T_STILL { holdData = d }
		out.write(d)
	}
} else if args.first == "video", args.count > 1 {
	let out = URL(fileURLWithPath: args[1], relativeTo: HERE)
	try? FileManager.default.removeItem(at: out)
	let writer = try! AVAssetWriter(outputURL: out, fileType: .mp4)
	let settings: [String: Any] = [
		AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: W, AVVideoHeightKey: H,
		AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: 9_000_000, AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel, AVVideoExpectedSourceFrameRateKey: 60, AVVideoMaxKeyFrameIntervalKey: 120],
		AVVideoColorPropertiesKey: [AVVideoColorPrimariesKey: AVVideoColorPrimaries_ITU_R_709_2, AVVideoTransferFunctionKey: AVVideoTransferFunction_ITU_R_709_2, AVVideoYCbCrMatrixKey: AVVideoYCbCrMatrix_ITU_R_709_2],
	]
	let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
	input.expectsMediaDataInRealTime = false
	let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
		kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA, kCVPixelBufferWidthKey as String: W, kCVPixelBufferHeightKey as String: H,
	])
	writer.add(input)
	writer.startWriting(); writer.startSession(atSourceTime: .zero)
	let n = Int((T_END * FPS).rounded())
	var holdFrame: CVPixelBuffer? = nil
	for i in 0..<n {
		while !input.isReadyForMoreMediaData { usleep(2000) }
		let t = Double(i) / FPS
		var pb: CVPixelBuffer
		if t >= T_STILL, let h = holdFrame { pb = h }   // bit-identical still ending
		else {
			var p: CVPixelBuffer? = nil
			CVPixelBufferPoolCreatePixelBuffer(nil, adaptor.pixelBufferPool!, &p)
			pb = p!
			CVPixelBufferLockBaseAddress(pb, [])
			let c = makeContext(CVPixelBufferGetBaseAddress(pb), CVPixelBufferGetBytesPerRow(pb))
			render(c, t)
			CVPixelBufferUnlockBaseAddress(pb, [])
			CVBufferSetAttachment(pb, kCVImageBufferColorPrimariesKey, kCVImageBufferColorPrimaries_ITU_R_709_2, .shouldPropagate)
			CVBufferSetAttachment(pb, kCVImageBufferTransferFunctionKey, kCVImageBufferTransferFunction_ITU_R_709_2, .shouldPropagate)
			CVBufferSetAttachment(pb, kCVImageBufferYCbCrMatrixKey, kCVImageBufferYCbCrMatrix_ITU_R_709_2, .shouldPropagate)
			if t >= T_STILL { holdFrame = pb }
		}
		adaptor.append(pb, withPresentationTime: CMTime(value: CMTimeValue(i), timescale: 60))
	}
	input.markAsFinished()
	let sem = DispatchSemaphore(value: 0)
	writer.finishWriting { sem.signal() }
	sem.wait()
	print(writer.status == .completed ? "wrote \(out.path) (\(n) frames)" : "failed: \(String(describing: writer.error))")
}
