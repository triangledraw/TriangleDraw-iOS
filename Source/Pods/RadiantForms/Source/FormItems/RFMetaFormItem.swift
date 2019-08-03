// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

/// This is an invisible field, that is submitted along with the json
public class RFMetaFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var value: AnyObject?

	@discardableResult
	public func value(_ value: AnyObject?) -> Self {
		self.value = value
		return self
	}
}

@available(*, unavailable, renamed: "RFMetaFormItem")
typealias MetaFormItem = RFMetaFormItem
