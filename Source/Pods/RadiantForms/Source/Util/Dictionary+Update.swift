// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

extension Dictionary {
	/// merge two dictionaries into one dictionary
	mutating func rf_update(_ other: Dictionary) {
		for (key, value) in other {
			self.updateValue(value, forKey:key)
		}
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_update instead")
    mutating func update(_ other: Dictionary) {
        rf_update(other)
    }
}
