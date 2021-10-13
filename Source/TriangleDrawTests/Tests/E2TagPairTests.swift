// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class E2TagPairTests: XCTestCase {
	func pair(_ tag0: Int, _ tag1: Int) -> E2TagPair {
		return E2TagPair.create(tag0: tag0, tag1: tag1)
	}

    func testSameGroup1() {
        var pairs = [E2TagPair]()
        pairs.append(pair(1, 2))
        pairs.append(pair(1, 3))
        let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
        XCTAssertEqual(actual, "2=1,3=1")
    }

    func testSameGroup2() {
        var pairs = [E2TagPair]()
        pairs.append(pair(1, 2))
        pairs.append(pair(2, 3))
        let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
        XCTAssertEqual(actual, "2=1,3=1")
    }

    func testSameGroup3() {
        var pairs = [E2TagPair]()
        pairs.append(pair(1, 2))
        pairs.append(pair(2, 1))
        let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
        XCTAssertEqual(actual, "2=1")
    }

    func testSameGroup4() {
        var pairs = [E2TagPair]()
        pairs.append(pair(1, 2))
        pairs.append(pair(2, 3))
        pairs.append(pair(3, 1))
        let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
        XCTAssertEqual(actual, "2=1,3=1")
    }

	func testSeparateGroups1() {
		var pairs = [E2TagPair]()
		pairs.append(pair(1, 2))
		pairs.append(pair(4, 5))
		pairs.append(pair(7, 8))
		let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
		XCTAssertEqual(actual, "2=1,5=4,8=7")
	}

	func testSeparateGroups2() {
		var pairs = [E2TagPair]()
		pairs.append(pair(1, 2))
		pairs.append(pair(4, 5))
		pairs.append(pair(7, 8))
		pairs.append(pair(11, 2))
		pairs.append(pair(55, 4))
		pairs.append(pair(77, 8))
		let dict = E2TagPair.dictionary(fromPairs: pairs)
		let actual = stringify(dict)
		XCTAssertEqual(actual, "2=1,5=4,8=7,11=1,55=4,77=7")
	}

	func stringify(_ dict: [Int: Int]) -> String {
		let keys: [Int] = dict.keys.map { $0 }
		let strings: [String] = keys.sorted().map { key in
			guard let value: Int = dict[key] else {
				fatalError("Expected value for key: \(key)")
			}
			return "\(key)=\(value)"
		}
		return strings.joined(separator: ",")
	}
}
