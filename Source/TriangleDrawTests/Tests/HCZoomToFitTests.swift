// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import XCTest
@testable import TriangleDrawMain
@testable import TriangleDrawLibrary

class HCZoomToFitTests: XCTestCase {

	// MARK: - SizeOfHexagonCanvas

	func testSizeOfHexagonCanvas() {
		let cgSize: CGSize = CGSize.sizeOfHexagonCanvas(width: 666, height: 1155)
		XCTAssertEqual(cgSize.width, 333.0, accuracy: 0.001)
		XCTAssertEqual(cgSize.height, 1000.25934, accuracy: 0.001)
	}

	// MARK: - Zoom to fit

	func test1000_iPadPro_landscape_noSplitScreen() {
		let boundingBox = E2CanvasBoundingBox(minX: 88, maxX: 89, minY: 51, maxY: 61)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1366, height: 1024),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 10
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 4175.82, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 46.40, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 351.37, accuracy: 0.01)
	}

	func test1001_iPadPro_landscape_splitScreen() {
		let boundingBox = E2CanvasBoundingBox(minX: 88, maxX: 89, minY: 51, maxY: 61)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 678, height: 1024),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 10
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 4175.82, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 46.40, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 351.37, accuracy: 0.01)
	}

	func test1002_iPadPro_portrait_noSplitScreen() {
		let boundingBox = E2CanvasBoundingBox(minX: 88, maxX: 89, minY: 51, maxY: 61)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1024, height: 1366),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 10
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 5791.35, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 64.35, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 491.17, accuracy: 0.01)
	}

	func test1003_iPadPro_portrait_splitScreen() {
		let boundingBox = E2CanvasBoundingBox(minX: 88, maxX: 89, minY: 51, maxY: 61)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 639, height: 1366),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 10
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 5791.35, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 64.35, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 491.17, accuracy: 0.01)
	}

	func test2000_iPadPro_landscape() {
		let boundingBox = E2CanvasBoundingBox(minX: 46, maxX: 133, minY: 8, maxY: 14)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1366, height: 1024),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 1397.05, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 0, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -1098.08, accuracy: 0.01)
	}

	func test2001_iPadPro_portrait() {
		let boundingBox = E2CanvasBoundingBox(minX: 46, maxX: 133, minY: 8, maxY: 14)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1024, height: 1366),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 1047.27, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 0, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -825.66, accuracy: 0.01)
	}

	func test3000_iPadPro_landscape() {
		let boundingBox = E2CanvasBoundingBox(minX: 2, maxX: 177, minY: 8, maxY: 95)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1366, height: 1024),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 533.79, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 0, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -10.0, accuracy: 0.01)
	}

	func test3001_iPadPro_portrait() {
		let boundingBox = E2CanvasBoundingBox(minX: 2, maxX: 177, minY: 8, maxY: 95)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 1024, height: 1366),
			uiInsets: UIEdgeInsets(top: 70, left: 0, bottom: 50, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 523.64, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 0, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -10.0, accuracy: 0.01)
	}

	func test4000_iPhone6S() {
		let boundingBox = E2CanvasBoundingBox(minX: 2, maxX: 177, minY: 8, maxY: 95)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 375, height: 667),
			uiInsets: UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 191.76, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 0, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -10.0, accuracy: 0.01)
	}

	func test5000_iPhone6S() {
		let boundingBox = E2CanvasBoundingBox(minX: 128, maxX: 135, minY: 92, maxY: 95)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 375, height: 667),
			uiInsets: UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 4218.75, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, -1968.75, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 3397.45, accuracy: 0.01)
	}

	func test6000_iPhone6S() {
		let boundingBox = E2CanvasBoundingBox(minX: 3, maxX: 9, minY: 50, maxY: 53)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 375, height: 667),
			uiInsets: UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0),
			margin: 10
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 4564.29, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, 4234.64, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -10.0, accuracy: 0.01)
	}

	func test7000_iPhone6S_zeroEdgeInsets() {
		let boundingBox = E2CanvasBoundingBox(minX: 124, maxX: 131, minY: 49, maxY: 56)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 375, height: 667),
			uiInsets: UIEdgeInsets.zero,
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 4218.75, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, -1781.25, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, 81.13, accuracy: 0.01)
	}

	func test8000_iPhone6S_additionalBarOntopOfNavigationBar() {
		let boundingBox = E2CanvasBoundingBox(minX: 90, maxX: 95, minY: 8, maxY: 95)
		let spy = HCZoomToFitRuleSpy(boundingBoxOrNil: boundingBox)
		let zoomToFit = HCZoomToFit(rule: spy)
		zoomToFit.execute(
			viewSize: CGSize(width: 375, height: 647),
			uiInsets: UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0),
			margin: 0
		)
		XCTAssertNil(spy.errorMessage)
		XCTAssertEqual(spy.resultScale ?? 0, 318.26, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.x ?? 0, -10.61, accuracy: 0.01)
		XCTAssertEqual(spy.resultPosition?.y ?? 0, -10.0, accuracy: 0.01)
	}
}

class HCZoomToFitRuleSpy: HCZoomToFitRule {
	let boundingBoxOrNil: E2CanvasBoundingBox?

	var errorMessage: String?
	var resultScale: CGFloat?
	var resultPosition: CGPoint?

	init(boundingBoxOrNil: E2CanvasBoundingBox?) {
		self.boundingBoxOrNil = boundingBoxOrNil
	}

	func error(_ message: String) {
		self.errorMessage = message
	}

	func findBoundingBox() -> E2CanvasBoundingBox? {
		return boundingBoxOrNil
	}

	func saveResult(scale: CGFloat, position: CGPoint) {
		self.resultScale = scale
		self.resultPosition = position
	}
}
