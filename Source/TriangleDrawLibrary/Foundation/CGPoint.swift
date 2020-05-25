// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

extension CGPoint {
	public var flip: CGPoint {
		return CGPoint(x: -x, y: -y)
	}
	
	public var flipY: CGPoint {
		return CGPoint(x: x, y: -y)
	}

	public func offset(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
		return CGPoint(x: self.x + x, y: self.y + y)
	}
	
	public func offsetX(_ x: CGFloat) -> CGPoint {
		return CGPoint(x: self.x + x, y: self.y)
	}
	
	public func offsetY(_ y: CGFloat) -> CGPoint {
		return CGPoint(x: self.x, y: self.y + y)
	}
	
	public func offset(_ point: CGPoint) -> CGPoint {
		return CGPoint(x: self.x + point.x, y: self.y + point.y)
	}
	
	public func scaleBy(_ scale: CGFloat) -> CGPoint {
		return CGPoint(x: self.x * scale, y: self.y * scale)
	}

	public func divideBy(_ amount: CGFloat) -> CGPoint {
		return CGPoint(x: self.x / amount, y: self.y / amount)
	}
	
	public var rounded: CGPoint {
		return CGPoint(x: round(self.x), y: round(self.y))
	}
	
	public var lengthSquared: CGFloat {
		return x * x + y * y
	}
	
	public func scaleBy(_ scale: CGFloat, aroundPoint center: CGPoint) -> CGPoint {
		let x0 = x - center.x
		let x1 = x0 * scale
		let x2 = x1 + center.x
		let y0 = y - center.y
		let y1 = y0 * scale
		let y2 = y1 + center.y
		return CGPoint(x: x2, y: y2)
	}

	/// Round to nearest pixel, eg. 1/1, 1/2, 1/3 depending on retina mode
	public func alignToNearestPixel(_ screenScale: Int) -> CGPoint {
		let scale = CGFloat(screenScale)
		let inv = 1 / scale
		
		let x = self.x * scale
		let rx = floor(x)
		let xx = rx * inv

		let y = self.y * scale
		let ry = floor(y)
		let yy = ry * inv
		return CGPoint(x: xx, y: yy)
	}
}
