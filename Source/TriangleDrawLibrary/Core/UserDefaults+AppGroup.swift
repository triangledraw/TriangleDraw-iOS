// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension UserDefaults {

	public static var td_appGroup: UserDefaults {
		guard let userDefault: UserDefaults = UserDefaults(suiteName: AppConstant.AppGroup.id) else {
			fatalError("Expected UserDefaults with suiteName for the AppGroup, but got nil")
		}
		return userDefault
	}

}
