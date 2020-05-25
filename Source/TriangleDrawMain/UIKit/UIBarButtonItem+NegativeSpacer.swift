// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIBarButtonItem {
    class func negativeSpacerWidth(_ width: Int) -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        item.width = CGFloat(-width)
        return item
    }
}
