// ================================================================ the film: the board, the history rail, the chips, the type
// Motion picked from her saved sites (video-master references/library/websites.md), rebuilt in the brand system:
// - magicui "Hyper Text" / motion-primitives "Text Scramble": chips and verbs resolve out of scrambled glyphs;
// - aceternity "Vanish Input": chatter breaks into dots that sink into the lattice;
// - magicui "Number Ticker": the dry-run preview counts its matches;
// - 60fps.design archive/dismiss: a card springs out of the board and files itself into the history rail;
// - aceternity "Canvas Reveal" (dot matrix): the board gathers into the mark built of diamonds.

let GLYPHS = Array("abcdefghijklmnopqrstuvwxyz0123456789{}<>/=+*#")
/// text that resolves out of scrambled glyphs: each character settles `settle` seconds after it appears
func scrambled(_ s: String, _ t: Double, _ t0: Double, cps: Double = 26, settle: Double = 0.07) -> String {
	let chars = Array(s)
	var out = ""
	for (j, ch) in chars.enumerated() {
		let tj = t0 + Double(j) / cps
		if t < tj { break }
		if ch == " " || t > tj + settle { out.append(ch); continue }
		let q = Int(quant(t) * 60) &+ j &* 7
		out.append(GLYPHS[Int(hash01(q, 31) * Double(GLYPHS.count)) % GLYPHS.count])
	}
	return out
}

// ---------------------------------------------------------------- the cards
struct CardPose { let p: CGPoint; let scale: CGFloat; let a: CGFloat; let dashed: Bool; let hi: Double; let order: Int }
func gatherTo(_ p: CGPoint, _ t: Double, _ d: Double) -> (CGPoint, CGFloat) {
	let g = einout(seg(t, T_END0 + d, T_END0 + b(1.4) + d))
	return (CGPoint(x: p.x + (MARK_C.x - p.x) * CGFloat(g), y: p.y + (MARK_C.y - p.y) * CGFloat(g)), CGFloat(1 - smooth(seg(t, T_END0 + b(0.8) + d, T_END0 + b(1.5) + d))))
}
func highlight(_ i: Int, _ t: Double) -> Double {
	func on(_ a: Double, _ z: Double) -> Double { smooth(seg(t, a, a + 0.15)) * (1 - smooth(seg(t, z, z + 0.25))) }
	switch i {
	case 2: return on(T_ASK1 + 1.0, b(15.6))                                         // "lives in nyc" (stale)
	case 3: return max(on(T_ASK1 + 1.2, b(15.6)), on(T_UPDATE, T_UPDATE + 1.4), on(T_ASK2 + 1.0, b(47.6)))
	case 8, 9, 10: return on(T_PREVIEW + 0.08 * Double(i - 8), T_APPLY + 0.2)      // the dry run's matches
	default: return 0
	}
}
func cardPose(_ i: Int, _ t: Double, _ cam: Cam) -> CardPose? {
	let cd = CARDS[i]
	if t < cd.born { return nil }
	var (wx, wy) = boardPos(i, t)
	var scale = 0.62 + 0.38 * spring(t, cd.born, freq: 3.2, zeta: 0.5)
	var a = 1.0, dashed = false, order = 1
	if let st = STEP[i] {
		let (ts, slot) = st
		// steps aside: it lifts, then glides on an arc into its slot in the history row, shrinking as it goes
		let u = seg(t, ts, ts + FLY)
		if u > 0 {
			let e = einout(u)
			let from = boardPos(i, ts), rs = railSlot(slot)
			let lift = 1 + 0.06 * sin(min(1, u / 0.35) * Double.pi)
			wx = lerp(from.0, rs.0, e); wy = lerp(from.1, rs.1, e) - sin(e * Double.pi) * 70
			scale *= lift * (1 - 0.54 * e)
			a = 1 - 0.2 * e
			dashed = e > 0.55
			order = u < 1 ? 2 : 0
		}
	}
	if a <= 0.003 { return nil }
	let (gp, ga) = gatherTo(scr(wx, wy, cam), t, 0.025 * Double(i))
	var hi = highlight(i, t)
	if let st = STEP[i], t > st.0 + FLY { let g = railGlow(st.1, t); hi = max(hi, g); a = max(a, 0.8 + 0.2 * g) }
	return CardPose(p: gp, scale: CGFloat(scale), a: CGFloat(a) * ga, dashed: dashed, hi: hi, order: order)
}
func drawCard(_ c: CGContext, _ i: Int, _ pose: CardPose, _ t: Double, _ k: CGFloat) {
	let cd = CARDS[i]
	let s = pose.scale * k
	let w = CARD_W * s, h = CARD_H * s
	let r = CGRect(x: pose.p.x - w / 2, y: pose.p.y - h / 2, width: w, height: h)
	let a = pose.a
	c.setFillColor(col(FIELD, 0.94 * a)); c.fill(r)
	c.saveGState()
	if pose.dashed { c.setLineDash(phase: 0, lengths: [5, 5]) }
	let hi = CGFloat(pose.hi)
	c.setStrokeColor(col(hi > 0.02 ? GOLD : PAPER, (0.62 + 0.38 * hi) * a)); c.setLineWidth(1.2 + 1.6 * hi); c.stroke(r)
	c.restoreGState()
	if let art = cd.art {
		let cell = 7.2 * s
		let rot = (i == 3 && t > T_ASK2 + 0.9) ? smooth(seg(t, T_ASK2 + 0.9, T_ASK2 + 1.1)) * (1 - smooth(seg(t, b(46.5), b(47.2)))) : 0
		dotArt(c, art, frame: 0, centre: CGPoint(x: r.midX, y: r.minY + h * 0.42), cell: cell, rot: rot, grow: { _ in 1 }, alpha: a)
	}
	let labelA = CGFloat(smooth((Double(pose.scale) - 0.6) / 0.15))
	text(c, cd.tag, mono(19 * s, 500), r.midX, r.maxY - 18 * s, hi > 0.02 ? GOLD : PAPER, a * 0.95 * labelA, .center)
	// status tags: what just happened to this fact
	var tag = "", tagC = SKY, tagA = 0.0
	switch cd.kind {
	case .expire: tag = "EXPIRED"; tagA = smooth(seg(t, T_EXPIRE - 0.05, T_EXPIRE + 0.1))
	case .oldFact: tag = "SUPERSEDED"; tagA = smooth(seg(t, T_UPDATE + 0.05, T_UPDATE + 0.2))
	case .newFact: tag = "LATEST"; tagC = GOLD; tagA = smooth(seg(t, T_UPDATE, T_UPDATE + 0.15)) * (1 - smooth(seg(t, b(31), b(32))))
	case .titan:
		if t < T_APPLY { tag = "MATCH"; tagC = GOLD; tagA = smooth(seg(t, T_PREVIEW + 0.08 * Double(i - 8), T_PREVIEW + 0.08 * Double(i - 8) + 0.12)) }
		else { tag = "FORGOTTEN"; tagA = smooth(seg(t, T_APPLY, T_APPLY + 0.15)) }
	default: break
	}
	if tagA > 0.01 { pill(c, tag, CGPoint(x: r.minX + 10 * s, y: r.minY), s, tagC, a * CGFloat(tagA), t, (cd.kind == .titan && t < T_APPLY) ? T_PREVIEW + 0.08 * Double(i - 8) : tagT0(i)) }
	// the dry run: a checkbox in the corner, ticked on the three titan docs; the bike stays unticked
	if (cd.kind == .titan || cd.kind == .nearMiss) && t > T_PREVIEW - 0.1 && t < T_APPLY + 0.4 {
		let ba = a * CGFloat(smooth(seg(t, T_PREVIEW - 0.1, T_PREVIEW + 0.05)) * (1 - smooth(seg(t, T_APPLY + 0.1, T_APPLY + 0.4))))
		let bs = 26 * s, bx = r.maxX - bs - 12 * s, by = r.minY + 12 * s
		let box = CGRect(x: bx, y: by, width: bs, height: bs)
		c.setFillColor(col(FIELD, ba)); c.fill(box)
		c.setStrokeColor(col(cd.kind == .titan ? GOLD : SKY, ba)); c.setLineWidth(1.6 * s); c.stroke(box)
		if cd.kind == .titan {
			let u = seg(t, T_PREVIEW + 0.08 * Double(i - 8), T_PREVIEW + 0.08 * Double(i - 8) + 0.16)
			if u > 0 {
				let p0 = CGPoint(x: bx + bs * 0.2, y: by + bs * 0.52), p1 = CGPoint(x: bx + bs * 0.42, y: by + bs * 0.75), p2 = CGPoint(x: bx + bs * 0.82, y: by + bs * 0.25)
				c.setStrokeColor(col(GOLD, ba)); c.setLineWidth(3 * s); c.setLineCap(.square)
				c.move(to: p0)
				if u < 0.4 { c.addLine(to: lerpP(p0, p1, u / 0.4)) } else { c.addLine(to: p1); c.addLine(to: lerpP(p1, p2, (u - 0.4) / 0.6)) }
				c.strokePath()
			}
		} else if t > T_PREVIEW + 0.3 {
			pill(c, "NOT A MATCH", CGPoint(x: r.minX + 10 * s, y: r.minY), s, SKY, ba * CGFloat(smooth(seg(t, T_PREVIEW + 0.3, T_PREVIEW + 0.45))), t, T_PREVIEW + 0.3)
		}
	}
	// expiry: a countdown ring closes around the card before it steps aside
	if cd.kind == .expire {
		let u = seg(t, T_EXPIRE - b(2.5), T_EXPIRE)
		if u > 0 && u < 1 {
			let rr = max(w, h) * 0.62
			c.setStrokeColor(col(GOLD, 0.9 * a)); c.setLineWidth(2.4 * k)
			c.addArc(center: CGPoint(x: r.midX, y: r.midY), radius: rr, startAngle: -.pi / 2, endAngle: -.pi / 2 + 2 * .pi * CGFloat(1 - u), clockwise: false)
			c.strokePath()
		}
	}
}
/// when each card's current status pill appeared (for its pulse)
func tagT0(_ i: Int) -> Double {
	switch CARDS[i].kind {
	case .expire: return T_EXPIRE
	case .oldFact, .newFact: return T_UPDATE
	case .titan: return T_APPLY
	default: return 0
	}
}
/// a status pill straddling a card's top edge, with one pulse ring when it appears (kinetics Status Pill / Pulse Badge)
func pill(_ c: CGContext, _ s: String, _ at: CGPoint, _ sc: CGFloat, _ color: UInt32, _ a: CGFloat, _ t: Double, _ t0: Double) {
	let fs = max(14 * sc, 12.5), ps = fs / 14
	let f = mono(fs, 600)
	let w = textW(s, f, track: 1.2 * ps) + 18 * ps, h = 24 * ps
	let pop = CGFloat(1 + 0.18 * exp(-max(0, t - t0) / 0.09) * (t > t0 ? 1 : 0))
	let r = CGRect(x: at.x, y: at.y - h / 2 * pop, width: w * pop, height: h * pop)
	c.setFillColor(col(FIELD, a)); c.fill(r)
	c.setStrokeColor(col(color, a)); c.setLineWidth(1.4 * sc); c.stroke(r)
	text(c, s, mono(fs * pop, 600), r.minX + 9 * ps, r.midY + 5 * ps * pop, color, a, track: 1.2 * ps)
	let u = t - t0
	if u > 0 && u < 0.45 {
		let g = CGFloat(u / 0.45), e = 10 * ps * g
		c.setStrokeColor(col(color, a * (1 - g) * 0.8)); c.setLineWidth(1.2)
		c.stroke(r.insetBy(dx: -e, dy: -e))
	}
}
/// chatter: speech bubbles in the gaps, alive (a small wobble), until the filter scrambles them
func drawChatter(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let k = CGFloat(cam.k)
	for (i, ch) in CHATTER.enumerated() where t >= ch.born {
		let a0 = 1 - smooth(seg(t, T_FILTER + 0.12, T_FILTER + 0.28))
		if a0 <= 0.003 { continue }
		let pop = 0.6 + 0.4 * spring(t, ch.born, freq: 3.4, zeta: 0.45)
		let wob = 3 * sin(t * 2.3 + Double(i) * 1.7)
		let (p, ga) = gatherTo(scr(ch.pos.0, ch.pos.1 + wob, cam), t, 0.02 * Double(i))
		let a = CGFloat(a0) * ga
		let f = mono(30 * k * CGFloat(pop), 500)
		let str = (t > T_FILTER - 0.02 && t < T_FILTER + 0.3) ? scrambled(ch.text, t, T_FILTER - 1, cps: 1e6, settle: 99) : ch.text
		let w = max(textW(ch.text, f) + 34 * k, 76 * k), h = 52 * k * CGFloat(pop)
		let br = CGRect(x: p.x - w / 2, y: p.y - h / 2, width: w, height: h)
		let path = CGMutablePath()
		path.addRect(br)
		path.move(to: CGPoint(x: br.minX + 14 * k, y: br.maxY)); path.addLine(to: CGPoint(x: br.minX + 8 * k, y: br.maxY + 13 * k)); path.addLine(to: CGPoint(x: br.minX + 28 * k, y: br.maxY))
		c.setFillColor(col(FIELD, 0.95 * a)); c.addPath(path); c.fillPath()
		c.setStrokeColor(col(PAPER, 0.55 * a)); c.setLineWidth(1.2); c.addPath(path); c.strokePath()
		text(c, str, f, p.x, p.y + 10 * k * CGFloat(pop), PAPER, a * 0.92, .center)
	}
}
/// the chatter vanishes (aceternity "Vanish Input"): each bubble breaks into dots that fall and settle into the lattice
func drawVanish(_ c: CGContext, _ t: Double, _ cam: Cam) {
	if t < T_FILTER + 0.1 || t > T_FILTER + 1.5 { return }
	let k = CGFloat(cam.k)
	for (i, ch) in CHATTER.enumerated() {
		let p0 = scr(ch.pos.0, ch.pos.1, cam)
		for q in 0..<44 {
			let h1 = hash01(i &* 97 &+ q, 3), h2 = hash01(i &* 61 &+ q, 9), h3 = hash01(i &* 13 &+ q, 21)
			let ts = T_FILTER + 0.12 + 0.16 * h3
			let u = t - ts
			if u < 0 { continue }
			let vx = (h1 - 0.5) * 300, vy = -60 - 200 * h2
			func at(_ v: Double) -> (Double, Double) {
				(Double(p0.x) + (h1 - 0.5) * 90 * Double(k) + vx * v, Double(p0.y) + (h2 - 0.5) * 36 * Double(k) + vy * v + 0.5 * 1700 * v * v)
			}
			// fly, then snap onto the nearest lattice cell and become one of its stored squares (kinetics Lattice Snap)
			let land = at(0.42)
			let gx = (floor(land.0 / PITCH) + 0.5) * PITCH, gy = (floor(land.1 / PITCH) + 0.5) * PITCH
			let sn = einout(seg(u, 0.42, 0.62))
			let fly = at(min(u, 0.42))
			let x = fly.0 + (gx - fly.0) * sn, y = fly.1 + (gy - fly.1) * sn
			let fade = 1 - smooth(seg(u, 0.75, 1.15))
			if fade <= 0.01 { continue }
			let sz = CGFloat(9 - 5.8 * min(1, u / 0.62)) * k
			diamond(c, CGPoint(x: x, y: y), sz, sn > 0.9 ? SKY : (q % 7 == 0 ? GOLD : PAPER), CGFloat(fade) * 0.95, rot: 1 - sn)
		}
	}
}

// ---------------------------------------------------------------- the history rail
func drawRail(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let a = CGFloat(smooth(seg(t, T_EXPIRE - 0.3, T_EXPIRE + 0.1))) * gatherTo(.zero, t, 0).1
	if a <= 0.003 { return }
	let k = CGFloat(cam.k)
	let l = scr(railSlot(0).0 - 78, RAIL_Y, cam), r = scr(railSlot(5).0 + 78, RAIL_Y, cam)
	let draw = CGFloat(ease(seg(t, T_EXPIRE - 0.3, T_EXPIRE + 0.4)))
	c.setStrokeColor(col(PAPER, 0.36 * a)); c.setLineWidth(1)
	c.move(to: CGPoint(x: l.x, y: l.y + 52 * k)); c.addLine(to: CGPoint(x: l.x + (r.x - l.x) * draw, y: r.y + 52 * k)); c.strokePath()
	text(c, "HISTORY", mono(19 * k, 500), l.x - 18 * k, l.y - 2 * k, PAPER, 0.95 * a, .right)
	text(c, "NOT ERASED", mono(19 * k, 500), l.x - 18 * k, l.y + 24 * k, GOLD, 0.95 * a, .right)
	// on "the history is not erased", a light walks along the row (aceternity Timeline / magicui Animated List)
	let walk = seg(t, b(42.8), b(42.8) + 1.0)
	if walk > 0 && walk < 1 {
		let x = l.x + (r.x - l.x) * CGFloat(einout(walk))
		c.setStrokeColor(col(GOLD, 0.95 * a)); c.setLineWidth(3)
		c.move(to: CGPoint(x: max(l.x, x - 60 * k), y: l.y + 52 * k)); c.addLine(to: CGPoint(x: x, y: l.y + 52 * k)); c.strokePath()
	}
}
/// how lit a history slot is while the light walks past it
func railGlow(_ slot: Int, _ t: Double) -> Double {
	let walk = einout(seg(t, b(42.8), b(42.8) + 1.0))
	let pos = (railSlot(slot).0 - (railSlot(0).0 - 78)) / (railSlot(5).0 - railSlot(0).0 + 156)
	return exp(-pow((walk - pos) / 0.08, 2)) * (t > b(42.8) && t < b(42.8) + 1.3 ? 1 : 0)
}

// ---------------------------------------------------------------- the bar: one box at the top carries the story
// It types the question; its split-flap answer board (aceternity Text Flipping Board) shuffles and lands on NYC, then
// flips to SF on { updates }. On command it opens into the code editor (dry run first) and folds back into the
// question for recall. One survivor from 02 to 05, never a cut.
let QBAR = CGRect(x: 960 - 262, y: 38, width: 524, height: 66)
let EBAR = CGRect(x: 460, y: 22, width: 1000, height: 226)
let BAR_IN = T_ASK1 - 0.45, A1 = b(12.2)
let FLAP_N = 3
let QUESTION = "where do i live?"
let CODE1 = ["memories.forgetMatching(\"user_123\", {", "  query: \"forget everything about Project Titan\",", "  dryRun: true,", "})"]
let CODE2 = ["memories.forget(\"user_123\", {", "  ids: preview.matches.map((m) => m.id),", "})"]
let LETTERS = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
func editorOpen(_ t: Double) -> Double { einout(seg(t, T_CODE - 0.35, T_CODE + 0.15)) * (1 - einout(seg(t, b(38.2), b(38.2) + 0.5))) }
func barRect(_ t: Double) -> CGRect {
	let o = CGFloat(editorOpen(t))
	return CGRect(x: QBAR.minX + (EBAR.minX - QBAR.minX) * o, y: QBAR.minY + (EBAR.minY - QBAR.minY) * o,
	              width: QBAR.width + (EBAR.width - QBAR.width) * o, height: QBAR.height + (EBAR.height - QBAR.height) * o)
}
func flapRect(_ j: Int, _ r: CGRect) -> CGRect {
	let tw: CGFloat = 40, th: CGFloat = 50, gap: CGFloat = 6
	let x0 = r.maxX - 18 - CGFloat(FLAP_N) * tw - CGFloat(FLAP_N - 1) * gap
	return CGRect(x: x0 + CGFloat(j) * (tw + gap), y: r.midY - th / 2, width: tw, height: th)
}
/// what tile j shows: its character, colour, and fold (0 open, 1 shut mid-flip)
func flapState(_ j: Int, _ t: Double) -> (Character, UInt32, Double) {
	let nyc = Array("NYC"), sf = Array(" SF")
	func shuffle(_ from: Double, _ land: Double, _ final: Character, _ color: UInt32) -> (Character, UInt32, Double)? {
		if t < from { return nil }
		if t < land {
			let q = Int((t - from) / 0.055), ph = ((t - from) / 0.055).truncatingRemainder(dividingBy: 1)
			return (LETTERS[Int(hash01(q &* 7 &+ j, 77) * 26) % 26], PAPER, abs(sin(ph * Double.pi)))
		}
		let u = seg(t, land, land + 0.09)
		return (final, color, u < 1 ? abs(sin(u * Double.pi)) * 0.6 : 0)
	}
	if t >= b(38.2) {                                              // asked again after the forget: blank, then SF
		return shuffle(T_ASK2 + 0.5, T_ASK2 + 1.0 + 0.08 * Double(j), sf[j], GOLD) ?? (" ", PAPER, 0)
	}
	let ft = T_UPDATE + 0.07 * Double(j)
	if t >= ft {                                                   // { updates }: NYC folds over to SF
		let u = seg(t, ft, ft + 0.16)
		return (u < 0.5 ? nyc[j] : sf[j], u < 0.5 ? PAPER : GOLD, u < 1 ? abs(sin(u * Double.pi)) : 0)
	}
	return shuffle(A1 - 0.1, A1 + 0.3 + 0.08 * Double(j), nyc[j], PAPER) ?? (" ", PAPER, 0)
}
func drawBar(_ c: CGContext, _ t: Double, _ cam: Cam) {
	if t < BAR_IN { return }
	let fade = CGFloat(1 - smooth(seg(t, T_END0, T_END0 + 0.45)))
	if fade <= 0.003 { return }
	let r = barRect(t), o = editorOpen(t)
	// the box: the outline traces itself round, then fills
	let trace = CGFloat(ease(seg(t, BAR_IN, BAR_IN + 0.4)))
	c.setFillColor(col(FIELD, 0.96 * fade * CGFloat(smooth(seg(t, BAR_IN + 0.1, BAR_IN + 0.35))))); c.fill(r)
	c.setStrokeColor(col(PAPER, 0.85 * fade)); c.setLineWidth(1.4)
	let per = 2 * (r.width + r.height), d = per * trace
	c.move(to: CGPoint(x: r.minX, y: r.minY))
	var left = d
	for (p, len) in [(CGPoint(x: r.maxX, y: r.minY), r.width), (CGPoint(x: r.maxX, y: r.maxY), r.height), (CGPoint(x: r.minX, y: r.maxY), r.width), (CGPoint(x: r.minX, y: r.minY), r.height)] {
		if left <= 0 { break }
		let cur = c.currentPointOfPath
		if left >= len { c.addLine(to: p) } else { c.addLine(to: CGPoint(x: cur.x + (p.x - cur.x) * left / len, y: cur.y + (p.y - cur.y) * left / len)) }
		left -= len
	}
	c.strokePath()
	// the question (and the flap) while the box is a bar
	let qa = CGFloat(1 - smooth(o / 0.4)) * fade
	if qa > 0.01 {
		let f = mono(30, 500)
		let shown: String = t < T_CODE ? scrambled(QUESTION, t, T_ASK1 + 0.1) : (t >= T_ASK2 ? scrambled(QUESTION, t, T_ASK2 + 0.1) : "")
		text(c, shown, f, r.minX + 26, r.midY + 10, PAPER, qa)
		let waiting = (t < A1 && t > T_ASK1) || (t > b(38.6) && t < T_ASK2 + 1.0)
		if waiting && Int(t * 3.2) % 2 == 0 { text(c, "▌", f, r.minX + 26 + textW(shown, f), r.midY + 10, PAPER, qa * 0.8) }
		let divX = flapRect(0, r).minX - 18
		c.setFillColor(col(PAPER, 0.35 * qa)); c.fill(CGRect(x: divX, y: r.minY + 12, width: 1, height: r.height - 24))
		let pop = CGFloat(0.6 + 0.4 * spring(t, BAR_IN + 0.3, freq: 3.2, zeta: 0.5))
		for j in 0..<FLAP_N {
			let fr0 = flapRect(j, r)
			let fr = CGRect(x: fr0.midX - fr0.width * pop / 2, y: fr0.midY - fr0.height * pop / 2, width: fr0.width * pop, height: fr0.height * pop)
			let (ch, color, fold) = flapState(j, t)
			c.setFillColor(col(FIELD, qa)); c.fill(fr)
			c.setStrokeColor(col(PAPER, 0.7 * qa)); c.setLineWidth(1.2); c.stroke(fr)
			c.setStrokeColor(col(PAPER, 0.3 * qa)); c.move(to: CGPoint(x: fr.minX, y: fr.midY)); c.addLine(to: CGPoint(x: fr.maxX, y: fr.midY)); c.strokePath()
			c.saveGState()
			c.translateBy(x: fr.midX, y: fr.midY); c.scaleBy(x: 1, y: CGFloat(max(0.03, 1 - fold)))
			text(c, String(ch), mono(32 * pop, 600), 0, 11 * pop, color, qa, .center)
			c.restoreGState()
		}
		// recall: tokens stream from the fact the answer comes from, up into the flap
		func stream(_ i: Int, _ t0: Double, _ seed: Int) {
			let (wx, wy) = boardPos(i, t0 + 0.4)
			let cp = scr(wx, wy - 60, cam)
			let to = CGPoint(x: flapRect(1, r).midX, y: r.maxY)
			tokenStream(c, t, (cp, CGPoint(x: cp.x, y: cp.y - 140), CGPoint(x: to.x, y: to.y + 160), to), t0: t0, n: 16, gap: 0.022, dur: 0.6, k: 1, seed: seed, alpha: qa, size: 1.3)
		}
		stream(2, A1 - 0.75, 502); stream(3, A1 - 0.67, 503)
		stream(3, T_ASK2 + 0.3, 513)
	}
	// the editor: forget by meaning, dry run first, then forget exactly the previewed ids
	let ea = CGFloat(smooth(seg(o, 0.6, 1))) * fade
	if ea > 0.01 {
		let f = mono(26, 500), lh: CGFloat = 36
		let swap = smooth(seg(t, b(35.8), b(36.1)))
		let lines = swap < 0.5 ? CODE1 : CODE2
		let start = swap < 0.5 ? T_CODE + 0.1 : b(36.1)
		let cps = swap < 0.5 ? 46.0 : 60.0
		let la = swap < 0.5 ? CGFloat(1 - swap * 2) : CGFloat(swap * 2 - 1)
		for (n, line) in lines.enumerated() {
			let before = lines[0..<n].reduce(0) { $0 + $1.count }
			let tLine = start + Double(before) / cps
			if t < tLine { break }
			let shown = scrambled(line, t, tLine, cps: cps, settle: 0.04)
			let y = r.minY + 50 + lh * CGFloat(n)
			var x = r.minX + 30
			var inStr = false
			for ch in shown {
				let s = String(ch)
				if ch == "\"" { inStr.toggle() }
				text(c, s, f, x, y, (inStr || ch == "\"") ? GOLD : PAPER, ea * la)
				x += textW(s, f)
			}
		}
		// the result line (magicui Number Ticker): 0 → 3 matches, then 3 forgotten
		let ry = r.minY + 50 + lh * 4 + 4
		if t > T_PREVIEW && swap < 0.5 {
			let n = Int((3 * eout(seg(t, T_PREVIEW, T_PREVIEW + 0.35))).rounded())
			text(c, "→ \(n) matches · nothing changed yet", f, r.minX + 30, ry, GOLD, ea * la)
		}
		if t > T_APPLY {
			text(c, "→ 3 forgotten · out of search, records preserved", f, r.minX + 30, ry, GOLD, ea * CGFloat(smooth(seg(t, T_APPLY, T_APPLY + 0.2))))
		}
	}
}

// ---------------------------------------------------------------- tokens: the chat's memories arriving on the board
func drawArrivals(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let k = CGFloat(cam.k)
	for (i, cd) in CARDS.enumerated() where cd.born > 0.7 && t < cd.born + 0.2 && t > cd.born - 0.75 {
		let bp = boardPos(i, cd.born)
		let to = scr(bp.0, bp.1, cam)
		let from = CGPoint(x: to.x + CGFloat(hash01(i, 5) - 0.5) * 500 * k, y: -60)
		tokenStream(c, t, (from, CGPoint(x: from.x, y: from.y + 200), CGPoint(x: to.x, y: to.y - 220), to), t0: cd.born - 0.7, n: 12, gap: 0.02, dur: 0.5, k: k, seed: 700 + i, size: 1.2)
	}
}

// ---------------------------------------------------------------- the world pass
func drawWorld(_ c: CGContext, _ t: Double, _ cam: Cam) {
	let k = CGFloat(cam.k)
	c.saveGState()
	c.clip(to: CGRect(x: 0, y: HUD_Y, width: DW, height: BAND_Y - HUD_Y))
	drawRail(c, t, cam)
	drawArrivals(c, t, cam)
	drawChatter(c, t, cam)
	// history first, then the board, then any card on its way into history (on top, so the eye can follow it)
	var poses: [(Int, CardPose)] = []
	for i in CARDS.indices { if let p = cardPose(i, t, cam) { poses.append((i, p)) } }
	for (i, p) in poses.sorted(by: { ($0.1.order, $0.0) < ($1.1.order, $1.0) }) { drawCard(c, i, p, t, k) }
	drawVanish(c, t, cam)
	c.restoreGState()
	let hudA = CGFloat(1 - smooth(seg(t, T_END0, T_END0 + b(1))))
	c.setStrokeColor(col(PAPER, 0.22 * hudA)); c.setLineWidth(1)
	c.move(to: CGPoint(x: 0, y: HUD_Y)); c.addLine(to: CGPoint(x: DW, y: HUD_Y)); c.strokePath()
	drawBar(c, t, cam)
}

// ---------------------------------------------------------------- type in the band
let VERBS: [(String, String, Double, Double)] = [("{ expires }", "temporary facts drop after they expire", T_EXPIRE, b(23.4)),
                                                 ("{ updates }", "updates win for what's true now", T_UPDATE, b(27.5)),
                                                 ("{ filters }", "casual chatter is less likely to stick", T_FILTER, b(31.4))]
func drawType(_ c: CGContext, _ t: Double) {
	let bandA = CGFloat(1 - smooth(seg(t, T_END0, T_END0 + b(1))))
	c.setStrokeColor(col(PAPER, 0.32 * bandA)); c.setLineWidth(1)
	c.move(to: CGPoint(x: 0, y: BAND_Y)); c.addLine(to: CGPoint(x: DW, y: BAND_Y)); c.strokePath()

	for cap in CAP {
		riseText(c, cap.0, STATE_F, LEFT_X, BAND_Y + 80, PAPER, t, cap.2, cap.4)
		riseText(c, cap.1, STATE_F, LEFT_X, BAND_Y + 158, PAPER, t, cap.3, cap.4 + 0.04)
	}
	for s in SECTIONS {
		let num = String(s.0.split(separator: " ").first ?? "")
		riseText(c, s.0.uppercased(), LABEL_F, LEFT_X, 46, PAPER, t, s.1, s.2)
		riseText(c, num, NUM_F, DW - LEFT_X, BAND_Y + 158, PAPER, t, s.1 + 0.05, s.2, .right)
	}
	for (verb, line, t0, t1) in VERBS {
		riseText(c, line.uppercased(), mono(22, 500), LEFT_X, BAND_Y + 46, GOLD, t, t0 + 0.06, t1)
		riseText(c, verb, OP_F, LEFT_X - 8, BAND_Y + 168, PAPER, t, t0 + 0.02, t1)
	}
}
