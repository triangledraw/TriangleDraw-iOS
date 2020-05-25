// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFToggleFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public typealias SyncBlock = (_ value: Bool, _ animated: Bool) -> Void
	public var syncCellWithValue: SyncBlock = { (value: Bool, animated: Bool) in
		RFLog("sync is not overridden")
	}

	internal var innerValue: Bool = false
	public var value: Bool {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	public typealias SwitchDidChangeBlock = (_ value: Bool) -> Void
	public var switchDidChangeBlock: SwitchDidChangeBlock = { (value: Bool) in
		RFLog("not overridden")
	}

	public func switchDidChange(_ value: Bool) {
		innerValue = value
		switchDidChangeBlock(value)
	}

	public func setValue(_ value: Bool, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}
}

@available(*, unavailable, renamed: "RFToggleFormItem")
typealias SwitchFormItem = RFToggleFormItem

@available(*, unavailable, renamed: "RFToggleFormItem")
typealias RFSwitchFormItem = RFToggleFormItem
