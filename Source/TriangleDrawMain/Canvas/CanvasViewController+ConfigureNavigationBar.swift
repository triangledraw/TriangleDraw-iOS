// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension CanvasViewController {
	func configureNavigationBar() {
		// Left side of the navigation bar
		do {
			let item0 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CanvasViewController.doneButtonTaped))
			let item1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
			if Platform.is_ideom_ipad {
				item1.width = 40
			} else {
				item1.width = 20
			}
			let item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.undo, target: self, action: #selector(undoButtonAction))
			undoBarButtonItem = item2
			let item3 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
			if Platform.is_ideom_ipad {
				item3.width = 20
			} else {
				item3.width = 20
			}
			let item4 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.redo, target: self, action: #selector(redoButtonAction))
			redoBarButtonItem = item4
			let item5 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
			if Platform.is_ideom_ipad {
				item5.width = 40
			} else {
				item5.width = 20
			}
			let item6 = UIBarButtonItem(title: "Debug", style: .plain, target: self, action: #selector(debugButtonAction))
			var items: [UIBarButtonItem] = [item0, item1, item2, item3, item4]
			if AppConstant.Canvas.Interaction.installDebugButton {
				items.append(item5)
				items.append(item6)
			}
			navigationItem.leftBarButtonItems = items
			navigationItem.setHidesBackButton(true, animated: true)
		}
		// Right side of the navigation bar
		do {
			let item0 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(menuAction(_:)))
			menuBarButtonItem = item0
			let item1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
			if Platform.is_ideom_ipad {
				item1.width = 20
			} else {
				item1.width = 20
			}
			let item2 = UIBarButtonItem(image: Image.canvas_enterFullscreen.image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(enterFullscreenAction))
			navigationItem.rightBarButtonItems = [item2, item1, item0]
		}
	}
}
