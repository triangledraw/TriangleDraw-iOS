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

    // MARK: Export to PNG

    enum ExportPNGStatus {
        case progress(progress: Float)
        case ok(image: UIImage, filename: String)
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

    // MARK: Export to PDF

    enum ExportPDFStatus {
        case progress(progress: Float)
        case ok(pdfData: Data, filename: String)
        case error(message: String)
    }

    func exportToPDF(callback: @escaping (ExportPDFStatus) -> Void) {
        guard let canvas: E2Canvas = self.initialCanvas else {
            callback(ExportPDFStatus.error(message: "exportToPDF - Expected document.canvas to be non-nil, but got nil"))
            return
        }
        log.debug("exportToPDF initiate")
        let t0 = CFAbsoluteTimeGetCurrent()
        let filename = document_displayName ?? ""

        PDFExporter.createPDF(from: canvas, progress: { progress in
            callback(ExportPDFStatus.progress(progress: progress))
        }) { pdfData in // swiftlint:disable:this multiple_closures_with_trailing_closure
            guard pdfData.count > 0 else {
                callback(ExportPDFStatus.error(message: "exportToPDF - Expected size of pdf to be greater than 0 bytes"))
                return
            }
            let t1 = CFAbsoluteTimeGetCurrent()
            let elapsed: Double = t1 - t0
            log.debug("exportToPDF - ready for sharing. elapsed: \(elapsed.string2)")
            callback(ExportPDFStatus.ok(pdfData: pdfData, filename: filename))
        }
    }

    // MARK: Export to SVG

    enum ExportSVGStatus {
        case ok(svgData: Data, filename: String)
        case error(message: String)
    }

    func exportToSVG(callback: @escaping (ExportSVGStatus) -> Void) {
        guard let canvas: E2Canvas = self.initialCanvas else {
            callback(ExportSVGStatus.error(message: "exportToSVG - Expected document.canvas to be non-nil, but got nil"))
            return
        }
        log.debug("exportToSVG initiate")
        let filename = document_displayName ?? ""

        let exporter = SVGExporter(canvas: canvas)
        exporter.appVersion = SystemInfo.appVersion
        exporter.rotated = false
        let svgData: Data = exporter.generateData()

        guard svgData.count > 0 else {
            callback(ExportSVGStatus.error(message: "exportToSVG - Expected size of svg to be greater than 0 bytes"))
            return
        }

        log.debug("exportToSVG - ready for sharing.")
        callback(ExportSVGStatus.ok(svgData: svgData, filename: filename))
    }
}
