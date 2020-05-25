// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public typealias RFOptionRowModelPayload = Any

public class RFOptionRowModel {
    public let title: String
    public let identifier: String
    public let payload: RFOptionRowModelPayload?
    
    public init(title: String, identifier: String, payload: RFOptionRowModelPayload?) {
        self.title = title
        self.identifier = identifier
        self.payload = payload
    }
}

extension RFOptionRowModel: CustomStringConvertible {
    public var description: String {
        let payloadString: String
        if let payload: RFOptionRowModelPayload = self.payload {
            payloadString = String(describing: payload)
        } else {
            payloadString = "no payload"
        }
        return "RFOptionRowModel(title: '\(title)', identifier: '\(identifier)', payload: '\(payloadString)')"
    }
}


public class RFOptionPickerFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var placeholder: String = ""

	@discardableResult
	public func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public var options = [RFOptionRowModel]()

    /// Add an option to the picker, that the user can select.
    ///
    /// - Parameter title: The localized text that is displayed to the user.
    /// - Parameter identifier: An optional identifier. Useful for preselecting an option.
    /// - Parameter payload: An optional payload.
	@discardableResult
    public func append(_ title: String, identifier: String? = nil, payload: RFOptionRowModelPayload? = nil) -> Self {
        options.append(RFOptionRowModel(title: title, identifier: identifier ?? title, payload: payload))
		return self
	}

	public func selectOptionWithTitle(_ title: String) {
		for option in options {
			if option.title == title {
				self.setSelectedOptionRow(option)
				RFLog("initial selected option: \(option)")
			}
		}
	}

	public func selectOptionWithIdentifier(_ identifier: String) {
		for option in options {
			if option.identifier == identifier {
				self.setSelectedOptionRow(option)
				RFLog("initial selected option: \(option)")
			}
		}
	}

	public typealias SyncBlock = (_ selected: RFOptionRowModel?) -> Void
	public var syncCellWithValue: SyncBlock = { (selected: RFOptionRowModel?) in
		RFLog("sync is not overridden")
	}

	internal var innerSelected: RFOptionRowModel?
	public var selected: RFOptionRowModel? {
		get {
			return self.innerSelected
		}
		set {
			self.setSelectedOptionRow(newValue)
		}
	}

	public func setSelectedOptionRow(_ selected: RFOptionRowModel?) {
		RFLog("option: \(String(describing: selected?.title))")
		innerSelected = selected
		syncCellWithValue(selected)
	}

	public typealias ValueDidChange = (_ selected: RFOptionRowModel?) -> Void
	public var valueDidChange: ValueDidChange = { (selected: RFOptionRowModel?) in
		RFLog("value did change not overridden")
	}
}

public class RFOptionRowFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	public var selected: Bool = false

	public var context: AnyObject?
}

@available(*, unavailable, renamed: "RFOptionRowModel")
typealias OptionRowModel = RFOptionRowModel

@available(*, unavailable, renamed: "RFOptionPickerFormItem")
typealias OptionPickerFormItem = RFOptionPickerFormItem

@available(*, unavailable, renamed: "RFOptionRowFormItem")
typealias OptionRowFormItem = RFOptionRowFormItem
