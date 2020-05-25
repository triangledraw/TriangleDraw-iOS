// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	/// - Converts the character `"-"` to the value `0`.
	/// - Converts the character `"*"` to the value `1`.
	public func load(fromStringRepresentation aString: String) {
		clearWithBlackColor()
		// Workaround skipping the ASCII character 0x0D aka. "Carriage return"
		// Before iOS13 the Scanner skipped the 0x0D character without problems.
		// However with iOS13 the Scanner.charactersToBeSkipped can no longer skip the 0x0D character.
		// So the string have to be sanitized for unwanted characters, before using the scanner.
		//
		// Furthermore remove TABs and SPACEs.
		let cleanedString: String = aString.replacingOccurrences(of: "[\\r\\t ]", with: "", options: .regularExpression)
		let scanner = Scanner(string: cleanedString)
		scanner.charactersToBeSkipped = CharacterSet()
		let cset = CharacterSet(charactersIn: "*-\n")
		var x: Int = 0
		var y: Int = 0
		var retries: Int = 10
		while !scanner.isAtEnd {
			if #available(iOS 13.0, *) {
				_ = scanner.scanUpToCharacters(from: cset)
				if scanner.scanString("\n") != nil {
					y += 1
					x = 0
				} else if scanner.scanString("*") != nil {
					let point: E2CanvasPoint = E2CanvasPoint(x: x, y: y)
					setPixel(point, value: 1)
					x += 1
				} else if scanner.scanString("-") != nil {
					let point: E2CanvasPoint = E2CanvasPoint(x: x, y: y)
					setPixel(point, value: 0)
					x += 1
				} else {
					retries -= 1
				}
			} else {
				scanner.scanUpToCharacters(from: cset, into: nil)
				if scanner.scanString("\n", into: nil) {
					y += 1
					x = 0
				} else if scanner.scanString("*", into: nil) {
					let point: E2CanvasPoint = E2CanvasPoint(x: x, y: y)
					setPixel(point, value: 1)
					x += 1
				} else if scanner.scanString("-", into: nil) {
					let point: E2CanvasPoint = E2CanvasPoint(x: x, y: y)
					setPixel(point, value: 0)
					x += 1
				} else {
					retries -= 1
				}
			}
			if retries <= 0 {
				log.error("Too many retries. Failed to parse")
				break
			}
		}
	}

	public var stringRepresentation: String {
		var s = ""
		for j: UInt in 0..<self.cellsPerColumn {
			if j > 0 {
				s += "\n"
			}
			for i: UInt in 0..<self.cellsPerRow {
				let offset = Int(j * self.cellsPerRow + i)
				let cell: E2TriangleCell = self.cells[offset]
				let s_l = (cell.tl == 1) ? "*" : "-"
				s += s_l
				let s_r = (cell.tr == 1) ? "*" : "-"
				s += s_r
			}
			s += "\n"
			for i: UInt in 0..<self.cellsPerRow {
				let offset = Int(j * self.cellsPerRow + i)
				let cell: E2TriangleCell = self.cells[offset]
				let s_l = (cell.bl == 1) ? "*" : "-"
				s += s_l
				let s_r = (cell.br == 1) ? "*" : "-"
				s += s_r
			}
		}
		return s
	}
}
