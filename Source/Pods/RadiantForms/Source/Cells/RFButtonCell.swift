// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFButtonCellModel {
	var title: String = ""
    var titleFont: RFFont = RFPreferredFontForTextStyle.body

	var action: () -> Void = {
		RFLog("action")
	}

}

public class RFButtonCell: UITableViewCell {
	public let model: RFButtonCellModel

	public init(model: RFButtonCellModel) {
		self.model = model
		super.init(style: .default, reuseIdentifier: nil)
		loadWithModel(model)
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func loadWithModel(_ model: RFButtonCellModel) {
        textLabel?.font = model.titleFont.resolve()
		textLabel?.text = model.title
		textLabel?.textAlignment = NSTextAlignment.center
	}
    
    @objc public dynamic var textLabel_textColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let appearanceProxy: RFButtonCell = RFButtonCell.appearance(whenContainedInInstancesOf: containerTypes)
        appearanceProxy.textLabel_textColor = theme.buttonCell.textLabel_textColor
    }
}

extension RFButtonCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.textLabel?.textColor = self.textLabel_textColor
    }
}

extension RFButtonCell: RFSelectRowDelegate {
	public func form_didSelectRow(indexPath: IndexPath, tableView: UITableView) {
		// hide keyboard when the user taps this kind of row
		tableView.rf_firstResponder()?.resignFirstResponder()

		model.action()

		tableView.deselectRow(at: indexPath, animated: true)
	}
}


@available(*, unavailable, renamed: "RFButtonCell")
typealias ButtonCell = RFButtonCell

@available(*, unavailable, renamed: "RFButtonCellModel")
typealias ButtonCellModel = RFButtonCellModel
