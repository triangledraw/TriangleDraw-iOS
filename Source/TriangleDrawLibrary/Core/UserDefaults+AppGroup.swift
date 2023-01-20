// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.
import Foundation

extension UserDefaults {

    // swiftlint:disable:next identifier_name
	public static var td_appGroup: UserDefaults {
		guard let userDefault: UserDefaults = UserDefaults(suiteName: AppConstant.AppGroup.id) else {
			fatalError("Expected UserDefaults with suiteName for the AppGroup, but got nil")
		}
		return userDefault
	}

}
