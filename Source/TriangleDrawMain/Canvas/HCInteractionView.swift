// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

protocol HCInteractionViewDelegate: class {
	func interactionView_scroll(_ view: HCInteractionView, panGestureRecognizer: UIPanGestureRecognizer)
	func interactionView_draw(_ view: HCInteractionView, panGestureRecognizer: UIPanGestureRecognizer)
	func interactionView_zoom(_ view: HCInteractionView, pinchGestureRecognizer: UIPinchGestureRecognizer)
	func interactionView_tap(_ view: HCInteractionView, tapGestureRecognizer: UITapGestureRecognizer)
}

class HCInteractionView: UIView {
	weak var delegate: HCInteractionViewDelegate?

	// MARK: -  Gesture handling

	private var pinchGestureRecognizer: UIPinchGestureRecognizer?
	private var scroll_panGestureRecognizer: UIPanGestureRecognizer?
	private var draw_panGestureRecognizer: UIPanGestureRecognizer?
	private var tapGestureRecognizer: UITapGestureRecognizer?

	func installGestures() {
		do {
			let recognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
			addGestureRecognizer(recognizer)
			recognizer.delegate = self
			self.pinchGestureRecognizer = recognizer
		}
		do {
			let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction_scroll(_:)))
			recognizer.minimumNumberOfTouches = 2
			addGestureRecognizer(recognizer)
			recognizer.delegate = self
			self.scroll_panGestureRecognizer = recognizer
		}
		do {
			let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction_draw(_:)))
			recognizer.minimumNumberOfTouches = 1
			recognizer.maximumNumberOfTouches = 1
			addGestureRecognizer(recognizer)
			recognizer.delegate = self
			self.draw_panGestureRecognizer = recognizer
		}
		do {
			let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
			addGestureRecognizer(recognizer)
			recognizer.delegate = self
			self.tapGestureRecognizer = recognizer
		}
	}

	@objc func pinchAction(_ recognizer: UIPinchGestureRecognizer) {
		delegate?.interactionView_zoom(self, pinchGestureRecognizer: recognizer)
	}

	@objc func panAction_scroll(_ recognizer: UIPanGestureRecognizer) {
		delegate?.interactionView_scroll(self, panGestureRecognizer: recognizer)
	}

	@objc func panAction_draw(_ recognizer: UIPanGestureRecognizer) {
		delegate?.interactionView_draw(self, panGestureRecognizer: recognizer)
	}

	@objc func tapAction(_ recognizer: UITapGestureRecognizer) {
		delegate?.interactionView_tap(self, tapGestureRecognizer: recognizer)
	}
}

extension HCInteractionView: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == draw_panGestureRecognizer {
			return false
		}
		if otherGestureRecognizer == draw_panGestureRecognizer {
			return false
		}
		return true
	}
}
