// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension HCMenuViewController {
	static func createSharePDFActivityViewController(pdfData: Data, filename: String, triangleCount: UInt) -> UIActivityViewController {
		let filesize: Int = pdfData.count
		log.debug("Open share sheet.  fileSize: \(filesize)  filename: '\(filename)'  triangleCount: \(triangleCount)")
		
		// There is not easy way to tell `UIActivityViewController`
		// that the data is a PDF file, and what the filename should be.
		// The easiest solution is to store the data in the temp dir
		// with the filename+extension that it should be treated as.
		let url: URL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename).appendingPathExtension("pdf")
		do {
			try pdfData.write(to: url)
		} catch {
			log.error("failed to write: \(url) \(error)")
			fatalError()
		}

        let subjectFormat = NSLocalizedString("EMAIL_PDF_SUBJECT_%@", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "TriangleDraw - {Drawing name}, a subject line for mails containing PDF attachments")
        let emailSubject = String(format: subjectFormat, filename)
		let itemBlock: WFActivitySpecificItemProviderItemBlock = { activityType in
                var message: String? = nil
                do {
                    let format = NSLocalizedString("SHARE_%d_TRIANGLES_ON_OTHER_SOCIAL_MEDIA", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "When sharing a drawing via other kinds of social media (Email, Text messaging, Flickr, Tumblr, etc): The message posted together with a .JPG file attachment")
                    message = String(format: format, triangleCount)
                }
                return message
            }
        let provider = WFActivitySpecificItemProvider(placeholderItem: "", block: itemBlock)
        let avc = UIActivityViewController(activityItems: [provider, url], applicationActivities: nil)
		avc.excludedActivityTypes = [
			.postToFacebook,
			.postToTwitter,
			.postToWeibo,
			.assignToContact,
			.saveToCameraRoll,
			.addToReadingList,
			.postToFlickr,
			.postToVimeo,
			.postToTencentWeibo,
			.openInIBooks
		]
        avc.setValue(emailSubject, forKey: "subject")
        avc.completionWithItemsHandler = { activityTypeOrNil, completed, returnedItems, activityError in
			guard let activityType: UIActivity.ActivityType = activityTypeOrNil else {
                log.debug("No activity was selected. (Cancel)")
                return
            }
			let completedString = completed ? "YES" : "NO"
            log.debug("activity: \(activityType) completed: \(completedString)")
        }
        return avc
    }
}
