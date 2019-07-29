// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFFormItemVisitor {
    func visit(object: RFAmountFormItem)
	func visit(object: RFAttributedTextFormItem)
	func visit(object: RFButtonFormItem)
	func visit(object: RFCustomFormItem)
	func visit(object: RFDatePickerFormItem)
	func visit(object: RFMetaFormItem)
	func visit(object: RFOptionPickerFormItem)
	func visit(object: RFOptionRowFormItem)
	func visit(object: RFPickerViewFormItem)
	func visit(object: RFPrecisionSliderFormItem)
	func visit(object: RFSectionFooterTitleFormItem)
	func visit(object: RFSectionFooterViewFormItem)
	func visit(object: RFSectionFormItem)
	func visit(object: RFSectionHeaderTitleFormItem)
	func visit(object: RFSectionHeaderViewFormItem)
	func visit(object: RFSegmentedControlFormItem)
	func visit(object: RFSliderFormItem)
	func visit(object: RFStaticTextFormItem)
	func visit(object: RFStepperFormItem)
	func visit(object: RFSwitchFormItem)
	func visit(object: RFTextFieldFormItem)
	func visit(object: RFTextViewFormItem)
	func visit(object: RFViewControllerFormItem)
}

open class RFFormItem {

	public init() {
	}

	func accept(visitor: RFFormItemVisitor) {}
    
    public var isHidden: Bool = false

	// For serialization to json purposes, eg. "firstName"
	public var elementIdentifier: String?

	@discardableResult
	public func elementIdentifier(_ elementIdentifier: String?) -> Self {
		self.elementIdentifier = elementIdentifier
		return self
	}

	// For styling purposes, eg. "bottomRowInFirstSection"
	public var styleIdentifier: String?

	@discardableResult
	public func styleIdentifier(_ styleIdentifier: String?) -> Self {
		self.styleIdentifier = styleIdentifier
		return self
	}

	// For styling purposes, eg. "leftAlignedGroup0"
	public var styleClass: String?

	@discardableResult
	public func styleClass(_ styleClass: String?) -> Self {
		self.styleClass = styleClass
		return self
	}
}


@available(*, unavailable, renamed: "RFFormItemVisitor")
typealias FormItemVisitor = RFFormItemVisitor

@available(*, unavailable, renamed: "RFFormItem")
typealias FormItem = RFFormItem
