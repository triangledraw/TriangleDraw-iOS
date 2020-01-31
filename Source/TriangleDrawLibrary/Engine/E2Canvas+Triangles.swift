// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	public func convertToTriangles() -> [E2CanvasTriangle2] {
//		return _convertToTriangles(debug: true)
		return _convertToTriangles(debug: false)
	}

	public func _convertToTriangles(debug: Bool) -> [E2CanvasTriangle2] {
		var triangleArray = [E2CanvasTriangle2]()

		func append(value: UInt8, a: IntVec2, b: IntVec2, c: IntVec2) {
			var finalValue: UInt8 = value
			if debug {
				if (a.x + a.y) % 5 == 0 {
					finalValue = 2
				}
			}
			let triangle = E2CanvasTriangle2(value: finalValue, a: a, b: b, c: c)
			triangleArray.append(triangle)
		}

		func append(_ value: UInt8, _ xy: IntVec2, _ x0: Int32, _ y0: Int32, _ x1: Int32, _ y1: Int32, _ x2: Int32, _ y2: Int32) {
			append(
				value: value,
				a: xy.offsetBy(dx: x0, dy: y0),
				b: xy.offsetBy(dx: x1, dy: y1),
				c: xy.offsetBy(dx: x2, dy: y2)
			)
		}

		let w: Int = Int(self.cellsPerRow)
		let h: Int = Int(self.cellsPerColumn)
		for j in 0..<h {
			for i in 0..<w {
				let offset = j * w + i
				let cell: E2TriangleCell = self.cells[offset]
				let xy = IntVec2(x: Int32(i * 2), y: Int32(j * 2))
				append(cell.tl, xy, 0, 0, 2, 0, 1, 1)
				append(cell.tr, xy, 2, 0, 3, 1, 1, 1)
				append(cell.bl, xy, 0, 2, 1, 1, 2, 2)
				append(cell.br, xy, 1, 1, 3, 1, 2, 2)
			}
		}

		return triangleArray
	}
}
