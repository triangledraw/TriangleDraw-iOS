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

		for j: Int in 0..<h {
			for i: Int in 0..<w {
				let offset: Int = j * w + i
				let canvasCell: E2TriangleCell = self.cells[offset]

				do {
					let value: UInt8 = canvasCell.tl
					let x = i * 2
					let y = j * 2
					if x >= 0 && y >= 0 {
						let destPoint = E2CanvasPoint(x: x, y: y)
						canvas.setPixel(destPoint, value: value)
					}
				}
				do {
					let value: UInt8 = canvasCell.tr
					let x = i * 2 + 1
					let y = j * 2
					if x >= 0 && y >= 0 {
						let destPoint = E2CanvasPoint(x: x, y: y)
						canvas.setPixel(destPoint, value: value)
					}
				}
				do {
					let value: UInt8 = canvasCell.bl
					let x = i * 2
					let y = j * 2 + 1
					if x >= 0 && y >= 0 {
						let destPoint = E2CanvasPoint(x: x, y: y)
						canvas.setPixel(destPoint, value: value)
					}
				}
				do {
					let value: UInt8 = canvasCell.br
					let x = i * 2 + 1
					let y = j * 2 + 1
					if x >= 0 && y >= 0 {
						let destPoint = E2CanvasPoint(x: x, y: y)
						canvas.setPixel(destPoint, value: value)
					}
				}
			}
		}
		return canvas
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

    func testSubdivideBy2() {
		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
		let canvasExpected: E2Canvas = loadCanvas("test_subdivide2_out3.pbm")

		let canvasActual = canvas.subdivide(n: 2)


		let actual: String = canvasActual.stringRepresentation
		let expected: String = canvasExpected.stringRepresentation

        let rep: Data = TDCanvasWriter.pbmRepresentation(from: canvasActual)
		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result.pbm").absoluteURL
		try! rep.write(to: url)

        XCTAssertEqual(actual, expected)
    }

}
