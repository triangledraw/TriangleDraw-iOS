// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension E2Canvas {
	public func line(from point0: CGPoint, to point1: CGPoint, value: UInt8) {
		var x0 = Int(Double(point0.x) * Double(100000.0))
		var y0 = Int(Double(point0.y) * Double(100000.0))
		let x1 = Int(Double(point1.x) * Double(100000.0))
		let y1 = Int(Double(point1.y) * Double(100000.0))
		let dx: Int = abs(x1 - x0)
		let sx: Int = x0 < x1 ? 1 : -1
		let dy: Int = abs(y1 - y0)
		let sy: Int = y0 < y1 ? 1 : -1
		var err: Int = (dx > dy ? dx : -dy) / 2
		var lastPoint: E2CanvasPoint = self.E2CanvasPoint_from_CGPoint(CGPoint(x: Double(x0) * Double(0.00001), y: Double(y0) * Double(0.00001)))
		setSymmetricPixel(lastPoint, value: value, symmetryMode: globalSymmetryMode)

		while true {
			let point: E2CanvasPoint = self.E2CanvasPoint_from_CGPoint(CGPoint(x: Double(x0) * Double(0.00001), y: Double(y0) * Double(0.00001)))
			let same: Bool = (point.x == lastPoint.x) && (point.y == lastPoint.y)
			if !same {
				setSymmetricPixel(point, value: value, symmetryMode: globalSymmetryMode)
			}
			lastPoint = point
			if x0 == x1 && y0 == y1 {
				break
			}
			let e2: Int = err
			if e2 > -dx {
				err -= dy
				x0 += sx
			}
			if e2 < dy {
				err += dx
				y0 += sy
			}
		}
	}
}
