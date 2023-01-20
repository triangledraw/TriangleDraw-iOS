// MIT license. Copyright (c) 2023 TriangleDraw. All rights reserved.

// swiftlint:disable:next identifier_name
public func remap<T: FloatingPoint>(_ value: T, _ a: T, _ b: T, _ c: T, _ d: T) -> T {
	return c + (d - c) * (value - a) / (b - a)
}
