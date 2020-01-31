// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

/*
An E2TriangleCell represent 4 triangles.

tl = top left
tr = top right
bl = bottom left
br = bottom right

********************
*               *   *
*    tl     *       *
*       *     tr    *
*   *               *
*********************
*   *       br      *
*       *           *
*     bl    *       *
*               *   *
********************

*/
public struct E2TriangleCell {
	public var tl: UInt8 = 0
	public var tr: UInt8 = 0
	public var bl: UInt8 = 0
	public var br: UInt8 = 0
}

extension E2TriangleCell: Equatable {
	public static func == (lhs: E2TriangleCell, rhs: E2TriangleCell) -> Bool {
		let same_tl: Bool = lhs.tl == rhs.tl
		let same_tr: Bool = lhs.tr == rhs.tr
		let same_bl: Bool = lhs.bl == rhs.bl
		let same_br: Bool = lhs.br == rhs.br
		return same_tl && same_tr && same_bl && same_br
	}
}
