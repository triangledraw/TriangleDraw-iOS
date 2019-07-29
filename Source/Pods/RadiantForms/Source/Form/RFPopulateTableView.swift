// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

protocol RFWillPopCommandProtocol {
	func execute(_ context: RFViewControllerFormItemPopContext)
}

class RFWillPopCustomViewController: RFWillPopCommandProtocol {
	let object: AnyObject
	init(object: AnyObject) {
		self.object = object
	}

	func execute(_ context: RFViewControllerFormItemPopContext) {
		if let vc = object as? RFViewControllerFormItem {
			vc.willPopViewController?(context)
			return
		}
	}
}

class RFWillPopOptionViewController: RFWillPopCommandProtocol {
	let object: RFViewControllerFormItem
	init(object: RFViewControllerFormItem) {
		self.object = object
	}

	func execute(_ context: RFViewControllerFormItemPopContext) {
		object.willPopViewController?(context)
	}
}

struct RFPopulateTableViewModel {
	var viewController: UIViewController
	var toolbarMode: RFToolbarMode
    var fontStrategy: RFFontStrategy
}

class RFPopulateTableView: RFFormItemVisitor {
	let model: RFPopulateTableViewModel

	var cells: RFTableViewCellArray = RFTableViewCellArray.createEmpty()
	var sections = [RFTableViewSection]()
	var header = RFTableViewSectionPart.systemDefault
	var footer = RFTableViewSectionPart.systemDefault

	enum LastItemType {
		case beginning
		case header
		case sectionEnd
		case item
	}
	var lastItemType = LastItemType.beginning

	init(model: RFPopulateTableViewModel) {
		self.model = model
	}

	func installZeroHeightHeader() {
		header = .none
		lastItemType = .sectionEnd
	}

	func closeSection() {
		cells.reloadVisibleItems()
		let section = RFTableViewSection(cells: cells, header: header, footer: footer)
		sections.append(section)

		cells = RFTableViewCellArray.createEmpty()
		header = RFTableViewSectionPart.systemDefault
		footer = RFTableViewSectionPart.systemDefault
	}

	func closeLastSection() {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}
		lastItemType = .sectionEnd
	}

    // MARK: RFAmountFormItem
    
    func visit(object: RFAmountFormItem) {
        let numberFormatter: NumberFormatter = object.numberFormatter ?? RFAmountCell_NumberFormatter(fractionDigits: object.fractionDigits)
        assert(numberFormatter.minimumFractionDigits == object.fractionDigits)
        assert(numberFormatter.maximumFractionDigits == object.fractionDigits)
        
        var model = RFAmountCellModel()
        model.numberFormatter = numberFormatter
        model.toolbarMode = self.model.toolbarMode
        model.title = object.title
        model.placeholder = object.placeholder
        model.unitSuffix = object.unitSuffix
        model.maxIntegerDigits = object.maxIntegerDigits
        model.fractionDigits = object.fractionDigits
        model.returnKeyType = object.returnKeyType
        model.titleFont = self.model.fontStrategy.titleFont()
        model.valueFont = self.model.fontStrategy.valueFont()
        model.model = object

        weak var weakObject = object
        model.valueDidChange = { (value: RFAmountValue) in
            RFLog("value \(value)")
            weakObject?.valueDidChange(value)
            return
        }

        let cell = RFAmountCell(model: model)
        cell.setValueWithoutSync(object.value)
        cells.append(cell)
        lastItemType = .item
        
        weak var weakCell = cell
        object.syncCellWithValue = { (value: RFAmountValue) in
            RFLog("sync value \(value)")
            weakCell?.setValueWithoutSync(value)
            return
        }
        
        object.obtainTitleWidth = {
            if let cell = weakCell {
                let size = cell.titleLabel.intrinsicContentSize
                return size.width
            }
            return 0
        }
        
        object.assignTitleWidth = { (width: CGFloat) in
            if let cell = weakCell {
                cell.titleWidthMode = RFAmountCell.TitleWidthMode.assign(width: width)
                cell.setNeedsUpdateConstraints()
            }
        }
    }

    // MARK: RFAttributedTextFormItem

	func visit(object: RFAttributedTextFormItem) {
		var model = RFAttributedTextCellModel()
		model.titleAttributedText = object.title
		model.valueAttributedText = object.value
		let cell = RFAttributedTextCell(model: model)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: NSAttributedString?) in
			RFLog("sync value \(String(describing: value))")
			if let c = weakCell {
				var m = RFAttributedTextCellModel()
				m.titleAttributedText = c.model.titleAttributedText
				m.valueAttributedText = value
				c.model = m
				c.loadWithModel(m)
			}
		}
	}

	// MARK: RFButtonFormItem

	func visit(object: RFButtonFormItem) {
        var model = RFButtonCellModel()
		model.title = object.title
		model.action = object.action
        model.titleFont = self.model.fontStrategy.titleFont()
        let cell = RFButtonCell(model: model)
		cells.append(cell)
		lastItemType = .item
	}

	// MARK: RFCustomFormItem

	func visit(object: RFCustomFormItem) {
		let context = RFCustomFormItem.Context(
			viewController: model.viewController
		)
		do {
            let cell: UITableViewCell = try object.createCell(context)
            object.latestCreatedCell = cell
			cells.append(cell)
			lastItemType = .item
		} catch {
			print("ERROR: Could not create cell for custom form item: \(error)")
            object.latestCreatedCell = nil

			var model = RFStaticTextCellModel()
			model.title = "RFCustomFormItem"
			model.value = "Exception"
			let cell = RFStaticTextCell(model: model)
			cells.append(cell)
			lastItemType = .item
		}
	}

	// MARK: RFDatePickerFormItem

	func visit(object: RFDatePickerFormItem) {
		let model = RFDatePickerCellModel()
		model.title = object.title
		model.datePickerMode = mapDatePickerMode(object.datePickerMode)
		model.locale = object.locale
		model.minimumDate = object.minimumDate
		model.maximumDate = object.maximumDate
		model.minuteInterval = object.minuteInterval
		model.date = object.value
        model.titleFont = self.model.fontStrategy.titleFont()
        model.valueFont = self.model.fontStrategy.valueFont()

		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}

		let cell = RFDatePickerToggleCell(model: model)
		let cellExpanded = RFDatePickerExpandedCell()

		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		cellExpanded.configure(model)

		weak var weakCell = cell
		object.syncCellWithValue = { (date: Date, animated: Bool) in
			RFLog("sync date \(date)")
			weakCell?.setDateWithoutSync(date, animated: animated)
		}

		weak var weakObject = object
		model.valueDidChange = { (date: Date) in
			RFLog("value did change \(date)")
			weakObject?.valueDidChange(date)
		}
	}

	func mapDatePickerMode(_ mode: RFDatePickerFormItemMode) -> UIDatePicker.Mode {
		switch mode {
		case .date: return UIDatePicker.Mode.date
		case .time: return UIDatePicker.Mode.time
		case .dateAndTime: return UIDatePicker.Mode.dateAndTime
		}
	}

	// MARK: RFMetaFormItem

	func visit(object: RFMetaFormItem) {
		// this item is not visual
	}

	// MARK: RFOptionPickerFormItem

	func visit(object: RFOptionPickerFormItem) {
		var model = RFOptionViewControllerCellModel()
		model.title = object.title
        model.titleFont = self.model.fontStrategy.titleFont()
		model.placeholder = object.placeholder
		model.optionField = object
		model.selectedOptionRow = object.selected

		weak var weakObject = object
		model.valueDidChange = { (value: RFOptionRowModel?) in
			RFLog("propagate from cell to model. value \(String(describing: value))")
			weakObject?.innerSelected = value
			weakObject?.valueDidChange(value)
		}

		let cell = RFOptionViewControllerCell(
			parentViewController: self.model.viewController,
			model: model
		)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (selected: RFOptionRowModel?) in
			RFLog("propagate from model to cell. option: \(String(describing: selected?.title))")
			weakCell?.setSelectedOptionRowWithoutPropagation(selected)
		}
	}

	// MARK: RFOptionRowFormItem

	func visit(object: RFOptionRowFormItem) {
		weak var weakViewController = self.model.viewController
		let cell = RFOptionCell(model: object) {
			RFLog("did select option")
			if let vc = weakViewController {
				if let x = vc as? RFSelectOptionDelegate {
					x.form_willSelectOption(option: object)
				}
			}
		}
		cells.append(cell)
		lastItemType = .item
	}

	// MARK: RFPrecisionSliderFormItem

	func visit(object: RFPrecisionSliderFormItem) {
		let model = RFPrecisionSliderCellModel()
		model.decimalPlaces = object.decimalPlaces
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
		model.value = object.value
		model.title = object.title
		model.initialZoom = object.initialZoom
		model.zoomUI = object.zoomUI
		model.collapseWhenResigning = object.collapseWhenResigning

		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}

		let cell = RFPrecisionSliderToggleCell(model: model)
		let cellExpanded = RFPrecisionSliderExpandedCell()

		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		weak var weakObject = object
		model.valueDidChange = { (changeModel: RFPrecisionSliderCellModel.SliderDidChangeModel) in
			RFLog("value did change \(changeModel.value)")
			let model = RFPrecisionSliderFormItem.SliderDidChangeModel(
				value: changeModel.value,
				valueUpdated: changeModel.valueUpdated,
				zoom: changeModel.zoom,
				zoomUpdated: changeModel.zoomUpdated
			)
			weakObject?.sliderDidChange(model)
		}

		weak var weakCell = cell
		weak var weakCellExpanded = cellExpanded
		object.syncCellWithValue = { (value: Int) in
			RFLog("sync value \(value)")
			if let model = weakCell?.model {
				model.value = value
			}
			weakCell?.reloadValueLabel()
			weakCellExpanded?.setValueWithoutSync(value)
		}
	}

	// MARK: RFSectionFooterTitleFormItem

	func visit(object: RFSectionFooterTitleFormItem) {
		if let title = object.title {
			footer = RFTableViewSectionPart.titleString(string: title)
		} else {
			footer = RFTableViewSectionPart.systemDefault
		}
		closeSection()
		lastItemType = .sectionEnd
	}

	// MARK: RFSectionFooterViewFormItem

	func visit(object: RFSectionFooterViewFormItem) {
		if let view: UIView = object.viewBlock?() {
			footer = RFTableViewSectionPart.titleView(view: view)
		} else {
			footer = RFTableViewSectionPart.systemDefault
		}
		closeSection()
		lastItemType = .sectionEnd
	}

	// MARK: RFSectionFormItem

	func visit(object: RFSectionFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}
		lastItemType = .sectionEnd
	}

	// MARK: RFSectionHeaderTitleFormItem

	func visit(object: RFSectionHeaderTitleFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}

		if let title = object.title {
			header = RFTableViewSectionPart.titleString(string: title)
		} else {
			header = RFTableViewSectionPart.systemDefault
		}
		lastItemType = .header
	}

	// MARK: RFSectionHeaderViewFormItem

	func visit(object: RFSectionHeaderViewFormItem) {
		switch lastItemType {
		case .beginning:
			break
		case .sectionEnd:
			break
		case .header:
			closeSection()
		case .item:
			closeSection()
		}

		if let view: UIView = object.viewBlock?() {
			header = RFTableViewSectionPart.titleView(view: view)
		} else {
			header = RFTableViewSectionPart.systemDefault
		}
		lastItemType = .header
	}

	// MARK: RFSegmentedControlFormItem

	func visit(object: RFSegmentedControlFormItem) {
		var model = RFSegmentedControlCellModel()
		model.title = object.title
		model.items = object.items
		model.value = object.selected
        model.titleFont = self.model.fontStrategy.titleFont()

		weak var weakObject = object
		model.valueDidChange = { (value: Int) in
			RFLog("value did change \(value)")
			weakObject?.valueDidChange(value)
			return
		}

		let cell = RFSegmentedControlCell(model: model)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Int) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}
	}

	// MARK: RFSliderFormItem

	func visit(object: RFSliderFormItem) {
		var model = RFSliderCellModel()
		model.minimumValue = object.minimumValue
		model.maximumValue = object.maximumValue
		model.value = object.value

		weak var weakObject = object
		model.valueDidChange = { (value: Float) in
			RFLog("value did change \(value)")
			weakObject?.sliderDidChange(value)
			return
		}

		let cell = RFSliderCell(model: model)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Float, animated: Bool) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: RFStaticTextFormItem

	func visit(object: RFStaticTextFormItem) {
		var model = RFStaticTextCellModel()
		model.title = object.title
		model.value = object.value
		let cell = RFStaticTextCell(model: model)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			RFLog("sync value \(value)")
			if let c = weakCell {
				var m = RFStaticTextCellModel()
				m.title = c.model.title
				m.value = value
				c.model = m
				c.loadWithModel(m)
			}
		}
	}

	// MARK: RFStepperFormItem

	func visit(object: RFStepperFormItem) {
		var model = RFStepperCellModel()
		model.title = object.title
		model.value = object.value
        model.titleFont = self.model.fontStrategy.titleFont()
        model.valueFont = self.model.fontStrategy.valueFont()

		weak var weakObject = object
		model.valueDidChange = { (value: Int) in
			RFLog("value \(value)")
			weakObject?.innerValue = value
			return
		}

		let cell = RFStepperCell(model: model)
		cells.append(cell)
		lastItemType = .item

		RFLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: true)
		RFLog("did assign value \(object.value)")

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Int, animated: Bool) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: RFSwitchFormItem

	func visit(object: RFSwitchFormItem) {
		var model = RFSwitchCellModel()
		model.title = object.title
        model.titleFont = self.model.fontStrategy.titleFont()

		weak var weakObject = object
		model.valueDidChange = { (value: Bool) in
			RFLog("value did change \(value)")
			weakObject?.switchDidChange(value)
			return
		}

		let cell = RFSwitchCell(model: model)
		cells.append(cell)
		lastItemType = .item

		RFLog("will assign value \(object.value)")
		cell.setValueWithoutSync(object.value, animated: false)
		RFLog("did assign value \(object.value)")

		weak var weakCell = cell
		object.syncCellWithValue = { (value: Bool, animated: Bool) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
			return
		}
	}

	// MARK: RFTextFieldFormItem

	func visit(object: RFTextFieldFormItem) {
		var model = RFTextFieldCellModel()
		model.toolbarMode = self.model.toolbarMode
		model.title = object.title
		model.placeholder = object.placeholder
		model.keyboardType = object.keyboardType
		model.returnKeyType = object.returnKeyType
		model.autocorrectionType = object.autocorrectionType
		model.autocapitalizationType = object.autocapitalizationType
		model.spellCheckingType = object.spellCheckingType
		model.secureTextEntry = object.secureTextEntry
        model.titleFont = self.model.fontStrategy.titleFont()
        model.valueFont = self.model.fontStrategy.valueFont()
		model.model = object
		weak var weakObject = object
		model.valueDidChange = { (value: String) in
			RFLog("value \(value)")
			weakObject?.textDidChange(value)
			return
		}
        model.didEndEditing = { (value: String) in
            RFLog("value \(value)")
            weakObject?.editingEnd(value)
            return
        }
		let cell = RFTextFieldCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}

		object.reloadPersistentValidationState = {
			weakCell?.reloadPersistentValidationState()
			return
		}

		object.obtainTitleWidth = {
			if let cell = weakCell {
				let size = cell.titleLabel.intrinsicContentSize
				return size.width
			}
			return 0
		}

		object.assignTitleWidth = { (width: CGFloat) in
			if let cell = weakCell {
				cell.titleWidthMode = RFTextFieldCell.TitleWidthMode.assign(width: width)
				cell.setNeedsUpdateConstraints()
			}
		}
	}

	// MARK: RFTextViewFormItem

	func visit(object: RFTextViewFormItem) {
		var model = RFTextViewCellModel()
		model.toolbarMode = self.model.toolbarMode
		model.title = object.title
		model.placeholder = object.placeholder
        model.titleFont = self.model.fontStrategy.titleFont()
        model.valueFont = self.model.fontStrategy.valueFont()
		weak var weakObject = object
		model.valueDidChange = { (value: String) in
			RFLog("value \(value)")
			weakObject?.innerValue = value
			return
		}
		let cell = RFTextViewCell(model: model)
		cell.setValueWithoutSync(object.value)
		cells.append(cell)
		lastItemType = .item

		weak var weakCell = cell
		object.syncCellWithValue = { (value: String) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value)
			return
		}
	}

	// MARK: RFViewControllerFormItem

	func visit(object: RFViewControllerFormItem) {
		let model = RFViewControllerCellModel(title: object.title, placeholder: object.placeholder)
        model.titleFont = self.model.fontStrategy.titleFont()
		let willPopViewController = RFWillPopCustomViewController(object: object)

		weak var weakViewController = self.model.viewController
		let cell = RFViewControllerCell(model: model) { (cell: RFViewControllerCell, _: RFViewControllerCellModel) in
			RFLog("push")
			if let vc = weakViewController {
				let dismissCommand = RFPopulateTableView.prepareDismissCommand(willPopViewController, parentViewController: vc, cell: cell)
				if let childViewController = object.createViewController?(dismissCommand) {
					vc.navigationController?.pushViewController(childViewController, animated: true)
				}
			}
		}
		cells.append(cell)
		lastItemType = .item
	}

	class func prepareDismissCommand(_ willPopCommand: RFWillPopCommandProtocol, parentViewController: UIViewController, cell: RFViewControllerCell) -> RFCommandProtocol {
		weak var weakViewController = parentViewController
		let command = RFCommandBlock { (childViewController: UIViewController, returnObject: AnyObject?) in
			RFLog("pop: \(String(describing: returnObject))")
			if let vc = weakViewController {
				let context = RFViewControllerFormItemPopContext(parentViewController: vc, childViewController: childViewController, cell: cell, returnedObject: returnObject)
				willPopCommand.execute(context)
				_ = vc.navigationController?.popViewController(animated: true)
			}
		}
		return command
	}

	// MARK: RFPickerViewFormItem

	func visit(object: RFPickerViewFormItem) {
		let model = RFPickerViewCellModel()
		model.title = object.title
		model.value = object.value
		model.titles = object.pickerTitles
		model.humanReadableValueSeparator = object.humanReadableValueSeparator

		switch object.behavior {
		case .collapsed, .expanded:
			model.expandCollapseWhenSelectingRow = true
			model.selectionStyle = .default
		case .expandedAlways:
			model.expandCollapseWhenSelectingRow = false
			model.selectionStyle = .none
		}

		let cell = RFPickerViewToggleCell(model: model)
		let cellExpanded = RFPickerViewExpandedCell()

		cells.append(cell)
		switch object.behavior {
		case .collapsed:
			cells.appendHidden(cellExpanded)
		case .expanded, .expandedAlways:
			cells.append(cellExpanded)
		}
		lastItemType = .item

		cellExpanded.collapsedCell = cell
		cell.expandedCell = cellExpanded

		cellExpanded.configure(model)

		weak var weakCell = cell
		object.syncCellWithValue = { (value: [Int], animated: Bool) in
			RFLog("sync value \(value)")
			weakCell?.setValueWithoutSync(value, animated: animated)
		}

		weak var weakObject = object
		model.valueDidChange = { (selectedRows: [Int]) in
			RFLog("value did change \(selectedRows)")
			weakObject?.valueDidChange(selectedRows)
		}
	}
}


@available(*, unavailable, renamed: "RFWillPopCommandProtocol")
typealias WillPopCommandProtocol = RFWillPopCommandProtocol

@available(*, unavailable, renamed: "RFWillPopCustomViewController")
typealias WillPopCustomViewController = RFWillPopCustomViewController

@available(*, unavailable, renamed: "RFWillPopOptionViewController")
typealias WillPopOptionViewController = RFWillPopOptionViewController

@available(*, unavailable, renamed: "RFPopulateTableViewModel")
typealias PopulateTableViewModel = RFPopulateTableViewModel

@available(*, unavailable, renamed: "RFPopulateTableView")
typealias PopulateTableView = RFPopulateTableView
