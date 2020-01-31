// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
extension E2Canvas {
    public func moveRight() {
        moveOperation(.right)
    }

    public func moveLeft() {
        moveOperation(.left)
    }

    public func moveUp() {
        moveOperation(.up)
    }

    public func moveDown() {
        moveOperation(.down)
    }

    private func moveOperation(_ operation: E2CanvasMoveOperation) {
		let (ox, oy) = operation.offset
        let orig: E2Canvas = self.createCopy()
        let w = Int(self.cellsPerRow)
        let h = Int(self.cellsPerColumn)
        for j in 0..<h-1 {
            for i in 0..<w {
				let topLeftPixel = orig.getWrapPixel(E2CanvasPoint(x: (i + ox) * 2, y: (j + oy) * 2))
				setPixel(E2CanvasPoint(x: i * 2, y: j * 2), value: topLeftPixel)

				let topRightPixel = orig.getWrapPixel(E2CanvasPoint(x: (i + ox) * 2 + 1, y: (j + oy) * 2))
				setPixel(E2CanvasPoint(x: i * 2 + 1, y: j * 2), value: topRightPixel)

				let bottomLeftPixel = orig.getWrapPixel(E2CanvasPoint(x: (i + ox) * 2, y: (j + oy) * 2 + 1))
				setPixel(E2CanvasPoint(x: i * 2, y: j * 2 + 1), value: bottomLeftPixel)

				let bottomRightPixel = orig.getWrapPixel(E2CanvasPoint(x: (i + ox) * 2 + 1, y: (j + oy) * 2 + 1))
				setPixel(E2CanvasPoint(x: i * 2 + 1, y: j * 2 + 1), value: bottomRightPixel)
            }
        }
        clearPixelsOutsideHexagon()
    }
}

fileprivate enum E2CanvasMoveOperation {
	case left, right, up, down

	var offset: (Int, Int) {
		switch self {
		case .left:  return (+1, 0)
		case .right: return (-1, 0)
		case .up:    return (0, +1)
		case .down:  return (0, -1)
		}
	}
}
