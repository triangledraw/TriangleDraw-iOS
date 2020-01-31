// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasFlipTests: XCTestCase {
    func testFlipX0() {
        let canvas: E2Canvas = loadCanvas("test_flipx_simple_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_flipx_simple_after.txt")
        canvas.flipX()
		let actual = canvas.stringRepresentation
		let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testFlipX1() {
        let canvas: E2Canvas = loadCanvas("test_flipx_simple2_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_flipx_simple2_after.txt")
        canvas.flipX()
		let actual = canvas.stringRepresentation
		let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testFlipY() {
        let canvas: E2Canvas = loadCanvas("test_flipy_simple_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_flipy_simple_after.txt")
        canvas.flipY()
		let actual = canvas.stringRepresentation
		let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }
}
