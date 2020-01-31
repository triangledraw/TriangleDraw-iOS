// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIView {
    func addConstraintCenterXSubview(_ subview: UIView) {
		addConstraint(NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }

    func addConstraintCenterYSubview(_ subview: UIView) {
		addConstraint(NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
