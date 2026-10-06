// ================================================================ background (v6): supermemory's hero film
// supermemory.ai/brand/media/field.mp4 (1280x720, 25fps, 32s, downloaded 2026-10-06 with her OK): six scenes cut every
// 4s (cosmos 0-2 + 22-32, blossoms 2-6, rock 6-10, thistles with orange memory tiles 10-14, mountain 14-18, flower
// 18-22). The site shows it under a multiply tint (#0562ef at 62%), so the plate carries the same tint: each channel x
// (0.392, 0.618, 0.961). `bg/plate_2112x1188.rgb` is the film, lanczos-scaled to 1.1x the frame (room for parallax),
// built by make.sh. The scenes are cut to the music's hits, the way the site cycles them.

let PLATE_W = 2112, PLATE_H = 1188
let PLATE_MX: Float = 96, PLATE_MY: Float = 54          // margin around the 1920x1080 design frame
let FILM_FPS = 25.0
let PLATE_BYTES = PLATE_W * PLATE_H * 3
let PLATE: (UnsafePointer<UInt8>, Int) = {
	let path = HERE.appendingPathComponent("bg/plate_2112x1188.rgb").path
	let fd = open(path, O_RDONLY)
	precondition(fd >= 0, "missing \(path): run make.sh")
	let size = Int(lseek(fd, 0, SEEK_END))
	let p = mmap(nil, size, PROT_READ, MAP_PRIVATE, fd, 0)!
	return (UnsafePointer(p.assumingMemoryBound(to: UInt8.self)), size / PLATE_BYTES)
}()

/// Which film time plays when: one scene per section, every cut on a hit.
struct Cut { let t0: Double; let t1: Double; let f0: Double; let f1: Double; var settle = false }
let EDL: [Cut] = [
	Cut(t0: 0, t1: ENTER, f0: 22.0, f1: 25.0),               // cosmos (the site's hero) under the console
	Cut(t0: ENTER, t1: TABS_T, f0: 6.2, f1: 9.2),            // rock at the edges of the terminal, on the drop
	Cut(t0: TABS_T, t1: END, f0: 25.0, f1: 30.25),           // the cosmos again, as if it kept playing behind the terminal
	Cut(t0: END, t1: HEAD_T, f0: 14.3, f1: 17.675),          // the mountain, as the card drops and the plugins orbit
	// the cosmos for the line (the loop's first seconds, fresh frames), slowing from real time to a stop at the still
	Cut(t0: HEAD_T, t1: T_STILL, f0: 0.05, f1: 0.05 + (T_STILL - HEAD_T) / 2, settle: true),
]
/// The film's own hard cuts (every 4s from 2s): never blend a frame into the next scene.
let FILM_CUTS: Set<Int> = [50, 150, 250, 350, 450, 550]
// The thistles with the orange memory tiles (film 10-14s) were tried behind the tabs and dropped: the tiles
// crowded the white logo chips, and the fine detail showed the 720p source's softness at 1.9x.
func filmTime(_ t: Double) -> Double {
	for c in EDL where t < c.t1 {
		let u = max(0, t - c.t0) / (c.t1 - c.t0)
		return c.f0 + (c.f1 - c.f0) * (c.settle ? u * (2 - u) : u)
	}
	return EDL.last!.f1
}

/// Parallax: the film moves 6% as far as the world on screen and zooms by the 0.2 power of the camera, so camera
/// moves keep their depth. Zero at the end.
func bgXform(_ t: Double) -> (off: CGPoint, zb: CGFloat) {
	let cam = camera(t), ce = camera(T_END)
	let k = 0.06 * CGFloat(cam.1)
	return (CGPoint(x: -(cam.0.x - ce.0.x) * k, y: -(cam.0.y - ce.0.y) * k), CGFloat(pow(cam.1 / ce.1, 0.2)))
}

/// Triangular dither, 256x256, about 1.6 levels: no 8-bit banding in the upscale.
let DITHER: UnsafeMutablePointer<Float> = {
	let p = UnsafeMutablePointer<Float>.allocate(capacity: 256 * 256)
	var s: UInt64 = 0x9E3779B97F4A7C15
	func r() -> Float { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return Float(s % 1_000_000) / 1_000_000 }
	for i in 0..<(256 * 256) { p[i] = (r() + r() - 1) * 1.6 }
	return p
}()

/// The film at time t into a BGRA buffer (PW x PH): bilinear from the plate, blended between the film's 25fps frames
/// so it plays smoothly at 60. Pure maths, so the rows run in parallel (no CoreGraphics here).
func paintBackground(_ out: UnsafeMutablePointer<UInt8>, _ t: Double) {
	let ft = filmTime(t) * FILM_FPS
	let i0 = min(PLATE.1 - 1, max(0, Int(ft.rounded(.down)))), i1 = min(PLATE.1 - 1, i0 + 1)
	let wf = FILM_CUTS.contains(i1) ? 0 : Float(ft - Double(i0))
	let fa = PLATE.0 + i0 * PLATE_BYTES, fb = PLATE.0 + i1 * PLATE_BYTES
	let (off, zb) = bgXform(t)
	let ox = Float(off.x), oy = Float(off.y), z = Float(zb), sc = Float(SC)
	let xs0 = UnsafeMutablePointer<Int>.allocate(capacity: PW), xs1 = UnsafeMutablePointer<Int>.allocate(capacity: PW)
	let wxs = UnsafeMutablePointer<Float>.allocate(capacity: PW)
	defer { xs0.deallocate(); xs1.deallocate(); wxs.deallocate() }
	for X in 0..<PW {
		let x = (Float(X) + 0.5) / sc
		let px = max(0, min(Float(PLATE_W - 1), 960 + (x - ox - 960) / z + PLATE_MX - 0.5))
		let x0 = min(Int(px), PLATE_W - 2)
		xs0[X] = x0 * 3; xs1[X] = (x0 + 1) * 3; wxs[X] = px - Float(x0)
	}
	DispatchQueue.concurrentPerform(iterations: PH) { Y in
		let y = (Float(Y) + 0.5) / sc
		let py = max(0, min(Float(PLATE_H - 1), 540 + (y - oy - 540) / z + PLATE_MY - 0.5))
		let y0 = min(Int(py), PLATE_H - 2), wy = py - Float(y0)
		let a0 = fa + y0 * PLATE_W * 3, a1 = a0 + PLATE_W * 3
		let b0 = fb + y0 * PLATE_W * 3, b1 = b0 + PLATE_W * 3
		let row = out + Y * PW * 4
		let dr = DITHER + (Y & 255) * 256
		for X in 0..<PW {
			let p = xs0[X], q = xs1[X], wx = wxs[X], n = dr[X & 255]
			let o = row + X * 4
			for ch in 0..<3 {
				let ta = Float(a0[p + ch]) + (Float(a0[q + ch]) - Float(a0[p + ch])) * wx
				let ba = Float(a1[p + ch]) + (Float(a1[q + ch]) - Float(a1[p + ch])) * wx
				let tb = Float(b0[p + ch]) + (Float(b0[q + ch]) - Float(b0[p + ch])) * wx
				let bb = Float(b1[p + ch]) + (Float(b1[q + ch]) - Float(b1[p + ch])) * wx
				let va = ta + (ba - ta) * wy, vb = tb + (bb - tb) * wy
				o[2 - ch] = UInt8(max(0, min(255, (va + (vb - va) * wf + n).rounded())))
			}
			o[3] = 255
		}
	}
}
