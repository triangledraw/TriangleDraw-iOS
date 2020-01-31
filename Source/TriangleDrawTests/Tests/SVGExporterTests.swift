// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary
@testable import TriangleDrawMain

class SVGExporterTests: XCTestCase {
    func test0() {
		let canvas: E2Canvas = loadCanvas("test_exportsvg_corners.pbm")
		let exporter = SVGExporter(canvas: canvas)
		exporter.rotated = false
		let data = exporter.generateData()
		XCTAssertGreaterThan(data.count, 50000)
		XCTAssertLessThan(data.count, 500000)
//		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result0.svg").absoluteURL
//		try! data.write(to: url)
    }

	func test1() {
		let canvas: E2Canvas = loadCanvas("test_exportsvg_cube.pbm")
		let exporter = SVGExporter(canvas: canvas)
		exporter.rotated = true
		let data = exporter.generateData()
		XCTAssertGreaterThan(data.count, 50000)
		XCTAssertLessThan(data.count, 500000)
//		let url: URL = URL(fileURLWithPath: "/Users/neoneye/Desktop/result1.svg").absoluteURL
//		try! data.write(to: url)
	}
}
