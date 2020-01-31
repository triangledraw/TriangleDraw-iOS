// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension CanvasViewController {
	func configureToolbar() {
		guard let toolbar: HCToolbar = self.hcToolbar else {
			fatalError()
		}
		let handlers = HCToolbarHandlers()
		handlers.onInvert = { [weak self] in
			self?.invertPixels()
		}
		handlers.onRotateCCW = { [weak self] in
			self?.rotateCCW()
		}
		handlers.onRotateCW = { [weak self] in
			self?.rotateCW()
		}
		handlers.onFlipX = { [weak self] in
			self?.flipX()
		}
		handlers.onFlipY = { [weak self] in
			self?.flipY()
		}
		handlers.onMoveLeft = { [weak self] in
			self?.moveLeft()
		}
		handlers.onMoveRight = { [weak self] in
			self?.moveRight()
		}
		handlers.onMoveUp = { [weak self] in
			self?.moveUp()
		}
		handlers.onMoveDown = { [weak self] in
			self?.moveDown()
		}
		toolbar.install(viewController: self, handlers: handlers)
	}
}
