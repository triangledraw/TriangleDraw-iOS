// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIColor {
	public func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { rendererContext in
			self.setFill()
			rendererContext.fill(CGRect(origin: .zero, size: size))
		}
	}
}
