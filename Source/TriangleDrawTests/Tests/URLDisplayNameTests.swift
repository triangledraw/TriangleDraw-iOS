// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain

class URLDisplayNameTests: XCTestCase {
	func testFileURL_simple() {
		let url: URL = URL(fileURLWithPath: "file:///var/mobile/Containers/Data/Application/1FB629DF-2E96-4047-BF06-373BB57A1965/Documents/Mona%20Lisa.triangleDraw/")
		let name: String = url.triangleDraw_displayName
		XCTAssertEqual(name, "Mona Lisa")
	}

	func testFileURL_emoji_flagForKenya() {
		// Filename containing the kenyan flag: 🇰🇪
		// https://emojipedia.org/flag-for-kenya/
		let url: URL = URL(fileURLWithPath: "file:///var/mobile/Containers/Data/Application/1FB629DF-2E96-4047-BF06-373BB57A1965/Documents/%F0%9F%87%B0%F0%9F%87%AA.triangleDraw/")
		let name: String = url.triangleDraw_displayName
		let data: Data = name.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
		let base64: String = data.base64EncodedString()
		XCTAssertEqual(base64, "8J+HsPCfh6o=")
	}

	func testWebURL_garbage() {
		// `triangleDraw_displayName` is intended to work with fileURL's
		// `triangleDraw_displayName` is not supposed to be used with web URLs, thus garbage
		do {
			let url: URL = URL(string: "https://example.com/monalisa")!
			XCTAssertEqual(url.triangleDraw_displayName, "monalisa")
		}
		do {
			let url: URL = URL(string: "https://example.com/monalisa.png?x=3")!
			XCTAssertEqual(url.triangleDraw_displayName, "monalisa")
		}
		do {
			let url: URL = URL(string: "https://example.com")!
			XCTAssertEqual(url.triangleDraw_displayName, "")
		}
		do {
			let url: URL = URL(string: "https://")!
			XCTAssertEqual(url.triangleDraw_displayName, "")
		}
	}
}
