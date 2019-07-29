// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFWillDisplayCellDelegate {
	func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath)
}


@available(*, unavailable, renamed: "RFWillDisplayCellDelegate")
typealias WillDisplayCellDelegate = RFWillDisplayCellDelegate
