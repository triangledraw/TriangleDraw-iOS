// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import CoreGraphics
import TriangleDrawLibrary

public class PDFExporter {

	public typealias ProgressBlock = (_ progress: Float) -> Void
	public typealias CompletionBlock = (_ pdfData: Data) -> Void

	private func fillPolygon(context: CGContext, p: UnsafePointer<gpc_polygon>) {
		var outers = IndexSet()
		var inners = IndexSet()

		let num_contours: Int32 = p.pointee.num_contours
		let hole_buffer = UnsafeBufferPointer<Int32>(start: p.pointee.hole, count: Int(num_contours))
		let contour_buffer = UnsafeBufferPointer<gpc_vertex_list>(start: p.pointee.contour, count: Int(num_contours))

		for c: Int32 in 0..<num_contours {
			let holeValue: Int32 = hole_buffer[Int(c)]
			if holeValue != 0 {
				inners.insert(Int(c))
			} else {
				outers.insert(Int(c))
			}
		}

		if AppConstant.ExportPDF.mode == .developer {
			log.debug("inners: \(inners)")
			log.debug("outers: \(outers)")
		}

		var dict = [Int: IndexSet]()

		outers.forEach { (outerIndex) in
			var vlist_outer: gpc_vertex_list = contour_buffer[outerIndex]
			var poly0 = gpc_polygon()
			create_polygon_from_vertex(&poly0, &vlist_outer)

			var foundInners = IndexSet()
			inners.forEach { (innerIndex) in
				var vlist_inner: gpc_vertex_list = contour_buffer[innerIndex]
				var poly1 = gpc_polygon()
				create_polygon_from_vertex(&poly1, &vlist_inner)

				var clip: gpc_polygon = poly1
				gpc_polygon_clip(GPC_INT, &poly0, &clip, &poly1)

				if poly1.num_contours > 0 && poly1.contour.pointee.num_vertices >= 3 {
					foundInners.insert(innerIndex)
				}

				gpc_free_polygon(&poly1)
			}

			gpc_free_polygon(&poly0)
			inners.subtract(foundInners)
			dict[outerIndex] = foundInners
		}

		if AppConstant.ExportPDF.mode == .developer {
			log.debug("dict: \(dict)")
		}

		for (outerIndex, found_inners) in dict {
			var vlist: gpc_vertex_list = contour_buffer[outerIndex]
//			if AppConstant.ExportPDF.mode == .developer {
//				log.debug("OUTER")
//			}
			createPath(context: context, vlist: &vlist)

			found_inners.forEach { (innerIndex) in
				var vlisti: gpc_vertex_list = contour_buffer[innerIndex]
//				if AppConstant.ExportPDF.mode == .developer {
//					log.debug("inner")
//				}
				createPath(context: context, vlist: &vlisti)
			}

			context.fillPath()
		}
	}

	private func createPath(context: CGContext, vlist: UnsafePointer<gpc_vertex_list>) {
		let num_vertices: Int32 = vlist.pointee.num_vertices
		guard num_vertices >= 1 else {
			return
		}
		let buffer = UnsafeBufferPointer<gpc_vertex>(start: vlist.pointee.vertex, count: Int(num_vertices))
		for v: Int in 0..<Int(num_vertices) {
			let x: Double = buffer[v].x
			let y: Double = buffer[v].y
			let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
			if v == 0 {
				context.move(to: point)
			} else {
				context.addLine(to: point)
			}
		}
		context.closePath()
	}

	private func create_polygon_from_vertex(_ p: UnsafeMutablePointer<gpc_polygon>, _ vl: UnsafePointer<gpc_vertex_list>) {
		let n: Int32 = vl.pointee.num_vertices
		p.pointee.num_contours = 1
		p.pointee.hole = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
		p.pointee.hole[0] = 0
		p.pointee.contour = UnsafeMutablePointer<gpc_vertex_list>.allocate(capacity: 1)
		p.pointee.contour.pointee.num_vertices = n
		p.pointee.contour.pointee.vertex = UnsafeMutablePointer<gpc_vertex>.allocate(capacity: Int(n))
		for i in 0..<Int(n) {
			p.pointee.contour.pointee.vertex[i] = vl.pointee.vertex[i]
		}
	}

	public func pdfDataSimple(from canvas: E2Canvas) -> Data {
		let res: E2Canvas = E2Canvas.createBigCanvas()
		res.load(fromStringRepresentation: canvas.stringRepresentation)
		res.maskAllPixelsOutsideHexagon()
		let allTriangles: [E2CanvasTriangle2] = res.convertToTriangles()
		let triangles: [E2CanvasTriangle2] = E2CanvasTriangle2.onlyTrianglesInsideTheHexagon(allTriangles)

		// 500 PostScript points = 17.6388889 centimeters
		var mediaRect = CGRect(x: 0, y: 0, width: 500, height: 500)

		// Create PDF context
		let data = NSMutableData()
		guard let consumer: CGDataConsumer = CGDataConsumer(data: data as CFMutableData) else {
			log.error("Unable to create CGDataConsumer")
			fatalError()
		}
		guard let context: CGContext = CGContext(consumer: consumer, mediaBox: &mediaRect, nil) else {
			log.error("Unable to create CGContext")
			fatalError()
		}
		context.beginPDFPage(nil)

		UIGraphicsPushContext(context)

		// Establish coordinate system
		let sw: CGFloat = mediaRect.size.width
		let sh: CGFloat = mediaRect.size.height
		let w: Int = Int(canvas.cellsPerRow)
		let h: Int = Int(canvas.cellsPerColumn)
		context.scaleBy(x: sw / CGFloat(w * 2), y: sh / CGFloat(h * 2))

		// Flip coordinate system
		let bounds: CGRect = context.boundingBoxOfClipPath
		context.scaleBy(x: 1, y: -1)
		context.translateBy(x: 0, y: -bounds.height)

		// Draw
		for t: E2CanvasTriangle2 in triangles {
			context.triangleDraw_setFillColor(triangleValue: t.value)
			context.triangleDraw_fillTriangle(
				a: t.a.cgPoint,
				b: t.b.cgPoint,
				c: t.c.cgPoint
			)
		}

		// Clean up
		UIGraphicsPopContext()
		context.endPDFPage()
		context.closePDF()
		return data as Data
	}

	private func pdfDataGPC(
		from canvas: E2Canvas,
		progress progressBlock: ProgressBlock) -> Data {

		let res: E2Canvas = E2Canvas.createBigCanvas()
		res.load(fromStringRepresentation: canvas.stringRepresentation)
		res.invertPixels()
		res.clearPixelsOutsideHexagon()

		let comb: E2Combiner = E2Combiner(canvas: res)
		comb.assignOptimalTags()
		comb.discardZeroes()
		if AppConstant.ExportPDF.mode == .developer {
			let rep: String = comb.stringRepresentation
			log.debug("rep: \(rep)")
		}

		let maxTag: UInt = comb.obtainMaxTag()
		if AppConstant.ExportPDF.mode == .developer {
			log.debug("maxTag: \(maxTag)")
		}


		var expire: Double = 0
		var lastProgress: Float = 0

		// 500 PostScript points = 17.6388889 centimeters
		var mediaRect = CGRect(x: 0, y: 0, width: 500, height: 500)

		// Create PDF context
		let data = NSMutableData()
		guard let consumer: CGDataConsumer = CGDataConsumer(data: data as CFMutableData) else {
			log.error("Unable to create CGDataConsumer")
			fatalError()
		}
		guard let context: CGContext = CGContext(consumer: consumer, mediaBox: &mediaRect, nil) else {
			log.error("Unable to create CGContext")
			fatalError()
		}
		context.beginPDFPage(nil)


		do {
			context.saveGState()
			UIGraphicsPushContext(context)

			// Establish coordinate system
			let sw: CGFloat = mediaRect.size.width
			let sh: CGFloat = mediaRect.size.height
			let w: Int = Int(canvas.cellsPerRow)
			let h: Int = Int(canvas.cellsPerColumn)
			context.scaleBy(x: sw / CGFloat(w * 2), y: sh / CGFloat(h * 2))

			// Flip coordinate system
			let bounds: CGRect = context.boundingBoxOfClipPath
			context.scaleBy(x: 1, y: -1)
			context.translateBy(x: 0, y: -bounds.height)

			var printStatusExpire: Double = 0
			var accumulatedTriangleCount: Int = 0

			for index: UInt in 0..<maxTag {
				let tagIndex = index + 1
				if AppConstant.ExportPDF.mode == .developer {
					log.debug("processing \(tagIndex) of \(maxTag)")
				}

				let triangles: [E2CanvasTriangle] = comb.triangles(forTag: Int(tagIndex))

				if AppConstant.ExportPDF.mode == .developer {
					log.debug("triangles: \(triangles.count)")
				}

				// Print status
				accumulatedTriangleCount += triangles.count
				let tnow: Double = CFAbsoluteTimeGetCurrent()
				let isLast: Bool = (tagIndex == maxTag)
				if tnow > printStatusExpire || isLast {
					let progress: Float = Float(tagIndex * 100) / Float(maxTag)
					log.info("Progress \(progress.string1)%   (Tag \(tagIndex) of \(maxTag)).   Triangles accumulated: \(accumulatedTriangleCount)")
					printStatusExpire = tnow + 0.5
				}

				var result = gpc_polygon()
				result.num_contours = 1

				result.hole = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
				result.hole[0] = 0
				result.contour = UnsafeMutablePointer<gpc_vertex_list>.allocate(capacity: 1)
				result.contour[0].num_vertices = 0
				result.contour[0].vertex = nil

				var triangleIndex: Int = 0
				for t: E2CanvasTriangle in triangles {

					var subject = gpc_polygon()

					subject.num_contours = 1
					subject.hole = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
					subject.hole[0] = 0
					subject.contour = UnsafeMutablePointer<gpc_vertex_list>.allocate(capacity: 1)
					subject.contour[0].num_vertices = 3
					subject.contour[0].vertex = UnsafeMutablePointer<gpc_vertex>.allocate(capacity: 3)

					let vertex: UnsafeMutablePointer<gpc_vertex> = subject.contour.pointee.vertex
					vertex[0].x = Double(t.x0)
					vertex[0].y = Double(t.y0)
					vertex[1].x = Double(t.x1)
					vertex[1].y = Double(t.y1)
					vertex[2].x = Double(t.x2)
					vertex[2].y = Double(t.y2)

					var clip: gpc_polygon = result
					gpc_polygon_clip(GPC_UNION, &subject, &clip, &result)

					gpc_free_polygon(&subject)

					let tt: Double = CFAbsoluteTimeGetCurrent()
					if tt > expire {
						expire = tt + 0.15
						let n: Int = Int(maxTag) * triangles.count
						let i: Int = Int(index) * triangles.count + triangleIndex
						let progress: Float = Float(i) / Float(n)
						let diff: Float = progress - lastProgress
						if diff > 0.02 {
							progressBlock(progress)
							lastProgress = progress
						}
					}

					triangleIndex += 1
				}

//				if index & 1 == 0 {
//					context.setFillColor(red: 1, green: 0, blue: 0, alpha: 1)
//				} else {
//					context.setFillColor(red: 0, green: 1, blue: 0, alpha: 1)
//				}
				fillPolygon(context: context, p: &result)

				gpc_free_polygon(&result)
			}

			UIGraphicsPopContext()
			context.restoreGState()
		}

		// Clean up
		context.endPDFPage()
		context.closePDF()
		return data as Data
	}

	private func pdfData(
		from canvas: E2Canvas,
		progress: ProgressBlock) -> Data {
//		return self.pdfDataSimple(from: canvas)
		return self.pdfDataGPC(from: canvas, progress: progress)
	}

	public static func createPDF(
		from canvas: E2Canvas,
		progress progressBlock: @escaping ProgressBlock,
		completion completionBlock: @escaping CompletionBlock) {

		let innerProgressBlock: ProgressBlock = { (progress: Float) in
			DispatchQueue.main.async {
				progressBlock(progress)
			}
		}

		let rv = PDFExporter()
		DispatchQueue.global(qos: .default).async {
			let data: Data = rv.pdfData(from: canvas, progress: innerProgressBlock)
			DispatchQueue.main.async {
				completionBlock(data)
			}
		}
	}
}
