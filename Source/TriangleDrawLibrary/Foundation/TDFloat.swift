// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import simd

#if swift(>=5.1)
	// Was introduced in Swift 5.1 and Xcode11.0
	public typealias TDFloat2 = SIMD2<Float>
#else
	// Swift 5.0 and earlier
	public typealias TDFloat2 = float2
#endif

#if swift(>=5.1)
	// Was introduced in Swift 5.1 and Xcode11.0
	public typealias TDFloat3 = SIMD3<Float>
#else
	// Swift 5.0 and earlier
	public typealias TDFloat3 = float3
#endif

#if swift(>=5.1)
	// Was introduced in Swift 5.1 and Xcode11.0
	public typealias TDFloat4 = SIMD4<Float>
#else
	// Swift 5.0 and earlier
	public typealias TDFloat4 = float4
#endif
