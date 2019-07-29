// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

class RFObtainTitleWidth: RFFormItemVisitor {
	var width: CGFloat = 0

	func visit(object: RFTextFieldFormItem) {
		width = object.obtainTitleWidth()
	}

    func visit(object: RFAmountFormItem) {}
	func visit(object: RFAttributedTextFormItem) {}
	func visit(object: RFButtonFormItem) {}
	func visit(object: RFCustomFormItem) {}
	func visit(object: RFDatePickerFormItem) {}
	func visit(object: RFMetaFormItem) {}
	func visit(object: RFOptionPickerFormItem) {}
	func visit(object: RFOptionRowFormItem) {}
	func visit(object: RFPickerViewFormItem) {}
	func visit(object: RFPrecisionSliderFormItem) {}
	func visit(object: RFSectionFooterTitleFormItem) {}
	func visit(object: RFSectionFooterViewFormItem) {}
	func visit(object: RFSectionFormItem) {}
	func visit(object: RFSectionHeaderTitleFormItem) {}
	func visit(object: RFSectionHeaderViewFormItem) {}
	func visit(object: RFSegmentedControlFormItem) {}
	func visit(object: RFSliderFormItem) {}
	func visit(object: RFStaticTextFormItem) {}
	func visit(object: RFStepperFormItem) {}
	func visit(object: RFSwitchFormItem) {}
	func visit(object: RFTextViewFormItem) {}
	func visit(object: RFViewControllerFormItem) {}
}

class RFAssignTitleWidth: RFFormItemVisitor {
	fileprivate var width: CGFloat = 0

	init(width: CGFloat) {
		self.width = width
	}

	func visit(object: RFTextFieldFormItem) {
		object.assignTitleWidth(width)
	}

    func visit(object: RFAmountFormItem) {}
	func visit(object: RFAttributedTextFormItem) {}
	func visit(object: RFButtonFormItem) {}
	func visit(object: RFCustomFormItem) {}
	func visit(object: RFDatePickerFormItem) {}
	func visit(object: RFMetaFormItem) {}
	func visit(object: RFOptionPickerFormItem) {}
	func visit(object: RFOptionRowFormItem) {}
	func visit(object: RFPickerViewFormItem) {}
	func visit(object: RFPrecisionSliderFormItem) {}
	func visit(object: RFSectionFooterTitleFormItem) {}
	func visit(object: RFSectionFooterViewFormItem) {}
	func visit(object: RFSectionFormItem) {}
	func visit(object: RFSectionHeaderTitleFormItem) {}
	func visit(object: RFSectionHeaderViewFormItem) {}
	func visit(object: RFSegmentedControlFormItem) {}
	func visit(object: RFSliderFormItem) {}
	func visit(object: RFStaticTextFormItem) {}
	func visit(object: RFStepperFormItem) {}
	func visit(object: RFSwitchFormItem) {}
	func visit(object: RFTextViewFormItem) {}
	func visit(object: RFViewControllerFormItem) {}
}

@available(*, unavailable, renamed: "RFObtainTitleWidth")
typealias ObtainTitleWidth = RFObtainTitleWidth

@available(*, unavailable, renamed: "RFAssignTitleWidth")
typealias AssignTitleWidth = RFAssignTitleWidth
