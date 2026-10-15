// ================================================================ the supermemory console, rebuilt in vector
// console.supermemory.ai, dark theme. Layout measured from the Oct 14 captures (viewport 1470x835 CSS px) and the
// console's CSS tokens (research_notes/Console video series/02-our-research.md, read 2026-10-14); the Agents card
// rows reuse the Oct 5 DOM measurements from ../one-command-v2-src. Every coordinate below is a CSS px of the
// 1470x835 page, so a camera can zoom anywhere and it stays sharp. All data shown is DEMO data.
//
// Not drawn on purpose: the agent tab strip under "All editor plugins at once" (AmpCode / Hermes must never appear),
// the What's new card, the support chat bubble, the user row at the bottom of the sidebar.

// ---------------------------------------------------------------- tokens
let C_BG: UInt32 = 0x0a0a0a, C_BG2: UInt32 = 0x101010, C_MUTED: UInt32 = 0x121212, C_FLOAT: UInt32 = 0x151515
let C_STRONG: UInt32 = 0xfafafa, C_TEXT: UInt32 = 0xf5f5f5, C_TEXT2: UInt32 = 0xa2a2a2, C_ICON: UInt32 = 0x838383
let C_ACCENT: UInt32 = 0x2f86ff, C_ACCENT_TEXT: UInt32 = 0x6fa8ff, C_TINT: UInt32 = 0x0d131a, C_TINT_STROKE: UInt32 = 0x1e3973
let C_ACTIVE: UInt32 = 0x0e151f        // active nav item / range tab / segment, sampled from the capture
let C_SIDE_HOVER: UInt32 = 0x171717    // nav hover on the #101010 sidebar
let C_OK: UInt32 = 0x4fb877, C_PROOF: UInt32 = 0x0562ef, C_VIOLET: UInt32 = 0xa88cff
let C_TYPE_ADD: UInt32 = 0x15834a     // Requests: the "add" type mark (darker chart green, sampled from the capture)
let BORDER_A: CGFloat = 0.07, BORDER_MUTED_A: CGFloat = 0.04, OVERLAY_A: CGFloat = 0x8c / 255.0
/// Console type scale. 1.12 = UI type, icons and pills 12% larger than the page for legibility; boxes keep their
/// measured size. Set to 1 for the page's own sizes.
var TS: CGFloat = 1.12
func ui(_ s: CGFloat, _ w: Double = 400) -> CTFont { sans(s * TS, w) }
func uim(_ s: CGFloat, _ w: Double = 400) -> CTFont { mono(s * TS, w) }
/// ui() at `s`, shrunk (in 0.25px steps) until `str` fits in maxW: for lines that would overflow at 1.12x.
func fitFont(_ str: String, _ s: CGFloat, _ w: Double, _ maxW: CGFloat) -> CTFont {
	var size = s * TS
	while size > s && textW(str, sans(size, w)) > maxW { size -= 0.25 }
	return sans(size, w)
}

let PAGE = CGRect(x: 0, y: 0, width: 1470, height: 835)
let SIDEBAR_W: CGFloat = 240, TOPBAR_H: CGFloat = 48
let MAIN_X: CGFloat = 264, MAIN_R: CGFloat = 1446, MAIN_W: CGFloat = 1182
let AG_X: CGFloat = 367, AG_W: CGFloat = 976          // the Agents page's centred column

// ---------------------------------------------------------------- icons (stroke, 24 grid, drawn after the console's)
let IC_COPY = [
	svgPath("M9 15C9 12.1716 9 10.7574 9.87868 9.87868C10.7574 9 12.1716 9 15 9L16 9C18.8284 9 20.2426 9 21.1213 9.87868C22 10.7574 22 12.1716 22 15V16C22 18.8284 22 20.2426 21.1213 21.1213C20.2426 22 18.8284 22 16 22H15C12.1716 22 10.7574 22 9.87868 21.1213C9 20.2426 9 18.8284 9 16L9 15Z"),
	svgPath("M16.9999 9C16.9975 6.04291 16.9528 4.51121 16.092 3.46243C15.9258 3.25989 15.7401 3.07418 15.5376 2.90796C14.4312 2 12.7875 2 9.5 2C6.21252 2 4.56878 2 3.46243 2.90796C3.25989 3.07417 3.07418 3.25989 2.90796 3.46243C2 4.56878 2 6.21252 2 9.5C2 12.7875 2 14.4312 2.90796 15.5376C3.07417 15.7401 3.25989 15.9258 3.46243 16.092C4.51121 16.9528 6.04291 16.9975 9 16.9999"),
]
let IC_CHECK = [svgPath("M5 14L8.5 17.5L19 6.5")]
let IC_ARROW = [svgPath("M9 6.65032C9 6.65032 15.9383 6.10759 16.9154 7.08463C17.8924 8.06167 17.3496 15 17.3496 15M16.5 7.5L6.5 17.5")]
let IC_SEARCH = [svgPath("O 11 11 7 M16.2 16.2 L20.5 20.5")]
let IC_HOME = [svgPath("M3 11.4 C3 10.5 3.4 9.7 4.1 9.1 L10.1 4.3 C11.2 3.4 12.8 3.4 13.9 4.3 L19.9 9.1 C20.6 9.7 21 10.5 21 11.4 V17.5 C21 19.4 19.4 21 17.5 21 H6.5 C4.6 21 3 19.4 3 17.5 Z M10 16.5 H14")]
let IC_CHAT = [svgPath("M12 21 C17 21 21 17 21 12 C21 7 17 3 12 3 C7 3 3 7 3 12 C3 13.6 3.4 15.1 4.1 16.4 L3.2 20.8 L7.6 19.9 C8.9 20.6 10.4 21 12 21 Z M8.2 12 H8.21 M12 12 H12.01 M15.8 12 H15.81")]
let IC_TAG = [svgPath("M12.6 3 H18.5 C19.9 3 21 4.1 21 5.5 V11.4 C21 12 20.8 12.6 20.3 13 L13 20.3 C12.1 21.2 10.6 21.2 9.7 20.3 L3.7 14.3 C2.8 13.4 2.8 11.9 3.7 11 L11 3.7 C11.4 3.2 12 3 12.6 3 Z O 16.5 7.5 1.5")]
let IC_GRAPH = [svgPath("R 3 3 6.5 6.5 2 R 14.5 14.5 6.5 6.5 2 M6.25 9.5 V14.5 C6.25 16.4 7.6 17.75 9.5 17.75 H14.5 M9.5 6.25 H14.5 C16.4 6.25 17.75 7.6 17.75 9.5 V14.5")]
let IC_GLOBE = [svgPath("O 12 12 9 M3 12 H21 E 12 12 3.8 9")]
let IC_IMPORT = [svgPath("M13 3 H8 C6.3 3 5 4.3 5 6 V18 C5 19.7 6.3 21 8 21 H10.5 M13 3 L19 9 V11 M13 3 V7 C13 8.1 13.9 9 15 9 H19 M14.3 17 C14.6 15.3 16 14 17.7 14 C18.9 14 19.9 14.6 20.5 15.5 M21 18 C20.7 19.7 19.3 21 17.6 21 C16.4 21 15.4 20.4 14.8 19.5 M20.7 13.6 V15.8 H18.5 M14.6 21.4 V19.2 H16.8")]
let IC_KEY = [svgPath("O 15.5 8.5 4.5 M12.3 11.7 L4 20 M6.7 17.3 L9 19.6 M9 15 L10.8 16.8")]
let IC_AGENT = [svgPath("R 6.5 3 11 9.5 3.5 M9.8 7.6 H9.81 M14.2 7.6 H14.21 M4.5 21 C4.5 17.4 7.6 15 12 15 C16.4 15 19.5 17.4 19.5 21")]
let IC_ACTIVITY = [svgPath("R 3 3 18 18 5 M7 12.5 H9 L10.5 9 L13.5 16 L15 12.5 H17")]
let IC_INSIGHTS = [svgPath("O 12 5 2 M11.1 6.8 L5.5 21 M12.9 6.8 L18.5 21 M7.4 16.2 C10.3 17.6 13.7 17.6 16.6 16.2")]
let IC_CHEV_R = [svgPath("M9.5 6 L15.5 12 L9.5 18")]
let IC_CHEV_L = [svgPath("M14.5 6 L8.5 12 L14.5 18")]
let IC_CHEV_D = [svgPath("M6 9.5 L12 15.5 L18 9.5")]
let IC_PLUS = [svgPath("M12 5 V19 M5 12 H19")]
let IC_X = [svgPath("M6.5 6.5 L17.5 17.5 M17.5 6.5 L6.5 17.5")]
let IC_USER = [svgPath("O 12 8 4 M5 21 C5 17.1 8.1 14.5 12 14.5 C15.9 14.5 19 17.1 19 21")]
let IC_LOCK = [svgPath("R 4.5 10.5 15 10.5 3 M8 10.5 V7.5 C8 5.3 9.8 3.5 12 3.5 C14.2 3.5 16 5.3 16 7.5 V10.5 M12 14.5 V16.5")]
let IC_MONITOR = [svgPath("R 2.5 4 19 13 2.5 M12 17 V20.5 M8 20.5 H16")]
let IC_CLOCK = [svgPath("O 12 12 9 M12 7.5 V12 L15 14")]
let IC_TERMINAL = [svgPath("R 3 3 18 18 5 M7.5 9 L10.5 12 L7.5 15 M12.5 15 H16.5")]
let IC_FILE = [svgPath("M14 3 H8 C6.3 3 5 4.3 5 6 V18 C5 19.7 6.3 21 8 21 H16 C17.7 21 19 19.7 19 18 V8 Z M14 3 V6 C14 7.1 14.9 8 16 8 H19 M9 13 H15 M9 17 H13")]
let IC_FILTER = [svgPath("M4 5 H20 L14 12.5 V19 L10 17 V12.5 Z")]
let IC_TREND = [svgPath("M3 17 L9 11 L13 15 L21 7 M15.5 7 H21 V12.5")]
let IC_PLAY = [svgPath("M7.5 5 V19 L19 12 Z")]
let IC_SEND = [svgPath("M12 19 V5.5 M6.5 11 L12 5.5 L17.5 11")]
let IC_CHECK_CIRCLE = [svgPath("O 12 12 9 M8.3 12.4 L10.8 14.9 L15.9 9.6")]
let IC_GEAR: [CGPath] = {
	let p = CGMutablePath()
	let steps = 240
	for s in 0...steps {
		let th = Double(s) / Double(steps) * 2 * Double.pi
		let tooth = max(-1, min(1, cos(8 * th) * 2.4)) * 0.5 + 0.5
		let r = 7.1 + 2.1 * tooth
		let pt = CGPoint(x: 12 + r * cos(th), y: 12 + r * sin(th))
		if s == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
	}
	p.closeSubpath()
	p.addEllipse(in: CGRect(x: 9, y: 9, width: 6, height: 6))
	return [p]
}()
func dots3(_ c: CGContext, _ cx: CGFloat, _ cy: CGFloat, _ color: UInt32, _ a: CGFloat) {
	for i in -1...1 { dot(c, CGPoint(x: cx + CGFloat(i) * 4.5 * TS, y: cy), 1.15 * TS, color, a) }
}

// ---------------------------------------------------------------- logos (the console's own marks)
let LOGO_CLAUDE = loadLogo("claude-code", mono: false)
let LOGO_CURSOR = loadLogo("cursor", mono: true)
let LOGO_CODEX = loadLogo("codex", mono: true)
let LOGO_OPENCODE = loadLogo("opencode", mono: true)
let ONBOARD_LOGOS = [LOGO_CLAUDE, LOGO_CURSOR, LOGO_CODEX, LOGO_OPENCODE]

// ---------------------------------------------------------------- demo data helpers
struct LCG {
	var s: UInt64
	mutating func next() -> Double {
		s = s &* 6364136223846793005 &+ 1442695040888963407
		return Double((s >> 33) & 0xFFFFFF) / Double(0xFFFFFF)
	}
}
func demoSeries(_ seed: UInt64, _ n: Int, base: Double, spikes: [Int: Double]) -> [Double] {
	var g = LCG(s: seed)
	return (0..<n).map { i in spikes[i] ?? (base * (0.55 + 0.9 * g.next())) }
}
func demoID(_ seed: UInt64, _ n: Int = 22) -> String {
	let abc = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
	var g = LCG(s: seed &* 7919 &+ 17)
	return String((0..<n).map { _ in abc[Int(g.next() * Double(abc.count - 1))] })
}
let MASKED_KEY = "sm_" + String(repeating: "•", count: 12)

// ================================================================ state (everything a timeline animates)
enum Page: Int { case overview, agents, keys, requests }
enum Nav: Int, CaseIterable { case overview, playground, namespaces, graph, connectors, importer, keys, agents, requests, insights, settings }
func navFor(_ p: Page) -> Nav { [Nav.overview, .agents, .keys, .requests][p.rawValue] }

struct NavState {
	var from: Nav = .overview
	var to: Nav = .overview
	var k: Double = 1            // 0..1 progress of the highlight sliding from -> to (eased inside)
	var hover: Nav? = nil
	var hoverK: Double = 0
}
struct CopyBox {
	var hover: Double = 0        // 0..1: box lightens to #121212, the copy icon fades in (page: 0.18s)
	var copiedT: Double? = nil   // seconds since the click: copy icon scales out, #4fb877 check scales in (shown while hovered)
}
struct OverviewState {
	var greeting = "Good evening"
	var range = 2                // 0 1d, 1 7d, 2 30d (default), 3 All
	var onboardHover: Double = 0
	var tooltip: Double = 0      // 0..1 "Copies a one-line setup prompt…"
	var toast: Double = 0        // 0..1 "Prompt copied. Paste it into your agent."
	var lower = true             // the chart / namespaces / recent cards under the stat row
}
struct AgentsState {
	var rowT: Double? = nil      // seconds since the demo row arrived (nil = empty state); enter = opacity 0->1, y +6->0, 0.26s
	var proof: Double = 0        // 0..1 the #0562ef left edge on the row (beat 4)
	var names: [Double] = [0, 0, 0, 0]   // "Claude Code, Cursor, Codex and OpenCode." each name #a2a2a2 -> #fafafa
	var cmd = CopyBox(), mcp = CopyBox(), cli = CopyBox()
	var emptyText = true         // false: an empty body (beat 1's crop would cut the centred empty-state lines)
}
struct KeysState {
	var createHover: Double = 0  // the page's "+ Create key" button
	var dialogT: Double? = nil   // seconds since the dialog opened (nil = closed)
	var keyName = "calm-blue-harbor"     // the auto slug (placeholder grey, as the page shows it)
	var scopedHover: Double = 0
	var cancelHover: Double = 0
	var submitHover: Double = 0
	var createdT: Double? = nil  // seconds since "Create key" was pressed in the dialog
	var key = CopyBox()          // the created key's copy button (always visible; hover adds its background)
	var closeK: Double = 0       // 0..1 the dialog and its overlay fade away (Done)
}
struct RequestsState {
	var newRowT: Double? = nil   // seconds since the newest row landed on top (nil = not there yet)
	var proof: Double = 0        // 0..1 the #0562ef left edge on that row (beat 8)
}
struct ConsoleState {
	var page: Page = .overview
	var enterT: Double? = nil    // seconds since this page opened (sections stagger in); nil = settled
	var prev: Page? = nil        // outgoing page, drawn underneath at prevA
	var prevA: Double = 0
	var nav = NavState()
	var ov = OverviewState(), ag = AgentsState(), keys = KeysState(), req = RequestsState()
	var hidden: Set<String> = [] // "onboard", "table", "connect", "mcp", "cli": skip so a lifted copy is not doubled
	var dim: Double = 0          // 0..1 -> page at 15% (black veil 0.85), for lift-outs drawn on top
	var scrollY: CGFloat = 0
	var topBar = true
}

// ---------------------------------------------------------------- shared bits
let STAGGER = 0.05
func enterK(_ t: Double?, _ i: Int) -> Double {
	guard let t = t else { return 1 }
	let t0 = Double(i) * STAGGER
	return enterEase(seg(t, t0, t0 + 0.26))
}
/// One page section with the console's enter motion (opacity 0->1, y +6->0, staggered).
func section(_ c: CGContext, _ t: Double?, _ i: Int, _ body: () -> Void) {
	let k = enterK(t, i)
	layer(c, CGFloat(k), dy: 6 * CGFloat(1 - k), body)
}
func hair(_ c: CGContext, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ a: CGFloat = 1) {
	rect(c, CGRect(x: x, y: y, width: w, height: 1), fill: WHITE, fa: BORDER_A * a)
}
func vhair(_ c: CGContext, _ x: CGFloat, _ y: CGFloat, _ h: CGFloat, _ a: CGFloat = 1) {
	rect(c, CGRect(x: x, y: y, width: 1, height: h), fill: WHITE, fa: BORDER_A * a)
}
/// Geist Mono 10px 500 uppercase, letter-spacing .06em (stat and table labels).
func monoLabel(_ c: CGContext, _ s: String, _ x: CGFloat, _ cy: CGFloat, _ color: UInt32 = C_TEXT2, _ a: CGFloat = 1, _ al: Align = .left, size: CGFloat = 10) {
	ctext(c, s.uppercased(), uim(size, 500), x, cy, color, a, al, track: 0.06 * size * TS)
}
func card(_ c: CGContext, _ r: CGRect, radius: CGFloat = 10, fill: UInt32 = C_BG) {
	rrect(c, r, radius, fill: fill, stroke: WHITE, sa: BORDER_A)
}
/// Page title (20px 600) + subtitle (14px) with its blue doc link and arrow. Returns the link's rect.
@discardableResult
func pageTitle(_ c: CGContext, _ x: CGFloat, _ title: String) -> CGRect {
	let f = ui(20, 600)
	ctext(c, title, f, x, 86.75, C_TEXT, 1)
	return CGRect(x: x, y: 73, width: textW(title, f), height: 28)
}
@discardableResult
func pageSub(_ c: CGContext, _ x: CGFloat, _ sub: String, _ link: String) -> CGRect {
	let f = ui(14), lf = ui(14, 500)
	ctext(c, sub, f, x, 116, C_TEXT2, 1)
	let lx = x + textW(sub + " ", f)
	ctext(c, link, lf, lx, 116, C_ACCENT_TEXT, 1)
	let lw = textW(link, lf)
	icon(c, IC_ARROW, lx + lw + 3 + 6 * TS, 116.5, 12 * TS, C_ACCENT_TEXT, 1)
	return CGRect(x: lx, y: 106, width: lw + 3 + 12 * TS, height: 20)
}
/// Table header cell: icon + mono label.
func headCell(_ c: CGContext, _ ic: [CGPath], _ iconX: CGFloat, _ label: String, _ cy: CGFloat) {
	icon(c, ic, iconX, cy, 12 * TS, C_ICON, 1)
	monoLabel(c, label, iconX + 7 * TS + 6, cy)
}

// ================================================================ shell: sidebar + top bar
struct NavItem { let label: String; let icon: [CGPath]; let top: CGFloat }
let NAV: [NavItem] = [
	NavItem(label: "Overview", icon: IC_HOME, top: 100), NavItem(label: "Playground", icon: IC_CHAT, top: 134),
	NavItem(label: "Namespaces", icon: IC_TAG, top: 210), NavItem(label: "Memory Graph", icon: IC_GRAPH, top: 244),
	NavItem(label: "Connectors", icon: IC_GLOBE, top: 278), NavItem(label: "Import", icon: IC_IMPORT, top: 312),
	NavItem(label: "API Keys", icon: IC_KEY, top: 388), NavItem(label: "Agents & MCP", icon: IC_AGENT, top: 422),
	NavItem(label: "Requests", icon: IC_ACTIVITY, top: 456), NavItem(label: "User Insights", icon: IC_INSIGHTS, top: 490),
	NavItem(label: "Settings", icon: IC_GEAR, top: 531),
]
let NAV_GROUPS: [(String, CGFloat)] = [("Data", 194), ("Developer", 372)]
/// A nav item's box (8px inset, 32 tall): use for cursor targets.
func navRect(_ n: Nav) -> CGRect { CGRect(x: 8, y: NAV[n.rawValue].top - 1, width: 224, height: 34) }
let SEARCH_BOX = CGRect(x: 8, y: 52, width: 224, height: 35)

func drawSidebar(_ c: CGContext, _ n: NavState) {
	rect(c, CGRect(x: 0, y: 0, width: SIDEBAR_W, height: PAGE.height), fill: C_BG2)
	// logo: mark + wordmark in white, with the small TM
	let wr = drawLockup(c, x: 20, y: 14.5, markH: 17.5, color: C_TEXT, a: 1)
	text(c, "™", sans(7, 500), wr.maxX + 1, wr.minY + 6.5, C_TEXT, 0.9)
	// search
	rrect(c, SEARCH_BOX, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
	icon(c, IC_SEARCH, 29.5, SEARCH_BOX.midY, 15 * TS, C_ICON, 1)
	ctext(c, "Search…", ui(14), 44, SEARCH_BOX.midY, C_ICON, 1)
	let kf = uim(10, 500)
	let kw = textW("⌘K", kf) + 10
	let kr = CGRect(x: SEARCH_BOX.maxX - 13 - kw, y: SEARCH_BOX.midY - 8, width: kw, height: 16)
	rrect(c, kr, 4, fill: 0x1a1a1a)
	ctext(c, "⌘K", kf, kr.midX, kr.midY, C_ICON, 1, .center)
	// highlight slides between items
	let k = ease(max(0, min(1, n.k)))
	if let h = n.hover, n.hoverK > 0.003, h != n.to { rrect(c, navRect(h), 8, fill: C_SIDE_HOVER, fa: CGFloat(n.hoverK)) }
	rrect(c, lerpR(navRect(n.from), navRect(n.to), k), 8, fill: C_ACTIVE, stroke: WHITE, sa: 0.045)
	for (g, cy) in NAV_GROUPS { monoLabel(c, g, 20, cy, C_ICON) }
	let f = ui(14)
	for nv in Nav.allCases {
		let it = NAV[nv.rawValue]
		var act = 0.0
		if n.from == n.to { act = nv == n.to ? 1 : 0 }
		else if nv == n.to { act = k } else if nv == n.from { act = 1 - k }
		let hov = (n.hover == nv) ? n.hoverK : 0
		let colr = mix(mix(C_TEXT2, C_TEXT, hov), C_ACCENT_TEXT, act)
		let cy = it.top + 16
		icon(c, it.icon, 30, cy, 16 * TS, colr, 1)
		ctext(c, it.label, f, 44, cy, colr, 1)
	}
	icon(c, IC_CHEV_R, 211, NAV[Nav.settings.rawValue].top + 16, 14 * TS, C_ICON, 1)
}

/// Top bar: demo workspace switcher ("acme" + Scale badge), Help, Docs.
func drawTopBar(_ c: CGContext) {
	rect(c, CGRect(x: SIDEBAR_W, y: 0, width: PAGE.width - SIDEBAR_W, height: TOPBAR_H), fill: C_BG)
	rect(c, CGRect(x: SIDEBAR_W, y: TOPBAR_H - 1, width: PAGE.width - SIDEBAR_W, height: 1), fill: WHITE, fa: BORDER_MUTED_A)
	let tile = CGRect(x: 277, y: 23 - 7 * TS, width: 14 * TS, height: 14 * TS)
	rrect(c, tile, 3.5, fill: C_ACCENT)
	ctext(c, "A", sans(9 * TS, 650), tile.midX, tile.midY, WHITE, 1, .center)
	let nf = ui(14, 500)
	let nx = tile.maxX + 8
	ctext(c, "acme", nf, nx, 23, C_TEXT, 1)
	let bf = ui(10.5, 600)
	let bx = nx + textW("acme", nf) + 8
	let br = CGRect(x: bx, y: 23 - 8 * TS, width: textW("Scale", bf) + 14, height: 16 * TS)
	rrect(c, br, br.height / 2, fill: C_ACCENT)
	ctext(c, "Scale", bf, br.midX, br.midY, WHITE, 1, .center)
	icon(c, IC_CHEV_D, br.maxX + 11, 23.5, 12 * TS, C_ICON, 1)
	// Help, Docs (right aligned at 1446)
	let hf = ui(12.5, 500)
	let dw = 11.5 + textW("Docs", hf) + 5 + 12 * TS + 11.5
	let dr = CGRect(x: MAIN_R - dw, y: 8, width: dw, height: 30)
	let hw = 10.75 * 2 + textW("Help", hf)
	let hr = CGRect(x: dr.minX - 7 - hw, y: 8, width: hw, height: 30)
	rrect(c, hr, 8, fill: C_BG2)
	rrect(c, dr, 8, fill: C_BG2)
	ctext(c, "Help", hf, hr.midX, 23, C_TEXT, 1, .center)
	ctext(c, "Docs", hf, dr.minX + 11.5, 23, C_TEXT, 1)
	icon(c, IC_ARROW, dr.maxX - 11.5 - 6 * TS, 23, 12 * TS, C_TEXT2, 1)
}

// ================================================================ Overview
struct Stat { let label: String; let value: String; let delta: String?; let bars: [Double] }
let OV_STATS: [Stat] = [
	Stat(label: "Documents", value: "2.4k", delta: "+18%", bars: demoSeries(11, 24, base: 0.18, spikes: [7: 0.92, 23: 0.55])),
	Stat(label: "Memories", value: "9.1k", delta: "+24%", bars: demoSeries(23, 24, base: 0.28, spikes: [12: 0.8, 15: 0.95, 16: 0.7, 23: 0.6])),
	Stat(label: "Search requests", value: "12.6k", delta: "+31%", bars: demoSeries(37, 24, base: 0.3, spikes: [9: 0.75, 18: 1.0, 23: 0.7])),
	Stat(label: "Namespaces", value: "14", delta: "+40%", bars: demoSeries(41, 24, base: 0.35, spikes: [0: 0.95, 11: 0.8, 23: 0.6])),
	Stat(label: "Connectors", value: "3", delta: "+50%", bars: demoSeries(53, 24, base: 0.12, spikes: [5: 0.6, 17: 0.9, 23: 0.5])),
]
let STAT_W: CGFloat = 224, STAT_H: CGFloat = 105, STAT_Y: CGFloat = 150
func statRect(_ i: Int) -> CGRect { CGRect(x: MAIN_X + CGFloat(i) * (STAT_W + 15.5), y: STAT_Y, width: STAT_W, height: STAT_H) }

func drawStatCard(_ c: CGContext, _ r: CGRect, _ s: Stat) {
	card(c, r)
	monoLabel(c, s.label, r.minX + 16, r.minY + 21)
	let nf = uim(22, 500)
	ctext(c, s.value, nf, r.minX + 16, r.minY + 50, C_TEXT, 1)
	if let d = s.delta {
		let x = r.minX + 16 + textW(s.value, nf) + 10
		icon(c, IC_TREND, x + 5 * TS, r.minY + 51, 10 * TS, C_OK, 1)
		ctext(c, d, uim(10.5), x + 12 * TS, r.minY + 51, C_OK, 1)
	}
	let base = r.minY + 92
	for (i, v) in s.bars.enumerated() {
		let h = max(2, CGFloat(v) * 17.5)
		let last = i == s.bars.count - 1
		rect(c, CGRect(x: r.minX + 16 + CGFloat(i) * 6, y: base - h, width: 3, height: h), fill: C_ACCENT, fa: last ? 1 : 0.5)
	}
}

func drawRangeTabs(_ c: CGContext, _ active: Int) {
	let labels = ["1d", "7d", "30d", "All"]
	let f = ui(12.5, 500)
	let ws = labels.map { textW($0, f) + 25 }
	let total = ws.reduce(0, +) + 6
	let box = CGRect(x: MAIN_R - total, y: 72, width: total, height: 34)   // measured 72 -> 106
	rrect(c, box, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
	var x = box.minX + 3
	for (i, l) in labels.enumerated() {
		let r = CGRect(x: x, y: box.minY + 3, width: ws[i], height: box.height - 6)
		if i == active { rrect(c, r, 6, fill: C_ACTIVE, stroke: C_TINT_STROKE, sa: 0.55) }
		ctext(c, l, f, r.midX, r.midY, i == active ? C_ACCENT_TEXT : mix(C_TEXT2, C_TEXT, 0.45), 1, .center)
		x += ws[i]
	}
}

// the Onboard line (lifts out in beat 6)
let OV_ONBOARD = CGPoint(x: MAIN_X, y: 123)     // left x, centre y
let ONBOARD_TEXT = "Onboard your agent to supermemory"
let ONBOARD_GAP: CGFloat = 5.75 * TS   // text end -> first mark box (the capture shows ~7.5px of air)
/// Size of the line (text + four marks), for a lift-out card or a cursor target.
func onboardSize() -> CGSize {
	let w = textW(ONBOARD_TEXT, ui(12.75))
	return CGSize(width: w + ONBOARD_GAP + 3 * 18.4 * TS + 12.5 * TS, height: 20)
}
func onboardRect() -> CGRect {
	let s = onboardSize()
	return CGRect(x: OV_ONBOARD.x, y: OV_ONBOARD.y - s.height / 2, width: s.width, height: s.height)
}
func drawOnboardLine(_ c: CGContext, _ o: CGPoint, hover: Double) {
	let f = ui(12.75)
	let tc = mix(C_TEXT2, C_TEXT, hover)
	ctext(c, ONBOARD_TEXT, f, o.x, o.y, tc, 1)
	let w = textW(ONBOARD_TEXT, f)
	let uy = midBase(f, o.y) + 3 * TS
	segLine(c, CGPoint(x: o.x, y: uy), CGPoint(x: o.x + w, y: uy), C_ICON, 0.5 + 0.4 * CGFloat(hover), lw: 1, dash: [1, 2])
	let box = 12.5 * TS, pitch = 18.4 * TS
	for (i, l) in ONBOARD_LOGOS.enumerated() {
		let cx = o.x + w + ONBOARD_GAP + box / 2 + CGFloat(i) * pitch
		drawLogoIn(c, l, CGRect(x: cx - box / 2, y: o.y - box / 2, width: box, height: box), tc, 1)
	}
}
/// Small float tooltip, top-left at p.
func drawTooltip(_ c: CGContext, at p: CGPoint, _ lines: [String], _ k: Double) {
	if k <= 0.003 { return }
	let a = CGFloat(min(1, k))
	let f = ui(12)
	let lh: CGFloat = 17 * TS
	let w = (lines.map { textW($0, f) }.max() ?? 0) + 20
	let r = CGRect(x: p.x, y: p.y + 4 * CGFloat(1 - eout(k)), width: w, height: CGFloat(lines.count) * lh + 14)
	rrect(c, r, 8, fill: C_FLOAT, fa: a, stroke: WHITE, sa: 0.1 * a)
	for (i, l) in lines.enumerated() { ctext(c, l, f, r.minX + 10, r.minY + 7 + lh * (CGFloat(i) + 0.5), C_TEXT, a) }
}
let OV_TOOLTIP_LINES = ["Copies a one-line setup prompt.", "Works with Claude Code, Cursor, Codex, OpenCode."]
/// Toast, bottom right, rises 14px as it appears.
func drawToast(_ c: CGContext, _ msg: String, _ k: Double) {
	if k <= 0.003 { return }
	let a = CGFloat(min(1, k * 1.4))
	let f = ui(13, 500)
	let w = 16 + 16 * TS + 10 + textW(msg, f) + 18
	let h: CGFloat = 50
	let r = CGRect(x: MAIN_R - w, y: PAGE.height - 24 - h + 14 * CGFloat(1 - eout(k)), width: w, height: h)
	rrect(c, r, 10, fill: C_FLOAT, fa: a, stroke: WHITE, sa: 0.1 * a)
	icon(c, IC_CHECK_CIRCLE, r.minX + 16 + 8 * TS, r.midY, 16 * TS, C_OK, a)
	ctext(c, msg, f, r.minX + 16 + 16 * TS + 10, r.midY, C_TEXT, a)
}
let TOAST_COPIED = "Prompt copied. Paste it into your agent."

// lower cards (demo data)
let OV_CHART = CGRect(x: MAIN_X, y: 270.5, width: 825, height: 289)
let OV_NS = CGRect(x: 1105, y: 270.5, width: 341, height: 289)
let OV_RECENT = CGRect(x: MAIN_X, y: 577.5, width: 583, height: 250)
let OV_LATEST = CGRect(x: 863, y: 577.5, width: 583, height: 250)
let CHART_N = 42
let CHART_S = demoSeries(101, CHART_N, base: 0.06, spikes: [20: 0.62, 21: 0.12, 23: 0.16, 26: 0.3, 28: 0.22, 38: 0.4, 39: 0.14])
let CHART_M = demoSeries(202, CHART_N, base: 0.06, spikes: [20: 0.2, 21: 0.12, 23: 0.18, 26: 0.4, 28: 0.3, 38: 0.18, 39: 0.16])
let NS_DEMO: [(String, Int)] = [("acme_default", 2140), ("support_bot", 860), ("docs_site", 412), ("user_1042", 188), ("onboarding", 96), ("sales_notes", 54), ("eval_runs", 21)]
let RECENT_DEMO: [(String, String, String)] = [
	("User prefers pnpm over npm in every repo", "acme_default", "2m ago"),
	("Deploys go through the staging branch first", "acme_default", "9m ago"),
	("Support replies should link the matching docs page", "support_bot", "14m ago"),
]
func cardTitle(_ c: CGContext, _ s: String, _ x: CGFloat, _ cy: CGFloat) {
	ctext(c, s, ui(15, 600), x, cy, C_TEXT, 1, track: -0.15 * TS)
}
func drawChartCard(_ c: CGContext, _ r: CGRect) {
	card(c, r)
	cardTitle(c, "Requests this month", r.minX + 16, r.minY + 28.3)
	// legend, right to left
	var x = r.maxX - 16
	let lf = uim(10, 500)
	for (s, sq, tc) in [("Live", C_ACCENT, C_ACCENT_TEXT), ("Searches", C_ACCENT, C_TEXT2), ("Memories", 0x34548c, C_TEXT2)] as [(String, UInt32, UInt32)] {
		let w = textW(s.uppercased(), lf, track: 0.6 * TS)
		monoLabel(c, s, x, r.minY + 28.3, tc, 1, .right)
		rect(c, CGRect(x: x - w - 11, y: r.minY + 25.3, width: 6, height: 6), fill: sq)
		x -= w + 11 + 14
	}
	let base = r.minY + 232, maxH: CGFloat = 146
	for i in 0..<CHART_N {
		let bx = r.minX + 26 + CGFloat(i) * 18.49
		let hs = max(3, CGFloat(CHART_S[i]) * maxH), hm = max(3, CGFloat(CHART_M[i]) * maxH)
		rrect(c, CGRect(x: bx, y: base - hs, width: 15, height: hs), 2, fill: C_ACCENT)
		rrect(c, CGRect(x: bx, y: base - hs - 2 - hm, width: 15, height: hm), 2, fill: 0x34548c)
	}
	rect(c, CGRect(x: r.minX + 16, y: r.minY + 249, width: r.width - 32, height: 1), fill: WHITE, fa: BORDER_MUTED_A)
	monoLabel(c, "30d ago", r.minX + 16, r.minY + 265.5, C_ICON)
	monoLabel(c, "now", r.maxX - 16, r.minY + 265.5, C_ICON, 1, .right)
}
func drawNamespacesCard(_ c: CGContext, _ r: CGRect) {
	card(c, r)
	cardTitle(c, "Namespaces", r.minX + 16, r.minY + 28.3)
	let f = uim(11), mx = Double(NS_DEMO[0].1)
	for (i, (name, n)) in NS_DEMO.enumerated() {
		let cy = r.minY + 74.8 + CGFloat(i) * 30.3
		let cw = textW(name, f) + 12
		rrect(c, CGRect(x: r.minX + 16, y: cy - 10, width: cw, height: 20), 4, fill: C_FLOAT)
		ctext(c, name, f, r.minX + 22, cy, C_TEXT, 1)
		let len = max(7, 62 * CGFloat(Double(n) / mx))
		rrect(c, CGRect(x: r.maxX - 53 - len, y: cy - 1.25, width: len, height: 2.5), 1.25, fill: C_ACCENT)
		ctext(c, "\(n)", f, r.maxX - 17, cy, C_TEXT2, 1, .right)
	}
}
func drawRecentCard(_ c: CGContext, _ r: CGRect) {
	card(c, r)
	cardTitle(c, "Recent memories", r.minX + 16, r.minY + 27.2)
	let vf = ui(12.5, 500)
	icon(c, IC_CHEV_R, r.maxX - 16 - 6 * TS, r.minY + 27.2, 12 * TS, C_ACCENT_TEXT, 1)
	ctext(c, "View all", vf, r.maxX - 16 - 12 * TS - 3, r.minY + 27.2, C_ACCENT_TEXT, 1, .right)
	let tf = ui(13), cf = uim(10.5)
	for (i, (s, ns, tm)) in RECENT_DEMO.enumerated() {
		let cy = r.minY + 66.5 + CGFloat(i) * 33.4
		icon(c, IC_FILE, r.minX + 24, cy, 14 * TS, C_ICON, 1)
		let tx = r.maxX - 17 - textW(tm, ui(12))
		ctext(c, tm, ui(12), r.maxX - 17, cy, C_TEXT2, 1, .right)
		let cw = textW(ns, cf) + 14
		let chip = CGRect(x: tx - 16 - cw, y: cy - 10, width: cw, height: 20)
		rrect(c, chip, 4, fill: C_FLOAT)
		ctext(c, ns, cf, chip.minX + 7, cy, C_TEXT2, 1)
		ctext(c, truncated(s, tf, chip.minX - 12 - (r.minX + 39)), tf, r.minX + 39, cy, C_TEXT, 1)
	}
}
func drawLatestCard(_ c: CGContext, _ r: CGRect) {
	card(c, r)
	cardTitle(c, "Latest searches", r.minX + 16, r.minY + 27.2)
	icon(c, IC_SEARCH, r.midX, r.minY + 96, 20 * TS, C_ICON, 1)
	ctext(c, "No searches yet", ui(13.5, 600), r.midX, r.minY + 124.2, C_TEXT, 1, .center)
	ctext(c, "Searches from the API and playground land here.", ui(12), r.midX, r.minY + 151.5, C_TEXT2, 1, .center)
	let bf = ui(12.5, 500)
	let bw = 12 + 12 * TS + 7 + textW("Try the playground", bf) + 13
	let br = CGRect(x: r.midX - bw / 2, y: r.minY + 175.5, width: bw, height: 31.5)
	rrect(c, br, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
	icon(c, IC_PLAY, br.minX + 12 + 6 * TS, br.midY, 12 * TS, C_TEXT2, 1)
	ctext(c, "Try the playground", bf, br.minX + 12 + 12 * TS + 7, br.midY, C_TEXT, 1)
}

func drawOverview(_ c: CGContext, _ s: ConsoleState) {
	let o = s.ov, t = s.enterT
	section(c, t, 0) {
		ctext(c, o.greeting, ui(20, 600), MAIN_X, 90.9, C_TEXT, 1)
		drawRangeTabs(c, o.range)
	}
	if !s.hidden.contains("onboard") { section(c, t, 1) { drawOnboardLine(c, OV_ONBOARD, hover: o.onboardHover) } }
	section(c, t, 2) { for i in 0..<5 { drawStatCard(c, statRect(i), OV_STATS[i]) } }
	if o.lower {
		section(c, t, 3) { drawChartCard(c, OV_CHART); drawNamespacesCard(c, OV_NS) }
		section(c, t, 4) { drawRecentCard(c, OV_RECENT); drawLatestCard(c, OV_LATEST) }
	}
}

// ================================================================ Agents & MCP
let AG_TABLE = CGRect(x: AG_X, y: 176, width: AG_W, height: 140)   // header 38 + body 102 (row 57.5 + footer 44.5)
let AG_ROW = CGRect(x: AG_X, y: 214, width: AG_W, height: 57.5)
// The "Connect an agent" card stops after the "All editor plugins at once" row (no tab strip), so the MCP and CLI
// cards sit 17px under it with the page's own card gap.
let AG_CONNECT = CGRect(x: AG_X, y: 403, width: AG_W, height: 121)
let AG_MCP = CGRect(x: AG_X, y: 541, width: AG_W, height: 121)
let AG_CLI = CGRect(x: AG_X, y: 679, width: AG_W, height: 116)
/// Command box inside a card, relative to the card's origin (box 460x32.75 at x 503, centred in its row).
func cardBoxRel(rowTop: CGFloat, rowH: CGFloat) -> CGRect { CGRect(x: 503, y: rowTop + rowH / 2 - 16.375, width: 460, height: 32.75) }
let BOX_REL_TALL = cardBoxRel(rowTop: 57, rowH: 63)       // rows with a subline
let BOX_REL_SHORT = cardBoxRel(rowTop: 57, rowH: 58)      // rows without
func offset(_ r: CGRect, _ o: CGPoint) -> CGRect { r.offsetBy(dx: o.x, dy: o.y) }
let AG_CMD_BOX = offset(BOX_REL_TALL, AG_CONNECT.origin)
let AG_MCP_BOX = offset(BOX_REL_TALL, AG_MCP.origin)
let AG_CLI_BOX = offset(BOX_REL_SHORT, AG_CLI.origin)
/// Copy icon centre inside a command box (cursor target).
func copyIconCenter(_ box: CGRect) -> CGPoint { CGPoint(x: box.maxX - 14.5 * TS, y: box.midY) }

func drawCopyBox(_ c: CGContext, _ r: CGRect, _ s: String, _ b: CopyBox) {
	rrect(c, r, 8, fill: mix(C_BG2, C_MUTED, b.hover))
	let f = uim(12.5)
	ctext(c, truncated(s, f, r.width - 12 - 30 * TS), f, r.minX + 12, r.midY, C_TEXT, 1)
	let ic = CGRect(x: r.maxX - 21 * TS, y: r.midY - 6.5 * TS, width: 13 * TS, height: 13 * TS)
	let hv = CGFloat(b.hover)
	if let s = b.copiedT {
		let out = ease(seg(s, 0, 0.18)), inn = spring(s, 0.02, freq: 3.2, zeta: 0.6)
		strokeIcon(c, IC_COPY, ic, C_ICON, hv * CGFloat(1 - out), scale: CGFloat(1 - 0.75 * out))
		strokeIcon(c, IC_CHECK, ic, C_OK, hv * CGFloat(min(1, inn * 1.4)), scale: CGFloat(0.25 + 0.75 * inn))
	} else {
		strokeIcon(c, IC_COPY, ic, C_ICON, hv)
	}
}
/// Card frame: #0a0a0a body, #101010 57px header with its title (and optional docs link), hairline under it.
func drawCardHeader(_ c: CGContext, _ r: CGRect, _ title: String, link: String?) {
	c.saveGState()
	let p = rrPath(r, 10)
	c.addPath(p); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(p); c.clip()
	rect(c, CGRect(x: r.minX, y: r.minY, width: r.width, height: 57), fill: C_BG2)
	hair(c, r.minX, r.minY + 57, r.width)
	ctext(c, title, ui(13, 500), r.minX + 13, r.minY + 28.5, C_TEXT, 1)
	if let l = link {
		let ax = r.maxX - 21 - 6 * TS
		icon(c, IC_ARROW, ax, r.minY + 28.5, 12 * TS, C_TEXT2, 1)
		ctext(c, l, ui(12), ax - 6 * TS - 4, r.minY + 28.5, C_TEXT2, 1, .right)
	}
	c.restoreGState()
}
func cardBorder(_ c: CGContext, _ r: CGRect) { rrect(c, r, 10, stroke: WHITE, sa: BORDER_A) }

/// "Connect an agent": header + the "All editor plugins at once" row. o = card's top-left.
func drawConnectCard(_ c: CGContext, _ o: CGPoint, _ st: AgentsState) {
	let r = CGRect(origin: o, size: AG_CONNECT.size)
	drawCardHeader(c, r, "Connect an agent", link: nil)
	ctext(c, "All editor plugins at once", ui(12.5, 500), o.x + 13, o.y + 78.4, C_TEXT, 1)
	let n = st.names
	func nc(_ i: Int) -> UInt32 { mix(C_TEXT2, C_STRONG, i < n.count ? n[i] : 0) }
	runs(c, [("Claude Code", nc(0)), (", ", C_TEXT2), ("Cursor", nc(1)), (", ", C_TEXT2), ("Codex", nc(2)), (" and ", C_TEXT2), ("OpenCode", nc(3)), (".", C_TEXT2)],
	     ui(11.5), o.x + 13, o.y + 99.4, 1)
	drawCopyBox(c, offset(BOX_REL_TALL, o), "npx supermemory plugin", st.cmd)
	cardBorder(c, r)
}
/// "Connect over MCP". o = card's top-left.
func drawMCPCard(_ c: CGContext, _ o: CGPoint, _ b: CopyBox) {
	let r = CGRect(origin: o, size: AG_MCP.size)
	drawCardHeader(c, r, "Connect over MCP", link: "MCP setup docs")
	ctext(c, "Add this URL to your MCP client", ui(12.5, 500), o.x + 13, o.y + 78.4, C_TEXT, 1)
	ctext(c, "Signs in through your browser. No API key needed.", ui(11.5), o.x + 13, o.y + 99.4, C_TEXT2, 1)
	drawCopyBox(c, offset(BOX_REL_TALL, o), "https://mcp.supermemory.ai/mcp", b)
	cardBorder(c, r)
}
/// "Supermemory CLI". o = card's top-left.
func drawCLICard(_ c: CGContext, _ o: CGPoint, _ b: CopyBox) {
	let r = CGRect(origin: o, size: AG_CLI.size)
	drawCardHeader(c, r, "Supermemory CLI", link: nil)
	ctext(c, "Manage this workspace from a shell", ui(12.5, 500), o.x + 13, o.y + 86, C_TEXT, 1)
	drawCopyBox(c, offset(BOX_REL_SHORT, o), "npm i -g supermemory && supermemory login", b)
	cardBorder(c, r)
}

// Connected table: column separators and header icons measured from the capture (relative to the table's left)
let AGT_SEPS: [CGFloat] = [275, 432.6, 620.4, 750.6, 898]
let AGT_HEAD: [([CGPath], CGFloat, String)] = [(IC_AGENT, 22.7, "Agent"), (IC_LOCK, 300, "Access"), (IC_MONITOR, 459, "Device"), (IC_CLOCK, 646.6, "Created"), (IC_ACTIVITY, 776, "Last active")]
/// The "Connected" table: empty state, or the demo row entering. o = table's top-left.
func drawConnectedTable(_ c: CGContext, _ o: CGPoint, _ st: AgentsState) {
	let r = CGRect(origin: o, size: AG_TABLE.size)
	c.saveGState()
	let p = rrPath(r, 10)
	c.addPath(p); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(p); c.clip()
	for (ic, x, l) in AGT_HEAD { headCell(c, ic, o.x + x, l, o.y + 19) }
	hair(c, o.x, o.y + 38, r.width)
	let rk: Double = st.rowT.map { enterEase(seg($0, 0, 0.26)) } ?? 0
	let emptyA = CGFloat(1 - (st.rowT.map { ease(seg($0, 0, 0.12)) } ?? 0))
	// empty state
	if emptyA > 0.003 && st.emptyText {
		let cx = o.x + r.width / 2
		icon(c, IC_AGENT, cx, o.y + 62, 20 * TS, C_ICON, emptyA)
		ctext(c, "No agents connected yet.", ui(13.5, 500), cx, o.y + 87, C_TEXT, emptyA, .center)
		ctext(c, "Agents appear here with their key, device, and access.", ui(12), cx, o.y + 108, C_TEXT2, emptyA, .center)
	}
	// the row
	if rk > 0.003 {
		let a = CGFloat(rk)
		layer(c, a, dy: 6 * CGFloat(1 - rk)) {
			let top = o.y + 38, cy = top + 28.75
			for sx in AGT_SEPS { vhair(c, o.x + sx, top, 57.5) }
			let tile = CGRect(x: o.x + 16, y: cy - 13, width: 26, height: 26)
			rrect(c, tile, 6, fill: C_BG2, stroke: WHITE, sa: BORDER_A)
			drawLogoIn(c, LOGO_CLAUDE, tile.insetBy(dx: 5.5, dy: 5.5), WHITE, 1)
			ctext(c, "claude-code", ui(13, 500), o.x + 53, top + 20, C_TEXT, 1)
			ctext(c, maskedKeyFill(200), uim(10), o.x + 53, top + 39.4, C_ICON, 1)
			rrect(c, CGRect(x: o.x + 296 - 3, y: cy - 3, width: 6, height: 6), 1.5, fill: C_OK)
			ctext(c, "Read & write", ui(12.5), o.x + 307.4, cy, C_TEXT, 1)
			ctext(c, "dev-laptop", ui(12.5), o.x + 453.8, cy, C_TEXT, 1)
			ctext(c, "just now", ui(12), o.x + 641.6, cy, C_TEXT2, 1)
			ctext(c, "—", ui(12), o.x + 770.8, cy, C_ICON, 1)
			dots3(c, o.x + 950.5, cy, C_ICON, 1)
			hair(c, o.x, top + 57.5, r.width)
			// footer
			let fy = top + 57.5 + 22.25
			let ff = uim(11, 600)
			ctext(c, "1-1", ff, o.x + 16.6, fy, C_TEXT, 1)
			ctext(c, "of 1", ui(11), o.x + 16.6 + textW("1-1", ff) + 5, fy, C_ICON, 1)
			rrect(c, CGRect(x: o.x + 296 - 3, y: fy - 3, width: 6, height: 6), 1.5, fill: C_OK)
			ctext(c, "1", ff, o.x + 304, fy, C_TEXT, 1)
			ctext(c, "read & write", ui(11), o.x + 304 + textW("1", ff) + 5, fy, C_TEXT2, 1)
			icon(c, IC_CHEV_L, o.x + 928, fy, 12 * TS, C_ICON, 0.6)
			icon(c, IC_CHEV_R, o.x + 949.6, fy, 12 * TS, C_ICON, 0.6)
		}
		if st.proof > 0.003 {
			rect(c, CGRect(x: o.x, y: o.y + 38 + 6 * CGFloat(1 - rk), width: 2.5, height: 57.5), fill: C_PROOF, fa: CGFloat(st.proof) * a)
		}
	}
	c.restoreGState()
	rrect(c, r, 10, stroke: WHITE, sa: BORDER_A)
}

func drawAgents(_ c: CGContext, _ s: ConsoleState) {
	let t = s.enterT, st = s.ag
	section(c, t, 0) { pageTitle(c, AG_X, "Agents") }
	section(c, t, 1) { pageSub(c, AG_X, "Connect the tools you code with, or build memory into your own product.", "How agents connect") }
	section(c, t, 2) {
		cardTitle(c, "Connected", AG_X, 152)
		if !s.hidden.contains("table") { drawConnectedTable(c, AG_TABLE.origin, st) }
	}
	section(c, t, 3) {
		cardTitle(c, "In your agents", AG_X, 358.5)
		ctext(c, "Supermemory as a plugin: your agents and the CLI share this workspace's memory.", ui(13), AG_X, 380.5, C_TEXT2, 1)
	}
	if !s.hidden.contains("connect") { section(c, t, 4) { drawConnectCard(c, AG_CONNECT.origin, st) } }
	if !s.hidden.contains("mcp") { section(c, t, 5) { drawMCPCard(c, AG_MCP.origin, st.mcp) } }
	if !s.hidden.contains("cli") { section(c, t, 6) { drawCLICard(c, AG_CLI.origin, st.cli) } }
}

// ================================================================ API Keys
let KY_TABLE = CGRect(x: MAIN_X, y: 144, width: MAIN_W, height: 38 + 3 * 57 + 44)
let KY_SEPS: [CGFloat] = [814, 971.6, 1101.7, 1236.7, 1369]
let KY_HEAD: [([CGPath], CGFloat, String)] = [(IC_KEY, 286, "API key"), (IC_LOCK, 839, "Scope"), (IC_CLOCK, 996.6, "Created"), (IC_ACTIVITY, 1126.7, "Last used"), (IC_CLOCK, 1261.7, "Expires")]
let KY_ROWS: [(String, String, String, String)] = [("acme-backend", "3d ago", "1h ago", "11th Oct, 2027"), ("support-bot", "9d ago", "12m ago", "—"), ("staging", "21d ago", "—", "—")]
/// A fully masked key that fills `w` in the list's mono 10px (the console prints keys this long, masked).
func maskedKeyFill(_ w: CGFloat) -> String {
	let f = uim(10)
	let n = Int(((w - textW("sm_", f)) / textW("•", f)).rounded(.down))
	return "sm_" + String(repeating: "•", count: max(12, n))
}
/// The page's "+ Create key" button (cursor target).
func keysCreateButton() -> CGRect {
	let w = 14 + 14 * TS + 6 + textW("Create key", ui(13, 500)) + 15
	return CGRect(x: MAIN_R - w, y: 93, width: w, height: 33)
}
func drawBlueButton(_ c: CGContext, _ r: CGRect, _ label: String, hover: Double, plus: Bool = true) {
	rrect(c, r, 8, fill: mix(C_ACCENT, 0x1d6fe8, hover))
	let f = ui(13, 500)
	let w = (plus ? 14 * TS + 6 : 0) + textW(label, f)
	let x0 = r.midX - w / 2
	if plus { icon(c, IC_PLUS, x0 + 7 * TS, r.midY, 14 * TS, WHITE, 1) }
	ctext(c, label, f, x0 + (plus ? 14 * TS + 6 : 0), r.midY, WHITE, 1)
}
func drawKeysTable(_ c: CGContext) {
	let r = KY_TABLE
	c.saveGState()
	let p = rrPath(r, 10)
	c.addPath(p); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(p); c.clip()
	for (ic, x, l) in KY_HEAD { headCell(c, ic, x, l, r.minY + 19) }
	hair(c, r.minX, r.minY + 38, r.width)
	for (i, row) in KY_ROWS.enumerated() {
		let top = r.minY + 38 + CGFloat(i) * 57, cy = top + 28.5
		for sx in KY_SEPS { vhair(c, sx, top, 57) }
		ctext(c, row.0, ui(13, 500), MAIN_X + 17, top + 20, C_TEXT, 1)
		ctext(c, maskedKeyFill(505), uim(10), MAIN_X + 17, top + 41.5, C_ICON, 1)
		rrect(c, CGRect(x: 835, y: cy - 3, width: 6, height: 6), 1.5, fill: C_OK)
		ctext(c, "Full access", ui(12.5), 848, cy, C_TEXT, 1)
		ctext(c, row.1, ui(12), 993.3, cy, C_TEXT2, 1)
		ctext(c, row.2, ui(12), 1123.4, cy, row.2 == "—" ? C_ICON : C_TEXT2, 1)
		ctext(c, row.3, ui(12), 1258.4, cy, row.3 == "—" ? C_ICON : C_TEXT2, 1)
		dots3(c, 1421, cy, C_ICON, 1)
		hair(c, r.minX, top + 57, r.width)
	}
	let fy = r.maxY - 22
	let ff = uim(11, 600)
	ctext(c, "1-3", ff, MAIN_X + 17, fy, C_TEXT, 1)
	ctext(c, "of 3", ui(11), MAIN_X + 17 + textW("1-3", ff) + 5, fy, C_ICON, 1)
	rrect(c, CGRect(x: 835, y: fy - 3, width: 6, height: 6), 1.5, fill: C_OK)
	ctext(c, "3", ff, 845, fy, C_TEXT, 1)
	ctext(c, "active", ui(11), 845 + textW("3", ff) + 5, fy, C_TEXT2, 1)
	c.restoreGState()
	rrect(c, r, 10, stroke: WHITE, sa: BORDER_A)
}
func drawKeys(_ c: CGContext, _ s: ConsoleState) {
	let t = s.enterT
	section(c, t, 0) { pageTitle(c, MAIN_X, "API Keys") }
	section(c, t, 1) {
		pageSub(c, MAIN_X, "Create keys that let your apps use the API.", "How API keys work")
		drawBlueButton(c, keysCreateButton(), "Create key", hover: s.keys.createHover)
	}
	section(c, t, 2) { drawKeysTable(c) }
}

// ---------------------------------------------------------------- the Create API key dialog (centred on the viewport)
let DLG_X: CGFloat = 496, DLG_W: CGFloat = 478, DLG_CY: CGFloat = 417
let DLG_FORM_H: CGFloat = 446, DLG_DONE_H: CGFloat = 196
func dialogHeight(_ st: KeysState) -> CGFloat { lerpC(DLG_FORM_H, DLG_DONE_H, ease(seg(st.createdT ?? 0, 0, 0.24))) }
func dialogRect(_ st: KeysState) -> CGRect { let h = dialogHeight(st); return CGRect(x: DLG_X, y: DLG_CY - h / 2, width: DLG_W, height: h) }
// form-state targets (absolute)
let DLG_FORM_TOP = DLG_CY - DLG_FORM_H / 2
let DLG_NAME = CGRect(x: DLG_X + 25, y: DLG_FORM_TOP + 131.5, width: 428, height: 35.5)
let DLG_EXPIRES = CGRect(x: DLG_X + 25, y: DLG_FORM_TOP + 212, width: 428, height: 35.6)
let DLG_PERMS = CGRect(x: DLG_X + 25, y: DLG_FORM_TOP + 294, width: 428, height: 37)
let DLG_FULL = CGRect(x: DLG_PERMS.minX + 2.5, y: DLG_PERMS.minY + 2.5, width: 202.5, height: 32)
let DLG_SCOPED = CGRect(x: DLG_FULL.maxX, y: DLG_FULL.minY, width: DLG_PERMS.width - 5 - 202.5, height: 32)
let DLG_CANCEL = CGRect(x: DLG_X + 25, y: DLG_FORM_TOP + 387.7, width: 208, height: 33)
let DLG_SUBMIT = CGRect(x: DLG_X + 246, y: DLG_FORM_TOP + 387.7, width: 207, height: 33)
let DLG_HELP = "This key can access every resource. For production, a scoped key is safer."
// created-state targets (absolute, once settled)
let DLG_DONE_TOP = DLG_CY - DLG_DONE_H / 2
let DLG_KEYBOX = CGRect(x: DLG_X + 25, y: DLG_DONE_TOP + 105, width: 428, height: 38)
let DLG_KEYCOPY = CGRect(x: DLG_KEYBOX.maxX - 33, y: DLG_KEYBOX.midY - 14, width: 28, height: 28)

func drawKeyDialog(_ c: CGContext, _ st: KeysState) {
	guard let dt = st.dialogT else { return }
	let openK = eout(seg(dt, 0, 0.2)) * (1 - ease(st.closeK))
	if openK <= 0.003 { return }
	rect(c, PAGE, fill: BLACK, fa: OVERLAY_A * CGFloat(openK))
	let r = dialogRect(st)
	let ck = st.createdT ?? -1
	let formA = CGFloat(1 - seg(ck, 0, 0.14)), doneA = CGFloat(seg(ck, 0.06, 0.24))
	c.saveGState()
	let sc = CGFloat(0.96 + 0.04 * openK)
	c.translateBy(x: r.midX, y: r.midY); c.scaleBy(x: sc, y: sc); c.translateBy(x: -r.midX, y: -r.midY)
	layer(c, CGFloat(openK)) {
		rrect(c, r, 14, fill: C_FLOAT)
		c.saveGState()
		c.addPath(rrPath(r, 14)); c.clip()          // the form folds away inside the shrinking dialog
		icon(c, IC_X, r.minX + 440, r.minY + 30.6, 16 * TS, C_TEXT2, 1)
		hair(c, r.minX, r.minY + 81, r.width)
		let x = r.minX + 25
		// form
		layer(c, formA) {
			ctext(c, "Create API key", ui(15, 600), x, r.minY + 30.6, C_TEXT, 1)
			ctext(c, "Choose what this key is allowed to do.", ui(12.5), x, r.minY + 57, C_TEXT2, 1)
			let lf = ui(12.5, 500)
			ctext(c, "Key name", lf, x, r.minY + 114, C_TEXT, 1)
			let nr = CGRect(x: x, y: r.minY + 131.5, width: 428, height: 35.5)
			rrect(c, nr.insetBy(dx: -2, dy: -2), 10, stroke: C_ACCENT, sa: 0.22, lw: 2)
			rrect(c, nr, 8, fill: C_BG, stroke: mix(C_TINT_STROKE, C_ACCENT, 0.35), lw: 1)
			ctext(c, st.keyName, ui(13), nr.minX + 12, nr.midY, C_ICON, 1)
			ctext(c, "Expires", lf, x, r.minY + 194.6, C_TEXT, 1)
			let er = CGRect(x: x, y: r.minY + 212, width: 428, height: 35.6)
			rrect(c, er, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
			ctext(c, "1 year", ui(13), er.minX + 16.5, er.midY, C_TEXT, 1)
			icon(c, IC_CHEV_D, er.maxX - 25.4, er.midY, 13 * TS, C_TEXT2, 1)
			ctext(c, "Permissions", lf, x, r.minY + 275.4, C_TEXT, 1)
			let pr = CGRect(x: x, y: r.minY + 294, width: 428, height: 37)
			rrect(c, pr, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
			let full = CGRect(x: pr.minX + 2.5, y: pr.minY + 2.5, width: 202.5, height: 32)
			let scoped = CGRect(x: full.maxX, y: full.minY, width: pr.width - 5 - 202.5, height: 32)
			rrect(c, full, 6, fill: C_ACTIVE)
			rrect(c, scoped, 6, fill: C_MUTED, fa: CGFloat(st.scopedHover))
			let sf = ui(12.5, 500)
			ctext(c, "Full access", sf, full.midX, full.midY, C_ACCENT_TEXT, 1, .center)
			ctext(c, "Scoped", sf, scoped.midX, scoped.midY, mix(C_TEXT2, C_TEXT, st.scopedHover), 1, .center)
			ctext(c, DLG_HELP, fitFont(DLG_HELP, 11.5, 400, 428), x, r.minY + 354.9, C_ICON, 1)
			let cr = CGRect(x: x, y: r.minY + 387.7, width: 208, height: 33)
			rrect(c, cr, 8, fill: mix(C_BG, C_MUTED, st.cancelHover), stroke: WHITE, sa: BORDER_A)
			ctext(c, "Cancel", ui(13, 500), cr.midX, cr.midY, C_TEXT, 1, .center)
			drawBlueButton(c, CGRect(x: r.minX + 246, y: r.minY + 387.7, width: 207, height: 33), "Create key", hover: st.submitHover)
		}
		// created
		layer(c, doneA) {
			ctext(c, "API key created", ui(15, 600), x, r.minY + 30.6, C_TEXT, 1)
			ctext(c, "Copy this key now. You won't be able to see it again.", ui(12.5), x, r.minY + 57, C_TEXT2, 1)
			let kb = CGRect(x: x, y: r.minY + 105, width: 428, height: 38)
			rrect(c, kb, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
			ctext(c, "sm_" + String(repeating: "•", count: 32), uim(12.5), kb.minX + 12, kb.midY, C_TEXT, 1)
			runs(c, [("Saved as ", C_ICON), (st.keyName, C_TEXT2), (" · expires in 1 year", C_ICON)], ui(11.5), x, r.minY + 165, 1)
			let cb = CGRect(x: kb.maxX - 33, y: kb.midY - 14, width: 28, height: 28)
			rrect(c, cb, 6, fill: C_MUTED, fa: CGFloat(st.key.hover))
			let ic = CGRect(x: cb.midX - 6.5 * TS, y: cb.midY - 6.5 * TS, width: 13 * TS, height: 13 * TS)
			if let s = st.key.copiedT {
				let out = ease(seg(s, 0, 0.18)), inn = spring(s, 0.02, freq: 3.2, zeta: 0.6)
				strokeIcon(c, IC_COPY, ic, mix(C_ICON, C_TEXT, st.key.hover), CGFloat(1 - out), scale: CGFloat(1 - 0.75 * out))
				strokeIcon(c, IC_CHECK, ic, C_OK, CGFloat(min(1, inn * 1.4)), scale: CGFloat(0.25 + 0.75 * inn))
			} else {
				strokeIcon(c, IC_COPY, ic, mix(C_ICON, C_TEXT, st.key.hover), 1)
			}
		}
		c.restoreGState()
		rrect(c, r, 14, stroke: WHITE, sa: BORDER_A)
	}
	c.restoreGState()
}

// ================================================================ Requests
struct Req { let type: String; let id: String; let ms: Int; let doc: Bool; let time: String }
let RQ_NEW = Req(type: "search", id: demoID(1), ms: 184, doc: false, time: "just now")
let RQ_ROWS: [Req] = [
	Req(type: "add", id: demoID(2), ms: 412, doc: true, time: "2m ago"),
	Req(type: "search", id: demoID(3), ms: 196, doc: false, time: "3m ago"),
	Req(type: "search", id: demoID(4), ms: 231, doc: false, time: "6m ago"),
	Req(type: "add", id: demoID(5), ms: 388, doc: true, time: "9m ago"),
	Req(type: "search", id: demoID(6), ms: 205, doc: false, time: "12m ago"),
	Req(type: "add", id: demoID(7), ms: 451, doc: true, time: "15m ago"),
	Req(type: "search", id: demoID(8), ms: 219, doc: false, time: "19m ago"),
	Req(type: "add", id: demoID(9), ms: 402, doc: true, time: "24m ago"),
	Req(type: "search", id: demoID(10), ms: 188, doc: false, time: "27m ago"),
	Req(type: "search", id: demoID(11), ms: 243, doc: false, time: "31m ago"),
]
let RQ_FILTER_Y: CGFloat = 142.6
let RQ_CARD_Y: CGFloat = 193, RQ_CARD_H: CGFloat = 127.5
func rqCard(_ i: Int) -> CGRect { let w = (MAIN_W - 32) / 3; return CGRect(x: MAIN_X + CGFloat(i) * (w + 16), y: RQ_CARD_Y, width: w, height: RQ_CARD_H) }
let RQ_TABLE_Y: CGFloat = 337.2, RQ_HEAD_H: CGFloat = 38.5, RQ_ROW_H: CGFloat = 57
let RQ_SEPS: [CGFloat] = [764.6, 894.6, 1173.5, 1325]
let RQ_HEAD: [([CGPath], CGFloat, String)] = [(IC_TERMINAL, 286.4, "Type"), (IC_ACTIVITY, 786, "Status"), (IC_CLOCK, 921, "Duration"), (IC_FILE, 1201, "Document"), (IC_CLOCK, 1350, "Time")]
/// The top body row of the Requests table (where the newest call lands).
let RQ_TOP_ROW = CGRect(x: MAIN_X, y: RQ_TABLE_Y + RQ_HEAD_H, width: MAIN_W, height: RQ_ROW_H)

func drawFilterButton(_ c: CGContext, _ x: CGFloat, _ ic: [CGPath], _ label: String) -> CGFloat {
	let f = ui(12.5, 500)
	let w = 12 + 14 * TS + 6 + textW(label, f) + 7 + 12 * TS + 10
	let r = CGRect(x: x, y: RQ_FILTER_Y, width: w, height: 34)
	rrect(c, r, 8, fill: C_BG, stroke: WHITE, sa: BORDER_A)
	icon(c, ic, r.minX + 12 + 7 * TS, r.midY, 14 * TS, C_TEXT2, 1)
	ctext(c, label, f, r.minX + 12 + 14 * TS + 6, r.midY, C_TEXT, 1)
	icon(c, IC_CHEV_D, r.maxX - 10 - 6 * TS, r.midY, 12 * TS, C_ICON, 1)
	return r.maxX
}
func drawRqCards(_ c: CGContext) {
	let nf = uim(22, 500)
	// BY TYPE
	var r = rqCard(0)
	card(c, r)
	monoLabel(c, "By type", r.minX + 17, r.minY + 21.5)
	ctext(c, "1,284", nf, r.minX + 17, r.minY + 44, C_TEXT, 1)
	ctext(c, "requests", ui(12), r.minX + 17 + textW("1,284", nf) + 6, r.minY + 46, C_TEXT2, 1)
	var x = r.minX + 17
	for (name, n, colr) in [("search", "842", C_ACCENT), ("add", "442", C_TYPE_ADD)] as [(String, String, UInt32)] {
		rect(c, CGRect(x: x, y: r.minY + 73 - 2.5, width: 5, height: 5), fill: colr)
		x += 9
		x = runs(c, [(name + " ", C_TEXT2)], ui(11), x, r.minY + 73, 1)
		ctext(c, n, uim(11, 600), x, r.minY + 73, C_TEXT, 1)
		x += textW(n, uim(11, 600)) + 12
	}
	let bw = r.width - 34 - 3
	rrect(c, CGRect(x: r.minX + 17, y: r.minY + 109, width: bw * 842 / 1284, height: 8), 2, fill: C_ACCENT)
	rrect(c, CGRect(x: r.minX + 17 + bw * 842 / 1284 + 3, y: r.minY + 109, width: bw * 442 / 1284, height: 8), 2, fill: C_TYPE_ADD)
	// 2XX RESPONSES
	r = rqCard(1)
	card(c, r)
	monoLabel(c, "2xx responses", r.minX + 17, r.minY + 21.5)
	ctext(c, "1,284", nf, r.minX + 17, r.minY + 75.5, C_TEXT, 1)
	ctext(c, "of 1,284", ui(11.5), r.minX + 17 + textW("1,284", nf) + 8, r.minY + 77.5, C_TEXT2, 1)
	for i in 0..<31 {   // 4px bars at 7.55 pitch, the last ~15 fade out (measured)
		let fade = i < 16 ? 1.0 : max(0.1, 1 - Double(i - 15) * 0.06)
		rrect(c, CGRect(x: r.minX + 17 + CGFloat(i) * 7.55, y: r.minY + 98, width: 4, height: 16), 1, fill: C_ACCENT, fa: CGFloat(fade))
	}
	// AVG SEARCH LATENCY
	r = rqCard(2)
	card(c, r)
	monoLabel(c, "Avg search latency", r.minX + 17, r.minY + 21.5)
	ctext(c, "212", nf, r.minX + 17, r.minY + 107.5, C_TEXT, 1)
	ctext(c, "ms · last 30 days", ui(11.5), r.minX + 17 + textW("212", nf) + 8, r.minY + 109, C_TEXT2, 1)
}
func drawReqRow(_ c: CGContext, _ q: Req, top: CGFloat) {
	let cy = top + RQ_ROW_H / 2
	for sx in RQ_SEPS { vhair(c, sx, top, RQ_ROW_H) }
	rrect(c, CGRect(x: 282.5, y: top + 21.4 - 2.5, width: 5, height: 5), 1, fill: q.type == "add" ? C_TYPE_ADD : C_ACCENT)
	ctext(c, q.type, ui(13, 500), 296.5, top + 21.4, C_TEXT, 1)
	ctext(c, q.id, ui(10.5), 296.5, top + 39.4, C_ICON, 1)
	let pf = uim(10.5, 500)
	let pr = CGRect(x: 785, y: cy - 9.5, width: textW("200", pf) + 12, height: 19)
	rrect(c, pr, 5, fill: mix(C_BG, C_OK, 0.12), stroke: mix(C_BG, C_OK, 0.42), lw: 1)
	ctext(c, "200", pf, pr.midX, cy, C_OK, 1, .center)
	ctext(c, "\(q.ms)", uim(12.5), 913.5, cy, C_TEXT, 1)
	rrect(c, CGRect(x: 969, y: cy - 1.75, width: CGFloat(q.ms) * 0.25, height: 3.5), 1.75, fill: C_ACCENT)
	if q.doc {
		icon(c, IC_FILE, 1201, cy, 12 * TS, C_ACCENT_TEXT, 1)
		ctext(c, "View", ui(12.5, 500), 1201 + 6 * TS + 6, cy, C_ACCENT_TEXT, 1)
	} else {
		ctext(c, "—", ui(12), 1194, cy, C_ICON, 1)
	}
	ctext(c, q.time, ui(12), 1345, cy, C_TEXT2, 1)
	hair(c, MAIN_X, top + RQ_ROW_H, MAIN_W)
}
func drawRqTable(_ c: CGContext, _ st: RequestsState) {
	let r = CGRect(x: MAIN_X, y: RQ_TABLE_Y, width: MAIN_W, height: RQ_HEAD_H + 9 * RQ_ROW_H)
	c.saveGState()
	let p = rrPath(r, 10)
	c.addPath(p); c.setFillColor(col(C_BG)); c.fillPath()
	c.addPath(p); c.clip()
	for (ic, x, l) in RQ_HEAD { headCell(c, ic, x, l, r.minY + RQ_HEAD_H / 2) }
	icon(c, IC_CHEV_D, 1364 + textW("TIME", uim(10, 500), track: 0.6 * TS) + 8, r.minY + RQ_HEAD_H / 2, 10 * TS, C_ICON, 1)
	hair(c, r.minX, r.minY + RQ_HEAD_H, r.width)
	let body = r.minY + RQ_HEAD_H
	var push: CGFloat = 0, nk = 0.0
	if let t = st.newRowT {
		nk = enterEase(seg(t, 0, 0.26))
		push = RQ_ROW_H * CGFloat(ease(seg(t, 0, 0.3)))
	}
	for (i, q) in RQ_ROWS.enumerated() { drawReqRow(c, q, top: body + push + CGFloat(i) * RQ_ROW_H) }
	if nk > 0.003 {
		layer(c, CGFloat(nk), dy: 6 * CGFloat(1 - nk)) { drawReqRow(c, RQ_NEW, top: body) }
		if st.proof > 0.003 { rect(c, CGRect(x: r.minX, y: body + 6 * CGFloat(1 - nk), width: 2.5, height: RQ_ROW_H), fill: C_PROOF, fa: CGFloat(st.proof * nk)) }
	}
	c.restoreGState()
	rrect(c, r, 10, stroke: WHITE, sa: BORDER_A)
}
func drawRequests(_ c: CGContext, _ s: ConsoleState) {
	let t = s.enterT
	section(c, t, 0) { pageTitle(c, MAIN_X, "Requests") }
	section(c, t, 1) { pageSub(c, MAIN_X, "Every API call, with timing and status.", "How usage is measured") }
	section(c, t, 2) {
		var x = MAIN_X
		x = drawFilterButton(c, x, IC_FILTER, "All types") + 9
		x = drawFilterButton(c, x, IC_ACTIVITY, "All statuses") + 9
		_ = drawFilterButton(c, x, IC_CLOCK, "Last 30 days")
	}
	section(c, t, 3) { drawRqCards(c) }
	section(c, t, 4) { drawRqTable(c, s.req) }
}

// ================================================================ the whole console
func drawPage(_ c: CGContext, _ s: ConsoleState) {
	switch s.page {
	case .overview: drawOverview(c, s)
	case .agents: drawAgents(c, s)
	case .keys: drawKeys(c, s)
	case .requests: drawRequests(c, s)
	}
}
/// Draw the console in page CSS px (0..1470 x 0..835). Set the camera transform on c first.
func drawConsole(_ c: CGContext, _ s: ConsoleState) {
	rect(c, PAGE, fill: C_BG)
	c.saveGState()
	c.clip(to: CGRect(x: SIDEBAR_W, y: 0, width: PAGE.width - SIDEBAR_W, height: PAGE.height))
	c.translateBy(x: 0, y: -s.scrollY)
	if let p = s.prev, p != s.page, s.prevA > 0.003 {
		var ps = s; ps.page = p; ps.enterT = nil
		layer(c, CGFloat(s.prevA)) { drawPage(c, ps) }
	}
	drawPage(c, s)
	c.restoreGState()
	if s.topBar { drawTopBar(c) }
	drawSidebar(c, s.nav)
	if s.page == .overview {
		drawTooltip(c, at: CGPoint(x: OV_ONBOARD.x, y: OV_ONBOARD.y + 14), OV_TOOLTIP_LINES, s.ov.tooltip)
		drawToast(c, TOAST_COPIED, s.ov.toast)
	}
	if s.page == .keys { drawKeyDialog(c, s.keys) }
	if s.dim > 0.003 { rect(c, PAGE, fill: BLACK, fa: 0.9 * CGFloat(s.dim)) }
}

// ================================================================ outside the console: terminal, agent input, cursor
struct TermState {
	var rect: CGRect
	var title = "~/acme-app"
	var cmd = "npx supermemory plugin"
	var prompt = "$"             // "$" for a shell, ">" for an agent session
	var typed: Double = 1        // 0..1 of cmd typed
	var caret = true             // block caret visible (blink it from the timeline)
	var dim: Double = 0          // 0..1: after Enter the command line settles at 60%
	var tag: String? = nil       // small mono tag in the title bar, e.g. "new session"
	var lines: [(String, UInt32)] = []
	var size: CGFloat = 15
	var alpha: Double = 1
}
func drawTerminal(_ c: CGContext, _ s: TermState) {
	let a = CGFloat(s.alpha)
	if a <= 0.003 { return }
	let r = s.rect
	layer(c, a) {
		rrect(c, r, 12, fill: C_BG, stroke: WHITE, sa: 0.1)
		for i in 0..<3 { dot(c, CGPoint(x: r.minX + 20 + CGFloat(i) * 18, y: r.minY + 19), 5.5, WHITE, 0.16) }
		ctext(c, s.title, mono(12.5), r.midX, r.minY + 19, C_TEXT2, 0.8, .center)
		if let tag = s.tag {
			let tf = mono(10.5, 500)
			let tw = textW(tag.uppercased(), tf, track: 0.8) + 14
			let tr = CGRect(x: r.maxX - 14 - tw, y: r.minY + 10, width: tw, height: 18)
			rrect(c, tr, 4, stroke: WHITE, sa: 0.14)
			ctext(c, tag.uppercased(), tf, tr.midX, tr.midY, C_TEXT2, 1, .center, track: 0.8)
		}
		rect(c, CGRect(x: r.minX + 1, y: r.minY + 38, width: r.width - 2, height: 1), fill: WHITE, fa: 0.07)
		let f = mono(s.size, 500), pf = mono(s.size, 400)
		let cw = textW("M", f)
		let lh = s.size * 1.7
		let x0 = r.minX + 24, y0 = r.minY + 38 + 18 + lh / 2
		let la = CGFloat(1 - 0.4 * s.dim)
		ctext(c, s.prompt, pf, x0, y0, C_TEXT2, 0.55 * la)
		let n = Int((Double(s.cmd.count) * max(0, min(1, s.typed))).rounded(.down))
		let typedS = String(s.cmd.prefix(n))
		ctext(c, typedS, f, x0 + 2 * cw, y0, C_TEXT, la)
		if s.caret {
			let cx = x0 + 2 * cw + textW(typedS, f)
			rect(c, CGRect(x: cx + 1, y: y0 - s.size * 0.62, width: cw * 0.92, height: s.size * 1.24), fill: C_TEXT, fa: 0.8 * la)
		}
		for (i, l) in s.lines.enumerated() { ctext(c, l.0, pf, x0, y0 + CGFloat(i + 1) * lh, l.1, 1) }
	}
}
struct AgentInputState {
	var rect: CGRect
	var placeholder = "Message your agent"
	var text: String? = nil      // first line of the pasted prompt
	var moreLines: Int = 0       // "+N lines" pill
	var pill: String? = nil      // or a plain label for the pill ("pasted text")
	var caret = false
	var sendHover: Double = 0
	var alpha: Double = 1
}
/// A plain, unbranded agent input card.
func drawAgentInput(_ c: CGContext, _ s: AgentInputState) {
	let a = CGFloat(s.alpha)
	if a <= 0.003 { return }
	let r = s.rect
	layer(c, a) {
		rrect(c, r, 14, fill: C_BG2, stroke: WHITE, sa: 0.09)
		let x = r.minX + 20, y = r.minY + 30
		if let t = s.text {
			let f = mono(14)
			let shown = truncated(t, f, r.width - 40)
			ctext(c, shown, f, x, y, C_TEXT, 1)
			if s.caret { rect(c, CGRect(x: x + textW(shown, f) + 2, y: y - 9, width: 1.6, height: 18), fill: C_TEXT, fa: 0.9) }
			if s.moreLines > 0 || s.pill != nil {
				let pf = mono(11.5, 500)
				let label = s.pill ?? "+\(s.moreLines) lines"
				let pr = CGRect(x: x, y: y + 18, width: textW(label, pf) + 16, height: 22)
				rrect(c, pr, 6, fill: C_FLOAT, stroke: WHITE, sa: 0.08)
				ctext(c, label, pf, pr.midX, pr.midY, C_TEXT2, 1, .center)
			}
		} else {
			ctext(c, s.placeholder, sans(15, 400), x, y, C_ICON, 1)
			if s.caret { rect(c, CGRect(x: x, y: y - 9, width: 1.6, height: 18), fill: C_TEXT, fa: 0.9) }
		}
		let by = r.maxY - 26
		let ar = CGRect(x: r.minX + 14, y: by - 14, width: 28, height: 28)
		rrect(c, ar, 14, stroke: WHITE, sa: 0.12)
		icon(c, IC_PLUS, ar.midX, ar.midY, 15, C_TEXT2, 1)
		let sr = CGRect(x: r.maxX - 14 - 30, y: by - 15, width: 30, height: 30)
		rrect(c, sr, 15, fill: mix(C_TEXT2, C_TEXT, s.text == nil ? 0 : 1 - 0.2 * s.sendHover))
		icon(c, IC_SEND, sr.midX, sr.midY, 16, C_BG, 1, lw: 2)
	}
}
/// "console.supermemory.ai" URL chip, centred on p.
func drawURLChip(_ c: CGContext, _ p: CGPoint, _ a: CGFloat, _ s: String = "console.supermemory.ai", size: CGFloat = 13) {
	if a <= 0.003 { return }
	let f = mono(size, 450)
	let w = 14 + size + 7 + textW(s, f) + 16
	let h = size * 2.3
	let r = CGRect(x: p.x - w / 2, y: p.y - h / 2, width: w, height: h)
	rrect(c, r, h / 2, fill: C_BG2, fa: a, stroke: WHITE, sa: 0.1 * a)
	icon(c, IC_LOCK, r.minX + 14 + size / 2, p.y, size, C_TEXT2, a)
	ctext(c, s, f, r.minX + 14 + size + 7, p.y, C_TEXT, a)
}
/// Arrow pointer, tip at p; `size` 1 = 25 units tall. press 0..1 squashes it slightly.
func drawCursor(_ c: CGContext, _ p: CGPoint, _ a: CGFloat, press: CGFloat = 0, size: CGFloat = 1) {
	if a <= 0.003 { return }
	let s = size * (1 - 0.14 * press)
	let pts: [(CGFloat, CGFloat)] = [(0, 0), (0, 25), (6, 19.5), (10.5, 29.5), (14.5, 27.8), (10.2, 18), (17.8, 18)]
	c.saveGState()
	c.translateBy(x: p.x, y: p.y); c.scaleBy(x: s, y: s)
	c.move(to: CGPoint(x: pts[0].0, y: pts[0].1))
	for q in pts.dropFirst() { c.addLine(to: CGPoint(x: q.0, y: q.1)) }
	c.closePath()
	c.setFillColor(col(WHITE, a)); c.setStrokeColor(col(INK, a)); c.setLineWidth(1.6); c.setLineJoin(.round)
	c.drawPath(using: .fillStroke)
	c.restoreGState()
}
/// Click ripple at p, k = 0..1 progress (0.45s in the films).
func drawRipple(_ c: CGContext, _ p: CGPoint, _ k: Double, size: CGFloat = 1) {
	if k <= 0 || k >= 1 { return }
	let r = (4 + 22 * CGFloat(eout(k))) * size
	c.setStrokeColor(col(WHITE, 0.75 * CGFloat(1 - k))); c.setLineWidth(1.6 * size)
	c.strokeEllipse(in: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r))
}
