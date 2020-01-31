// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

class SystemInfo {
	static var systemInfo: String {
        var items = [String]()

		func append(_ key: String, _ value: String) {
			items.append("\(key): \(value)")
		}

        do {
			append("App Version", appVersion)
			append("App Creation Date", creationDateString)
			append("App XCBuildConfiguration", xcBuildConfiguration.rawValue)
			append("Device iOS", UIDevice.current.systemVersion)
			append("Device Kind", unameMachine)
        }
        do {
            let size: CGSize = UIScreen.main.bounds.size
			append("Device Screen", "\(size.width.string0)x\(size.height.string0)")
        }
		do {
			let languages = NSLocale.preferredLanguages
			let languagesPretty: String = languages.joined(separator: " ")
			append("User Languages", languagesPretty)
		}
        return items.joined(separator: "\n")
    }

	enum DeviceType {
		case realDevice
		case simulator
	}

	static var deviceType: DeviceType {
		#if targetEnvironment(simulator)
			return DeviceType.simulator
		#else
			return DeviceType.realDevice
		#endif
	}

	enum XCBuildConfiguration: String {
	case debug
	case release
	}

	static var xcBuildConfiguration: XCBuildConfiguration {
		#if DEBUG
		return XCBuildConfiguration.debug
		#else
		return XCBuildConfiguration.release
		#endif
	}

	// Returns `true` if we are currently being unittested.
	static var areWeBeingUnitTested: Bool {
		let env = ProcessInfo.processInfo.environment
		return env.keys.contains("XCTestConfigurationFilePath")
	}

	static var appVersion: String {
		return self.cfBundleShortVersionString
	}

	static var cfBundleShortVersionString: String {
		guard let string = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return "N/A"
		}
		return string
	}

	static var cfBundleVersion: String {
		guard let string = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
			return "N/A"
		}
		return string
	}

	static var creationDate: Date? {
		guard let infoPath = Bundle.main.path(forResource: "Info.plist", ofType: nil) else {
			return nil
		}
		guard let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath) else {
			return nil
		}
		let key = FileAttributeKey(rawValue: "NSFileCreationDate")
		guard let infoDate = infoAttr[key] as? Date else {
			return nil
		}
		return infoDate
	}

	static var creationDateString: String {
		guard let date = creationDate else {
			return "Unknown"
		}
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter.string(from: date)
	}


	/// Obtain the machine hardware platform from the `uname()` unix command
	///
	/// Example of return values
	///  - `"iPhone8,1"` = iPhone 6s
	///  - `"iPad6,7"` = iPad Pro (12.9-inch)
	static var unameMachine: String {
		var utsnameInstance = utsname()
		uname(&utsnameInstance)
		let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}
		return optionalString ?? "N/A"
	}
}
