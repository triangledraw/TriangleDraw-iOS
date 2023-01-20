// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class E2CanvasCopyTests: XCTestCase {
    func testCopy() {
		let canvas0: E2Canvas = E2Canvas.createBigCanvas()
		do {
			canvas0.setRawPixel(E2CanvasPoint(x: 0, y: 0), value: 0)
			canvas0.setRawPixel(E2CanvasPoint(x: 1, y: 0), value: 10)
			canvas0.setRawPixel(E2CanvasPoint(x: 0, y: 1), value: 1)
			canvas0.setRawPixel(E2CanvasPoint(x: 1, y: 1), value: 11)
		}
		let canvas1: E2Canvas = canvas0.createCopy()
		do {
			XCTAssertTrue(canvas0 !== canvas1)
			XCTAssertEqual(canvas0.size.width, canvas1.size.width)
			XCTAssertEqual(canvas0.size.height, canvas1.size.height)
			XCTAssertEqual(canvas0.cellsPerRow, canvas1.cellsPerRow)
			XCTAssertEqual(canvas0.cellsPerColumn, canvas1.cellsPerColumn)
			XCTAssertEqual(canvas0.cells.count, canvas1.cells.count)
		}
		do {
			canvas0.setRawPixel(E2CanvasPoint(x: 0, y: 0), value: 255)
			canvas0.setRawPixel(E2CanvasPoint(x: 1, y: 0), value: 255)
			canvas0.setRawPixel(E2CanvasPoint(x: 0, y: 1), value: 255)
			canvas0.setRawPixel(E2CanvasPoint(x: 1, y: 1), value: 255)
		}
		do {
			let value00: UInt8 = canvas0.getPixel(E2CanvasPoint(x: 0, y: 0))
			let value10: UInt8 = canvas0.getPixel(E2CanvasPoint(x: 1, y: 0))
			let value01: UInt8 = canvas0.getPixel(E2CanvasPoint(x: 0, y: 1))
			let value11: UInt8 = canvas0.getPixel(E2CanvasPoint(x: 1, y: 1))
			XCTAssertEqual(value00, 255)
			XCTAssertEqual(value10, 255)
			XCTAssertEqual(value01, 255)
			XCTAssertEqual(value11, 255)
		}
		do {
			let value00: UInt8 = canvas1.getPixel(E2CanvasPoint(x: 0, y: 0))
			let value10: UInt8 = canvas1.getPixel(E2CanvasPoint(x: 1, y: 0))
			let value01: UInt8 = canvas1.getPixel(E2CanvasPoint(x: 0, y: 1))
			let value11: UInt8 = canvas1.getPixel(E2CanvasPoint(x: 1, y: 1))
			XCTAssertEqual(value00, 0)
			XCTAssertEqual(value10, 10)
			XCTAssertEqual(value01, 1)
			XCTAssertEqual(value11, 11)
		}
	}
}
