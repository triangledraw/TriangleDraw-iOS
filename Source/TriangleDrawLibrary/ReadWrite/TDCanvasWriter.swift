// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public class TDCanvasWriter {
    public class func pbmRepresentation(from canvas: E2Canvas) -> Data {
        let width: Int = Int(canvas.width)
        let height: Int = Int(canvas.height)
        var rows = [String]()
        rows.append("P1")
        rows.append("# {\"FileFormat\":3,\"ToolName\":\"TriangleDraw-iOS\",\"ToolVersion\":\"2020.5.26\"}")
        rows.append("\(width) \(height)")
        for y in 0..<height {
            var cells = [String]()
            for x in 0..<width {
				let value: UInt8 = canvas.getPixelX(Int(x), y: Int(y))
                cells.append("\(value)")
            }
            rows.append(cells.joined(separator: " "))
        }
        let resultString = rows.joined(separator: "\n")
        return resultString.data(using: .utf8, allowLossyConversion: true) ?? Data()
    }
}
