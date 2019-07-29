// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public protocol RFCommandProtocol {
	func execute(viewController: UIViewController, returnObject: AnyObject?)
}

public class RFCommandBlock: RFCommandProtocol {
	public let block: (UIViewController, AnyObject?) -> Void
	public init(block: @escaping (UIViewController, AnyObject?) -> Void) {
		self.block = block
	}

	public func execute(viewController: UIViewController, returnObject: AnyObject?) {
		block(viewController, returnObject)
	}
}

@available(*, unavailable, renamed: "RFCommandProtocol")
typealias CommandProtocol = RFCommandProtocol

@available(*, unavailable, renamed: "RFCommandBlock")
typealias CommandBlock = RFCommandBlock
