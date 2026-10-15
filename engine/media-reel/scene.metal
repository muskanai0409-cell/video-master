// scene.metal: one sunlit gallery room, rendered in several media from the same geometry and light.
// The supermemory mark stands on a plinth as a plaster sculpture (extruded from its exact vector field, texture 1);
// a low sun comes through a mullioned window on the right (the window is analytic: a gobo, not geometry), a cool
// sky fill lives in the shadows, the polished floor reflects, a little haze catches the beam, and a wall label
// (texture 2) hangs to the right of the plinth.
// Media (u.lens.w):
//   0 light      photographic: soft shadows, AO, bounce, floor reflection, beam haze, filmic curve, grain
//   1 engraving  variable-width hatching that follows each surface, line weight carries the tone
//   3 survey     a contour drawing: the sculpture sliced in height, the room in rings of distance from it
//   4 riso       a two-drum risograph print: blue and fluorescent pink halftones, misregistered
// Kernel `cells` renders the ASCII medium's per-cell data (tone, colour, edges) for the driver to set in type.
#include <metal_stdlib>
using namespace metal;

struct U {
	float4 ro;     // camera position; w = focal length (image-plane distance, in units of frame height)
	float4 ta;     // camera target; w = roll (radians)
	float4 lens;   // x aperture radius, y focus distance, z samples per side, w medium
	float4 misc;   // x time, y grain seed, z cell width (px), w cell height (px)
	float4 look;   // x sun progress 0..1, y exposure, z riso seed, w riso misregistration (px)
	float4 pc;     // the projector: the final camera's position; w = its focal length
	float4 pfw;    // its forward axis; w = slide width (px)
	float4 prt;    // its right axis; w = slide height (px)
	float4 pup;    // its up axis
	float4 rev;    // the paint going on: x wordmark progress 0..1, y line progress, z/w wordmark left/right (slide px)
	float2 res;
	float2 pad;
};

constexpr sampler lin(filter::linear, address::clamp_to_edge);
constant float RF = 0.75;                                   // the mark field spans [-RF, RF] in mark units
constant float S = 1.30;                                    // mark height (m)
constant float HT = 0.115;                                  // half thickness of the extrusion
constant float PT = 0.40;                                   // plinth top
constant float3 MC = float3(0.0, PT + 0.5 * S - 0.003, 0.0);
constant float MROT = 0.34;                                 // the sculpture turns to face front-left
constant float BACKZ = -2.0, LEFTX = -3.4, RIGHTX = 4.0, CEILY = 3.6;
constant float WX = 4.0;                                    // window plane
constant float2 WC = float2(2.05, 2.80), WH = float2(2.55, 0.70);   // a clerestory band: centre (z, y), half size

// ------------------------------------------------------------------------------------------------ utilities
float hash12(float2 p) { float3 p3 = fract(float3(p.xyx) * 0.1031); p3 += dot(p3, p3.yzx + 33.33); return fract((p3.x + p3.y) * p3.z); }
float hash13(float3 p3) { p3 = fract(p3 * 0.1031); p3 += dot(p3, p3.zyx + 31.32); return fract((p3.x + p3.y) * p3.z); }
float vnoise(float2 p) {
	float2 i = floor(p), f = fract(p); f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash12(i), hash12(i + float2(1, 0)), f.x), mix(hash12(i + float2(0, 1)), hash12(i + float2(1, 1)), f.x), f.y);
}
float fbm(float2 p) { float s = 0.0, a = 0.5; for (int i = 0; i < 5; i++) { s += a * vnoise(p); p = p * 2.03 + 17.1; a *= 0.5; } return s; }
float3 rotY(float3 p, float a) { float c = cos(a), s = sin(a); return float3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z); }
float sdBox(float3 p, float3 b, float r) { float3 q = abs(p) - b + r; return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0) - r; }
float luma(float3 c) { return dot(c, float3(0.2126, 0.7152, 0.0722)); }

// ------------------------------------------------------------------------------------------------ geometry
float mark2D(float2 q, texture2d<float> fld) {
	float2 uv = float2(0.5 + q.x / (2.0 * RF), 0.5 - q.y / (2.0 * RF));
	float2 c = clamp(uv, 0.0, 1.0);
	return fld.sample(lin, c).r + length(uv - c) * 2.0 * RF;
}
float3 toMark(float3 p) { return rotY(p - MC, MROT); }
float sdMark(float3 p, texture2d<float> fld) {
	float3 q = toMark(p);
	float bound = sdBox(q, float3(0.83, 0.69, HT + 0.02), 0.0);
	if (bound > 0.08) return bound;
	float d2 = mark2D(q.xy / S, fld) * S;
	const float rr = 0.010;
	float2 w = float2(d2 + rr, abs(q.z) - HT + rr);
	return min(max(w.x, w.y), 0.0) + length(max(w, 0.0)) - rr;
}
float sdPlinth(float3 p) { return sdBox(p - float3(0.0, PT * 0.5, 0.0), float3(0.95, PT * 0.5, 0.42), 0.006); }

// ids: 1 mark, 2 plinth, 3 floor, 4 back wall (with the vinyl lettering), 5 left wall, 7 right wall, 8 ceiling
float2 world(float3 p, texture2d<float> fld) {
	float2 r = float2(p.y, 3.0);
	float d = p.z - BACKZ;   if (d < r.x) r = float2(d, 4.0);
	d = p.x - LEFTX;         if (d < r.x) r = float2(d, 5.0);
	d = RIGHTX - p.x;        if (d < r.x) r = float2(d, 7.0);
	d = CEILY - p.y;         if (d < r.x) r = float2(d, 8.0);
	d = sdPlinth(p);         if (d < r.x) r = float2(d, 2.0);
	d = sdMark(p, fld);      if (d < r.x) r = float2(d, 1.0);
	return r;
}
// what can shade the sun beam inside the room (the window itself is the gobo)
float occluders(float3 p, texture2d<float> fld) { return min(sdMark(p, fld), sdPlinth(p)); }
float2 paintAt(float3 p, float3 n, float pw, constant U& u, texture2d<float> slide, texture2d<float> fld);

float3 normalAt(float3 p, texture2d<float> fld) {
	const float2 e = float2(1.2e-3, 0.0);
	return normalize(float3(world(p + e.xyy, fld).x - world(p - e.xyy, fld).x,
	                        world(p + e.yxy, fld).x - world(p - e.yxy, fld).x,
	                        world(p + e.yyx, fld).x - world(p - e.yyx, fld).x));
}

struct Hit { float3 p; float3 n; float t; float id; };
Hit trace(float3 ro, float3 rd, texture2d<float> fld, float tmax) {
	float t = 0.0; float2 h = float2(1.0, 0.0);
	for (int i = 0; i < 240; i++) {
		h = world(ro + rd * t, fld);
		if (h.x < 1.2e-4 * (1.0 + t) || t > tmax) break;
		t += h.x * 0.92;
	}
	Hit r; r.t = t; r.p = ro + rd * t; r.id = t > tmax ? 0.0 : h.y; r.n = normalAt(r.p, fld);
	return r;
}

// ------------------------------------------------------------------------------------------------ light
float3 sunDir(float k) { return normalize(float3(0.66 + 0.04 * k, 0.40 - 0.03 * k, 0.66 - 0.40 * k)); }

// the mullioned window, projected along the sun onto p; penumbra grows with distance from the glass
float gobo(float3 p, float3 sun) {
	float s = (WX - p.x) / max(sun.x, 1e-3);
	float2 uv = float2(p.z + sun.z * s, p.y + sun.y * s);
	float soft = 0.006 + 0.0075 * s;
	float2 d = abs(uv - WC) - WH;
	float inside = 1.0 - smoothstep(-soft, soft, max(d.x, d.y));
	float2 g = (uv - WC + WH) / (2.0 * WH) * float2(3.0, 2.0);
	float2 f = min(fract(g), 1.0 - fract(g)) * (2.0 * WH) / float2(3.0, 2.0);   // metres to the nearest mullion
	float mull = smoothstep(0.028 - soft, 0.028 + soft, f.x) * smoothstep(0.034 - soft, 0.034 + soft, f.y);
	return inside * mull;
}
float softShadow(float3 ro, float3 rd, texture2d<float> fld, float k) {
	float res = 1.0, t = 0.012;
	for (int i = 0; i < 56 && t < 6.0; i++) {
		float h = occluders(ro + rd * t, fld);
		res = min(res, k * h / t);
		if (res < 1e-3) return 0.0;
		t += clamp(h, 0.008, 0.25);
	}
	return clamp(res, 0.0, 1.0);
}
float occlusion(float3 p, float3 n, texture2d<float> fld) {
	float o = 0.0, sc = 1.0;
	for (int i = 1; i <= 5; i++) { float h = 0.015 + 0.09 * float(i); o += (h - world(p + n * h, fld).x) * sc; sc *= 0.72; }
	return clamp(1.0 - 1.6 * o, 0.0, 1.0);
}

constexpr sampler mipLin(filter::linear, mip_filter::linear, address::clamp_to_zero);
// Anamorphic paint (after Felice Varini): the wordmark is painted on whatever surfaces lie behind it as seen from
// one point, the final camera. From there it lines up with the sculpture into the official lockup; from anywhere
// else it breaks into slanted pieces across wall, floor and plinth. Returns (blue paint, ink) coverage.
float occluders(float3 p, texture2d<float> fld);
float2 paintAt(float3 p, float3 n, float pw, constant U& u, texture2d<float> slide, texture2d<float> fld) {
	float3 v = p - u.pc.xyz;
	float z = dot(v, u.pfw.xyz);
	if (z <= 0.05) return 0.0;
	float2 uv = float2(dot(v, u.prt.xyz), dot(v, u.pup.xyz)) / z * u.pc.w;
	float2 st = float2(uv.x * u.prt.w / u.pfw.w + 0.5, 0.5 - uv.y);
	if (any(st < 0.0) || any(st > 1.0)) return 0.0;
	float dv = length(v);
	float texel = z / (u.pc.w * u.prt.w) / max(abs(dot(n, v / dv)), 0.12);
	float lod = max(0.0, log2(max(pw, 1e-6) / texel));
	float2 cov = slide.sample(mipLin, st, level(lod)).rg;
	// painted on from left to right with a brushed, uneven edge
	float sx = st.x * u.pfw.w, sy = st.y * u.prt.w;
	float edge = mix(u.rev.z - 40.0, u.rev.w + 40.0, u.rev.x) + (vnoise(float2(sy * 0.08, 3.0)) - 0.5) * 36.0 + (vnoise(float2(sy * 0.6, 9.0)) - 0.5) * 10.0;
	cov.x *= clamp((edge - sx) / 18.0, 0.0, 1.0);
	cov.y *= u.rev.y;
	if (cov.x + cov.y < 0.003) return 0.0;
	// only what the projector can see gets paint
	float3 dir = -v / dv;
	float t = 0.004;
	for (int i = 0; i < 48 && t < dv; i++) { float h = occluders(p + n * 0.002 + dir * t, fld); if (h < 0.0015) return 0.0; t += max(h, 0.01); }
	return cov;
}
constant float3 PIGMENT = float3(0.0045, 0.0085, 0.64);                              // brand-blue pigment (linear)
float3 albedoOf(float id, float3 p, float3 n, texture2d<float> plac, float pw) {
	if (id == 1.0) return PIGMENT * (0.97 + 0.06 * vnoise(p.xy * 70.0 + p.z * 40.0));
	if (id == 2.0) return float3(0.925, 0.92, 0.905);
	if (id == 3.0) {
		float m = fbm(p.xz * 1.6) * 0.6 + fbm(p.xz * 9.0) * 0.4;
		return float3(0.47, 0.455, 0.44) * (0.86 + 0.24 * m);
	}
	return float3(0.87, 0.86, 0.835) * (0.985 + 0.03 * vnoise(p.xy * 6.0 + p.z * 3.0));   // walls, ceiling
}

struct Lit { float3 col; float sun; float tone; float3 alb; float2 paint; };
// direct + fill lighting at a surface point (no reflections)
Lit lightAt(float3 p, float3 n, float id, float3 rd, float sunK, texture2d<float> fld, texture2d<float> plac, float pw, constant U& u, bool neutral = false) {
	float3 sun = sunDir(sunK);
	float3 alb = albedoOf(id, p, n, plac, pw);
	if (neutral && id == 1.0) alb = float3(0.80);
	float2 paint = (id == 1.0 || id == 0.0) ? float2(0.0) : paintAt(p, n, pw, u, plac, fld);
	alb = mix(alb, PIGMENT, paint.x);
	alb = mix(alb, float3(0.0036, 0.0048, 0.0075), paint.y);                          // ink #0b1015
	if (id == 7.0) {
		// the window itself, seen from inside: bright sky through the panes, dark mullions
		float2 uv = float2(p.z, p.y);
		float2 d = abs(uv - WC) - WH;
		if (max(d.x, d.y) < 0.0) {
			float2 f = min(fract((uv - WC + WH) / (2.0 * WH) * float2(3.0, 2.0)), 1.0 - fract((uv - WC + WH) / (2.0 * WH) * float2(3.0, 2.0))) * (2.0 * WH) / float2(3.0, 2.0);
			float glass = step(0.028, f.x) * step(0.034, f.y);
			Lit W; W.col = mix(float3(0.12, 0.12, 0.13), float3(5.5, 5.6, 6.0), glass); W.sun = 0.0; W.alb = alb; W.paint = paint; W.tone = 1.0;
			return W;
		}
	}
	float g = (id == 7.0 || id == 8.0) ? 0.0 : gobo(p, sun);
	float ndl = max(dot(n, sun), 0.0);
	float sh = (g > 0.0 && ndl > 0.0) ? softShadow(p + n * 2e-3, sun, fld, 26.0) : 0.0;
	float occ = occlusion(p, n, fld);
	float3 sunCol = float3(1.0, 0.865, 0.70) * 3.1;
	float3 skyDir = normalize(float3(0.85, 0.45, 0.35));
	float3 skyCol = float3(0.60, 0.65, 0.82) * 0.62;
	float sky = (0.55 + 0.45 * dot(n, skyDir)) * occ;
	float bounce = (0.35 * max(-n.y, 0.0) + 0.18 * max(n.z, 0.0) + 0.10) * occ;      // warm light off the sunlit floor
	float sunAmt = ndl * g * sh;
	float3 col = alb * (sunCol * sunAmt + skyCol * sky + float3(1.0, 0.82, 0.66) * 0.36 * bounce + float3(0.06, 0.055, 0.05) * occ);
	if (id == 2.0) { float3 hv = normalize(sun - rd); col += sunCol * 0.03 * pow(max(dot(n, hv), 0.0), 36.0) * g * sh; }
	if (id == 1.0) {                                                                 // dry pigment: a velvet rim, no gloss
		float rim = pow(1.0 - max(dot(n, -rd), 0.0), 3.0);
		col += float3(0.10, 0.16, 0.95) * rim * (0.10 + 0.5 * sunAmt) * occ;
	}
	Lit L; L.col = col; L.sun = sunAmt; L.alb = alb; L.paint = paint;
	L.tone = luma(col);
	return L;
}

// the beam: in-scattering along the view ray where the sun passes the window and is not blocked by the sculpture
float3 haze(float3 ro, float3 rd, float tHit, float sunK, float jitter, texture2d<float> fld, float u_haze) {
	float3 sun = sunDir(sunK);
	const int N = 30;
	float dt = min(tHit, 22.0) / float(N), acc = 0.0;
	for (int i = 0; i < N; i++) {
		float3 p = ro + rd * (dt * (float(i) + jitter));
		float g = gobo(p, sun);
		if (g <= 0.0) continue;
		float vis = 1.0, t = 0.02;
		for (int k = 0; k < 18 && t < 4.0; k++) { float h = occluders(p + sun * t, fld); if (h < 0.002) { vis = 0.0; break; } t += max(h, 0.04); }
		acc += g * vis;
	}
	float cosT = dot(rd, sun), gg = 0.45;
	float phase = (1.0 - gg * gg) / pow(1.0 + gg * gg - 2.0 * gg * cosT, 1.5) * 0.25;
	return float3(1.0, 0.86, 0.70) * acc * dt * u_haze * phase;
}

float3 aces(float3 x) { return clamp((x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14), 0.0, 1.0); }
float3 grade(float3 c, float expo) {
	c = aces(c * expo);
	c = pow(c, float3(1.0 / 2.2));
	float l = luma(c);
	c += (float3(-0.010, 0.000, 0.022)) * (1.0 - l) * (1.0 - l);                      // cool the shadows a touch
	c += float3(0.012, 0.004, -0.012) * l * l;                                          // warm the highlights
	return clamp(c, 0.0, 1.0);
}

// ------------------------------------------------------------------------------------------------ camera
struct Ray { float3 o; float3 d; };
Ray camRay(constant U& u, float2 pix, float2 lensSample) {
	float3 ro = u.ro.xyz, fw = normalize(u.ta.xyz - ro);
	float3 rt = normalize(cross(fw, float3(0, 1, 0))), up = cross(rt, fw);
	float cr = cos(u.ta.w), sr = sin(u.ta.w);
	float3 rt2 = rt * cr + up * sr, up2 = up * cr - rt * sr;
	float2 uv = (pix - 0.5 * u.res) / u.res.y; uv.y = -uv.y;
	float3 rd = normalize(fw * u.ro.w + rt2 * uv.x + up2 * uv.y);
	Ray r; r.o = ro; r.d = rd;
	if (u.lens.x > 0.0) {
		float3 fp = ro + rd * (u.lens.y / dot(rd, fw));
		float a = lensSample.x * 6.2831853, rr = sqrt(lensSample.y) * u.lens.x;
		r.o = ro + (rt2 * cos(a) + up2 * sin(a)) * rr;
		r.d = normalize(fp - r.o);
	}
	return r;
}

// ------------------------------------------------------------------------------------------------ medium 0: light
float3 shadeLight(Ray r, float sunK, float jit, float pixAngle, texture2d<float> fld, texture2d<float> plac, constant U& u) {
	Hit h = trace(r.o, r.d, fld, 30.0);
	float pw = h.t * pixAngle / max(abs(dot(h.n, r.d)), 0.2);
	Lit L = lightAt(h.p, h.n, h.id, r.d, sunK, fld, plac, pw, u);
	float3 col = L.col;
	if (h.id == 3.0) {
		// polished concrete: a soft fresnel reflection of the room
		float cosi = max(dot(-r.d, h.n), 0.0);
		float F = 0.035 + 0.965 * pow(1.0 - cosi, 5.0);
		float3 rd2 = reflect(r.d, h.n);
		rd2 = normalize(rd2 + (float3(hash12(r.d.xy * 913.0 + jit), hash12(r.d.yx * 571.0 + jit), hash12(r.d.zx * 337.0)) - 0.5) * 0.006);
		Hit h2 = trace(h.p + h.n * 2e-3, rd2, fld, 16.0);
		Lit L2 = lightAt(h2.p, h2.n, h2.id, rd2, sunK, fld, plac, (h.t + h2.t) * pixAngle * 2.0, u);
		col = mix(col, min(L2.col, float3(2.2)), clamp(F * 1.2, 0.0, 0.30));
	}
	col += haze(r.o, r.d, h.t, sunK, jit, fld, u.rev.y > -1.0 ? 0.13 : 0.0);
	return col;
}

// ------------------------------------------------------------------------------------------------ medium 5: infinity mirrors
// After Yayoi Kusama's Infinity Mirror Rooms: the walls become mirrors close around the plinth, so the sculpture
// repeats without end. Real reflections, up to 12 bounces, each a little darker.
constant float MX = 1.40, MBACK = -1.6, MFRONT = 4.9;
float2 worldM(float3 p, texture2d<float> fld) {
	float2 r = float2(p.y, 3.0);
	float d = CEILY - p.y;   if (d < r.x) r = float2(d, 8.0);
	d = p.x + MX;            if (d < r.x) r = float2(d, 9.0);
	d = MX - p.x;            if (d < r.x) r = float2(d, 9.0);
	d = p.z - MBACK;         if (d < r.x) r = float2(d, 9.0);
	d = MFRONT - p.z;        if (d < r.x) r = float2(d, 9.0);
	d = sdPlinth(p);         if (d < r.x) r = float2(d, 2.0);
	d = sdMark(p, fld);      if (d < r.x) r = float2(d, 1.0);
	return r;
}
float3 shadeMirror(Ray r, float sunK, float pixAngle, texture2d<float> fld, texture2d<float> plac, constant U& u) {
	float3 ro = r.o, rd = r.d, att = float3(1.0);
	float travelled = 0.0;
	const float3 fogCol = float3(1.05, 1.04, 1.02);                                    // the far reflections melt into white
	for (int b = 0; b < 16; b++) {
		float t = 0.0; float2 h = float2(1.0, 0.0);
		for (int i = 0; i < 200; i++) { h = worldM(ro + rd * t, fld); if (h.x < 1.2e-4 * (1.0 + t) || t > 40.0) break; t += h.x * 0.92; }
		if (t > 40.0) break;
		float3 p = ro + rd * t;
		travelled += t;
		if (h.y == 9.0) {
			const float2 e = float2(1.2e-3, 0.0);
			float3 n = normalize(float3(worldM(p + e.xyy, fld).x - worldM(p - e.xyy, fld).x, worldM(p + e.yxy, fld).x - worldM(p - e.yxy, fld).x, worldM(p + e.yyx, fld).x - worldM(p - e.yyx, fld).x));
			att *= float3(0.93, 0.935, 0.94);                                            // silvered glass, a touch cool
			ro = p + n * 2e-3; rd = reflect(rd, n);
			continue;
		}
		float3 c;
		if (h.y == 8.0) c = float3(1.15, 1.14, 1.12);                                  // a light-box ceiling
		else { float3 n = normalAt(p, fld); c = lightAt(p, n, h.y, rd, sunK, fld, plac, travelled * pixAngle / max(abs(dot(n, rd)), 0.2), u).col; }
		float fog = 1.0 - exp(-max(travelled - 5.0, 0.0) * 0.032);
		return mix(c * att, fogCol, fog);
	}
	return fogCol;
}

// ------------------------------------------------------------------------------------------------ medium 1: engraving
// one family of parallel lines in coordinate u; dark = 0..1 is the ink share of each period
float lines(float u, float dark, float fwu) {
	float d = abs(fract(u) - 0.5);
	float w = 0.5 * clamp(dark, 0.0, 1.0);
	float c = clamp((w - d) / max(fwu, 1e-4) + 0.5, 0.0, 1.0) * min(1.0, 2.0 * w / max(fwu, 1e-4));   // a thin line cannot cover more than its width
	return mix(c, clamp(dark, 0.0, 1.0), smoothstep(0.25, 0.6, fwu));                  // fade to flat tone before it can alias
}
float engraveInk(Hit h, float tone, float pixWorld) {
	float3 p = h.p, n = h.n;
	float F = 56.0;                                                                    // lines per metre
	float u1, u2;
	if (h.id == 1.0) {
		float3 q = toMark(p), nq = rotY(n, MROT);
		if (abs(nq.z) > 0.6) { u1 = (q.x - q.y) * F * 1.15; u2 = (q.x + q.y) * F * 1.15; }
		else { u1 = q.z * F * 1.6; u2 = (q.x + q.y) * F; }
	} else if (h.id == 3.0) { u1 = p.x * F * 0.8; u2 = p.z * F * 0.8; }
	else if (h.id == 2.0) { if (n.y > 0.6) { u1 = p.x * F; u2 = p.z * F; } else { u1 = p.y * F; u2 = (p.x + p.z) * F; } }
	else if (h.id == 5.0) { u1 = p.y * F * 0.8; u2 = p.z * F * 0.8; }
	else { u1 = p.y * F * 0.8; u2 = p.x * F * 0.8; }
	float fwu = F * pixWorld * 1.3;
	float dark = 1.0 - tone;
	float c1 = lines(u1, clamp((dark - 0.06) / 0.62, 0.0, 1.0) * 0.72, fwu);
	float c2 = lines(u2, smoothstep(0.50, 0.95, dark) * 0.50, fwu);                   // cross-hatch only in shade
	float c3 = lines((u1 + u2) * 0.7071, smoothstep(0.75, 1.00, dark) * 0.45, fwu);
	return 1.0 - (1.0 - c1) * (1.0 - c2) * (1.0 - c3);
}

// distance (m) from a surface point to the nearest drawn edge of what it lies on
float edgeDist(Hit h, texture2d<float> fld) {
	float3 p = h.p, n = h.n;
	if (h.id == 1.0) {
		float3 q = toMark(p), nq = rotY(n, MROT);
		if (abs(nq.z) > 0.6) return max(-mark2D(q.xy / S, fld) * S, 0.0);
		return max(HT - abs(q.z), 0.0);
	}
	if (h.id == 2.0) {
		float3 b = abs(p - float3(0.0, PT * 0.5, 0.0)), e = float3(0.95, PT * 0.5, 0.42) - b;
		float3 an = abs(n);
		if (an.y > 0.6) return min(e.x, e.z);
		if (an.z > 0.6) return min(e.x, e.y);
		return min(e.y, e.z);
	}
	if (h.id == 3.0) return min(min(p.z - BACKZ, p.x - LEFTX), min(RIGHTX - p.x, sdPlinth(p) + 0.0));
	if (h.id == 4.0) return min(min(p.y, p.x - LEFTX), min(RIGHTX - p.x, CEILY - p.y));
	if (h.id == 5.0) return min(min(p.y, p.z - BACKZ), CEILY - p.y);
	if (h.id == 7.0) return min(min(p.y, p.z - BACKZ), CEILY - p.y);
	return min(min(p.z - BACKZ, p.x - LEFTX), RIGHTX - p.x);
}
float edgeInk(Hit h, float pw, float weight, texture2d<float> fld) {
	float d = edgeDist(h, fld);
	return clamp((weight * pw - d) / max(pw, 1e-5) + 0.5, 0.0, 1.0);
}

// ------------------------------------------------------------------------------------------------ medium 3: survey
float isoLine(float v, float spacing, float width, float fwv) {
	float d = abs(fract(v / spacing + 0.5) - 0.5) * spacing;
	return clamp((width * 0.5 - d) / max(fwv, 1e-5) + 0.5, 0.0, 1.0) * (1.0 - smoothstep(0.35, 0.9, fwv / spacing));
}

// ------------------------------------------------------------------------------------------------ the main kernel
kernel void render(texture2d<float, access::write> out [[texture(0)]],
                   texture2d<float> fld [[texture(1)]],
                   texture2d<float> plac [[texture(2)]],
                   constant U& u [[buffer(0)]],
                   uint2 gid [[thread_position_in_grid]]) {
	if (gid.x >= uint(u.res.x) || gid.y >= uint(u.res.y)) return;
	int medium = int(u.lens.w + 0.5);
	int n = max(1, int(u.lens.z + 0.5));
	float sunK = u.look.x;
	float3 col = 0.0;
	float pixAngle = 1.0 / (u.res.y * u.ro.w);
	for (int k = 0; k < n * n; k++) {
		float2 o = (float2(float(k % n), float(k / n)) + 0.5) / float(n) - 0.5;
		float2 pix = float2(gid) + 0.5 + o;
		float jit = hash12(pix * 1.31 + u.misc.x * 7.0);
		float2 ls = float2(hash12(pix + 0.37 * float(k) + u.misc.x), hash12(pix.yx * 1.7 + 0.11 * float(k)));
		Ray r = camRay(u, pix, ls);
		if (medium == 0) {
			col += shadeLight(r, sunK, jit, pixAngle, fld, plac, u);
		} else if (medium == 5) {
			col += shadeMirror(r, sunK, pixAngle, fld, plac, u);
		} else if (medium == 1) {
			Hit h = trace(r.o, r.d, fld, 30.0);
			float pw = h.t * pixAngle / max(abs(dot(h.n, r.d)), 0.25);
			Lit L = lightAt(h.p, h.n, h.id, r.d, sunK, fld, plac, pw, u, true);
			float tone = luma(grade(L.col, u.look.y));
			float ink = engraveInk(h, tone, pw);
			ink = max(ink, edgeInk(h, pw, h.id == 1.0 ? 1.9 : 1.3, fld));
			float3 paper = float3(0.953, 0.937, 0.898);
			float3 inkCol = (h.id == 1.0) ? float3(0.05, 0.06, 0.62) : float3(0.11, 0.105, 0.12);
			float3 cc = mix(paper, inkCol, ink);
			cc = mix(cc, float3(0.05, 0.06, 0.62), L.paint.x * 0.92);                      // the painted wordmark prints solid blue
			cc = mix(cc, float3(0.11, 0.105, 0.12), L.paint.y);
			col += cc;
		} else if (medium == 3) {
			Hit h = trace(r.o, r.d, fld, 30.0);
			float pw = h.t * pixAngle / max(abs(dot(h.n, r.d)), 0.2);
			Lit L = lightAt(h.p, h.n, h.id, r.d, sunK, fld, plac, pw, u, true);
			float tone = luma(grade(L.col, u.look.y));
			float3 paper = float3(0.957, 0.947, 0.918);
			float3 c = paper * (0.90 + 0.10 * tone);                                      // a faint hillshade wash
			float3 sienna = float3(0.66, 0.33, 0.17), blue = float3(0.06, 0.09, 0.78);
			if (h.id == 1.0 || h.id == 2.0) {
				float v = h.p.y;
				float fwv = pw * max(length(float2(h.n.x, h.n.z)), 0.15) + 1e-5;
				float minor = isoLine(v, 0.022, 0.0016, fwv), major = isoLine(v, 0.11, 0.0042, fwv);
				float3 ink = (h.id == 1.0) ? blue : sienna;
				c = mix(c, ink, max(minor * 0.75, major));
			} else {
				float dist = min(sdMark(h.p, fld), sdPlinth(h.p));
				float fwv = pw + 1e-5;
				float minor = isoLine(dist, 0.045, 0.0028, fwv), major = isoLine(dist, 0.225, 0.0065, fwv);
				c = mix(c, sienna, max(minor * 0.55, major * 0.95));
				c = mix(c, blue, L.paint.x * 0.85);
				c = mix(c, float3(0.043, 0.063, 0.082), L.paint.y);
			}
			col += c;
		} else if (medium == 9) {
			Hit h = trace(r.o, r.d, fld, 30.0);
			float pw = h.t * pixAngle / max(abs(dot(h.n, r.d)), 0.2);
			float2 pt = (h.id == 1.0 || h.id == 0.0) ? float2(0.0) : paintAt(h.p, h.n, pw, u, plac, fld);
			col += float3(pt.x, pt.y, 0.0);
		} else if (medium == 4) {
			// two plates, each sampled through its own misregistration, then screened at its own angle
			float3 paper = float3(0.965, 0.955, 0.93);
			float mis = u.look.w;
			float2 offA = (float2(hash12(float2(u.look.z, 1.0)), hash12(float2(u.look.z, 2.0))) - 0.5) * 2.0 * mis;
			float2 offB = (float2(hash12(float2(u.look.z, 3.0)), hash12(float2(u.look.z, 4.0))) - 0.5) * 2.0 * mis + float2(mis * 0.8, -mis * 0.5);
			Ray ra = camRay(u, pix + offA, ls), rb = camRay(u, pix + offB, ls);
			Hit ha = trace(ra.o, ra.d, fld, 30.0), hb = trace(rb.o, rb.d, fld, 30.0);
			Lit La = lightAt(ha.p, ha.n, ha.id, ra.d, sunK, fld, plac, ha.t * pixAngle * 2.0, u), Lb = lightAt(hb.p, hb.n, hb.id, rb.d, sunK, fld, plac, hb.t * pixAngle * 2.0, u);
			float toneA = luma(grade(La.col, u.look.y));
			float dBlue = pow(clamp(1.0 - toneA * 1.08, 0.0, 1.0), 1.15);                    // shadows and form
			if (ha.id == 1.0) dBlue = clamp(dBlue * 1.25 + 0.12, 0.0, 1.0);
			float dPink = clamp(Lb.sun * 0.55, 0.0, 1.0) * 0.85 + 0.06;                        // the sunlight prints pink
			dPink *= 1.0 - max(Lb.paint.x, Lb.paint.y);
			dBlue = max(dBlue, max(La.paint.x * 0.95, La.paint.y));
			// clustered-dot screens
			float cell = 9.5 * u.res.y / 1080.0;
			float a1 = 0.2618, a2 = 1.309;                                                      // 15 and 75 degrees
			float2 pa = float2(cos(a1) * pix.x - sin(a1) * pix.y, sin(a1) * pix.x + cos(a1) * pix.y) / cell;
			float2 pb = float2(cos(a2) * pix.x - sin(a2) * pix.y, sin(a2) * pix.x + cos(a2) * pix.y) / cell;
			float2 fa = fract(pa) - 0.5, fb = fract(pb) - 0.5;
			float spotA = length(fa) * 1.41, spotB = length(fb) * 1.41;                         // 0 at the dot centre
			float rough = (vnoise(pix * 0.9) - 0.5) * 0.10;
			float blot = 0.88 + 0.24 * fbm(pix * 0.006 + u.look.z);
			float inkA = clamp((sqrt(dBlue * blot) - spotA + rough) / (1.6 / cell) + 0.5, 0.0, 1.0);
			float inkB = clamp((sqrt(dPink * blot) - spotB + rough) / (1.6 / cell) + 0.5, 0.0, 1.0);
			float3 blueInk = float3(0.13, 0.20, 0.86), pinkInk = float3(1.0, 0.36, 0.62);
			float3 c = paper;
			c *= mix(float3(1.0), pinkInk, inkB * 0.92);
			c *= mix(float3(1.0), blueInk, inkA * 0.94);
			col += c;
		}
	}
	col /= float(n * n);
	if (medium == 9) { out.write(float4(col, 1.0), gid); return; }
	bool photo = medium == 0 || medium == 5;
	if (photo) col = grade(col, u.look.y);
	float2 q = float2(gid) / u.res;
	float vig = 0.86 + 0.14 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.28);
	if (photo) col *= vig; else col *= 0.97 + 0.03 * vig;
	float gr = hash12(float2(gid) * 1.003 + fract(u.misc.y * 0.6180339) * 811.0) - 0.5;
	float grain = photo ? 0.020 : (medium == 4 ? 0.030 : 0.012);
	col += gr * grain;
	if (!photo) {                                                                         // paper tooth
		float tooth = vnoise(float2(gid) * 0.55) * 0.6 + vnoise(float2(gid) * 0.12) * 0.4;
		col *= 0.985 + 0.03 * tooth;
	}
	out.write(float4(clamp(col, 0.0, 1.0), 1.0), gid);
}

// ------------------------------------------------------------------------------------------------ ASCII cells
// one thread per character cell: 4 x 4 rays; out0 = (graded colour, tone), out1 = (edge strength, edge angle / pi,
// share of the cell covered by the sculpture, depth)
kernel void cells(texture2d<float, access::write> out0 [[texture(0)]],
                  texture2d<float> fld [[texture(1)]],
                  texture2d<float> plac [[texture(2)]],
                  constant U& u [[buffer(0)]],
                  texture2d<float, access::write> out1 [[texture(3)]],
                  uint2 gid [[thread_position_in_grid]]) {
	float cw = u.misc.z, ch = u.misc.w;
	uint cols = uint(u.res.x / cw), rows = uint(u.res.y / ch);
	if (gid.x >= cols || gid.y >= rows) return;
	float2 origin = float2(gid) * float2(cw, ch) + 0.5 * (u.res - float2(float(cols) * cw, float(rows) * ch));
	float ids[16]; float dep[16]; float3 nrm[16];
	float3 acc = 0.0; float mk = 0.0, dsum = 0.0, pnt = 0.0;
	for (int k = 0; k < 16; k++) {
		float2 o = (float2(float(k % 4), float(k / 4)) + 0.5) / 4.0;
		float2 pix = origin + o * float2(cw, ch);
		Ray r = camRay(u, pix, float2(0.5));
		Hit h = trace(r.o, r.d, fld, 30.0);
		Lit L = lightAt(h.p, h.n, h.id, r.d, u.look.x, fld, plac, h.t * cw / (u.res.y * u.ro.w), u);
		acc += L.col; pnt += L.paint.x;
		ids[k] = h.id; dep[k] = h.t; nrm[k] = h.n;
		mk += (h.id == 1.0) ? 1.0 : 0.0; dsum += h.t;
	}
	float3 c = grade(acc / 16.0, u.look.y);
	// discontinuities between neighbouring rays: id change, depth jump or crease
	float2 mean = 0.0; float cnt = 0.0; float sxx = 0.0, syy = 0.0, sxy = 0.0;
	float2 pts[24]; int np = 0;
	for (int y = 0; y < 4; y++) for (int x = 0; x < 4; x++) {
		int i = y * 4 + x;
		if (x < 3) { int j = i + 1;
			bool e = ids[i] != ids[j] || abs(dep[i] - dep[j]) > 0.03 * dep[i] || dot(nrm[i], nrm[j]) < 0.75;
			if (e) { pts[np++] = float2(float(x) + 0.5, float(y)); } }
		if (y < 3) { int j = i + 4;
			bool e = ids[i] != ids[j] || abs(dep[i] - dep[j]) > 0.03 * dep[i] || dot(nrm[i], nrm[j]) < 0.75;
			if (e) { pts[np++] = float2(float(x), float(y) + 0.5); } }
	}
	for (int i = 0; i < np; i++) { mean += pts[i]; cnt += 1.0; }
	float angle = 0.0;
	if (cnt > 0.0) {
		mean /= cnt;
		for (int i = 0; i < np; i++) { float2 d = pts[i] - mean; sxx += d.x * d.x; syy += d.y * d.y; sxy += d.x * d.y; }
		// principal direction of the discontinuity points = the edge direction (cell y runs down)
		angle = 0.5 * atan2(2.0 * sxy, sxx - syy);
		// account for the cell's aspect: points were in ray-grid units, cells are taller than wide
		float2 dir = float2(cos(angle) * cw, sin(angle) * ch);
		angle = atan2(dir.y, dir.x);
	}
	float edge = cnt / 24.0;
	out0.write(float4(c, luma(c)), gid);
	out1.write(float4(edge, fract(angle / 3.14159265 + 1.0), mk / 16.0, pnt / 16.0), gid);
}
