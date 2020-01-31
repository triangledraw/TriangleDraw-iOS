// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.

public struct E2CanvasBoundingBox {
	/// Index of the left-most column where the user have drawn content.
	///
	/// Ignores as many empty columns as possible from the left.
	let minX: UInt

	/// Index of the right-most column where the user have drawn content.
	///
	/// Ignores as many empty columns as possible from the right.
	let maxX: UInt

	/// Index of the top-most row where the user have drawn content.
	///
	/// Ignores as many empty rows as possible from the top.
	let minY: UInt

	/// Index of the bottom-most row where the user have drawn content.
	///
	/// Ignores as many empty rows as possible from the bottom.
	let maxY: UInt
}

extension E2CanvasBoundingBox: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "xRange: \(minX)..\(maxX), yRange: \(minY)..\(maxY), size: \(width)x\(height), midX: \(midX.string1), midY: \(midY.string1)"
	}
}

extension E2CanvasBoundingBox {
	public var width: UInt {
		let value: Int = 1 + Int(maxX) - Int(minX)
		guard value > 0 else {
			log.error("Expected the xRange to be non-negative, but got  minX: \(minX)  maxX: \(maxX)")
			return 0
		}
		return UInt(value)
	}

	public var height: UInt {
		let value: Int = 1 + Int(maxY) - Int(minY)
		guard value > 0 else {
			log.error("Expected the yRange to be non-negative, but got  minY: \(minY)  maxY: \(maxY)")
			return 0
		}
		return UInt(value)
	}
}

extension E2CanvasBoundingBox {
	public var midX: Float {
		return Float(1 + minX + maxX) / 2
	}
	
	public var midY: Float {
		return Float(1 + minY + maxY) / 2
	}
}

public class E2CanvasBoundingBoxFinder {
	public let canvas: E2Canvas
	public let mask: E2Canvas

	public init(canvas: E2Canvas) {
		assert(canvas.size.width == AppConstant.CanvasFileFormat.width, "width")
		assert(canvas.size.height == AppConstant.CanvasFileFormat.height, "height")
		self.canvas = canvas
		self.mask = E2Canvas.bigCanvasMask()
		assert(mask.cellsPerColumn == canvas.cellsPerColumn)
		assert(mask.cellsPerRow == canvas.cellsPerRow)
	}

	public func result() -> E2CanvasBoundingBox? {
		let minXOrNil: UInt? = findMinX()
		let maxXOrNil: UInt? = findMaxX()
		let minYOrNil: UInt? = findMinY()
		let maxYOrNil: UInt? = findMaxY()
		if minXOrNil == nil && maxXOrNil == nil && minYOrNil == nil && maxYOrNil == nil {
			log.debug("Unable to find bounds of an empty canvas")
			return nil
		}
		// Either we can compute all of the values or none of the values.
		// There is something wrong if some of the values could be computed and yet some values are missing
		guard let minX = minXOrNil, let maxX = maxXOrNil, let minY = minYOrNil, let maxY = maxYOrNil else {
			let resolvedMinX: UInt = minXOrNil ?? 666
			let resolvedMaxX: UInt = maxXOrNil ?? 666
			let resolvedMinY: UInt = minYOrNil ?? 666
			let resolvedMaxY: UInt = maxYOrNil ?? 666
			log.error("Inconsistency. Partially found the bounds. Got: minX: \(resolvedMinX) maxX: \(resolvedMaxX) minY: \(resolvedMinY) maxY: \(resolvedMaxY)")
			return nil
		}
		guard minX < maxX else {
			log.error("Inconsistency. The xRange is not supposed to be negative, but got: minX: \(minX)  maxX: \(maxX)")
			return nil
		}
		guard minY < maxY else {
			log.error("Inconsistency. The yRange is not supposed to be negative, but got: minY: \(minY)  maxY: \(maxY)")
			return nil
		}
		return E2CanvasBoundingBox(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
	}

	public lazy var histogram: E2Canvas.HistogramResult = {
		return canvas.histogram()
	}()

	/// Identify the most used pixel value
	///
	/// This is used for determining what makes up the empty areas and the content created by the user
	public lazy var mostUsedPixelValue: UInt8 = {
		var foundNumberOfOccurances: UInt = 0
		var foundPixelValue: UInt8 = 255
		for (pixelValue, numberOfOccurrances) in self.histogram {
			if numberOfOccurrances > foundNumberOfOccurances {
				foundNumberOfOccurances = numberOfOccurrances
				foundPixelValue = pixelValue
			}
		}
		return foundPixelValue
	}()

	/// Find the top-most row where the user have drawn content.
	///
	/// Ignores as many empty rows as possible from the top.
	public func findMinY() -> UInt? {
		let mostUsedPixelValue: UInt8 = self.mostUsedPixelValue
		for j: UInt in 0..<canvas.height {
			for i: UInt in 0..<canvas.width {
				let point = E2CanvasPoint(x: Int(i), y: Int(j))
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}
				// compare with the most used pixel value
				let value: UInt8 = canvas.getPixel(point)
				if value != mostUsedPixelValue {
					return j
				}
			}
		}
		return nil
	}

	/// Find the bottom-most row where the user have drawn content.
	///
	/// Ignores as many empty rows as possible from the bottom.
	public func findMaxY() -> UInt? {
		let mostUsedPixelValue: UInt8 = self.mostUsedPixelValue
		var j = Int(canvas.height - 1)
		while j >= 0 {
			for i: UInt in 0..<canvas.width {
				let point = E2CanvasPoint(x: Int(i), y: j)
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}
				// compare with the most used pixel value
				let value: UInt8 = canvas.getPixel(point)
				if value != mostUsedPixelValue {
					return UInt(j)
				}
			}
			j -= 1
		}
		return nil
	}

	/// Find the left-most column where the user have drawn content.
	///
	/// Ignores as many empty columns as possible from the left.
	public func findMinX() -> UInt? {
		let mostUsedPixelValue: UInt8 = self.mostUsedPixelValue
		for i: UInt in 0..<canvas.width {
			for j: UInt in 0..<canvas.height {
				let point = E2CanvasPoint(x: Int(i), y: Int(j))
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}
				// compare with the most used pixel value
				let value: UInt8 = canvas.getPixel(point)
				if value != mostUsedPixelValue {
					return i
				}
			}
		}
		return nil
	}

	/// Find the right-most column where the user have drawn content.
	///
	/// Ignores as many empty columns as possible from the right.
	public func findMaxX() -> UInt? {
		var i = Int(canvas.width - 1)
		let mostUsedPixelValue: UInt8 = self.mostUsedPixelValue
		while i >= 0 {
			for j: UInt in 0..<canvas.height {
				let point = E2CanvasPoint(x: i, y: Int(j))
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}
				// compare with the most used pixel value
				let value: UInt8 = canvas.getPixel(point)
				if value != mostUsedPixelValue {
					return UInt(i + 1)
				}
			}
			i -= 1
		}
		return nil
	}
}
