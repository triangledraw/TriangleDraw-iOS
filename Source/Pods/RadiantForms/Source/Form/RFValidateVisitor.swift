// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

class RFValidateVisitor: RFFormItemVisitor {
	var result = RFValidateResult.valid

	func visit(object: RFTextFieldFormItem) {
		result = object.submitValidateValueText()
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
	func visit(object: RFToggleFormItem) {}
	func visit(object: RFTextViewFormItem) {}
	func visit(object: RFViewControllerFormItem) {}
    func visit(object: RFTextFormItem) {}
}

@available(*, unavailable, renamed: "RFValidateVisitor")
typealias ValidateVisitor = RFValidateVisitor
