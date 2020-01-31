// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain

extension CGPoint {
	var testString: String {
		return String(format: "%.1f %.1f", self.x, self.y)
	}
}

class CGPointTest: XCTestCase {
    func testScaleByAroundPoint_zero() {
		let result0 = CGPoint.zero.scaleBy(1, aroundPoint: CGPoint.zero).testString
		XCTAssertEqual(result0, "0.0 0.0")
		let result1 = CGPoint(x: 10, y: 0).scaleBy(2, aroundPoint: CGPoint.zero).testString
		XCTAssertEqual(result1, "20.0 0.0")
		let result2 = CGPoint(x: -10, y: 0).scaleBy(2, aroundPoint: CGPoint.zero).testString
		XCTAssertEqual(result2, "-20.0 0.0")
	}
	
	func testScaleByAroundPoint_plus10() {
		let result0 = CGPoint.zero.scaleBy(2, aroundPoint: CGPoint(x: 10, y: 0)).testString
		XCTAssertEqual(result0, "-10.0 0.0")
		let result1 = CGPoint(x: 10, y: 0).scaleBy(2, aroundPoint: CGPoint(x: 10, y: 0)).testString
		XCTAssertEqual(result1, "10.0 0.0")
		let result2 = CGPoint(x: 20, y: 0).scaleBy(2, aroundPoint: CGPoint(x: 10, y: 0)).testString
		XCTAssertEqual(result2, "30.0 0.0")
	}

	func testScaleBy() {
		let result0 = CGPoint.zero.scaleBy(10).testString
		XCTAssertEqual(result0, "0.0 0.0")
		let result1 = CGPoint(x: 3, y: 5).scaleBy(2).testString
		XCTAssertEqual(result1, "6.0 10.0")
	}

	func testDivideBy() {
		let result0 = CGPoint.zero.divideBy(10).testString
		XCTAssertEqual(result0, "0.0 0.0")
		let result1 = CGPoint(x: 6, y: 10).divideBy(2).testString
		XCTAssertEqual(result1, "3.0 5.0")
	}
	
	func testLengthSquared() {
		XCTAssertEqual(CGPoint.zero.lengthSquared, 0.0, accuracy: 0.000001)
		XCTAssertEqual(CGPoint(x: -2, y: 3).lengthSquared, 13.0, accuracy: 0.000001)
	}
}
