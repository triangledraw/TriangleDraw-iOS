// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFSectionFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}
}

public class RFSectionHeaderTitleFormItem: RFFormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}

	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	/// The section title is shown in uppercase.
	///
	/// Works best with texts shorter than 50 characters
	///
	/// Longer texts that spans multiple lines can cause crashes with expand/collapse animations.
	/// In this case consider using the `SectionHeaderViewFormItem` class.
	public var title: String?

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

public class RFSectionHeaderViewFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public typealias CreateUIView = () -> UIView?
	public var viewBlock: CreateUIView?
}

public class RFSectionFooterTitleFormItem: RFFormItem {
	public init(title: String? = nil) {
		self.title = title
		super.init()
	}

	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String?

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}
}

public class RFSectionFooterViewFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public typealias CreateUIView = () -> UIView?
	public var viewBlock: CreateUIView?
}

@available(*, unavailable, renamed: "RFSectionFormItem")
typealias SectionFormItem = RFSectionFormItem

@available(*, unavailable, renamed: "RFSectionHeaderTitleFormItem")
typealias SectionHeaderTitleFormItem = RFSectionHeaderTitleFormItem

@available(*, unavailable, renamed: "RFSectionHeaderViewFormItem")
typealias SectionHeaderViewFormItem = RFSectionHeaderViewFormItem

@available(*, unavailable, renamed: "RFSectionFooterTitleFormItem")
typealias SectionFooterTitleFormItem = RFSectionFooterTitleFormItem

@available(*, unavailable, renamed: "RFSectionFooterViewFormItem")
typealias SectionFooterViewFormItem = RFSectionFooterViewFormItem
