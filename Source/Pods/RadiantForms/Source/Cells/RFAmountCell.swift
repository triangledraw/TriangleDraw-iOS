// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFAmountCellSizes {
    public let titleLabelFrame: CGRect
    public let textFieldFrame: CGRect
    public let cellHeight: CGFloat
    
    public init(titleLabelFrame: CGRect, textFieldFrame: CGRect, cellHeight: CGFloat) {
        self.titleLabelFrame = titleLabelFrame
        self.textFieldFrame = textFieldFrame
        self.cellHeight = cellHeight
    }
}

public struct RFAmountCellModel {
    var numberFormatter: NumberFormatter! = nil
    var title: String = ""
    var toolbarMode: RFToolbarMode = .simple
    var placeholder: String = ""
    var unitSuffix: String = ""
    var returnKeyType: UIReturnKeyType = .default
    var maxIntegerDigits: UInt8 = 10
    var fractionDigits: UInt8 = 3
    var model: RFAmountFormItem! = nil
    var titleFont: RFFont = RFPreferredFontForTextStyle.body
    var valueFont: RFFont = RFPreferredFontForTextStyle.body

    var valueDidChange: (RFAmountValue) -> Void = { (value: RFAmountValue) in
        RFLog("value \(value)")
    }
    
    var maxIntegerAndFractionDigits: UInt {
        return UInt(self.maxIntegerDigits) + UInt(self.fractionDigits)
    }

    func formatAmount(_ internalValue: UInt64) -> String {
        let decimal0: Decimal = Decimal(internalValue)
        let negativeExponent: Int = -Int(self.fractionDigits)
        let decimal1: Decimal = Decimal(sign: .plus, exponent: negativeExponent, significand: decimal0)
        return self.numberFormatter.string(from: decimal1 as NSNumber) ?? ""
    }
}

public class RFAmountCell: UITableViewCell {
    public let model: RFAmountCellModel
    public let titleLabel = UILabel()
    public let textField = RFAmountCell_TextField()
    
    public init(model: RFAmountCellModel) {
        assert(model.numberFormatter != nil)
        assert(model.model != nil)
        
        self.model = model
        
        super.init(style: .default, reuseIdentifier: nil)
        
        self.addGestureRecognizer(tapGestureRecognizer)
        
        selectionStyle = .none
        
        titleLabel.font = model.titleFont.resolve()
        textField.font = model.valueFont.resolve()

        textField.configure()
        textField.delegate = self

        textField.addTarget(self, action: #selector(valueDidChange), for: UIControl.Event.editingChanged)

        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.text = model.title
        textField.returnKeyType = model.returnKeyType
        
        if self.model.toolbarMode == .simple {
            textField.inputAccessoryView = toolbar
        }

        clipsToBounds = true
        
        installRightView()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIAppearance
    
    @objc public dynamic var titleLabel_textColor: UIColor?
    @objc public dynamic var rightView_textColor: UIColor?
    @objc public dynamic var textField_placeholderColor: UIColor?
    @objc public dynamic var textField_appearanceStrategy: RFTextFieldAppearanceStrategy?
    
    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        do {
            let appearanceProxy: RFAmountCell = RFAmountCell.appearance(whenContainedInInstancesOf: containerTypes)
            appearanceProxy.titleLabel_textColor = theme.amountCell.titleLabel_textColor
            appearanceProxy.rightView_textColor = theme.amountCell.rightView_textColor
            appearanceProxy.textField_placeholderColor = theme.amountCell.textField_placeholderColor
            appearanceProxy.textField_appearanceStrategy = theme.amountCell.textField_appearanceStrategy
        }
        
        do {
            let allContainerTypes: [UIAppearanceContainer.Type] = [RFAmountCell.self] + containerTypes
            let appearanceProxy: UITextField = UITextField.appearance(whenContainedInInstancesOf: allContainerTypes)
            appearanceProxy.keyboardAppearance = theme.amountCell.textField_keyboardAppearance
        }
    }

    // MARK: - RightView, for unit indicators or currency codes
    
    private func installRightView() {
        let text: String = model.unitSuffix
        guard !text.isEmpty else {
            return
        }
        let label: UILabel = self.rightView
        label.font = textField.font
        textField.rightView = label
        textField.rightViewMode = .always
        label.text = text
        label.sizeToFit()
    }
    
    public lazy var rightView: UILabel = {
        let instance = RFEdgeInsetLabel(frame: .zero)
        instance.textAlignment = .right
        instance.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return instance
    }()
    
    
    // MARK: - Toolbar, Prev/Next Buttons
    
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
    
    @objc public func handleTap() {
        textField.becomeFirstResponder()
    }
    
    public lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return gr
    }()
    
    public enum TitleWidthMode {
        case auto
        case assign(width: CGFloat)
    }
    
    public var titleWidthMode: TitleWidthMode = .auto
    
    public func compute() -> RFAmountCellSizes {
        let cellWidth: CGFloat = bounds.width
        
        var titleLabelFrame = CGRect.zero
        var textFieldFrame = CGRect.zero
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
        
        return RFAmountCellSizes(titleLabelFrame: titleLabelFrame, textFieldFrame: textFieldFrame, cellHeight: cellHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //RFLog("layoutSubviews")
        let sizes: RFAmountCellSizes = compute()
        titleLabel.frame = sizes.titleLabelFrame
        textField.frame = sizes.textFieldFrame
    }
    
    /// Remove all non-digits, such as symbols, whitespace, formatting.
    public static func extractDigitsFromString(_ formattedString: String) -> String {
        // Split the string by non-digit characters to an array of digits and the join them back to a string
        return formattedString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    public func createInternalValue(_ digitsString: String) -> UInt64? {
        guard let internalValue: UInt64 = UInt64(digitsString) else {
            RFLog("Failed to create internalValue from string")
            return nil
        }
        return internalValue
    }
    
    public func formatAmount(_ internalValue: UInt64) -> String {
        return self.model.formatAmount(internalValue)
    }

    public func parseAndFormatAmount(_ value: RFAmountValue) -> String {
        if value == 0 {
            RFLog("The value is zero")
            return ""
        }
        return self.formatAmount(value)
    }
    
    @objc public func valueDidChange() {
        let text: String = textField.text ?? ""
        let unformattedString: String = type(of: self).extractDigitsFromString(text)
        let internalValue: RFAmountValue = self.createInternalValue(unformattedString) ?? 0
        model.valueDidChange(internalValue)
    }
    
    public func setValueWithoutSync(_ value: RFAmountValue) {
        RFLog("set value \(value)")
        let formattedValue: String = self.parseAndFormatAmount(value)
        textField.text = formattedValue
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

extension RFAmountCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField_appearanceStrategy?.textFieldDidBeginEditing(textField)
        updateToolbarButtons()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField_appearanceStrategy?.textFieldDidEndEditing(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //RFLog("enter. NSRange: \(range)   replacementString: '\(string)'")
        
        let currentText: String = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            RFLog("ERROR: Unable to create Range from NSRange")
            return false
        }
        //RFLog("stringRange: \(stringRange)   NSRange: \(range)   currentText: '\(currentText)'")

        let updatedText: String = currentText.replacingCharacters(in: stringRange, with: string)
        
        let digitsString: String = type(of: self).extractDigitsFromString(updatedText)
        if digitsString.isEmpty {
            return true
        }
        guard let internalValue: UInt64 = self.createInternalValue(digitsString) else {
            RFLog("Cannot create an internalValue")
            return false
        }
        if internalValue == 0 {
            textField.text = nil
            RFLog("Show placeholder, when the internalValue is zero")
            valueDidChange()
            return false
        }
        
        let internalValueString: String = String(internalValue)
        guard internalValueString.count <= self.model.maxIntegerAndFractionDigits else {
            RFLog("The internalValue must stay shorter than the max number of digits")
            return false
        }
        
        let s: String = self.formatAmount(internalValue)
        textField.text = s
        valueDidChange()
        
        //RFLog("Leave.  s: '\(s)'")
        return false
    }
    
    // Hide the keyboard when the user taps the return key in this UITextField
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension RFAmountCell: RFCellHeightProvider {
    public func form_cellHeight(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        let sizes: RFAmountCellSizes = compute()
        let value = sizes.cellHeight
        //RFLog("compute height of row: \(value)")
        return value
    }
}

extension RFAmountCell: RFWillDisplayCellDelegate {
    public func form_willDisplay(tableView: UITableView, forRowAtIndexPath indexPath: IndexPath) {
        self.titleLabel.textColor = self.titleLabel_textColor
        self.rightView.textColor = self.rightView_textColor

        let placeholderColor: UIColor = self.textField_placeholderColor ?? UIColor(white: 0.7, alpha: 1)
        self.textField.attributedPlaceholder = NSAttributedString(
            string: self.model.placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        self.textField_appearanceStrategy?.willDisplay(self.textField)
    }
}

internal class RFAmountCell_NumberFormatter: NumberFormatter {
    /// `fractionDigits` is typically between 0 and 5
    init(fractionDigits: UInt8) {
        super.init()
        self.numberStyle = .decimal
        self.currencyCode = ""
        self.currencySymbol = ""
        self.currencyGroupingSeparator = ""
        self.perMillSymbol = ""
        self.groupingSeparator = ","
        self.minimumFractionDigits = Int(fractionDigits)
        self.maximumFractionDigits = Int(fractionDigits)
        self.negativeSuffix = ""
        self.negativePrefix = "-"
        self.decimalSeparator = "."
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class RFAmountCell_TextField: UITextField {
    fileprivate func configure() {
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        returnKeyType = .done
        clearButtonMode = .never
        isSecureTextEntry = false
        keyboardType = .numberPad
        textAlignment = .right
    }
}
