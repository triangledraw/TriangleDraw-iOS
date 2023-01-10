// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class IntVec2Tests: XCTestCase {
	func testImmutable() {
		let v = IntVec2(x: 11, y: 22)
		XCTAssertEqual(v.x, 11)
		XCTAssertEqual(v.y, 22)
	}

	func testMutate() {
		var v = IntVec2(x: 1, y: 2)
		v.x = v.x + 1000
		v.y = v.y + 2000
		XCTAssertEqual(v.x, 1001)
		XCTAssertEqual(v.y, 2002)
	}

	func testEquatable() {
		do {
			let a = IntVec2(x: 1, y: 2)
			let b = IntVec2(x: 1, y: 2)
			XCTAssertEqual(a, b)
		}
		do {
			let a = IntVec2(x: 1, y: 2)
			let b = IntVec2(x: 300, y: 2)
			XCTAssertNotEqual(a, b)
		}
		do {
			let a = IntVec2(x: 1, y: 2)
			let b = IntVec2(x: 1, y: 300)
			XCTAssertNotEqual(a, b)
		}
		do {
			let a = IntVec2.zero
			let b = IntVec2(x: 1, y: 2)
			XCTAssertNotEqual(a, b)
		}
	}

	func testOffsetBy() {
		do {
			let a = IntVec2(x: -10, y: -1000).offsetBy(dx: 10, dy: 1000)
			let b = IntVec2.zero
			XCTAssertEqual(a, b)
		}
		do {
			let a = IntVec2(x: 1, y: 2)
			let b = a.offsetBy(dx: 0, dy: 0)
			XCTAssertEqual(a, b)
		}
	}

	func testCustomDebugStringConvertible() {
		do {
			let s = String(reflecting: IntVec2.zero)
			XCTAssertEqual(s, "(0, 0)")
		}
		do {
			let s = String(reflecting: IntVec2(x: -123, y: -456))
			XCTAssertEqual(s, "(-123, -456)")
		}
		do {
			let s = String(reflecting: IntVec2(x: 123, y: 456))
			XCTAssertEqual(s, "(123, 456)")
		}
	}

	func testConvertToCGPoint() {
		do {
			let point: CGPoint = IntVec2.zero.cgPoint
			XCTAssertEqual(point.x, 0.0, accuracy: 0.0001)
			XCTAssertEqual(point.y, 0.0, accuracy: 0.0001)
		}
		do {
			let point: CGPoint = IntVec2(x: 1, y: 2).cgPoint
			XCTAssertEqual(point.x, 1.0, accuracy: 0.0001)
			XCTAssertEqual(point.y, 2.0, accuracy: 0.0001)
		}
		do {
			let point: CGPoint = IntVec2(x: -10, y: -20).cgPoint
			XCTAssertEqual(point.x, -10.0, accuracy: 0.0001)
			XCTAssertEqual(point.y, -20.0, accuracy: 0.0001)
		}
	}
}
