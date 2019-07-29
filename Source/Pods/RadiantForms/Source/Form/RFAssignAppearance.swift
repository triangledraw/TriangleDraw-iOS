// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public protocol RFAssignAppearance {
	func assignDefaultColors()
	func assignTintColors()
}

@available(*, unavailable, renamed: "RFAssignAppearance")
typealias AssignAppearance = RFAssignAppearance
