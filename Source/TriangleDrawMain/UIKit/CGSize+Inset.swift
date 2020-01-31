// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension CGSize {
	func inset(by insets: UIEdgeInsets) -> CGSize {
		let newSize: CGSize = CGSize(
			width: self.width - (insets.left + insets.right),
			height: self.height - (insets.top + insets.bottom)
		)
		return newSize
	}
}
