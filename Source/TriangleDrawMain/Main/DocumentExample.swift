// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import TriangleDrawLibrary


enum DocumentExample: String {
	case blankFile = "Drawing"
	case triangledrawLogo = "triangledraw logo"
	case developer_rows
	case developer_columns
	case rune1 = "rune 1"
	case injection
}

extension DocumentExample {
	var overrideDisplayName: String? {
		switch self {
		case .triangledrawLogo:
			return "Client Logo"
		case .rune1:
			return "Viking Symbol"
		default:
			return nil
		}
	}
}

extension DocumentExample {
	var url: URL {
		return DocumentExample.bundleURL.appendingPathComponent(self.rawValue).appendingPathExtension("triangleDraw")
	}

	var canvas: E2Canvas {
		do {
			let data: Data = try Data(contentsOf: self.url)
			let canvas: E2Canvas = try TDCanvasReader.canvas(fromPBMRepresentation: data)
			return canvas
		} catch {
			log.error("The examples are supposed to be bundled with the app. \(error)")
			fatalError("The examples are supposed to be bundled with the app.")
		}
	}

	static var bundleURL: URL {
		return Bundle.main.url(forResource: "DocumentExample", withExtension: "bundle")!
	}
}
