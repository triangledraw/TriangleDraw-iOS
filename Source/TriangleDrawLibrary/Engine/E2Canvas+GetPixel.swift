// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	public func getPixel(_ point: E2CanvasPoint) -> UInt8 {
		return self.inner_getPixel(point: point)
	}

	public func getPixelX(_ x: Int, y: Int) -> UInt8 {
		let point = E2CanvasPoint(x: x, y: y)
		return getPixel(point)
	}

	public func inner_getPixel(point: E2CanvasPoint) -> UInt8 {
		let x = point.x
		let y = point.y
		let x2: Int = x / 2
		let y2: Int = y / 2
		let w = Int(self.cellsPerRow)
		let h = Int(self.cellsPerColumn)
		if x2 < 0 || y2 < 0 {
			return 0
		}
		if x2 >= w || y2 >= h {
			return 0
		}
		let offset = y2 * w + x2
		let cell: E2TriangleCell = self.cells[offset]
		if y & 1 != 0 {
			if x & 1 != 0 {
				return cell.br
			} else {
				return cell.bl
			}
		} else {
			if x & 1 != 0 {
				return cell.tr
			} else {
				return cell.tl
			}
		}
	}
}
