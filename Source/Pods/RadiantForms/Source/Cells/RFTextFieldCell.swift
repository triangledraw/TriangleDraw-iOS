// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFTextFieldCellModel {
	var title: String = ""
	var toolbarMode: RFToolbarMode = .simple
	var placeholder: String = ""
	var keyboardType: UIKeyboardType = .default
	var returnKeyType: UIReturnKeyType = .default
	var autocorrectionType: UITextAutocorrectionType = .no
	var autocapitalizationType: UITextAutocapitalizationType = .none
	var spellCheckingType: UITextSpellCheckingType = .no
	var secureTextEntry = false
    var titleFont: RFFont = RFPreferredFontForTextStyle.body
    var valueFont: RFFont = RFPreferredFontForTextStyle.body
    var errorLabelFont: RFFont = RFPreferredFontForTextStyle.caption2
	var model: RFTextFieldFormItem! = nil

	var valueDidChange: (String) -> Void = { (value: String) in
		RFLog("value \(value)")
	}
    
    var didEndEditing: (String) -> Void = { (value: String) in
        RFLog("value \(value)")
    }
}

public class RFTextFieldCell: UITableViewCell {
	public let model: RFTextFieldCellModel
	public let titleLabel = UILabel()
	public let textField = RFTextFieldCell_TextField()
	public let errorLabel = UILabel()

	public var state: RFTextFieldCell_State = .noMessage

	public init(model: RFTextFieldCellModel) {
		self.model = model
		super.init(style: .default, reuseIdentifier: nil)

		self.addGestureRecognizer(tapGestureRecognizer)

		selectionStyle = .none

		titleLabel.font = model.titleFont.resolve()
		textField.font  = model.valueFont.resolve()
		errorLabel.font = model.errorLabelFont.resolve()

		errorLabel.textColor = UIColor.black
		errorLabel.numberOfLines = 0

		textField.configure()
		textField.delegate = self

		textField.addTarget(self, action: #selector(RFTextFieldCell.valueDidChange), for: UIControl.Event.editingChanged)

		contentView.addSubview(titleLabel)
		contentView.addSubview(textField)
		contentView.addSubview(errorLabel)

		titleLabel.text = model.title
		textField.placeholder = model.placeholder
		textField.autocapitalizationType = model.autocapitalizationType
		textField.autocorrectionType = model.autocorrectionType
		textField.keyboardType = model.keyboardType
		textField.returnKeyType = model.returnKeyType
		textField.spellCheckingType = model.spellCheckingType
		textField.isSecureTextEntry = model.secureTextEntry

		if self.model.toolbarMode == .simple {
			textField.inputAccessoryView = toolbar
		}

		updateErrorLabel(model.model.liveValidateValueText())

//        titleLabel.backgroundColor = UIColor.blue
//        textField.backgroundColor = UIColor.green
//        errorLabel.backgroundColor = UIColor.yellow
		clipsToBounds = true
	}

	public required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

    // MARK: - UIAppearance
    
    @objc public dynamic var titleLabel_textColor: UIColor?
    @objc public dynamic var textField_placeholderColor: UIColor?
    @objc public dynamic var textField_appearanceStrategy: RFTextFieldAppearanceStrategy?
    @objc public dynamic var errorLabel_textColor: UIColor?

    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        do {
            let appearanceProxy: RFTextFieldCell = RFTextFieldCell.appearance(whenContainedInInstancesOf: containerTypes)
            appearanceProxy.titleLabel_textColor = theme.textFieldCell.titleLabel_textColor
            appearanceProxy.textField_placeholderColor = theme.textFieldCell.textField_placeholderColor
            appearanceProxy.textField_appearanceStrategy = theme.textFieldCell.textField_appearanceStrategy
            appearanceProxy.errorLabel_textColor = theme.textFieldCell.errorLabel_textColor
        }
        
        do {
            let allContainerTypes: [UIAppearanceContainer.Type] = [RFTextFieldCell.self] + containerTypes
            let appearanceProxy: UITextField = UITextField.appearance(whenContainedInInstancesOf: allContainerTypes)
            appearanceProxy.keyboardAppearance = theme.textFieldCell.textField_keyboardAppearance
        }
    }

	public lazy var toolbar: RFSimpleToolbar = {
		let instance = RFSimpleToolbar()
		weak var weakSelf = self
		instance.jumpToPrevious = {
			if let cell = weakSelf {
				cell.gotoPrevious()
			}
		}
		instance.jumpToNext = {
			if let cell = weakSelf {
				cell.gotoNext()
			}
		}
		instance.dismissKeyboard = {
			if let cell = weakSelf {
				cell.dismissKeyboard()
			}
		}
		return instance
	}()

	public func updateToolbarButtons() {
		if model.toolbarMode == .simple {
			toolbar.updateButtonConfiguration(self)
		}
	}

	public func gotoPrevious() {
		RFLog("make previous cell first responder")
		rf_makePreviousCellFirstResponder()
	}

	public func gotoNext() {
		RFLog("make next cell first responder")
		rf_makeNextCellFirstResponder()
	}

	public func dismissKeyboard() {
		RFLog("dismiss keyboard")
		_ = resignFirstResponder()
	}

	@objc public func handleTap(_ sender: UITapGestureRecognizer) {
		textField.becomeFirstResponder()
	}

	public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
		let gr = UITapGestureRecognizer(target: self, action: #selector(RFTextFieldCell.handleTap(_:)))
		return gr
		}()

	public enum TitleWidthMode {
		case auto
		case assign(width: CGFloat)
	}

	public var titleWidthMode: TitleWidthMode = .auto

	public func compute() -> RFTextFieldCell_Sizes {
		let cellWidth: CGFloat = bounds.width

		var titleLabelFrame = CGRect.zero
		var textFieldFrame = CGRect.zero
		var errorLabelFrame = CGRect.zero
		var cellHeight: CGFloat = 0
		let veryTallCell = CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat.greatestFiniteMagnitude)

		var layoutMargins = self.layoutMargins
		layoutMargins.top = 0
		layoutMargins.bottom = 0
		let area = veryTallCell.rf_inset(by: layoutMargins)

		let (topRect, _) = area.divided(atDistance: 44, from: .minYEdge)
		do {
			let size = titleLabel.sizeThatFits(area.size)
			var titleLabelWidth = size.width

			switch titleWidthMode {
			case .auto:
				break
			case let .assign(width):
				let w = CGFloat(width)
				if w > titleLabelWidth {
					titleLabelWidth = w
				}
			}

			var (slice, remainder) = topRect.divided(atDistance: titleLabelWidth, from: .minXEdge)
			titleLabelFrame = slice
			(_, remainder) = remainder.divided(atDistance: 10, from: .minXEdge)
			remainder.size.width += 4
			textFieldFrame = remainder

			cellHeight = ceil(textFieldFrame.height)
		}
		do {
			let size = errorLabel.sizeThatFits(area.size)
//			RFLog("error label size \(size)")
			if size.height > 0.1 {
				var r = topRect
				r.origin.y = topRect.maxY - 6
				let (slice, _) = r.divided(atDistance: size.height, from: .minYEdge)
				errorLabelFrame = slice
				cellHeight = ceil(errorLabelFrame.maxY + 10)
			}
		}

		return RFTextFieldCell_Sizes(titleLabelFrame: titleLabelFrame, textFieldFrame: textFieldFrame, errorLabelFrame: errorLabelFrame, cellHeight: cellHeight)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		//RFLog("layoutSubviews")
		let sizes: RFTextFieldCell_Sizes = compute()
		titleLabel.frame = sizes.titleLabelFrame
		textField.frame = sizes.textFieldFrame
		errorLabel.frame = sizes.errorLabelFrame
	}

	@objc public func valueDidChange() {
		model.valueDidChange(textField.text ?? "")

		let result: RFValidateResult = model.model.liveValidateValueText()
		switch result {
		case .valid:
			RFLog("valid")
		case .hardInvalid:
			RFLog("hard invalid")
		case .softInvalid:
			RFLog("soft invalid")
		}
	}

	public func setValueWithoutSync(_ value: String) {
		RFLog("set value \(value)")
		textField.text = value
		_ = validateAndUpdateErrorIfNeeded(value, shouldInstallTimer: false, checkSubmitRule: false)
	}

	public func updateErrorLabel(_ result: RFValidateResult) {
		switch result {
		case .valid:
			errorLabel.text = nil
		case .hardInvalid(let message):
			errorLabel.text = message
		case .softInvalid(let message):
			errorLabel.text = message
		}
	}

	public var lastResult: RFValidateResult?

	public var hideErrorMessageAfterFewSecondsTimer: Timer?
	public func invalidateTimer() {
		if let timer = hideErrorMessageAfterFewSecondsTimer {
			timer.invalidate()
			hideErrorMessageAfterFewSecondsTimer = nil
		}
	}

	public func installTimer() {
		invalidateTimer()
		let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(RFTextFieldCell.timerUpdate), userInfo: nil, repeats: false)
		hideErrorMessageAfterFewSecondsTimer = timer
	}

	// Returns true  when valid
	// Returns false when invalid
	public func validateAndUpdateErrorIfNeeded(_ text: String, shouldInstallTimer: Bool, checkSubmitRule: Bool) -> Bool {

		let tableView: UITableView? = rf_tableView()

		let result: RFValidateResult = model.model.validateText(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: checkSubmitRule)
		if let lastResult = lastResult {
			if lastResult == result {
				switch result {
				case .valid:
					//RFLog("same valid")
					return true
				case .hardInvalid:
					//RFLog("same hard invalid")
					invalidateTimer()
					if shouldInstallTimer {
						installTimer()
					}
					return false
				case .softInvalid:
					//RFLog("same soft invalid")
					invalidateTimer()
					if shouldInstallTimer {
						installTimer()
					}
					return true
				}
			}
		}
		lastResult = result

		switch result {
		case .valid:
			//RFLog("different valid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = nil
				setNeedsLayout()
				tv.endUpdates()

				invalidateTimer()
			}
			return true
		case let .hardInvalid(message):
			//RFLog("different hard invalid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = message
				setNeedsLayout()
				tv.endUpdates()

				invalidateTimer()
				if shouldInstallTimer {
					installTimer()
				}
			}
			return false
		case let .softInvalid(message):
			//RFLog("different soft invalid")
			if let tv = tableView {
				tv.beginUpdates()
				errorLabel.text = message
				setNeedsLayout()
				tv.endUpdates()

				invalidateTimer()
				if shouldInstallTimer {
					installTimer()
				}
			}
			return true
		}
	}

	@objc public func timerUpdate() {
		invalidateTimer()
		//RFLog("timer update")

		let s = textField.text ?? ""
		_ = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: false, checkSubmitRule: false)
	}

	public func reloadPersistentValidationState() {
		invalidateTimer()
		//RFLog("reload persistent message")

		let s = textField.text ?? ""
		_ = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: false, checkSubmitRule: true)
	}

	// MARK: UIResponder

	public override var canBecomeFirstResponder: Bool {
		return true
	}

	public override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}

	public override func resignFirstResponder() -> Bool {
		return textField.resignFirstResponder()
	}

}

extension RFTextFieldCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField_appearanceStrategy?.textFieldDidBeginEditing(textField)
        updateToolbarButtons()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField_appearanceStrategy?.textFieldDidEndEditing(textField)
    }

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textFieldString: NSString = textField.text as NSString? ?? ""
		let s = textFieldString.replacingCharacters(in: range, with:string)
		let valid = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: true, checkSubmitRule: false)
		return valid
	}

	// Hide the keyboard when the user taps the return key in this UITextField
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let s = textField.text ?? ""
		let isTextValid = validateAndUpdateErrorIfNeeded(s, shouldInstallTimer: true, checkSubmitRule: true)
		if isTextValid {
			textField.resignFirstResponder()
			model.didEndEditing(s)
		}
		return false
	}
}

extension RFTextFieldCell: RFCellHeightProvider {
	public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
		let sizes: RFTextFieldCell_Sizes = compute()
		let value = sizes.cellHeight
		//RFLog("compute height of row: \(value)")
		return value
	}
}

extension RFTextFieldCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.titleLabel.textColor = self.titleLabel_textColor
        
        self.errorLabel.textColor = self.errorLabel_textColor ?? UIColor.red
        
        let placeholderColor: UIColor = self.textField_placeholderColor ?? UIColor(white: 0.7, alpha: 1)
        self.textField.attributedPlaceholder = NSAttributedString(
            string: self.model.placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        self.textField_appearanceStrategy?.willDisplay(self.textField)
    }
}

public enum RFTextFieldCell_State {
    case noMessage
    case temporaryMessage(message: String)
    case persistentMessage(message: String)
}

public class RFTextFieldCell_Sizes {
    public let titleLabelFrame: CGRect
    public let textFieldFrame: CGRect
    public let errorLabelFrame: CGRect
    public let cellHeight: CGFloat
    
    public init(titleLabelFrame: CGRect, textFieldFrame: CGRect, errorLabelFrame: CGRect, cellHeight: CGFloat) {
        self.titleLabelFrame = titleLabelFrame
        self.textFieldFrame = textFieldFrame
        self.errorLabelFrame = errorLabelFrame
        self.cellHeight = cellHeight
    }
}

public class RFTextFieldCell_TextField: UITextField {
    public func configure() {
        autocapitalizationType = .sentences
        autocorrectionType = .default
        spellCheckingType = .no
        returnKeyType = .done
        clearButtonMode = .whileEditing
    }
}

@available(*, unavailable, renamed: "RFTextFieldCell")
typealias TextFieldFormItemCell = RFTextFieldCell

@available(*, unavailable, renamed: "RFTextFieldCellModel")
typealias TextFieldFormItemCellModel = RFTextFieldCellModel

@available(*, unavailable, renamed: "RFTextFieldCell_State")
typealias TextFieldCell_State = RFTextFieldCell_State

@available(*, unavailable, renamed: "RFTextFieldCell_Sizes")
typealias TextFieldFormItemCellSizes = RFTextFieldCell_Sizes

@available(*, unavailable, renamed: "RFTextFieldCell_TextField")
typealias CustomTextField = RFTextFieldCell_TextField
