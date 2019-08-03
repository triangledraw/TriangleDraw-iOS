// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UITableView {
	/// This is supposed to be run after the expand row animation has completed.
	/// This function ensures that the main row and its expanded row are both fully visible.
	/// If the rows are obscured it will scrolls to make them visible.
	internal func rf_scrollToVisibleAfterExpand(_ indexPath: IndexPath) {
		let rect = rectForRow(at: indexPath)
		let focusArea_minY = rect.minY - (contentOffset.y + contentInset.top)
		//RFLog("focusArea_minY \(focusArea_minY)    \(rect.minY) \(contentOffset.y) \(contentInset.top)")
		if focusArea_minY < 0 {
			RFLog("focus area is outside the top. Scrolling to make it visible")
			scrollToRow(at: indexPath, at: .top, animated: true)
			return
		}

		// Expanded row
		let expanded_indexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
		let expanded_rect = rectForRow(at: expanded_indexPath)
		let focusArea_maxY = expanded_rect.maxY - (contentOffset.y + contentInset.top)
		//RFLog("focusArea_maxY \(focusArea_maxY)    \(expanded_rect.maxY) \(contentOffset.y) \(contentInset.top)")

		let bottomMaxY = bounds.height - (contentInset.bottom + contentInset.top)
		//RFLog("bottomMaxY: \(bottomMaxY) \(bounds.height) \(contentInset.bottom) \(contentInset.top)")

		if focusArea_maxY > bottomMaxY {
			RFLog("content is outside the bottom. Scrolling to make it visible")
			scrollToRow(at: expanded_indexPath, at: .bottom, animated: true)
			return
		}

		RFLog("focus area is inside. No need to scroll")
	}
}
