// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class E2CanvasCountDifferenciesTests: XCTestCase {
	func point(_ x: Int, _ y: Int) -> E2CanvasPoint {
		return E2CanvasPoint(x: x, y: y)
	}

	func createCanvas(_ width: UInt, _ height: UInt) -> E2Canvas {
		return E2Canvas(canvasSize: E2CanvasSize(width: width, height: height))
	}


    func testCountNoDifference0() {
		let c0: E2Canvas = createCanvas(1, 2)
        c0.clearWithBlackColor()
        let count: UInt = c0.numberOfDifferences(from: c0)
        XCTAssertEqual(count, 0)
    }

    func testCountNoDifference1() {
        let c0: E2Canvas = createCanvas(1, 2)
        c0.clearWithBlackColor()
        c0.setPixel(point(0, 0), value: 1)
        let count: UInt = c0.numberOfDifferences(from: c0)
        XCTAssertEqual(count, 0)
    }

    func testCount0() {
        let c0: E2Canvas = createCanvas(1, 2)
        c0.clearWithBlackColor()
        let c1: E2Canvas = createCanvas(1, 2)
        c1.clearWithBlackColor()
        c1.setPixel(point(0, 0), value: 1)
        let count: UInt = c0.numberOfDifferences(from: c1)
        XCTAssertEqual(count, 1)
    }

    func testCount1() {
        let c0: E2Canvas = createCanvas(1, 2)
        c0.clearWithBlackColor()
        c0.setPixel(point(1, 0), value: 1)
        let c1: E2Canvas = createCanvas(1, 2)
        c1.clearWithBlackColor()
        c1.setPixel(point(0, 0), value: 1)
        let count: UInt = c0.numberOfDifferences(from: c1)
        XCTAssertEqual(count, 2)
    }

    func testCount2() {
        let c0: E2Canvas = createCanvas(2, 4)
        c0.clearWithBlackColor()
        c0.setPixel(point(2, 1), value: 1)
        let c1: E2Canvas = createCanvas(2, 4)
        c1.clearWithBlackColor()
        c1.setPixel(point(3, 3), value: 1)
        let count: UInt = c0.numberOfDifferences(from: c1)
        XCTAssertEqual(count, 2)
    }
}
