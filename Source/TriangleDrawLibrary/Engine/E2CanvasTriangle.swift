// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public class E2CanvasTriangle {
	public let x0: Int
	public let y0: Int
	public let x1: Int
	public let y1: Int
	public let x2: Int
	public let y2: Int

	public init(x0: Int, y0: Int, x1: Int, y1: Int, x2: Int, y2: Int) {
		self.x0 = x0
		self.y0 = y0
		self.x1 = x1
		self.y1 = y1
		self.x2 = x2
		self.y2 = y2
	}
}

extension E2CanvasTriangle: CustomStringConvertible {
	public var description: String {
		return "E2CanvasTriangle(\(x0) \(y0), \(x1) \(y1), \(x2) \(y2))"
	}
}

public struct E2CanvasTriangle2 {
	public var value: UInt8
	public var a: IntVec2
	public var b: IntVec2
	public var c: IntVec2
}

extension E2CanvasTriangle2 {
	/// Remove all triangles that are outside the hexagon mask.
	///
	/// The typical values are `0` and `1` and have been assigned by the user.
	///
	/// However there is a special value of `255` indicates that it's a triangle outside the hexagon mask.
	public static func onlyTrianglesInsideTheHexagon(_ triangles: [E2CanvasTriangle2]) -> [E2CanvasTriangle2] {
		return triangles.filter { $0.value != 255 }
	}
}
