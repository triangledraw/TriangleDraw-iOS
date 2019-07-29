// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class E2CombinerTests: XCTestCase {
    func group(_ inputRepresentation: String) -> String {
        let canvas = E2Canvas.createFromTestRepresentation(inputRepresentation)
		let comb: E2Combiner = E2Combiner(canvas: canvas)
        comb.assignOptimalTags()
        return comb.testRepresentation
    }

    func testGroup1() {
        /*
         
                           +1,0
          0,0 ***************************** +2,0
              *                           *
              : *        topleft        *   *
              :   *                   *       *
              :     *               *           *
              :       *           *               *
              :         *       *                   *
              :           *   *        topright       *
              :             *                           * 
         0,+1 :             ***************************** +3,+1
              :             *                           * 
              :           *   *      bottomright      *
              :         *       *                   *
              :       *           *               *
              :     *               *           *
              :   *                   *       *
              : *       bottomleft      *   *
              *                           *
         0,+2 ***************************** +2,+2
                          +1,+2
         
         
         
         */
        XCTAssertEqual(group("-- --"), "11 11")
        XCTAssertEqual(group("-- -*"), "11 23")
        XCTAssertEqual(group("-- *-"), "11 21")
        XCTAssertEqual(group("-- **"), "11 22")
        XCTAssertEqual(group("-* --"), "12 33")
        XCTAssertEqual(group("-* -*"), "12 32")
        XCTAssertEqual(group("-* *-"), "12 34")
        XCTAssertEqual(group("-* **"), "12 22")
        XCTAssertEqual(group("*- --"), "12 22")
        XCTAssertEqual(group("*- -*"), "12 34")
        XCTAssertEqual(group("*- *-"), "12 32")
        XCTAssertEqual(group("*- **"), "12 33")
        XCTAssertEqual(group("** --"), "11 22")
        XCTAssertEqual(group("** -*"), "11 21")
        XCTAssertEqual(group("** *-"), "11 23")
        XCTAssertEqual(group("** **"), "11 11")
    }

    func testGroup2() {
        XCTAssertEqual(group("---- ---- ---- ----"), "1111 1111 1111 1111")
        XCTAssertEqual(group("**** **** **** ****"), "1111 1111 1111 1111")
        XCTAssertEqual(group("**-- **-- **-- **--"), "1122 1122 1122 1122")
        XCTAssertEqual(group("**** ---- **** ----"), "1111 2222 3333 4444")
        XCTAssertEqual(group("**-- -**- --** ---*"), "1122 3112 3311 3331")
        XCTAssertEqual(group("---* --** -**- **--"), "1112 1122 1223 2233")
    }

    func testGroup3() {
        XCTAssertEqual(group("-*****-- **---**- **---**- -*****--"), "12222233 22444223 22444225 62222255")
    }

    func group_nd(_ inputRepresentation: String) -> String {
        let canvas = E2Canvas.createFromTestRepresentation(inputRepresentation)
		let comb: E2Combiner = E2Combiner(canvas: canvas)
        comb.assignOptimalTags()
        comb.discardZeroes()
        return comb.testRepresentation
    }

    func testGroup2_no_dashes() {
        XCTAssertEqual(group_nd("---- ---- ---- ----"), "0000 0000 0000 0000")
        XCTAssertEqual(group_nd("**** **** **** ****"), "1111 1111 1111 1111")
        XCTAssertEqual(group_nd("**-- **-- **-- **--"), "1100 1100 1100 1100")
        XCTAssertEqual(group_nd("**** ---- **** ----"), "1111 0000 2222 0000")
        XCTAssertEqual(group_nd("**-- -**- --** ---*"), "1100 0110 0011 0001")
        XCTAssertEqual(group_nd("---* --** -**- **--"), "0001 0011 0110 1100")
    }
}

extension E2Combiner {
	fileprivate var testRepresentation: String {
		let s: String = self.stringRepresentation
        return s.replacingOccurrences(of: "\n", with: " ")
    }
}

extension E2Canvas {
	fileprivate static func createFromTestRepresentation(_ aString: String) -> E2Canvas {
		let testRep = aString.replacingOccurrences(of: " ", with: "\n")
		let rowStrings = aString.components(separatedBy: " ")
		let rows = UInt(rowStrings.count)
		var cols: UInt = 0
		if rows >= 1 {
			let row0 = rowStrings[0]
			cols = UInt(row0.count)
		}
		assert((rows & 1) == 0, "there must be an even number of rows")
		assert((cols & 1) == 0, "there must be an even number of cols")
		let c: E2Canvas = E2Canvas(canvasSize: E2CanvasSize(width: cols / 2, height: rows))
		c.load(fromStringRepresentation: testRep)
		return c
	}
}
