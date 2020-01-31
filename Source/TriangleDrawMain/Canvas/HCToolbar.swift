// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

class HCToolbarHandlers {
	typealias ActionBlock = () -> ()

	var onInvert: ActionBlock = {}
	var onRotateCCW: ActionBlock = {}
	var onRotateCW: ActionBlock = {}
	var onFlipX: ActionBlock = {}
	var onFlipY: ActionBlock = {}
	var onMoveLeft: ActionBlock = {}
	var onMoveRight: ActionBlock = {}
	var onMoveUp: ActionBlock = {}
	var onMoveDown: ActionBlock = {}
}

/// `HCToolbar` aka. Hexagon Canvas Bottom Toolbar
class HCToolbar: UIToolbar {
	private var handlers: HCToolbarHandlers?
	private weak var viewController: UIViewController?

	func install(viewController: UIViewController, handlers: HCToolbarHandlers) {
		self.handlers = handlers
		self.viewController = viewController
		self.barStyle = .black
		self.items = self.createBarButtonItems()
	}

    static func create(viewController: UIViewController, handlers: HCToolbarHandlers) -> HCToolbar {
		let instance = HCToolbar()
		instance.install(viewController: viewController, handlers: handlers)
		return instance
    }

	private func createBarButtonItems() -> [UIBarButtonItem] {
		return createItems().map { barButtonItem(item: $0) }
	}

    private func createItems() -> [Item] {
        let is_iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        if is_iPad {
            // On iPad there is plenty of room
            return createItems_iPad()
        } else {
            // On iPhone/iPod Touch there is little of space
            return createItems_iPhone()
        }
    }

    private func createItems_iPad() -> [Item] {
		return [
			.moveLeft,
			.fixedSpace(width: 20),
			.moveRight,
			.flexibleSpace,
			.moveUp,
			.fixedSpace(width: 20),
			.moveDown,
			.flexibleSpace,
			.flipX,
			.fixedSpace(width: 20),
			.flipY,
			.flexibleSpace,
			.rotateCCW,
			.fixedSpace(width: 20),
			.rotateCW,
			.flexibleSpace,
			.invert,
		]
    }

	private func createItems_iPhone() -> [Item] {
		return [
			.moveLeft,
			.fixedSpace(width: 25),
			.moveRight,
			.fixedSpace(width: 25),
			.moveUp,
			.fixedSpace(width: 25),
			.moveDown,
			.flexibleSpace,
			.invert,
			.fixedSpace(width: 9),
			.showSheet
		]
	}

	private enum Item {
		case fixedSpace(width: CGFloat)
		case flexibleSpace
		case moveLeft
		case moveRight
		case moveUp
		case moveDown
		case flipX
		case flipY
		case rotateCCW
		case rotateCW
		case invert
		case showSheet
	}

	private func barButtonItem(item: Item) -> UIBarButtonItem {
		guard let handlers: HCToolbarHandlers = self.handlers else {
			fatalError("Expected handlers to be non-nil, but got nil")
		}

		switch item {
		case .fixedSpace(let width):
			let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
			barButtonItem.width = width
			return barButtonItem
		case .flexibleSpace:
			return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		case .moveLeft:
			return imageItem(Image.canvas_moveLeft, handlers.onMoveLeft)
		case .moveRight:
			return imageItem(Image.canvas_moveRight, handlers.onMoveRight)
		case .moveUp:
			return imageItem(Image.canvas_moveUp, handlers.onMoveUp)
		case .moveDown:
			return imageItem(Image.canvas_moveDown, handlers.onMoveDown)
		case .flipX:
			return imageItem(Image.canvas_flipX, handlers.onFlipX)
		case .flipY:
			return imageItem(Image.canvas_flipY, handlers.onFlipY)
		case .rotateCCW:
			return imageItem(Image.canvas_rotateCCW, handlers.onRotateCCW)
		case .rotateCW:
			return imageItem(Image.canvas_rotateCW, handlers.onRotateCW)
		case .invert:
			let title: String
			let is_iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
			if is_iPad {
				title = NSLocalizedString("BOTTOM_TOOLBAR_INVERT_iPad", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Button for inverting colors in navigationbar. (Only visible on iPad)")
			} else {
				title = NSLocalizedString("BOTTOM_TOOLBAR_INVERT_iPhone", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Button for inverting colors (Only visible on iPhone)")
			}
			return textItem(title, handlers.onInvert)
		case .showSheet:
			let title = NSLocalizedString("BOTTOM_TOOLBAR_MORE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Show an actionsheet (Only visible on iPhone)")
			return UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(action_showSheet))
		}
	}

	@objc func action_showSheet() {
		log.debug("show sheet")

		let alertControllerTitle = NSLocalizedString("MORE_ACTIONSHEET_TITLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Title of actionsheet (iPhone actionsheet)")
		let actionSheet: UIAlertController = UIAlertController(title: alertControllerTitle, message: nil, preferredStyle: .actionSheet)
		do {
			let title = NSLocalizedString("MORE_ACTIONSHEET_DISMISS", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Dismiss actionsheet (iPhone actionsheet)")
			let action = UIAlertAction(title: title, style: .cancel)
			actionSheet.addAction(action)
		}
		do {
			let title = NSLocalizedString("MORE_ACTIONSHEET_ROTATE_60_COUNTERCLOCKWISE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Rotate CounterClockWise 60 degree button in actionsheet (iPhone actionsheet)")
			let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
				self?.handlers?.onRotateCCW()
			}
			actionSheet.addAction(action)
		}
		do {
			let title = NSLocalizedString("MORE_ACTIONSHEET_ROTATE_60_CLOCKWISE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Rotate ClockWise 60 degree button in actionsheet (iPhone actionsheet)")
			let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
				self?.handlers?.onRotateCW()
			}
			actionSheet.addAction(action)
		}
		do {
			let title = NSLocalizedString("MORE_ACTIONSHEET_FLIP_X", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Flip horizontal button in actionsheet (iPhone actionsheet)")
			let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
				self?.handlers?.onFlipX()
			}
			actionSheet.addAction(action)
		}
		do {
			let title = NSLocalizedString("MORE_ACTIONSHEET_FLIP_Y", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "Flip vertical button in actionsheet (iPhone actionsheet)")
			let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
				self?.handlers?.onFlipY()
			}
			actionSheet.addAction(action)
		}

		viewController?.present(actionSheet, animated: true)
    }

	private func imageItem(_ image: Image, _ actionBlock: @escaping HCToolbarHandlers.ActionBlock) -> UIBarButtonItem {
		let barButtonItem = UIBarButtonItem(image: image.image, style: .plain, target: nil, action: nil)
		barButtonItem.actionClosure = { (_) in
			actionBlock()
		}
		return barButtonItem
	}

	private func textItem(_ title: String, _ actionBlock: @escaping HCToolbarHandlers.ActionBlock) -> UIBarButtonItem {
		let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
		barButtonItem.actionClosure = { (_) in
			actionBlock()
		}
		return barButtonItem
	}
}
