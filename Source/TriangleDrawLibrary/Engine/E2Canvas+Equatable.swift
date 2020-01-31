// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas: Equatable {
	public static func == (lhs: E2Canvas, rhs: E2Canvas) -> Bool {
		if lhs === rhs {
			return true
		}
		guard lhs.size.width == rhs.size.width else {
			return false
		}
		guard lhs.size.height == rhs.size.height else {
			return false
		}
		guard lhs.cellsPerColumn == rhs.cellsPerColumn else {
			return false
		}
		guard lhs.cellsPerRow == rhs.cellsPerRow else {
			return false
		}
		guard lhs.cells == rhs.cells else {
			return false
		}
		return true
	}
}
