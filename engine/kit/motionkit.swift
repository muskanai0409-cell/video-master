// motionkit.swift: the research turned into code (motion-mastery.md, lanes A and B, premium-motion.md).
// Concatenate it into a film's build like lib.swift. Nothing here is a house default: a film picks a curve family and a
// cadence on its style card, and passes them in. Every function is pure in t, so frames render in any order.
import Foundation

// ================================================================ curves
/// A cubic-bezier easing curve, solved for y at a given x (Newton, then bisection).
struct Bezier {
	let x1, y1, x2, y2: Double
	init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) { self.x1 = x1; self.y1 = y1; self.x2 = x2; self.y2 = y2 }
	private func bx(_ t: Double) -> Double { let u = 1 - t; return 3 * u * u * t * x1 + 3 * u * t * t * x2 + t * t * t }
	private func by(_ t: Double) -> Double { let u = 1 - t; return 3 * u * u * t * y1 + 3 * u * t * t * y2 + t * t * t }
	private func dbx(_ t: Double) -> Double { let u = 1 - t; return 3 * u * u * x1 + 6 * u * t * (x2 - x1) + 3 * t * t * (1 - x2) }
	func callAsFunction(_ x: Double) -> Double {
		if x <= 0 { return 0 }; if x >= 1 { return 1 }
		var t = x
		for _ in 0..<8 { let d = dbx(t); if abs(d) < 1e-7 { break }; let e = bx(t) - x; if abs(e) < 1e-7 { return by(t) }; t -= e / d }
		var lo = 0.0, hi = 1.0; t = x
		for _ in 0..<40 { let v = bx(t); if abs(v - x) < 1e-7 { break }; if v < x { lo = t } else { hi = t }; t = (lo + hi) / 2 }
		return by(t)
	}
}

/// A curve family: one curve per role, from a published motion system. Pick one per film on the style card and do not
/// reuse the last film's family (anti-house rule 5). Exits run at about half the entrance duration.
struct CurveFamily {
	let name: String
	let enter: Bezier, move: Bezier, exit: Bezier, camera: Bezier
	let enterDur: Double, moveDur: Double                      // seconds
	var exitDur: Double { enterDur * 0.5 }
}
enum Families {
	/// Material 3: emphasized decelerate to enter, standard to move, emphasized accelerate to exit (m3 tokens)
	static let material = CurveFamily(name: "material", enter: Bezier(0.05, 0.7, 0.1, 1), move: Bezier(0.2, 0, 0, 1),
	                                  exit: Bezier(0.3, 0, 0.8, 0.15), camera: Bezier(0.2, 0, 0, 1), enterDur: 0.5, moveDur: 0.5)
	/// IBM Carbon, productive: quick and efficient (UI, information)
	static let carbonProductive = CurveFamily(name: "carbon-productive", enter: Bezier(0, 0, 0.38, 0.9), move: Bezier(0.2, 0, 0.38, 0.9),
	                                          exit: Bezier(0.2, 0, 1, 0.9), camera: Bezier(0.2, 0, 0.38, 0.9), enterDur: 0.24, moveDur: 0.24)
	/// IBM Carbon, expressive: considered, for hero moments
	static let carbonExpressive = CurveFamily(name: "carbon-expressive", enter: Bezier(0, 0, 0.3, 1), move: Bezier(0.4, 0.14, 0.3, 1),
	                                          exit: Bezier(0.4, 0.14, 1, 1), camera: Bezier(0.4, 0.14, 0.3, 1), enterDur: 0.6, moveDur: 0.7)
	/// Luxury web (ascenta, Lenis era): one long expo-out, expo in-out to cross the frame
	static let luxury = CurveFamily(name: "luxury-expo", enter: Bezier(0.16, 1, 0.3, 1), move: Bezier(0.77, 0, 0.175, 1),
	                                exit: Bezier(0.7, 0, 0.84, 0), camera: Bezier(0.2, 0.6, 0.4, 1), enterDur: 1.0, moveDur: 1.2)
	/// Editorial: quart-out reveals, slow and few
	static let editorial = CurveFamily(name: "editorial-quart", enter: Bezier(0.165, 0.84, 0.44, 1), move: Bezier(0.77, 0, 0.175, 1),
	                                   exit: Bezier(0.5, 0, 0.75, 0), camera: Bezier(0.45, 0, 0.55, 1), enterDur: 1.2, moveDur: 1.0)
	static let all = [material, carbonProductive, carbonExpressive, luxury, editorial]
}
func clamp01(_ x: Double) -> Double { max(0, min(1, x)) }
/// progress of a tween from t0 over dur on a curve
func tween(_ t: Double, _ t0: Double, _ dur: Double, _ c: Bezier) -> Double { c(clamp01((t - t0) / dur)) }
func expoOut(_ p: Double) -> Double { p >= 1 ? 1 : 1 - pow(2, -10 * clamp01(p)) }

// ================================================================ springs, set by duration and bounce (Apple's model)
/// The step response of a spring defined like SwiftUI's Spring(duration:bounce:). Damping ratio = 1 - bounce (checked on
/// this Mac, lane B 7.2). bounce 0 is critically damped (the default: no overshoot); 0.15 barely reads; keep under 0.3,
/// and use overshoot only for things thrown, dropped or released (anti-house rule 6).
func spring(_ t: Double, _ t0: Double, duration: Double, bounce: Double = 0) -> Double {
	let tau = t - t0
	if tau <= 0 { return 0 }
	let w = 2 * Double.pi / duration, z = 1 - bounce
	if z >= 1 { return 1 - exp(-w * tau) * (1 + w * tau) }
	let wd = w * sqrt(1 - z * z)
	return 1 - exp(-z * w * tau) * (cos(wd * tau) + (z * w / wd) * sin(wd * tau))
}

// ================================================================ cadence: two speeds (lane B 7.8, M6)
/// The time a layer sees when it animates on ones (60), twos (12 at 24fps), or any stepped rate: type and objects step,
/// the camera glides.
func stepped(_ t: Double, fps: Double) -> Double { (t * fps).rounded(.down) / fps }
/// A smear instead of blur on stepped layers: how much to stretch an object along its velocity on this step (1 = none).
/// Spider-Verse rule: one stretched frame when a stepped move jumps more than `threshold` px.
func smearStretch(stepDistancePx d: Double, threshold: Double = 40) -> Double { d > threshold ? min(2.0, d / threshold) : 1 }
/// Motion-blur sample count that follows speed: samples no more than 3px apart, 1 on a still frame (lane C row 5).
func shutterSamples(pxPerFrame v: Double, shutter: Double = 0.5, maxSamples: Int = 48) -> Int {
	max(1, min(maxSamples, Int((v * shutter / 3).rounded(.up))))
}

// ================================================================ camera
/// Scale (or distance) interpolated in log space, so a 1x to 8x push reads as one steady speed (premium web / howseen).
func logLerp(_ a: Double, _ b: Double, _ p: Double) -> Double { exp(log(a) + (log(b) - log(a)) * p) }
/// Frame-rate independent smoothing toward a target: alpha = 1 - e^(-lambda dt); lambda 6.3 to 7.7 per second feels like Lenis.
func approach(_ current: Double, _ target: Double, dt: Double, lambda: Double = 7.0) -> Double { current + (target - current) * (1 - exp(-lambda * dt)) }

// ================================================================ type
/// Line-masked reveal (editorial register): line i slides up from below its clip line on a long expo-out.
/// Returns the share of the line height still hidden (1 = hidden, 0 = in place).
func lineReveal(_ t: Double, line i: Int, t0: Double, dur: Double = 1.2, stagger: Double = 0.1) -> Double {
	1 - expoOut(clamp01((t - t0 - Double(i) * stagger) / dur))
}
/// Reading time for a line of type on screen (lane B 1.13): 0.4s plus characters / 15.
func readingTime(_ text: String) -> Double { 0.4 + Double(text.count) / 15 }

/// Typing like a person (136M keystrokes, lane B 1.10 and M4): mean 130ms, SD 25 for a fast typist, never under 60ms,
/// +200ms at spaces, +550ms before the key word, optional one typo fixed after 220ms. Seeded, so frames agree.
struct Keystroke { let t: Double; let text: String }
func typeLikeAPerson(_ text: String, start: Double, keyWord: String? = nil, typoAt: Int? = nil, seed: UInt64 = 7) -> [Keystroke] {
	var rng = seed &* 0x9E3779B97F4A7C15
	func gauss() -> Double {
		func u() -> Double { rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17; return Double(rng >> 11) / 9007199254740992.0 }
		return sqrt(-2 * log(max(1e-12, u()))) * cos(2 * Double.pi * u())
	}
	let chars = Array(text)
	var out: [Keystroke] = [], t = start, shown = ""
	let keyStart = keyWord.flatMap { text.range(of: $0) }.map { text.distance(from: text.startIndex, to: $0.lowerBound) }
	for (i, c) in chars.enumerated() {
		var gap = max(0.06, 0.13 + 0.025 * gauss())
		if c == " " { gap += 0.2 }
		if let k = keyStart, i == k { gap += 0.55 }
		t += i == 0 ? 0 : gap
		if let ty = typoAt, ty == i {
			out.append(Keystroke(t: t, text: shown + "x")); t += 0.22
			out.append(Keystroke(t: t, text: shown)); t += max(0.06, 0.13 + 0.025 * gauss())
		}
		shown.append(c)
		out.append(Keystroke(t: t, text: shown))
	}
	return out
}
/// what is on screen at time t, and whether the caret should blink (it only blinks 0.5s after the last key)
func typedText(_ keys: [Keystroke], at t: Double) -> (text: String, caretSolid: Bool) {
	guard let last = keys.last(where: { $0.t <= t }) else { return ("", true) }
	let idle = t - last.t
	return (last.text, idle < 0.5 || Int((idle - 0.5) / 0.53) % 2 == 0)
}

// ================================================================ sound against picture
/// Sound trails its picture by 0 to 2 frames and never leads it (broadcast window about -45ms / +125ms, lane B 9.2).
func sfxTime(forPictureAt t: Double, fps: Double = 60, framesLate: Double = 1) -> Double { t + framesLate / fps }

// ================================================================ film finish (lane B section 5), as numbers for a shader
enum FilmFinish {
	static let grainOctaveWeights = [0.50, 0.33, 0.17]            // three octaves of grain
	static let grainOpacity = 0.30                                // "felt rather than seen"
	static let halationRadius = (r: 1.4, g: 1.0, b: 0.7)          // times a base radius
	static let halationMax = 0.5
	static let bloomMix = 0.03...0.15
	static let chromaticOffset = 0.005                            // of frame width, lateral only
	static let vignetteMax = 0.35
}

#if MOTIONKIT_TEST
// swiftc -O -D MOTIONKIT_TEST motionkit.swift -o mk && ./mk
for f in Families.all { print(f.name, String(format: "enter(0.5) %.3f  move(0.5) %.3f", f.enter(0.5), f.move(0.5))) }
print(String(format: "spring bounce 0 at 0.5s: %.3f; bounce 0.2 peak: %.3f", spring(0.5, 0, duration: 0.5),
             (0..<200).map { spring(Double($0) / 200, 0, duration: 0.5, bounce: 0.2) }.max()!))
let keys = typeLikeAPerson("remember what i told you last week", start: 0, keyWord: "last week", typoAt: 5)
print(String(format: "typed %d keystrokes in %.2fs; at 1.0s: '%@'", keys.count, keys.last!.t, typedText(keys, at: 1.0).text))
print("shutter samples at 2, 30, 200 px/frame:", shutterSamples(pxPerFrame: 2), shutterSamples(pxPerFrame: 30), shutterSamples(pxPerFrame: 200))
print(String(format: "log zoom halfway 1x->8x: %.3f (linear would be 4.5)", logLerp(1, 8, 0.5)))
#endif
