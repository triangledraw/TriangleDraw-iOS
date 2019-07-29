// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFCustomFormItem: RFFormItem {
	public struct Context {
		public let viewController: UIViewController
	}

	public enum CustomFormItemError: Error {
		case couldNotCreate
	}

	public typealias CreateCell = (Context) throws -> UITableViewCell
	public var createCell: CreateCell = { _ in throw CustomFormItemError.couldNotCreate }

    /// Holds a weak reference to the latest created cell.
    ///
    /// This reference becomes `nil` when the cell gets deallocated.
    ///
    /// Useful for modifying the cell in the future, such as when dismissing a child view controller.
    public weak var latestCreatedCell: UITableViewCell?
    
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}
}

@available(*, unavailable, renamed: "RFCustomFormItem")
typealias CustomFormItem = RFCustomFormItem
