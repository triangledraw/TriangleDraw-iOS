// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit

/// Semitransparent with blurry background.
class CanvasNavigationController: UINavigationController {

    func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .dark)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
