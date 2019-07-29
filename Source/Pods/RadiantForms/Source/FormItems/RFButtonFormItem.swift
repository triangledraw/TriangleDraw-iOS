// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFButtonFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public var action: () -> Void = {}
}

@available(*, unavailable, renamed: "RFButtonFormItem")
typealias ButtonFormItem = RFButtonFormItem
