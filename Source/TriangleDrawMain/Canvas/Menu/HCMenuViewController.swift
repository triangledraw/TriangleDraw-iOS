// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit
import Foundation
import TriangleDrawLibrary
import MBProgressHUD
import SwiftUI

protocol HCMenuViewControllerDelegate: AnyObject {
	func hcMenuViewController_applySubdivide(n: UInt8)
	func hcMenuViewController_canvasGridModeDidChange(gridMode: CanvasGridMode)
}

enum HexagonCanvasMenuDocument {
	case document(document: Document)
	case mock
}

extension UIViewController {
	/// Open a menu with settings related to the canvas
	func td_presentHexagonCanvasMenu(document: HexagonCanvasMenuDocument = .mock, delegate: HCMenuViewControllerDelegate? = nil) {
		let nc = HCMenuViewController.create(document: document, delegate: delegate)
		self.present(nc, animated: true, completion: nil)
	}
}

struct HCMenuViewController {
    static func create(document: HexagonCanvasMenuDocument, delegate: HCMenuViewControllerDelegate?) -> UIViewController {
        let model = HCMenuViewModel.create()
        model.delegate = delegate

        switch document {
        case let .document(document):
            model.initialCanvas = document.canvas
            model.document_displayName = document.displayName
        case .mock:
            model.initialCanvas = DocumentExample.triangledrawLogo.canvas
            model.document_displayName = "Mock"
        }

        let rootView = HCMenuView(model: model)
        return UIHostingController(rootView: rootView)
    }
}
