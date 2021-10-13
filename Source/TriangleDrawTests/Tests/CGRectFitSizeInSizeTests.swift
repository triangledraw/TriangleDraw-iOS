// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain

class CGRectFitSizeInSizeTests: XCTestCase {
	func testFitInsideSquare0_sameSize() {
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 1000), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 500), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 250.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 500, height: 1000), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
	}

	func testFitInsideSquare1_downscale() {
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 100000, height: 100000), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 100000, height: 50000), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 250.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 50000, height: 100000), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
	}

	func testFitInsideSquare2_upscale() {
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 10, height: 10), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 10, height: 5), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 250.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 5, height: 10), fit: CGSize(width: 1000, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
	}

	func testFitInsideWideContainer() {
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 1000), fit: CGSize(width: 1000, height: 500))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 500), fit: CGSize(width: 1000, height: 500))
			XCTAssertEqual(r.size.width, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 500, height: 1000), fit: CGSize(width: 1000, height: 500))
			XCTAssertEqual(r.size.width, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 375.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
	}

	func testFitInsideTallContainer() {
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 1000), fit: CGSize(width: 500, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 250.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 1000, height: 500), fit: CGSize(width: 500, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 250.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 375.0, accuracy: 0.001)
		}
		do {
			let r: CGRect = CGRect.fitSizeInSize(size: CGSize(width: 500, height: 1000), fit: CGSize(width: 500, height: 1000))
			XCTAssertEqual(r.size.width, 500.0, accuracy: 0.001)
			XCTAssertEqual(r.size.height, 1000.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.x, 0.0, accuracy: 0.001)
			XCTAssertEqual(r.origin.y, 0.0, accuracy: 0.001)
		}
	}
}
