// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import UIKit

extension UINavigationItem {
    func barButtonItem(withTag tag: Int) -> UIBarButtonItem? {
		var items = [UIBarButtonItem]()
		items += leftBarButtonItems ?? []
		items += rightBarButtonItems ?? []
        for item: UIBarButtonItem in items {
            // swiftlint:disable:next for_where
            if item.tag == tag {
                return item
            }
        }
        return nil
    }
}
