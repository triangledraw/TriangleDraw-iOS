// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension CanvasViewController {
	@objc func invertPixels() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_INVERT", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The invert-color operations undo/redo name")
		registerForUndo(#selector(invertPixels), actionName)
		document?.canvas?.invertPixels()
		document?.canvas?.clearPixelsOutsideHexagon()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func rotateCCW() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_ROTATE_60_CLOCKWISE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The rotate 60 degree clockwise operations undo/redo name")
		registerForUndo(#selector(rotateCW), actionName)
		drawingView?.rotateAnimation(degrees: 60) { [weak self] in
			self?.didRotateCCW()
		}
		log.debug("leave")
	}

	fileprivate func didRotateCCW() {
		document?.canvas?.rotateClockwise()
		drawingView?.canvas = document?.canvas
		enableInteraction()
	}

	@objc func rotateCW() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_ROTATE_60_COUNTERCLOCKWISE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The rotate 60 degree counter-clockwise operations undo/redo name")
		registerForUndo(#selector(rotateCCW), actionName)
		drawingView?.rotateAnimation(degrees: -60) { [weak self] in
			self?.didRotateCW()
		}
		log.debug("leave")
	}

	fileprivate func didRotateCW() {
		document?.canvas?.rotateCounterClockwise()
		drawingView?.canvas = document?.canvas
		enableInteraction()
	}

	@objc func flipX() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_FLIP_X", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The mirror horizontally operations undo/redo name")
		registerForUndo(#selector(flipX), actionName)
		document?.canvas?.flipX()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func flipY() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_FLIP_Y", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The mirror vertically operations undo/redo name")
		registerForUndo(#selector(flipY), actionName)
		document?.canvas?.flipY()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func moveLeft() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_MOVE_LEFT", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The adjust offset left operations undo/redo name")
		registerForUndo(#selector(moveRight), actionName)
		document?.canvas?.moveLeft()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func moveRight() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_MOVE_RIGHT", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The adjust offset right operations undo/redo name")
		registerForUndo(#selector(moveLeft), actionName)
		document?.canvas?.moveRight()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func moveUp() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_MOVE_UP", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The adjust offset upward operations undo/redo name")
		registerForUndo(#selector(moveDown), actionName)
		document?.canvas?.moveUp()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}

	@objc func moveDown() {
		log.debug("enter")
		disableInteraction()
		let actionName = NSLocalizedString("OPERATION_MOVE_DOWN", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The adjust offset downward operations undo/redo name")
		registerForUndo(#selector(moveUp), actionName)
		document?.canvas?.moveDown()
		drawingView?.canvas = document?.canvas
		enableInteraction()
		log.debug("leave")
	}
}
