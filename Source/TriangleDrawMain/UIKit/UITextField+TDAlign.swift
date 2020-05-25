// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UITextField {
    func alignMinX() {
        textAlignment = .left
    }

    func alignMidX() {
        textAlignment = .center
    }

    func alignMaxX() {
        textAlignment = .right
    }

    func alignMinY() {
        contentVerticalAlignment = .top
    }

    func alignMidY() {
        contentVerticalAlignment = .center
    }

    func alignMaxY() {
        contentVerticalAlignment = .bottom
    }
}
