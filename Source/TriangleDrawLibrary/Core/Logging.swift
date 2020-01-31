// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import SwiftyBeaver

public let log = SwiftyBeaver.self

public class LogHelper {
	/// Setup logging for the Main process
	///
	/// When the app is launched with Xcode attached, then we want the log
	/// to be printed to the Xcode console.
	///
	/// When the app is launched without Xcode attached, then we want the log
	/// to be written to the os_log(), that can be seen via the `Console.app`.
	/// In order to see these log messages, do like this:
	/// Do a search query where subsystem **equals** "com.triangledraw.td3".
	/// Search queries uses `Contains` by default, and have to be changed to `Equals`,
	/// otherwise log messages from the `Thumbnail process` will be shown.
	public static func setup_mainExecutable() {

		guard Thread.isMainThread else {
			fatalError("Assuming that setup happens in main thread")
		}

		// https://stackoverflow.com/questions/4744826/detecting-if-ios-app-is-run-in-debugger
		let value: String = ProcessInfo.processInfo.environment["TD_RUN_IN_DEBUGGER"] ?? ""
		let debuggerAttached: Bool = (value == "true")

		if debuggerAttached {
			addConsoleDestination(SwiftyBeaver.Level.verbose)
		} else {
			addOSLogDestination(SwiftyBeaver.Level.verbose)
		}

		//log.debug("debuggerAttached: \(debuggerAttached)")

		//logDiagnosticsMessages()
	}

	/// Setup logging for the Thumbnail process
	///
	/// AFAIK there is no way of seeing the log messages inside Xcode.
	/// Inspecting log messages for NSExtensions, here it's necessary to use the `Console.app`.
	///
	/// We always want the log to be written to the os_log(), that can be seen via the `Console.app`.
	/// In order to see these log messages, do like this:
	/// Do a search query where subsystem **equals** "com.triangledraw.td3.thumbnail".
	/// Search queries uses `Contains` by default, and have to be changed to `Equals`,
	/// otherwise log messages from the `Main process` will be shown.
	public static func setup_thumbnailExecutable() {
		addOSLogDestination(SwiftyBeaver.Level.verbose)
		//logDiagnosticsMessages()
	}

	private static func addConsoleDestination(_ minLevel: SwiftyBeaver.Level) {
		let destination = ConsoleDestination()
		destination.levelColor.applyDefaultStyle()
		destination.minLevel = minLevel
		destination.asynchronously = false
		log.addDestination(destination)
	}

	private static func addOSLogDestination(_ minLevel: SwiftyBeaver.Level) {
		for destination: BaseDestination in log.destinations {
			if type(of: destination) == OSLogDestination.self {
				//log.warning("There is alreay an instance created. No need to create one more.")
				return
			}
		}

		let destination = OSLogDestination()
		destination.minLevel = minLevel
		destination.asynchronously = false
		log.addDestination(destination)
	}

	public static func logDiagnosticsMessages() {
		log.verbose("verbose example")
		log.debug("debug example")
		log.info("info example")
		log.warning("warning example")
		log.error("error example")
	}
}

fileprivate extension BaseDestination.LevelColor {
	mutating func applyDefaultStyle() {
		debug   = "🏐 "
		info    = "🏐 "
		verbose = "🏐 "
		error   = "⛔️ "
		warning = "⚠️ "
	}
}
