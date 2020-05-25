// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	/// Split up all triangles into smaller triangles
	///
	/// Useful when a drawing is too rough and the user wants smaller triangles for adding finer details.
	/// It's annoying for the user to redraw everything all over.
	///
	/// - For `N=1` then 1 triangle stays 1 triangle (identity).
	/// - For `N=2` then 1 triangle gets subdivided into 4 triangles.
	/// - For `N=3` then 1 triangle gets subdivided into 9 triangles.
	/// - For `N=5` then 1 triangle gets subdivided into 25 triangles.
	///
	/// The formula is `N*N`.
	///
	/// The overflow gets discarded, so that the canvas size stays the same.
	public func subdivide(n: UInt) -> E2Canvas {
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
				let point = leftCorner.offset(x: y + i, y: y)
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
				let point = leftCorner.offset(x: y + i, y: -y)
				self.setRawPixel(point, value: value)
			}
		}
	}
}
