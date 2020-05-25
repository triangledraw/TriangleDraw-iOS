// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFAttributedTextCellModel {
	var titleAttributedText: NSAttributedString?
	var valueAttributedText: NSAttributedString?
}

/// Cell for displaying oneliner `Key` and `Value`.
///
/// Shows the `title` in the left side, and the `value` in the right side.
///
/// Neither the `title` nor the `value` can span multiple lines.
///
/// The cell is not selectable.
public class RFAttributedTextCell: UITableViewCell {
    public var model: RFAttributedTextCellModel

    public init(model: RFAttributedTextCellModel) {
        self.model = model
        super.init(style: .value1, reuseIdentifier: nil)
        loadWithModel(model)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadWithModel(_ model: RFAttributedTextCellModel) {
        selectionStyle = .none
        textLabel?.attributedText = model.titleAttributedText
        detailTextLabel?.attributedText = model.valueAttributedText
    }
}


@available(*, unavailable, renamed: "RFAttributedTextCell")
typealias AttributedTextCell = RFAttributedTextCell

@available(*, unavailable, renamed: "RFAttributedTextCellModel")
typealias AttributedTextCellModel = RFAttributedTextCellModel
