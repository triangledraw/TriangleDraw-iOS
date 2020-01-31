// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.

public func clamp<T: FloatingPoint>(_ value: T, _ minValue: T, _ maxValue: T) -> T {
	if value <= minValue {
		return minValue
	}
	if value >= maxValue {
		return maxValue
	}
	return value
}

