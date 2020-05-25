// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension URL {
	/// From a long url like
	///
	///    file:///var/mobile/Containers/Data/Application/1FB629DF-2E96-4047-BF06-373BB57A1965/Documents/Mona%20Lisa.triangleDraw/
	///
	/// It only returns the string `Mona Lisa`
	///
	/// Nowadays it's common to use Emoji's inside filenames, like this:
	///
	///    file:///var/mobile/Containers/Data/Application/1FB629DF-2E96-4047-BF06-373BB57A1965/Documents/%F0%9F%87%B0%F0%9F%87%AA.triangleDraw/
	///
	/// It only returns the string `🇰🇪`
	public var triangleDraw_displayName: String {
		let percentEncodedString: String = self.deletingPathExtension().lastPathComponent
		guard let decodedString: String = percentEncodedString.removingPercentEncoding else {
			log.error("Unable to removingPercentEncoding from string: '\(percentEncodedString)'")
			return percentEncodedString
		}
		return decodedString
	}
}
