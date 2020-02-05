// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import simd
import UIKit

public struct AppConstant {
	public struct AppGroup {
		// The AppGroup is must exist inside the Apple provisioning portal.
		// The AppGroup makes it possible to embed the "ThumbnailExtension" executable
		// inside the "TriangleDraw.app". This AppGroup id is used inside the entitlement files.
		// Further more the AppGroup makes it possible to share UserDefaults between executables.
		public static let id: String = "group.com.triangledraw.td3"
	}

	public struct App {
		public enum InitialViewController {
			case production_browser
			case screenshot_canvasWithTriangleDrawLogo
			case screenshot_canvasWithRune
			case debug_canvasMenu
		}
		public static let initialViewController: InitialViewController = .production_browser
	}

	public struct Browser {
		public static let debug_installCustomActions = false

//		public static let tintColor: UIColor = AppConstant.ColorBlindSafe.ultramarine40
//		public static let tintColor: UIColor = AppConstant.ColorBlindSafe.indigo50
		public static let tintColor: UIColor = AppConstant.ColorBlindSafe.magenta50
//		public static let tintColor: UIColor = AppConstant.ColorBlindSafe.orange40
//		public static let tintColor: UIColor = AppConstant.ColorBlindSafe.gold20
	}

	public struct Canvas {
		public enum Mode {
			case production
			case developer
		}
		public static let mode: Mode = .production

		public struct FilledCircle {
			public static let debug_pointSize = false
		}

		public struct Interaction {
			public static let installDebugButton = false
			public static let experimentsWithGameOfLife = false
			public static let debug_tapGesture = false
			public static let debug_drawLineGesture = false

			public static let experimentsWith3Color = false
		}

		public static let hexagonEdgeColor = TDFloat4(0.25, 0.25, 0.25, 1)

		/// Pinch to zoom in/out
		public static let minZoom: Float = 0.47
		public static let maxZoom: Float = 7.5

		/// Zoom to fit
		public static let zoomToFitMargin: Float = 10

		/// The rotate duration depends on the zoom factor.
		/// If everything is visible then the user cannot be confused about what is going on, so a low duration is good, say 0.3 seconds.
		/// If little is visible then the user can easily be confused about what is going on, so a long duration is good, say 1.2 seconds.
		public static let rotateDurationQuick: Float = 0.3
		public static let rotateDurationSlow: Float = 1.2

		/// MSAA - antialiasing
		/// TriangleDraw v2, was using `GLKView.drawableMultisample = GLKViewDrawableMultisample.multisample4X`
		/// A real device should have no problem running with 4x MSAA.
		/// However the simulator don't like this, bringing the entire computer to its knees.
		#if targetEnvironment(simulator)
			public static let rasterSampleCount = 1
		#else
			public static let rasterSampleCount = 4
		#endif

		/// A real device should be able to run at 60 FPS.
		/// However the simulator don't like this, bringing the entire computer to its knees.
		#if targetEnvironment(simulator)
			public static let frameRateDivider: Int = 10
		#else
			public static let frameRateDivider: Int = 1
		#endif

		/// Apothem of hexagon:
		/// sin(60deg) == sqrt(3)/2
		/// https://en.wikipedia.org/wiki/Apothem
		public static let hexagonApothem: Double = 0.866025403784439
	}

	public struct CanvasFileFormat {
		public static let fileExtension = "triangleDraw"

		///
		/// >> h = Math.sin(Math::PI / 3.0)
		/// => 0.866025403784439
		/// >> h * 104
		/// => 90.0666419935816
		///
		public static let width: UInt = 90
		public static let height: UInt = 104
		public static let visibleArea_height: UInt = 88
		public static let visibleArea_edgeCount: UInt = 44
	}

	public struct TDRenderBitmap {
		public static let debug_print = false
		public static let debug_timing = false
		public static let debug_hideEveryOddTile = false
		public static let debug_fillTriangles_skip = false

		public static let backgroundFill: UIColor = UIColor(red: 0.075, green: 0.075, blue: 0.075, alpha: 1)
	}

	public struct ThumbnailProvider {
		public static let debug_drawDiagnosticsInfo: Bool = false
		public static let developer_enableErrorExperiments = false

		public enum Size {
			case square
			case experimental_landscape
			case experimental_portrait
		}
		public static let size: Size = .square

		public static let backgroundFill: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.84, alpha: 1)
	}

	public struct ExportPDF {
		public enum Mode {
			case production
			case developer
		}
		public static let mode: Mode = .production
	}

	public struct ColorBlindSafe {
		// TriangleDraw uses "IBM design library" color blind safe
		// https://www.ibm.com/design/v1/language/resources/color-library/
		// https://davidmathlogic.com/colorblind/#%23648FFF-%23785EF0-%23DC267F-%23FE6100-%23FFB000

		// #648FFF - Ultramarine 40
		public static let ultramarine40: UIColor = UIColor(red: 0.392, green: 0.561, blue: 1, alpha: 1)

		// #785EF0 - Indigo 50
		public static let indigo50: UIColor = UIColor(red: 0.471, green: 0.369, blue: 0.941, alpha: 1)

		// #DC267F - Magenta 50
		public static let magenta50: UIColor = UIColor(red: 0.863, green: 0.149, blue: 0.498, alpha: 1)

		// #FE6100 - Orange 40
		public static let orange40: UIColor = UIColor(red: 0.996, green: 0.38, blue: 0, alpha: 1)

		// #FFB000 - Gold 20
		public static let gold20: UIColor = UIColor(red: 1, green: 0.69, blue: 0, alpha: 1)
	}
}
