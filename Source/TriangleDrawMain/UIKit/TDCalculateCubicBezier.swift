// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import QuartzCore

class TDCalculateBezierPoint {
	static func calculate(t: CGFloat, p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint {
		let u: CGFloat = 1.0 - t
		let tt: CGFloat = t * t
		let uu: CGFloat = u * u
		let uuu: CGFloat = uu * u
		let ttt: CGFloat = tt * t
		var x: CGFloat = uuu * p0.x
		x += 3 * uu * t * p1.x
		x += 3 * u * tt * p2.x
		x += ttt * p3.x
		var y: CGFloat = uuu * p0.y
		y += 3 * uu * t * p1.y
		y += 3 * u * tt * p2.y
		y += ttt * p3.y
		return CGPoint(x: x, y: y)
	}

	static func easeInEaseOut(t: CGFloat) -> CGPoint {
		let f = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

		var a:[Float] = [0.0, 0.0]
		var b:[Float] = [0.0, 0.0]
		var c:[Float] = [0.0, 0.0]
		var d:[Float] = [0.0, 0.0]

		f.getControlPoint(at: 0, values: &a)
		f.getControlPoint(at: 1, values: &b)
		f.getControlPoint(at: 2, values: &c)
		f.getControlPoint(at: 3, values: &d)

		let p0 = CGPoint(x: CGFloat(a[0]), y: CGFloat(a[1]))
		let p1 = CGPoint(x: CGFloat(b[0]), y: CGFloat(b[1]))
		let p2 = CGPoint(x: CGFloat(c[0]), y: CGFloat(c[1]))
		let p3 = CGPoint(x: CGFloat(d[0]), y: CGFloat(d[1]))

		return calculate(t: t, p0: p0, p1: p1, p2: p2, p3: p3)
	}
}
