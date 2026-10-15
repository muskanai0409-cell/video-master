// gallery_mark.metal: the supermemory mark as a plaster sculpture in a sunlit gallery corner. The mark is extruded
// from its own 2D signed distance field (sdfgen of lock_mark.png, texture 1). Light: a low sun through a mullioned
// window (gobo shadows that crawl across wall and floor as the sun moves), a cool sky fill (the brand blue lives in
// the shadows), a warm floor bounce, ambient occlusion, a filmic curve, grain. No glow, no chrome, no black void.
#include <metal_stdlib>
using namespace metal;

struct Uniforms { float time; float2 res; float frame; float p0, p1, p2, p3; };
constexpr sampler lin(filter::linear, address::clamp_to_edge);

float sdMark2D(float2 q, texture2d<float> fld) {
	// q in mark units: the field spans [-1, 1]; outside it, distance keeps growing from the edge
	float2 uv = q * 0.5 + 0.5;
	float2 c = clamp(uv, 0.0, 1.0);
	float d = fld.sample(lin, float2(c.x, 1.0 - c.y)).r * 2.0;                 // field units: full width = 1 -> [-1,1] width 2
	return d + length(uv - c) * 2.0;
}
float sdMark3D(float3 p, texture2d<float> fld, float depth, float round_) {
	float d2 = sdMark2D(p.xy, fld) + round_;
	float2 w = float2(d2, abs(p.z) - depth + round_);
	return min(max(w.x, w.y), 0.0) + length(max(w, 0.0)) - round_;
}
float3 rotY(float3 p, float a) { float c = cos(a), s = sin(a); return float3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z); }

// world: floor y=0, back wall z=-1.6, side wall x=-3.2 ; the mark stands at the origin, 1.6 units tall
float2 world(float3 p, float t, texture2d<float> fld) {
	float3 q = rotY(p - float3(0.15, 0.735, 0.0), -0.30 + 0.08 * sin(t * 0.21));
	float mark = sdMark3D(q / 1.0, fld, 0.16, 0.03);
	float room = min(p.y, min(p.z + 1.6, p.x + 3.2));
	return mark < room ? float2(mark, 1.0) : float2(room, 2.0);
}
float3 nrm(float3 p, float t, texture2d<float> fld) {
	float2 e = float2(1.5e-3, 0.0);
	return normalize(float3(world(p + e.xyy, t, fld).x - world(p - e.xyy, t, fld).x,
	                        world(p + e.yxy, t, fld).x - world(p - e.yxy, t, fld).x,
	                        world(p + e.yyx, t, fld).x - world(p - e.yyx, t, fld).x));
}
float shadowRay(float3 ro, float3 rd, float t, texture2d<float> fld, float k) {
	float res = 1.0, s = 0.015;
	for (int i = 0; i < 64 && s < 10.0; i++) {
		float h = world(ro + rd * s, t, fld).x;
		res = min(res, k * h / s);
		if (h < 1e-4) return 0.0;
		s += clamp(h, 0.01, 0.3);
	}
	return clamp(res, 0.0, 1.0);
}
float occlusion(float3 p, float3 n, float t, texture2d<float> fld) {
	float o = 0.0, sc = 1.0;
	for (int i = 1; i <= 5; i++) { float h = 0.02 + 0.12 * float(i); o += (h - world(p + n * h, t, fld).x) * sc; sc *= 0.75; }
	return clamp(1.0 - 1.8 * o, 0.0, 1.0);
}
// the window: light passes only through the panes of a 3 x 2 mullioned window high on the right
float gobo(float3 p, float3 sun) {
	// project p along the sun onto the window plane x = 4.0
	float s = (4.0 - p.x) / sun.x;
	float3 w = p + sun * s;
	float2 uv = float2(w.z, w.y);                                         // window coordinates
	float2 c = float2(1.35, 2.75), half_ = float2(1.9, 1.25);
	float2 d = abs(uv - c) - half_;
	float frame = 1.0 - smoothstep(-0.02, 0.02, max(d.x, d.y));
	float2 g = fract((uv - c + half_) / float2(half_.x * 2.0 / 3.0, half_.y)) ;
	float mull = smoothstep(0.0, 0.03, g.x) * smoothstep(0.0, 0.03, 1.0 - g.x) * smoothstep(0.0, 0.04, g.y) * smoothstep(0.0, 0.04, 1.0 - g.y);
	return frame * mull;
}
float hash12(float2 p) { float3 p3 = fract(float3(p.xyx) * 0.1031); p3 += dot(p3, p3.yzx + 33.33); return fract((p3.x + p3.y) * p3.z); }
float3 filmic(float3 x) { x = max(x - 0.004, 0.0); return (x * (6.2 * x + 0.5)) / (x * (6.2 * x + 1.7) + 0.06); }

float3 render(float3 ro, float3 rd, float t, texture2d<float> fld) {
	float s = 0.0; float2 h = 0.0;
	for (int i = 0; i < 200; i++) { h = world(ro + rd * s, t, fld); if (h.x < 2e-4 || s > 40.0) break; s += h.x * 0.85; }
	float3 p = ro + rd * s, n = nrm(p, t, fld);
	float az = 2.55 + 0.35 * smoothstep(0.0, 12.0, t);                                // the sun crawls across
	float3 sun = normalize(float3(cos(az) * -0.9, 0.55, sin(az) * 0.9));
	sun = normalize(float3(0.62, 0.40, 0.70 - 0.22 * smoothstep(0.0, 12.0, t)));
	float sh = shadowRay(p + n * 2e-3, sun, t, fld, 22.0) * gobo(p, sun);
	float occ = occlusion(p, n, t, fld);
	float3 albedo = h.y < 1.5 ? float3(0.92, 0.90, 0.86) : float3(0.88, 0.87, 0.84);
	// plaster micro-texture
	albedo *= 0.97 + 0.03 * hash12(floor(p.xz * 180.0) + floor(p.y * 180.0));
	float3 sunCol = float3(1.0, 0.88, 0.72) * 2.6;
	float3 skyCol = float3(0.46, 0.52, 0.80) * 0.62;                                  // a cool sky fill: the blue lives in the shadows
	float dif = max(dot(n, sun), 0.0) * sh;
	float sky = (0.55 + 0.45 * n.y) * occ;
	float bounce = max(dot(n, float3(0.0, -1.0, 0.0)), 0.0) * 0.35 * occ;
	float3 col = albedo * (sunCol * dif + skyCol * sky + float3(1.0, 0.8, 0.6) * bounce);
	// a faint sheen on the sculpture's lit edges
	if (h.y < 1.5) { float3 hv = normalize(sun - rd); col += sunCol * 0.04 * pow(max(dot(n, hv), 0.0), 40.0) * sh; }
	return col;
}

kernel void frame(texture2d<float, access::write> out [[texture(0)]],
                  texture2d<float> fld [[texture(1)]],
                  constant Uniforms& u [[buffer(0)]],
                  uint2 gid [[thread_position_in_grid]]) {
	if (gid.x >= uint(u.res.x) || gid.y >= uint(u.res.y)) return;
	float t = u.time;
	float3 ro = float3(-1.4 + 0.45 * smoothstep(0.0, 12.0, t), 1.05, 4.9 - 0.7 * smoothstep(0.0, 12.0, t));
	float3 ta = float3(0.25, 0.78, -0.3);
	float3 fw = normalize(ta - ro), rt = normalize(cross(fw, float3(0, 1, 0))), up = cross(rt, fw);
	float3 col = 0.0;
	for (int k = 0; k < 4; k++) {
		float2 o = float2(float(k & 1), float(k >> 1)) * 0.5 - 0.25;
		float2 uv = (float2(gid) + 0.5 + o - 0.5 * u.res) / u.res.y; uv.y = -uv.y;
		col += render(ro, normalize(fw * 2.1 + rt * uv.x + up * uv.y), t, fld);
	}
	col = filmic(col / 4.0);
	float2 q = float2(gid) / u.res;
	col *= 0.9 + 0.1 * pow(16.0 * q.x * q.y * (1.0 - q.x) * (1.0 - q.y), 0.3);
	col += (hash12(float2(gid) + fract(t * 3.77) * 517.0) - 0.5) * 0.022;
	out.write(float4(col, 1.0), gid);
}
