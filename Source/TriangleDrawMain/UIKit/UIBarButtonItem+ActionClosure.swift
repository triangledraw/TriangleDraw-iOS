// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIBarButtonItem {
	private struct AssociatedObject {
		static var key = "action_closure_key"
	}

	typealias ActionClosure = (_ barButtonItem: UIBarButtonItem) -> Void
	var actionClosure: ActionClosure? {
		get {
			return objc_getAssociatedObject(self, &AssociatedObject.key) as? ActionClosure
		}
		set {
			objc_setAssociatedObject(self, &AssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			target = self
			action = #selector(didTapButton)
		}
	}

	@objc func didTapButton() {
		actionClosure?(self)
	}
}
