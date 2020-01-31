// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import MessageUI
import TriangleDrawLibrary

extension UIViewController {
	/// Send feedback via email to the developer
	func td_presentEmailWithFeedback() {
		EmailWithFeedback.shared.present(parentViewController: self)
	}
}

/// Presents a `MFMailComposeViewController` that is prefilled
/// with info about the system, device, app.
fileprivate class EmailWithFeedback: NSObject {
	fileprivate static let shared = EmailWithFeedback()
	private var startTime: Double = 0

	fileprivate func present(parentViewController: UIViewController) {
		startTime = CFAbsoluteTimeGetCurrent()
		guard MFMailComposeViewController.canSendMail() else {
			log.error("This device is not configured for sending mail")
			return
		}
		log.debug("Ask for user for feedback")

		let systemInfo: String = SystemInfo.systemInfo

		var items = [String]()
		items.append("What do you think?")
		items.append("")
		items.append("")
		items.append("Helpful info for the developer:")
		items.append(systemInfo)
		let messageBody: String = items.joined(separator: "\n")

		let subject = "Help improve TriangleDraw"
		let mailer = MFMailComposeViewController()
		mailer.mailComposeDelegate = self
		mailer.setSubject(subject)
		mailer.setToRecipients(["TriangleDraw <hello@triangledraw.com>"])
		mailer.setMessageBody(messageBody, isHTML: false)
		if Platform.is_ideom_ipad {
			mailer.modalPresentationStyle = .pageSheet
		}
		parentViewController.present(mailer, animated: true)
	}
}

extension EmailWithFeedback: MFMailComposeViewControllerDelegate {
	public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
		let elapsed: Double = CFAbsoluteTimeGetCurrent() - startTime
		log.debug("elapsed: \(elapsed.string2)")
		if let theError: Error = error {
			log.error("Error occurred while trying to send. error: \(theError.localizedDescription)")
			return
		}
		switch result {
		case .cancelled:
			log.debug("result: cancelled, User canceled the composition")
		case .saved:
			log.debug("result: saved, User successfully saved the message")
		case .sent:
			log.debug("result: sent, User successfully sent/queued the message")
		case .failed:
			log.error("result: failed, User's attempt to save or send was unsuccessful")
		@unknown default:
			log.error("result: MFMailComposeResult may have additional unknown values, possibly added in future versions")
		}
	}
}
