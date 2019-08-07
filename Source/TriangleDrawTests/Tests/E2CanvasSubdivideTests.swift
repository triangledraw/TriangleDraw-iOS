// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

extension E2Canvas {
	func subdivide(n: UInt) -> E2Canvas {
		let canvas: E2Canvas = E2Canvas.createBigCanvas()

		let w: Int = Int(self.cellsPerRow)
		let h: Int = Int(self.cellsPerColumn)

		guard w == canvas.cellsPerRow && h == canvas.cellsPerColumn else {
			fatalError("Expected same canvas sizes")
		}
		guard n >= 1 else {
			log.error("Expected N to be 1 or more. Cannot subdivide.")
			return canvas
		}

		let halfW: Int = w / 2
		let halfH: Int = h / 2

		for j: Int in 0..<h {
			for i: Int in 0..<w {
				let offset: Int = j * w + i
				let cell: E2TriangleCell = self.cells[offset]

				// Scale around center
				let scaledX: Int = ((i - halfW) * Int(n) + halfW) * 2
				let scaledY: Int = ((j - halfH) * Int(n) + halfH) * 2

				do {
					// top-left
					let x = scaledX
					let y = scaledY
					let point = E2CanvasPoint(x: x, y: y)
					canvas.drawDownwardPointingTriangle(leftCorner: point, n: n, value: cell.tl)
				}
				do {
					// top-right
					let x = scaledX + Int(n)
					let y = scaledY + Int(n) - 1
					let point = E2CanvasPoint(x: x, y: y)
					canvas.drawUpwardPointingTriangle(leftCorner: point, n: n, value: cell.tr)
				}
				do {
					// bottom-left
					let x = scaledX
					let y = scaledY + Int(n * 2) - 1
					let point = E2CanvasPoint(x: x, y: y)
					canvas.drawUpwardPointingTriangle(leftCorner: point, n: n, value: cell.bl)
				}
				do {
					// bottom-right
					let x = scaledX + Int(n)
					let y = scaledY + Int(n)
					let point = E2CanvasPoint(x: x, y: y)
					canvas.drawDownwardPointingTriangle(leftCorner: point, n: n, value: cell.br)
				}
			}
		}
		return canvas
	}

	fileprivate func drawDownwardPointingTriangle(leftCorner: E2CanvasPoint, n: UInt, value: UInt8) {
		let height = Int(n)
		let width = (height * 2) - 1
		for y in 0..<height {
			let count = width - (y * 2)
			for i in 0..<count {
				let xx = leftCorner.x + y + i
				let yy = leftCorner.y + y
				let point = E2CanvasPoint(x: xx, y: yy)
				self.setRawPixel(point, value: value)
			}
		}
	}

	fileprivate func drawUpwardPointingTriangle(leftCorner: E2CanvasPoint, n: UInt, value: UInt8) {
		let height = Int(n)
		let width = (height * 2) - 1
		for y in 0..<height {
			let count = width - (y * 2)
			for i in 0..<count {
				let xx = leftCorner.x + y + i
				let yy = leftCorner.y - y
				let point = E2CanvasPoint(x: xx, y: yy)
				self.setRawPixel(point, value: value)
			}
		}
	}
}

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
