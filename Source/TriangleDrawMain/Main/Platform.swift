// MIT license. Copyright (c) 2021 TriangleDraw. All rights reserved.
import UIKit

class Platform {
	static var is_ideom_ipad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
}
