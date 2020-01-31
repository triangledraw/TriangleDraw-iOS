// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

extension UIColor {
	// usage:
	// myButton.backgroundColor = UIColor.rgb(240, 10, 20)
	class func rgb(_ red: Int, _ green: Int, _ blue: Int) -> UIColor {
		return rgba(red, green, blue, 255)
	}
	
	// usage:
	// myButton.backgroundColor = UIColor.rgba(240, 10, 20, 20)
	class func rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int) -> UIColor {
		return UIColor(
			red  : CGFloat(red)   / 255.0,
			green: CGFloat(green) / 255.0,
			blue : CGFloat(blue)  / 255.0,
			alpha: CGFloat(alpha) / 255.0
		)
	}
	
	// usage:
	// myButton.backgroundColor = UIColor.hex(0xaabbcc)
	// or
	// myButton.backgroundColor = UIColor.hex(0xaabbcc, 0.4)
	class func hex(_ hex: Int, _ alpha: Double = 1.0) -> UIColor {
		let red   = Double((hex & 0xFF0000) >> 16) / 255.0
		let green = Double((hex & 0xFF00) >> 8) / 255.0
		let blue  = Double((hex & 0xFF)) / 255.0
		return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}
	
	struct ColorRGBA {
		var r: Int = 0
		var g: Int = 0
		var b: Int = 0
		var a: Int = 0
	}

	func rgba() -> ColorRGBA {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		var rgba = ColorRGBA()
		rgba.r = Int(r * 255.0)
		rgba.g = Int(g * 255.0)
		rgba.b = Int(b * 255.0)
		rgba.a = Int(a * 255.0)
		return rgba
	}
}
