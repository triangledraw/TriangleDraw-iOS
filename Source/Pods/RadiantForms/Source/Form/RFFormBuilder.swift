// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

class RFAlignLeft {
	fileprivate let items: [RFFormItem]
	init(items: [RFFormItem]) {
		self.items = items
	}
}

public enum RFToolbarMode {
	case none
	case simple
}

public class RFFormBuilder {
	private var innerItems = [RFFormItem]()
	private var alignLeftItems = [RFAlignLeft]()

	public init() {
	}
    
    /// Only invoke the `postPopulate()` function the very first time.
    internal var needsPostPopulate: Bool = true

	public var navigationTitle: String?

	public var toolbarMode: RFToolbarMode = .none

	public var suppressHeaderForFirstSection = false

	public func removeAll() {
		innerItems.removeAll()
	}

	@discardableResult
	public func append(_ item: RFFormItem) -> RFFormItem {
		innerItems.append(item)
		return item
	}

	public func appendMulti(_ items: [RFFormItem]) {
		innerItems += items
	}

	public func alignLeft(_ items: [RFFormItem]) {
		let alignLeftItem = RFAlignLeft(items: items)
		alignLeftItems.append(alignLeftItem)
	}

	public func alignLeftElementsWithClass(_ styleClass: String) {
		let items: [RFFormItem] = innerItems.filter { $0.styleClass == styleClass }
		alignLeft(items)
	}

	public var items: [RFFormItem] {
		return innerItems
	}

	public func dump(_ prettyPrinted: Bool = true) -> Data {
		return RFDumpVisitor.dump(prettyPrinted, items: innerItems)
	}

	public func result(_ viewController: UIViewController) -> RFTableViewSectionArray {
        let fontStrategy: RFFontStrategy = RFFontStrategySingleton.shared.resolve(viewController: viewController)
        let model = RFPopulateTableViewModel(viewController: viewController, toolbarMode: toolbarMode, fontStrategy: fontStrategy)

		let v = RFPopulateTableView(model: model)
		if suppressHeaderForFirstSection {
			v.installZeroHeightHeader()
		}
		for item in innerItems {
            if item.isHidden {
                continue
            }
			item.accept(visitor: v)
		}
		v.closeLastSection()

		for alignLeftItem in alignLeftItems {
			let widthArray: [CGFloat] = alignLeftItem.items.map {
				let v = RFObtainTitleWidth()
				$0.accept(visitor: v)
				return v.width
			}
			//RFLog("widthArray: \(widthArray)")
			let width = widthArray.max()!
			//RFLog("max width: \(width)")

			for item in alignLeftItem.items {
				let v = RFAssignTitleWidth(width: width)
				item.accept(visitor: v)
			}
		}

		return RFTableViewSectionArray(sections: v.sections)
	}

	public func validateAndUpdateUI() {
		RFReloadPersistentValidationStateVisitor.validateAndUpdateUI(innerItems)
	}

	public enum FormValidateResult {
		case valid
		case invalid(item: RFFormItem, message: String)
	}

	public func validate() -> FormValidateResult {
		for item in innerItems {
			let v = RFValidateVisitor()
			item.accept(visitor: v)
			switch v.result {
			case .valid:
				// RFLog("valid")
				continue
			case .hardInvalid(let message):
				//RFLog("invalid message \(message)")
				return .invalid(item: item, message: message)
			case .softInvalid(let message):
				//RFLog("invalid message \(message)")
				return .invalid(item: item, message: message)
			}
		}
		return .valid
	}

}

/// Append one `RFFormItem` instance to the builder.
public func += (left: RFFormBuilder, right: RFFormItem) {
    left.append(right)
}

/// Append multiple `RFFormItem` instances to the builder.
public func += (left: RFFormBuilder, right: [RFFormItem]) {
    right.forEach { left.append($0) }
}

@available(*, unavailable, renamed: "RFAlignLeft")
typealias AlignLeft = RFAlignLeft

@available(*, unavailable, renamed: "RFToolbarMode")
typealias ToolbarMode = RFToolbarMode

@available(*, unavailable, renamed: "RFFormBuilder")
typealias FormBuilder = RFFormBuilder
