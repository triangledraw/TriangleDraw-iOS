// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

extension E2Canvas {
	/// - Converts the character `"-"` to the value `0`.
	/// - Converts the character `"*"` to the value `1`.
	public func load(fromStringRepresentation aString: String) {
		clearWithBlackColor()
		let scanner = Scanner(string: aString)
		let spaceSet = CharacterSet(charactersIn: " \t")
		scanner.charactersToBeSkipped = spaceSet
		let cset = CharacterSet(charactersIn: "*-\n")
		var x: Int = 0
		var y: Int = 0
		var retries: Int = 10
		while !scanner.isAtEnd {
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
