// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension HCMenuViewController {
	static func createSharePNGActivityViewController(image imageToShare: UIImage, filename: String?, triangleCount: UInt) -> UIActivityViewController {
		let filenameDebugString: String = filename ?? "nil"
		let imageSize: CGSize = imageToShare.size
		log.debug("Open share sheet.  imageSize: \(imageSize)  filename: '\(filenameDebugString)'  triangleCount: \(triangleCount)")
		
        let subjectFormat = NSLocalizedString("EMAIL_PNG_SUBJECT_%@", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "TriangleDraw - {Drawing name}, a subject line for mails containing PNG attachments")
        let emailSubject = String(format: subjectFormat, filename ?? "")
        let avc = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
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
