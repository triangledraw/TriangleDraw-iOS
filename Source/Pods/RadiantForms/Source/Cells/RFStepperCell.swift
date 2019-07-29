// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFStepperCellModel {
	var title: String = ""
	var value: Int = 0

    var titleFont: RFFont = RFPreferredFontForTextStyle.body
    var valueFont: RFFont = RFPreferredFontForTextStyle.body

	var valueDidChange: (Int) -> Void = { (value: Int) in
		RFLog("value \(value)")
	}
}

public class RFStepperCell: UITableViewCell {
	public let model: RFStepperCellModel
	public let valueLabel = UILabel()
	public let stepperView = UIStepper()
	public var containerView = UIView()

	public init(model: RFStepperCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		selectionStyle = .none
        textLabel?.font = model.titleFont.resolve()
		textLabel?.text = model.title

		valueLabel.font = model.valueFont.resolve()
		valueLabel.textColor = UIColor.gray
		containerView.addSubview(stepperView)
		containerView.addSubview(valueLabel)
		accessoryView = containerView

		stepperView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

		valueLabel.text = "0"
	}

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIAppearance
    
    @objc public dynamic var textLabel_textColor: UIColor?
    @objc public dynamic var valueLabel_textColor: UIColor?
    @objc public dynamic var stepper_tintColor: UIColor?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let appearanceProxy: RFStepperCell = RFStepperCell.appearance(whenContainedInInstancesOf: containerTypes)
        appearanceProxy.textLabel_textColor = theme.stepperCell.textLabel_textColor
        appearanceProxy.valueLabel_textColor = theme.stepperCell.valueLabel_textColor
        appearanceProxy.stepper_tintColor = theme.stepperCell.stepper_tintColor
    }
    
	public override func layoutSubviews() {
		super.layoutSubviews()

		stepperView.sizeToFit()
		valueLabel.sizeToFit()

		let rightPadding: CGFloat = layoutMargins.right
		let valueStepperPadding: CGFloat = 10

		let valueSize = valueLabel.frame.size
		let stepperSize = stepperView.frame.size

		let containerWidth = ceil(valueSize.width + valueStepperPadding + stepperSize.width)
		containerView.frame = CGRect(x: bounds.width - rightPadding - containerWidth, y: 0, width: containerWidth, height: stepperSize.height)

		let valueY: CGFloat = bounds.midY - valueSize.height / 2
		valueLabel.frame = CGRect(x: 0, y: valueY, width: valueSize.width, height: valueSize.height).integral

		let stepperY: CGFloat = bounds.midY - stepperSize.height / 2
		stepperView.frame = CGRect(x: containerWidth - stepperSize.width, y: stepperY, width: stepperSize.width, height: stepperSize.height)
	}

	@objc public func valueChanged() {
		RFLog("value did change")

		let value: Double = stepperView.value
		let intValue: Int = Int(round(value))

		updateValue(intValue)

		model.valueDidChange(intValue)
		setNeedsLayout()
	}

	public func updateValue(_ value: Int) {
		let value: Double = stepperView.value
		let intValue: Int = Int(round(value))

		self.valueLabel.text = "\(intValue)"
	}

	public func setValueWithoutSync(_ value: Int, animated: Bool) {
		RFLog("set value \(value)")

		stepperView.value = Double(value)
		updateValue(value)
	}
}

extension RFStepperCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.textLabel?.textColor = self.textLabel_textColor
        self.valueLabel.textColor = self.valueLabel_textColor
        self.stepperView.tintColor = self.stepper_tintColor
    }
}


@available(*, unavailable, renamed: "RFStepperCell")
typealias StepperCell = RFStepperCell

@available(*, unavailable, renamed: "RFStepperCellModel")
typealias StepperCellModel = RFStepperCellModel
