// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFViewControllerFormItemPopContext {
	public let parentViewController: UIViewController
	public let childViewController: UIViewController
	public let cell: RFViewControllerCell
	public let returnedObject: AnyObject?

	public init(parentViewController: UIViewController, childViewController: UIViewController, cell: RFViewControllerCell, returnedObject: AnyObject?) {
		self.parentViewController = parentViewController
		self.childViewController = childViewController
		self.cell = cell
		self.returnedObject = returnedObject
	}
}

public class RFViewControllerFormItem: RFFormItem {
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

	@discardableResult
	public func viewController(_ aClass: UIViewController.Type) -> Self {
		createViewController = { (dismissCommand: RFCommandProtocol) in
			return aClass.init()
		}
		return self
	}

	@discardableResult
	public func storyboard(_ name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
		createViewController = { (dismissCommand: RFCommandProtocol) in
			let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: storyboardBundleOrNil)
			return storyboard.instantiateInitialViewController()
		}
		return self
	}

	// the view controller must invoke the dismiss block when it's being dismissed
	public typealias CreateViewController = (RFCommandProtocol) -> UIViewController?
	public var createViewController: CreateViewController?

	// dismissing the view controller
	public typealias PopViewController = (RFViewControllerFormItemPopContext) -> Void
	public var willPopViewController: PopViewController?
}

@available(*, unavailable, renamed: "RFViewControllerFormItemPopContext")
typealias ViewControllerFormItemPopContext = RFViewControllerFormItemPopContext

@available(*, unavailable, renamed: "RFViewControllerFormItem")
typealias ViewControllerFormItem = RFViewControllerFormItem
