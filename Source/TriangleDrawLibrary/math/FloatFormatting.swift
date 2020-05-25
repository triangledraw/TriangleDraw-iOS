// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation
import CoreGraphics

extension CGFloat {
	public var string0: String {
		return String(format: "%.0f", self)
	}
	public var string1: String {
		return String(format: "%.1f", self)
	}
	public var string2: String {
		return String(format: "%.2f", self)
	}
}

extension Float {
	public var string0: String {
		return String(format: "%.0f", self)
	}
	public var string1: String {
		return String(format: "%.1f", self)
	}
	public var string2: String {
		return String(format: "%.2f", self)
	}
}

extension Double {
	public var string0: String {
		return String(format: "%.0f", self)
	}
	public var string1: String {
		return String(format: "%.1f", self)
	}
	public var string2: String {
		return String(format: "%.2f", self)
	}
}

extension CGPoint {
	public var string0: String {
		return "(\(self.x.string0), \(self.y.string0))"
	}
	public var string1: String {
		return "(\(self.x.string1), \(self.y.string1))"
	}
	public var string2: String {
		return "(\(self.x.string2), \(self.y.string2))"
	}
}

extension CGSize {
	public var string0: String {
		return "(\(self.width.string0), \(self.height.string0))"
	}
	public var string1: String {
		return "(\(self.width.string1), \(self.height.string1))"
	}
	public var string2: String {
		return "(\(self.width.string2), \(self.height.string2))"
	}
}
