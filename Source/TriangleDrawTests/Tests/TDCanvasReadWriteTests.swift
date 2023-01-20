// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class TDCanvasReadWriteTests: XCTestCase {
	func point(_ x: Int, _ y: Int) -> E2CanvasPoint {
		return E2CanvasPoint(x: x, y: y)
	}

    func testWriteRead1() {
		let originalCanvas: E2Canvas = loadCanvas("test_parsepbm_advanced1.pbm")
        XCTAssertEqual(originalCanvas.width, 180)
        XCTAssertEqual(originalCanvas.height, 104)
        let rep: Data? = TDCanvasWriter.pbmRepresentation(from: originalCanvas)
        XCTAssertNotNil(rep)
        let copyCanvas: E2Canvas? = try? TDCanvasReader.canvas(fromPBMRepresentation: rep)
        XCTAssertNotNil(copyCanvas)
        let same: Bool = originalCanvas == copyCanvas
        XCTAssertTrue(same, "write followed by read should match original")
    }

    func testProtectAgainstTooBigValues1() {
		let originalCanvas: E2Canvas = E2Canvas.createBigCanvas()
        originalCanvas.setPixel(point(90, 52), value: 5)
		// PBM allows only pixel values of 0 and 1
        let rep: Data? = TDCanvasWriter.pbmRepresentation(from: originalCanvas)
        XCTAssertNotNil(rep)
		guard let copyCanvas: E2Canvas = try? TDCanvasReader.canvas(fromPBMRepresentation: rep) else {
			XCTFail("failed to copy canvas")
			return
		}
		let actual: UInt8 = copyCanvas.getPixelX(90, y: 52)
        XCTAssertEqual(actual, 1)
    }

    func testWrongDimensions1() {
        let canvas: E2Canvas? = loadCanvasFromPBMFile("test_readwrite_wrongdimensions1.pbm")
        XCTAssertNil(canvas)
    }

	func testLoadMockFile0() {
		let canvas: E2Canvas = DocumentExample.triangledrawLogo.canvas
		XCTAssertEqual(canvas.width, 180)
		XCTAssertEqual(canvas.height, 104)
	}

	func testLoadMockFile1() {
		let canvas: E2Canvas = DocumentExample.developer_rows.canvas
		XCTAssertEqual(canvas.width, 180)
		XCTAssertEqual(canvas.height, 104)
	}

	func testLoadMockFile2() {
		let canvas: E2Canvas = DocumentExample.developer_columns.canvas
		XCTAssertEqual(canvas.width, 180)
		XCTAssertEqual(canvas.height, 104)
	}

	func testLoadMockFile3() {
		let canvas: E2Canvas = DocumentExample.rune1.canvas
		XCTAssertEqual(canvas.width, 180)
		XCTAssertEqual(canvas.height, 104)
	}
}
