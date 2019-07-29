// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFSwitchCellModel {
	var title: String = ""

    var titleFont: RFFont = RFPreferredFontForTextStyle.body

	var valueDidChange: (Bool) -> Void = { (value: Bool) in
		RFLog("value \(value)")
	}
}

public class RFSwitchCell: UITableViewCell {
	public let model: RFSwitchCellModel
	public let switchView: UISwitch

	public init(model: RFSwitchCellModel) {
		self.model = model
		self.switchView = UISwitch()
		super.init(style: .default, reuseIdentifier: nil)
		selectionStyle = .none
        textLabel?.font = model.titleFont.resolve()
		textLabel?.text = model.title

		switchView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
		accessoryView = switchView
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    // MARK: - UIAppearance
    
    @objc public dynamic var textLabel_textColor: UIColor?
    @objc public dynamic var switch_onTintColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let appearanceProxy: RFSwitchCell = RFSwitchCell.appearance(whenContainedInInstancesOf: containerTypes)
        appearanceProxy.textLabel_textColor = theme.switchCell.textLabel_textColor
        appearanceProxy.switch_onTintColor = theme.switchCell.switch_onTintColor
    }
    
	@objc public func valueChanged() {
		RFLog("value did change")
		model.valueDidChange(switchView.isOn)
	}

	public func setValueWithoutSync(_ value: Bool, animated: Bool) {
		RFLog("set value \(value), animated \(animated)")
		switchView.setOn(value, animated: animated)
	}
}

extension RFSwitchCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.textLabel?.textColor = self.textLabel_textColor
        self.switchView.onTintColor = self.switch_onTintColor
    }
}


@available(*, unavailable, renamed: "RFSwitchCell")
typealias SwitchCell = RFSwitchCell

@available(*, unavailable, renamed: "RFSwitchCellModel")
typealias SwitchCellModel = RFSwitchCellModel
