// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Metal
import MetalKit
import simd
import TriangleDrawLibrary

enum HCRendererError: Error {
    case badVertexDescriptor
}

enum HCFilledCircleMode {
	case variableSize
	case fixedSize
}

struct HCFilledTriangleVertex {
	var position: TDFloat2
	var color: TDFloat4
}

struct HCFilledCircleVertex {
	var position: TDFloat2
}

// Structure for Gathering Per-Frame Constants
struct HCFilledTriangleConstants {
	var modelViewProjectionMatrix = matrix_identity_float4x4
}

// Structure for Gathering Per-Frame Constants
struct HCFilledCircleConstants {
	var pointSize: simd_float1 = 10
	var modelViewProjectionMatrix = matrix_identity_float4x4
}

struct HCScrollAndZoom {
	var shouldPerformZoomToFit: Bool = true
	var zoomToFitEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero

	var position = CGPoint.zero
	var pinchCenter = CGPoint.zero

	/// The width of the topside of the hexagoncanvas, measured in number of points
	var scale = CGFloat(500)

	mutating func clampPosition() {
		position.x = TriangleDrawLibrary.clamp(position.x, -scale, scale)
		position.y = TriangleDrawLibrary.clamp(position.y, -scale, scale)
	}
}

class HCRenderer: NSObject {
    public let device: MTLDevice
    let commandQueue: MTLCommandQueue
	var viewportSize: CGSize = CGSize.zero

	var filledtriangle_vertices: [HCFilledTriangleVertex]

	var filledtriangle_pipelineState: MTLRenderPipelineState
	var filledtriangle_vertexBuffer: MTLBuffer
	var filledtriangle_indexBuffer: MTLBuffer
	var filledtriangle_indices: [UInt16]

	var edgetriangle_vertexBuffer: MTLBuffer
	var edgetriangle_indexBuffer: MTLBuffer
	var edgetriangle_indices: [UInt16]

	var filledcircle_mode: HCFilledCircleMode
	var filledcircle_pipelineState: MTLRenderPipelineState
	var filledcircle_vertexBuffer: MTLBuffer
	var filledcircle_indexBuffer: MTLBuffer
	var filledcircle_indices: [UInt16]

	var time = TimeInterval(0.0)
	var filledTriangle_constants = HCFilledTriangleConstants()
	var filledCircle_constants = HCFilledCircleConstants()

	var scrollAndZoom = HCScrollAndZoom()

	init?(metalKitView: MTKView, canvas: E2Canvas, filledCircleMode: HCFilledCircleMode) {
		self._canvas = canvas
        self.device = metalKitView.device!
		self.filledcircle_mode = filledCircleMode
        guard let queue = self.device.makeCommandQueue() else { return nil }
        self.commandQueue = queue

		metalKitView.colorPixelFormat = MTLPixelFormat.bgra8Unorm

        do {
            filledtriangle_pipelineState = try HCRenderer.filledtriangle_renderPipelineState(
				device: device,
				metalKitView: metalKitView
			)
        } catch {
            log.error("Unable to compile render pipeline state.  Error info: \(error)")
            return nil
        }
		do {
			filledcircle_pipelineState = try HCRenderer.filledcircle_renderPipelineState(
				device: device,
				metalKitView: metalKitView,
				mode: filledCircleMode
			)
		} catch {
			log.error("Unable to compile render pipeline state.  Error info: \(error)")
			return nil
		}


		let buildHexagon = HCBuildHexagonCanvas()
//		buildHexagon.buildHexagon(sideCount: 10)
//		buildHexagon.buildHexagon(sideCount: 30)
//		buildHexagon.buildHexagon(sideCount: 40)
//		buildHexagon.buildHexagon(sideCount: 50)
//		buildHexagon.buildHexagon(sideCount: AppConstant.CanvasFileFormat.visibleArea_edgeCount)
//		buildHexagon.buildHexagon2()
		buildHexagon.buildHexagon(canvas: canvas)
		buildHexagon.create_filledCircles_from_filledTriangles()
		//print("buildHexagon: \(buildHexagon)")

		let filledtriangle_vertices: [HCFilledTriangleVertex] = buildHexagon.filledtriangle_vertices
		let filledcircle_vertices: [HCFilledCircleVertex] = buildHexagon.filledcircle_vertices

		self.filledtriangle_indices = buildHexagon.filledtriangle_indices
		self.filledcircle_indices = buildHexagon.filledcircle_indices

		let hexagonCorners: HCHexagonCorners = buildHexagon.corners

		self.filledtriangle_vertices = filledtriangle_vertices
		guard let filledtriangle_vertexBuffer: MTLBuffer = device.makeBuffer(bytes: filledtriangle_vertices, length: filledtriangle_vertices.count * MemoryLayout<HCFilledTriangleVertex>.stride, options: []) else {
			fatalError("makeBuffer() filledtriangle_vertexBuffer")
		}
		self.filledtriangle_vertexBuffer = filledtriangle_vertexBuffer

		guard let filledtriangle_indexBuffer: MTLBuffer = device.makeBuffer(bytes: filledtriangle_indices, length: filledtriangle_indices.count * MemoryLayout<UInt16>.stride, options: []) else {
			fatalError("makeBuffer() filledtriangle_indexBuffer")
		}
		self.filledtriangle_indexBuffer = filledtriangle_indexBuffer


		guard let filledcircle_vertexBuffer: MTLBuffer = device.makeBuffer(bytes: filledcircle_vertices, length: filledcircle_vertices.count * MemoryLayout<HCFilledCircleVertex>.stride, options: []) else {
			fatalError("makeBuffer() filledcircle_vertexBuffer")
		}
		self.filledcircle_vertexBuffer = filledcircle_vertexBuffer

		guard let filledcircle_indexBuffer: MTLBuffer = device.makeBuffer(bytes: filledcircle_indices, length: filledcircle_indices.count * MemoryLayout<UInt16>.stride, options: []) else {
			fatalError("makeBuffer() filledcircle_indexBuffer")
		}
		self.filledcircle_indexBuffer = filledcircle_indexBuffer


		let buildEdge = HCBuildEdgeAroundHexagon(
			corners: hexagonCorners,
			color: AppConstant.Canvas.hexagonEdgeColor
		)
		let edgetriangle_vertices: [HCFilledTriangleVertex] = buildEdge.edgetriangle_vertices
		let edgetriangle_indices: [UInt16] = buildEdge.edgetriangle_indices
		self.edgetriangle_indices = edgetriangle_indices

		guard let edgetriangle_vertexBuffer: MTLBuffer = device.makeBuffer(bytes: edgetriangle_vertices, length: edgetriangle_vertices.count * MemoryLayout<HCFilledTriangleVertex>.stride, options: []) else {
			fatalError("makeBuffer() edgetriangle_vertices")
		}
		self.edgetriangle_vertexBuffer = edgetriangle_vertexBuffer

		guard let edgetriangle_indexBuffer: MTLBuffer = device.makeBuffer(bytes: edgetriangle_indices, length: edgetriangle_indices.count * MemoryLayout<UInt16>.stride, options: []) else {
			fatalError("makeBuffer() edgetriangle_indexBuffer")
		}
		self.edgetriangle_indexBuffer = edgetriangle_indexBuffer


        super.init()
    }
    
    class func filledtriangle_vertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()

		vertexDescriptor.attributes[0].format = MTLVertexFormat.float2
		vertexDescriptor.attributes[0].offset = 0
		vertexDescriptor.attributes[0].bufferIndex = 0

		vertexDescriptor.attributes[1].format = MTLVertexFormat.float4
		vertexDescriptor.attributes[1].offset = MemoryLayout<TDFloat3>.stride
		vertexDescriptor.attributes[1].bufferIndex = 0

		vertexDescriptor.layouts[0].stride = MemoryLayout<HCFilledTriangleVertex>.stride

        return vertexDescriptor
    }
    
	class func filledcircle_vertexDescriptor() -> MTLVertexDescriptor {
		let vertexDescriptor = MTLVertexDescriptor()

		vertexDescriptor.attributes[0].format = MTLVertexFormat.float2
		vertexDescriptor.attributes[0].offset = 0
		vertexDescriptor.attributes[0].bufferIndex = 0

		vertexDescriptor.layouts[0].stride = MemoryLayout<HCFilledCircleVertex>.stride

		return vertexDescriptor
	}

    class func filledtriangle_renderPipelineState(
		device: MTLDevice,
		metalKitView: MTKView) throws -> MTLRenderPipelineState
	{
		guard let library: MTLLibrary = device.makeDefaultLibrary() else {
			fatalError("makeDefaultLibrary()")
		}
		guard let vertexFunction = library.makeFunction(name: "filledtriangle_vertex") else {
			fatalError("makeFunction() filledtriangle_vertex")
		}
		guard let fragmentFunction = library.makeFunction(name: "filledtriangle_fragment") else {
			fatalError("makeFunction() filledtriangle_fragment")
		}
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.label = "Filled Triangles"
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
		pipelineDescriptor.rasterSampleCount = AppConstant.Canvas.rasterSampleCount
		pipelineDescriptor.vertexDescriptor = filledtriangle_vertexDescriptor()
		pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat

        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }


	class func filledcircle_renderPipelineState(
		device: MTLDevice,
		metalKitView: MTKView,
		mode: HCFilledCircleMode) throws -> MTLRenderPipelineState
	{
		guard let library: MTLLibrary = device.makeDefaultLibrary() else {
			fatalError("makeDefaultLibrary()")
		}
		guard let vertexFunction = library.makeFunction(name: "filledcircle_vertex") else {
			fatalError("makeFunction() filledcircle_vertex")
		}
		let fragmentFunctionName: String
		switch mode {
		case .variableSize:
			fragmentFunctionName = "filledcircle_variablesize_fragment"
		case .fixedSize:
			fragmentFunctionName = "filledcircle_fixedsize_fragment"
		}
		guard let fragmentFunction = library.makeFunction(name: fragmentFunctionName) else {
			fatalError("makeFunction() missing fragmentFunction for mode: '\(mode)' name: '\(fragmentFunctionName)'")
		}

		let pipelineDescriptor = MTLRenderPipelineDescriptor()
		pipelineDescriptor.label = "Filled Circles"
		pipelineDescriptor.vertexFunction = vertexFunction
		pipelineDescriptor.fragmentFunction = fragmentFunction
		pipelineDescriptor.rasterSampleCount = AppConstant.Canvas.rasterSampleCount
		pipelineDescriptor.vertexDescriptor = filledcircle_vertexDescriptor()
		pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat


		/*
		Invert colors
		When drawing a dot on a black background then the dot becomes white.
		When drawing a dot on a white background then the dot becomes black.
		*/
		pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
		pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
		pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .oneMinusDestinationColor
		pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceColor

		return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
	}

	var _canvas: E2Canvas
	var canvas: E2Canvas {
		get {
			return _canvas
		}
		set(newCanvas) {
			_canvas = newCanvas
			canvasNeedsDraw = true
		}
	}

	var canvasNeedsDraw: Bool = false

	func redrawCanvasIfNeeded() {
		guard canvasNeedsDraw else {
			return
		}
		canvasNeedsDraw = false

		let startTime: DispatchTime = DispatchTime.now()

		let buildHexagon = HCBuildHexagonCanvas()
		buildHexagon.buildHexagon(canvas: _canvas)

		let count0: Int = self.filledtriangle_vertices.count
		let count1: Int = buildHexagon.filledtriangle_vertices.count
		assert(count0 == count1)
		self.filledtriangle_vertices = buildHexagon.filledtriangle_vertices

		filledtriangle_vertexBuffer.contents().copyMemory(from: filledtriangle_vertices, byteCount: filledtriangle_vertices.count * MemoryLayout<HCFilledTriangleVertex>.stride)

		let endTime: DispatchTime = DispatchTime.now()
		let nanoTime: UInt64 = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
		let elapsed = Double(nanoTime) / 1_000_000_000
		if elapsed > 0.05 {
			log.warning("redraw took too long time. Elapsed: \(elapsed) seconds")
		}
	}

	func drawFilledTriangles(_ encoder: MTLRenderCommandEncoder) {
		encoder.pushDebugGroup("Filled Triangles")
		encoder.setRenderPipelineState(filledtriangle_pipelineState)
		encoder.setVertexBuffer(filledtriangle_vertexBuffer, offset: 0, index: 0)
		encoder.setVertexBytes(&filledTriangle_constants, length: MemoryLayout<HCFilledTriangleConstants>.size, index: 1)
		encoder.drawIndexedPrimitives(type: .triangle, indexCount: filledtriangle_indices.count, indexType: .uint16, indexBuffer: filledtriangle_indexBuffer, indexBufferOffset: 0)
		encoder.popDebugGroup()
	}

	func drawHexagonEdge(_ encoder: MTLRenderCommandEncoder) {
		encoder.pushDebugGroup("Hexagon Edge")
		encoder.setRenderPipelineState(filledtriangle_pipelineState)
		encoder.setVertexBuffer(edgetriangle_vertexBuffer, offset: 0, index: 0)
		encoder.setVertexBytes(&filledTriangle_constants, length: MemoryLayout<HCFilledTriangleConstants>.size, index: 1)
		encoder.drawIndexedPrimitives(type: .triangle, indexCount: edgetriangle_indices.count, indexType: .uint16, indexBuffer: edgetriangle_indexBuffer, indexBufferOffset: 0)
		encoder.popDebugGroup()
	}

	func drawFilledCircles(_ encoder: MTLRenderCommandEncoder) {
		guard filledCircle_constants.pointSize > 0.9 else {
			return
		}
		encoder.pushDebugGroup("Filled Circles")
		encoder.setRenderPipelineState(filledcircle_pipelineState)
		encoder.setVertexBuffer(filledcircle_vertexBuffer, offset: 0, index: 0)
		encoder.setVertexBytes(&filledCircle_constants, length: MemoryLayout<HCFilledCircleConstants>.size, index: 1)
		encoder.drawIndexedPrimitives(type: .point, indexCount: filledcircle_indices.count, indexType: .uint16, indexBuffer: filledcircle_indexBuffer, indexBufferOffset: 0)
		encoder.popDebugGroup()
	}

	var isRotating: Bool = false
	var rotate_index: Int = 0
	var rotate_total: Int = 0
	var rotate_rads: Float = 0

	typealias RotateCompletion = () -> Void
	var rotateCompletion: RotateCompletion?

	func performRotateOperation(metalView: HCMetalView, degrees: Int, rotateCompletion: @escaping RotateCompletion) {
		let frameRate: Int = metalView.preferredFramesPerSecond / AppConstant.Canvas.frameRateDivider

		let scale: CGFloat = scrollAndZoom.scale
		let size: CGSize = metalView.bounds.size
		let minScale: Float = Float(size.minValue) * AppConstant.Canvas.minZoom
		let maxScale: Float = Float(size.maxValue) * AppConstant.Canvas.maxZoom

		// The rotate speed depends on the current zoom factor
		let duration: Float = remap(
			Float(scale),
			minScale,
			maxScale,
			AppConstant.Canvas.rotateDurationQuick,
			AppConstant.Canvas.rotateDurationSlow
		)
		//log.debug("scale: \(scale.string1)  duration: \(duration.string2)")

		rotate_index = 0
		rotate_total = Int(ceil(Float(frameRate) * duration))
		rotate_rads = Float(degrees) * Float.pi / 180
		isRotating = true
		self.rotateCompletion = rotateCompletion
	}

	func updateWithTimestep(_ timestep: TimeInterval, view: MTKView) {
		// We keep track of time so we can animate the various transformations
//		time = time + timestep

		if scrollAndZoom.shouldPerformZoomToFit {
			zoomToFit(
				viewSize: view.bounds.size,
				uiInsets: scrollAndZoom.zoomToFitEdgeInsets,
				margin: CGFloat(AppConstant.Canvas.zoomToFitMargin)
			)
			scrollAndZoom.shouldPerformZoomToFit = false
		}

		var rotateRadians: Float = 0
		if isRotating {

			let progress = Float(rotate_index) / Float(rotate_total)

			let p: CGPoint = TDCalculateBezierPoint.easeInEaseOut(t: CGFloat(progress))
			let factor: CGFloat = p.y

			rotateRadians = rotate_rads * Float(factor)

			rotate_index += 1

			if rotate_index >= rotate_total {
				isRotating = false
				rotateCompletion?()
				rotateCompletion = nil
			}
		}

		let modelToWorldMatrix = matrix4x4_rotation(rotateRadians, vector_float3(0, 0, 1))
//		let modelToWorldMatrix = matrix4x4_rotation(Float(time) * 0.25, vector_float3(0, 0, 1))
//		let modelToWorldMatrix = matrix4x4_rotation(radians_from_degrees(30) + Float(time) * 0.25, vector_float3(0, 0, 1))

		let viewSize = view.bounds.size

		let modelViewProjectionMatrix = matrix_ortho(0, Float(viewSize.width), 0, Float(viewSize.height), -1, 1)
		let translation = matrix4x4_translation(Float(viewSize.width / 2), Float(viewSize.height / 2), 0)
		let translation2 = matrix4x4_translation(Float(scrollAndZoom.position.x), Float(scrollAndZoom.position.y), 0)
		let scale = matrix4x4_scale(Float(scrollAndZoom.scale), Float(scrollAndZoom.scale), 1)

		// The combined model-view-projection matrix moves our vertices from model space into clip space
		let a = matrix_multiply(modelViewProjectionMatrix, translation)
		let b = matrix_multiply(a, translation2)
		let c = matrix_multiply(b, scale)
		let d = matrix_multiply(c, modelToWorldMatrix)
		filledTriangle_constants.modelViewProjectionMatrix = d
		filledCircle_constants.modelViewProjectionMatrix = d

		// Adjust the diameter of the filled circle depending on the zoom level
		do {
			let oldPointSize: Float = filledCircle_constants.pointSize
			let newPointSize: Float = filledCircle_pointSizeFromScale(Float(scrollAndZoom.scale))
			filledCircle_constants.pointSize = newPointSize
			let diff = newPointSize - oldPointSize
			if AppConstant.Canvas.FilledCircle.debug_pointSize && diff * diff > 0.1 {
				log.debug("scale: \(scrollAndZoom.scale.string2)  \(newPointSize)")
			}
		}
	}

	func filledCircle_pointSizeFromScale(_ scale: Float) -> Float {
		switch self.filledcircle_mode {
		case .variableSize:
			// Zoom level affects the size of the dots.
			// Zoom in and the dots gets larger.
			// Zoom out and the dots gets smaller.
			let value = scale / 125.0
			if value > 80 {
				return 80
			}
			if value < 3.5 {
				return 3.5
			}
			return value
		case .fixedSize:
			// The dots are unaffected by the zoom level.
			return 7
		}
	}
}

extension HCRenderer: MTKViewDelegate {
    func draw(in view: MTKView) {
		guard let drawable = view.currentDrawable else {
			log.error("Expected currentDrawable to be non-nil, but got nil")
			return
		}

		guard let commandBuffer = commandQueue.makeCommandBuffer() else {
			log.error("Expected currentDrawable to be non-nil, but got nil")
			return
		}

		let timestep = 1.0 / TimeInterval(view.preferredFramesPerSecond / AppConstant.Canvas.frameRateDivider)
		redrawCanvasIfNeeded()
		updateWithTimestep(timestep, view: view)

		let viewport = MTLViewport(originX: 0, originY: 0, width: Double(self.viewportSize.width), height: Double(self.viewportSize.height), znear: -1.0, zfar: +1.0)

		/// Delay getting the currentRenderPassDescriptor until we absolutely need it to avoid
		/// holding onto the drawable and blocking the display pipeline any longer than necessary
		let renderPassDescriptor = view.currentRenderPassDescriptor

		if let renderPassDescriptor = renderPassDescriptor, let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {

			// Set the region of the drawable to which we'll draw.
			encoder.setViewport(viewport)

			drawFilledTriangles(encoder)
			drawFilledCircles(encoder)
			drawHexagonEdge(encoder)

			encoder.endEncoding()
		}

		commandBuffer.present(drawable)
		commandBuffer.commit()
    }
    
	/// Called whenever view changes orientation or is resized
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		log.debug("newSize: \(size)")

		// Save the size of the drawable as we'll pass these
		// values to our vertex shader when we draw
		viewportSize = size
    }
}
