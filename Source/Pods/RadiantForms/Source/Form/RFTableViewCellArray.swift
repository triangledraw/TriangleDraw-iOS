// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFTableViewCellArrayItem {
	public let cell: UITableViewCell
	public var hidden: Bool

	public init(cell: UITableViewCell, hidden: Bool) {
		self.cell = cell
		self.hidden = hidden
	}
}

public class RFTableViewCellArray {
	fileprivate(set) var allItems: [RFTableViewCellArrayItem]
	fileprivate(set) var visibleItems = [RFTableViewCellArrayItem]()

	public static func create(cells: [UITableViewCell]) -> RFTableViewCellArray {
		let items = cells.map { RFTableViewCellArrayItem(cell: $0, hidden: false) }
		return RFTableViewCellArray(allItems: items)
	}

	public static func createEmpty() -> RFTableViewCellArray {
		return RFTableViewCellArray(allItems: [])
	}

	public init(allItems: [RFTableViewCellArrayItem]) {
		self.allItems = allItems
		reloadVisibleItems()
	}

	public func reloadVisibleItems() {
		visibleItems = allItems.filter { $0.hidden == false }
	}

	public subscript(index: Int) -> UITableViewCell {
		return visibleItems[index].cell
	}

	public var count: Int {
		return visibleItems.count
	}

	public func append(_ cell: UITableViewCell) {
		let item = RFTableViewCellArrayItem(cell: cell, hidden: false)
		allItems.append(item)
	}

	public func appendHidden(_ cell: UITableViewCell) {
		let item = RFTableViewCellArrayItem(cell: cell, hidden: true)
		allItems.append(item)
	}
}

@available(*, unavailable, renamed: "RFTableViewCellArrayItem")
typealias TableViewCellArrayItem = RFTableViewCellArrayItem

@available(*, unavailable, renamed: "RFTableViewCellArray")
typealias TableViewCellArray = RFTableViewCellArray
