// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFAccessoryButtonDelegate {
	func form_accessoryButtonTapped(indexPath: IndexPath, tableView: UITableView)
}


@available(*, unavailable, renamed: "RFAccessoryButtonDelegate")
typealias AccessoryButtonDelegate = RFAccessoryButtonDelegate
