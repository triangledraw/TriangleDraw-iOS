// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.

public class VerboseInfoProvider {
	public typealias Pair = (String, String)
	public var pairs = Array<Pair>()

	public init() {}

	public func append(_ key: String, _ value: String) {
		pairs.append((key, value))
	}
}

public protocol AcceptsVerboseInfoProvider {
	func verboseInfo(_ provider: VerboseInfoProvider)
}
