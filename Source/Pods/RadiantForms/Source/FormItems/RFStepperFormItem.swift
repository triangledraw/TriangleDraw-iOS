// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFStepperFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	typealias SyncBlock = (_ value: Int, _ animated: Bool) -> Void
	var syncCellWithValue: SyncBlock = { (value: Int, animated: Bool) in
		RFLog("sync is not overridden")
	}

	internal var innerValue: Int = 0
	public var value: Int {
		get {
			return self.innerValue
		}
		set {
			self.setValue(newValue, animated: false)
		}
	}

	public func setValue(_ value: Int, animated: Bool) {
		innerValue = value
		syncCellWithValue(value, animated)
	}
}

@available(*, unavailable, renamed: "RFStepperFormItem")
typealias StepperFormItem = RFStepperFormItem
