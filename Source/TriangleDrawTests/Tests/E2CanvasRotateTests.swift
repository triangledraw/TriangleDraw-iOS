// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasRotateTests: XCTestCase {
    func testRotateCWSimple() {
        let canvas: E2Canvas = loadCanvas("test_rotate_simple_none.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_rotate_simple_60degree.txt")
        canvas.rotateClockwise()
		let actual: String = canvas.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testRotateCWLine() {
        let canvas: E2Canvas = loadCanvas("test_rotate_line_none.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_rotate_line_60degree.txt")
        canvas.rotateClockwise()
		let actual: String = canvas.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testRotateCWLine2() {
        let canvas: E2Canvas = loadCanvas("test_rotate_line2_minus60degree.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_rotate_line2_none.txt")
        canvas.rotateClockwise()
		let actual: String = canvas.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testRotateCWLogo() {
        let canvas: E2Canvas = loadCanvas("test_rotate_logo_none.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_rotate_logo_60degree.txt")
        canvas.rotateClockwise()
		let actual: String = canvas.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testRotateCCWSimple() {
        let canvas: E2Canvas = loadCanvas("test_rotate_simple_60degree.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_rotate_simple_none.txt")
        canvas.rotateCounterClockwise()
		let actual: String = canvas.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }
}
