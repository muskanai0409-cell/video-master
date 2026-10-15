// ================================================================ memories: small pixel-art scenes, drawn here in code
// Seven moments most people carry (a parent's hand, learning to ride, home, a sunset, a birthday, a dog, a kite) and a
// scatter of everyday ones (a cup, a song, a star, rain). Warm colours only: blue is kept for the pulse that brings the
// ones that matter back. Every cell is authored below; nothing is traced from an image.

// palette: the supermemory brand book's own colours only (paper, and the six weather stops: sky, dawn, dream, mist, glow,
// gold). Memories are warm (gold and glow) on the blue field; the dim pixels sit in the cool stops.
let PAL: [Character: UInt32] = [
	"W": 0xf4f8ff, "C": 0xf4f8ff,                 // paper
	"Y": 0xf3c77a, "F": 0xffe0a8, "L": 0xf3c77a, "O": 0xe9b25e,   // gold (and a lit and a deeper gold)
	"R": 0xfaebcf, "P": 0xfaebcf,                 // glow
	"T": 0xcde5ff, "H": 0xcde5ff, "B": 0xc1d8e4,  // dawn, mist
	"D": 0x94b6ff, "S": 0x94b6ff,                 // sky (the dim pixels)
	"G": 0xc1d8e4, "V": 0xced9ff,                 // mist, dream
]
let FLICKER: Set<Character> = ["F", "L"]

struct Cell { let x: Int; let y: Int; let ch: Character }
struct PixArt {
	let w: Int, h: Int
	let frames: [[Cell]]          // animation frames (cells only)
	let frameDur: Double
}
func art(_ frames: [[String]], frameDur: Double = 0.2) -> PixArt {
	let h = frames[0].count, w = frames[0].map { $0.count }.max()!
	let fs = frames.map { rows -> [Cell] in
		var cs: [Cell] = []
		for (y, row) in rows.enumerated() { for (x, ch) in row.enumerated() where ch != "." { cs.append(Cell(x: x, y: y, ch: ch)) } }
		return cs
	}
	return PixArt(w: w, h: h, frames: fs, frameDur: frameDur)
}
/// a canvas for the geometric ones (circles and lines read better drawn than typed)
struct Canvas {
	let w: Int, h: Int
	var g: [[Character]]
	init(_ w: Int, _ h: Int) { self.w = w; self.h = h; g = Array(repeating: Array(repeating: ".", count: w), count: h) }
	mutating func set(_ x: Int, _ y: Int, _ c: Character) { if x >= 0 && y >= 0 && x < w && y < h { g[y][x] = c } }
	mutating func line(_ x0: Int, _ y0: Int, _ x1: Int, _ y1: Int, _ c: Character) {
		var x = x0, y = y0
		let dx = abs(x1 - x0), dy = -abs(y1 - y0), sx = x0 < x1 ? 1 : -1, sy = y0 < y1 ? 1 : -1
		var err = dx + dy
		while true {
			set(x, y, c)
			if x == x1 && y == y1 { break }
			let e2 = 2 * err
			if e2 >= dy { err += dy; x += sx }
			if e2 <= dx { err += dx; y += sy }
		}
	}
	mutating func ring(_ cx: Int, _ cy: Int, _ r: Double, _ c: Character) {
		for y in 0..<h { for x in 0..<w {
			let d = (Double((x - cx) * (x - cx) + (y - cy) * (y - cy))).squareRoot()
			if abs(d - r) < 0.55 { set(x, y, c) }
		} }
	}
	var rows: [String] { g.map { String($0) } }
}

// ---------------------------------------------------------------- the seven that matter
let ART_HANDS = art([[
	"...WWW............",
	"...WWW............",
	"...WWW............",
	"....W.............",
	"..WWWWW...........",
	".WWWWWWW..........",
	".W.WWW.W....PPP...",
	".W.WWW..W...PPP...",
	".W.WWW..W...PPP...",
	"...WWW...YY..P....",
	"..WWWWW....PPPPP..",
	"..WW.WW.....PPP...",
	"..WW.WW.....PPP...",
	"..WW.WW.....P.P...",
	"..WW.WW.....P.P...",
	"..WW.WW.....P.P...",
]])
let ART_BIKE: PixArt = {
	var c = Canvas(20, 13)
	c.ring(4, 9, 3.2, "W"); c.ring(15, 9, 3.2, "W")
	c.set(4, 9, "C"); c.set(15, 9, "C")
	let A = (4, 9), B = (9, 9), S = (8, 5), H = (13, 5), F = (15, 9)
	c.line(A.0, A.1, B.0, B.1, "R"); c.line(A.0, A.1, S.0, S.1, "R"); c.line(B.0, B.1, S.0, S.1, "R")
	c.line(S.0, S.1, H.0, H.1, "R"); c.line(B.0, B.1, H.0, H.1, "R"); c.line(H.0, H.1, F.0, F.1, "R")
	c.line(7, 4, 9, 4, "Y")                                   // saddle
	c.set(13, 4, "R"); c.line(12, 3, 14, 3, "W")             // stem and bars
	return art([c.rows])
}()
let ART_HOUSE = art([[
	"..............S...",
	".............S....",
	"..............S...",
	"............BB....",
	"........RR..BB....",
	".......RRRR.BB....",
	"......RRRRRRBB....",
	".....RRRRRRRR.....",
	"....RRRRRRRRRR....",
	"...RRRRRRRRRRRR...",
	"..RRRRRRRRRRRRRR..",
	"...HHHHHHHHHHHH...",
	"...HHLLLHHHHHHH...",
	"...HHLLLHHBBHHH...",
	"...HHLLLHHBBHHH...",
	"...HHHHHHHBBHHH...",
	"..DDDDDDDDDDDDDD..",
], [
	".............S....",
	"..............S...",
	".............S....",
	"............BB....",
	"........RR..BB....",
	".......RRRR.BB....",
	"......RRRRRRBB....",
	".....RRRRRRRR.....",
	"....RRRRRRRRRR....",
	"...RRRRRRRRRRRR...",
	"..RRRRRRRRRRRRRR..",
	"...HHHHHHHHHHHH...",
	"...HHLLLHHHHHHH...",
	"...HHLLLHHBBHHH...",
	"...HHLLLHHBBHHH...",
	"...HHHHHHHBBHHH...",
	"..DDDDDDDDDDDDDD..",
]], frameDur: 0.42)
let ART_SUNSET = art([[
	"..............W.W...",
	"...PPPP........W....",
	"........YYYY........",
	"......YYYYYYYY......",
	".....YYYYYYYYYY.....",
	"....OOOOOOOOOOOO....",
	"....OOOOOOOOOOOO....",
	"RRRRRRRRRRRRRRRRRRRR",
	"..DDDD..OOOO..DDDD..",
	"DDD......OO......DDD",
	"....DDD.YY.Y.DDD....",
	".DD......YY.....DD..",
	".........Y..........",
], [
	"..............W.W...",
	"...PPPP........W....",
	"........YYYY........",
	"......YYYYYYYY......",
	".....YYYYYYYYYY.....",
	"....OOOOOOOOOOOO....",
	"....OOOOOOOOOOOO....",
	"RRRRRRRRRRRRRRRRRRRR",
	"...DDDD.OOOO.DDDD...",
	"DD.......OO.......DD",
	"...DDD..Y.YY..DDD...",
	"..DD.....YY......DD.",
	"..........Y.........",
]], frameDur: 0.36)
let ART_CAKE = art([[
	"....F..F...F..F...",
	"....Y..Y...Y..Y...",
	"....W..W...W..W...",
	"....P..P...P..P...",
	"....W..W...W..W...",
	"..CCCCCCCCCCCCCCC.",
	"..CTCCTCCTCCTCCTC.",
	"..TTTTTTTTTTTTTTT.",
	"..RRRRRRRRRRRRRRR.",
	"..TTTTTTTTTTTTTTT.",
	"..TTTTTTTTTTTTTTT.",
	".DDDDDDDDDDDDDDDDD",
]])
let ART_DOG = art([[
	"..................",
	".............TTT..",
	"............BTDTT.",
	"............BTTTTT",
	"............BTTTTD",
	"..T.........TTT.P.",
	"...T.TTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TT.....TT.....",
	"....TT.....TT.....",
	"....BB.....BB.....",
], [
	"..................",
	".............TTT..",
	"............BTDTT.",
	"............BTTTTT",
	"............BTTTTD",
	"............TTT.P.",
	"..TT.TTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TTTTTTTTTTT...",
	"....TT.....TT.....",
	"....TT.....TT.....",
	"....BB.....BB.....",
]], frameDur: 0.17)
let ART_KITE: PixArt = {
	func frame(_ tail: [(Int, Int)]) -> [String] {
		var c = Canvas(16, 18)
		let cx = 9, cy = 6
		for y in 0..<13 { for x in 0..<16 {
			let u = Double(abs(x - cx)) / 5.4 + Double(abs(y - cy)) / 6.4
			if u <= 1 { c.set(x, y, y < cy ? (x < cx ? "R" : "Y") : (x < cx ? "O" : "P")) }
		} }
		c.line(cx, 0, cx, 12, "C"); c.line(4, cy, 14, cy, "C")
		for (x, y) in tail { c.set(x, y, "W") }
		c.set(tail[1].0 - 1, tail[1].1, "Y"); c.set(tail[1].0 + 1, tail[1].1, "Y")
		c.set(tail[3].0 - 1, tail[3].1, "P"); c.set(tail[3].0 + 1, tail[3].1, "P")
		c.line(5, 9, 0, 17, "D")                                  // the string, down to someone holding it
		return c.rows
	}
	return art([frame([(9, 13), (8, 14), (8, 15), (9, 16), (10, 17)]), frame([(9, 13), (10, 14), (10, 15), (9, 16), (8, 17)])], frameDur: 0.3)
}()

// ---------------------------------------------------------------- everyday moments (they fade and stay faded)
let SMALL_ARTS: [PixArt] = [
	art([[".RR.RR.", "RRRRRRR", "RRRRRRR", ".RRRRR.", "..RRR..", "...R..."]]),                               // heart
	art([["...Y...", "..YYY..", "YYYYYYY", ".YYYYY.", "..YYY..", ".YY.YY.", ".Y...Y."]]),                     // star
	art([["..CCC..", ".CC....", "CC.....", "CC.....", "CC.....", ".CC....", "..CCC.."]]),                     // moon
	art([["...W...", "...WW..", "...W.W.", "...W..W", "...W...", ".WWW...", "WWWW...", ".WW...."]]),          // a song
	art([["..P.P..", ".PPPPP.", "PPPYPPP", ".PPPPP.", "..P.P..", "...G...", ".G.G...", "..GG..."]]),          // flower
	art([["..W.W..", ".W.W...", ".......", "OOOOO..", "OOOOOOO", "OOOOO.O", "OOOOOO.", ".OOO..."]]),          // a cup
	art([["...R...", ".RRRRR.", "RRRRRRR", "R.R.R.R", "...W...", "...W...", ".W.W...", "..W...."]]),          // umbrella
	art([["..OOO..", ".OWWYO.", "OWWYYYO", "OOYYYWO", "OYYYWWO", ".OYWWO.", "..OOO.."]]),                     // ball
	art([["..OOO.O", ".OOOOOO", "OWOOOO.", ".OOOOOO", "..OOO.O"]]),                                           // fish
	art([["CCCCCCC", "CC...CC", "C.C.C.C", "C..C..C", "C.....C", "CCCCCCC"]]),                                // a letter
	art([["..PPP..", ".PPPPP.", ".PPPPP.", ".TTTTT.", "..TTT..", "..TTT..", "...T..."]]),                     // ice cream
	art([["Y..Y..Y", ".Y.Y.Y.", "..YYY..", "YYYYYYY", "..YYY..", ".Y.Y.Y.", "Y..Y..Y"]]),                     // sun
	art([[".YY.YY.", "..YYY..", "RRRYRRR", "RRRYRRR", "YYYYYYY", "RRRYRRR", "RRRYRRR"]]),                     // a gift
	art([["PP...PP", "PPP.PPP", "PPPWPPP", ".PPWPP.", "PPPWPPP", "PP.W.PP"]]),                                // butterfly
	art([[".YYYYY.", "YYYYYYY", "YY.Y.YY", "YYYYYYY", "Y.YYY.Y", "YY...YY", ".YYYYY."]]),                     // a smile
	art([["..GGG..", ".GGGGG.", "GGGGGGG", "GGGGGGG", ".GGGGG.", "...B...", "...B..."]]),                     // tree
	art([["T.....T", "TT...TT", "TTTTTTT", "T.TTT.T", "TTTTTTT", "TTTPTTT", ".TTTTT."]]),                     // cat
]

let ART_HOUSE2 = art([[
	"........RR........",
	".......RRRR...BB..",
	"......RRRRRR..BB..",
	".....RRRRRRRR.BB..",
	"....RRRRRRRRRRBB..",
	"...RRRRRRRRRRRR...",
	"..RRRRRRRRRRRRRR..",
	"...HHHHHHHHHHHH...",
	"...HLLHHHHHHLLH...",
	"...HLLHHHHHHLLH...",
	"...HHHHHHHHHHHH...",
	"...HLLHHBBHHLLH...",
	"...HLLHHBBHHLLH...",
	"...HHHHHBBHHHHH...",
	"..DDDDDDDDDDDDDD..",
]])
let ART_BEACH = art([[
	"..........YYY.....",
	".........YYYYY....",
	"..W......YYYYY....",
	".WRW......YYY.....",
	"WRRRW.............",
	"..T...............",
	"..T...............",
	"DDDDDDDDDDDDDDDDDD",
	"SSSSDDDDSSSSDDDDSS",
	"TTTTTTTTTTTTTTTTTT",
]])
