#include <metal_stdlib>
using namespace metal;
struct Uniforms { float time; float2 res; float frame; float p0, p1, p2, p3; };
constexpr sampler lin(filter::linear, address::clamp_to_edge);
kernel void frame(texture2d<float, access::write> out [[texture(0)]], texture2d<float> fld [[texture(1)]], constant Uniforms& u [[buffer(0)]], uint2 gid [[thread_position_in_grid]]) {
	if (gid.x >= uint(u.res.x) || gid.y >= uint(u.res.y)) return;
	float2 tc = (float2(gid) + 0.5) / u.res;            // texture coords straight from the output pixel (top-left origin)
	float d = fld.sample(lin, tc).r;
	out.write(float4(d < 0.0 ? 1.0 : 0.1, d < 0.0 ? 1.0 : 0.1, d < 0.0 ? 1.0 : 0.1, 1.0), gid);
}
