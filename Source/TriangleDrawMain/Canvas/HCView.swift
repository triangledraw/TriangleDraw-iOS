// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

/// `HCView` aka. Hexagon Canvas View
class HCView: UIView, TDCanvasDrawingProtocol {

	var metalView: HCMetalView?

	func canvasGridModeDidChange() {
		guard window != nil else {
			return
		}
		guard metalView != nil else {
			return
		}
		var originalScrollAndZoom = HCScrollAndZoom()
		if let renderer = metalView?.renderer {
			originalScrollAndZoom = renderer.scrollAndZoom
		}

		removeOurSubviews()
		addOurSubviews()

		if let canvas: E2Canvas = self._canvas {
			metalView?.renderer?.canvas = canvas
		}
		if let renderer = metalView?.renderer {
			renderer.scrollAndZoom = originalScrollAndZoom
		}
	}

	override func didMoveToWindow() {
		super.didMoveToWindow()
		if window != nil {
			installCanvas()
			addOurSubviews()
		} else {
			removeOurSubviews()
		}
	}

	func addOurSubviews() {
		let filledCircleMode: HCFilledCircleMode = CanvasGridModeController().currentCanvasGridMode.filledCircleMode

		let metalView: HCMetalView
		do {
			metalView = try HCMetalView.create(frame: CGRect.zero, filledCircleMode: filledCircleMode)
		} catch {
			#if targetEnvironment(simulator)
				log.error("Expected a device, but got nil. Metal is not available on older simulators (pre iOS13). Metal works in iOS13 or newer simulators. Error: \(error)")
			#else
				log.error("Expected a device, but got nil. Metal is not supported by this device! Error: \(error)")
			#endif
			return
		}
		self.metalView = metalView
		addSubview(metalView)
	}

	func removeOurSubviews() {
		if let view = metalView {
			view.removeFromSuperview()
			metalView = nil
		}
	}

	func installCanvas() {
		maskCanvas = E2Canvas.bigCanvasMask()
		guard maskCanvas != nil else {
			fatalError("Expected maskCanvas to be non-nil, but got nil")
		}
		if canvas == nil {
			log.error("Expected canvas to be non-nil, but got nil. Creating a dummy canvas")
			canvas = DocumentExample.triangledrawLogo.canvas
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		metalView?.frame = bounds
	}

	// MARK: - TDCanvasDrawingProtocol

	var onTapBlock: TDCanvasDrawing_TapBlock?
	var onBeforeDrawBlock: TDCanvasDrawing_BeforeDrawBlock?
	var onDrawBlock: TDCanvasDrawing_DrawBlock?
	var onAfterDrawBlock: TDCanvasDrawing_AfterDrawBlock?
	var hideLabels: Bool = false
	var maskCanvas: E2Canvas?

	var _canvas: E2Canvas?
	var canvas: E2Canvas? {
		get {
			return _canvas
		}
		set(newCanvas) {
			_canvas = newCanvas
			guard let nonNilCanvas: E2Canvas = newCanvas else {
				log.error("Expected newCanvas to be non-nil, but got nil")
				return
			}
			metalView?.renderer?.canvas = nonNilCanvas
		}
	}

	func rotateAnimation(degrees: Int, completionBlock: @escaping TDCanvasDrawing_RotateCompletionBlock) {
		guard let metalView: HCMetalView = self.metalView else {
			log.error("Expected self.metalView to be non-nil, but got nil")
			completionBlock()
			return
		}
		guard let renderer: HCRenderer = metalView.renderer else {
			log.error("Expected metalView.renderer to be non-nil, but got nil")
			completionBlock()
			return
		}
		renderer.performRotateOperation(metalView: metalView, degrees: degrees) {
			completionBlock()
		}
	}
}

extension HCView: HCInteractionViewDelegate {
	func interactionView_scroll(_ view: HCInteractionView, panGestureRecognizer: UIPanGestureRecognizer) {
		metalView?.interactionView_scroll(view, panGestureRecognizer: panGestureRecognizer)
	}

	func interactionView_draw(_ view: HCInteractionView, panGestureRecognizer: UIPanGestureRecognizer) {
		metalView?.interactionView_draw(view, panGestureRecognizer: panGestureRecognizer)
	}

	func interactionView_zoom(_ view: HCInteractionView, pinchGestureRecognizer: UIPinchGestureRecognizer) {
		metalView?.interactionView_zoom(view, pinchGestureRecognizer: pinchGestureRecognizer)
	}

	func interactionView_tap(_ view: HCInteractionView, tapGestureRecognizer: UITapGestureRecognizer) {
		metalView?.interactionView_tap(view, tapGestureRecognizer: tapGestureRecognizer)
	}
}

extension CanvasGridMode {
	fileprivate var filledCircleMode: HCFilledCircleMode {
		switch self {
		case .smallFixedSizeDots:
			return HCFilledCircleMode.fixedSize
		case .bigZoomableDots:
			return HCFilledCircleMode.variableSize
		}
	}
}
