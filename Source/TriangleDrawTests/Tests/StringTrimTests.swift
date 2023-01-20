// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain

class StringTrimTests: XCTestCase {
    func test() {
		XCTAssertEqual("Hello", "Hello".trim())
		XCTAssertEqual("Hello World", "  Hello World  ".trim())
		XCTAssertEqual("Hello", "Hello\n".trim())
		XCTAssertEqual("Hello", "\nHello".trim())
    }
}
