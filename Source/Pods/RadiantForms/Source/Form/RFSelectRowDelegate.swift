// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFSelectRowDelegate {
	func form_didSelectRow(indexPath: IndexPath, tableView: UITableView)
}


@available(*, unavailable, renamed: "RFSelectRowDelegate")
typealias SelectRowDelegate = RFSelectRowDelegate
