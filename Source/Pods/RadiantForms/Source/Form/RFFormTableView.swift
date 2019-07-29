// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFFormTableView: UITableView {
	public init() {
		super.init(frame: CGRect.zero, style: .grouped)
		contentInset = UIEdgeInsets.zero
		scrollIndicatorInsets = UIEdgeInsets.zero

		// Enable "Self Sizing Cells"
		estimatedRowHeight = 44.0
		rowHeight = UITableView.rf_automaticDimension
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    @objc public dynamic var sectionHeader_textLabel_textColor: UIColor?
    @objc public dynamic var sectionFooter_textLabel_textColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        RFSimpleToolbar.configureAppearance(whenContainedInInstancesOf: containerTypes, theme: theme)

        do {
            let appearanceProxy: RFFormTableView = RFFormTableView.appearance(whenContainedInInstancesOf: containerTypes)
            appearanceProxy.sectionHeader_textLabel_textColor = theme.sectionHeader.textLabel_textColor
            appearanceProxy.sectionFooter_textLabel_textColor = theme.sectionFooter.textLabel_textColor
            appearanceProxy.backgroundColor = theme.tableViewBackground.color
            appearanceProxy.separatorColor = theme.tableViewSeparator.color
        }

        do {
            let allContainerTypes: [UIAppearanceContainer.Type] = [RFFormTableView.self] + containerTypes
            let appearanceProxy: UITableViewCell = UITableViewCell.appearance(whenContainedInInstancesOf: allContainerTypes)
            appearanceProxy.backgroundColor = theme.cellBackground.color
        }

        do {
            let allContainerTypes: [UIAppearanceContainer.Type] = [RFFormTableView.self] + containerTypes
            RFAmountCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFButtonCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFDatePickerToggleCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFOptionViewControllerCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFSegmentedControlCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFStepperCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFSwitchCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFTextFieldCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
            RFViewControllerCell.configureAppearance(whenContainedInInstancesOf: allContainerTypes, theme: theme)
        }
    }
}

@available(*, unavailable, renamed: "RFFormTableView")
typealias FormTableView = RFFormTableView
