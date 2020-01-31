// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIView {
    func addConstraintSuperviewEdgeHorizontalSubview(_ subview: UIView) {
		let views: [String: Any] = ["subview": subview]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: views))
    }

    func addConstraintSuperviewEdgeVerticalSubview(_ subview: UIView) {
		let views: [String: Any] = ["subview": subview]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: views))
    }
}
