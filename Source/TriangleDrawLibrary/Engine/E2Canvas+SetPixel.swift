// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	public func setPixel(_ point: E2CanvasPoint, value: UInt8) {
		self.inner_setPixel(point: point, value: value)
	}

	public func setRawPixel(_ point: E2CanvasPoint, value: UInt8) {
		self.inner_setPixel(point: point, value: value, sanitize: false)
	}

	public func inner_setPixel(point: E2CanvasPoint, value: UInt8, sanitize: Bool = true) {
		let resultValue: UInt8
		if sanitize {
			// Ensure that the value is either 0 or 1
			resultValue = value & 1
		} else {
			resultValue = value
		}
		let x = point.x
		let y = point.y
		let x2: Int = x / 2
		let y2: Int = y / 2
		let w = Int(self.cellsPerRow)
		let h = Int(self.cellsPerColumn)
		if x2 < 0 || y2 < 0 {
			return
		}
		if x2 >= w || y2 >= h {
			return
		}
		let offset = y2 * w + x2
		if y & 1 != 0 {
			if x & 1 != 0 {
				self.cells[offset].br = resultValue
			} else {
				self.cells[offset].bl = resultValue
			}
		} else {
			if x & 1 != 0 {
				self.cells[offset].tr = resultValue
			} else {
				self.cells[offset].tl = resultValue
			}
		}
	}
}
