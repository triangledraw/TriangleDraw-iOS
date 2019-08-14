// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

extension E2Canvas {
	func exportToSVG(rotated: Bool = false) -> String {
		assert(self.size.width == AppConstant.CanvasFileFormat.width, "width")
		assert(self.size.height == AppConstant.CanvasFileFormat.height, "height")

		var pointsInsideMask = [E2CanvasPoint]()
		let mask: E2Canvas = E2Canvas.bigCanvasMask()
		for y in 0..<Int(self.height) {
			for x in 0..<Int(self.width) {
				let point = E2CanvasPoint(x: x, y: y)
				if mask.getPixel(point) > 0 {
					pointsInsideMask.append(point)
				}
			}
		}

		var minX: Int = pointsInsideMask.first?.x ?? 0
		for point: E2CanvasPoint in pointsInsideMask {
			if minX > point.x {
				minX = point.x
			}
		}
		var maxX: Int = pointsInsideMask.first?.x ?? 0
		for point: E2CanvasPoint in pointsInsideMask {
			if maxX < point.x {
				maxX = point.x
			}
		}
		var minY: Int = pointsInsideMask.first?.y ?? 0
		for point: E2CanvasPoint in pointsInsideMask {
			if minY > point.y {
				minY = point.y
			}
		}
		var maxY: Int = pointsInsideMask.first?.y ?? 0
		for point: E2CanvasPoint in pointsInsideMask {
			if maxY < point.y {
				maxY = point.y
			}
		}
		//log.debug("x range: \(minX) \(maxX)   y range: \(minY) \(maxY)")

		var blackSegments = [String]()
		var whiteSegments = [String]()
		for point: E2CanvasPoint in pointsInsideMask {
			let segment: String
			switch point.orientation {
			case .upward:
				let x: Int = point.x - minX + 1
				let y: Int = point.y - minY
				segment = "M\(x) \(y)l-1 1 h2z"
			case .downward:
				let x: Int = point.x - minX
				let y: Int = point.y - minY
				segment = "M\(x) \(y)h2l-1 1z"
			}
			if self.getPixel(point) > 0 {
				whiteSegments.append(segment)
			} else {
				blackSegments.append(segment)
			}
		}

		var result: String = """
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 720 720">
		<rect width="720" height="720" fill="gray"/>
		<svg preserveAspectRatio="xMidYMid meet" viewBox="-88 -44 176 88" x="10" y="10" width="700" height="700">
		<g transform="rotate(ROTATION_DEGREES) scale(2) scale(0.5 0.866025) translate(-88 -44)">
		<path fill="black" d="BLACK_PATH"/>
		<path fill="white" d="WHITE_PATH"/>
		</g>
		</svg>
		</svg>
		"""
		let rotation = rotated ? "90" : "0"
		result = result.replacingOccurrences(of: "ROTATION_DEGREES", with: rotation)
		result = result.replacingOccurrences(of: "BLACK_PATH", with: blackSegments.joined())
		result = result.replacingOccurrences(of: "WHITE_PATH", with: whiteSegments.joined())
		return result
	}
}

class ExportToSVGTests: XCTestCase {

    func testExample() {
//		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
//		let canvas: E2Canvas = loadCanvas("test_rotate_logo_none.txt")
		let canvas: E2Canvas = loadCanvas("test_boundingbox0.txt")
//		let canvas: E2Canvas = loadCanvas("test_boundingbox3.txt")

		let xmlString: String = canvas.exportToSVG()
		let rep: Data = xmlString.data(using: .utf8, allowLossyConversion: true)!
		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result.svg").absoluteURL
		try! rep.write(to: url)
    }

}
