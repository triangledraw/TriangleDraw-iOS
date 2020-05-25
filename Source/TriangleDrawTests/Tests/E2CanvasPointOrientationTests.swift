// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasPointOrientationTests: XCTestCase {
	func testUpward() {
		let canvas: E2Canvas = loadCanvas("test_orientation_upward.pbm")
		var countUpward: UInt = 0
		var countDownward: UInt = 0
		for y in 0..<canvas.height {
			for x in 0..<canvas.width {
				let point = E2CanvasPoint(x: Int(x), y: Int(y))
				let value: UInt8 = canvas.getPixel(point)
				if value == 0 {
					continue
				}
				switch point.orientation {
				case .upward:
					countUpward += 1
				case .downward:
					countDownward += 1
				}
			}
		}
		XCTAssertEqual(countUpward, 7)
		XCTAssertEqual(countDownward, 0)
	}

	func testDownward() {
		let canvas: E2Canvas = loadCanvas("test_orientation_downward.pbm")
		var countUpward: UInt = 0
		var countDownward: UInt = 0
		for y in 0..<canvas.height {
			for x in 0..<canvas.width {
				let point = E2CanvasPoint(x: Int(x), y: Int(y))
				let value: UInt8 = canvas.getPixel(point)
				if value == 0 {
					continue
				}
				switch point.orientation {
				case .upward:
					countUpward += 1
				case .downward:
					countDownward += 1
				}
			}
		}
		XCTAssertEqual(countUpward, 0)
		XCTAssertEqual(countDownward, 7)
	}
}
