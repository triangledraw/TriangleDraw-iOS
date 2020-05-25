// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public typealias RFCustomFormItemPayload = Any

/// This is for installing a custom `UITableViewCell` in the form.
public class RFCustomFormItem: RFFormItem {
	public struct Context {
		public let viewController: UIViewController
	}

	public enum CustomFormItemError: Error {
		case couldNotCreate
	}

	public typealias CreateCell = (Context) throws -> UITableViewCell
    
    /// This `createCell` callback is invoked whenever there is a need for a new instance of the custom `UITableViewCell` subclass.
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

    /// The `payload` field can be useful for holding the result of the custom cell.
    ///
    /// Usecase: When the user makes a choice in a color picker and the selected color is to be stored somewhere,
    /// then this `payload` field can be a possible storage location for the picked color.
    ///
    /// Beware this `payload` field is of the `Any` type, so it's not typesafe.
    public var payload: RFCustomFormItemPayload?
}

@available(*, unavailable, renamed: "RFCustomFormItem")
typealias CustomFormItem = RFCustomFormItem
