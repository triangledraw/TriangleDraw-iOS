// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFOptionViewControllerCellModel {
	var title: String = ""
    var titleFont: RFFont = RFPreferredFontForTextStyle.body
	var placeholder: String = ""
	var optionField: RFOptionPickerFormItem?
	var selectedOptionRow: RFOptionRowModel?

	var valueDidChange: (RFOptionRowModel?) -> Void = { (value: RFOptionRowModel?) in
		RFLog("value \(String(describing: value))")
	}
}

public class RFOptionViewControllerCell: UITableViewCell, RFSelectRowDelegate {
	fileprivate let model: RFOptionViewControllerCellModel
	fileprivate var selectedOptionRow: RFOptionRowModel?
	fileprivate weak var parentViewController: UIViewController?

	public init(parentViewController: UIViewController, model: RFOptionViewControllerCellModel) {
		self.parentViewController = parentViewController
		self.model = model
		self.selectedOptionRow = model.selectedOptionRow
		super.init(style: .value1, reuseIdentifier: nil)
		accessoryType = .disclosureIndicator
		textLabel?.text = model.title
        textLabel?.font = model.titleFont.resolve()
		updateValue()
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	fileprivate func humanReadableValue() -> String? {
		if let option = selectedOptionRow {
			return option.title
		} else {
			return model.placeholder
		}
	}

	fileprivate func updateValue() {
		let s = humanReadableValue()
		RFLog("update value \(String(describing: s))")
		detailTextLabel?.text = s
	}

	public func setSelectedOptionRowWithoutPropagation(_ option: RFOptionRowModel?) {
		RFLog("set selected option: \(String(describing: option?.title)) \(String(describing: option?.identifier))")

		selectedOptionRow = option
		updateValue()
	}

	fileprivate func viaOptionList_userPickedOption(_ option: RFOptionRowModel) {
		RFLog("user picked option: \(option.title) \(option.identifier)")

		if selectedOptionRow === option {
			RFLog("no change")
			return
		}

		selectedOptionRow = option
		updateValue()
		model.valueDidChange(option)
	}

	public func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
		RFLog("will invoke")

		guard let vc: UIViewController = parentViewController else {
			RFLog("Expected a parent view controller")
			return
		}
		guard let nc: UINavigationController = vc.navigationController else {
			RFLog("Expected parent view controller to have a navigation controller")
			return
		}
		guard let optionField = model.optionField else {
			RFLog("Expected model to have an optionField")
			return
		}

		// hide keyboard when the user taps this kind of row
		tableView.rf_firstResponder()?.resignFirstResponder()

		let childViewController = RFOptionListViewController(optionField: optionField) { [weak self] (selected: RFOptionRowModel) in
			self?.viaOptionList_userPickedOption(selected)
			nc.popViewController(animated: true)
		}
		nc.pushViewController(childViewController, animated: true)

		RFLog("did invoke")
	}

    // MARK: - UIAppearance
    
    @objc public dynamic var textLabel_textColor: UIColor?
    @objc public dynamic var detailTextLabel_textColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let appearanceProxy: RFOptionViewControllerCell = RFOptionViewControllerCell.appearance(whenContainedInInstancesOf: containerTypes)
        appearanceProxy.textLabel_textColor = theme.optionViewControllerCell.textLabel_textColor
        appearanceProxy.detailTextLabel_textColor = theme.optionViewControllerCell.detailTextLabel_textColor
    }
}

extension RFOptionViewControllerCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.textLabel?.textColor = self.textLabel_textColor
        self.detailTextLabel?.textColor = self.detailTextLabel_textColor
    }
}


@available(*, unavailable, renamed: "RFOptionViewControllerCell")
typealias OptionViewControllerCell = RFOptionViewControllerCell

@available(*, unavailable, renamed: "RFOptionViewControllerCellModel")
typealias OptionViewControllerCellModel = RFOptionViewControllerCellModel
