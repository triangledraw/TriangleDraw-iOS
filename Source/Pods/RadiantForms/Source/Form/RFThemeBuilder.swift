// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFThemeBuilder: NSObject {
    private var theme: RFTheme

    public init(theme: RFTheme) {
        self.theme = theme
        super.init()
    }
    
    @objc public static var light: RFThemeBuilder {
        return RFThemeBuilder(theme: RFTheme.lightTheme())
    }
    
    @objc public static var dark: RFThemeBuilder {
        return RFThemeBuilder(theme: RFTheme.darkTheme())
    }
    
    @objc public func apply() {
        self.applyWhenContainedInInstancesOf([])
    }
    
    public func applyTo(_ containerTypes: UIAppearanceContainer.Type ...) {
        self.applyWhenContainedInInstancesOf(containerTypes)
    }
    
    @objc public func applyWhenContainedInInstancesOf(_ containerTypes: [UIAppearanceContainer.Type]) {
        RFFontStrategySingleton.shared.register(
            containerTypes: containerTypes,
            theme: self.theme
        )

        RFFormTableView.configureAppearance(
            whenContainedInInstancesOf: containerTypes,
            theme: self.theme
        )
    }
    
    private var _tintColor: UIColor?
    
    @objc public var tintColor: UIColor? {
        get {
            return self._tintColor
        }
        set {
            if let color: UIColor = newValue {
                theme.amountCell = RFTheme_AmountCell.textField_textColor(color: color, theme: theme.amountCell)
                theme.amountCell = RFTheme_AmountCell.textField_tintColor(color: color, theme: theme.amountCell)
                theme.optionViewControllerCell = RFTheme_OptionViewControllerCell.detailTextLabel_textColor(color: color, theme: theme.optionViewControllerCell)
                theme.textFieldCell = RFTheme_TextFieldCell.textField_textColor(color: color, theme: theme.textFieldCell)
                theme.textFieldCell = RFTheme_TextFieldCell.textField_tintColor(color: color, theme: theme.textFieldCell)
            }
            self._tintColor = newValue
        }
    }
    
    @objc public func useTintFirstResponderStrategy() {
        theme.amountCell = RFTheme_AmountCell.textField_appearanceStrategy_useTintFirstResponder(theme: theme.amountCell)
        theme.textFieldCell = RFTheme_TextFieldCell.textField_appearanceStrategy_useTintFirstResponder(theme: theme.textFieldCell)
    }
    
    @objc public func useBoldTitleFontStrategy() {
        theme.fontStrategy = RFTheme_FontStrategy.boldTitle
    }
}
