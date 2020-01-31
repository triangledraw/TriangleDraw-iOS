// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.

extension E2Canvas {
	public func gameOfLife() -> E2Canvas {
		assert(self.size.width == AppConstant.CanvasFileFormat.width, "width")
		assert(self.size.height == AppConstant.CanvasFileFormat.height, "height")

		let mask: E2Canvas = E2Canvas.bigCanvasMask()
		let resultCanvas: E2Canvas = E2Canvas.createBigCanvas()
		for y in 0..<Int(self.height) {
			for x in 0..<Int(self.width) {
				let point = E2CanvasPoint(x: x, y: y)
				// ignore pixels outside the drawing area
				let m: UInt8 = mask.getPixel(point)
				if m == 0 {
					continue
				}

				let value: UInt8 = self.getPixel(point)
				let isLiveCell: Bool = value > 0

				let numberOfLiveNeighbours: UInt8
				switch point.orientation {
				case .upward:
					numberOfLiveNeighbours = countLiveNeighboursForUpwardTriangle(point: point)
				case .downward:
					numberOfLiveNeighbours = countLiveNeighboursForDownwardTriangle(point: point)
				}


				// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
				//
				// At each step in time, the following transitions occur:
				//
				// A. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
				// B. Any live cell with two or three live neighbours lives on to the next generation.
				// C. Any live cell with more than three live neighbours dies, as if by overpopulation.
				// D. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

				var resultValue: UInt8 = 0 // Rule A and Rule C
				if isLiveCell {
					if numberOfLiveNeighbours == 2 || numberOfLiveNeighbours == 3 {
						resultValue = 1 // Rule B
					}
				} else {
					if numberOfLiveNeighbours == 3 {
						resultValue = 1 // Rule D
					}
				}
				resultCanvas.setPixel(point, value: resultValue)
			}
		}
		return resultCanvas
	}

	fileprivate func countLiveNeighboursForUpwardTriangle(point: E2CanvasPoint) -> UInt8 {
		var counter: UInt8 = 0
		for neighbourType in UpwardTriangleNeighbour.allCases {
			let neighbourPoint: E2CanvasPoint = point.upwardTriangleNeighbour(neighbourType)
			let value: UInt8 = self.getPixel(neighbourPoint)
			if value > 0 {
				counter += neighbourType.weight
			}
		}
		return counter / 2
	}

	fileprivate func countLiveNeighboursForDownwardTriangle(point: E2CanvasPoint) -> UInt8 {
		var counter: UInt8 = 0
		for neighbourType in DownwardTriangleNeighbour.allCases {
			let neighbourPoint: E2CanvasPoint = point.downwardTriangleNeighbour(neighbourType)
			let value: UInt8 = self.getPixel(neighbourPoint)
			if value > 0 {
				counter += neighbourType.weight
			}
		}
		return counter / 2
	}
}

fileprivate enum UpwardTriangleNeighbour: CaseIterable {
	// Above the triangle - Going from left to right
	case aboveMinus1
	case aboveCenter
	case abovePlus1

	// Sides of the triangle - Groing from left to right
	case leftMinus2
	case leftMinus1 // Shares the same edge with the triangle
	case rightPlus1 // Shares the same edge with the triangle
	case rightPlus2

	// Below the triangle - Going from left to right
	case belowMinus2
	case belowMinus1
	case belowCenter // Shares the same edge with the triangle
	case belowPlus1
	case belowPlus2
}

extension UpwardTriangleNeighbour {
	fileprivate var x: Int {
		switch self {
		case .aboveMinus1: return -1
		case .aboveCenter: return 0
		case .abovePlus1:  return +1
		case .leftMinus2:  return -2
		case .leftMinus1:  return -1
		case .rightPlus1:  return +1
		case .rightPlus2:  return +2
		case .belowMinus2: return -2
		case .belowMinus1: return -1
		case .belowCenter: return 0
		case .belowPlus1:  return +1
		case .belowPlus2:  return +2
		}
	}

	fileprivate var y: Int {
		switch self {
		case .aboveMinus1: return -1
		case .aboveCenter: return -1
		case .abovePlus1:  return -1
		case .leftMinus2:  return 0
		case .leftMinus1:  return 0
		case .rightPlus1:  return 0
		case .rightPlus2:  return 0
		case .belowMinus2: return +1
		case .belowMinus1: return +1
		case .belowCenter: return +1
		case .belowPlus1:  return +1
		case .belowPlus2:  return +1
		}
	}

	/// More weight for triangles that shares the same edge with the center triangle
	/// Less weight for triangles that are far away from the center triangle
	fileprivate var weight: UInt8 {
		switch self {
		case .leftMinus1, .rightPlus1, .belowCenter:
			return 4
		case .aboveCenter, .belowMinus2, .belowPlus2:
			return 2
		default:
			return 1
		}
	}
}

fileprivate enum DownwardTriangleNeighbour: CaseIterable {
	// Above the triangle - Going from left to right
	case aboveMinus2
	case aboveMinus1
	case aboveCenter // Shares the same edge with the triangle
	case abovePlus1
	case abovePlus2

	// Sides of the triangle - Groing from left to right
	case leftMinus2
	case leftMinus1 // Shares the same edge with the triangle
	case rightPlus1 // Shares the same edge with the triangle
	case rightPlus2

	// Below the triangle - Going from left to right
	case belowMinus1
	case belowCenter
	case belowPlus1
}

extension DownwardTriangleNeighbour {
	fileprivate var x: Int {
		switch self {
		case .aboveMinus2: return -2
		case .aboveMinus1: return -1
		case .aboveCenter: return 0
		case .abovePlus1:  return +1
		case .abovePlus2:  return +2
		case .leftMinus2:  return -2
		case .leftMinus1:  return -1
		case .rightPlus1:  return +1
		case .rightPlus2:  return +2
		case .belowMinus1: return -1
		case .belowCenter: return 0
		case .belowPlus1:  return +1
		}
	}

	fileprivate var y: Int {
		switch self {
		case .aboveMinus2: return -1
		case .aboveMinus1: return -1
		case .aboveCenter: return -1
		case .abovePlus1:  return -1
		case .abovePlus2:  return -1
		case .leftMinus2:  return 0
		case .leftMinus1:  return 0
		case .rightPlus1:  return 0
		case .rightPlus2:  return 0
		case .belowMinus1: return +1
		case .belowCenter: return +1
		case .belowPlus1:  return +1
		}
	}

	/// More weight for triangles that shares the same edge with the center triangle
	/// Less weight for triangles that are far away from the center triangle
	fileprivate var weight: UInt8 {
		switch self {
		case .aboveCenter, .leftMinus1, .rightPlus1:
			return 4
		case .belowCenter, .aboveMinus2, .abovePlus2:
			return 2
		default:
			return 1
		}
	}
}

extension E2CanvasPoint {
	fileprivate func upwardTriangleNeighbour(_ neighbourType: UpwardTriangleNeighbour) -> E2CanvasPoint {
		return self.offset(x: neighbourType.x, y: neighbourType.y)
	}

	fileprivate func downwardTriangleNeighbour(_ neighbourType: DownwardTriangleNeighbour) -> E2CanvasPoint {
		return self.offset(x: neighbourType.x, y: neighbourType.y)
	}
}
