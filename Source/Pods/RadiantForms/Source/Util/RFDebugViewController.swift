// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit
import WebKit

public enum RFDebugViewController_WhatToShow {
	case json(json: Data)
	case text(text: String)
	case url(url: URL)
}

/// Present various types of data: json, plain text, webpage
///
/// The data is shown in a webview.
///
/// This is only supposed to be used during development,
/// as a quick way to inspect data.
///
/// Usage:
///
/// 	RFDebugViewController.showURL(self, url: URL(string: "http://www.google.com")!)
/// 	RFDebugViewController.showText(self, text: "hello world")
///
public class RFDebugViewController: UIViewController {

	public let dismissBlock: () -> Void
	public let whatToShow: RFDebugViewController_WhatToShow

	public init(dismissBlock: @escaping () -> Void, whatToShow: RFDebugViewController_WhatToShow) {
		self.dismissBlock = dismissBlock
		self.whatToShow = whatToShow
		super.init(nibName: nil, bundle: nil)
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	public class func showJSON(_ parentViewController: UIViewController, jsonData: Data) {
		showModally(parentViewController, whatToShow: RFDebugViewController_WhatToShow.json(json: jsonData))
	}

	public class func showText(_ parentViewController: UIViewController, text: String) {
		showModally(parentViewController, whatToShow: RFDebugViewController_WhatToShow.text(text: text))
	}

	public class func showURL(_ parentViewController: UIViewController, url: URL) {
		showModally(parentViewController, whatToShow: RFDebugViewController_WhatToShow.url(url: url))
	}

	public class func showModally(_ parentViewController: UIViewController, whatToShow: RFDebugViewController_WhatToShow) {
		weak var weakSelf = parentViewController
		let dismissBlock: () -> Void = {
			if let vc = weakSelf {
				vc.dismiss(animated: true, completion: nil)
			}
		}

		let vc = RFDebugViewController(dismissBlock: dismissBlock, whatToShow: whatToShow)
		let nc = UINavigationController(rootViewController: vc)
		parentViewController.present(nc, animated: true, completion: nil)
	}

	public override func loadView() {
        let webview = WKWebView()
        self.view = webview

        let item = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(RFDebugViewController.dismissAction(_:)))
        self.navigationItem.leftBarButtonItem = item

        switch whatToShow {
        case let .json(json):
            let url = URL(string: "http://localhost")!
            webview.load(json, mimeType: "application/json", characterEncodingName: "utf-8", baseURL: url)
            self.title = "JSON"
        case let .text(text):
            let url = URL(string: "http://localhost")!
            let data = (text as NSString).data(using: String.Encoding.utf8.rawValue)!
            webview.load(data, mimeType: "text/plain", characterEncodingName: "utf-8", baseURL: url)
            self.title = "Text"
        case let .url(url):
            let request = URLRequest(url: url)
            webview.load(request)
            self.title = "URL"
        }
	}

	@objc func dismissAction(_ sender: AnyObject?) {
		dismissBlock()
	}
}

@available(*, unavailable, renamed: "RFDebugViewController")
typealias DebugViewController = RFDebugViewController

@available(*, unavailable, renamed: "RFDebugViewController_WhatToShow")
typealias WhatToShow = RFDebugViewController_WhatToShow
