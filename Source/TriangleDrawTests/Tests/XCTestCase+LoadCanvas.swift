// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

extension XCTestCase {
	func loadCanvas(_ resourceName: String) -> E2Canvas {
		if resourceName.hasSuffix(".txt") {
			return loadCanvasFromTextFile(resourceName)
		}
		if resourceName.hasSuffix(".pbm") {
			guard let canvas: E2Canvas = loadCanvasFromPBMFile(resourceName) else {
				fatalError("Unable to load PBM file for resource: \(resourceName)")
			}
			return canvas
		}
		fatalError()
	}

	func loadCanvasFromTextFile(_ resourceName: String) -> E2Canvas {
		guard let url: URL = Bundle(for: type(of: self)).url(forResource: resourceName, withExtension: nil) else {
			log.error("no url for resource: \(resourceName)")
			fatalError()
		}
		guard let content = try? String(contentsOf: url, encoding: .utf8) else {
			log.error("Unable to load file for resource: \(resourceName)   at url: \(url)")
			fatalError()
		}
		let canvas: E2Canvas = E2Canvas.createBigCanvas()
		canvas.load(fromStringRepresentation: content)
		return canvas
	}

	func loadCanvasFromPBMFile(_ resourceName: String) -> E2Canvas? {
		guard let url: URL = Bundle(for: type(of: self)).url(forResource: resourceName, withExtension: nil) else {
			//print("no url for resource: \(resourceName)")
			return nil
		}
		guard let content: Data = try? Data(contentsOf: url) else {
			//print("unable to read file: \(url)")
			return nil
		}
		let canvas: E2Canvas? = try? TDCanvasReader.canvas(fromPBMRepresentation: content)
		return canvas
	}

	func loadCanvasMask() -> E2Canvas {
		return E2Canvas.bigCanvasMask_create()
	}

}
