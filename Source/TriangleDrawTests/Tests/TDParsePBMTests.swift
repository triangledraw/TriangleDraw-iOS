// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class TDParsePBMTests: XCTestCase {
    func parse(_ resourceName: String) -> TDParsePBM? {
		guard let url: URL = Bundle(for: type(of: self)).url(forResource: resourceName, withExtension: "pbm") else {
			//print("no url for resource: \(resourceName)")
            return nil
        }
		guard let content = try? Data(contentsOf: url) else {
			//print("unable to read file: \(url)")
			return nil
		}
        return try? TDParsePBM.parse(content)
    }

    func testSimple1() {
        let model: TDParsePBM? = parse("test_parsepbm_simple1")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model?.data.comments.count, 1)
        XCTAssertEqual(model?.data.width, 1)
        XCTAssertEqual(model?.data.height, 1)
        XCTAssertEqual(model?.stringRepresentation, "0")
    }

    func testSimple2() {
        let model: TDParsePBM? = parse("test_parsepbm_simple2")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model?.data.width, 4)
        XCTAssertEqual(model?.data.height, 3)
        XCTAssertEqual(model?.stringRepresentation, "1 1 1 1 1 0 1 0 0 0 0 0")
    }

    func testComments3() {
        let model: TDParsePBM! = parse("test_parsepbm_comments3")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model.data.comments.count, 3)
        XCTAssertEqual(model.data.width, 1)
        XCTAssertEqual(model.data.height, 1)
        XCTAssertEqual(model.stringRepresentation, "1")
		let comments: String = model.data.comments.joined(separator: ",")
        XCTAssertEqual(comments, "# This is Ripley,# last survivor of the Nostromo,# signing off")
    }

    func testSpacing1() {
        let model: TDParsePBM? = parse("test_parsepbm_spacing1")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model?.data.width, 2)
        XCTAssertEqual(model?.data.height, 2)
        XCTAssertEqual(model?.stringRepresentation, "0 1 1 0")
    }

    func testAdvanced1() {
        let model: TDParsePBM? = parse("test_parsepbm_advanced1")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model?.data.width, 180)
        XCTAssertEqual(model?.data.height, 104)
    }

    func testEncodingUTF8() {
        let model: TDParsePBM? = parse("test_parsepbm_utf8")
        XCTAssertNotNil(model, "a wellformed file should return a model")
        XCTAssertEqual(model?.data.width, 1)
        XCTAssertEqual(model?.data.height, 1)
        XCTAssertEqual(model?.stringRepresentation, "0")
    }

    func testEncodingUTF16BE() {
        let model: TDParsePBM? = parse("test_parsepbm_utf16be")
        XCTAssertNil(model, "only UTF8 encoding is allowed")
    }

    func testEncodingUTF16LE() {
        let model: TDParsePBM? = parse("test_parsepbm_utf16le")
        XCTAssertNil(model, "only UTF8 encoding is allowed")
    }

    func testInvalid1() {
        let model: TDParsePBM? = parse("test_parsepbm_invalid1")
        XCTAssertNil(model, "a mallformed file should return nil")
    }

    func testNil1() {
        let model = try? TDParsePBM.parse(nil)
        XCTAssertNil(model, "nil input should return nil output")
    }

    func testEmptyString1() {
        let data = Data()
        let model = try? TDParsePBM.parse(data)
        XCTAssertNil(model, "empty input should return nil output")
    }

    func testNegativeSize1() {
        let model: TDParsePBM? = parse("test_parsepbm_negative_width")
        XCTAssertNil(model, "a mallformed file should return nil")
    }

    func testNegativeSize2() {
        let model: TDParsePBM? = parse("test_parsepbm_negative_height")
        XCTAssertNil(model, "a mallformed file should return nil")
    }

    func testIllegalCellValues1() {
        let model: TDParsePBM? = parse("test_parsepbm_illegal_cell_values")
        XCTAssertNil(model, "a mallformed file should return nil")
    }
}
