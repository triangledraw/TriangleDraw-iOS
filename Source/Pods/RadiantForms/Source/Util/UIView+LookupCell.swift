// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UIView {
	/// Find the first UITableViewCell among all the superviews.
	///
	/// - returns: the found cell otherwise nil.
	func rf_cell() -> UITableViewCell? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let cell = view as? UITableViewCell {
				return cell
			}
			viewOrNil = view.superview
		}
		return nil
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_cell instead")
    func form_cell() -> UITableViewCell? {
        return rf_cell()
    }
}
