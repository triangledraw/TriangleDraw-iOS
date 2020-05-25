// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

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

extension HCInteractionView: AcceptsVerboseInfoProvider {
	func verboseInfo(_ provider: VerboseInfoProvider) {
		let append = provider.append

		if self.delegate != nil {
			append("interactionView.delegate", "non-nil")
		} else {
			append("interactionView.delegate", "nil (This is possible an error state!)")
		}

		let frame: CGRect = self.frame
		append("interactionView.frame", "\(frame.origin.string1), \(frame.size.string1)")

		if let gr: UIPinchGestureRecognizer = self.pinchGestureRecognizer {
			append("interactionView.pinchGestureRecognizer.isEnabled", "\(gr.isEnabled)")
			append("interactionView.pinchGestureRecognizer.state", "\(gr.state.rawValue)")
			if gr.delegate != nil {
				append("interactionView.pinchGestureRecognizer.delegate", "non-nil")
			} else {
				append("interactionView.pinchGestureRecognizer.delegate", "nil (This is possible an error state!)")
			}
		} else {
			append("interactionView.pinchGestureRecognizer", "nil (This is possible an error state!)")
		}

		if let gr: UIPanGestureRecognizer = self.scroll_panGestureRecognizer {
			append("interactionView.scroll_panGestureRecognizer.isEnabled", "\(gr.isEnabled)")
			append("interactionView.scroll_panGestureRecognizer.state", "\(gr.state.rawValue)")
			if gr.delegate != nil {
				append("interactionView.scroll_panGestureRecognizer.delegate", "non-nil")
			} else {
				append("interactionView.scroll_panGestureRecognizer.delegate", "nil (This is possible an error state!)")
			}
		} else {
			append("interactionView.scroll_panGestureRecognizer", "nil (This is possible an error state!)")
		}

		if let gr: UIPanGestureRecognizer = self.draw_panGestureRecognizer {
			append("interactionView.draw_panGestureRecognizer.isEnabled", "\(gr.isEnabled)")
			append("interactionView.draw_panGestureRecognizer.state", "\(gr.state.rawValue)")
			if gr.delegate != nil {
				append("interactionView.draw_panGestureRecognizer.delegate", "non-nil")
			} else {
				append("interactionView.draw_panGestureRecognizer.delegate", "nil (This is possible an error state!)")
			}
		} else {
			append("interactionView.draw_panGestureRecognizer", "nil (This is possible an error state!)")
		}

		if let gr: UITapGestureRecognizer = self.tapGestureRecognizer {
			append("interactionView.tapGestureRecognizer.isEnabled", "\(gr.isEnabled)")
			append("interactionView.tapGestureRecognizer.state", "\(gr.state.rawValue)")
			if gr.delegate != nil {
				append("interactionView.tapGestureRecognizer.delegate", "non-nil")
			} else {
				append("interactionView.tapGestureRecognizer.delegate", "nil (This is possible an error state!)")
			}
		} else {
			append("interactionView.tapGestureRecognizer", "nil (This is possible an error state!)")
		}
	}
}
