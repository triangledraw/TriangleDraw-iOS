// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension BrowserViewController {
	func presentDocumentExample(_ documentExample: DocumentExample) {
		let displayNameBehavior: Document.DisplayNameBehavior
		if let name: String = documentExample.overrideDisplayName {
			displayNameBehavior = .customDisplayName(name: name)
		} else {
			displayNameBehavior = .extractFromURL
		}
		presentDocument(
			at: documentExample.url,
			animated: false,
			displayNameBehavior: displayNameBehavior
		)
	}

	func presentDocument(at documentURL: URL, animated: Bool, displayNameBehavior: Document.DisplayNameBehavior) {
		let document: Document = Document(fileURL: documentURL)
		document.open(completionHandler: { [weak self] (success) in
			guard let strongSelf = self else {
				log.error("Expected self to be non-nil, but got nil. Cannot open document.\n: documentURL: \(documentURL)")
				return
			}

			// Make sure to implement handleError(_:userInteractionPermitted:) in your UIDocument subclass to handle errors appropriately.
			if success {
				strongSelf.presentDocument_successfullyOpenedDocument(
					document: document,
					animated: animated,
					displayNameBehavior: displayNameBehavior
				)
			} else {
				strongSelf.presentDocument_failureOpeningDocument(document: document)
			}
		})
	}

	private func presentDocument_successfullyOpenedDocument(document: Document, animated: Bool, displayNameBehavior: Document.DisplayNameBehavior) {
		log.debug("Succesfully opened document.\ndocumentState: \(document.documentState.td_humanReadable)\nfileURL: \(document.fileURL)")
		document.displayNameBehavior = displayNameBehavior
		let (nc, canvasViewController) = CanvasViewController.createInsideNavigationController()

		// In order to get a proper animation when opening and closing documents, the DocumentViewController needs a custom view controller
		// transition. The `UIDocumentBrowserViewController` provides a `transitionController`, which takes care of the zoom animation. Therefore, the
		// `UIDocumentBrowserViewController` is registered as the `transitioningDelegate` of the `CanvasViewController`. Next, obtain the
		// transitionController, and store it for later (see `animationController(forPresented:presenting:source:)` and
		// `animationController(forDismissed:)`).
		if #available(iOS 12.0, *) {
			transitionController = transitionController(forDocumentAt: document.fileURL)
		} else {
			transitionController = transitionController(forDocumentURL: document.fileURL)
		}
		transitionController?.targetView = canvasViewController.hcSafeAreaView

		nc.transitioningDelegate = self
		nc.modalPresentationStyle = .fullScreen


		// Now load the contents of the presented document, and once that is done, present the `CanvasViewController` instance.
		// In order for the transition animation to work, the transition controller needs a view to zoom into, which is the particle system on the
		// left side of the main application user interface.
		canvasViewController.setInitialDocument(document, completion: {
			self.transitionController?.targetView = canvasViewController.hcSafeAreaView
			self.present(nc, animated: animated, completion: nil)
		})
	}

	private func presentDocument_failureOpeningDocument(document: Document) {
		log.error("Failed to open document.\ndocumentState: \(document.documentState.td_humanReadable)\nfileURL: \(document.fileURL)")

		let message: String
		if let error: Error = document.handleError_latestError {
			document.clearLatestError()
			message = "\(type(of: error)) '\(error)'"
		} else {
			message = "Unknown error. Expected handleError to provide an error, but got none!"
		}

		let alertController = UIAlertController(
			title: "Cannot Open",
			message: message,
			preferredStyle: .alert
		)
		alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))

		self.present(alertController, animated: true, completion: nil)
	}
}

extension BrowserViewController: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// Since the `UIDocumentBrowserViewController` has been set up to be the transitioning delegate of `CanvasViewController` instances (see
		// implementation of `presentDocument(at:)`), it is being asked for a transition controller.
		// Therefore, return the transition controller, that previously was obtained from the `UIDocumentBrowserViewController` when a
		// `CanvasViewController` instance was presented.
		return transitionController
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// The same zoom transition is needed when closing documents and returning to the `UIDocumentBrowserViewController`, which is why the the
		// existing transition controller is returned here as well.
		return transitionController
	}
}
