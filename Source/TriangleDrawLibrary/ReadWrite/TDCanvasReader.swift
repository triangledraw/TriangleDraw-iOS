// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public class TDCanvasReader {
    public class func canvas(fromPBMRepresentation pbmRepresentation: Data?) throws -> E2Canvas {
		// Interpret the data as a .PBM file
        let model = try TDParsePBM.parse(pbmRepresentation)
        let width: Int = model.data.width
        let height: Int = model.data.height
		// Check that the dimensions corresponds to our canvas size
        let ok1: Bool = width == 180
        let ok2: Bool = height == 104
        let dimensions_ok: Bool = ok1 && ok2
        if !dimensions_ok {
			let messageFormat = NSLocalizedString("READ_FAILED_WRONG_DIMENSIONS_%d_%d", tableName: "ReadWrite", bundle: Bundle.main, value: "", comment: "Expected dimensions 180x104, but got {width}x{height}")
			let message = String(format: messageFormat, width, height)
			throw NSError(domain: "TDCanvasReader", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
        }
		// Transfer pixel data to canvas
		let canvas: E2Canvas = E2Canvas.createBigCanvas()
        for y in 0..<height {
            for x in 0..<width {
                let index: Int = y * width + x
                let value: Int = model.data.cells[index]
				let point: E2CanvasPoint = E2CanvasPoint(x: x, y: y)
                canvas.setPixel(point, value: UInt8(value))
            }
        }
        // Success
        return canvas
    }
}
