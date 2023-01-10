// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit
import QuickLook
import TriangleDrawLibrary

/// The `Thumbnail process` keeps the same process running,
/// and renders thumbnails from different threads.
/// Therefore things have to be thread-safe.
let thumbnailProcess = ThumbnailProcess()

public enum MyDocumentError: Error {
	case forceError
}

enum MyImage: String {
	case boom
}

extension MyImage {
	var image: UIImage {
		guard let image: UIImage = UIImage(named: self.rawValue) else {
			log.error("no image for \(self)")
			fatalError("no image for \(self)")
		}
		return image
	}
}


class ThumbnailProvider: QLThumbnailProvider {

	/// Main method to implement in order to provide thumbnails for files.
    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
		let t0: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()

		let invocationCounter: UInt = thumbnailProcess.setupAndIncrement()
		let tracking = ThumbnailTracking(value: invocationCounter)
		//log.debug("\(tracking) start")

		let fileURL: URL = request.fileURL
		let maximumSize = request.maximumSize
		let scale = request.scale

		let documentName: String = fileURL.deletingPathExtension().lastPathComponent

		log.debug("\(tracking) Begin. Document: '\(documentName)'\nfileURL: \(fileURL)\nmaximumSize: \(maximumSize)\nscale: \(scale)")

		if AppConstant.ThumbnailProvider.developer_enableErrorExperiments {
			if documentName == "boom1" {
				log.error("Detected document that triggers an error. Boom1")
				let error = MyDocumentError.forceError
				handler(nil, error)
				return
			}

			if documentName == "boom2" {
				log.error("Detected document that triggers an error. Boom2")
				let error = MyDocumentError.forceError

				guard let url: URL = Bundle.main.url(forResource: "Boom", withExtension: "png") else {
					log.error("Unable to find resource with the name")
					handler(nil, error)
					return
				}

				//let image: UIImage = MyImage.boom.image
				// I want to get the url to the image, but it's difficult.

				//let url: URL = url to image
				let reply = QLThumbnailReply(imageFileURL: url)

				handler(reply, error)
				return
			}

			if documentName == "boom3" {
				log.error("Detected document that triggers an error. Boom3")
				//let error = MyDocumentError.forceError

				let image: UIImage = MyImage.boom.image
				let r = CGRect(origin: .zero, size: maximumSize)

				func draw() -> Bool {
					image.draw(in: r)
					return true
				}

				let reply = QLThumbnailReply(contextSize: r.size, currentContextDrawing: draw)

				// handler(reply, error)
				handler(reply, nil)
				return
			}
		}

		// Make use of the parameters of the request to determine the context size for the subsequent steps.
		let contextSize = contextSizeForFile(at: fileURL, maximumSize: maximumSize, scale: scale)

		let drawingBlock: (CGContext) -> Bool = { (context: CGContext) in
//			log.debug("#\(invocationCounter) will draw")
			let success: Bool = ThumbnailProvider.drawThumbnail(
				tracking: tracking,
				startTime: t0,
				fileURL: fileURL,
				contextSize: contextSize,
				scale: scale,
				context: context
			)
			let t1: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
			let elapsed: Double = t1 - t0
			if success {
				log.debug("\(tracking) End. elapsed: \(elapsed.string2)")
			} else {
				// Indicate whether or not drawing the thumbnail succeeded.
				ThumbnailProvider.drawErrorImage(context: context)
				log.error("\(tracking) End. Failed to draw thumbnail. elapsed: \(elapsed.string2)")
			}

			// If we are returning `false`, then our rendered image will not be shown
			// Instead the app icon will be shown.
			// Thus we always return true.
			return true
		}

		// Create the QLThumbnailReply with the requested context size and the drawing block that draws the thumbnail.
		let reply = QLThumbnailReply(contextSize: contextSize, drawing: drawingBlock)

		// Call the completion handler and provide the reply.
		// No need to return an error, since thumbnails are always provided.
		handler(reply, nil)
    }

	private func contextSizeForFile(at URL: URL, maximumSize: CGSize, scale: CGFloat) -> CGSize {
		switch AppConstant.ThumbnailProvider.size {
		case .square:
			return maximumSize
		case .experimental_landscape:
			return CGSize(width: maximumSize.width, height: maximumSize.height * 0.75)
		case .experimental_portrait:
			return CGSize(width: maximumSize.width * 0.75, height: maximumSize.height)
		}
	}

	private enum LoadCanvasError: Error {
		case timeoutWhileOpeningDocument
		case expectedDocumentStateToBeNormalButGotSomethingElse
		case documentOpenFailedForUnknownReason
		case timeoutWhileClosingDocument
		case expectedCanvasToBeNonNil
	}


	private static func loadCanvas(tracking: ThumbnailTracking, fileURL: URL) throws -> E2Canvas {
		let defaultTimeoutLengthInSeconds: Int = 3

		let document = Document(fileURL: fileURL)

		// Before open the documentState is typically `[normal,closed]` or `[normal,closed,progressAvailable]`
//		log.debug("\(tracking) before open. documentState: \(document.documentState.td_humanReadable)")

		// Open the document
		let openingSemaphore = DispatchSemaphore(value: 0)
		var openingSuccess = false
//		log.debug("\(tracking) A")
		document.open(completionHandler: { (success) in
			openingSuccess = success
//			log.debug("\(tracking) C")
			openingSemaphore.signal()
		})
		let openingTimeout: DispatchTime = DispatchTime.now() + .seconds(defaultTimeoutLengthInSeconds)
//		log.debug("\(tracking) B")
		let openingDispatchTimeoutResult: DispatchTimeoutResult = openingSemaphore.wait(timeout: openingTimeout)
//		log.debug("\(tracking) D")
		guard openingDispatchTimeoutResult == .success else {
			log.error("\(tracking) Timeout. Open document took longer than \(defaultTimeoutLengthInSeconds) seconds.\nfileURL: \(fileURL)\ndocumentState: \(document.documentState.td_humanReadable)")
			throw LoadCanvasError.timeoutWhileOpeningDocument
		}
		guard document.documentState.contains(.normal) else {
			log.error("\(tracking) Failed to open document. Expected documentState to be normal, but got something else.\nfileURL: \(fileURL)\ndocumentState: \(document.documentState.td_humanReadable)")
			throw LoadCanvasError.expectedDocumentStateToBeNormalButGotSomethingElse
		}
		guard openingSuccess else {
			let reason: String
			if let error: Error = document.handleError_latestError {
				document.clearLatestError()
				reason = "\(error)"
			} else {
				reason = "Unknown reason"
			}
			// Documentstate is typically: `[normal,closed,savingError]`
			log.error("\(tracking) Failed to open document.\nfileURL: \(fileURL)\ndocumentState: \(document.documentState.td_humanReadable)\reason: \(reason)")
			throw LoadCanvasError.documentOpenFailedForUnknownReason
		}

		let canvasOrNil: E2Canvas? = document.canvas

		// After a successful opening, the documentState is
		// typically `[normal,editingDisabled]` or `[normal,editingDisabled,progressAvailable]`
		log.debug("\(tracking) Document is open. documentState: \(document.documentState.td_humanReadable)")

		// Close the document
		let closingSemaphore = DispatchSemaphore(value: 0)
		document.close { (_) in
			closingSemaphore.signal()
		}
		let closingTimeout: DispatchTime = DispatchTime.now() + .seconds(defaultTimeoutLengthInSeconds)
		let closingDispatchTimeoutResult: DispatchTimeoutResult = closingSemaphore.wait(timeout: closingTimeout)
		guard closingDispatchTimeoutResult == .success else {
			log.error("\(tracking) Timeout. Closing document took longer than \(defaultTimeoutLengthInSeconds) seconds. Cannot draw thumbnail. fileURL: \(fileURL)")
			throw LoadCanvasError.timeoutWhileClosingDocument
		}

		guard let canvas: E2Canvas = canvasOrNil else {
			log.error("\(tracking) Expected document to have a non-nil canvas, but got nil. Cannot render thumbnail")
			throw LoadCanvasError.expectedCanvasToBeNonNil
		}

		return canvas
	}

	private static func drawThumbnail(tracking: ThumbnailTracking, startTime: CFAbsoluteTime, fileURL: URL, contextSize: CGSize, scale: CGFloat, context: CGContext) -> Bool {

		let canvas: E2Canvas
		do {
			canvas = try ThumbnailProvider.loadCanvas(tracking: tracking, fileURL: fileURL)
		} catch {
			log.error("\(tracking) Unable to load canvas: \(error)\nfileURL: \(fileURL)")
			return false
		}

		let size = CGSize(width: contextSize.width * scale, height: contextSize.height * scale)
		let frame = CGRect(origin: .zero, size: contextSize)
		let frameScaled = CGRect(origin: .zero, size: size)

		do {
			context.setFillColor(AppConstant.ThumbnailProvider.backgroundFill.cgColor)
			context.fill(frameScaled)
		}

		let tileCount: UInt = size.triangleDraw_findOptimalTileCount(clampN: 16)
//		log.debug("\(tracking) contextSize: \(contextSize)  scale: \(scale)  size: \(size)  tileCount: \(tileCount)")

		guard let image: UIImage = TDRenderBitmap.inner_image2(with: size, tileCount: Int(tileCount), canvas: canvas, context: context, progress: nil) else {
			log.error("\(tracking) Expected TDRenderBitmap to return a non-nil image, but got nil.")
			return false
		}
		image.draw(in: frame)

		if AppConstant.ThumbnailProvider.debug_drawDiagnosticsInfo {
			let t1 = CFAbsoluteTimeGetCurrent()
			let elapsed: Double = t1 - startTime
			//log.debug("\(tracking) Elapsed: \(elapsed.string2)")
			drawBottomBarWithDiagnosticsInfo(elapsed: elapsed, context: context)
		}

		return true
	}

	static func drawErrorImage(context: CGContext) {
		let image: UIImage = MyImage.boom.image
		let bounds: CGRect = context.boundingBoxOfClipPath
		UIGraphicsPushContext(context)
		image.draw(in: bounds)
		UIGraphicsPopContext()
	}

	static func drawBottomBarWithDiagnosticsInfo(elapsed: Double, context: CGContext) {
		let bounds: CGRect = context.boundingBoxOfClipPath
		let barWidth: CGFloat = remap(CGFloat(elapsed), CGFloat(0.0), CGFloat(2.0), CGFloat(0), bounds.width)
		let barHeight: CGFloat = 10
		let rect = CGRect(x: 0, y: bounds.height - barHeight, width: barWidth, height: barHeight)
		context.setFillColor(AppConstant.ColorBlindSafe.orange40.cgColor)
		context.fill(rect)
	}
}

class ThumbnailProcess {
	private let setupSemaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
	private var setupCounter: UInt = 0

	/// Thread-safe setup
	///
	/// First time being invoked, the global log instance is being initialized.
	/// Following times, there is no initialization going on.
	///
	/// Returns an incrementing counter for each invocation.
	func setupAndIncrement() -> UInt {
		setupSemaphore.wait()
		let counter: UInt = setupCounter
		setupCounter += 1

		let isFirstInvocation = (counter == 0)
		if isFirstInvocation {
			LogHelper.setup_thumbnailExecutable()
		}
		setupSemaphore.signal()
		return counter
	}
}

struct ThumbnailTracking {
	private let id: String
	init(value: UInt) {
		self.id = "#\(value)"
	}
}

extension ThumbnailTracking: CustomStringConvertible {
	var description: String {
		return self.id
	}
}
