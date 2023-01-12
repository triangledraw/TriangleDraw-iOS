// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation
import Combine
import SwiftUI
import TriangleDrawLibrary

public class HCMenuViewModel: ObservableObject {
    weak var delegate: HCMenuViewControllerDelegate?
    var initialGridMode: CanvasGridMode

    init() {
        self.delegate = nil
        self.initialGridMode = CanvasGridMode.smallFixedSizeDots
    }

    static func create() -> HCMenuViewModel {
        let instance = HCMenuViewModel()
        instance.initialGridMode = CanvasGridModeController().currentCanvasGridMode
        return instance
    }
}
