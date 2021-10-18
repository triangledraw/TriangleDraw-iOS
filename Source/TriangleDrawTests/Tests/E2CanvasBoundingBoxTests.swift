// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class E2CanvasBoundingBoxTests: XCTestCase {
	func testWidthHeight() {
		let box = E2CanvasBoundingBox(minX: 10, maxX: 20, minY: 10, maxY: 40)
		XCTAssertEqual(box.width, 11)
		XCTAssertEqual(box.height, 31)
	}

	func testMiddle() {
		let box = E2CanvasBoundingBox(minX: 10, maxX: 20, minY: 10, maxY: 40)
		XCTAssertEqual(box.midX, 15.5, accuracy: 0.01)
		XCTAssertEqual(box.midY, 25.5, accuracy: 0.01)
	}

	func testFinderWithEmptyCanvas() {
		let canvas: E2Canvas = E2Canvas.createBigCanvas()
		let box = E2CanvasBoundingBoxFinder(canvas: canvas)
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "666,666")
		XCTAssertEqual(box.yRange, "666,666")
		XCTAssertNil(box.result())
	}

    func test0() {
        let box = load("test_boundingbox0.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
        XCTAssertEqual(box.xRange, "59,115")
        XCTAssertEqual(box.yRange, "47,57")
		XCTAssertNotNil(box.result())
    }

    func test1() {
        let box = load("test_boundingbox1.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
        XCTAssertEqual(box.xRange, "58,94")
        XCTAssertEqual(box.yRange, "34,63")
		XCTAssertNotNil(box.result())
    }

    func test2() {
        let box = load("test_boundingbox2.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 1)
        XCTAssertEqual(box.xRange, "88,91")
        XCTAssertEqual(box.yRange, "51,52")
		XCTAssertNotNil(box.result())
    }

    func test3() {
        let box = load("test_boundingbox3.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 1)
        XCTAssertEqual(box.xRange, "87,92")
        XCTAssertEqual(box.yRange, "45,58")
		XCTAssertNotNil(box.result())
    }

    func test4() {
        let box = load("test_boundingbox4.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 1)
        XCTAssertEqual(box.xRange, "87,92")
        XCTAssertEqual(box.yRange, "39,64")
		XCTAssertNotNil(box.result())
    }

	func test5() {
		let box = load("test_boundingbox5.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "2,177")
		XCTAssertEqual(box.yRange, "51,52")
		XCTAssertNotNil(box.result())
	}

	func test6() {
		let box = load("test_boundingbox6.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "45,134")
		XCTAssertEqual(box.yRange, "8,95")
		XCTAssertNotNil(box.result())
	}

	func test7() {
		let box = load("test_boundingbox7.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "42,137")
		XCTAssertEqual(box.yRange, "8,11")
		XCTAssertNotNil(box.result())
	}

	func test8() {
		let box = load("test_boundingbox8.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "42,137")
		XCTAssertEqual(box.yRange, "92,95")
		XCTAssertNotNil(box.result())
	}

	func test9() {
		let box = load("test_boundingbox9.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 1)
		XCTAssertEqual(box.xRange, "42,137")
		XCTAssertEqual(box.yRange, "8,11")
		XCTAssertNotNil(box.result())
	}

	func test10() {
		let box = load("test_boundingbox10.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "78,99")
		XCTAssertEqual(box.yRange, "9,93")
		XCTAssertNotNil(box.result())
	}

	func test11() {
		let box = load("test_boundingbox11.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "28,45")
		XCTAssertEqual(box.yRange, "48,57")
		XCTAssertNotNil(box.result())
	}

	func test12() {
		let box = load("test_boundingbox12.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "2,9")
		XCTAssertEqual(box.yRange, "50,53")
		XCTAssertNotNil(box.result())
	}

	func test13() {
		let box = load("test_boundingbox13.txt")
		XCTAssertEqual(box.mostUsedPixelValue, 0)
		XCTAssertEqual(box.xRange, "3,9")
		XCTAssertEqual(box.yRange, "50,53")
		XCTAssertNotNil(box.result())
	}

	func load(_ resourceName: String) -> E2CanvasBoundingBoxFinder {
		let canvas: E2Canvas = loadCanvas(resourceName)
		return E2CanvasBoundingBoxFinder(canvas: canvas)
	}
}

extension E2CanvasBoundingBoxFinder {
	fileprivate var xRange: String {
		let minX: UInt = findMinX() ?? 666
		let maxX: UInt = findMaxX() ?? 666
		return "\(minX),\(maxX)"
	}

	fileprivate var yRange: String {
		let minY: UInt = findMinY() ?? 666
		let maxY: UInt = findMaxY() ?? 666
		return "\(minY),\(maxY)"
	}
}
