// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

public class TriangleDrawFrameworkMeta {
	public let bundle: Bundle

	public init() {
		let bundleUrl: URL = Bundle.main.bundleURL
		let bundlePathExtension: String = bundleUrl.pathExtension
//		log.debug("bundleUrl: \(bundleUrl)\npathExtension: \(bundlePathExtension)")

		// `true` when invoked inside the `Thumbnail process`
		// `false` when invoked inside the `Main process`
		let isAppex: Bool = bundlePathExtension == "appex"

		if isAppex {
			self.bundle = Bundle.main
			return
		}

		self.bundle = Bundle.main
	}

	public var urlHexagonMask: URL {
		let resourceName = "hexagon_mask"
		guard let url: URL = self.bundle.url(forResource: resourceName, withExtension: "txt") else {
			log.error("no url for resource: \(resourceName)")
			fatalError("no url for resource: \(resourceName)")
		}
		return url
	}
}
