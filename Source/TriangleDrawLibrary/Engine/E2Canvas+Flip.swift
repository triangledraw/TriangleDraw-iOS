// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
extension E2Canvas {
    public func flipX() {
		let orig: E2Canvas = self.createCopy()
        clearWithBlackColor()
        let w = Int(self.cellsPerRow)
        let h = Int(self.cellsPerColumn)
        for j in 0..<h {
            for i in 0..<w {
                let inverse_i: Int = w - 1 - i
                do {
					// dest->tl = source->tl
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * inverse_i, y: 2 * j)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * j)
                    setPixel(dst, value: orig.getPixel(src))
                }
                do {
					// dest->bl = source->bl
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * inverse_i, y: 2 * j + 1)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * j + 1)
					setPixel(dst, value: orig.getPixel(src))
                }
                let inverse_i_minus1: Int = inverse_i - 1
                if inverse_i_minus1 >= 0 {
                    do {
						// dest->tr = source->tr
						let src: E2CanvasPoint = E2CanvasPoint(x: 2 * inverse_i_minus1 + 1, y: 2 * j)
						let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * j)
						setPixel(dst, value: orig.getPixel(src))
                    }
                    do {
						// dest->br = source->br
						let src: E2CanvasPoint = E2CanvasPoint(x: 2 * inverse_i_minus1 + 1, y: 2 * j + 1)
						let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * j + 1)
						setPixel(dst, value: orig.getPixel(src))
                    }
                }
            }
        }
    }

    public func flipY() {
		let orig: E2Canvas = self.createCopy()
		let w = Int(self.cellsPerRow)
		let h = Int(self.cellsPerColumn)
        for j in 0..<h {
            for i in 0..<w {
                let inverse_j: Int = h - 1 - j
                do {
					// dest->tl = source->bl
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * inverse_j + 1)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * j)
					setPixel(dst, value: orig.getPixel(src))
                }
                do {
					// dest->bl = source->tl
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * inverse_j)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i, y: 2 * j + 1)
					setPixel(dst, value: orig.getPixel(src))
                }
                do {
					// dest->tr = source->br
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * inverse_j + 1)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * j)
					setPixel(dst, value: orig.getPixel(src))
                }
                do {
					// dest->br = source->tr
					let src: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * inverse_j)
					let dst: E2CanvasPoint = E2CanvasPoint(x: 2 * i + 1, y: 2 * j + 1)
					setPixel(dst, value: orig.getPixel(src))
                }
            }
        }
    }
}
