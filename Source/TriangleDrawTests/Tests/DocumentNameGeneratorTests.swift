// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain

class DocumentNameGeneratorTests: XCTestCase {

    func defaultName(_ name: String, existingNames: [String]) -> String {
        return DocumentNameGenerator.defaultName(name, existingNames: Set<AnyHashable>(existingNames))
    }

    func testDefaultNoCollision0() {
        let names = ["a", "b", "c"]
        let actual = defaultName("hello", existingNames: names)
        let expected = "hello"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultNoCollisionCaseSensitive0() {
        let names = ["a", "b", "c"]
        let actual = defaultName("A", existingNames: names)
        let expected = "A"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision0() {
        let names = ["readme"]
        let actual = defaultName("readme", existingNames: names)
        let expected = "readme 1"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision1() {
        let names = ["readme", "readme 1"]
        let actual = defaultName("readme", existingNames: names)
        let expected = "readme 2"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision2() {
        let names = ["readme 42"]
        let actual = defaultName("readme 42", existingNames: names)
        let expected = "readme 43"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision3() {
        let names = ["readme 1"]
        let actual = defaultName("readme 0", existingNames: names)
        let expected = "readme 0"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision4() {
        let names = ["readme", "readme 1"]
        let actual = defaultName("readme 0", existingNames: names)
        let expected = "readme 0"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollision5() {
        let names = ["readme", "readme 0", "readme 1"]
        let actual = defaultName("readme 0", existingNames: names)
        let expected = "readme 2"
        XCTAssertEqual(actual, expected)
    }

    func testDefaultCollisionCaseSensitive0() {
        let names = ["a", "a 1", "A", "A 1", "A 2"]
        let actual = defaultName("A", existingNames: names)
        let expected = "A 3"
        XCTAssertEqual(actual, expected)
    }

	// MARK: - Batch
	
    func defaultNames(_ preferredNames: [String], taken takenNames: [String]) -> [String] {
        return DocumentNameGenerator.defaultNames(preferredNames, existingNames: Set<AnyHashable>(takenNames))
    }

    func testBatchTrivial1() {
        let taken = ["local 1", "local 2", "local 3"]
        let names = ["cloud 1", "cloud 2", "cloud 3"]
        let actual = defaultNames(names, taken: taken)
        let expected = ["cloud 1", "cloud 2", "cloud 3"]
        XCTAssertEqual(actual, expected)
    }

    func testBatchCollision1() {
        let taken = ["local 1", "local 2", "local 3", "test 1"]
        let names = ["cloud 1", "cloud 2", "cloud 3", "test 1"]
        let actual = defaultNames(names, taken: taken)
        let expected = ["cloud 1", "cloud 2", "cloud 3", "test 2"]
        XCTAssertEqual(actual, expected)
    }

    func testBatchCollision2() {
        let taken = ["local 1", "local 2", "local 3", "test 1", "test 3"]
        let names = ["cloud 1", "cloud 2", "cloud 3", "test 1", "test 2"]
        let actual = defaultNames(names, taken: taken)
        let expected = ["cloud 1", "cloud 2", "cloud 3", "test 4", "test 2"]
        XCTAssertEqual(actual, expected)
    }

    func testBatchCollision3() {
        let taken = ["test 1", "test 3"]
        let names = ["test 1", "test 2", "test 3", "test 4", "test 6"]
        let actual = defaultNames(names, taken: taken)
        let expected = ["test 5", "test 2", "test 7", "test 4", "test 6"]
        XCTAssertEqual(actual, expected)
    }

	// MARK: - Duplicate name

    func duplicateName(_ name: String, existingNames: [String]) -> String {
        return DocumentNameGenerator.duplicateName(name, existingNames: Set<AnyHashable>(existingNames), copyName: "copy")
    }

    func testDuplicateNoCollision0() {
        let names = ["a", "b", "c"]
        let actual = duplicateName("hello", existingNames: names)
        let expected = "hello"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateNoCollision1() {
        let names = ["a", "b", "c"]
        let actual = duplicateName("hello  ", existingNames: names)
        let expected = "hello  "
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionSimple0() {
        let names = ["readme"]
        let actual = duplicateName("readme", existingNames: names)
        let expected = "readme copy"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionSimple1() {
        let names = ["readme", "readme copy"]
        let actual = duplicateName("readme", existingNames: names)
        let expected = "readme copy 1"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionSimple2() {
        let names = ["readme", "readme copy", "readme copy 1"]
        let actual = duplicateName("readme", existingNames: names)
        let expected = "readme copy 2"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionEndsInCopyWithoutSpace0() {
        let names = ["readme", "readme copy", "readme copy 1"]
        let actual = duplicateName("readme copy", existingNames: names)
        let expected = "readme copy 2"
        XCTAssertEqual(actual, expected)
    }

	func testDuplicateCollisionEndsInCopyWithoutSpace1() {
		let names = ["My cool logo copy 42", "My cool logo copy 43"]
		let actual = duplicateName("My cool logo copy 42", existingNames: names)
		let expected = "My cool logo copy 44"
		XCTAssertEqual(actual, expected)
	}

    func testDuplicateCollisionEndsInCopyWithSpace() {
        let names = ["readme", "readme copy", "readme copy 1"]
        let actual = duplicateName("readme copy ", existingNames: names)
        let expected = "readme copy 2"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionEvil1() {
        let names = ["readme", "readme copy", "readme copy 1", "readme copy 2"]
        let actual = duplicateName("readme copy 1", existingNames: names)
        let expected = "readme copy 3"
        XCTAssertEqual(actual, expected)
    }

    func testDuplicateCollisionEvil2() {
        let names = ["readme 3"]
        let actual = duplicateName("readme 3", existingNames: names)
        let expected = "readme 3 copy"
        XCTAssertEqual(actual, expected)
    }

	func testDuplicateEvilURLs0() {
		// A file that is named `file:///hello` can cause problems
		// The file is appended to a file: url, causing two times `file:///` in the same url.
		let names = ["file:///hello"]
		let actual = duplicateName("file:///hello", existingNames: names)
		let expected = "file:///hello copy"
		XCTAssertEqual(actual, expected)
	}

	// MARK: - Localized duplicate name

    func localizedDuplicateName(_ name: String, existingNames: [String]) -> String {
        return DocumentNameGenerator.duplicateName(name, existingNames: Set<AnyHashable>(existingNames), copyName: "KOPI")
    }

    func testLocalizedDuplicateNoCollision0() {
        let names = ["a", "b", "c"]
        let actual = localizedDuplicateName("hello", existingNames: names)
        let expected = "hello"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateNoCollision1() {
        let names = ["a", "b", "c"]
        let actual = localizedDuplicateName("hello  ", existingNames: names)
        let expected = "hello  "
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionSimple0() {
        let names = ["readme"]
        let actual = localizedDuplicateName("readme", existingNames: names)
        let expected = "readme KOPI"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionSimple1() {
        let names = ["readme", "readme KOPI"]
        let actual = localizedDuplicateName("readme", existingNames: names)
        let expected = "readme KOPI 1"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionSimple2() {
        let names = ["readme", "readme KOPI", "readme KOPI 1"]
        let actual = localizedDuplicateName("readme", existingNames: names)
        let expected = "readme KOPI 2"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionEndsInCopyWithoutSpace() {
        let names = ["readme", "readme KOPI", "readme KOPI 1"]
        let actual = localizedDuplicateName("readme KOPI", existingNames: names)
        let expected = "readme KOPI 2"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionEndsInCopyWithSpace() {
        let names = ["readme", "readme KOPI", "readme KOPI 1"]
        let actual = localizedDuplicateName("readme KOPI ", existingNames: names)
        let expected = "readme KOPI 2"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionEvil1() {
        let names = ["readme", "readme KOPI", "readme KOPI 1", "readme KOPI 2"]
        let actual = localizedDuplicateName("readme KOPI 1", existingNames: names)
        let expected = "readme KOPI 3"
        XCTAssertEqual(actual, expected)
    }

    func testLocalizedDuplicateCollisionEvil2() {
        let names = ["readme 3"]
        let actual = localizedDuplicateName("readme 3", existingNames: names)
        let expected = "readme 3 KOPI"
        XCTAssertEqual(actual, expected)
    }
}
