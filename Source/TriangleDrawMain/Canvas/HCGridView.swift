// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

class HCGridView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isOpaque = false
		self.isUserInteractionEnabled = false
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func draw(_ rect: CGRect) {
		UIColor.red.setStroke()
		let inset: CGFloat = 0.5
		let numberOfLines: Int = 4
		for i in 0...numberOfLines {
			let x = remap(CGFloat(i), 0, CGFloat(numberOfLines), bounds.minX + inset, bounds.maxX - inset)
			let point0 = CGPoint(x: x, y: bounds.minY)
			let point1 = CGPoint(x: x, y: bounds.maxY)
			let path = UIBezierPath()
			path.move(to: point0)
			path.addLine(to: point1)
			path.lineWidth = 1
			path.stroke()
		}
		for i in 0...numberOfLines {
			let y = remap(CGFloat(i), 0, CGFloat(numberOfLines), bounds.minY + inset, bounds.maxY - inset)
			let point0 = CGPoint(x: bounds.minX, y: y)
			let point1 = CGPoint(x: bounds.maxX, y: y)
			let path = UIBezierPath()
			path.move(to: point0)
			path.addLine(to: point1)
			path.lineWidth = 1
			path.stroke()
		}
	}
}
