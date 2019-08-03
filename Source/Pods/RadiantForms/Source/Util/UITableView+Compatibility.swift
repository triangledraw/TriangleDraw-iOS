// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

extension UITableView {
    public static var rf_automaticDimension: CGFloat {
        #if swift(>=4.2)
            // 'automaticDimensions' was introduced in Swift 4.2
            return UITableView.automaticDimension
        #else
            // Swift 4.0 and earlier
            return UITableViewAutomaticDimension
        #endif
    }

    @available(*, deprecated, message: "Will be removed with Version2, use rf_automaticDimension instead")
    public static var form_automaticDimension: CGFloat {
        return rf_automaticDimension
    }
}
