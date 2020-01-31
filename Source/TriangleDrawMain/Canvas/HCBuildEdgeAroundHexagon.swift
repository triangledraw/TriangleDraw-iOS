// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics
import TriangleDrawLibrary

class HCBuildEdgeAroundHexagon {
	let edgetriangle_vertices: [HCFilledTriangleVertex]
	let edgetriangle_indices: [UInt16]

	init(corners: HCHexagonCorners, extrudeScale: CGFloat = 1.05, color: TDFloat4, debug: Bool = false) {
		var vertices = [HCFilledTriangleVertex]()

		let extrudedTopLeft = corners.topLeft.scaleBy(extrudeScale)
		let extrudedTopRight = corners.topRight.scaleBy(extrudeScale)
		let extrudedMiddleLeft = corners.middleLeft.scaleBy(extrudeScale)
		let extrudedMiddleRight = corners.middleRight.scaleBy(extrudeScale)
		let extrudedBottomLeft = corners.bottomLeft.scaleBy(extrudeScale)
		let extrudedBottomRight = corners.bottomRight.scaleBy(extrudeScale)

		let color0: TDFloat4, color1: TDFloat4, color2: TDFloat4
		if debug {
			color0 = TDFloat4(1, 0, 0, 1)
			color1 = TDFloat4(0, 1, 0, 1)
			color2 = TDFloat4(0, 0, 1, 1)
		} else {
			color0 = color
			color1 = color
			color2 = color
		}

		func append(_ point0: CGPoint, _ point1: CGPoint, _ point2: CGPoint) {
			func convert(_ point: CGPoint) -> TDFloat2 {
				return TDFloat2(Float(point.x), Float(point.y))
			}

			vertices.append(HCFilledTriangleVertex(position: convert(point0), color: color0))
			vertices.append(HCFilledTriangleVertex(position: convert(point1), color: color1))
			vertices.append(HCFilledTriangleVertex(position: convert(point2), color: color2))
		}

		// Top side
		append(corners.topLeft, corners.topRight, extrudedTopLeft)
		append(extrudedTopLeft, corners.topRight, extrudedTopRight)

		// Bottom side
		append(corners.bottomLeft, corners.bottomRight, extrudedBottomLeft)
		append(extrudedBottomLeft, corners.bottomRight, extrudedBottomRight)

		// Side between middleLeft and topLeft
		append(corners.topLeft, corners.middleLeft, extrudedTopLeft)
		append(extrudedMiddleLeft, corners.middleLeft, extrudedTopLeft)

		// Side between middleRight and topRight
		append(corners.topRight, corners.middleRight, extrudedTopRight)
		append(extrudedMiddleRight, corners.middleRight, extrudedTopRight)

		// Side between middleLeft and bottomLeft
		append(corners.bottomLeft, corners.middleLeft, extrudedBottomLeft)
		append(extrudedMiddleLeft, corners.middleLeft, extrudedBottomLeft)

		// Side between middleRight and bottomRight
		append(corners.bottomRight, corners.middleRight, extrudedBottomRight)
		append(extrudedMiddleRight, corners.middleRight, extrudedBottomRight)


		var indices = [UInt16]()
		for i in 0..<vertices.count {
			indices.append(UInt16(i))
		}

		self.edgetriangle_vertices = vertices
		self.edgetriangle_indices = indices
	}
}
