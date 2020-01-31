// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import XCTest

class UITests: XCTestCase {
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

	func testCaptureScreenshot_browserWithDocumentExamples() {
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launchArguments.append("-ScreenshotBrowserImportDocumentExamples")
		app.launchArguments.append("true")
		app.launch()
		snapshot("0browser")
	}

    func testCaptureScreenshot_canvasWithTriangleDrawLogo() {
        let app = XCUIApplication()
        setupSnapshot(app)
		app.launchArguments.append("-ScreenshotCanvasWithTriangleDrawLogo")
		app.launchArguments.append("true")
        app.launch()
        snapshot("1canvas")
    }

    func testCaptureScreenshot_canvasWithRune() {
        let app = XCUIApplication()
        setupSnapshot(app)
		app.launchArguments.append("-ScreenshotCanvasWithRune")
		app.launchArguments.append("true")
        app.launch()
        snapshot("2canvas")
    }
}
