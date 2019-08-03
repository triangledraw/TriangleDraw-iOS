// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CanvasMoveTests: XCTestCase {
	func testMoveRightSimple() {
        let canvas: E2Canvas = loadCanvas("test_move_right_simple_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_right_simple_after.txt")
        canvas.moveRight()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveRightWrap0() {
        let canvas: E2Canvas = loadCanvas("test_move_right_wrap0_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_right_wrap0_after.txt")
        canvas.moveRight()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveRightWrap1() {
        let canvas: E2Canvas = loadCanvas("test_move_right_wrap1_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_right_wrap1_after.txt")
        canvas.moveRight()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveRightWrap2() {
        let canvas: E2Canvas = loadCanvas("test_move_right_wrap2_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_right_wrap2_after.txt")
        canvas.moveRight()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftSimple() {
        let canvas: E2Canvas = loadCanvas("test_move_right_simple_after.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_right_simple_before.txt")
        canvas.moveLeft()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftWrap0() {
        let canvas: E2Canvas = loadCanvas("test_move_left_wrap0_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_left_wrap0_after.txt")
        canvas.moveLeft()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveLeftWrap1() {
        let canvas: E2Canvas = loadCanvas("test_move_left_wrap1_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_left_wrap1_after.txt")
        canvas.moveLeft()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveUpSimple() {
        let canvas: E2Canvas = loadCanvas("test_move_up_simple_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_up_simple_after.txt")
        canvas.moveUp()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveUpWrap0() {
        let canvas: E2Canvas = loadCanvas("test_move_up_wrap0_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_up_wrap0_after.txt")
        canvas.moveUp()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveUpWrap1() {
        let canvas: E2Canvas = loadCanvasMask()
        let canvasExpected: E2Canvas = loadCanvasMask()
        canvas.moveUp()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveUpWrap2() {
        let canvas: E2Canvas = loadCanvas("test_move_up_wrap1_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_up_wrap1_after.txt")
        canvas.moveUp()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveDownSimple() {
        let canvas: E2Canvas = loadCanvas("test_move_up_simple_after.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_up_simple_before.txt")
        canvas.moveDown()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveDownWrap0() {
        let canvas: E2Canvas = loadCanvas("test_move_up_wrap0_after.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_up_wrap0_before.txt")
        canvas.moveDown()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveDownWrap1() {
        let canvas: E2Canvas = loadCanvasMask()
        let canvasExpected: E2Canvas = loadCanvasMask()
        canvas.moveDown()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveDownWrap2() {
        let canvas: E2Canvas = loadCanvas("test_move_down_wrap1_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_down_wrap1_after.txt")
        canvas.moveDown()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testMoveDownWrap3() {
        let canvas: E2Canvas = loadCanvas("test_move_down_wrap2_before.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_move_down_wrap2_after.txt")
        canvas.moveDown()
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }
}
