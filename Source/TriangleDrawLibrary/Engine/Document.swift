// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

public enum DocumentError: Error {
	case archivingFailure
	case unrecognizedContent
	case corruptDocument(error: Error)
}

extension DocumentError {
	public var localizedDescription: String {
		switch self {
		case .archivingFailure:
			return NSLocalizedString("File could not be saved", comment: "")
		case .unrecognizedContent:
			return NSLocalizedString("File is an unrecognised format", comment: "")
		case .corruptDocument:
			return NSLocalizedString("Unable to create canvas from pbm representation", tableName: "TDDocument", comment: "")
		}
	}
}


public class Document: UIDocument {
    public var canvas: E2Canvas?

	public enum DisplayNameBehavior {
		case extractFromURL
		case customDisplayName(name: String)
	}
	public var displayNameBehavior = DisplayNameBehavior.extractFromURL

	override public func contents(forType typeName: String) throws -> Any {
		guard let canvas: E2Canvas = self.canvas else {
			throw DocumentError.archivingFailure
		}
		let data: Data = TDCanvasWriter.pbmRepresentation(from: canvas)
		guard !data.isEmpty else {
			throw DocumentError.archivingFailure
		}
		return data
	}

	override public func load(fromContents contents: Any, ofType typeName: String?) throws {
		guard let data = contents as? Data else {
			throw DocumentError.unrecognizedContent
		}
		let canvas: E2Canvas
		do {
			canvas = try TDCanvasReader.canvas(fromPBMRepresentation: data)
		} catch {
			throw DocumentError.corruptDocument(error: error)
		}
		self.canvas = canvas
	}

	public private(set) var handleError_latestError: Error?

	public func clearLatestError() {
		handleError_latestError = nil
	}

	override public func handleError(_ error: Error, userInteractionPermitted: Bool) {
		log.error("Error: \(type(of: error)) '\(error)'\nDocument: '\(self)'\nuserInteractionPermitted: \(userInteractionPermitted)\nfileUrl: \(self.fileURL)\ndocumentState: \(self.documentState.td_humanReadable)")
		self.handleError_latestError = error
        super.handleError(error, userInteractionPermitted: userInteractionPermitted)
    }
}

extension Document {
	public var displayName: String {
		switch displayNameBehavior {
		case .extractFromURL:
			return fileURL.triangleDraw_displayName
		case let .customDisplayName(name):
			return name
		}
	}

	override public var description: String {
		return self.displayName
	}
}
