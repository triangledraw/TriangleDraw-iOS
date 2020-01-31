// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension HCMenuViewController {
	static func createSharePNGActivityViewController(image imageToShare: UIImage, filename: String?, triangleCount: UInt) -> UIActivityViewController {
		let filenameDebugString: String = filename ?? "nil"
		let imageSize: CGSize = imageToShare.size
		log.debug("Open share sheet.  imageSize: \(imageSize)  filename: '\(filenameDebugString)'  triangleCount: \(triangleCount)")
		
        let subjectFormat = NSLocalizedString("EMAIL_PNG_SUBJECT_%@", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "TriangleDraw - {Drawing name}, a subject line for mails containing PNG attachments")
        let emailSubject = String(format: subjectFormat, filename ?? "")
		let itemBlock: WFActivitySpecificItemProviderItemBlock = { activityType in
                var message: String? = nil
                if activityType == UIActivity.ActivityType.postToFacebook {
                    let format = NSLocalizedString("SHARE_%d_TRIANGLES_ON_FACEBOOK", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "When sharing a drawing via Facebook: The message posted to Facebook feed together with a .JPG file attachment")
                    message = String(format: format, triangleCount)
                } else if activityType == UIActivity.ActivityType.postToTwitter {
                    let format = NSLocalizedString("SHARE_%d_TRIANGLES_ON_TWITTER", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "When sharing a drawing via Twitter: The message posted to Twitter feed together with a .JPG file attachment")
                    let formattedString = String(format: format, triangleCount)

					// In the past (iOS11 and earlier) the Twitter sheet was showing both the text and the image.
					// However with iOS12 the image now entirely covers the text, so that the text isn't visible.
					// A solution is insert a space at the end of "lorem ipsum #TriangleDraw".
					message = formattedString + " "
                } else {
                    let format = NSLocalizedString("SHARE_%d_TRIANGLES_ON_OTHER_SOCIAL_MEDIA", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "When sharing a drawing via other kinds of social media (Email, Text messaging, Flickr, Tumblr, etc): The message posted together with a .JPG file attachment")
                    message = String(format: format, triangleCount)
                }
                return message
            }
        let provider = WFActivitySpecificItemProvider(placeholderItem: "", block: itemBlock)
        let avc = UIActivityViewController(activityItems: [provider, imageToShare], applicationActivities: nil)
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
