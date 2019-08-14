// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

extension E2Canvas {
	func exportToSVG() -> String {
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

		var blackSegments = [String]()
		var whiteSegments = [String]()
		for point: E2CanvasPoint in pointsInsideMask {
			let segment: String
			switch point.orientation {
			case .upward:
				let coordinate = "\(point.x + 1) \(point.y)"
				segment = "M\(coordinate)l-1 1 h2z"
			case .downward:
				let coordinate = "\(point.x) \(point.y)"
				segment = "M\(coordinate)h2l-1 1z"
			}
			if self.getPixel(point) > 0 {
				whiteSegments.append(segment)
			} else {
				blackSegments.append(segment)
			}
		}

		var result: String = """
		<svg viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
		<rect width="1000" height="1000" fill="green"/>
		<g transform="scale(10) scale(0.5 0.866025)">
		<path fill="black" d="BLACK_PATH"/>
		<path fill="white" d="WHITE_PATH"/>
		</g>
		</svg>
		"""
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
