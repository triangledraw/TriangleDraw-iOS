// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIEdgeInsets {
	func insetsByAdding(_ value: CGFloat) -> UIEdgeInsets {
		var newInsets = self
		newInsets.left += value
		newInsets.right += value
		newInsets.top += value
		newInsets.bottom += value
		return newInsets
	}
}
