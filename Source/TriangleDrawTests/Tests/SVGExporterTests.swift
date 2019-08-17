// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary
@testable import TriangleDrawMain

class SVGExporterTests: XCTestCase {

    func testExample() {
//		let canvas: E2Canvas = loadCanvas("test_subdivide2_in.pbm")
//		let canvas: E2Canvas = loadCanvas("test_rotate_logo_none.txt")
//		let canvas: E2Canvas = loadCanvas("test_boundingbox0.txt")
//		let canvas: E2Canvas = loadCanvas("test_boundingbox3.txt")
//		let canvas: E2Canvas = loadCanvas("test_exportsvg_corners.pbm")
		let canvas: E2Canvas = loadCanvas("test_exportsvg_cube.pbm")

		let exporter = SVGExporter(canvas: canvas)
		exporter.appVersion = "2019.2.1"
		exporter.rotated = true
		let data = exporter.generateData()
		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result.svg").absoluteURL
		try! data.write(to: url)
    }

}
