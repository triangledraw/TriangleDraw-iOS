// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary
import RadiantForms

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

	static var shared: AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}

// MARK: -
// MARK: Application lifecycle

    class func resetAppleLanguagesAfterUnittest() {
        /* Recover after running unittests
        	 The unittests sets 'AppleLanguages' in order to exercise localization.
        	 However 'AppleLanguages' leaves the simulator in a messed up state.
        	 Where the user language preferences are ignored.
        	 Thus I reset the userdefaults whenever it seems that
        	 'AppleLanguages' was force overwriting the users langauge settings.
        	 */
        if SystemInfo.areWeBeingUnitTested {
            log.debug("We are being unittested")
            // We are running unittests.
        } else {
            log.debug("We are not being unittested")
			let value: Any? = UserDefaults.standard.object(forKey: "AppleLanguages")
			log.debug("AppleLanguages: \(String(describing: value))")
            if let ary = value as? [Any] {
                let wasForceOverwritten: Bool = ary.isEmpty
                if wasForceOverwritten {
                    // Recover, by undoing the messed up state from running unittests
                    log.debug("removing '\(String(describing: value))' for key 'AppleLanguages'")
                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    UserDefaults.standard.synchronize()
                    log.debug("You must re-run the app again for the new settings to take effect")
                    exit(-1)
                }
            }
        }
    }

    func trackLaunch() {
        let runCount: Int = UserDefaults.standard.td_runCount()
        trackActivation(runCount)
    }

	func configureForms() {
		let builder = RFThemeBuilder.light
		builder.tintColor = AppConstant.Browser.tintColor
	}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		LogHelper.setup_mainExecutable()

		//AppDelegate.resetAppleLanguagesAfterUnittest()

		configureForms()
        dumpSystemInfo()
        trackLaunch()

        // Increment the number of times this app has been started successfully
        UserDefaults.standard.td_incrementRunCount()
		if let appUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
			log.debug("app dir: \(appUrl)")
		}
        log.debug("application:didFinishLaunchingWithOptions:")
        return true
    }

    func dumpSystemInfo() {
        log.debug(SystemInfo.systemInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        log.debug("applicationWillResignActive:")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        log.debug("applicationDidBecomeActive:")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        log.debug("applicationWillEnterForeground:")
        trackLaunch()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        log.debug("applicationWillTerminate:")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        //log.debug(@"applicationDidReceiveMemoryWarning:");
    }

	func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

		// This delegate method is invoked when the Particles app is externally asked to open a document at a specific URL.
		// Ensure that the URL is an actual file URL.
		guard inputURL.isFileURL else {
			log.error("Expected file:// url, but got: \(inputURL)")
			return false
		}

		// Next, obtain the `UIDocumentBrowserViewController` instance of the application, in order to be able to invoke the
		// `revealDocument(at:,importIfNeeded:completion:)` method with the given URL.
		// The `UIDocumentBrowserViewController` will prepare the file at the URL, and notify once the document is ready to be presented, which in
		// this case is making a call to the `presentDocument(at:)` method, similarly to when opening documents chosen by the user from within the
		// application.
		guard let browserViewController = window?.rootViewController as? BrowserViewController else {
			log.error("Expected rootViewController to be of type BrowserViewController")
			return false
		}
		
		browserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
			if let error = error {
				// Handle the error appropriately
				log.error("Failed to reveal document at URL \(inputURL), error: '\(error)'")

				let alertController = UIAlertController(title: "An error occurred",
														message: "The app was unable to reveal a document.",
														preferredStyle: .alert)
				browserViewController.present(alertController, animated: true, completion: nil)

				return
			}

			// Present the Document View Controller for the revealed URL.
			browserViewController.presentDocument(
				at: revealedDocumentURL!,
				animated: true,
				displayNameBehavior: .extractFromURL
			)
		}

		return true
	}

	func trackActivation(_ runCount: Int) {
		log.debug("TriangleDrawMain executable Launch. runCount: \(runCount)")
	}

	// MARK: State Preservation and Restoration

	// See also `encodeRestorableState(with:)` and `decodeRestorableState(with:)` in the implementation of `UIDocumentBrowserViewController`.

	func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {

		// This delegate method is called by the system when dealing with application state preservation and restoration.
		// Return true in order to indicate that the application state should be preserved.
		return true
	}

	func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {

		// Similarly, return true in order to indicate that the application should attempt to restore the saved application state.
		return true
	}
}
