// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import CoreGraphics

/// A vector of 2 signed integers.
///
/// This struct is inspired by Metal's `intvec2` type and GLSL's `ivec2` type.
public struct IntVec2 {
	public var x: Int32
	public var y: Int32
}

extension IntVec2 {
	/// Returns a new vector that is offset from that of the source vector.
	///
	/// - Parameters:
	///   - dx: The offset value for the `x`-coordinate.
	///   - dy: The offset value for the `y`-coordinate.
	public func offsetBy(dx: Int32, dy: Int32) -> IntVec2 {
		return IntVec2(x: self.x + dx, y: self.y + dy)
	}

	/// The vector with the value `(0, 0)`.
	public static var zero: IntVec2 {
		return IntVec2(x: 0, y: 0)
	}
}

extension IntVec2: Equatable {

	/// Returns a Boolean value indicating whether two values are equal.
	///
	/// Equality is the inverse of inequality. For any values `a` and `b`,
	/// `a == b` implies that `a != b` is `false`.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	public static func == (lhs: IntVec2, rhs: IntVec2) -> Bool {
		guard lhs.x == rhs.x else {
			return false
		}
		guard lhs.y == rhs.y else {
			return false
		}
		return true
	}
}

extension IntVec2: CustomDebugStringConvertible {
	/// A textual representation of this instance, suitable for debugging.
	///
	/// Calling this property directly is discouraged. Instead, convert an
	/// instance of any type to a string by using the `String(reflecting:)`
	/// initializer. This initializer works with any type, and uses the custom
	/// `debugDescription` property for types that conform to
	/// `CustomDebugStringConvertible`:
	///
	///     struct Point: CustomDebugStringConvertible {
	///         let x: Int, y: Int
	///
	///         var debugDescription: String {
	///             return "(\(x), \(y))"
	///         }
	///     }
	///
	///     let p = Point(x: 21, y: 30)
	///     let s = String(reflecting: p)
	///     print(s)
	///     // Prints "(21, 30)"
	///
	/// The conversion of `p` to a string in the assignment to `s` uses the
	/// `Point` type's `debugDescription` property.
	public var debugDescription: String {
		return "(\(x), \(y))"
	}
}

extension IntVec2 {
	/// Returns a CGPoint initialized with the `x` and `y` coordinates.
	public var cgPoint: CGPoint {
		return CGPoint(x: Int(self.x), y: Int(self.y))
	}
}
