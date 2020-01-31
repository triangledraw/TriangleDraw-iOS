// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension E2Canvas {
	public func coordinates() -> [CGPoint] {
		let w = self.size.width
		let h = self.size.height
		var points = [CGPoint]()
		for y in 0...h {
			for x in 0...w {
				var xx = CGFloat(x)
				xx -= (y & 1) != 0 ? 0.0 : 0.5
				xx += 0.5
				let px = (xx / CGFloat(w)) * 2.0 - 1.0
				let py = (CGFloat(h - y) / CGFloat(h)) * 2.0 - 1.0
				points.append(CGPoint(x: px, y: py))
			}
		}
		return points
	}
}
