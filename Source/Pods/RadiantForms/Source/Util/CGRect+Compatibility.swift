// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension CGRect {
    public func rf_inset(by insets: UIEdgeInsets) -> CGRect {
        #if swift(>=4.2)
            // 'inset(by:)' was introduced in Swift 4.2
            return inset(by: insets)
        #else
            // Swift 4.0 and earlier
            return UIEdgeInsetsInsetRect(self, insets)
        #endif
    }

    @available(*, deprecated, message: "Will be removed with Version2, use rf_inset instead")
    public func form_inset(by insets: UIEdgeInsets) -> CGRect {
        return rf_inset(by: insets)
    }
}
