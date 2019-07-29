// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension IndexPath {

	/// Indexpath of the previous cell.
	///
	/// This function is complex because it deals with empty sections and invalid indexpaths.
	public func rf_indexPathForPreviousCell(_ tableView: UITableView) -> IndexPath? {
		if section < 0 || row < 0 {
			return nil
		}
		let sectionCount = tableView.numberOfSections
		if section < 0 || section >= sectionCount {
			return nil
		}
		let firstRowCount = tableView.numberOfRows(inSection: section)
		if row > 0 && row <= firstRowCount {
			return IndexPath(row: row - 1, section: section)
		}
		var currentSection = section
		while true {
			currentSection -= 1
			if currentSection < 0 || currentSection >= sectionCount {
				return nil
			}
			let rowCount = tableView.numberOfRows(inSection: currentSection)
			if rowCount > 0 {
				return IndexPath(row: rowCount - 1, section: currentSection)
			}
		}
	}
    
    @available(*, deprecated, message: "Will be removed with Version2, use rf_indexPathForPreviousCell instead")
    public func form_indexPathForPreviousCell(_ tableView: UITableView) -> IndexPath? {
        return rf_indexPathForPreviousCell(tableView)
    }

	/// Indexpath of the next cell.
	///
	/// This function is complex because it deals with empty sections and invalid indexpaths.
	public func rf_indexPathForNextCell(_ tableView: UITableView) -> IndexPath? {
		if section < 0 {
			return nil
		}
		let sectionCount = tableView.numberOfSections
		var currentRow = row + 1
		var currentSection = section
		while true {
			if currentSection >= sectionCount {
				return nil
			}
			let rowCount = tableView.numberOfRows(inSection: currentSection)
			if currentRow >= 0 && currentRow < rowCount {
				return IndexPath(row: currentRow, section: currentSection)
			}
			if currentRow > rowCount {
				return nil
			}
			currentSection += 1
			currentRow = 0
		}
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_indexPathForNextCell instead")
    public func form_indexPathForNextCell(_ tableView: UITableView) -> IndexPath? {
        return rf_indexPathForNextCell(tableView)
    }

}

extension UITableView {

	/// Determine where a cell is located in this tableview. Considers cells inside and cells outside the visible area.
	///
	/// Unlike UITableView.indexPathForCell() which only looksup inside the visible area.
	/// UITableView doesn't let you lookup cells outside the visible area.
	/// UITableView.indexPathForCell() returns nil when the cell is outside the visible area.
	func rf_indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		let sectionCount: Int = dataSource.numberOfSections?(in: self) ?? 0
		for section: Int in 0 ..< sectionCount {
			let rowCount: Int = dataSource.tableView(self, numberOfRowsInSection: section)
			for row: Int in 0 ..< rowCount {
				let indexPath = IndexPath(row: row, section: section)
				let dataSourceCell = dataSource.tableView(self, cellForRowAt: indexPath)
				if dataSourceCell === cell {
					return indexPath
				}
			}
		}
		return nil
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_indexPathForCell instead")
    func form_indexPathForCell(_ cell: UITableViewCell) -> IndexPath? {
        return rf_indexPathForCell(cell)
    }

	/// Find a cell above that can be jumped to. Skip cells that cannot be jumped to.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func rf_indexPathForPreviousResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: IndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.rf_indexPathForPreviousCell(self)
			if indexPath == nil {
				return nil
			}

			let cell = dataSource.tableView(self, cellForRowAt: indexPath)
			if cell.canBecomeFirstResponder {
				return indexPath
			}
		}
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_indexPathForPreviousResponder instead")
    func form_indexPathForPreviousResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
        return rf_indexPathForPreviousResponder(initialIndexPath)
    }
    
	/// Find a cell below that can be jumped to. Skip cells that cannot be jumped to.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func rf_indexPathForNextResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
		guard let dataSource = self.dataSource else { return nil }
		var indexPath: IndexPath! = initialIndexPath
		while true {
			indexPath = indexPath.rf_indexPathForNextCell(self)
			if indexPath == nil {
				return nil
			}

			let cell = dataSource.tableView(self, cellForRowAt: indexPath)
			if cell.canBecomeFirstResponder {
				return indexPath
			}
		}
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_indexPathForNextResponder instead")
    func form_indexPathForNextResponder(_ initialIndexPath: IndexPath) -> IndexPath? {
        return rf_indexPathForNextResponder(initialIndexPath)
    }
    
	/// Jump to a cell above.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func rf_makePreviousCellFirstResponder(_ cell: UITableViewCell) {
		guard let indexPath0 = rf_indexPathForCell(cell) else { return }
		guard let indexPath1 = rf_indexPathForPreviousResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRow(at: indexPath1, at: .middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAt: indexPath1)
		cell.becomeFirstResponder()
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_makePreviousCellFirstResponder instead")
    func form_makePreviousCellFirstResponder(_ cell: UITableViewCell) {
        return rf_makePreviousCellFirstResponder(cell)
    }

	/// Jump to a cell below.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func rf_makeNextCellFirstResponder(_ cell: UITableViewCell) {
		guard let indexPath0 = rf_indexPathForCell(cell) else { return }
		guard let indexPath1 = rf_indexPathForNextResponder(indexPath0) else { return }
		guard let dataSource = self.dataSource else { return }
		scrollToRow(at: indexPath1, at: .middle, animated: true)
		let cell = dataSource.tableView(self, cellForRowAt: indexPath1)
		cell.becomeFirstResponder()
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_makeNextCellFirstResponder instead")
    func form_makeNextCellFirstResponder(_ cell: UITableViewCell) {
        rf_makeNextCellFirstResponder(cell)
    }

	/// Determines if it's possible to jump to a cell above.
	func rf_canMakePreviousCellFirstResponder(_ cell: UITableViewCell) -> Bool {
		guard let indexPath0 = rf_indexPathForCell(cell) else { return false }
		if rf_indexPathForPreviousResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_canMakePreviousCellFirstResponder instead")
    func form_canMakePreviousCellFirstResponder(_ cell: UITableViewCell) -> Bool {
        return rf_canMakePreviousCellFirstResponder(cell)
    }
    
	/// Determines if it's possible to jump to a cell below.
	func rf_canMakeNextCellFirstResponder(_ cell: UITableViewCell) -> Bool {
		guard let indexPath0 = rf_indexPathForCell(cell) else { return false }
		if rf_indexPathForNextResponder(indexPath0) == nil { return false }
		if self.dataSource == nil { return false }
		return true
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_canMakeNextCellFirstResponder instead")
    func form_canMakeNextCellFirstResponder(_ cell: UITableViewCell) -> Bool {
        return rf_canMakeNextCellFirstResponder(cell)
    }
}

extension UITableViewCell {

	/// Jump to the previous cell, located above the current cell.
	///
	/// Usage: when the user types SHIFT TAB on the keyboard, then we want to jump to a cell above.
	func rf_makePreviousCellFirstResponder() {
		rf_tableView()?.rf_makePreviousCellFirstResponder(self)
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_makePreviousCellFirstResponder instead")
    func form_makePreviousCellFirstResponder() {
        rf_makePreviousCellFirstResponder()
    }

	/// Jump to the next cell, located below the current cell.
	///
	/// Usage: when the user hits TAB on the keyboard, then we want to jump to a cell below.
	func rf_makeNextCellFirstResponder() {
		rf_tableView()?.rf_makeNextCellFirstResponder(self)
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_makeNextCellFirstResponder instead")
    func form_makeNextCellFirstResponder() {
        rf_makeNextCellFirstResponder()
    }
    
	/// Determines if it's possible to jump to the cell above.
	func rf_canMakePreviousCellFirstResponder() -> Bool {
		return rf_tableView()?.rf_canMakePreviousCellFirstResponder(self) ?? false
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_canMakePreviousCellFirstResponder instead")
    func form_canMakePreviousCellFirstResponder() -> Bool {
        return rf_canMakePreviousCellFirstResponder()
    }
    
	/// Determines if it's possible to jump to the cell below.
	func rf_canMakeNextCellFirstResponder() -> Bool {
		return rf_tableView()?.rf_canMakeNextCellFirstResponder(self) ?? false
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_canMakeNextCellFirstResponder instead")
    func form_canMakeNextCellFirstResponder() -> Bool {
        return rf_canMakeNextCellFirstResponder()
    }
}
