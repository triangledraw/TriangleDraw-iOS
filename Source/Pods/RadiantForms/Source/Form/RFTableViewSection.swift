// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFTableViewSection: NSObject {
	public let cells: RFTableViewCellArray
	public let header: RFTableViewSectionPart
	public let footer: RFTableViewSectionPart

	init(cells: RFTableViewCellArray, header: RFTableViewSectionPart, footer: RFTableViewSectionPart) {
		self.cells = cells
		self.header = header
		self.footer = footer
		super.init()
	}
}

extension RFTableViewSection: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = cells[indexPath.row]
		if let theCell = cell as? RFCellForRowDelegate {
			return theCell.form_cellForRow(indexPath: indexPath, tableView: tableView)
		}
		return cell
	}

	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return header.title
	}

	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return footer.title
	}
}

extension RFTableViewSection: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return header.view
	}

	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return footer.view
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return header.height
	}

	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return footer.height
	}

	public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
		return header.estimatedHeight
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = cells[indexPath.row] as? RFSelectRowDelegate {
			cell.form_didSelectRow(indexPath: indexPath, tableView: tableView)
		}
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let cell = cells[indexPath.row] as? RFCellHeightProvider {
			return cell.form_cellHeight(indexPath: indexPath, tableView: tableView)
		}
		return UITableView.rf_automaticDimension
	}

	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cells[indexPath.row] as? RFWillDisplayCellDelegate {
			cell.form_willDisplay(tableView: tableView, forRowAtIndexPath: indexPath)
		}
	}

	public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		if let cell = cells[indexPath.row] as? RFAccessoryButtonDelegate {
			cell.form_accessoryButtonTapped(indexPath: indexPath, tableView: tableView)
		}
	}
}

@available(*, unavailable, renamed: "RFTableViewSection")
typealias TableViewSection = RFTableViewSection
