// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFTextCellModel {
    var text: String = ""
}

/// Cell for displaying multiline text spanning the full width.
///
/// The cell is not selectable.
public class RFTextCell: UITableViewCell {
    public init(model: RFTextCellModel) {
        super.init(style: .default, reuseIdentifier: nil)
        textLabel?.numberOfLines = 0
        selectionStyle = .none
        loadWithModel(model)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadWithModel(_ model: RFTextCellModel) {
        textLabel?.text = model.text
    }

    // MARK: - UIAppearance
    
    @objc public dynamic var textLabel_textColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let appearanceProxy: RFTextCell = RFTextCell.appearance(whenContainedInInstancesOf: containerTypes)
        appearanceProxy.textLabel_textColor = theme.textCell.textLabel_textColor
    }
}

extension RFTextCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.textLabel?.textColor = self.textLabel_textColor
    }
}

