// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension CanvasViewController {
	func configureHCView() {
		guard let view: TDCanvasDrawingView = self.hcView else {
			fatalError()
		}
		view.onTapBlock = { [weak self] canvasView, point in
			if let value = canvasView.canvas?.getPixel(point) {
				let toggledValue = (value > 0) ? 0 : 1
				self?.setPixel(point, value: UInt8(toggledValue))
			}
		}
		view.onBeforeDrawBlock = { [weak self] in
			self?.beginDrawing()
		}
		view.onAfterDrawBlock = { [weak self] in
			self?.endDrawing()
		}
		var stroke_value: UInt8 = 0
		view.onDrawBlock = { [weak self] canvasView, cgPoint, point, gestureBegin in
			guard let strongSelf = self else {
				log.error("Expected self to be non-nil, but got nil")
				return
			}
			if gestureBegin {
				if let value = canvasView.canvas?.getPixel(point) {
					stroke_value = (value > 0) ? 0 : 1
					strongSelf.last_cgpoint = cgPoint
				}
			}
			strongSelf.line(from: cgPoint, to: strongSelf.last_cgpoint, value: stroke_value)
			strongSelf.last_cgpoint = cgPoint
		}

		self.drawingView = self.hcView
	}
}
