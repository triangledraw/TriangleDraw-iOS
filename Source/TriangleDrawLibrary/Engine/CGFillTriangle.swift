// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension CGContext {
	public func triangleDraw_setFillColor(triangleValue: UInt8) {
		switch triangleValue {
		case 0:
			setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
		case 1:
			setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		case 255:
			setFillColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
		default:
			setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
		}
	}
	

	public func triangleDraw_fillTriangle(a: CGPoint, b: CGPoint, c: CGPoint) {
		beginPath()
		move(to: a)
		addLine(to: b)
		addLine(to: c)
		closePath()
		fillPath()
	}


	public func triangleDraw_fillTrianglesInTile(triangles: [E2CanvasTriangle2], window_x0: Double, window_x1: Double, window_y0: Double, window_y1: Double, scale_x: Double, scale_y: Double) {
		for (triangleIndex, triangle) in triangles.enumerated() {
			if AppConstant.TDRenderBitmap.debug_fillTriangles_skip {
				if triangleIndex % 9 <= 4 {
					continue
				}
			}
			let t: E2CanvasTriangle2 = triangle
			if Double(t.a.x) < window_x0 {
				continue
			}
			if Double(t.a.x) > window_x1 {
				continue
			}
			if Double(t.a.y) < window_y0 {
				continue
			}
			if Double(t.a.y) > window_y1 {
				continue
			}
			var x0 = Double(t.a.x)
			var y0 = Double(t.a.y)
			var x1 = Double(t.b.x)
			var y1 = Double(t.b.y)
			var x2 = Double(t.c.x)
			var y2 = Double(t.c.y)
			x0 *= scale_x
			y0 *= scale_y
			x1 *= scale_x
			y1 *= scale_y
			x2 *= scale_x
			y2 *= scale_y
			x0 = round(x0)
			y0 = round(y0)
			x1 = round(x1)
			y1 = round(y1)
			x2 = round(x2)
			y2 = round(y2)
			x0 -= round(window_x0 * scale_x)
			y0 -= round(window_y0 * scale_y)
			x1 -= round(window_x0 * scale_x)
			y1 -= round(window_y0 * scale_y)
			x2 -= round(window_x0 * scale_x)
			y2 -= round(window_y0 * scale_y)

			triangleDraw_setFillColor(triangleValue: t.value)

			triangleDraw_fillTriangle(
				a: CGPoint(x: CGFloat(x0), y: CGFloat(y0)),
				b: CGPoint(x: CGFloat(x1), y: CGFloat(y1)),
				c: CGPoint(x: CGFloat(x2), y: CGFloat(y2))
			)
		}
	}
}
