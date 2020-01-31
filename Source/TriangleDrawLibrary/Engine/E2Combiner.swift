// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation


public struct E2TriangleTagCell {
    var tl: Int = 0
    var tr: Int = 0
    var bl: Int = 0
    var br: Int = 0
}


public class E2Combiner {
    /*
     Create an E2Combiner instance with a canvas
     */

    private let canvas: E2Canvas
    private var tagPairs = [E2TagPair]()

    private var tagCells = [E2TriangleTagCell]()

    /*
     PURPOSE:
     Identify which polygon a triangle belong to.
     
     The algorithm is roughly like this:
     
     Assign the number 1 to the top-left most triangle.
     Traverse over all triangles in the canvas.
     If a triangle has the same color the triangle above, then assign the same tag.
     If a triangle has the same color the triangle to the left, then assign the same tag.
     Otherwise increment the tag-counter and assign the new tag to triangle.
     
     If it turns out that a triangle has same color as its neighbours, but the
     neighbours have different tags, then merge the tags.
     
     Afterwards all gaps in the assigned tags are removed.
     */
    public func assignOptimalTags() {
        assignTags()
        collapseTags()
        removeGaps()
    }

    /*
     Identify all triangles that have "color == 0"
     Set these triangles tag to zero.
     Afterwards all gaps in the assigned tags are removed.
     */
    public func discardZeroes() {
		let w: UInt = canvas.cellsPerRow
		let h: UInt = canvas.cellsPerColumn
		for j: UInt in 0..<h {
			for i: UInt in 0..<w {
				let offset = Int(j * w + i)
				let cell: E2TriangleCell = canvas.cells[offset]
				var tagCell: E2TriangleTagCell = tagCells[offset]
                if cell.tl == 0 {
                    tagCell.tl = 0
                }
                if cell.tr == 0 {
                    tagCell.tr = 0
                }
                if cell.bl == 0 {
                    tagCell.bl = 0
                }
                if cell.br == 0 {
                    tagCell.br = 0
                }
				tagCells[offset] = tagCell
            }
        }
        removeGaps()
    }

    /*
     Pretty prints the tags so that it's possible to use
     for comparisons in unittesting code.
     */
	public var stringRepresentation: String {
        var s = ""
		for j: UInt in 0..<canvas.cellsPerColumn {
            if j > 0 {
                s += "\n"
            }
            for i: UInt in 0..<canvas.cellsPerRow {
				let offset = Int(j * canvas.cellsPerRow + i)
				let tagCell: E2TriangleTagCell = tagCells[offset]
                s += "\(tagCell.tl)"
                s += "\(tagCell.tr)"
            }
            s += "\n"
			for i: UInt in 0..<canvas.cellsPerRow {
				let offset = Int(j * canvas.cellsPerRow + i)
				let tagCell: E2TriangleTagCell = tagCells[offset]
				s += "\(tagCell.bl)"
				s += "\(tagCell.br)"
            }
        }
        return s
    }

    /*
     Determine how many different tags have been assigned.
     Returns the maximum tag value that is to be found.
     If no maximum is found then zero is returned.
     */
    public func obtainMaxTag() -> UInt {
        var foundTag: UInt = 0
		func REMEMBER_MAX_TAG(_ tag: Int) {
			if tag > foundTag {
				foundTag = UInt(tag)
			}
		}
		for j: UInt in 0..<canvas.cellsPerColumn {
            for i: UInt in 0..<canvas.cellsPerRow {
				let offset = Int(j * canvas.cellsPerRow + i)
				let tagCell: E2TriangleTagCell = tagCells[offset]
                REMEMBER_MAX_TAG(tagCell.tl)
                REMEMBER_MAX_TAG(tagCell.tr)
                REMEMBER_MAX_TAG(tagCell.bl)
                REMEMBER_MAX_TAG(tagCell.br)
            }
        }
        return foundTag
    }

    /*
     Select only triangles where triangle.tag == aTag
     Returns an array of E2CanvasTriangle instances corresponding to the selected triangles.
     */
    public func triangles(forTag tag: Int) -> [E2CanvasTriangle] {
        var triangleArray = [E2CanvasTriangle]()

		func triangleArrayAppend(_ triangleTag: Int, _ x: Int, _ y: Int, _ x0: Int, _ y0: Int, _ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) {
			if tag != triangleTag {
				return
			}
			let triangle: E2CanvasTriangle = E2CanvasTriangle(
				x0: x + x0,
				y0: y + y0,
				x1: x + x1,
				y1: y + y1,
				x2: x + x2,
				y2: y + y2
			)
			triangleArray.append(triangle)
		}

		let w: UInt = canvas.cellsPerRow
		let h: UInt = canvas.cellsPerColumn
		for j: UInt in 0..<h {
            for i: UInt in 0..<w {
				let offset = Int(j * canvas.cellsPerRow + i)
				let tagCell: E2TriangleTagCell = tagCells[offset]
                let x = Int(i * 2)
                let y = Int(j * 2)
                triangleArrayAppend(tagCell.tl, x, y, 0, 0, 2, 0, 1, 1)
                triangleArrayAppend(tagCell.tr, x, y, 2, 0, 3, 1, 1, 1)
                triangleArrayAppend(tagCell.bl, x, y, 0, 2, 1, 1, 2, 2)
                triangleArrayAppend(tagCell.br, x, y, 1, 1, 3, 1, 2, 2)
            }
        }
        return triangleArray
    }

    public init(canvas: E2Canvas) {
        self.canvas = canvas

		let cpr = Int(canvas.cellsPerRow)
        let cpc = Int(canvas.cellsPerColumn)
		let n = cpr * cpc
		for _ in 0..<n {
			tagCells.append(E2TriangleTagCell())
		}
    }

    public func tag(_ tag0: Int, correspondsToTag tag1: Int) {
		tagPairs.append(E2TagPair.create(tag0: tag0, tag1: tag1))
    }

    public func assignTags() {
            /*
             
                               +1,0
              0,0 ***************************** +2,0
                  *                           *
                  : *        topleft        *   *
                  :   *                   *       *
                  :     *               *           *
                  :       *           *               *
                  :         *       *                   *
                  :           *   *        topright       *
                  :             *                           * 
             0,+1 :             ***************************** +3,+1
                  :             *                           * 
                  :           *   *      bottomright      *
                  :         *       *                   *
                  :       *           *               *
                  :     *               *           *
                  :   *                   *       *
                  : *       bottomleft      *   *
                  *                           *
             0,+2 ***************************** +2,+2
                              +1,+2
             
             
             
             */
        var tag: Int = 1
		let w: Int = Int(canvas.cellsPerRow)
		let h: Int = Int(canvas.cellsPerColumn)
        for j in 0..<h {
            for i in 0..<w {
				// Obtain data from pixel(i, j-1)
                var value_above_tl: Int = -1
                var tag_above_tl: Int = -1
                if j > 0 {
					let offset: Int = (j - 1) * w + i
					let cell: E2TriangleCell = canvas.cells[offset]
                    value_above_tl = Int(cell.bl)
					let tagCell: E2TriangleTagCell = tagCells[offset]
                    tag_above_tl = tagCell.bl
                }
                    // Obtain data from pixel(i-1, j)
                var value_leftof_tl: Int = -1
                var value_leftof_bl: Int = -1
                var tag_leftof_tl: Int = -1
                var tag_leftof_bl: Int = -1
                if i > 0 {
					let offset: Int = j * w + i - 1
					let cell: E2TriangleCell = canvas.cells[offset]
                    value_leftof_tl = Int(cell.tr)
                    value_leftof_bl = Int(cell.br)
					let tagCell: E2TriangleTagCell = tagCells[offset]
                    tag_leftof_tl = tagCell.tr
                    tag_leftof_bl = tagCell.br
                }

				let this_offset: Int = j * w + i
				let this_cell: E2TriangleCell = canvas.cells[this_offset]
				var this_tagCell: E2TriangleTagCell = tagCells[this_offset]
				// Assign tag to TopLeft triangle
                let tl_equals_above: Bool = this_cell.tl == value_above_tl
                let tl_equals_left: Bool = this_cell.tl == value_leftof_tl
                let status_tl: Int = (tl_equals_above ? 2 : 0) + (tl_equals_left ? 1 : 0)
                switch status_tl {
				case 1:
					// value is same as left
					this_tagCell.tl = tag_leftof_tl
				case 2:
					// same as above
					this_tagCell.tl = tag_above_tl
				case 3:
					// same as above and same as left
					this_tagCell.tl = tag_above_tl
					self.tag(tag_above_tl, correspondsToTag: tag_leftof_tl)
				default:
					// value is different
					this_tagCell.tl = tag
					tag += 1
                }

                    // Assign tag to TopRight triangle
                let tr_equals_tl: Bool = this_cell.tr == this_cell.tl
                let status_tr: Int = tr_equals_tl ? 1 : 0
                switch status_tr {
				case 1:
					// value is same as left
					this_tagCell.tr = this_tagCell.tl
				default:
					// value is different
					this_tagCell.tr = tag
					tag += 1
                }
                    // Assign tag to BottomRight triangle
                let br_equals_above: Bool = this_cell.br == this_cell.tr
                let status_br: Int = br_equals_above ? 1 : 0
                switch status_br {
				case 1:
					// same as above
					this_tagCell.br = this_tagCell.tr
				default:
					// value is different
					this_tagCell.br = tag
					tag += 1
                }
                    // Assign tag to BottomLeft triangle
                let bl_equals_br: Bool = this_cell.bl == this_cell.br
                let bl_equals_left: Bool = this_cell.bl == value_leftof_bl
                let status_bl: Int = (bl_equals_br ? 2 : 0) + (bl_equals_left ? 1 : 0)
                switch status_bl {
				case 1:
					// value is same as left
					this_tagCell.bl = tag_leftof_bl
				case 2:
					// same as above
					this_tagCell.bl = this_tagCell.br
				case 3:
					// same as above and same as left
					this_tagCell.bl = this_tagCell.br
					self.tag(this_tagCell.br, correspondsToTag: tag_leftof_bl)
				default:
					// value is different
					this_tagCell.bl = tag
					tag += 1
                }

				tagCells[this_offset] = this_tagCell
            }
        }
    }

    public func collapseTags() {
        let tagReplacements = E2TagPair.dictionary(fromPairs: tagPairs)
        replaceTags(tagReplacements)
    }

    public func removeGaps() {
        let optimalTagReplacements = findOptimalTagReplacements()
        replaceTags(optimalTagReplacements)
    }

    public func replaceTags(_ tagReplacements: [Int: Int]) {
		func lookupTriangleTag(_ tag: Int) -> Int {
			return tagReplacements[tag] ?? tag
		}
		let w: Int = Int(canvas.cellsPerRow)
		let h: Int = Int(canvas.cellsPerColumn)
        for j in 0..<h {
            for i in 0..<w {
				let offset: Int = j * w + i
				var tagCell: E2TriangleTagCell = tagCells[offset]
                tagCell.tl = lookupTriangleTag(tagCell.tl)
                tagCell.tr = lookupTriangleTag(tagCell.tr)
                tagCell.bl = lookupTriangleTag(tagCell.bl)
                tagCell.br = lookupTriangleTag(tagCell.br)
				tagCells[offset] = tagCell
            }
        }
    }

    public func findOptimalTagReplacements() -> [Int: Int] {
		// Reassign tag numbers, so that there are no gaps
        var tag: Int = 1
        var optimalTagReplacements = [Int: Int]()
        var processedTags = NSMutableIndexSet()

		func PROCESS_TAG(_ triangleTag: Int) {
			if triangleTag == 0 {
				return
			}
			if !processedTags.contains(triangleTag) {
				optimalTagReplacements[triangleTag] = tag
				tag += 1
				processedTags.add(triangleTag)
			}
		}

		let w: Int = Int(canvas.cellsPerRow)
		let h: Int = Int(canvas.cellsPerColumn)
        for j in 0..<h {
            for i in 0..<w {
				let offset: Int = j * w + i
				let tagCell: E2TriangleTagCell = tagCells[offset]
                let tl = tagCell.tl
                let tr = tagCell.tr
                PROCESS_TAG(tl)
                PROCESS_TAG(tr)
            }
            for i in 0..<w {
				let offset: Int = j * w + i
				let tagCell: E2TriangleTagCell = tagCells[offset]
				let bl = tagCell.bl
				let br = tagCell.br
                PROCESS_TAG(bl)
                PROCESS_TAG(br)
            }
        }
        return optimalTagReplacements
    }
}
