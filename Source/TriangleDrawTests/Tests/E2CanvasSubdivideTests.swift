// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasSubdivideTests: XCTestCase {

    func test0() {
		let canvas: E2Canvas = loadCanvas("test_subdivide0_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide0_out3.pbm")

		let canvasActual: E2Canvas = E2Canvas.createBigCanvas()

		let midx: Int = Int(canvas.width) / 2 - 1
		let midy: Int = Int(canvas.height) / 2 - 1
		for y in 0..<Int(canvas.height) {
			for x in 0..<Int(canvas.width) {
				let sourcePoint = E2CanvasPoint(x: (x - midx) / 3 + midx, y: (y - midy) / 3 + midy)
				let value: UInt8 = canvas.getPixel(sourcePoint)
				let destPoint = E2CanvasPoint(x: x, y: y)
				canvasActual.setPixel(destPoint, value: value)
			}
		}

		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation

        let rep: Data = TDCanvasWriter.pbmRepresentation(from: canvasActual)
		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result.pbm").absoluteURL
		try! rep.write(to: url)

        XCTAssertEqual(actual, expected)
    }

}
