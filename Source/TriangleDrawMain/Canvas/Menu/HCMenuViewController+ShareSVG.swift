// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

extension HCMenuViewController {
	static func createShareSVGActivityViewController(svgData: Data, filename: String, triangleCount: UInt) -> UIActivityViewController {
		let filesize: Int = svgData.count
		log.debug("Open share sheet.  fileSize: \(filesize)  filename: '\(filename)'  triangleCount: \(triangleCount)")
		
        let emailSubject = "TriangleDraw - \(filename)"
		let itemBlock: WFActivitySpecificItemProviderItemBlock = { activityType in
                let message: String = "This is what I can do with \(triangleCount) triangles. What can you do?"
                return message
            }
        let provider = WFActivitySpecificItemProvider(placeholderItem: "", block: itemBlock)
        let avc = UIActivityViewController(activityItems: [provider, svgData], applicationActivities: nil)
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
