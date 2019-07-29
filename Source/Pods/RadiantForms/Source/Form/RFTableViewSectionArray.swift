// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFTableViewSectionArray: NSObject {
	public let sections: [RFTableViewSection]

	public init(sections: [RFTableViewSection]) {
		self.sections = sections
		super.init()
	}

	func findItem(_ cell: UITableViewCell?) -> RFTableViewCellArrayItem? {
		for section in sections {
			for item in section.cells.allItems {
				if item.cell === cell {
					return item
				}
			}
		}
		return nil
	}

	func findVisibleItem(indexPath: IndexPath) -> RFTableViewCellArrayItem? {
		guard indexPath.section >= 0 else { return nil }
		guard indexPath.row >= 0 else { return nil }
		guard indexPath.section < sections.count else { return nil }
		let section = sections[indexPath.section]
		let items = section.cells.visibleItems
		guard indexPath.row < items.count else { return nil }
		return items[indexPath.row]
	}

	func indexPathForItem(_ findItem: RFTableViewCellArrayItem) -> IndexPath? {
		for (sectionIndex, section) in sections.enumerated() {
			for (rowIndex, item) in section.cells.visibleItems.enumerated() {
				if item === findItem {
					return IndexPath(row: rowIndex, section: sectionIndex)
				}
			}
		}
		return nil
	}

	func reloadVisibleItems() {
		for section in sections {
			section.cells.reloadVisibleItems()
		}
	}

	var numberOfVisibleItems: Int {
		var count = 0
		for section in sections {
			count += section.cells.visibleItems.count
		}
		return count
	}

	public override var debugDescription: String {
		var result = [String]()
		result.append("============ number of sections: \(sections.count)")
		for (sectionIndex, section) in sections.enumerated() {
			result.append("  --- section: \(sectionIndex), number of cells: \(section.cells.visibleItems.count)")
			for (rowIndex, item) in section.cells.visibleItems.enumerated() {
				let cellType = type(of: item.cell)
				let s = "    \(sectionIndex).\(rowIndex) \(cellType)"
				result.append(s)
			}
		}
		result.append("============")
		return result.joined(separator: "\n")
	}

	func trace(_ items: Any?..., function: String = #function) {
		//print("\(function) - \(items)")
	}
}

extension RFTableViewSectionArray: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		let returnValue = sections.count
		trace(returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let returnValue = sections[section].tableView(tableView, numberOfRowsInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let returnValue = sections[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
		trace(indexPath, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let returnValue = sections[section].tableView(tableView, titleForHeaderInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let returnValue = sections[section].tableView(tableView, titleForFooterInSection: section)
		trace(section, returnValue)
		return returnValue
	}
}

extension RFTableViewSectionArray: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let formTableView: RFFormTableView = tableView as? RFFormTableView else {
            RFLog("ERROR: Expected tableView to be of type RFFormTableView.")
            return
        }
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else {
            RFLog("Section has a custom view. Will not apply appearance.")
            return
        }
        guard let color: UIColor = formTableView.sectionHeader_textLabel_textColor else {
            RFLog("No color provided. Will not apply appearance")
            return
        }
        RFLog("Applying appearance to section header")
        header.textLabel?.textColor = color
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let formTableView: RFFormTableView = tableView as? RFFormTableView else {
            RFLog("ERROR: Expected tableView to be of type RFFormTableView.")
            return
        }
        guard let footer: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else {
            RFLog("Section has a custom view. Will not apply appearance.")
            return
        }
        guard let color: UIColor = formTableView.sectionFooter_textLabel_textColor else {
            RFLog("No color provided. Will not apply appearance")
            return
        }
        RFLog("Applying appearance to section footer")
        footer.textLabel?.textColor = color
    }
    
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		sections[indexPath.section].tableView(tableView, didSelectRowAt: indexPath)
		trace(indexPath)
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let returnValue = sections[section].tableView(tableView, viewForHeaderInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let returnValue = sections[section].tableView(tableView, viewForFooterInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let returnValue = sections[section].tableView(tableView, heightForHeaderInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		let returnValue = sections[section].tableView(tableView, estimatedHeightForHeaderInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		let returnValue = sections[section].tableView(tableView, heightForFooterInSection: section)
		trace(section, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let returnValue = sections[indexPath.section].tableView(tableView, heightForRowAt: indexPath)
		trace(indexPath, returnValue)
		return returnValue
	}

	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		sections[indexPath.section].tableView(tableView, willDisplay: cell, forRowAt: indexPath)
		trace(indexPath)
	}

	public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		sections[indexPath.section].tableView(tableView, accessoryButtonTappedForRowWith: indexPath)
		trace(indexPath)
	}
}

extension RFTableViewSectionArray: UIScrollViewDelegate {
	/// hide keyboard when the user starts scrolling
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		guard let responder = scrollView.rf_firstResponder() else {
			return
		}

		if responder is RFDontCollapseWhenScrolling {
			// Don't collapse inline controls, such as inline date pickers, 
			// since there are more screen estate for the user to move around.
			return
		}

		// Scenario: A textfield is the first responder and has a visible keyboard
		// There is little screen estate for the user to find a button to dismiss the keyboard
		// Thus we want the keyboard to collapse when scrolling.
		responder.resignFirstResponder()
	}

	/// hide keyboard when the user taps the status bar
	public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
		scrollView.rf_firstResponder()?.resignFirstResponder()
		return true
	}
}

@available(*, unavailable, renamed: "RFTableViewSectionArray")
typealias TableViewSectionArray = RFTableViewSectionArray
