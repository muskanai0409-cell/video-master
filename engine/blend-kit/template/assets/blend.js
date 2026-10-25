// blend.js: the one-take blend moves (references/one-take-blend.md) as pure functions of t.
// Studied from the Mem0 Claude Code explainer (Oct 2026): one object carries the film, nothing fades to nothing,
// the picture starts a breath before its word. Every function returns numbers or CSS strings for the frame at t;
// nothing keeps state between frames, so any frame renders on its own (HyperFrames seeks).
(function () {
  const clamp = (x, a, z) => (x < a ? a : x > z ? z : x);
  const lerp = (a, z, p) => a + (z - a) * p;
  const bez = (x1, y1, x2, y2) => (p) => {
    if (p <= 0) return 0; if (p >= 1) return 1;
    let lo = 0, hi = 1, s = p;
    for (let i = 0; i < 22; i++) { s = (lo + hi) / 2; const x = 3 * (1 - s) * (1 - s) * s * x1 + 3 * (1 - s) * s * s * x2 + s * s * s; if (x < p) lo = s; else hi = s; }
    return 3 * (1 - s) * (1 - s) * s * y1 + 3 * (1 - s) * s * s * y2 + s * s * s;
  };
  // one curve family: long soft settles, no bounce (the springs rule in SKILL.md)
  const OUT = bez(0.16, 1, 0.3, 1), INOUT = bez(0.7, 0, 0.2, 1), IN = bez(0.6, 0, 0.9, 0.4), SOFT = bez(0.45, 0, 0.35, 1), LIN = (x) => x;
  const ramp = (t, t0, t1, fn = SOFT) => fn(clamp((t - t0) / (t1 - t0), 0, 1));
  const win = (t, a, b, c, d) => ramp(t, a, b) * (1 - ramp(t, c, d));
  const R = (seed) => { let s = seed >>> 0; return () => { s = (s + 0x6D2B79F5) >>> 0; let x = Math.imul(s ^ (s >>> 15), 1 | s);
    x = (x + Math.imul(x ^ (x >>> 7), 61 | x)) ^ x; return ((x ^ (x >>> 14)) >>> 0) / 4294967296; }; };
  const blur = (px) => (px > 0.02 ? `blur(${px.toFixed(2)}px)` : "none");

  // 1. hinge-up: an element stands up out of the ground line (transform-origin: 50% 100%), 0.6s
  function hinge(p) {
    const q = OUT(clamp(p, 0, 1));
    return { transform: `perspective(1400px) translateY(${lerp(50, 0, q).toFixed(2)}px) rotateX(${lerp(84, 0, q).toFixed(3)}deg) scale(${lerp(0.9, 1, q).toFixed(4)})`,
             opacity: clamp(p * 5, 0, 1) };
  }
  // 3. rack focus, the outgoing layer: it goes soft and dim and stays as depth (k 0..1)
  function defocus(k, maxBlur = 12, dim = 0.55) { return { filter: blur(maxBlur * k), opacity: 1 - dim * k }; }
  // 3. words in from blur, one by one (start 0.3s before the spoken line)
  function wordIn(t, t0, i, stagger = 0.1, dur = 0.45) {
    const p = ramp(t, t0 + i * stagger, t0 + i * stagger + dur, OUT);
    return { filter: blur(8 * (1 - p)), opacity: p, transform: p >= 1 ? "none" : `translateY(${(6 * (1 - p)).toFixed(2)}px)` };
  }
  // 4. mask wipe-out, right to left (clip-path for the outgoing line)
  const wipeOut = (p) => `inset(-20% ${(100 * INOUT(clamp(p, 0, 1))).toFixed(2)}% -20% -20%)`;
  // directional motion blur: one SVG <feGaussianBlur> per moving element, stdDeviation from speed (px/s)
  function mblur(node, speed, k = 0.012) { const s = Math.min(40, Math.abs(speed) * k); node.setAttribute("stdDeviation", `${s.toFixed(2)} 0`); return s > 0.05; }
  // speed of any position function at t (px/s), for mblur
  const speedOf = (f, t) => (f(t + 1 / 240) - f(t - 1 / 240)) * 120;
  // 5. wash birth: an element arrives as a solid wash of the actor's colour, then the colour cools into the real UI
  function washBirth(t, t0, { slide = 0.45, cool = 0.6 } = {}) {
    const c0 = t0 + slide * 0.6;
    return { arrive: ramp(t, t0, t0 + slide, OUT), wash: t < t0 ? 0 : 1 - ramp(t, c0, c0 + cool, SOFT), content: ramp(t, c0 + cool * 0.5, c0 + cool, SOFT) };
  }
  // shared-element morph between two rects {x, y, w, h, r}
  function morphRect(a, b, p) { const q = INOUT(clamp(p, 0, 1)); return { x: lerp(a.x, b.x, q), y: lerp(a.y, b.y, q), w: lerp(a.w, b.w, q), h: lerp(a.h, b.h, q), r: lerp(a.r, b.r, q) }; }
  const place = (el, r) => { el.style.left = r.x.toFixed(2) + "px"; el.style.top = r.y.toFixed(2) + "px"; el.style.width = r.w.toFixed(2) + "px"; el.style.height = r.h.toFixed(2) + "px"; el.style.borderRadius = r.r.toFixed(2) + "px"; };
  // 9-10. band to bar: a band centred on (cx, cy); k < 0 pinches the middle (an eye opening), k = 0 is a bar; r rounds the corners
  function bandPath(cx, cy, w, h, k, r = 0) {
    const x0 = cx - w / 2, x1 = cx + w / 2, y0 = cy - h / 2, y1 = cy + h / 2; r = Math.min(r, w / 2, h / 2);
    return new Path2D(`M${x0 + r},${y0} Q${cx},${y0 - k} ${x1 - r},${y0} Q${x1},${y0} ${x1},${y0 + r} L${x1},${y1 - r} Q${x1},${y1} ${x1 - r},${y1}`
      + ` Q${cx},${y1 + k} ${x0 + r},${y1} Q${x0},${y1} ${x0},${y1 - r} L${x0},${y0 + r} Q${x0},${y0} ${x0 + r},${y0} Z`);
  }
  // 12. absorption: a card collapses to a pill, then a dot, then flies into the container on a rising curve
  function absorb(t, t0, from, to, { collapse = 0.3, shrink = 0.15, fly = 0.42, lift = 120 } = {}) {
    const a = ramp(t, t0, t0 + collapse, INOUT), b = ramp(t, t0 + collapse, t0 + collapse + shrink, INOUT);
    const f0 = t0 + collapse + shrink, f = ramp(t, f0, f0 + fly, INOUT);
    const w = b > 0 ? lerp(56, 10, b) : lerp(from.w, 56, a), h = b > 0 ? lerp(18, 10, b) : lerp(from.h, 18, a);
    const pos = (q) => { const cx = lerp(from.x, to.x, 0.5), cy = Math.min(from.y, to.y) - lift;
      return [(1 - q) * (1 - q) * from.x + 2 * (1 - q) * q * cx + q * q * to.x, (1 - q) * (1 - q) * from.y + 2 * (1 - q) * q * cy + q * q * to.y]; };
    const [x, y] = pos(f);
    // the trail: where the dot was a moment ago
    const trail = [1, 2, 3, 4, 5].map((k) => { const q = ramp(t - k * 0.028, f0, f0 + fly, INOUT); return pos(q); });
    return { x, y, w, h, r: b > 0 ? lerp(9, 5, b) : lerp(from.r ?? 10, 9, a), fill: a, label: 1 - ramp(t, t0, t0 + 0.15, LIN),
             flying: f > 0 && f < 1, arrived: f >= 1, arriveAt: f0 + fly, trail };
  }
  // 15. count-up (tabular figures in CSS)
  const count = (from, to, p, dec = 1) => (from + (to - from) * OUT(clamp(p, 0, 1))).toFixed(dec);
  // 18. highlight hop: one fill moves between card rects at the given times (each phrase's first word)
  function hop(t, times, rects, dur = 0.3) {
    let i = -1; for (let k = 0; k < times.length; k++) if (t >= times[k]) i = k;
    if (i < 0) return null;
    const p = i > 0 ? ramp(t, times[i], times[i] + dur, INOUT) : ramp(t, times[0], times[0] + dur, OUT);
    return { ...(i > 0 ? morphRect(rects[i - 1], rects[i], p) : rects[0]), i, p };
  }
  // 19. stepped reveal (letters), and one shimmer pass: the position of a 300%-wide mask or background band,
  //     sweeping left to right as p goes 0 to 1 (put it on a white copy of the line, masked to the band)
  const steps = (t, t0, n, per = 0.065) => clamp(Math.floor((t - t0) / per) + 1, 0, n);
  const shimmer = (p) => `${(100 - 100 * SOFT(clamp(p, 0, 1))).toFixed(2)}% 0`;
  // the official lockup's letter edges (assets/brand/lockup.svg, % of width): mark, then s u p e r m e m o r y
  const LOCKUP_STEPS = [0, 17.6, 26.45, 33.6, 41.35, 48.5, 53.15, 63.4, 70.7, 81.0, 88.7, 93.35, 100];
  // word timings from vo-times.js: line.words = [[word, start, end], ...] (tools/vo_eleven.py); picture leads by 0.2 to 0.4s
  function WORD(line, w, n = 0) { const hits = (line.words || []).filter((x) => x[0].toLowerCase().replace(/[^a-z0-9']/g, "") === w.toLowerCase());
    if (!hits[n]) throw new Error(`no word "${w}" in ${line.id}`); return hits[n][1]; }

  window.BLEND = { clamp, lerp, bez, OUT, INOUT, IN, SOFT, LIN, ramp, win, R, blur, hinge, defocus, wordIn, wipeOut, mblur, speedOf,
                   washBirth, morphRect, place, bandPath, absorb, count, hop, steps, shimmer, LOCKUP_STEPS, WORD };
})();
