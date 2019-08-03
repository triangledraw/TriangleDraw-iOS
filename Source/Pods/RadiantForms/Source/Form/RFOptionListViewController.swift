// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

class RFOptionListViewController: RFFormViewController, RFSelectOptionDelegate {
	typealias SelectOptionHandler = (RFOptionRowModel) -> Void
	let optionField: RFOptionPickerFormItem
	let selectOptionHandler: SelectOptionHandler

	init(optionField: RFOptionPickerFormItem, selectOptionHandler: @escaping SelectOptionHandler) {
		self.optionField = optionField
		self.selectOptionHandler = selectOptionHandler
		super.init()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override func populate(_ builder: RFFormBuilder) {
		RFLog("preselect option \(String(describing: optionField.selected?.title))")
		builder.navigationTitle = optionField.title
		for optionRow: RFOptionRowModel in optionField.options {
			let option = RFOptionRowFormItem()
			option.title = optionRow.title
			option.context = optionRow
			option.selected = (optionRow === optionField.selected)
			builder.append(option)
		}
	}

	func form_willSelectOption(option: RFOptionRowFormItem) {
		guard let selected = option.context as? RFOptionRowModel else {
			fatalError("Expected RFOptionRowModel when selecting option \(option.title)")
		}

		RFLog("select option \(option.title)")
		selectOptionHandler(selected)
	}
}


@available(*, unavailable, renamed: "RFOptionListViewController")
typealias OptionListViewController = RFOptionListViewController
