// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension Date {
	/// Returns strings like: `"1999-12-31T23:59:59Z"`
	public var iso8601: String {
		return ISO8601DateFormatter().string(from: self)
	}
}
