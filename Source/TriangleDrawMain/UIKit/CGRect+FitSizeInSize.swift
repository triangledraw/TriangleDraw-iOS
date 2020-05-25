// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension CGRect {
	/// Scale and translate a rectangle so that it fits inside a container rectangle.
	///
	///
	/// - parameter size:  The size of the rectangle that is to be scaled and translated.
	/// - parameter fit:   The size of the target container rectangle.
	///
	/// - returns: A scaled and translated version of the `size` rectangle.
	static func fitSizeInSize(size: CGSize, fit: CGSize) -> CGRect {
		assert(size.width > 0)
		assert(size.height > 0)
		assert(fit.width > 0)
		assert(fit.height > 0)
		let heightQuotient: CGFloat = size.height / fit.height
		let widthQuotient: CGFloat = size.width / fit.width
		let result: CGSize
		if heightQuotient > widthQuotient {
			result = CGSize(width: size.width / heightQuotient, height: fit.height)
		} else {
			result = CGSize(width: fit.width, height: size.height / widthQuotient)
		}
		let point = CGPoint(
			x: floor((fit.width - result.width) / 2.0),
			y: floor((fit.height - result.height) / 2.0)
		)
		return CGRect(origin: point, size: result)
	}
}
