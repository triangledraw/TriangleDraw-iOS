// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public struct E2CanvasPoint {
	public let x: Int
	public let y: Int

	public init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
}

extension E2CanvasPoint {
	public func offset(x: Int, y: Int) -> E2CanvasPoint {
		return E2CanvasPoint(x: self.x + x, y: self.y + y)
	}
}

extension E2CanvasPoint: Equatable {
	public static func == (lhs: E2CanvasPoint, rhs: E2CanvasPoint) -> Bool {
		let same_x: Bool = lhs.x == rhs.x
		let same_y: Bool = lhs.y == rhs.y
		return same_x && same_y
	}
}

extension E2CanvasPoint {
	public func flipX(size: E2CanvasSize) -> E2CanvasPoint {
		return E2CanvasPoint(x: Int(size.width * 2 - 2) - self.x, y: self.y)
	}

	public func flipY(size: E2CanvasSize) -> E2CanvasPoint {
		return E2CanvasPoint(x: self.x, y: Int(size.height - 1) - self.y)
	}
}
