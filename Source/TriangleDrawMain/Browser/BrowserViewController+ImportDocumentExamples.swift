// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import TriangleDrawLibrary

extension BrowserViewController {
	func importDocumentExamples() {
		func fileExist(_ url: URL) -> Bool {
			do {
				return try url.checkResourceIsReachable()
			} catch {
				return false
			}
		}

		let fm = FileManager.default
		guard let appUrl: URL = fm.urls(for: .documentDirectory, in: .userDomainMask).last else {
			log.error("Expected url to documentDirectory, but got nil.")
			return
		}

		func importDocument(documentExample: DocumentExample, displayName: String, documentDate: Date) {
			let source: URL = documentExample.url
			let dest: URL = appUrl.appendingPathComponent(displayName).appendingPathExtension("triangleDraw")
			do {
				if fileExist(dest) {
					try fm.removeItem(at: dest)
				}

				try fm.copyItem(at: source, to: dest)

				var attr = [FileAttributeKey: Any]()
				attr[FileAttributeKey.modificationDate] = documentDate
				try fm.setAttributes(attr, ofItemAtPath: dest.path)

				log.debug("successfully created file at: \(dest)")
			} catch {
				log.error("Failed to create file at: \(dest). Error: \(error)")
			}
		}

		let dateEinstein: Date = Date(timeIntervalSince1970: -2044742400) // 17mar1905 - Einstein
		let dateOrwell: Date = Date(timeIntervalSince1970: 441763200) // 01jan1984 - George Orwell
		let dateNow = Date() // Today

		importDocument(
			documentExample: DocumentExample.rune1,
			displayName: "Viking Symbol",
			documentDate: dateEinstein
		)
		importDocument(
			documentExample: DocumentExample.injection,
			displayName: "Injection",
			documentDate: dateOrwell
		)
		importDocument(
			documentExample: DocumentExample.triangledrawLogo,
			displayName: "Client Logo",
			documentDate: dateNow
		)
	}
}
