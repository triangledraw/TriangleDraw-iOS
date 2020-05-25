// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension String {
	public func trim() -> String {
		return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
}
