// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIImage {
    func imageScaled(toExactSize newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		guard let context: CGContext = UIGraphicsGetCurrentContext() else {
			log.error("Expected UIGraphicsGetCurrentContext() to non-nil CGContext, but got nil")
			return nil
		}
		context.interpolationQuality = .medium
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
