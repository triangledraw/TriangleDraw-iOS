// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFFontStrategy {
    func titleFont() -> RFFont
    func valueFont() -> RFFont
}

public class RFFontStrategy_Default: RFFontStrategy {
    public func titleFont() -> RFFont {
        return RFPreferredFontForTextStyle.body
    }
    
    public func valueFont() -> RFFont {
        return RFPreferredFontForTextStyle.body
    }
}

public class RFFontStrategy_BoldTitle: RFFontStrategy {
    public func titleFont() -> RFFont {
        return RFPreferredFontForTextStyle.headline
    }
    
    public func valueFont() -> RFFont {
        return RFPreferredFontForTextStyle.body
    }
}

/// UIViewController has no appearance proxy. This singleton serves the same purpose.
internal class RFFontStrategySingleton {
    static let shared = RFFontStrategySingleton()
    
    private typealias TypeName2FontStrategy = [String: RFFontStrategy]
    private var dict = TypeName2FontStrategy()
    private var globalFontStrategyOrNil: RFFontStrategy?
    
    func register(containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        let fontStrategy: RFFontStrategy = theme.fontStrategy.resolveFontStrategy()
        guard containerTypes.count <= 1 else {
            RFLog("ERROR: Expected containerTypes array to be exactly 1 element, but got more. Cannot register fontStrategy.")
            return
        }
        guard let firstContainerType: UIAppearanceContainer.Type = containerTypes.first else {
            self.globalFontStrategyOrNil = fontStrategy
            RFLog("Registered a global fontStrategy: '\(type(of: fontStrategy))'")
            return
        }
        guard let vctype = firstContainerType as? RFFormViewController.Type else {
            RFLog("ERROR: Expected vc to be subclass of RFFormViewController. Cannot register fontStrategy.")
            return
        }
        
        let typename: String = String(describing: vctype)
        self.dict[typename] = fontStrategy
        RFLog("registered typename: '\(typename)'  fontStrategy: '\(type(of: fontStrategy))'")
    }
    
    /// Lookup `RFFontStrategy` for a given `viewController`.
    /// Returns `nil` if there is no registered font strategy.
    func find(viewController: UIViewController) -> RFFontStrategy? {
        guard let vctype = type(of: viewController) as? RFFormViewController.Type else {
            RFLog("ERROR: Expected viewController to be subclass of RFFormViewController. Cannot register fontStrategy.")
            return nil
        }
        
        let typename: String = String(describing: vctype)
        let fontStrategyOrNil: RFFontStrategy? = self.dict[typename]
        return fontStrategyOrNil
    }
    
    /// Determine what `RFFontStrategy` to use for a given `viewController`.
    /// If none is found, then it fallsback to using the default font strategy.
    func resolve(viewController: UIViewController) -> RFFontStrategy {
        let fontStrategyOrNil: RFFontStrategy? = self.find(viewController: viewController)
        if let fontStrategy: RFFontStrategy = fontStrategyOrNil {
            RFLog("Resolve: Using the a registered fontStrategy. fontStrategy: '\(type(of: fontStrategy))'")
            return fontStrategy
        }
        if let fontStrategy: RFFontStrategy = self.globalFontStrategyOrNil {
            RFLog("Resolve: Using the global fontStrategy. fontStrategy: '\(type(of: fontStrategy))'")
            return fontStrategy
        }
        RFLog("No registered fontStrategy. Using default font strategy.")
        return RFFontStrategy_Default()
    }
}
