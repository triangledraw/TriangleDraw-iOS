// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
extension E2Canvas {
    public func numberOfDifferences(from otherCanvas: E2Canvas) -> UInt {
        assert(otherCanvas.width == width)
        assert(otherCanvas.height == height)
        let cd0: E2Canvas = self
        let cd1: E2Canvas = otherCanvas
        assert(cd0.cellsPerColumn == cd1.cellsPerColumn)
        assert(cd0.cellsPerRow == cd1.cellsPerRow)
        var count: UInt = 0
        for j in 0..<Int(cd0.cellsPerColumn) {
            for i in 0..<Int(cd0.cellsPerRow) {
                do {
					// Compare top-left pixels
					let point: E2CanvasPoint = E2CanvasPoint(x: i * 2, y: j * 2)
                    let pixel0 = getPixel(point)
                    let pixel1 = otherCanvas.getPixel(point)
                    if pixel0 != pixel1 {
                        count += 1
                    }
                }
                do {
					// Compare top-right pixels
					let point: E2CanvasPoint = E2CanvasPoint(x: i * 2 + 1, y: j * 2)
                    let pixel0 = getPixel(point)
                    let pixel1 = otherCanvas.getPixel(point)
                    if pixel0 != pixel1 {
                        count += 1
                    }
                }
                do {
					// Compare bottom-left pixels
					let point: E2CanvasPoint = E2CanvasPoint(x: i * 2, y: j * 2 + 1)
                    let pixel0 = getPixel(point)
                    let pixel1 = otherCanvas.getPixel(point)
                    if pixel0 != pixel1 {
                        count += 1
                    }
                }
                do {
					// Compare bottom-right pixels
					let point: E2CanvasPoint = E2CanvasPoint(x: i * 2 + 1, y: j * 2 + 1)
                    let pixel0 = getPixel(point)
                    let pixel1 = otherCanvas.getPixel(point)
                    if pixel0 != pixel1 {
                        count += 1
                    }
                }
            }
        }
        return count
    }
}
