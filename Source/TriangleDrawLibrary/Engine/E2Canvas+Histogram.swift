// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.

extension E2Canvas {
	public typealias HistogramResult = [UInt8: UInt]

	/// Count the number of times a pixel value occurs inside the masked area
	public func histogram() -> HistogramResult {
		assert(self.size.width == AppConstant.CanvasFileFormat.width, "width")
		assert(self.size.height == AppConstant.CanvasFileFormat.height, "height")
		let mask: E2Canvas = E2Canvas.bigCanvasMask()
		var counters = [UInt](repeating: 0, count: 256)
		for j: UInt in 0..<self.height {
			for i: UInt in 0..<self.width {
				let point = E2CanvasPoint(x: Int(i), y: Int(j))
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}
				// increase the number of times this pixel has occurred
				let value: UInt8 = self.getPixel(point)
				counters[Int(value)] += 1
			}
		}
		var result = HistogramResult()
		for (index, counterValue) in counters.enumerated() {
			let key = UInt8(index)
			if counterValue > 0 {
				result[key] = counterValue
			}
		}
		return result
	}
}
