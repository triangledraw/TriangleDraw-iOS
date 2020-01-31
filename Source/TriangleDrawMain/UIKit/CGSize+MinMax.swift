// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension CGSize {
	var minValue: CGFloat {
		return min(self.width, self.height)
	}

	var maxValue: CGFloat {
		return max(self.width, self.height)
	}
}
