// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UIView {
	/// Find the first responder.
	///
	/// This function is recursive.
	///
	/// - returns: the first responder otherwise nil.
	public func rf_firstResponder() -> UIView? {
		if self.isFirstResponder {
			return self
		}
		for subview in subviews {
			let responder = subview.rf_firstResponder()
			if responder != nil {
				return responder
			}
		}
		return nil
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_firstResponder instead")
    public func form_firstResponder() -> UIView? {
        return rf_firstResponder()
    }
}
