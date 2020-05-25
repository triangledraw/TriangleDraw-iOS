// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

public enum TDLiveIndicatorStatus {
	case good
	case error
}

fileprivate extension TDLiveIndicatorStatus {
	var color: UIColor {
		switch self {
		case .good:
			return UIColor.darkGray
		case .error:
			return UIColor.red
		}
	}
}

public struct TDLiveIndicatorTick {
	public let statusMainProcess: TDLiveIndicatorStatus
	public let statusThumbnailProcess: TDLiveIndicatorStatus

	public init(statusMainProcess: TDLiveIndicatorStatus, statusThumbnailProcess: TDLiveIndicatorStatus) {
		self.statusMainProcess = statusMainProcess
		self.statusThumbnailProcess = statusThumbnailProcess
	}

	fileprivate func color(x: Int, y: Int) -> UIColor {
		switch y {
		case 0:
			return statusMainProcess.color
		case 1:
			return statusThumbnailProcess.color
		default:
			if x & 3 == 0 {
				return UIColor.black
			} else {
				return UIColor.darkGray
			}
		}
	}
}


public class TDLiveIndicator_Fifo<T> {
	private let capacity: UInt
	public private (set) var array: [T]

	public init(capacity: UInt, defaultValue: T) {
		self.capacity = capacity
		self.array = [T](repeating: defaultValue, count: Int(capacity))
	}

	public func append(_ item: T) {
		array.append(item)
		purge()
	}

	private func purge() {
		let diff: Int = self.array.count - Int(self.capacity)
		if diff >= 1 {
			array.removeFirst(diff)
		}
	}
}


public class TDLiveIndicatorTickContainer: TDLiveIndicator_Fifo<TDLiveIndicatorTick> {
	public init() {
		let defaultValue = TDLiveIndicatorTick(statusMainProcess: .good, statusThumbnailProcess: .good)
		super.init(capacity: 10, defaultValue: defaultValue)
	}

	public func appendMockSample(tick: Int) {
		switch tick & 3 {
		case 1:
			self.append(TDLiveIndicatorTick(statusMainProcess: .error, statusThumbnailProcess: .good))
		case 2:
			self.append(TDLiveIndicatorTick(statusMainProcess: .error, statusThumbnailProcess: .error))
		case 3:
			self.append(TDLiveIndicatorTick(statusMainProcess: .good, statusThumbnailProcess: .error))
		default:
			self.append(TDLiveIndicatorTick(statusMainProcess: .good, statusThumbnailProcess: .good))
		}
	}
}


public class TDLiveIndicator {

	public static func render(tickArray: [TDLiveIndicatorTick], tickOffset: Int) -> UIImage {
		let width: Int = tickArray.count
		let height: Int = 3
		let pixelSize = CGSize(width: 4, height: 10)
		let imageSize = CGSize(width: pixelSize.width * CGFloat(width), height: pixelSize.height * CGFloat(height))
		let resultImage: UIImage = UIGraphicsImageRenderer(size: imageSize).image { rendererContext in
			for x in 0..<width {
				let tick: TDLiveIndicatorTick = tickArray[x]
				for y in 0..<height {
					let color: UIColor = tick.color(x: tickOffset + x, y: y)
					color.setFill()
					let origin = CGPoint(x: pixelSize.width * CGFloat(x), y: pixelSize.height * CGFloat(y))
					rendererContext.fill(CGRect(origin: origin, size: pixelSize))
				}
			}
		}
		return resultImage.withRenderingMode(.alwaysOriginal)
	}

}
