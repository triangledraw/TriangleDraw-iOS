// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import CoreGraphics

public struct E2TriangleResult {
    // x can be: -1, 0, +1
    // y can be:     0, +1
    public var x: Int = 0
    public var y: Int = 0
}

public class E2Canvas {
	public var cells: [E2TriangleCell]
	public let cellsPerRow: UInt
	public let cellsPerColumn: UInt
	public let size: E2CanvasSize

    public var width: UInt {
		// IDEA: eliminate 2x
        return self.size.width * 2
    }
    public var height: UInt {
        return self.size.height
    }

	private lazy var wrapOffsets: [Int: Int] = {
		let canvasSize: E2CanvasSize = self.size
		assert(canvasSize.width == AppConstant.CanvasFileFormat.width, "width")
		assert(canvasSize.height == AppConstant.CanvasFileFormat.height, "height")
		let width: Int = Int(canvasSize.width * 2)
		let height: Int = Int(canvasSize.height)
		var offsets = [Int: Int]()

		func REGISTER_WRAP_POINT(_ x0: Int, _ y0: Int, _ x1: Int, _ y1: Int) {
			let offset0 = y0 * width + x0
			let offset1 = y1 * width + x1
			offsets[offset0] = offset1
		}

		// Left top half
		for i in 0...45 {
			REGISTER_WRAP_POINT(i + 0, 51 - i, i + 132, 95 - i)
			REGISTER_WRAP_POINT(i + 1, 51 - i, i + 133, 95 - i)
		}
		// Left bottom half
		for i in 0...43 {
			REGISTER_WRAP_POINT(i + 0, i + 52, i + 132, i + 8)
			REGISTER_WRAP_POINT(i + 1, i + 52, i + 133, i + 8)
		}
		// Right top half
		for i in 0...43 {
			REGISTER_WRAP_POINT(i + 134, i + 8, i + 2, i + 52)
			REGISTER_WRAP_POINT(i + 135, i + 8, i + 3, i + 52)
		}
		// Right bottom half
		for i in 0...43 {
			REGISTER_WRAP_POINT(i + 134, 95 - i, i + 2, 51 - i)
			REGISTER_WRAP_POINT(i + 135, 95 - i, i + 3, 51 - i)
		}
		// Top side
		for i in 45..<width - 44 {
			REGISTER_WRAP_POINT(i, 6, i, 94)
			REGISTER_WRAP_POINT(i, 7, i, 95)
		}
		REGISTER_WRAP_POINT(134, 7, 2, 51)
		// Bottom side
		for i in 45..<width - 44 {
			REGISTER_WRAP_POINT(i, 96, i, 8)
			REGISTER_WRAP_POINT(i, 97, i, 9)
		}
		REGISTER_WRAP_POINT(134, 96, 2, 52)
		REGISTER_WRAP_POINT(44, 96, 176, 52)
		return offsets
    }()

    public class func createBigCanvas() -> E2Canvas {
		return E2Canvas(canvasSize: E2CanvasSize(width: AppConstant.CanvasFileFormat.width, height: AppConstant.CanvasFileFormat.height))
    }

	private static var bigMask: E2Canvas?

    public static func bigCanvasMask() -> E2Canvas {
		if let bigMask = self.bigMask {
			return bigMask
		}
		let instance: E2Canvas = E2Canvas.bigCanvasMask_create()
		bigMask = instance
		return instance
    }

	public static func bigCanvasMask_create() -> E2Canvas {
		let meta = TriangleDrawFrameworkMeta()
		let url: URL = meta.urlHexagonMask
		guard let content = try? String(contentsOf: url, encoding: .utf8) else {
			log.error("Unable to load mask file from url: \(url)")
			fatalError("Unable to load mask file from url: \(url)")
		}
		let canvas: E2Canvas = E2Canvas.createBigCanvas()
		canvas.load(fromStringRepresentation: content)
		return canvas
	}

    public static func triangle(from aPoint: CGPoint) -> E2TriangleResult {
		return aPoint.e2TriangleResult
    }

    public init(canvasSize size: E2CanvasSize) {
		let w: UInt = size.width
        let h: UInt = size.height
        let h2: UInt = h / 2
        let cpr: UInt = w
        let cpc: UInt = h2
        assert((w > 0), "size.width must be greater than 0")
        assert((h > 0), "size.height must be greater than 0")
        assert(((h & 1) == 0), "size.height must be an even number")

		let repeating = E2TriangleCell(tl: 0, tr: 0, bl: 0, br: 0)
		let repeatCount: UInt = cpr * cpc
		let cells = [E2TriangleCell](repeating: repeating, count: Int(repeatCount))

		self.cells = cells
		self.size = size
		self.cellsPerRow = cpr
		self.cellsPerColumn = cpc

        clearWithBlackColor()
    }

    public func clearWithBlackColor() {
		self.clear(0)
    }

    public func clearWithWhiteColor() {
		self.clear(1)
    }

    public func trianglePattern() {
		self.fillWithPattern()
    }

	public func getWrapPixel(_ point: E2CanvasPoint) -> UInt8 {
		let width: Int = Int(self.cellsPerRow * 2)
		let offset: Int = point.y * width + point.x
		if let offset1 = wrapOffsets[offset], offset1 > 0 {
			let wrappedPoint = E2CanvasPoint(x: offset1 % width, y: offset1 / width)
			return self.inner_getPixel(point: wrappedPoint)
		}
		return self.inner_getPixel(point: point)
	}

    public func canvasPoint(from aPoint: CGPoint) -> E2CanvasPoint {
		return self.E2CanvasPoint_from_CGPoint(aPoint)
    }

    /*
    aPoint.x must be in the range -1..+1
    aPoint.y must be in the range -1..+1
    
    In the following diagram 
         input:  x,y
        output: [x,y]
    
    output.x can be: -1, 0, +1
    output.y can be:     0, +1
    
     
                       0,-1
    -1,-1 ***************************** +1,-1
          *                           *
          * *         [0,0]         * *
          *   *                   *   *
          *     *               *     *
          *       *           *       *
          *         *       *         *
          *  [-1,0]   *   *   [+1,0]  *
          *             *             * 
     -1,0 ***************************** +1,0
          *             *             * 
          * [-1,+1]   *   *   [+1,+1] *
          *         *       *         *
          *       *           *       *
          *     *               *     *
          *   *                   *   *
          * *         [0,+1]        * *
          *                           *
    -1,+1 ***************************** +1,+1
                       0,+1
     
     
    */

	public func createCopy() -> E2Canvas {
		let canvasCopy = E2Canvas(canvasSize: self.size)
		canvasCopy.cells = self.cells  // copy by value
		return canvasCopy
	}

	public func printPixel(_ x: Int, _ y: Int) {
		let point = E2CanvasPoint(x: x, y: y)
		let value: UInt8 = getPixel(point)
		print("pixel[\(x), \(y)] = \(value)")
	}



    /*
     aPoint.x must be in the range 0..1
     aPoint.y must be in the range 0..1
     */

    /*
     
                       +1,0
      0,0 ***************************** +2,0
          *                           *
          : *        topleft        *   *
          :   *                   *       *
          :     *               *           *
          :       *           *               *
          :         *       *                   *
          :           *   *        topright       *
          :             *                           * 
     0,+1 :             ***************************** +3,+1
          :             *                           * 
          :           *   *      bottomright      *
          :         *       *                   *
          :       *           *               *
          :     *               *           *
          :   *                   *       *
          : *       bottomleft      *   *
          *                           *
     0,+2 ***************************** +2,+2
                      +1,+2
     
     
     
     */

}

extension E2Canvas {
	public func clear(_ value: UInt8) {
		let cell = E2TriangleCell(tl: value, tr: value, bl: value, br: value)
		for i in 0..<cells.count {
			self.cells[i] = cell
		}
	}
}

extension E2Canvas {
	public func fillWithPattern() {
		let cell = E2TriangleCell(tl: 1, tr: 0, bl: 0, br: 1)
		for i in 0..<cells.count {
			self.cells[i] = cell
		}
	}
}

extension E2Canvas {
	public func invertPixels() {
		for i in 0..<cells.count {
			let cell: E2TriangleCell = self.cells[i]
			let tl: UInt8 = (cell.tl == 0) ? 1 : 0
			let tr: UInt8 = (cell.tr == 0) ? 1 : 0
			let bl: UInt8 = (cell.bl == 0) ? 1 : 0
			let br: UInt8 = (cell.br == 0) ? 1 : 0
			self.cells[i] = E2TriangleCell(tl: tl, tr: tr, bl: bl, br: br)
		}
	}
}

extension E2Canvas {
	public func clearPixelsOutsideHexagon() {
		_setAllPixelsOutsideHexagon(value: 0)
	}

	public func maskAllPixelsOutsideHexagon() {
		_setAllPixelsOutsideHexagon(value: 255)
	}

	private func _setAllPixelsOutsideHexagon(value: UInt8) {
		guard self.size.width == AppConstant.CanvasFileFormat.width else {
			return
		}
		guard self.size.height == AppConstant.CanvasFileFormat.height else {
			return
		}
		let w: UInt = self.cellsPerRow
		let h: UInt = self.cellsPerColumn
		let mask: E2Canvas = E2Canvas.bigCanvasMask()
		let maskCells: [E2TriangleCell] = mask.cells
		guard w == mask.cellsPerRow && h == mask.cellsPerColumn else {
			return
		}
		for j: UInt in 0..<h {
			for i: UInt in 0..<w {
				let offset = Int(j * w + i)
				var canvasCell: E2TriangleCell = self.cells[offset]
				let maskCell: E2TriangleCell = maskCells[offset]
				if maskCell.tl == 0 {
					canvasCell.tl = value
				}
				if maskCell.tr == 0 {
					canvasCell.tr = value
				}
				if maskCell.bl == 0 {
					canvasCell.bl = value
				}
				if maskCell.br == 0 {
					canvasCell.br = value
				}
				self.cells[offset] = canvasCell
			}
		}
	}
}

extension CGPoint {
	/// result.x can be: -1, 0, +1
	/// result.y can be:     0, +1
	public var e2TriangleResult: E2TriangleResult {
		var result_x: Int = 1
		var result_y: Int = 1
		var x = Double(self.x)
		var y = Double(self.y)
		if y < 0 {
			result_y = 0
			y = -y
		}
		if x < 0 {
			result_x = -1
			x = -x
		}
		if x < y {
			result_x = 0
		}
		return E2TriangleResult(x: result_x, y: result_y)
	}
}

extension E2Canvas {
	public func E2CanvasPoint_from_CGPoint(_ aPoint: CGPoint) -> E2CanvasPoint {
		let w = self.cellsPerRow
		let h = self.cellsPerColumn
		let cx = Double(aPoint.x) * Double(w)
		let cy = Double(aPoint.y) * Double(h)
		var integral_x: Double = 0
		var integral_y: Double = 0
		let fractional_x = modf(cx, &integral_x)
		let fractional_y = modf(cy, &integral_y)
		// remap from the range 0..1 to the range -1..+1
		let px: Double = fractional_x * 2.0 - 1.0
		let py: Double = fractional_y * 2.0 - 1.0
		let result: E2TriangleResult = CGPoint(x: px, y: py).e2TriangleResult
		// result.x can be: -1, 0, +1
		// result.y can be:     0, +1
		let index_x: Int = (Int(integral_x)) * 2 + result.x
		let index_y: Int = (Int(integral_y)) * 2 + result.y
		// DLog(@"%.2f %.2f -> %.2f %.2f -> %.2f,%.2f %.2f,%.2f -> %i %i -> %i %i", aPoint.x, aPoint.y, cx, cy, integral_x, fractional_x, integral_y, fractional_y, result.x, result.y, index.x, index.y);
		return E2CanvasPoint(x: index_x, y: index_y)
	}
}
