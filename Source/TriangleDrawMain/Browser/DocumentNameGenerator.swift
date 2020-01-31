// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

class DocumentNameGenerator {
    class func defaultName(_ defaultNamex: String, existingNames: Set<AnyHashable>) -> String {
		let trimmedName: String = defaultNamex.trim()
        var defaultName = trimmedName
        // Return the desired name if it's available
        do {
            let collision: Bool = existingNames.contains(defaultName)
            if !collision {
                return defaultName
            }
            // success
        }
		// Special treatment to strings such as "My cool logo copy 42"
        var suffixNumber: Int = -1
        repeat {
            let pattern = "^(.*?) (\\d{1,6})$"
			guard let regex = try? NSRegularExpression(pattern: pattern) else {
				fatalError("failed to compile regex: \(pattern)")
			}
			let range = NSRange(location: 0, length: trimmedName.utf16.count)
			//print("range: \(range.location) \(range.length)  trimmedName: '\(trimmedName)'")
			guard let match: NSTextCheckingResult = regex.firstMatch(in: trimmedName, range: range) else {
				//print("no match for regex")
                break
            }
			if let r: Range = Range(match.range(at: 1), in: trimmedName) {
				defaultName = String(trimmedName[r])
				//print("rangeAt(1) = \(r)  => '\(defaultName)'")
            }
			if let r: Range = Range(match.range(at: 2), in: trimmedName) {
				let s = String(trimmedName[r])
				//print("rangeAt(2) = \(r)  => '\(s)'")
				suffixNumber = Int(s) ?? 0
			}
        } while false
        var firstCount: Int = 0
        if suffixNumber >= 0 {
            firstCount = suffixNumber
        }

		// Increment suffix number until we find a match
        var count = firstCount
        for _ in 0..<1000 {
			let name: String
			if count == 0 {
				name = defaultName
			} else {
				name = "\(defaultName) \(count)"
			}
			// Look for an existing document with the same name.
            let collision: Bool = existingNames.contains(name)
            if !collision {
				// success
                return name
            }
            // If none is found, increment the counter and try again.
            count += 1
        }

		fatalError("prevented infinite loop. unable to find a suitable name")
    }

    class func defaultNames(_ defaultNames: [String], existingNames: Set<AnyHashable>) -> [String] {
        var okNames = Set<AnyHashable>()
        for defaultName: String in defaultNames {
            if existingNames.contains(defaultName) {
                continue
            }
            _ = okNames.insert(defaultName)
        }
        var names = [String]()
        var taken = existingNames
        taken = taken.union(okNames)
        for defaultName: String in defaultNames {
            let name: String
            if okNames.contains(defaultName) {
                name = defaultName
            } else {
                name = DocumentNameGenerator.defaultName(defaultName, existingNames: taken)
            }
            _ = taken.insert(name)
            names.append(name)
        }
        return names
    }

    class func duplicateName(_ duplicateName: String, existingNames: Set<AnyHashable>, copyName: String) -> String {
		let trimmedName: String = duplicateName.trim()
        var defaultName = trimmedName
		// Special treatment to strings such as "My cool logo copy 42"
        var suffixNumber: Int = -1
        repeat {
            let pattern = "^(.*?) (\\d{1,6})$"
			guard let regex = try? NSRegularExpression(pattern: pattern) else {
				fatalError("failed to compile regex: \(pattern)")
			}
			let range = NSRange(location: 0, length: trimmedName.utf16.count)
			guard let match: NSTextCheckingResult = regex.firstMatch(in: trimmedName, range: range) else {
				break
			}
			if let r: Range = Range(match.range(at: 1), in: trimmedName) {
				defaultName = String(trimmedName[r])
			}
			var s1: String? = nil
			if let r: Range = Range(match.range(at: 2), in: trimmedName) {
				s1 = String(trimmedName[r])
			}
			suffixNumber = Int(s1 ?? "") ?? 0
        } while false

		// Append ' copy' suffix
        let nameWithCopySuffix: String
        if defaultName.hasSuffix(copyName) {
            nameWithCopySuffix = defaultName
        } else {
            nameWithCopySuffix = "\(trimmedName) \(copyName)"
            suffixNumber = -1
        }

		// Increment the counter and keep trying
		for _ in 0..<1000 {
			let name: String
            if suffixNumber == -1 {
                name = duplicateName
            } else if suffixNumber == 0 {
                name = nameWithCopySuffix
            } else {
                name = "\(nameWithCopySuffix) \(suffixNumber)"
            }
			// Look for an existing document with the same name.
            let collision0: Bool = existingNames.contains(name)
            let nameWithoutWhitespace = name.trim()
			let collision1: Bool = existingNames.contains(nameWithoutWhitespace)

			// Determine if the current name is good
            let collision: Bool = collision0 || collision1
            if !collision {
				// success
                return name
            }
            // If none is found, increment the counter and try again.
            suffixNumber += 1
        }

		fatalError("prevented infinite loop. unable to find a suitable name")
    }
}
