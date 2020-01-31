// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public enum CanvasGridMode: String, CaseIterable {
	/// Tiny dots that are barely noticable with a size unaffected by the zoom level.
	case smallFixedSizeDots = "smallFixedSizeDots"

	/// Big dots that changes size depending on the zoom level.
	case bigZoomableDots = "bigZoomableDots"
}

extension CanvasGridMode {
	public var localizedDisplayName: String {
		switch self {
		case .smallFixedSizeDots:
			return "Small Dots"
		case .bigZoomableDots:
			return "Big Dots"
		}
	}
}

/// Keeps track of the users preferred `grid mode`.
class CanvasGridModeController {
    private(set) lazy var currentCanvasGridMode = loadCanvasGridMode()
    private let defaults: UserDefaults
    private let defaultsKey = "TRIANGLEDRAW_CANVASGRIDMODE"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func changeCanvasGridMode(to gridMode: CanvasGridMode) {
        currentCanvasGridMode = gridMode
        defaults.setValue(gridMode.rawValue, forKey: defaultsKey)
    }

    private func loadCanvasGridMode() -> CanvasGridMode {
		let rawValue: String? = defaults.string(forKey: defaultsKey)
        return rawValue.flatMap(CanvasGridMode.init) ?? .bigZoomableDots
    }
}
