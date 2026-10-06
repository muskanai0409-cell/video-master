// ---------------------------------------------------------------- terminal, typeset from the cli's own strings (supermemory@4.25.4)
let GLYPHS: [Character: [String]] = [
	"S": ["11111", "10000", "11111", "00001", "11111"], "U": ["10001", "10001", "10001", "10001", "01110"],
	"P": ["11110", "10001", "11110", "10000", "10000"], "E": ["11111", "10000", "11110", "10000", "11111"],
	"R": ["11110", "10001", "11110", "10100", "10010"], "M": ["10001", "11011", "10101", "10001", "10001"],
	"O": ["01110", "10001", "10001", "10001", "01110"], "Y": ["10001", "01010", "00100", "00100", "00100"],
]
let WORDC: [Character] = Array("SUPERMEMORY")
let BANNER_COLS = WORDC.count * 6 - 1
func bannerFilled(_ row: Int, _ col: Int) -> Bool {
	if row < 0 || row >= 5 || col < 0 || col >= BANNER_COLS { return false }
	let gi = col / 6, gc = col % 6
	if gc >= 5 { return false }
	let g = GLYPHS[WORDC[gi]]![row]
	return Array(g)[gc] == "1"
}
struct Seg { let s: String; let color: UInt32; let a: CGFloat; let bold: Bool }
func sg(_ s: String, _ color: UInt32 = T_TEXT, _ a: CGFloat = 1, bold: Bool = false) -> Seg { Seg(s: s, color: color, a: a, bold: bold) }
enum Box { case none, top, bar, bottom, diamond }
struct TLine { let box: Box; let segs: [Seg] }
let DETECT: [(String, String, Int)] = [("Claude Code", "command claude", 0), ("Cursor", "command cursor or local config", 3), ("OpenCode", "command opencode or local config", 2), ("Codex", "command codex or local config", 1)]
let PHASE_A: [TLine] = {
	var L: [TLine] = []
	L.append(TLine(box: .top, segs: [sg(" Supermemory plugin", bold: true)]))
	L.append(TLine(box: .bar, segs: [sg(" Detected integrations", bold: true)]))
	for (name, src, _) in DETECT { L.append(TLine(box: .bar, segs: [sg("   "), sg("[ready]", T_GREEN), sg(" " + name, bold: true), sg(" " + src, T_TEXT, 0.45)])) }
	L.append(TLine(box: .bottom, segs: [sg(" scripts can use supermemory plugin --all", T_TEXT, 0.45)]))
	L.append(TLine(box: .none, segs: []))
	L.append(TLine(box: .diamond, segs: [sg("  Which integrations should Supermemory install?")]))
	L.append(TLine(box: .bar, segs: [sg("  "), sg("Install all ready integrations", T_CYAN)]))
	L.append(TLine(box: .bar, segs: []))
	return L
}()
let PHASE_B: [TLine] = [
	TLine(box: .top, segs: [sg(" Supermemory OAuth", bold: true)]),
	TLine(box: .bar, segs: [sg(" "), sg("One approval", bold: true), sg(" connects "), sg("Claude Code, Cursor, OpenCode, Codex", bold: true), sg(".")]),
	TLine(box: .bottom, segs: [sg(" The same API key will be saved for each plugin your plan can use.", T_TEXT, 0.45)]),
]
let T_FS: CGFloat = 17, T_LH: CGFloat = 25
let T_CW: CGFloat = textW("0", mono(17))

func drawBox(_ c: CGContext, _ b: Box, _ x: CGFloat, _ base: CGFloat, _ a: CGFloat) {
	if b == .none || a <= 0.003 { return }
	let cx = x + T_CW / 2, top = base - T_LH + 6, bot = base + 6, mid = base - 5
	c.setStrokeColor(col(T_CYAN, a)); c.setLineWidth(1.3)
	switch b {
	case .top: c.move(to: CGPoint(x: x + T_CW, y: mid)); c.addLine(to: CGPoint(x: cx, y: mid)); c.addLine(to: CGPoint(x: cx, y: bot))
	case .bar: c.move(to: CGPoint(x: cx, y: top)); c.addLine(to: CGPoint(x: cx, y: bot))
	case .bottom: c.move(to: CGPoint(x: cx, y: top)); c.addLine(to: CGPoint(x: cx, y: mid)); c.addLine(to: CGPoint(x: x + T_CW, y: mid))
	case .diamond:
		let r: CGFloat = 4.5
		c.move(to: CGPoint(x: cx, y: mid - r)); c.addLine(to: CGPoint(x: cx + r, y: mid)); c.addLine(to: CGPoint(x: cx, y: mid + r)); c.addLine(to: CGPoint(x: cx - r, y: mid)); c.closePath()
	case .none: break
	}
	c.strokePath()
}
func drawTLine(_ c: CGContext, _ l: TLine, _ base: CGFloat, _ a: CGFloat) {
	drawBox(c, l.box, T_X0, base, a)
	var x = T_X0 + T_CW
	for s in l.segs {
		text(c, s.s, mono(T_FS, s.bold ? 600 : 400), x, base, s.color, s.a * a)
		x += CGFloat(s.s.count) * T_CW
	}
}

