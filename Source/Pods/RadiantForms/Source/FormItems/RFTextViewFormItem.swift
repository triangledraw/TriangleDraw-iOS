// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFTextViewFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var placeholder: String = ""

	@discardableResult
	public func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	typealias SyncBlock = (_ value: String) -> Void
	var syncCellWithValue: SyncBlock = { (string: String) in
		RFLog("sync is not overridden")
	}

	internal var innerValue: String = ""
	public var value: String {
		get {
			return self.innerValue
		}
		set {
			self.assignValueAndSync(newValue)
		}
	}

	func assignValueAndSync(_ value: String) {
		innerValue = value
		syncCellWithValue(value)
	}
}

@available(*, unavailable, renamed: "RFTextViewFormItem")
typealias TextViewFormItem = RFTextViewFormItem
