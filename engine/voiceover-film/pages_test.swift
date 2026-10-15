// ================================================================ pages test: render every page state at 2x
// from this folder: cat lib.swift console.swift pages_test.swift > test.swift && swiftc -O test.swift -o test && ./test
// Writes stills/page_<name>.png (2940x1670) and stills/page_sheet.png.

let SCALE: CGFloat = 2
try? FileManager.default.createDirectory(at: HERE.appendingPathComponent("stills"), withIntermediateDirectories: true)
var shots: [(String, CGImage)] = []
func shot(_ name: String, _ draw: (CGContext) -> Void) {
	let c = makeContext(PAGE.width, PAGE.height, scale: SCALE)
	draw(c)
	let img = c.makeImage()!
	writePNG(img, HERE.appendingPathComponent("stills/page_\(name).png"))
	shots.append((name, img))
}
func base(_ p: Page) -> ConsoleState {
	var s = ConsoleState()
	s.page = p
	s.nav.from = navFor(p); s.nav.to = navFor(p)
	return s
}
func center(_ r: CGRect) -> CGPoint { CGPoint(x: r.midX, y: r.midY) }

// ---- Overview
shot("overview") { c in drawConsole(c, base(.overview)) }
shot("overview_enter") { c in var s = base(.overview); s.enterT = 0.14; drawConsole(c, s) }
shot("overview_tooltip") { c in
	var s = base(.overview); s.ov.onboardHover = 1; s.ov.tooltip = 1
	drawConsole(c, s)
	drawCursor(c, CGPoint(x: onboardRect().minX + 120, y: onboardRect().midY + 2), 1)
}
shot("overview_toast") { c in
	var s = base(.overview); s.ov.onboardHover = 1; s.ov.toast = 1
	drawConsole(c, s)
	let p = CGPoint(x: onboardRect().minX + 120, y: onboardRect().midY + 2)
	drawRipple(c, p, 0.35); drawCursor(c, p, 1, press: 0.4)
}
shot("overview_lift") { c in
	// how a timeline lifts the Onboard line out: page dimmed, line hidden in the page, redrawn bigger on a card
	var s = base(.overview); s.dim = 1; s.hidden = ["onboard"]
	drawConsole(c, s)
	let sz = onboardSize(), k: CGFloat = 2.4
	c.saveGState()
	c.translateBy(x: 735 - sz.width * k / 2, y: 417); c.scaleBy(x: k, y: k)
	rrect(c, CGRect(x: -16, y: -22, width: sz.width + 32, height: 44), 10, fill: C_BG, stroke: WHITE, sa: BORDER_A)
	drawOnboardLine(c, .zero, hover: 1)
	drawTooltip(c, at: CGPoint(x: 0, y: 30), OV_TOOLTIP_LINES, 1)
	c.restoreGState()
}

// ---- Agents & MCP
shot("agents_empty") { c in drawConsole(c, base(.agents)) }
shot("agents_row_enter") { c in var s = base(.agents); s.ag.rowT = 0.1; drawConsole(c, s) }
shot("agents_row") { c in var s = base(.agents); s.ag.rowT = 9; s.ag.proof = 1; drawConsole(c, s) }
shot("agents_copy") { c in
	var s = base(.agents); s.ag.names = [1, 1, 1, 0.4]; s.ag.cmd = CopyBox(hover: 1, copiedT: 0.5)
	drawConsole(c, s)
	let p = copyIconCenter(AG_CMD_BOX)
	drawRipple(c, p, 0.4); drawCursor(c, CGPoint(x: p.x + 6, y: p.y + 7), 1)
}
shot("agents_mcp_cli") { c in
	var s = base(.agents); s.ag.rowT = 9; s.ag.mcp = CopyBox(hover: 1, copiedT: 0.6); s.ag.cli = CopyBox(hover: 1, copiedT: nil)
	drawConsole(c, s)
	let p = copyIconCenter(AG_CLI_BOX)
	drawCursor(c, CGPoint(x: p.x - 2, y: p.y + 2), 1)
}
shot("agents_lift_mcp") { c in
	var s = base(.agents); s.ag.rowT = 9; s.dim = 1; s.hidden = ["mcp"]
	drawConsole(c, s)
	let k: CGFloat = 1.3
	c.saveGState()
	c.translateBy(x: 735 - AG_MCP.width * k / 2, y: 417 - AG_MCP.height * k / 2); c.scaleBy(x: k, y: k)
	drawMCPCard(c, .zero, CopyBox(hover: 1, copiedT: 0.6))
	c.restoreGState()
}
shot("nav_slide") { c in
	var s = base(.agents); s.nav.from = .overview; s.nav.to = .agents; s.nav.k = 0.45; s.enterT = 0.1
	drawConsole(c, s)
	let p = CGPoint(x: navRect(.agents).minX + 70, y: navRect(.agents).midY + 3)
	drawRipple(c, p, 0.3); drawCursor(c, p, 1, press: 0.6)
}

// ---- API Keys
shot("keys") { c in var s = base(.keys); s.keys.createHover = 1; drawConsole(c, s); drawCursor(c, CGPoint(x: keysCreateButton().midX + 10, y: keysCreateButton().midY + 4), 1) }
shot("keys_dialog_open") { c in var s = base(.keys); s.keys.dialogT = 0.07; drawConsole(c, s) }
shot("keys_dialog") { c in
	var s = base(.keys); s.keys.dialogT = 9; s.keys.scopedHover = 1
	drawConsole(c, s)
	drawCursor(c, CGPoint(x: DLG_SCOPED.midX + 18, y: DLG_SCOPED.midY + 3), 1)
}
shot("keys_created") { c in
	var s = base(.keys); s.keys.dialogT = 9; s.keys.createdT = 9; s.keys.key = CopyBox(hover: 1, copiedT: 0.5)
	drawConsole(c, s)
	let p = center(DLG_KEYCOPY)
	drawRipple(c, p, 0.45); drawCursor(c, CGPoint(x: p.x + 6, y: p.y + 7), 1)
}
shot("keys_created_mid") { c in var s = base(.keys); s.keys.dialogT = 9; s.keys.createdT = 0.12; drawConsole(c, s) }

// ---- Requests
shot("requests") { c in drawConsole(c, base(.requests)) }
shot("requests_landing") { c in var s = base(.requests); s.req.newRowT = 0.12; drawConsole(c, s) }
shot("requests_landed") { c in var s = base(.requests); s.req.newRowT = 9; s.req.proof = 1; drawConsole(c, s) }

// ---- outside the console: terminal + table (frame 0), agent input, URL chip, cursor
shot("kit") { c in
	rect(c, PAGE, fill: 0x050607)
	drawURLChip(c, CGPoint(x: 735, y: 60), 1)
	drawTerminal(c, TermState(rect: CGRect(x: 40, y: 150, width: 520, height: 250), typed: 1, caret: true))
	drawTerminal(c, TermState(rect: CGRect(x: 40, y: 430, width: 520, height: 150), cmd: "i use pnpm", typed: 0.7, caret: true, tag: "new session"))
	var ag = AgentsState(); ag.rowT = 9; ag.proof = 1
	c.saveGState()
	let k: CGFloat = 1.6
	c.clip(to: CGRect(x: 600, y: 150, width: 840, height: 420))
	c.translateBy(x: 610, y: 210); c.scaleBy(x: k, y: k)
	drawConnectedTable(c, .zero, ag)
	c.restoreGState()
	drawAgentInput(c, AgentInputState(rect: CGRect(x: 40, y: 620, width: 520, height: 120), text: "# You are onboarding this project to Supermemory", moreLines: 86))
	drawAgentInput(c, AgentInputState(rect: CGRect(x: 600, y: 620, width: 520, height: 120), caret: true))
	drawRipple(c, CGPoint(x: 1260, y: 680), 0.4)
	drawCursor(c, CGPoint(x: 1260, y: 680), 1, press: 0.3, size: 1.4)
}

// ---- contact sheet
let cols = 3, tw = 735, th = 418
let rows = (shots.count + cols - 1) / cols
let sw = cols * tw + (cols + 1) * 16, sh = rows * (th + 34) + 16
let sheet = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: 0, space: sRGB, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
sheet.interpolationQuality = .high
sheet.setFillColor(col(0x2a2a2e)); sheet.fill(CGRect(x: 0, y: 0, width: sw, height: sh))
for (i, (name, img)) in shots.enumerated() {
	let x = 16 + (i % cols) * (tw + 16), y = sh - (16 + (i / cols) * (th + 34) + th)
	sheet.draw(img, in: CGRect(x: x, y: y, width: tw, height: th))
	sheet.textPosition = CGPoint(x: CGFloat(x), y: CGFloat(y - 22)); CTLineDraw(ctline(name, mono(16), col(0xdddddd)), sheet)
}
writePNG(sheet.makeImage()!, HERE.appendingPathComponent("stills/page_sheet.png"))
print("wrote \(shots.count) stills + page_sheet.png")
