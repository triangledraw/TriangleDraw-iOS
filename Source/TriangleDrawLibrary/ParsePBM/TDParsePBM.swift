// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

/***************************************
 TriangleDraw's file format is modelled after the Netpbm file format .PBM
 See http://en.wikipedia.org/wiki/Netpbm_format#PBM_example
 
 
 P1
 # This is an example bitmap of the letter "J"
 6 10
 0 0 0 0 1 0
 0 0 0 0 1 0
 0 0 0 0 1 0
 0 0 0 0 1 0
 0 0 0 0 1 0
 0 0 0 0 1 0
 1 0 0 0 1 0
 0 1 1 1 0 0
 0 0 0 0 0 0
 0 0 0 0 0 0
 
 ***************************************/
public struct TDParsePBMData {
    public var width: Int
    public var height: Int
    public var cells: [Int]
	public var comments: [String]
}

public class TDParsePBM: NSObject {
    public var data = TDParsePBMData(width: 0, height: 0, cells: [], comments: [])

	public class func parse(_ input: Data?) throws -> TDParsePBM {
        let pbm = TDParsePBM()
		let (ok, message) = pbm.parse(input)
        if !ok {
			throw NSError(domain: "ParsePBM", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
        }
        return pbm
    }

	public var stringRepresentation: String? {
        var result = [String]()
        let n: Int = data.width * data.height
        for i in 0..<n {
            let value: Int = data.cells[i]
            result.append("\(value)")
        }
        return result.joined(separator: " ")
    }

	public func parse(_ inputData: Data?) -> (Bool, String) {
        var input: String! = nil
        if let aData = inputData {
            input = String(data: aData, encoding: .utf8)
        }
        guard input != nil else {
            return (false, "Parser was given a NSData parameter that is not UTF8. Cannot parse.")
        }
		let unfilterdRows: [String] = input.components(separatedBy: CharacterSet.newlines)
		// Accumulate data rows and comment rows
		var commentRows = [String]()
        var rawDataRows = [String]()
        for row: String in unfilterdRows {
            if row.isEmpty {
                continue
            }
            if row.hasPrefix("#") {
				commentRows.append(row)
			} else {
				rawDataRows.append(row)
			}
        }
		data.comments = commentRows
        if rawDataRows.count < 2 {
            return (false, "File format is not wellformed. Cannot parse.")
        }
        // Check that header is P1
        do {
            guard rawDataRows[0] == "P1" else {
                return (false, "The PBM file format must start with P1 in the first line. Cannot parse.")
            }
        }
        // Read width & height
        do {
			let row: String = rawDataRows[1]
            let scanner = Scanner(string: row)
            scanner.charactersToBeSkipped = CharacterSet.whitespaces
            let ok0: Bool = scanner.scanInt(&data.width)
            let ok1: Bool = scanner.scanInt(&data.height)
            let ok2: Bool = scanner.isAtEnd
            let ok: Bool = ok0 && ok1 && ok2
            if !ok {
                return (false, "Width and Height must be positive integer numbers. Cannot parse.")
            }
            if data.width < 1 {
                return (false, "Width must be positive integer numbers. Cannot parse.")
            }
            if data.height < 1 {
                return (false, "Height must be positive integer numbers. Cannot parse.")
            }
            let dataRowCount: Int = rawDataRows.count - 2
            if data.height != dataRowCount {
                return (false, "Height be consistent with the number rows with pixel data. Cannot parse.")
            }
        }
        // Read cell data
		let capacity = data.width * data.height
		var cells: [Int] = [Int](repeating: 0, count: capacity)
		let dataRows: [String] = Array(rawDataRows.dropFirst(2))
		for (rowIndex, dataRow) in dataRows.enumerated() {
            let scanner = Scanner(string: dataRow)
            scanner.charactersToBeSkipped = CharacterSet.whitespaces
            for i in 0..<data.width {
                if scanner.isAtEnd {
                    return (false, "Width be consistent with the number columns with pixel data. Cannot parse.")
                }
                var value: Int = 0
                let ok: Bool = scanner.scanInt(&value)
                if !ok {
                    return (false, "PBM only supports black+white. Cannot parse.")
                }
                let valueOK: Bool = value == 0 || value == 1
                if !valueOK {
                    return (false, "PBM only supports black+white. Cannot parse.")
                }
				let index = rowIndex * data.width + i
				cells[index] = value
            }
            if !scanner.isAtEnd {
                return (false, "Width be consistent with the number columns with pixel data. Cannot parse.")
            }
        }
        // Successfully read file
		data.cells = cells
        return (true, "Successfully read file")
    }
}
