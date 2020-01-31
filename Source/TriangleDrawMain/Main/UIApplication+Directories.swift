// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIApplication {
	static func cacheDirectory() -> URL {
		guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
			fatalError("unable to get system cache directory - serious problems")
		}
		return cacheURL
	}

	static func documentsDirectory() -> URL {
		guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
			fatalError("unable to get system docs directory - serious problems")
		}
		return documentsURL
	}
}
