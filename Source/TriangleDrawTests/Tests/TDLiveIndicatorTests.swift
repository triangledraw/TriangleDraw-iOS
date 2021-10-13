// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawLibrary

class TDLiveIndicatorTests: XCTestCase {

    func testFifo_append() {
		let fifo = TDLiveIndicator_Fifo<Int>(capacity: 3, defaultValue: 1)
		do {
			let values: [Int] = fifo.array
			XCTAssertEqual(values, [1, 1, 1])
		}
		fifo.append(2)
		do {
			let values: [Int] = fifo.array
			XCTAssertEqual(values, [1, 1, 2])
		}
		fifo.append(3)
		do {
			let values: [Int] = fifo.array
			XCTAssertEqual(values, [1, 2, 3])
		}
		fifo.append(4)
		do {
			let values: [Int] = fifo.array
			XCTAssertEqual(values, [2, 3, 4])
		}
		fifo.append(5)
		do {
			let values: [Int] = fifo.array
			XCTAssertEqual(values, [3, 4, 5])
		}
    }
}
