// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.

public class VerboseInfoProvider {
	public typealias Pair = (String, String)
	public var pairs = [Pair]()

	public init() {}

	public func append(_ key: String, _ value: String) {
		pairs.append((key, value))
	}
}

public protocol AcceptsVerboseInfoProvider {
	func verboseInfo(_ provider: VerboseInfoProvider)
}
