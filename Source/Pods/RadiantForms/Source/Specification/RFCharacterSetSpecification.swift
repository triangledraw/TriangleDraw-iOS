// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

/// Check if a string has no illegal characters.
public class RFCharacterSetSpecification: RFSpecification {
	private let characterSet: CharacterSet

	public init(characterSet: CharacterSet) {
		self.characterSet = characterSet
	}

	public static func charactersInString(_ charactersInString: String) -> RFCharacterSetSpecification {
		let cs = CharacterSet(charactersIn: charactersInString)
		return RFCharacterSetSpecification(characterSet: cs)
	}

	/// Check if all characters are contained in the characterset.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is a string and all its characters are legal, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let fullString = candidate as? String else { return false }
		for character: Character in fullString {
			let range: Range<String.Index>? =
			String(character).rangeOfCharacter(from: characterSet)
			if range == nil {
				return false // one or more characters does not satify the characterSet
			}
			if range!.isEmpty {
				return false // one or more characters does not satify the characterSet
			}
		}
		return true // the whole string satisfies the characterSet
	}
}

extension RFCharacterSetSpecification {
	public static var alphanumerics: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.alphanumerics)
	}
	public static var capitalizedLetters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.capitalizedLetters)
	}
	public static var controlCharacters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.controlCharacters)
	}
	public static var decimalDigits: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.decimalDigits)
	}
	public static var decomposables: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.decomposables)
	}
	public static var illegalCharacters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.illegalCharacters)
	}
	public static var letters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.letters)
	}
	public static var lowercaseLetters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.lowercaseLetters)
	}
	public static var newlines: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.newlines)
	}
	public static var nonBaseCharacters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.nonBaseCharacters)
	}
	public static var punctuationCharacters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.punctuationCharacters)
	}
	public static var symbols: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.symbols)
	}
	public static var uppercaseLetters: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.uppercaseLetters)
	}
	public static var urlFragmentAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlFragmentAllowed)
	}
	public static var urlHostAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlHostAllowed)
	}
	public static var urlPasswordAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlPasswordAllowed)
	}
	public static var urlPathAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlPathAllowed)
	}
	public static var urlQueryAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlQueryAllowed)
	}
	public static var urlUserAllowed: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.urlUserAllowed)
	}
	public static var whitespaces: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.whitespaces)
	}
	public static var whitespacesAndNewlines: RFCharacterSetSpecification {
		return RFCharacterSetSpecification(characterSet: CharacterSet.whitespacesAndNewlines)
	}
}

/// - warning:
/// These functions will be removed in the future, starting with RadiantForms 2.0.0
extension RFCharacterSetSpecification {
	public static func alphanumericCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.alphanumerics
	}

	public static func capitalizedLetterCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.capitalizedLetters
	}

	public static func controlCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.controlCharacters
	}

	public static func decimalDigitCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.decimalDigits
	}

	public static func decomposableCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.decomposables
	}

	public static func illegalCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.illegalCharacters
	}

	public static func lowercaseLetterCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.lowercaseLetters
	}

	public static func newlineCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.newlines
	}

	public static func nonBaseCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.nonBaseCharacters
	}

	public static func punctuationCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.punctuationCharacters
	}

	public static func symbolCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.symbols
	}

	public static func uppercaseLetterCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.uppercaseLetters
	}

	public static func whitespaceCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.whitespaces
	}

	public static func whitespaceAndNewlineCharacterSet() -> RFCharacterSetSpecification {
		return RFCharacterSetSpecification.whitespacesAndNewlines
	}
}

@available(*, unavailable, renamed: "RFCharacterSetSpecification")
typealias CharacterSetSpecification = RFCharacterSetSpecification
