// gpu.swift: run a Metal compute shader per frame and stream BGRA frames to stdout (for ffmpeg), or write PNG stills.
// No installs: Metal compiles the .metal source at runtime. The kernel signature is fixed:
//   kernel void frame(texture2d<float, access::write> out [[texture(0)]],
//                     texture2d<float, access::read> src [[texture(1)]],   // optional input (black if none)
//                     constant Uniforms& u [[buffer(0)]],
//                     uint2 gid [[thread_position_in_grid]])
//   struct Uniforms { float time; float2 res; float frame; float p0, p1, p2, p3; };
// Usage:
//   ./gpu <shader.metal> stills <W> <H> <t1> <t2> ...          -> stills/<shader>_<t>.png
//   ./gpu <shader.metal> raw <W> <H> <fps> <seconds> [sub]     -> BGRA frames on stdout (sub = motion-blur subframes)
import Foundation
import Metal
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

struct Uniforms { var time: Float; var res: SIMD2<Float>; var frame: Float; var p0: Float; var p1: Float; var p2: Float; var p3: Float }

let args = CommandLine.arguments
let shaderPath = args[1], mode = args[2]
let W = Int(args[3])!, H = Int(args[4])!
let dev = MTLCreateSystemDefaultDevice()!
let queue = dev.makeCommandQueue()!
let src = try! String(contentsOfFile: shaderPath, encoding: .utf8)
let lib: MTLLibrary
do { lib = try dev.makeLibrary(source: src, options: nil) } catch { FileHandle.standardError.write("shader compile error:\n\(error)\n".data(using: .utf8)!); exit(1) }
let pso = try! dev.makeComputePipelineState(function: lib.makeFunction(name: "frame")!)
let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba16Float, width: W, height: H, mipmapped: false)
desc.usage = [.shaderWrite, .shaderRead]; desc.storageMode = .shared
let outTex = dev.makeTexture(descriptor: desc)!
// an optional field texture: SDF=<file.f32> SDFN=<size> in the environment (r32Float, sampled bilinearly as texture 1)
let env = ProcessInfo.processInfo.environment
let inTex: MTLTexture = {
	if let path = env["SDF"], let n = Int(env["SDFN"] ?? "512"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
		let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r32Float, width: n, height: n, mipmapped: false)
		d.usage = [.shaderRead]; d.storageMode = .shared
		let t = dev.makeTexture(descriptor: d)!
		data.withUnsafeBytes { t.replace(region: MTLRegionMake2D(0, 0, n, n), mipmapLevel: 0, withBytes: $0.baseAddress!, bytesPerRow: n * 4) }
		return t
	}
	let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r32Float, width: 8, height: 8, mipmapped: false)
	d.usage = [.shaderRead]; d.storageMode = .shared
	return dev.makeTexture(descriptor: d)!
}()
let P = (4..<12).compactMap { i -> Float? in i < args.count ? Float(args[i]) : nil }

func render(_ t: Double, _ frameIndex: Int) -> [Float16] {
	var u = Uniforms(time: Float(t), res: SIMD2(Float(W), Float(H)), frame: Float(frameIndex), p0: 0, p1: 0, p2: 0, p3: 0)
	let cb = queue.makeCommandBuffer()!
	let enc = cb.makeComputeCommandEncoder()!
	enc.setComputePipelineState(pso)
	enc.setTexture(outTex, index: 0); enc.setTexture(inTex, index: 1)
	enc.setBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 0)
	let tg = MTLSize(width: 16, height: 16, depth: 1)
	enc.dispatchThreadgroups(MTLSize(width: (W + 15) / 16, height: (H + 15) / 16, depth: 1), threadsPerThreadgroup: tg)
	enc.endEncoding(); cb.commit(); cb.waitUntilCompleted()
	var px = [Float16](repeating: 0, count: W * H * 4)
	outTex.getBytes(&px, bytesPerRow: W * 8, from: MTLRegionMake2D(0, 0, W, H), mipmapLevel: 0)
	return px
}
@inline(__always) func to8(_ v: Float) -> UInt8 {
	// linear-ish shader output is treated as display-referred sRGB already; clamp and add tiny dither against banding
	return UInt8(max(0, min(255, v * 255 + 0.5)))
}
func bgra(_ px: [Float16]) -> [UInt8] {
	var o = [UInt8](repeating: 255, count: W * H * 4)
	for i in 0..<(W * H) {
		let r = Float(px[i * 4]), g = Float(px[i * 4 + 1]), b = Float(px[i * 4 + 2])
		o[i * 4] = to8(b); o[i * 4 + 1] = to8(g); o[i * 4 + 2] = to8(r)
	}
	return o
}
func writePNG(_ bytes: [UInt8], _ path: String) {
	var b = bytes
	let ctx = b.withUnsafeMutableBytes { raw in
		CGContext(data: raw.baseAddress, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
		          bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
	}
	let img = ctx.makeImage()!
	let d = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(d, img, nil); CGImageDestinationFinalize(d)
}

let name = URL(fileURLWithPath: shaderPath).deletingPathExtension().lastPathComponent
if mode == "stills" {
	try? FileManager.default.createDirectory(atPath: "stills", withIntermediateDirectories: true)
	for a in args.dropFirst(5) {
		guard let t = Double(a) else { continue }
		let t0 = Date()
		writePNG(bgra(render(t, Int(t * 60))), String(format: "stills/%@_%05.2f.png", name, t))
		FileHandle.standardError.write(String(format: "t=%.2f %.2fs\n", t, Date().timeIntervalSince(t0)).data(using: .utf8)!)
	}
} else if mode == "raw" {
	let fps = Double(args[5])!, secs = Double(args[6])!, sub = args.count > 7 ? Int(args[7])! : 1
	let n = Int((secs * fps).rounded())
	let out = FileHandle.standardOutput
	for f in 0..<n {
		if sub <= 1 { out.write(Data(bgra(render(Double(f) / fps, f)))); continue }
		var acc = [Float](repeating: 0, count: W * H * 4)
		for s in 0..<sub {
			let t = (Double(f) + (Double(s) + 0.5) / Double(sub) * 0.5 - 0.25) / fps          // 180-degree shutter
			let px = render(max(0, t), f)
			for i in 0..<(W * H * 4) { acc[i] += Float(px[i]) }
		}
		var o = [UInt8](repeating: 255, count: W * H * 4)
		let k = 1 / Float(sub)
		for i in 0..<(W * H) { o[i * 4] = to8(acc[i * 4 + 2] * k); o[i * 4 + 1] = to8(acc[i * 4 + 1] * k); o[i * 4 + 2] = to8(acc[i * 4] * k) }
		out.write(Data(o))
		if f % 30 == 0 { FileHandle.standardError.write("\r\(f)/\(n)".data(using: .utf8)!) }
	}
	FileHandle.standardError.write("\n".data(using: .utf8)!)
}
