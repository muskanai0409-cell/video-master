// ================================================================ frames
func renderOne(_ out: UnsafeMutablePointer<UInt8>, _ t: Double) {
	paintField(out, t)
	let c = makeContext(out)
	drawGrid(c, t)
	drawHook(c, t)
	c.saveGState(); applyCam(c, stageCam(t)); drawStage(c, t); c.restoreGState()
	drawEnd(c, t)
	drawHUD(c, t)
	c.flush()
}
func renderFrame(_ i: Int, into out: UnsafeMutablePointer<UInt8>) {
	let n = PW * PH * 4
	let t0 = min(Double(i) / FPS, T_STILL)
	if t0 >= T_STILL || SUBFRAMES == 1 { renderOne(out, t0); return }
	let acc = UnsafeMutablePointer<UInt16>.allocate(capacity: n); acc.initialize(repeating: 0, count: n)
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	defer { acc.deallocate(); buf.deallocate() }
	for k in 0..<SUBFRAMES {
		let t = max(0, t0 + (Double(k) / Double(SUBFRAMES) - 0.5) * SHUTTER / FPS)
		renderOne(buf, t)
		DispatchQueue.concurrentPerform(iterations: 32) { q in
			for p in (q * n / 32)..<((q + 1) * n / 32) { acc[p] &+= UInt16(buf[p]) }
		}
	}
	let half = UInt16(SUBFRAMES / 2)
	DispatchQueue.concurrentPerform(iterations: 32) { q in
		for p in (q * n / 32)..<((q + 1) * n / 32) { out[p] = UInt8((acc[p] + half) / UInt16(SUBFRAMES)) }
	}
}

// ================================================================ entry
let args = Array(CommandLine.arguments.dropFirst())
if args.first == "stills" {
	let times = args.dropFirst().compactMap(Double.init)
	var imgs: [CGImage] = []
	for t in times {
		let mem = UnsafeMutablePointer<UInt8>.allocate(capacity: PW * PH * 4)
		let t0 = Date()
		renderFrame(Int((t * FPS).rounded()), into: mem)
		FileHandle.standardError.write(String(format: "t=%.2f %.2fs\n", t, Date().timeIntervalSince(t0)).data(using: .utf8)!)
		let img = makeContext(mem).makeImage()!
		imgs.append(img)
		writePNG(img, HERE.appendingPathComponent(String(format: "stills/t_%05.2f.png", t)))
		mem.deallocate()
	}
	let cols = 3, tw = 640, th = 360
	let rows = (imgs.count + cols - 1) / cols
	let sw = cols * tw + (cols + 1) * 12, sh = rows * (th + 30) + 12
	let s = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	s.interpolationQuality = .high
	s.setFillColor(col(0xd8d8dc)); s.fill(CGRect(x: 0, y: 0, width: sw, height: sh))
	for (i, img) in imgs.enumerated() {
		let x = 12 + (i % cols) * (tw + 12), y = sh - (12 + (i / cols) * (th + 30) + th)
		s.draw(img, in: CGRect(x: x, y: y, width: tw, height: th))
		s.textPosition = CGPoint(x: CGFloat(x), y: CGFloat(y - 20)); CTLineDraw(ctline(String(format: "%.2fs", times[i]), mono(16), col(INK)), s)
	}
	writePNG(s.makeImage()!, HERE.appendingPathComponent("stills/sheet.png"))
	print("wrote \(imgs.count) stills + sheet")
} else if args.first == "info" {
	print(PW, PH, Int(FPS), Int((T_END * FPS).rounded()), Int((T_STILL * FPS).rounded()))
} else if args.first == "raw" {
	let total = Int((T_END * FPS).rounded())
	let from = args.count > 1 ? Int(args[1])! : 0, to = args.count > 2 ? Int(args[2])! : total
	let n = PW * PH * 4
	let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
	let out = FileHandle.standardOutput
	var hold: Data? = nil
	for i in from..<to {
		if Double(i) / FPS >= T_STILL {
			if hold == nil { renderFrame(i, into: buf); hold = Data(bytes: buf, count: n) }
			out.write(hold!)
		} else {
			renderFrame(i, into: buf)
			out.write(Data(bytesNoCopy: buf, count: n, deallocator: .none))
		}
		if i % 30 == 0 { FileHandle.standardError.write("\r\(i)/\(total)".data(using: .utf8)!) }
	}
	FileHandle.standardError.write("\n".data(using: .utf8)!)
}
