// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

@IBDesignable
class BorderedButton: UIButton {

	@IBInspectable
	var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.borderColor = color.cgColor
			} else {
				layer.borderColor = nil
			}
		}
	}

}
