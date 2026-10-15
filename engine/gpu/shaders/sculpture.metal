// sculpture.metal: a raymarched studio sculpture (real 3D, no meshes). Metaballs that breathe and fuse, on a
// cyclorama, lit like a product shot: a soft key with penumbra shadows, a fill, a rim, ambient occlusion, fresnel
// reflections of a softbox studio, ACES-like tone curve, a whisper of grain. 2x2 supersampling.
#include <metal_stdlib>
using namespace metal;

struct Uniforms { float time; float2 res; float frame; float p0, p1, p2, p3; };

float smin(float a, float b, float k) { float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0); return mix(b, a, h) - k * h * (1.0 - h); }
float sdSphere(float3 p, float r) { return length(p) - r; }
float sdRoundBox(float3 p, float3 b, float r) { float3 q = abs(p) - b + r; return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0) - r; }

// the sculpture: five spheres orbit a core and fuse; over time the cluster settles into a rounded slab
float sculpt(float3 p, float t) {
	float d = 1e9;
	float settle = smoothstep(4.0, 9.0, t);
	for (int i = 0; i < 5; i++) {
		float fi = float(i);
		float a = t * (0.35 + 0.07 * fi) + fi * 1.2566;
		float rr = mix(0.85 + 0.25 * sin(t * 0.6 + fi), 0.25, settle);
		float3 c = float3(cos(a) * rr, 0.95 + 0.35 * sin(t * 0.8 + fi * 1.7) * (1.0 - settle), sin(a) * rr);
		d = smin(d, sdSphere(p - c, mix(0.42 + 0.06 * sin(t + fi), 0.5, settle)), mix(0.55, 0.9, settle));
	}
	float slab = sdRoundBox(p - float3(0.0, 0.95, 0.0), float3(0.95, 0.5, 0.6), 0.32);
	return mix(d, slab, settle * 0.85);
}
float floorSDF(float3 p) {
	// a cyclorama: flat floor that curves up into a back wall
	float back = -2.6;
	float z = p.z - back;
	float r = 1.4;
	if (z < r && p.y > 0.0) { float2 q = float2(z - r, p.y - r); return (p.y < r && z < r) ? r - length(q) : min(p.y, z); }
	return min(p.y, z);
}
float2 mapScene(float3 p, float t) {
	float a = sculpt(p, t), b = floorSDF(p);
	return a < b ? float2(a, 1.0) : float2(b, 2.0);
}
float3 normalAt(float3 p, float t) {
	float2 e = float2(1e-3, 0.0);
	return normalize(float3(mapScene(p + e.xyy, t).x - mapScene(p - e.xyy, t).x,
	                        mapScene(p + e.yxy, t).x - mapScene(p - e.yxy, t).x,
	                        mapScene(p + e.yyx, t).x - mapScene(p - e.yyx, t).x));
}
float softShadow(float3 ro, float3 rd, float t) {
	float res = 1.0, s = 0.02;
	for (int i = 0; i < 48 && s < 8.0; i++) {
		float h = mapScene(ro + rd * s, t).x;
		res = min(res, 9.0 * h / s);
		if (h < 1e-4) break;
		s += clamp(h, 0.01, 0.25);
	}
	return clamp(res, 0.0, 1.0);
}
float ao(float3 p, float3 n, float t) {
	float o = 0.0, sc = 1.0;
	for (int i = 1; i <= 5; i++) { float h = 0.03 + 0.11 * float(i); o += (h - mapScene(p + n * h, t).x) * sc; sc *= 0.7; }
	return clamp(1.0 - 2.2 * o, 0.0, 1.0);
}
// the studio the chrome reflects: deep blue room, two long softboxes, a warm kicker
float3 studio(float3 rd) {
	float3 c = mix(float3(0.01, 0.02, 0.09), float3(0.04, 0.10, 0.55), smoothstep(-0.2, 0.9, rd.y));
	c += float3(1.6, 1.7, 1.9) * smoothstep(0.985, 0.995, dot(rd, normalize(float3(-0.6, 0.7, 0.2))));      // key softbox
	c += float3(1.1, 1.2, 1.4) * smoothstep(0.88, 0.97, 1.0 - abs(rd.x * 2.2 - 1.1)) * smoothstep(0.2, 0.6, rd.y) * 0.35;
	c += float3(0.9, 0.55, 0.25) * smoothstep(0.96, 0.995, dot(rd, normalize(float3(0.9, 0.2, -0.4)))) * 0.8;   // warm kicker
	return c;
}
float3 shade(float3 ro, float3 rd, float t) {
	float s = 0.0; float2 h = float2(0.0);
	for (int i = 0; i < 160; i++) { h = mapScene(ro + rd * s, t); if (h.x < 1e-4 || s > 30.0) break; s += h.x * 0.9; }
	if (s > 30.0) return studio(rd) * 0.3;
	float3 p = ro + rd * s, n = normalAt(p, t);
	float3 key = normalize(float3(-0.6, 0.9, 0.35)), rim = normalize(float3(0.4, 0.3, -0.85));
	float occ = ao(p, n, t), sh = softShadow(p + n * 2e-3, key, t);
	float fres = pow(1.0 - max(dot(n, -rd), 0.0), 5.0);
	float3 col;
	if (h.y < 1.5) {
		// glossy porcelain with a blue soul: diffuse + clear-coat reflection of the studio
		float3 base = float3(0.93, 0.95, 1.0);
		float dif = max(dot(n, key), 0.0) * sh;
		float sss = pow(clamp(1.0 + dot(n, rd), 0.0, 1.0), 2.0) * 0.6;                       // light wraps the edges
		float3 refl = studio(reflect(rd, n));
		col = base * (0.10 + 0.95 * dif) * occ + float3(0.10, 0.30, 1.0) * sss * occ;
		col += refl * mix(0.05, 0.9, fres) * occ;
		col += float3(0.6, 0.75, 1.0) * pow(max(dot(n, rim), 0.0), 3.0) * 0.6;
	} else {
		// the cyclorama: matte, cool, catching the sculpture's shadow and a faint blue bounce
		float dif = max(dot(n, key), 0.0) * sh;
		col = float3(0.80, 0.84, 0.95) * (0.18 + 0.75 * dif) * occ;
		col += float3(0.05, 0.12, 0.5) * (1.0 - occ) * 0.35;
	}
	return mix(col, studio(rd) * 0.25, 1.0 - exp(-0.004 * s * s));                     // a little atmosphere
}
float3 aces(float3 x) { return clamp((x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14), 0.0, 1.0); }
float hash12(float2 p) { float3 p3 = fract(float3(p.xyx) * 0.1031); p3 += dot(p3, p3.yzx + 33.33); return fract((p3.x + p3.y) * p3.z); }

kernel void frame(texture2d<float, access::write> out [[texture(0)]],
                  texture2d<float, access::read> src [[texture(1)]],
                  constant Uniforms& u [[buffer(0)]],
                  uint2 gid [[thread_position_in_grid]]) {
	if (gid.x >= uint(u.res.x) || gid.y >= uint(u.res.y)) return;
	float t = u.time;
	// camera: a slow orbit and dolly in, like a product turntable shot
	float ang = 0.55 + t * 0.09;
	float dist = mix(6.2, 4.6, smoothstep(0.0, 10.0, t));
	float3 ro = float3(sin(ang) * dist, 1.55 + 0.25 * sin(t * 0.3), cos(ang) * dist);
	float3 ta = float3(0.0, 0.95, 0.0);
	float3 fw = normalize(ta - ro), rt = normalize(cross(fw, float3(0, 1, 0))), up = cross(rt, fw);
	float3 col = 0.0;
	for (int sx = 0; sx < 2; sx++) for (int sy = 0; sy < 2; sy++) {
		float2 o = float2(float(sx), float(sy)) * 0.5 - 0.25;
		float2 uv = (float2(gid) + 0.5 + o - 0.5 * u.res) / u.res.y;
		uv.y = -uv.y;
		float3 rd = normalize(fw * 1.9 + rt * uv.x + up * uv.y);
		col += shade(ro, rd, t);
	}
	col /= 4.0;
	col = aces(col * 1.15);
	col = pow(col, float3(1.0 / 2.2));
	float2 q = float2(gid) / u.res;
	col *= 0.86 + 0.14 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.25);           // gentle vignette
	col += (hash12(float2(gid) + fract(t * 7.13) * 917.0) - 0.5) * 0.018;                      // fine grain
	out.write(float4(col, 1.0), gid);
}
