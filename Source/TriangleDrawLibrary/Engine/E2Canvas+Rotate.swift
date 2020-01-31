// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

struct E2CanvasClockwiseRotater {
	let canvas: E2Canvas
	let w: Int
	let h: Int
	let h2: Int
	let half_w: Float
	let half_h: Float

	init(canvas: E2Canvas) {
		let w = Int(canvas.cellsPerRow)
		let h = Int(canvas.cellsPerColumn)
		let h2 = Int(canvas.size.height)
		let half_w: Float = Float(w) * 0.5
		let half_h: Float = Float(h2) * 0.5
		self.canvas = canvas
		self.w = w
		self.h = h
		self.h2 = h2
		self.half_w = half_w
		self.half_h = half_h
	}

	func convert(pointInput: E2CanvasPoint) -> E2CanvasPoint? {
		let i: Int = pointInput.x >> 1
		let ii: Bool = pointInput.x & 1 == 1

		let j: Int = pointInput.y >> 1
		let jj: Bool = pointInput.y & 1 == 1

		let cx: Float = Float(i) + 0.25
		let cy: Float = Float(j * 2 + 1)

		let i2: Float
		let j2: Float
		switch (ii, jj) {
		case (false, false):
			i2 = cx + 0.0
			j2 = cy - 0.75
		case (false, true):
			i2 = cx + 0.0
			j2 = cy + 0.75
		case (true, false):
			i2 = cx + 1.0
			j2 = cy - 0.25
		case (true, true):
			i2 = cx + 1.0
			j2 = cy + 0.25
		}
		let x: Float = (i2 - half_w) / half_w
		let y: Float = (j2 - half_h) / half_h
		let cgPoint = CGPoint(x: CGFloat(x), y: CGFloat(y))
		return canvas.pointRotatedClockwise(cgPoint)
	}
}

extension E2Canvas {
	public func rotateClockwise() {
		let sourceCanvas: E2Canvas = self.createCopy()
		let rotator = E2CanvasClockwiseRotater(canvas: sourceCanvas)
        for y in 0..<Int(self.cellsPerColumn * 2) {
            for x in 0..<Int(self.cellsPerRow * 2) {
				let destinationPoint = E2CanvasPoint(x: x, y: y)
				if let sourcePoint: E2CanvasPoint = rotator.convert(pointInput: destinationPoint) {
					let value: UInt8 = sourceCanvas.getPixel(sourcePoint)
					self.setPixel(destinationPoint, value: value)
				}
            }
        }
    }

    public func rotateCounterClockwise() {
        // Rotating counter clockwise by 60 degrees, is the same as rotating clockwise 5 times 60 degrees.
        rotateClockwise()
        rotateClockwise()
        rotateClockwise()
        rotateClockwise()
        rotateClockwise()
    }

	fileprivate func pointRotatedClockwise(_ point: CGPoint) -> E2CanvasPoint? {
		let point_x = Float(point.x)
		let point_y = Float(point.y)
		let rads: Float = .pi / 3.0
		let rot_x = Float(point_x * cosf(rads) - point_y * sinf(rads))
		let rot_y = Float(point_y * cosf(rads) + point_x * sinf(rads))
		let lookup_x: Float = (rot_x + 1.0) * 0.5
		let lookup_y: Float = (rot_y + 1.0) * 0.5
		if lookup_x < 0.0 || lookup_x > 1.0 || lookup_y < 0.0 || lookup_y > 1.0 {
			return nil
		}
		let canvasPoint: E2CanvasPoint = self.canvasPoint(from: CGPoint(x: CGFloat(lookup_x), y: CGFloat(lookup_y)))
		return canvasPoint
	}
}
