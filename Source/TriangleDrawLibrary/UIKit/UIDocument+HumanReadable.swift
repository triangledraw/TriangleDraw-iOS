// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIDocument.State {
	/// Returns a string like this: `[normal,editingDisabled]` or `[normal,closed]`.
	public var td_humanReadable: String {
		var matchedNames = [String]()
		func check(_ state: UIDocument.State, _ name: String) {
			if self.contains(state) { matchedNames.append(name) }
		}
		check(.normal, "normal")
		check(.closed, "closed")
		check(.inConflict, "inConflict")
		check(.savingError, "savingError")
		check(.editingDisabled, "editingDisabled")
		check(.progressAvailable, "progressAvailable")
		return "[" + matchedNames.joined(separator: ",") + "]"
	}
}
