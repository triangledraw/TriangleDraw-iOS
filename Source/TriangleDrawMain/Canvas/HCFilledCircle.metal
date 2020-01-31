// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
#include <metal_stdlib>
using namespace metal;

struct Constants {
	float pointSize;

	float4x4 modelViewProjectionMatrix;
};

struct VertexIn {
	// Position in unit space
	// a value of 0 indicates center of the shape
	// a value of -1 indicates left edge of the shape
	// a value of 1 indicates right edge of the shape
	float2 position [[attribute(0)]];
};

struct VertexOut {
	// The [[position]] attribute of this member indicates that this value is the clip space
	// position of the vertex when this structure is returned from the vertex function
	float4 clipSpacePosition [[position]];

	float pointsize [[point_size]];
};


vertex VertexOut filledcircle_vertex(
									 VertexIn in [[stage_in]],
									 constant Constants &uniforms [[buffer(1)]])
{
	VertexOut out;

	float2 modelPosition = in.position;

	// Multiplies by the model-view-projection matrix from the constant buffer
	// Transforms vertex positions from model-local space to clip space
	out.clipSpacePosition = uniforms.modelViewProjectionMatrix * float4(modelPosition, 0, 1);

	out.pointsize = uniforms.pointSize;
	
	return out;
}

fragment half4 filledcircle_variablesize_fragment(
							  VertexOut in [[stage_in]],
							  float2 pointCoord [[point_coord]])
{
	float2 cxy = 2.f * (pointCoord - 0.5f);
	float r = dot(cxy, cxy);

	// Antialiasing using `fwidth()` is described here
	// https://www.desultoryquest.com/blog/drawing-anti-aliased-circular-points-using-opengl-slash-webgl/
	// https://metashapes.com/blog/anti-aliasing-shaders/
	float delta = fwidth(r);

	float alpha = 1.f - smoothstep(1.f - delta, 1.f + delta, r);
	return half4(0.75h, 0.75h, 0.75h, 1.h) * half(alpha);
}

fragment half4 filledcircle_fixedsize_fragment(
							  VertexOut in [[stage_in]],
							  float2 pointCoord [[point_coord]])
{
    float2 cxy = 2.f * (pointCoord - 0.5f);
    float v = 1.f - length(cxy);
    float alpha = smoothstep(0.6f, 1.f, v) * 0.375f;
	return half(alpha);
}
