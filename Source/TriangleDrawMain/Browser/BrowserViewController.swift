// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

/**
# `UIDocumentBrowserViewController` provides developers with several features:

 - A system UI that all users will be able to recognize and use.
 - No need to write your own UI and associated logic to deal with file management locally or on iCloud.
 - Simple sharing of documents globally across the user’s account.
 - Fewer bugs because you are writing less code.

*/
class BrowserViewController: UIDocumentBrowserViewController {
	// Used for document presentation
	var transitionController: UIDocumentBrowserTransitionController?


	// This key is used to encode the bookmark data of the URL of the opened document as part of the state restoration data.
	static let bookmarkDataKey = "bookmarkData"

	override func viewDidLoad() {
		super.viewDidLoad()

		// The `UIDocumentBrowserViewController` needs a delegate that is notified about the user's interaction with their files.
		// In this case, the view controller itself is assigned as its delegate.
		delegate = self

		// Since the application allows creating Particles documents, document creation is enabled on the `UIDocumentBrowserViewController`.
		allowsDocumentCreation = true

		// In this application, selecting multiple items is not supported. Instead, only one document at a time can be opened.
		allowsPickingMultipleItems = false

		// Apple's "Numbers" app, looks great. It uses a "white" style and "green" tint.
		browserUserInterfaceStyle = .white
		view.tintColor = AppConstant.Browser.tintColor

		if AppConstant.Browser.debug_installCustomActions {
			installCustomActions()
		}

		menu_installMenuButton()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UserDefaults.standard.bool(forKey: "ScreenshotBrowserImportDocumentExamples") {
			importDocumentExamples()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		var initialViewController: AppConstant.App.InitialViewController = AppConstant.App.initialViewController
		if UserDefaults.standard.bool(forKey: "ScreenshotCanvasWithTriangleDrawLogo") {
			initialViewController = .screenshot_canvasWithTriangleDrawLogo
		}
		if UserDefaults.standard.bool(forKey: "ScreenshotCanvasWithRune") {
			initialViewController = .screenshot_canvasWithRune
		}



		switch initialViewController {
		case .production_browser:
			// The UIDocumentBrowserViewController has to be the 1st viewcontroller
			// and it works best when its initialized via the storyboard.
			// I have tried initializing it programmatically and it sporadically
			// mess up the statusbar. When initialized via the storyboard
			// then it happens sporadically, but less frequent.
			() // Do nothing since we are already in the DocumentBrowser
		case .screenshot_canvasWithTriangleDrawLogo:
			presentDocumentExample(DocumentExample.triangledrawLogo)
		case .screenshot_canvasWithRune:
			presentDocumentExample(DocumentExample.rune1)
		case .debug_canvasMenu:
			self.td_presentHexagonCanvasMenu()
		}
	}

	func installCustomActions() {
		// Define one custom `UIDocumentBrowserAction`, which will show up when interacting with a selection of items. In this case, the action is
		// configured to be presented both in the navigation bar of the `UIDocumentBrowserViewController`, and the menu controller, which appears
		// when long-pressing items.
		let action = UIDocumentBrowserAction(identifier: "com.triangledraw.td3.doc.export",
											 localizedTitle: "Export",
											 availability: [.menu, .navigationBar],
											 handler: { (_) in
												fatalError("Export as SVG")
		})

		// By specifying the supported content types of the action, the action can only be performed on Particles files, but not on any other type of
		// file.
		action.supportedContentTypes = ["com.triangledraw.td3.doc"]

		// Last but not least, the newly created action is assigned to the `UIDocumentBrowserViewController`.
		customActions = [action]
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {

		// Since the `UIDocumentBrowserViewController` is configured to use the "dark" browser user interface style, using the "lightContent" for the
		// status bar is a good choice.
		return UIStatusBarStyle.default
	}

	// MARK: Gear that opens a Menu

	func menu_installMenuButton() {
		let image: UIImage = Image.browser_gear.image
		let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menu_buttonAction))
		additionalLeadingNavigationBarButtonItems = [button]
	}

	@IBAction func menu_buttonAction() {
		let nc = BrowserMenuViewController.createInsideNavigationController()
		self.present(nc, animated: true, completion: nil)
	}


	// MARK: Live Indicator

	func liveIndicator_installButton() {
		let image: UIImage = TDLiveIndicator.render(tickArray: liveIndicator_tickArray.array, tickOffset: liveIndicator_timerTick)
		let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(liveIndicator_buttonAction))
		additionalLeadingNavigationBarButtonItems = [button]
	}

	@IBAction func liveIndicator_buttonAction() {
		liveIndicator_uninstallTimer()
		let nc = BrowserMenuViewController.createInsideNavigationController()
		self.present(nc, animated: true, completion: nil)
	}

	private var liveIndicator_tickArray = TDLiveIndicatorTickContainer()
	private var liveIndicator_timerTick: Int = 0
	private var liveIndicator_timer: Timer?

	private func liveIndicator_installTimer() {
		self.liveIndicator_timer?.invalidate()
		// If the frequency is too rapid, such as 10 times per second, then the user has no chance of tapping the UIBarButtonItem.
		// Installing a new UIBarButtonItem takes a long time.
		// On my iPhone6S I can max do it 2 times per second.
		let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(liveIndicator_timerUpdate), userInfo: nil, repeats: true)
		self.liveIndicator_timer = timer
	}

	private func liveIndicator_uninstallTimer() {
		self.liveIndicator_timer?.invalidate()
		self.liveIndicator_timer = nil
	}

	@objc func liveIndicator_timerUpdate() {
		guard self.liveIndicator_timer?.isValid == true else {
			log.error("timer has been invalidated")
			return
		}
		liveIndicator_timerTick += 1
		liveIndicator_tickArray.appendMockSample(tick: liveIndicator_timerTick)
		liveIndicator_installButton()
	}

	// MARK: State Preservation and Restoration

	override func encodeRestorableState(with coder: NSCoder) {

		// The system will call this method on the view controller when the application state needs to be preserved.
		// Encode relevant information using the coder instance, that is provided.

		if let canvasViewController = presentedViewController as? CanvasViewController,
			let documentURL = canvasViewController.document?.fileURL {
			do {
				// Obtain the bookmark data of the URL of the document that is currently presented, if there is any.
				let didStartAccessing = documentURL.startAccessingSecurityScopedResource()
				defer {
					if didStartAccessing {
						documentURL.stopAccessingSecurityScopedResource()
					}
				}
				let bookmarkData = try documentURL.bookmarkData()

				// Encode it with the coder.
				coder.encode(bookmarkData, forKey: BrowserViewController.bookmarkDataKey)

			} catch {
				// Make sure to handle the failure appropriately, e.g., by showing an alert to the user
				log.error("Failed to get bookmark data from URL \(documentURL): \(error)")
			}
		}

		super.encodeRestorableState(with: coder)
	}

	override func decodeRestorableState(with coder: NSCoder) {

		// This method is called when the system attempts to restore application state.
		// Try decoding the bookmark data, obtain a URL instance from it, and present the document.
		if let bookmarkData = coder.decodeObject(of: NSData.self, forKey: BrowserViewController.bookmarkDataKey) as Data? {
			do {
				var bookmarkDataIsStale: Bool = false
				let documentURL = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &bookmarkDataIsStale)
				presentDocument(
					at: documentURL,
					animated: false,
					displayNameBehavior: .extractFromURL
				)
			} catch {
				// Make sure to handle the failure appropriately, e.g., by showing an alert to the user
				log.error("Failed to create document URL from bookmark data: \(bookmarkData), error: \(error)")
			}
		}
		super.decodeRestorableState(with: coder)
	}
}


// MARK: UIDocumentBrowserViewControllerDelegate

extension BrowserViewController: UIDocumentBrowserViewControllerDelegate {
	/// Called when you select "Create Document" in the browser UI.
	func documentBrowser(_ controller: UIDocumentBrowserViewController,
						 didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {

		// When the user wants to create a new document, a blank version of a new Partiles file needs to be provided to the
		// `UIDocumentBrowserViewController`. In this case, obtain the URL of the "Drawing.triangleDraw", which is part of the application bundle, and
		// afterwards, perform the importHandler on the URL with a Copy operation.

		let url: URL = DocumentExample.blankFile.url
		log.debug("importHandler mode_copy with url: \(url)")
		importHandler(url, .copy)
	}

	/// Called when you select an existing document in the browser.
	func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
		guard let sourceURL = documentURLs.first else {
			log.error("Expected documentURLs to be non-empty. Cannot open document.")
			return
		}

		// When the user has chosen an existing document, a new `CanvasViewController` is presented for the first document that was picked.
		presentDocument(at: sourceURL, animated: true, displayNameBehavior: .extractFromURL)
	}

	/// Informs the delegate that a document has been imported into the file system.
	func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
		// Present a `CanvasViewController` for the new newly created document.
		presentDocument(at: destinationURL, animated: true, displayNameBehavior: .extractFromURL)
	}

	/// Informs the delegate that an import action failed.
	func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
		// Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
		if let error = error {
			log.error("documentURL: '\(documentURL)'  error: '\(error)'")
		} else {
			log.error("documentURL: '\(documentURL)'  error: nil")
		}
	}

	func documentBrowser(_ controller: UIDocumentBrowserViewController, applicationActivitiesForDocumentURLs documentURLs: [URL]) -> [UIActivity] {
		// Whenever one or more items are being shared by the user, the default activities of the `UIDocumentBrowserViewController` can be augmented
		// with custom ones. In this case, no additional activities are added.
		return []
	}

}
