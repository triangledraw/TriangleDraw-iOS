// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import CoreGraphics

extension CGSize {
	public func triangleDraw_findOptimalTileCount(clampN: UInt) -> UInt {
		var n: UInt = 1
		while true {
			let nextN = n * 2

			func tooSmallValue(_ value: CGFloat) -> Bool {
				let valueDividedByNextN: CGFloat = value / CGFloat(nextN)
				return valueDividedByNextN < 4.1
			}

			if tooSmallValue(self.width) || tooSmallValue(self.height) {
				return n
			}

			func hasRemainder(_ value: CGFloat) -> Bool {
				let valueDividedByNextN: CGFloat = value / CGFloat(nextN)
				let remainder: CGFloat = abs(fmod(valueDividedByNextN, 1.0))
				return remainder > 0.00001
			}

			if hasRemainder(self.width) || hasRemainder(self.height) {
				return n
			}

			n = nextN
			guard n < clampN else {
				return clampN
			}
		}
	}
}
