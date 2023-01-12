// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation
import Combine
import SwiftUI
import TriangleDrawLibrary

public class HCMenuViewModel: ObservableObject {
    weak var delegate: HCMenuViewControllerDelegate?
    var initialGridMode: CanvasGridMode
    var initialSymmetryMode: SymmetryMode
    var initialCanvas: E2Canvas?

    // swiftlint:disable:next identifier_name
    var document_displayName: String?

    init() {
        self.delegate = nil
        self.initialGridMode = CanvasGridMode.smallFixedSizeDots
        self.initialSymmetryMode = SymmetryMode.noSymmetry
        self.initialCanvas = nil
        self.document_displayName = nil
    }

    static func create() -> HCMenuViewModel {
        let instance = HCMenuViewModel()
        instance.initialGridMode = CanvasGridModeController().currentCanvasGridMode
        instance.initialSymmetryMode = globalSymmetryMode
        return instance
    }

    public enum ExportPNGStatus {
        case progress(progress: Float)
        case ok(image: UIImage, filename: String?)
        case error(message: String)
    }

    func exportToPNG(callback: @escaping (ExportPNGStatus) -> Void) {
        guard let canvas: E2Canvas = self.initialCanvas else {
            callback(ExportPNGStatus.error(message: "exportToPNG - Expected document.canvas to be non-nil, but got nil"))
            return
        }
        log.debug("exportToPNG initiate")
        let t0 = CFAbsoluteTimeGetCurrent()
        let filename = document_displayName ?? ""

        TDRenderBitmap.imageWithSize2048x2048(for: canvas, progress: { progress in
            callback(ExportPNGStatus.progress(progress: progress))
        }) { imageOrNil in // swiftlint:disable:this multiple_closures_with_trailing_closure
            guard let image: UIImage = imageOrNil else {
                callback(ExportPNGStatus.error(message: "exportToPNG - Expected TDRenderBitmap to generate an image, but got nil"))
                return
            }
            let t1 = CFAbsoluteTimeGetCurrent()
            let elapsed: Double = t1 - t0
            log.debug("exportToPNG - ready for sharing. elapsed: \(elapsed.string2)")
            callback(ExportPNGStatus.ok(image: image, filename: filename))
        }
    }
}
