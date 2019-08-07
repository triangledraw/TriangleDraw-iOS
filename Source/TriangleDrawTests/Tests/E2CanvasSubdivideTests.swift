// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasSubdivideTests: XCTestCase {

    func testIdentity0() {
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
		let canvasActual = canvasExpected.subdivide(n: 1)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testIdentity1() {
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_out5.pbm")
		let canvasActual = canvasExpected.subdivide(n: 1)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

	// MARK: -

    func testSubdivide0_n2() {
		let canvas: E2Canvas = loadCanvas("test_subdivide0_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide0_out2.pbm")
		let canvasActual = canvas.subdivide(n: 2)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testSubdivide0_n3() {
		let canvas: E2Canvas = loadCanvas("test_subdivide0_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide0_out3.pbm")
		let canvasActual = canvas.subdivide(n: 3)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

	func testSubdivide0_n5() {
		let canvas: E2Canvas = loadCanvas("test_subdivide0_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide0_out5.pbm")
		let canvasActual = canvas.subdivide(n: 5)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
		XCTAssertEqual(actual, expected)
	}

	// MARK: -

    func testSubdivide1_n2() {
		let canvas: E2Canvas = loadCanvas("test_subdivide1_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide1_out2.pbm")
		let canvasActual = canvas.subdivide(n: 2)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testSubdivide1_n3() {
		let canvas: E2Canvas = loadCanvas("test_subdivide1_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide1_out3.pbm")
		let canvasActual = canvas.subdivide(n: 3)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

	func testSubdivide1_n5() {
		let canvas: E2Canvas = loadCanvas("test_subdivide1_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide1_out5.pbm")
		let canvasActual = canvas.subdivide(n: 5)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
		XCTAssertEqual(actual, expected)
	}

	// MARK: -

    func testSubdivide2_n2() {
		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_out2.pbm")
		let canvasActual = canvas.subdivide(n: 2)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testSubdivide2_n3() {
		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_out3.pbm")
		let canvasActual = canvas.subdivide(n: 3)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

	func testSubdivide2_n5() {
		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_out5.pbm")
		let canvasActual = canvas.subdivide(n: 5)
		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
		XCTAssertEqual(actual, expected)
	}
}
