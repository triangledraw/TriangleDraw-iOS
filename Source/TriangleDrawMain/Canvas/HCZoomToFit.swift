// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics
import UIKit
import TriangleDrawLibrary

extension HCRenderer {
	/// Center the drawing on the display
	func zoomToFit(viewSize: CGSize, uiInsets: UIEdgeInsets, margin: CGFloat) {
		let rule = HCZoomToFitRuleImpl(hcRenderer: self)
		let zoomToFit = HCZoomToFit(rule: rule)
		zoomToFit.execute(viewSize: viewSize, uiInsets: uiInsets, margin: margin)
	}
}

protocol HCZoomToFitRule {
	/// Invoked once, when it's not possible to compute the optimal scale and position
	func error(_ message: String)

	/// Invoked once. Determine the bounding box of the user content.
	func findBoundingBox() -> E2CanvasBoundingBox?

	/// Invoked once after everything have gone smooth
	func saveResult(scale: CGFloat, position: CGPoint)
}

class HCZoomToFitRuleImpl: HCZoomToFitRule {
	let hcRenderer: HCRenderer
	init(hcRenderer: HCRenderer) {
		self.hcRenderer = hcRenderer
	}

	func error(_ message: String) {
		log.error(message)
	}

	func findBoundingBox() -> E2CanvasBoundingBox? {
		let canvas: E2Canvas = hcRenderer.canvas
		guard canvas.width == AppConstant.CanvasFileFormat.width * 2 else {
			log.error("Expected canvas.width to be \(AppConstant.CanvasFileFormat.width) * 2, but got \(canvas.width)")
			return nil
		}
		guard canvas.height == AppConstant.CanvasFileFormat.height else {
			log.error("Expected canvas.height to be \(AppConstant.CanvasFileFormat.height), but got \(canvas.height)")
			return nil
		}
		let boundingBoxFinder = E2CanvasBoundingBoxFinder(canvas: canvas)
		guard let boundingBox: E2CanvasBoundingBox = boundingBoxFinder.result() else {
			log.error("Unable to determine bounding box of canvas")
			return nil
		}
		return boundingBox
	}

	/// Assign scale+position to `HCRenderer.scrollAndZoom`, so that the drawing is centered on the display.
	func saveResult(scale: CGFloat, position: CGPoint) {
		hcRenderer.scrollAndZoom.position = position
		hcRenderer.scrollAndZoom.scale = scale
	}
}

class HCZoomToFit {
	static let debug = false

	let rule: HCZoomToFitRule
	init(rule: HCZoomToFitRule) {
		self.rule = rule
	}

	/// Compute the optimal scale+translation, in order to center the drawing on the display.
	///
	///
	/// - parameter viewSize: TriangleDraw is a universal app, so the display can be both iPhone and iPad.
	///                       The screen can be in splitscreen mode. Landscape mode. Portrait mode.
	///                       Another app can insert an additional bar ontop of the navigationbar.
	///
	/// - parameter uiInsets: Screen estate covered up by statusbar + navigationbar + toolbar
	///                       (semi-transparent UI controls).
	///
	/// - parameter margin:   Minimum spacing around the drawing.
	///                       It doesn't look nice with a zero margin around the drawing.
	///                       A `10px` margin can do wonders.
	///
	///
	/// Examples of `viewSize`:
	///
	///       1366 x 1024, iPadPro landscape
	///       678 x 1024,  iPadPro landscape splitscreen
	///       1024 x 1366, iPadPro portrait
	///       639 x 1366,  iPadPro portrait splitscreen
	///       375 x 667,   iPhone6S
	///       375 x 647,   iPhone6S with additional bar ontop of the navigationbar
	///
	/// Examples of `uiInserts`:
	///
	///        UIEdgeInsets.zero, for fullscreen mode without visible statusbar + navigationbar + toolbar
	///        UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0), for iPadPro
	///        UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0), for iPhone6S
	///
	func execute(viewSize: CGSize, uiInsets: UIEdgeInsets, margin: CGFloat) {
		let debug: Bool = type(of: self).debug
		guard viewSize.width > 1 && viewSize.height > 1 else {
			rule.error("Expected viewSize to be positive, but got: \(viewSize)")
			return
		}
		guard uiInsets.top >= 0 && uiInsets.bottom >= 0 && uiInsets.left >= 0 && uiInsets.right >= 0 else {
			rule.error("Expected uiInsets to be non-negative, but got: \(uiInsets)")
			return
		}
		guard margin >= 0 else {
			rule.error("Expected margin to be non-negative, but got: \(margin)")
			return
		}
		let insets: UIEdgeInsets = uiInsets.insetsByAdding(margin)
		guard insets.top >= 0 && insets.bottom >= 0 && insets.left >= 0 && insets.right >= 0 else {
			rule.error("Expected insets to be non-negative, but got: \(insets)")
			return
		}

		// Deal with the screen estate taken up by statusbar + navigationbar + toolbar
		let viewSizeInsetted: CGSize = viewSize.inset(by: insets)
		if debug {
			log.debug("viewSizeInsetted: \(viewSizeInsetted)   viewSize: \(viewSize)   insets: \(insets)")
		}

		guard viewSizeInsetted.width > 1 && viewSizeInsetted.height > 1 else {
			rule.error("Expected viewSizeInsetted to be positive, but got: \(viewSizeInsetted)")
			return
		}

		let minScale: CGFloat = CGFloat(viewSize.minValue) * CGFloat(AppConstant.Canvas.minZoom)
		let maxScale: CGFloat = CGFloat(viewSize.maxValue) * CGFloat(AppConstant.Canvas.maxZoom)
		if debug {
			log.debug("minScale: \(minScale.string2)  maxScale: \(maxScale.string2)")
		}

		guard let boundingBox: E2CanvasBoundingBox = rule.findBoundingBox() else {
			rule.error("Unable to determine bounding box of canvas")
			return
		}
		if debug {
			log.debug("boundingBox: \(String(reflecting: boundingBox))")
		}

		let x: Float = remap(boundingBox.midX, Float(0), Float(AppConstant.CanvasFileFormat.width*2), Float(-1), Float(1))
		let y: Float = remap(boundingBox.midY, Float(0), Float(AppConstant.CanvasFileFormat.height), Float(-1), Float(1))
		if debug {
			log.debug("x: \(x.string2)  y: \(y.string2)")
		}

		let fittedRect: CGRect = boundingBox.fitInside(viewSizeInsetted)
		if debug {
			log.debug("fittedRect: \(fittedRect)")
		}

		let vertexCount: UInt = AppConstant.CanvasFileFormat.visibleArea_edgeCount + 1
		let vertexCount2 = Double(vertexCount * 2)
		let canvasWidthRatio = vertexCount2 / Double(boundingBox.width)
		let rawScale = CGFloat(Double(fittedRect.size.width) * canvasWidthRatio)


		let scale: CGFloat = clamp(rawScale, minScale, maxScale)

		if rawScale < minScale {
			log.error("clamped rawScale \(rawScale.string2) to minScale \(minScale.string2)")
		} else {
			if rawScale > maxScale {
				log.error("clamped rawScale \(rawScale.string2) to maxScale \(maxScale.string2)")
			} else {
				if debug {
					log.debug("rawScale is good. Didn't perform any clamping.")
				}
			}
		}

		let positionX: CGFloat = CGFloat(x) * scale
		let positionY: CGFloat = CGFloat(y) * scale
		let positionXYScaled = CGPoint(x: -positionX, y: positionY)
		let position = positionXYScaled.offset(
			(insets.left - insets.right) / 2.0,
			-(insets.top - insets.bottom) / 2.0
		)
		if debug {
			log.debug("scale: \(scale.string2)    position: \(position.string2)")
		}
		rule.saveResult(scale: scale, position: position)
	}
}

extension E2CanvasBoundingBox {
	func fitInside(_ containerSize: CGSize) -> CGRect {
		let canvasSize: CGSize = CGSize.sizeOfHexagonCanvas(width: self.width, height: self.height)
		return CGRect.fitSizeInSize(size: canvasSize, fit: containerSize)
	}
}

extension CGSize {
	static func sizeOfHexagonCanvas(width: UInt, height: UInt) -> CGSize {
		return CGSize(
			width: CGFloat(width) / 2,
			height: CGFloat(height) * CGFloat(AppConstant.Canvas.hexagonApothem)
		)
	}
}
