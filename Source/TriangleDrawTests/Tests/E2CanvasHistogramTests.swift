// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasHistogramTests: XCTestCase {
	func point(_ x: Int, _ y: Int) -> E2CanvasPoint {
		return E2CanvasPoint(x: x, y: y)
	}

	func test0() {
		let canvas: E2Canvas = loadCanvas("test_histogram0.txt")
		let result = canvas.histogram()
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0], 11375)
		XCTAssertEqual(result[1], 241)
	}

	func test1() {
		let canvas: E2Canvas = loadCanvas("test_histogram1.txt")
		let result = canvas.histogram()
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0], 241)
		XCTAssertEqual(result[1], 11375)
	}

	func test2() {
		let canvas: E2Canvas = E2Canvas.createBigCanvas()
		canvas.inner_setPixel(point: point(60, 52), value: 1, sanitize: false)
		canvas.inner_setPixel(point: point(60, 53), value: 1, sanitize: false)
		canvas.inner_setPixel(point: point(60, 54), value: 1, sanitize: false)
		canvas.inner_setPixel(point: point(90, 52), value: 5, sanitize: false)
		canvas.inner_setPixel(point: point(90, 53), value: 5, sanitize: false)
		canvas.inner_setPixel(point: point(90, 54), value: 5, sanitize: false)
		let result = canvas.histogram()
		XCTAssertEqual(result.count, 3)
		XCTAssertEqual(result[0], 11610)
		XCTAssertEqual(result[1], 3)
		XCTAssertEqual(result[5], 3)
	}
}
