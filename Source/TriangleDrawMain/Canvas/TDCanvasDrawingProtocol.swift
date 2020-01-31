// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary

typealias TDCanvasDrawing_TapBlock = (TDCanvasDrawingProtocol, E2CanvasPoint) -> Void
typealias TDCanvasDrawing_DrawBlock = (TDCanvasDrawingProtocol, CGPoint, E2CanvasPoint, Bool) -> Void
typealias TDCanvasDrawing_BeforeDrawBlock = () -> Void
typealias TDCanvasDrawing_AfterDrawBlock = () -> Void
typealias TDCanvasDrawing_RotateCompletionBlock = () -> Void

protocol TDCanvasDrawingProtocol: class {
	var onTapBlock: TDCanvasDrawing_TapBlock? { get set }
	var onBeforeDrawBlock: TDCanvasDrawing_BeforeDrawBlock? { get set }
	var onDrawBlock: TDCanvasDrawing_DrawBlock? { get set }
	var onAfterDrawBlock: TDCanvasDrawing_AfterDrawBlock? { get set }
	var hideLabels: Bool { get set }
	var canvas: E2Canvas? { get set }

	func rotateAnimation(degrees: Int, completionBlock: @escaping TDCanvasDrawing_RotateCompletionBlock)
}

typealias TDCanvasDrawingView = (UIView & TDCanvasDrawingProtocol)
