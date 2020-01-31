// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension HCMetalView: HCInteractionViewDelegate {
	func canvasPointFromScreenPosition(_ screenPosition: CGPoint) -> CGPoint {
		guard let renderer: HCRenderer = self.renderer else {
			log.error("Expected renderer to be non-nil, but got nil")
			return CGPoint.zero
		}

		let size: CGSize = self.bounds.size
		let halfWidth = size.width / 2
		let halfHeight = size.height / 2

		let x: CGFloat = screenPosition.x - halfWidth
		let y: CGFloat = -(screenPosition.y - halfHeight)  // flip Y coordinate

		let pos: CGPoint = renderer.scrollAndZoom.position
		let xx = x - pos.x
		let yy = y - pos.y

		let scale: CGFloat = renderer.scrollAndZoom.scale * 2
		let xxx: CGFloat = xx / scale
		let yyy: CGFloat = -(yy / scale) // flip Y coordinate, back

		let px: CGFloat = remap(xxx, -0.5, 0.5, 0, 1)
		let py: CGFloat = remap(yyy, -0.5, 0.5, 0, 1)
		return CGPoint(x: px, y: py)
	}

	func interactionView_scroll(_ view: HCInteractionView, panGestureRecognizer recognizer: UIPanGestureRecognizer) {
		guard let renderer: HCRenderer = self.renderer else {
			log.error("Expected renderer to be non-nil, but got nil")
			return
		}
		let translation: CGPoint = recognizer.translation(in: self)
		recognizer.setTranslation(CGPoint.zero, in: self)
		renderer.scrollAndZoom.position = renderer.scrollAndZoom.position.offset(translation.flipY)   // flip Y coordinate
		renderer.scrollAndZoom.clampPosition()
//		print("renderer.scrollAndZoom.position: \(renderer.scrollAndZoom.position.string0)")
	}

	func interactionView_draw(_ view: HCInteractionView, panGestureRecognizer recognizer: UIPanGestureRecognizer) {
		guard let hcView: HCView = self.hcView else {
			let t = type(of: self.superview)
			fatalError("Expected HCMetalView.superview to be HCView, but got something else. \(t)")
		}
		guard let canvas: E2Canvas = hcView.canvas else {
			fatalError("Expected HCView.canvas to be non-nil, but got nil")
		}

		if recognizer.state == .began {
			hcView.onBeforeDrawBlock?()
		}
		if recognizer.state == .ended {
			hcView.onAfterDrawBlock?()
		}
		if recognizer.state == .began || recognizer.state == .changed {
			let screenPosition: CGPoint = recognizer.location(in: self)
			let point: CGPoint = canvasPointFromScreenPosition(screenPosition)
			let index: E2CanvasPoint = canvas.canvasPoint(from: point)
			if AppConstant.Canvas.Interaction.debug_drawLineGesture {
				log.debug("point: \(point.string2)  index: \(index)")
			}
			if recognizer.state == .began {
				hcView.onDrawBlock?(hcView, point, index, true)
			} else {
				hcView.onDrawBlock?(hcView, point, index, false)
			}
			recognizer.setTranslation(CGPoint.zero, in: self)
		}
	}

	func interactionView_tap(_ view: HCInteractionView, tapGestureRecognizer recognizer: UITapGestureRecognizer) {
		if recognizer.state == .ended {
			let screenPosition: CGPoint = recognizer.location(in: view)
			let screenPosition2 = view.convert(screenPosition, to: self)
			tdiv_tap(view, screenPosition: screenPosition2)
		}
	}

	func tdiv_tap(_ view: HCInteractionView, screenPosition: CGPoint) {
		let point: CGPoint = canvasPointFromScreenPosition(screenPosition)
		guard let hcView: HCView = self.hcView else {
			let t = type(of: self.superview)
			log.error("Expected HCMetalView.superview to be HCView, but got something else. \(t)")
			return
		}
		guard let canvas: E2Canvas = hcView.canvas else {
			log.error("Expected HCView.canvas to be non-nil, but got nil")
			return
		}
		guard let maskCanvas: E2Canvas = hcView.maskCanvas else {
			log.error("Expected HCView.maskCanvas to be non-nil, but got nil")
			return
		}

		let index: E2CanvasPoint = canvas.canvasPoint(from: point)
		let mask_value: UInt8 = maskCanvas.getPixel(index)
		if AppConstant.Canvas.Interaction.debug_tapGesture {
			log.debug("screen: \(screenPosition.string0)   point: \(point.string2)  index: \(index)  mask_value: \(mask_value)  orientation: \(index.orientation)")
		}

		if mask_value > 0 {

			if AppConstant.Canvas.Interaction.experimentsWith3Color {
				let value: UInt8 = canvas.getPixel(index)
				let newValue: UInt8
				if value == 0 {
					newValue = 1
				} else {
					if value == 1 {
						newValue = 2
					} else {
						newValue = 0
					}
				}

				canvas.setRawPixel(index, value: newValue)

				self.renderer?.canvasNeedsDraw = true
				return
			}

			hcView.onTapBlock?(hcView, index)
		}
	}

	func interactionView_zoom(_ view: HCInteractionView, pinchGestureRecognizer recognizer: UIPinchGestureRecognizer) {
		let screenPosition: CGPoint = recognizer.location(in: view)
		let screenPosition2 = view.convert(screenPosition, to: self)
		if recognizer.state == .began {
			self.tdiv_pinch_began(view, screenPosition: screenPosition2)
		}
		if recognizer.state == .changed && recognizer.numberOfTouches == 2 {
			self.tdiv_pinch_changed(view, screenPosition: screenPosition2, scale: recognizer.scale)
			recognizer.scale = 1
		}
	}

	func tdiv_pinch_began(_ view: HCInteractionView, screenPosition: CGPoint) {
		guard let renderer: HCRenderer = self.renderer else {
			log.error("Expected renderer to be non-nil, but got nil")
			return
		}

		let size: CGSize = self.bounds.size
		let halfWidth = size.width / 2
		let halfHeight = size.height / 2

		let x: CGFloat = screenPosition.x - halfWidth
		let y: CGFloat = -(screenPosition.y - halfHeight)  // flip Y coordinate
		//print("x: \(x.string2)   y: \(y.string2)")

		let pos: CGPoint = renderer.scrollAndZoom.position
		let xx = x - pos.x
		let yy = y - pos.y
//		print("pinch began xx: \(xx.string2)   yy: \(yy.string2)")

		let scale: CGFloat = renderer.scrollAndZoom.scale * 2
		let xxx = xx / scale
		let yyy = yy / scale

//		print("pinch began xxx: \(xxx.string2)   yyy: \(yyy.string2)")
//		print("pinch began xx: \(xx.string2) / \(scale) = xxx: \(xxx.string2)")

		let objectSize: CGFloat = 2
		let i = xxx * objectSize
		let j = yyy * objectSize
//		print("i: \(i.string2)  j: \(j.string2)")
		renderer.scrollAndZoom.pinchCenter = CGPoint(x: i, y: j)
	}

	func tdiv_pinch_changed(_ view: HCInteractionView, screenPosition: CGPoint, scale: CGFloat) {
		guard let renderer: HCRenderer = self.renderer else {
			log.error("Expected renderer to be non-nil, but got nil")
			return
		}

		let size: CGSize = self.bounds.size

		let minScale: CGFloat = size.minValue * CGFloat(AppConstant.Canvas.minZoom)
		let maxScale: CGFloat = size.maxValue * CGFloat(AppConstant.Canvas.maxZoom)
		assert(minScale < maxScale)

		let halfWidth = size.width / 2
		let halfHeight = size.height / 2

		let x: CGFloat = screenPosition.x - halfWidth
		let y: CGFloat = -(screenPosition.y - halfHeight)  // flip Y coordinate
//		print("x: \(x.string2)   y: \(y.string2)")

		let oldScale: CGFloat = renderer.scrollAndZoom.scale
		let newScaleUnclamped: CGFloat = oldScale * scale
		let newScale: CGFloat = clamp(newScaleUnclamped, minScale, maxScale)

		let pinchCenter: CGPoint = renderer.scrollAndZoom.pinchCenter

		let offset = pinchCenter.scaleBy(newScale).flip
		let xy = CGPoint(x: x, y: y)
		let newPosition: CGPoint = xy.offset(offset)

		//log.debug("pinch changed.  position: \(newPosition.string2)   scale: \(newScale.string2)   size.minValue: \(size.minValue.string1)  size.maxValue: \(size.maxValue.string1)")
		renderer.scrollAndZoom.scale = newScale
		renderer.scrollAndZoom.position = newPosition
		renderer.scrollAndZoom.clampPosition()
	}
}
