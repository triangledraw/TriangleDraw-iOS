// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UIView {
	/// Find the first UITableView among all the superviews.
	///
	/// - returns: the found tableview otherwise nil.
	func rf_tableView() -> UITableView? {
		var viewOrNil: UIView? = self
		while let view = viewOrNil {
			if let tableView = view as? UITableView {
				return tableView
			}
			viewOrNil = view.superview
		}
		return nil
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_tableView instead")
    func form_tableView() -> UITableView? {
        return rf_tableView()
    }
}
