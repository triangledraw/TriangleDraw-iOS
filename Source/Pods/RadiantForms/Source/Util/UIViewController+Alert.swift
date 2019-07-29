// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UIViewController {
	/// Show an alert with an OK button
	///
	/// - parameter title: The text shown in top of the alert.
	/// - parameter message: The text shown in center of the alert.
	public func rf_simpleAlert(_ title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_simpleAlert instead")
    public func form_simpleAlert(_ title: String, _ message: String) {
        rf_simpleAlert(title, message)
    }
}
