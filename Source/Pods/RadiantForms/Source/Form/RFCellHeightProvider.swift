// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFCellHeightProvider {
	func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat
}

@available(*, unavailable, renamed: "RFCellHeightProvider")
typealias CellHeightProvider = RFCellHeightProvider
