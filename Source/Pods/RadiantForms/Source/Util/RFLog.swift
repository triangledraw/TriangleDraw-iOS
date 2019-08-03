// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

/// `Print` with additional info such as linenumber, filename
///
/// http://stackoverflow.com/questions/24114288/macros-in-swift
#if DEBUG
	func RFLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
		print("[\(file):\(line)] \(function) - \(message)")
	}
#else
	func RFLog(_ message: String, function: String = #function, file: String = #file, line: Int = #line) {
		// do nothing
	}
#endif
