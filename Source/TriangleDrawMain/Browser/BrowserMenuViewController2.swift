// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import SwiftUI
import UIKit

final class BrowserMenuViewController2: UIHostingController<BrowserMenuNavigationView> {
	init() {
		super.init(rootView: BrowserMenuNavigationView())
        rootView.dismissAction = dismissAction
	}

    required init?(coder: NSCoder) {
		fatalError()
    }

	static func create() -> UIViewController {
		let vc = BrowserMenuViewController2()
		vc.modalTransitionStyle = .crossDissolve
		vc.modalPresentationStyle = .formSheet
		return vc
	}

    private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}
