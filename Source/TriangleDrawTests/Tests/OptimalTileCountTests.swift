// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

extension CGSize {
	var td_tileCount: UInt {
		return triangleDraw_findOptimalTileCount(clampN: 16)
	}
}

class OptimalTileCountTests: XCTestCase {
	func testNonInteger() {
		XCTAssertEqual(CGSize(width: 83, height: 83).td_tileCount, 1)
	}

    func testInteger() {
		// `UIDocumentBrowserViewController` uses 84x84 thumbnails when running in the iPhone5S simulator
		XCTAssertEqual(CGSize(width: 84, height: 84).td_tileCount, 4)
    }

	func testPowerOf2() {
		XCTAssertEqual(CGSize(width: 8, height: 8).td_tileCount, 1)
		XCTAssertEqual(CGSize(width: 16, height: 16).td_tileCount, 2)
		XCTAssertEqual(CGSize(width: 32, height: 32).td_tileCount, 4)
		XCTAssertEqual(CGSize(width: 64, height: 64).td_tileCount, 8)
		XCTAssertEqual(CGSize(width: 128, height: 128).td_tileCount, 16)
		XCTAssertEqual(CGSize(width: 1024, height: 1024).td_tileCount, 16)
		XCTAssertEqual(CGSize(width: 4096, height: 4096).td_tileCount, 16)
	}
}
