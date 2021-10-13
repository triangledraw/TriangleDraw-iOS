// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class Engine2Tests: XCTestCase {
	func point(_ x: Int, _ y: Int) -> E2CanvasPoint {
		return E2CanvasPoint(x: x, y: y)
	}

	func createCanvas(_ width: UInt, _ height: UInt) -> E2Canvas {
		return E2Canvas(canvasSize: E2CanvasSize(width: width, height: height))
	}

    func testBlankCanvas0() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        let actual = c.stringRepresentation
        let expected = "--\n--"
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(c.width, 2)
        XCTAssertEqual(c.height, 2)
    }

    func testBlankCanvas1() {
		let c: E2Canvas = createCanvas(2, 4)
        c.clearWithBlackColor()
        let actual = c.stringRepresentation
        let expected = "----\n----\n----\n----"
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(c.width, 4)
        XCTAssertEqual(c.height, 4)
    }

    func testSetPixel00() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(0, 0), value: 1)
        let actual = c.stringRepresentation
        let expected = "*-\n--"
        XCTAssertEqual(actual, expected)
    }

    func testSetPixel10() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(1, 0), value: 1)
        let actual = c.stringRepresentation
        let expected = "-*\n--"
        XCTAssertEqual(actual, expected)
    }

    func testSetPixel01() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(0, 1), value: 1)
        let actual = c.stringRepresentation
        let expected = "--\n*-"
        XCTAssertEqual(actual, expected)
    }

    func testSetPixel11() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(1, 1), value: 1)
        let actual = c.stringRepresentation
        let expected = "--\n-*"
        XCTAssertEqual(actual, expected)
    }

    func testSetPixelInvalidValue1() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(1, 1), value: 5)
        let actual = c.getPixel(point(1, 1))
        XCTAssertEqual(actual, 1)
    }

    func testSetPixelInvalidValue2() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        c.setPixel(point(1, 1), value: 6)
        let actual = c.getPixel(point(1, 1))
        XCTAssertEqual(actual, 0)
    }

    func testGetPixel0() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        do {
            let actual = c.getPixel(point(0, 0))
            let expected: UInt8 = 0
            XCTAssertEqual(actual, expected)
        }
        c.setPixel(point(0, 0), value: 1)
        do {
            let actual = c.getPixel(point(0, 0))
            let expected: UInt8 = 1
            XCTAssertEqual(actual, expected)
        }
    }

    func testGetPixel1() {
		let c: E2Canvas = createCanvas(1, 2)
        c.clearWithBlackColor()
        do {
            let actual = c.getPixel(point(1, 1))
            let expected: UInt8 = 0
            XCTAssertEqual(actual, expected)
        }
        c.setPixel(point(1, 1), value: 1)
        do {
            let actual = c.getPixel(point(1, 1))
            let expected: UInt8 = 1
            XCTAssertEqual(actual, expected)
        }
    }

    func testBigCanvasMask() {
		let canvas: E2Canvas = E2Canvas.bigCanvasMask()
        XCTAssertNotNil(canvas, "bigCanvasMask")
        do {
            let actual = canvas.size.width
            let expected = AppConstant.CanvasFileFormat.width
            XCTAssertEqual(actual, expected)
        }
        do {
            let actual = canvas.size.height
            let expected = AppConstant.CanvasFileFormat.height
            XCTAssertEqual(actual, expected)
        }
    }

    func testInvert() {
		let c: E2Canvas = createCanvas(2, 4)
        c.load(fromStringRepresentation: "--**\n----\n*---\n----")
        c.invertPixels()
        let actual = c.stringRepresentation
        let expected = "**--\n****\n-***\n****"
        XCTAssertEqual(actual, expected)
    }

    func testLoadFromStringRepresentation_ignoreTheCarriageReturnCharacter() {
		let c: E2Canvas = createCanvas(2, 4)
        c.load(fromStringRepresentation: "---*\r\n--*-\r\n-*--\r\n*---")
        let actual = c.stringRepresentation
        let expected = "---*\n--*-\n-*--\n*---"
        XCTAssertEqual(actual, expected)
    }

    func testPointToTriangle1() {
        /*
         
           0,-1
        -1,-1 ***************************** +1,-1
              *                           *
              * *         [0,0]         * *
              *   *                   *   *
              *     *               *     *
              *       *           *       *
              *         *       *         *
              *  [-1,0]   *   *   [+1,0]  *
              *             *             * 
         -1,0 ***************************** +1,0
              *             *             * 
              * [-1,+1]   *   *   [+1,+1] *
              *         *       *         *
              *       *           *       *
              *     *               *     *
              *   *                   *   *
              * *         [0,+1]        * *
              *                           *
        -1,+1 ***************************** +1,+1
                           0,+1
        
         */
        // Ensure that points in top triangle results in 0,0
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.1, y: -0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.1, y: -0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.1, y: -0.2))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.1, y: -0.2))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.8, y: -0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.8, y: -0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 0)
        }
        // Ensure that points in bottom triangle results in 0,1
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.1, y: 0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.1, y: 0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.1, y: 0.2))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.1, y: 0.2))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.8, y: 0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.8, y: 0.9))
            XCTAssertEqual(result.x, 0)
            XCTAssertEqual(result.y, 1)
        }
    }

    func testPointToTriangle2() {
        /*
         
           0,-1
        -1,-1 ***************************** +1,-1
              *                           *
              * *         [0,0]         * *
              *   *                   *   *
              *     *               *     *
              *       *           *       *
              *         *       *         *
              *  [-1,0]   *   *   [+1,0]  *
              *             *             * 
         -1,0 ***************************** +1,0
              *             *             * 
              * [-1,+1]   *   *   [+1,+1] *
              *         *       *         *
              *       *           *       *
              *     *               *     *
              *   *                   *   *
              * *         [0,+1]        * *
              *                           *
        -1,+1 ***************************** +1,+1
                           0,+1
        
         */
        // Ensure that points in top/left triangle results in -1,0
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.9, y: -0.7))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.9, y: -0.1))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.3, y: -0.1))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 0)
        }
        // Ensure that points in top/right triangle results in 1,0
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.9, y: -0.7))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.9, y: -0.1))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 0)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.3, y: -0.1))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 0)
        }
        // Ensure that points in bottom/left triangle results in -1,1
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.9, y: 0.7))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.9, y: 0.1))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: -0.3, y: 0.1))
            XCTAssertEqual(result.x, -1)
            XCTAssertEqual(result.y, 1)
        }
        // Ensure that points in bottom/right triangle results in 1,1
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.9, y: 0.7))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.9, y: 0.1))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 1)
        }
        do {
            let result: E2TriangleResult = E2Canvas.triangle(from: CGPoint(x: 0.3, y: 0.1))
            XCTAssertEqual(result.x, 1)
            XCTAssertEqual(result.y, 1)
        }
    }

    func testIndexForPoint1() {
		let c: E2Canvas = createCanvas(1, 2)
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.01, y: 0.4))
            XCTAssertEqual(index.x, -1)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.1))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.1))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.4))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.01, y: 0.6))
            XCTAssertEqual(index.x, -1)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.9))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.9))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.6))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 1)
        }
    }

    func testIndexForPoint2() {
		let c: E2Canvas = createCanvas(2, 4)
        // column 0
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.24, y: 0.1))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.24, y: 0.49))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.24, y: 0.51))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.24, y: 0.99))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 3)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.26, y: 0.1))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.26, y: 0.49))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.26, y: 0.51))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.26, y: 0.99))
            XCTAssertEqual(index.x, 0)
            XCTAssertEqual(index.y, 3)
        }
        // column 1
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.24))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.26))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.74))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.49, y: 0.76))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 3)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.24))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.26))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.74))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.51, y: 0.76))
            XCTAssertEqual(index.x, 1)
            XCTAssertEqual(index.y, 3)
        }
        // column 2
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.74, y: 0.1))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.74, y: 0.49))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.74, y: 0.51))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.74, y: 0.99))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 3)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.76, y: 0.1))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.76, y: 0.49))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.76, y: 0.51))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.76, y: 0.99))
            XCTAssertEqual(index.x, 2)
            XCTAssertEqual(index.y, 3)
        }
        // column 3
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.24))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.26))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.74))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 0.99, y: 0.76))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 3)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 1.01, y: 0.24))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 0)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 1.01, y: 0.26))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 1)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 1.01, y: 0.74))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 2)
        }
        do {
            let index: E2CanvasPoint = c.canvasPoint(from: CGPoint(x: 1.01, y: 0.76))
            XCTAssertEqual(index.x, 3)
            XCTAssertEqual(index.y, 3)
        }
    }

    func testLineHorizontal1() {
        let canvas: E2Canvas = loadCanvas("test_linedraw_logo_none.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_linedraw_logo_horizontal.txt")
        canvas.line(from: CGPoint(x: 0.33, y: 0.5), to: CGPoint(x: 0.66, y: 0.5), value: 1)
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }

    func testLineVertical1() {
        let canvas: E2Canvas = loadCanvas("test_linedraw_logo_none.txt")
        let canvasExpected: E2Canvas = loadCanvas("test_linedraw_logo_vertical.txt")
        canvas.line(from: CGPoint(x: 0.5, y: 0.33), to: CGPoint(x: 0.5, y: 0.66), value: 1)
        let actual = canvas.stringRepresentation
        let expected = canvasExpected.stringRepresentation
        XCTAssertEqual(actual, expected)
    }
}
