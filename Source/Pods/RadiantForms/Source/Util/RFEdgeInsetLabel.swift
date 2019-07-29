// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

/// `UILabel` with padding around it, inspired by:
/// https://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accommodate-insets/21267507#21267507
/// https://stackoverflow.com/a/55437367/78336
public class RFEdgeInsetLabel: UILabel {
    public var edgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.rf_inset(by: edgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -edgeInsets.top,
                                          left: -edgeInsets.left,
                                          bottom: -edgeInsets.bottom,
                                          right: -edgeInsets.right)
        return textRect.rf_inset(by: invertedInsets)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.rf_inset(by: edgeInsets))
    }
}
