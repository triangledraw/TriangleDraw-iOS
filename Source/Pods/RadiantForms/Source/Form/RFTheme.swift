// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFTheme {
    internal let tableViewBackground: RFTheme_TableViewBackground
    internal let tableViewSeparator: RFTheme_TableViewSeparator
    internal let sectionHeader: RFTheme_SectionHeader
    internal let sectionFooter: RFTheme_SectionFooter
    internal let cellBackground: RFTheme_CellBackground
    internal var amountCell: RFTheme_AmountCell
    internal let buttonCell: RFTheme_ButtonCell
    internal let datePickerCell: RFTheme_DatePickerCell
    internal var optionViewControllerCell: RFTheme_OptionViewControllerCell
    internal let segmentedControlCell: RFTheme_SegmentedControlCell
    internal let stepperCell: RFTheme_StepperCell
    internal let switchCell: RFTheme_SwitchCell
    internal var textFieldCell: RFTheme_TextFieldCell
    internal let viewControllerCell: RFTheme_ViewControllerCell
    internal let navigationBar: RFTheme_NavigationBar
    internal let toolBar: RFTheme_ToolBar
    internal var fontStrategy: RFTheme_FontStrategy
    
    public static func lightTheme() -> RFTheme {
        return RFTheme(
            tableViewBackground: .lightTheme,
            tableViewSeparator: .lightTheme,
            sectionHeader: .lightTheme,
            sectionFooter: .lightTheme,
            cellBackground: .lightTheme,
            amountCell: .lightTheme,
            buttonCell: .lightTheme,
            datePickerCell: .lightTheme,
            optionViewControllerCell: .lightTheme,
            segmentedControlCell: .lightTheme,
            stepperCell: .lightTheme,
            switchCell: .lightTheme,
            textFieldCell: .lightTheme,
            viewControllerCell: .lightTheme,
            navigationBar: .lightTheme,
            toolBar: .lightTheme,
            fontStrategy: .defaultStrategy
        )
    }
    
    public static func darkTheme() -> RFTheme {
        return RFTheme(
            tableViewBackground: .darkTheme,
            tableViewSeparator: .darkTheme,
            sectionHeader: .darkTheme,
            sectionFooter: .darkTheme,
            cellBackground: .darkTheme,
            amountCell: .darkTheme,
            buttonCell: .darkTheme,
            datePickerCell: .darkTheme,
            optionViewControllerCell: .darkTheme,
            segmentedControlCell: .darkTheme,
            stepperCell: .darkTheme,
            switchCell: .darkTheme,
            textFieldCell: .darkTheme,
            viewControllerCell: .darkTheme,
            navigationBar: .darkTheme,
            toolBar: .darkTheme,
            fontStrategy: .defaultStrategy
        )
    }
}

internal enum RFTheme_TableViewBackground {
    case lightTheme, darkTheme
}

internal enum RFTheme_TableViewSeparator {
    case lightTheme, darkTheme
}

internal enum RFTheme_SectionHeader {
    case lightTheme, darkTheme
}

internal enum RFTheme_SectionFooter {
    case lightTheme, darkTheme
}

internal enum RFTheme_CellBackground {
    case lightTheme, darkTheme
}

internal enum RFTheme_AmountCell {
    case lightTheme, darkTheme
    indirect case textField_textColor(color: UIColor, theme: RFTheme_AmountCell)
    indirect case textField_tintColor(color: UIColor, theme: RFTheme_AmountCell)
    indirect case textField_appearanceStrategy_useTintFirstResponder(theme: RFTheme_AmountCell)
}

internal enum RFTheme_ButtonCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_DatePickerCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_OptionViewControllerCell {
    case lightTheme, darkTheme
    indirect case detailTextLabel_textColor(color: UIColor, theme: RFTheme_OptionViewControllerCell)
}

internal enum RFTheme_SegmentedControlCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_StepperCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_SwitchCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_TextFieldCell {
    case lightTheme, darkTheme
    indirect case textField_textColor(color: UIColor, theme: RFTheme_TextFieldCell)
    indirect case textField_tintColor(color: UIColor, theme: RFTheme_TextFieldCell)
    indirect case textField_appearanceStrategy_useTintFirstResponder(theme: RFTheme_TextFieldCell)
}

internal enum RFTheme_ViewControllerCell {
    case lightTheme, darkTheme
}

internal enum RFTheme_NavigationBar {
    case lightTheme, darkTheme
}

internal enum RFTheme_ToolBar {
    case lightTheme, darkTheme
}

internal enum RFTheme_FontStrategy {
    case defaultStrategy
    case boldTitle
}


internal extension RFTheme_SectionHeader {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.darkGray
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_SectionFooter {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.lightGray
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_TableViewBackground {
    var color: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(white: 0.9, alpha: 1.0)
        case .darkTheme:
            return UIColor(white: 0.25, alpha: 1.0)
        }
    }
}

internal extension RFTheme_TableViewSeparator {
    var color: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(white: 0.8, alpha: 1.0)
        case .darkTheme:
            return UIColor(white: 0.0, alpha: 1.0)
        }
    }
}

internal extension RFTheme_CellBackground {
    var color: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(white: 0.95, alpha: 1.0)
        case .darkTheme:
            return UIColor(white: 0.2, alpha: 1.0)
        }
    }
}

internal extension RFTheme_AmountCell {
    var titleLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        case .textField_textColor(_, let theme):
            return theme.titleLabel_textColor
        case .textField_tintColor(_, let theme):
            return theme.titleLabel_textColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.titleLabel_textColor
        }
    }

    var rightView_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        case .textField_textColor(_, let theme):
            return theme.rightView_textColor
        case .textField_tintColor(_, let theme):
            return theme.rightView_textColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.rightView_textColor
        }
    }

    var textField_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .textField_textColor(let color, _):
            return color
        case .textField_tintColor(_, let theme):
            return theme.textField_textColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_textColor
        }
    }
    
    var textField_keyboardAppearance: UIKeyboardAppearance {
        switch self {
        case .lightTheme:
            return .light
        case .darkTheme:
            return .dark
        case .textField_textColor(_, let theme):
            return theme.textField_keyboardAppearance
        case .textField_tintColor(_, let theme):
            return theme.textField_keyboardAppearance
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_keyboardAppearance
        }
    }

    var textField_placeholderColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(white: 0.7, alpha: 1)
        case .darkTheme:
            return UIColor(white: 0.4, alpha: 1)
        case .textField_textColor(_, let theme):
            return theme.textField_placeholderColor
        case .textField_tintColor(_, let theme):
            return theme.textField_placeholderColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_placeholderColor
        }
    }

    var textField_tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .textField_textColor(_, let theme):
            return theme.textField_tintColor
        case .textField_tintColor(let color, _):
            return color
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_tintColor
        }
    }
    
    var textField_appearanceStrategy: RFTextFieldAppearanceStrategy {
        switch self {
        case .lightTheme, .darkTheme:
            return RFTextFieldAppearanceStrategy_Default(
                tintColor: self.textField_tintColor,
                textColor: self.textField_textColor
            )
        case .textField_textColor(_, let theme):
            return theme.textField_appearanceStrategy
        case .textField_tintColor(_, let theme):
            return theme.textField_appearanceStrategy
        case .textField_appearanceStrategy_useTintFirstResponder(_):
            return RFTextFieldAppearanceStrategy_TintFirstResponder(
                tintColor: self.textField_tintColor,
                textColor: self.textField_textColor
            )
        }
    }
}

internal extension RFTheme_ButtonCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_DatePickerCell {
    var row_tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        }
    }
    
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }
    
    var detailTextLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.gray
        case .darkTheme:
            return UIColor.gray
        }
    }
}

internal extension RFTheme_OptionViewControllerCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        case .detailTextLabel_textColor(_, let theme):
            return theme.textLabel_textColor
        }
    }
    
    var detailTextLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .detailTextLabel_textColor(let color, _):
            return color
        }
    }
}

internal extension RFTheme_SegmentedControlCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }
    
    var segmentedControl_tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_SwitchCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }
    
    var switch_onTintColor: UIColor {
        return UIColor(red: 0.298, green: 0.85, blue: 0.39, alpha: 1)
    }
}

internal extension RFTheme_StepperCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }
    
    var valueLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        }
    }
    
    var stepper_tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_TextFieldCell {
    var titleLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        case .textField_textColor(_, let theme):
            return theme.titleLabel_textColor
        case .textField_tintColor(_, let theme):
            return theme.titleLabel_textColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.titleLabel_textColor
        }
    }
    
    var textField_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .textField_textColor(let color, _):
            return color
        case .textField_tintColor(_, let theme):
            return theme.textField_textColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_textColor
        }
    }
    
    var textField_keyboardAppearance: UIKeyboardAppearance {
        switch self {
        case .lightTheme:
            return .light
        case .darkTheme:
            return .dark
        case .textField_textColor(_, let theme):
            return theme.textField_keyboardAppearance
        case .textField_tintColor(_, let theme):
            return theme.textField_keyboardAppearance
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_keyboardAppearance
        }
    }
    
    var textField_placeholderColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(white: 0.7, alpha: 1)
        case .darkTheme:
            return UIColor(white: 0.4, alpha: 1)
        case .textField_textColor(_, let theme):
            return theme.textField_placeholderColor
        case .textField_tintColor(_, let theme):
            return theme.textField_placeholderColor
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_placeholderColor
        }
    }
    
    var textField_tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0, green: 0.45, blue: 1, alpha: 1)
        case .textField_textColor(_, let theme):
            return theme.textField_tintColor
        case .textField_tintColor(let color, _):
            return color
        case .textField_appearanceStrategy_useTintFirstResponder(let theme):
            return theme.textField_tintColor
        }
    }
    
    var textField_appearanceStrategy: RFTextFieldAppearanceStrategy {
        switch self {
        case .lightTheme, .darkTheme:
            return RFTextFieldAppearanceStrategy_Default(
                tintColor: self.textField_tintColor,
                textColor: self.textField_textColor
            )
        case .textField_textColor(_, let theme):
            return theme.textField_appearanceStrategy
        case .textField_tintColor(_, let theme):
            return theme.textField_appearanceStrategy
        case .textField_appearanceStrategy_useTintFirstResponder(_):
            return RFTextFieldAppearanceStrategy_TintFirstResponder(
                tintColor: self.textField_tintColor,
                textColor: self.textField_textColor
            )
        }
    }
    
    var errorLabel_textColor: UIColor {
        return UIColor.red
    }
}

internal extension RFTheme_ViewControllerCell {
    var textLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.white
        }
    }

    var detailTextLabel_textColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        case .darkTheme:
            return UIColor(red: 0.558, green: 0.558, blue: 0.578, alpha: 1)
        }
    }
}

internal extension RFTheme_NavigationBar {
    var barTintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.white
        case .darkTheme:
            return UIColor.darkGray
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.blue
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_ToolBar {
    var barTintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.white
        case .darkTheme:
            return UIColor.darkGray
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .lightTheme:
            return UIColor.blue
        case .darkTheme:
            return UIColor.white
        }
    }
}

internal extension RFTheme_FontStrategy {
    func resolveFontStrategy() -> RFFontStrategy {
        switch self {
        case .defaultStrategy:
            return RFFontStrategy_Default()
        case .boldTitle:
            return RFFontStrategy_BoldTitle()
        }
    }
}

