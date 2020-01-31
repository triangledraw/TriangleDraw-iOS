// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

enum Image: String {
	case browser_gear
	case canvas_moveLeft
	case canvas_moveRight
	case canvas_moveUp
	case canvas_moveDown
	case canvas_flipX
	case canvas_flipY
	case canvas_rotateCCW
	case canvas_rotateCW
	case canvas_enterFullscreen
}

extension Image {
	var image: UIImage {
		guard let image: UIImage = UIImage(named: self.rawValue) else {
			fatalError("no image for \(self)")
		}
		return image
	}
}
