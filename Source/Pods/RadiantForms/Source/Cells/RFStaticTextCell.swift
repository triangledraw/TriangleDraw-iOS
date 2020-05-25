// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public struct RFStaticTextCellModel {
	var title: String = ""
	var value: String = ""
}

/// Cell for displaying oneliner `Key` and `Value`.
///
/// Shows the `title` in the left side, and the `value` in the right side.
///
/// Neither the `title` nor the `value` can span multiple lines.
///
/// The cell is not selectable.
public class RFStaticTextCell: UITableViewCell {
	public var model: RFStaticTextCellModel

	public init(model: RFStaticTextCellModel) {
		self.model = model
		super.init(style: .value1, reuseIdentifier: nil)
		loadWithModel(model)
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func loadWithModel(_ model: RFStaticTextCellModel) {
		selectionStyle = .none
		textLabel?.text = model.title
		detailTextLabel?.text = model.value
	}
}


@available(*, unavailable, renamed: "RFStaticTextCell")
typealias StaticTextCell = RFStaticTextCell

@available(*, unavailable, renamed: "RFStaticTextCellModel")
typealias StaticTextCellModel = RFStaticTextCellModel
