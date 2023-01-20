// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit
import SwiftUI

struct BrowserMenuViewController {
    static func createInsideNavigationController() -> UIViewController {
        let model = BrowserMenuViewModel.create()
        return UIHostingController(rootView: BrowserMenuView(model: model))
    }
}
