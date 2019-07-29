// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public enum RFValidateRule {
	case hardRule(specification: RFSpecification, message: String)
	case softRule(specification: RFSpecification, message: String)
	case submitRule(specification: RFSpecification, message: String)
}

public class RFValidatorBuilder {
	fileprivate var rules = [RFValidateRule]()

	public init() {}

	public func hardValidate(_ specification: RFSpecification, message: String) {
		rules.append(RFValidateRule.hardRule(specification: specification, message: message))
	}

	public func softValidate(_ specification: RFSpecification, message: String) {
		rules.append(RFValidateRule.softRule(specification: specification, message: message))
	}

	public func submitValidate(_ specification: RFSpecification, message: String) {
		rules.append(RFValidateRule.submitRule(specification: specification, message: message))
	}

	public func build() -> RFValidator {
		return RFValidator(rules: self.rules)
	}
}

public class RFValidator {
	fileprivate let rules: [RFValidateRule]

	public init(rules: [RFValidateRule]) {
		self.rules = rules
	}

	public func liveValidate(_ candidate: Any?) -> RFValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: false)
	}

	public func submitValidate(_ candidate: Any?) -> RFValidateResult {
		return validate(candidate, checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
	}

	public func validate(_ candidate: Any?, checkHardRule: Bool, checkSoftRule: Bool, checkSubmitRule: Bool) -> RFValidateResult {
		var results = [RFValidateResult]()
		for rule in rules {
			switch rule {
			case let .hardRule(specification, message):
				if checkHardRule && !specification.isSatisfiedBy(candidate) {
					return .hardInvalid(message: message)
				}
			case let .softRule(specification, message):
				if checkSoftRule && !specification.isSatisfiedBy(candidate) {
					results.append(.softInvalid(message: message))
				}
			case let .submitRule(specification, message):
				if checkSubmitRule && !specification.isSatisfiedBy(candidate) {
					return .hardInvalid(message: message)
				}
			}
		}
		if results.isEmpty {
			return .valid
		}
		return results[0]
	}
}


@available(*, unavailable, renamed: "RFValidateRule")
typealias ValidateRule = RFValidateRule

@available(*, unavailable, renamed: "RFValidatorBuilder")
typealias ValidatorBuilder = RFValidatorBuilder

@available(*, unavailable, renamed: "RFValidator")
typealias Validator = RFValidator
