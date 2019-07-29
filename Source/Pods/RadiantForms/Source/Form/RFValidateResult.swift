// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public enum RFValidateResult: Equatable {
	case valid
	case hardInvalid(message: String)
	case softInvalid(message: String)
}

public func ==(lhs: RFValidateResult, rhs: RFValidateResult) -> Bool {
	switch (lhs, rhs) {
	case (.valid, .valid):
		return true
	case let (.hardInvalid(messageA), .hardInvalid(messageB)):
		return messageA == messageB
	case let (.softInvalid(messageA), .softInvalid(messageB)):
		return messageA == messageB
	default:
		return false
	}
}

@available(*, unavailable, renamed: "RFValidateResult")
typealias ValidateResult = RFValidateResult
