// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class RemapTests: XCTestCase {
    func testIdentity() {
		let actualMin: Float = remap(0, 0, 1, 0, 1)
		XCTAssertEqual(actualMin, 0, accuracy: 0.01)
		let actualMax: Float = remap(1, 0, 1, 0, 1)
		XCTAssertEqual(actualMax, 1, accuracy: 0.01)
		let actualMid: Float = remap(0.5, 0, 1, 0, 1)
		XCTAssertEqual(actualMid, 0.5, accuracy: 0.01)
    }

	func testReverse() {
		let actualMin: Float = remap(0, 0, 1, 1, 0)
		XCTAssertEqual(actualMin, 1, accuracy: 0.01)
		let actualMax: Float = remap(1, 0, 1, 1, 0)
		XCTAssertEqual(actualMax, 0, accuracy: 0.01)
		let actualMid: Float = remap(0.5, 0, 1, 1, 0)
		XCTAssertEqual(actualMid, 0.5, accuracy: 0.01)
	}

	func testTranslate() {
		let actualMin: Float = remap(-1, -1, 0, 0, 1)
		XCTAssertEqual(actualMin, 0, accuracy: 0.01)
		let actualMax: Float = remap(0, -1, 0, 0, 1)
		XCTAssertEqual(actualMax, 1, accuracy: 0.01)
		let actualMid: Float = remap(-0.5, -1, 0, 0, 1)
		XCTAssertEqual(actualMid, 0.5, accuracy: 0.01)
	}

	func testScale() {
		let actualMin: Float = remap(-10, -10, 10, 0, 1)
		XCTAssertEqual(actualMin, 0, accuracy: 0.01)
		let actualMax: Float = remap(10, -10, 10, 0, 1)
		XCTAssertEqual(actualMax, 1, accuracy: 0.01)
		let actualMid: Float = remap(0, -10, 10, 0, 1)
		XCTAssertEqual(actualMid, 0.5, accuracy: 0.01)
	}
}
