// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
#include <metal_stdlib>
using namespace metal;

struct Constants {
	float4x4 modelViewProjectionMatrix;
};

struct VertexIn {
	// Position in unit space
	// a value of 0 indicates center of the shape
	// a value of -1 indicates left edge of the shape
	// a value of 1 indicates right edge of the shape
	float2 position [[attribute(0)]];

	// Floating-point RGBA colors
	float4 color [[attribute(1)]];
};

struct VertexOut {
	// The [[position]] attribute of this member indicates that this value is the clip space
	// position of the vertex when this structure is returned from the vertex function
	float4 clipSpacePosition [[position]];

	// Since this member does not have a special attribute, the rasterizer interpolates
	// its value with the values of the other triangle vertices and then passes
	// the interpolated value to the fragment shader for each fragment in the triangle
	float4 color;
};

vertex VertexOut filledtriangle_vertex(
									   VertexIn in [[stage_in]],
									   constant Constants &uniforms [[buffer(1)]])
{
	VertexOut out;

	float2 modelPosition = in.position;

	// Multiplies by the model-view-projection matrix from the constant buffer
	// Transforms vertex positions from model-local space to clip space
	out.clipSpacePosition = uniforms.modelViewProjectionMatrix * float4(modelPosition, 0, 1);

	// Pass our input color straight to our output color.  This value will be interpolated
	//   with the other color values of the vertices that make up the triangle to produce
	//   the color value for each fragment in our fragment shader
	out.color = in.color;
	
	return out;
}

fragment half4 filledtriangle_fragment(VertexOut in [[stage_in]]) {
	return half4(in.color);
}
