import AppKit
let args = CommandLine.arguments
let src = URL(fileURLWithPath: args[1]), dst = URL(fileURLWithPath: args[2]), maxSide = CGFloat(Double(args[3])!)
guard let img = NSImage(contentsOf: src) else { print("load fail"); exit(1) }
let s = img.size; let k = maxSide / max(s.width, s.height)
let w = Int((s.width*k).rounded()), h = Int((s.height*k).rounded())
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: w, pixelsHigh: h, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
NSColor.clear.set(); NSRect(x:0,y:0,width:w,height:h).fill()
img.draw(in: NSRect(x:0,y:0,width:w,height:h), from: .zero, operation: .sourceOver, fraction: 1)
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: dst)
print(w, h)
