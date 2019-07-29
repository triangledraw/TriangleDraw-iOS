// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFStaticTextFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
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
			innerValue = newValue
			syncCellWithValue(innerValue)
		}
	}

	@discardableResult
	public func value(_ value: String) -> Self {
		self.value = value
		return self
	}
}

@available(*, unavailable, renamed: "RFStaticTextFormItem")
typealias StaticTextFormItem = RFStaticTextFormItem
