// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2CanvasPoint {
	public enum Orientation {
		case upward
		case downward
	}

	/// Determine if the triangle is facing upwards or downwards
	public var orientation: Orientation {
		if (self.x + self.y) & 1 == 1 {
			return .upward
		} else {
			return .downward
		}
	}
}
