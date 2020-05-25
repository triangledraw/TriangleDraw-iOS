// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public enum SymmetryMode: String, CaseIterable {
	case noSymmetry = "none"
	case flipX = "flipx"
	case flipY = "flipy"
	case flipXY = "flipxy"
	case way3 = "3way"
	case way6 = "6way"
}

extension SymmetryMode {
	public var localizedDisplayName: String {
		switch self {
		case .noSymmetry:
			return "None"
		case .flipX:
			return "Flip X"
		case .flipY:
			return "Flip Y"
		case .flipXY:
			return "Flip XY"
		case .way3:
			return "3 Way"
		case .way6:
			return "6 Way"
		}
	}
}

public var globalSymmetryMode = SymmetryMode.noSymmetry

extension E2Canvas {
	public func setSymmetricPixel(_ point: E2CanvasPoint, value: UInt8, symmetryMode: SymmetryMode) {
		self.inner_setPixel(point: point, value: value)

		switch symmetryMode {
		case .noSymmetry:
			()
		case .flipX:
			let pointX = point.flipX(size: self.size)
			self.inner_setPixel(point: pointX, value: value)
		case .flipY:
			let pointY = point.flipY(size: self.size)
			self.inner_setPixel(point: pointY, value: value)
		case .flipXY:
			let pointX = point.flipX(size: self.size)
			self.inner_setPixel(point: pointX, value: value)
			let pointY = point.flipY(size: self.size)
			self.inner_setPixel(point: pointY, value: value)
			let pointXY = point.flipX(size: self.size).flipY(size: self.size)
			self.inner_setPixel(point: pointXY, value: value)
		case .way3:
			let rotater = E2CanvasClockwiseRotater(canvas: self)
			if let p1: E2CanvasPoint = rotater.convert(pointInput: point) {
				if let p2: E2CanvasPoint = rotater.convert(pointInput: p1) {
					self.inner_setPixel(point: p2, value: value)
					if let p3: E2CanvasPoint = rotater.convert(pointInput: p2) {
						if let p4: E2CanvasPoint = rotater.convert(pointInput: p3) {
							self.inner_setPixel(point: p4, value: value)
						}
					}
				}
			}
		case .way6:
			let rotater = E2CanvasClockwiseRotater(canvas: self)
			if let p1: E2CanvasPoint = rotater.convert(pointInput: point) {
				self.inner_setPixel(point: p1, value: value)
				if let p2: E2CanvasPoint = rotater.convert(pointInput: p1) {
					self.inner_setPixel(point: p2, value: value)
					if let p3: E2CanvasPoint = rotater.convert(pointInput: p2) {
						self.inner_setPixel(point: p3, value: value)
						if let p4: E2CanvasPoint = rotater.convert(pointInput: p3) {
							self.inner_setPixel(point: p4, value: value)
							if let p5: E2CanvasPoint = rotater.convert(pointInput: p4) {
								self.inner_setPixel(point: p5, value: value)
							}
						}
					}
				}
			}
		}
	}
}
