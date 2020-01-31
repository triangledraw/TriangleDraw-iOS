// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

struct HCHexagonCorners {
	var topLeft = CGPoint.zero
	var topRight = CGPoint.zero
	var middleLeft = CGPoint.zero
	var middleRight = CGPoint.zero
	var bottomLeft = CGPoint.zero
	var bottomRight = CGPoint.zero
}

extension HCHexagonCorners: CustomStringConvertible {
	var description: String {
		return "\(topLeft.string2) \(topRight.string2) \(middleLeft.string2) \(middleRight.string2) \(bottomLeft.string2) \(bottomRight.string2)"
	}
}
