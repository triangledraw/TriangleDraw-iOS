// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics
import simd
import TriangleDrawLibrary

class HCBuildHexagonCanvas {
	var filledtriangle_vertices = [HCFilledTriangleVertex]()
	var filledtriangle_indices = [UInt16]()
	var filledtriangle_count = 0

	var filledcircle_vertices = [HCFilledCircleVertex]()
	var filledcircle_indices = [UInt16]()

	var corners = HCHexagonCorners()

	func create_filledCircles_from_filledTriangles() {
		// Create list of points without duplicate positions
		var dict = [String: HCFilledTriangleVertex]()
		for vertex: HCFilledTriangleVertex in filledtriangle_vertices {
			let original_x: String = vertex.position.x.string2
			let original_y: String = vertex.position.y.string2

			// Sporadic the same point was added multiple times to the dictionary
			// Even though this code was supposed to reject duplicate points.
			// After closer investigation, coordinates around 0 is causing a
			// funny problem when converted from float to string
			// Sometimes a number becomes -0.00 and other times it's just 0.00
			// Getting rid of the `-` prefix, solved the problem.
			// At first I thought this was a problem with my fragment shader.
			let x: String = original_x.replacingOccurrences(of: "-0.00", with: "0.00")
			let y: String = original_y.replacingOccurrences(of: "-0.00", with: "0.00")

			let s = "\(x),\(y)"
			if dict.keys.contains(s) {
				continue
			}
			dict[s] = vertex
		}
		let filledcircle_vertices: [HCFilledCircleVertex] = dict.values.map {
			HCFilledCircleVertex(position: $0.position)
		}
		var filledcircle_indices = [UInt16]()
		for (index, _) in filledcircle_vertices.enumerated() {
			filledcircle_indices.append(UInt16(index))
		}
		//print("filledcircle_indices: \(filledcircle_indices.count)")

		self.filledcircle_indices = filledcircle_indices
		self.filledcircle_vertices = filledcircle_vertices
	}

	func appendVertex(_ vertex: HCFilledTriangleVertex) {
		let n: UInt16 = UInt16(filledtriangle_vertices.count)
		filledtriangle_vertices.append(vertex)
		filledtriangle_indices.append(n)
	}

	func appendTriangles(repeatCount: Int, leftMostPosition: CGPoint, width: CGFloat, height: CGFloat) {
		func convert(_ point: CGPoint) -> TDFloat2 {
			return TDFloat2(Float(point.x), Float(point.y))
		}

		for i in 0..<repeatCount {
			let left: CGPoint   = leftMostPosition.offsetX(CGFloat(i) * width)
			let middle: CGPoint = leftMostPosition.offset((CGFloat(i) + 0.5) * width, height)
			let right: CGPoint  = leftMostPosition.offsetX(CGFloat(i + 1) * width)

			if i < repeatCount / 2 {
				appendVertex(HCFilledTriangleVertex(position: convert(left),   color: TDFloat4(1, 0, 0, 1)))
				appendVertex(HCFilledTriangleVertex(position: convert(middle), color: TDFloat4(0, 1, 0, 1)))
				appendVertex(HCFilledTriangleVertex(position: convert(right),  color: TDFloat4(0, 0, 1, 1)))
			} else
				if filledtriangle_count % 2 == 0 {
					appendVertex(HCFilledTriangleVertex(position: convert(left),   color: TDFloat4(0, 0, 0, 1)))
					appendVertex(HCFilledTriangleVertex(position: convert(middle), color: TDFloat4(0, 0, 0, 1)))
					appendVertex(HCFilledTriangleVertex(position: convert(right),  color: TDFloat4(0, 0, 0, 1)))
				} else {
					appendVertex(HCFilledTriangleVertex(position: convert(left),   color: TDFloat4(1, 1, 1, 1)))
					appendVertex(HCFilledTriangleVertex(position: convert(middle), color: TDFloat4(1, 1, 1, 1)))
					appendVertex(HCFilledTriangleVertex(position: convert(right),  color: TDFloat4(1, 1, 1, 1)))
			}

		}
		filledtriangle_count += 1
	}

	func buildHexagon(sideCount: Int) {
		let halfWidth: CGFloat = 1
		let halfHeight: CGFloat = halfWidth * CGFloat(AppConstant.Canvas.hexagonApothem)
		let x0: CGFloat = -halfWidth
		let x1: CGFloat = halfWidth
		let y0: CGFloat = -halfHeight
		let y1: CGFloat = halfHeight
		let w = x1 - x0
		let h = y1 - y0
		let sideCountMinus1 = sideCount - 1
		let n = sideCount * 2
		let width: CGFloat = w / CGFloat(n)
		let height: CGFloat = h / CGFloat(n)
		let ycenter = (y1 + y0) / 2

		// Build the "Bottom half" of the hexagon canvas, from bottom to top
		for j in 0...sideCountMinus1 {
			let i = sideCountMinus1 - j
			// Bottom half of the hexagon canvas. Triangles oriented downwards
			appendTriangles(
				repeatCount: n - i,
				leftMostPosition: CGPoint(x: x0 + width * CGFloat(i) / 2, y: ycenter - height * CGFloat(i)),
				width: width,
				height: -height
			)

			// Bottom half of the hexagon canvas. Triangles oriented upwards
			appendTriangles(
				repeatCount: n - i - 1,
				leftMostPosition: CGPoint(x: x0 + width * CGFloat(i + 1)  / 2, y: ycenter - height * CGFloat(i + 1)),
				width: width,
				height: height
			)
		}

		// Build the "Top half" of the hexagon canvas, from bottom to top
		for i in 0...sideCountMinus1 {
			// Top half of the hexagon canvas. Triangles oriented downwards
			appendTriangles(
				repeatCount: n - i - 1,
				leftMostPosition: CGPoint(x: x0 + width * CGFloat(i + 1)  / 2, y: ycenter + height * CGFloat(i + 1)),
				width: width,
				height: -height
			)

			// Top half of the hexagon canvas. Triangles oriented upwards
			appendTriangles(
				repeatCount: n - i,
				leftMostPosition: CGPoint(x: x0 + width * CGFloat(i) / 2, y: ycenter + height * CGFloat(i)),
				width: width,
				height: height
			)
		}

		let insetLength: CGFloat = w / 4
		self.corners.topLeft     = CGPoint(x: x0 + insetLength, y: y1)
		self.corners.topRight    = CGPoint(x: x1 - insetLength, y: y1)
		self.corners.middleLeft  = CGPoint(x: x0, y: ycenter)
		self.corners.middleRight = CGPoint(x: x1, y: ycenter)
		self.corners.bottomLeft  = CGPoint(x: x0 + insetLength, y: y0)
		self.corners.bottomRight = CGPoint(x: x1 - insetLength, y: y0)
	}

	func buildHexagon2() {
		//let canvas: E2Canvas = DocumentExample.triangledrawLogo.canvas
		let canvas: E2Canvas = DocumentExample.developer_rows.canvas
		//let canvas: E2Canvas = DocumentExample.developer_columns.canvas
		buildHexagon(canvas: canvas)
	}

	func buildHexagon(canvas: E2Canvas) {
		func convert(_ point: CGPoint) -> TDFloat2 {
			return TDFloat2(Float(point.x), Float(point.y))
		}

		let maskCanvas: E2Canvas = E2Canvas.bigCanvasMask()
		let coordinates: [CGPoint] = canvas.coordinates()

		let whiteColor = TDFloat4(1, 1, 1, 1)
		let grayColor = TDFloat4(0.5, 0.5, 0.5, 1)
		let blackColor = TDFloat4(0, 0, 0, 1)

		func appendTriangle(a: Int, b: Int, c: Int, value: UInt8) {
			let color: TDFloat4
			if value >= 2 {
				color = grayColor
			} else {
				if value >= 1 {
					color = whiteColor
				} else {
					color = blackColor
				}
			}
			let position_a = convert(coordinates[a])
			let position_b = convert(coordinates[b])
			let position_c = convert(coordinates[c])
			appendVertex(HCFilledTriangleVertex(position: position_a, color: color))
			appendVertex(HCFilledTriangleVertex(position: position_b, color: color))
			appendVertex(HCFilledTriangleVertex(position: position_c, color: color))
		}

		var use_mask = true
		if maskCanvas.cellsPerRow != canvas.cellsPerRow {
			use_mask = false
		}
		if maskCanvas.cellsPerColumn != canvas.cellsPerColumn {
			use_mask = false
		}
		let w = Int(canvas.cellsPerRow)
		let h = Int(canvas.cellsPerColumn)
		let cw = Int(canvas.size.width)
		let w1: Int = cw + 1
		for y in 0..<h {
			let y2 = y * 2
			for x in 0..<w {
				let offset = y * w + x
				let cell: E2TriangleCell = canvas.cells[offset]
				var mask0 = true
				var mask1 = true
				var mask2 = true
				var mask3 = true
				if use_mask {
					let maskcell: E2TriangleCell = maskCanvas.cells[offset]
					if maskcell.tl == 0 {
						mask0 = false
					}
					if maskcell.tr == 0 {
						mask1 = false
					}
					if maskcell.bl == 0 {
						mask2 = false
					}
					if maskcell.br == 0 {
						mask3 = false
					}
				}
				if mask0 {
					let a: Int = y2 * w1 + x
					let b: Int = a + 1
					let c: Int = a + w1
					appendTriangle(a: a, b: b, c: c, value: cell.tl)
				}
				if mask1 {
					let a: Int = y2 * w1 + x + 1
					let b: Int = a + w1 - 1
					let c: Int = b + 1
					appendTriangle(a: a, b: b, c: c, value: cell.tr)
				}
				if mask2 {
					let a: Int = (y2 + 1) * w1 + x
					let b: Int = a + w1 + 1
					let c: Int = b - 1
					appendTriangle(a: a, b: b, c: c, value: cell.bl)
				}
				if mask3 {
					let a: Int = (y2 + 1) * w1 + x
					let b: Int = a + w1 + 1
					let c: Int = a + 1
					appendTriangle(a: a, b: b, c: c, value: cell.br)
				}
			}
		}

		// Outline around hexagon
		do {
			let sin60deg = AppConstant.Canvas.hexagonApothem
			let hh = Int(sin60deg * Double(w) * 0.5 + 6)
			let w4: Int = w / 4
			let inset: Int = 1
			let x0: Int = inset
			let x1: Int = w4 + inset
			let x2: Int = w - w4 - inset
			let x3: Int = w - inset
			let ymid: Int = h
			let ytop: Int = ymid - hh
			let ybot: Int = ymid + hh

			self.corners.topLeft     = coordinates[w1 * ytop + x1]
			self.corners.topRight    = coordinates[w1 * ytop + x2]
			self.corners.middleLeft  = coordinates[w1 * ymid + x0]
			self.corners.middleRight = coordinates[w1 * ymid + x3]
			self.corners.bottomLeft  = coordinates[w1 * ybot + x1]
			self.corners.bottomRight = coordinates[w1 * ybot + x2]
		}
	}
}

extension HCBuildHexagonCanvas: CustomStringConvertible {
	var description: String {
		return "<corners: \(corners)  filledtriangle_vertices.count: \(filledtriangle_vertices.count)  filledtriangle_indices.count: \(filledtriangle_indices.count)  filledcircle_vertices.count: \(filledcircle_vertices.count)  filledcircle_indices.count: \(filledcircle_indices.count)>"
	}
}
