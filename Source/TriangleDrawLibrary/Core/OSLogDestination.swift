// The MIT License (MIT)
//
// Copyright (c) 2018 Jean-Charles SORIN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import SwiftyBeaver
import os

final class OSLogDestination: BaseDestination {

	override func send(_ level: SwiftyBeaver.Level,
					   msg: String,
					   thread: String,
					   file: String,
					   function: String,
					   line: Int,
					   context: Any?) -> String? {

		let log = self.createOSLog(context: context)
		let fileName: String = self.osLogFileNameOfFile(file)

		os_log("%{public}@.%{public}@:%i\n%{public}@",
			   log: log,
			   type: self.osLogLevelRelated(to: level),
			   fileName, function, line, msg)

		return super.send(level,
						  msg: msg,
						  thread: thread,
						  file: file,
						  function: function,
						  line: line)
	}

}

private extension OSLogDestination {

	func createOSLog(context: Any?) -> OSLog {
		var currentContext = "Default"
		if let loggerContext = context as? String {
			currentContext = loggerContext
		}
		let subsystem = Bundle.main.bundleIdentifier ?? "com.logger.default"
		let customLog = OSLog(subsystem: subsystem, category: currentContext)
		return customLog
	}

	func osLogLevelRelated(to swiftyBeaverLogLevel: SwiftyBeaver.Level) -> OSLogType {
		var logType: OSLogType
		switch swiftyBeaverLogLevel {
		case .debug:
			// https://forums.developer.apple.com/thread/82736#347949
			//
			// Sadly the `OSLogType.debug` doesn't get shown in the Console app
			// Solution is to use the commandline tool `log`, like this:
			// xcrun simctl spawn 14B7E27B-1159-4F7F-BA4C-BB480E6B36EB log stream --level debug
			// It's painful to type this in every time.
			//
			// An easier solution is to use `OSLogType.default`.
			logType = .default
		case .verbose:
			logType = .default
		case .info:
			logType = .info
		case .warning:
			// We use `.error` here because of 🔶 indicator in the Console app.
			logType = .error
		case .error:
			// We use `.fault` here because of 🔴 indicator in the Console app.
			logType = .fault
		}

		return logType
	}
	
	/// Identical to BaseDestination.fileNameOfFile() which is internal to SwiftyBeaver
	func osLogFileNameOfFile(_ file: String) -> String {
		let fileParts = file.components(separatedBy: "/")
		if let lastPart = fileParts.last {
			return lastPart
		}
		return ""
	}
}
