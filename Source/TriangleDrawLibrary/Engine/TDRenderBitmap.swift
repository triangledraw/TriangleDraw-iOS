// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

/*
 iOS kills apps with a too big memory footprint.
 There is rumours that apps that polutes the memory space,
 gets treated poorly by Apple.

 Exporting a TriangleDraw document to high-resolution bitmap,
 challenges this small-memory constraint.

 Therefore much care has been put into making a tile-based-renderer,
 so that the memory footprint can be as minimal as possible.


 Performance measurements
 
 method   tile_count   resolution    simulator   iPadmini             iPhone4
 RGBA     16           4096x4096     311mb
 RGBA     32           4096x4096     287mb
 RGBA     64           4096x4096     280mb
 GRAY      1            512x 512     -                                Invalid context
 GRAY      2            512x 512     -                                Invalid context
 GRAY      4            512x 512     -                                ???mb (0.7seconds)
 GRAY      4           1024x1024     -                                ???mb (2.0seconds)
 GRAY     32           1024x1024     10mb
 GRAY      4           2048x2048     45mb        15mb (2.4seconds)    ???mb (5.9seconds)
 GRAY      8           2048x2048     -           11mb (3.3seconds)
 GRAY     16           2048x2048     25mb         9mb (7.7seconds)
 GRAY     32           2048x2048     25mb
 GRAY     64           2048x2048     26mb
 GRAY     16           4096x4096     82mb
 GRAY     32           4096x4096     76mb
 GRAY     64           4096x4096     75mb
 GRAY     32           8192x8192     265mb
 
 Export to png/jpg
 1024x1024      jpg   91kb
 1024x1024      png   26kb
 2048x2048      jpg  279kb
 2048x2048      png   85kb
 4096x4096      jpg  951kb
 4096x4096      png  330kb

 */
public typealias TDRenderBitmapTileIndex = (x: Int, y: Int)
public typealias TDRenderBitmapProgressBlock = (Float) -> Void
public typealias TDRenderBitmapCompletionBlock = (_ imageOrNil: UIImage?) -> Void

public class TDRenderBitmap {
    private let canvas: E2Canvas
	private var context: CGContext?
	private let triangles: [E2CanvasTriangle2]
    private var fullSize = CGSize.zero
    private var tile_count: Int = 0
    private var antiAlias = false
    private var debugAlternateBackgroundColor = false
    private var overdrawEdges = false
    private var window_inset_x: Float = 0.0
    private var window_inset_y: Float = 0.0

	public init(canvas: E2Canvas) {
		self.canvas = canvas
		let allTriangles: [E2CanvasTriangle2] = canvas.convertToTriangles()
		let triangles: [E2CanvasTriangle2] = E2CanvasTriangle2.onlyTrianglesInsideTheHexagon(allTriangles)
		self.triangles = triangles
	}

    public class func imageWithSize2048x2048(for canvas: E2Canvas) -> UIImage? {
        return image(with: CGSize(width: 2048, height: 2048), tileCount: 4, canvas: canvas, progress: nil, completion: nil)
    }

    // Asynchronous, so that we can show a HUD progressbar
    public class func imageWithSize2048x2048(for canvas: E2Canvas, progress progressBlock: @escaping TDRenderBitmapProgressBlock, completion completionBlock: @escaping TDRenderBitmapCompletionBlock) {
        _ = image(with: CGSize(width: 2048, height: 2048), tileCount: 4, canvas: canvas, progress: progressBlock, completion: completionBlock)
    }

	// Many of `TDRenderBitmap` functions returns an optional `UIImage`.
	// In case of an error, then `nil` is returned and no reasonable error can be shown to the user.
	// Perhaps rework `TDRenderBitmap` to instead use an `enum Result` type,
	// with a `success` case for the generated image.
	// with a `failure` case for the error or error message. Maybe with a localized text.
    public class func image(with size: CGSize, tileCount: Int, canvas: E2Canvas, progress progressBlock: TDRenderBitmapProgressBlock?, completion completionBlock: TDRenderBitmapCompletionBlock?) -> UIImage? {
        let sync: Bool = (progressBlock == nil) || (completionBlock == nil)
        if sync {
            return TDRenderBitmap.inner_image(with: size, tileCount: tileCount, canvas: canvas, progress: nil)
        }
		let innerProgressBlock: TDRenderBitmapProgressBlock = { progress in
                DispatchQueue.main.sync(execute: {
                    progressBlock?(progress)
                })
            }
        DispatchQueue.global(qos: .default).async(execute: {
            let image: UIImage? = TDRenderBitmap.inner_image(with: size, tileCount: tileCount, canvas: canvas, progress: innerProgressBlock)
            DispatchQueue.main.async(execute: {
                completionBlock?(image)
            })
        })
        return nil
    }

    public class func inner_image(with size: CGSize, tileCount: Int, canvas: E2Canvas, progress progressBlock: TDRenderBitmapProgressBlock?) -> UIImage? {
        let sw = Int(size.width)
        let sh = Int(size.height)
		if AppConstant.TDRenderBitmap.debug_print {
			log.debug("Will render image. Size \(sw) \(sh)")
		}
		let colorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()

		var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
		bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

		guard let context: CGContext = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: sw * 4, space: colorspace, bitmapInfo: bitmapInfo) else {
			log.error("Unable to create CGContext. width: \(sw) height: \(sh)")
			return nil
		}

        context.setAllowsAntialiasing(false)
        let fillrect = CGRect(x: 0, y: 0, width: sw, height: sh)
		context.setFillColor(AppConstant.TDRenderBitmap.backgroundFill.cgColor)
        context.fill(fillrect)
		return inner_image2(with: size, tileCount: tileCount, canvas: canvas, context: context, progress: progressBlock)
	}

	public class func inner_image2(with size: CGSize, tileCount: Int, canvas: E2Canvas, context: CGContext, progress progressBlock: TDRenderBitmapProgressBlock?) -> UIImage? {
		let t0 = CFAbsoluteTimeGetCurrent()
		let sw = Int(size.width)
		let sh = Int(size.height)

		// Flip coordinate system
        let bounds: CGRect = context.boundingBoxOfClipPath
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -bounds.size.height)


		let res: E2Canvas = E2Canvas.createBigCanvas()
		res.load(fromStringRepresentation: canvas.stringRepresentation)
		res.maskAllPixelsOutsideHexagon()

        let rt = TDRenderBitmap(canvas: res)
//		rt.debugAlternateBackgroundColor = true
        rt.overdrawEdges = true
        rt.antiAlias = true
        rt.fullSize = size
        rt.tile_count = tileCount
        rt.window_inset_x = 4
        rt.window_inset_y = 2
        for tiley in 0..<tileCount {
            for tilex in 0..<tileCount {
				if AppConstant.TDRenderBitmap.debug_hideEveryOddTile {
					if (tilex + tiley) & 1 == 0 {
						continue
					}
				}
                autoreleasepool {
					let tile: UIImage? = rt.image(forTile: TDRenderBitmapTileIndexMake(x: tilex, y: tiley))
                    let tileRect = CGRect(x: CGFloat(tilex * sw / tileCount), y: CGFloat(tiley * sh / tileCount), width: CGFloat(sw / tileCount), height: CGFloat(sh / tileCount))
					if AppConstant.TDRenderBitmap.debug_print {
						log.debug("tile[\(tilex),\(tiley)]  tileRect: \(tileRect)")
					}
                    UIGraphicsPushContext(context)
                    tile?.draw(in: tileRect)
                    UIGraphicsPopContext()
                }
				if let theProgressBlock: TDRenderBitmapProgressBlock = progressBlock {
                    let tiles_total = Float(tileCount * tileCount)
                    let tile_index = Float(tiley * tileCount + tilex)
                    theProgressBlock(tile_index / tiles_total)
                }
            }
        }
		guard let cgimage: CGImage = context.makeImage() else {
			log.error("Expected CGContext.makeImage() to return an image, but got nil")
			return nil
		}
		let image: UIImage = UIImage(cgImage: cgimage)
		if AppConstant.TDRenderBitmap.debug_timing {
			let t1 = CFAbsoluteTimeGetCurrent()
			let elapsed: Double = t1 - t0
			printTiming(imageSize: image.size, tileCount: tileCount, elapsed: elapsed)
		}
        return image
    }

	private class func printTiming(imageSize: CGSize, tileCount: Int, elapsed: Double) {
		let numberOfTiles = tileCount * tileCount
		let timePerTile: Double = elapsed / Double(numberOfTiles)
		let tilesPerSecond: Double = 1.0 / timePerTile
		log.debug("imageSize: \(imageSize)  tiles: \(tileCount)x\(tileCount) (\(numberOfTiles))   Elapsed \(elapsed.string2)   Tiles/second: \(tilesPerSecond.string2)")
	}

    public func image(forTile tileIndex: TDRenderBitmapTileIndex) -> UIImage? {
        let tile_index: Int = tileIndex.y * tile_count + tileIndex.x
		if AppConstant.TDRenderBitmap.debug_print {
			log.debug("tile \(tile_index)")
		}
        let aa_scale: Double = antiAlias ? 4.0 : 1.0
        let tileSize = CGSize(width: CGFloat(Double(fullSize.width) / Double(tile_count)), height: CGFloat(Double(fullSize.height) / Double(tile_count)))
		if AppConstant.TDRenderBitmap.debug_print {
	        log.debug("tileSize: \(tileSize)")
		}
        ASSERT_INTEGER(tileSize.width)
        ASSERT_INTEGER(tileSize.height)
		// Determine width/height of a single triangle
        let cells_per_row2: Int = Int(canvas.cellsPerRow * 2)
        let cells_per_column2: Int = Int(canvas.cellsPerColumn * 2)
        let cell_width_in_pixels = Double(fullSize.width) / Double(cells_per_row2)
        let cell_height_in_pixels = Double(fullSize.height) / Double(cells_per_column2)
        var scale_x: Double = cell_width_in_pixels
        var scale_y: Double = cell_height_in_pixels
        scale_x *= aa_scale
        scale_y *= aa_scale
		if AppConstant.TDRenderBitmap.debug_print {
			log.debug("scale: \(scale_x.string2) \(scale_y.string2)")
		}
        var corrected_window_inset_x: Double = 0
        var corrected_window_inset_y: Double = 0
        var insetSize = CGSize.zero
        if overdrawEdges {
            var pixel_inset_x = Double(window_inset_x) * cell_width_in_pixels
            var pixel_inset_y = Double(window_inset_y) * cell_height_in_pixels
			if AppConstant.TDRenderBitmap.debug_print {
            	log.debug("pixel_inset not rounded \(pixel_inset_x.string2) \(pixel_inset_y.string2)")
			}
            pixel_inset_x = Double(roundf(Float(pixel_inset_x)))
            pixel_inset_y = Double(roundf(Float(pixel_inset_y)))
			if AppConstant.TDRenderBitmap.debug_print {
	            log.debug("pixel_inset rounded \(pixel_inset_x.string2) \(pixel_inset_y.string2)")
			}
            insetSize = CGSize(width: CGFloat(pixel_inset_x), height: CGFloat(pixel_inset_y))
            corrected_window_inset_x = pixel_inset_x / cell_width_in_pixels
            corrected_window_inset_y = pixel_inset_y / cell_height_in_pixels
        }
        let contentSize: CGSize = tileSize
        ASSERT_INTEGER(contentSize.width)
        ASSERT_INTEGER(contentSize.height)
        let imageSize = CGSize(width: contentSize.width + insetSize.width * 2.0, height: contentSize.height + insetSize.height * 2.0)
        ASSERT_INTEGER(imageSize.width)
        ASSERT_INTEGER(imageSize.height)
        let aa_imageSize = CGSize(width: CGFloat(Double(imageSize.width) * aa_scale), height: CGFloat(Double(imageSize.height) * aa_scale))
		if AppConstant.TDRenderBitmap.debug_print {
			log.debug("aa_imageSize: \(aa_imageSize)")
		}
        ASSERT_INTEGER(aa_imageSize.width)
        ASSERT_INTEGER(aa_imageSize.height)
        let cropRect = CGRect(x: insetSize.width, y: insetSize.height, width: contentSize.width, height: contentSize.height)
		let context: CGContext
		if let aContext = self.context {
			context = aContext
		} else {
			let sw: Int = Int(aa_imageSize.width)
			let sh: Int = Int(aa_imageSize.height)

			let colorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()

			var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
			bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue

			guard let aContext: CGContext = CGContext(data: nil, width: sw, height: sh, bitsPerComponent: 8, bytesPerRow: sw * 4, space: colorspace, bitmapInfo: bitmapInfo) else {
				log.error("Unable to create CGContext. width: \(sw) height: \(sh)")
				return nil
			}

			aContext.setAllowsAntialiasing(false)
			// Flip coordinate system
			let bounds: CGRect = aContext.boundingBoxOfClipPath
			aContext.scaleBy(x: 1.0, y: -1.0)
			aContext.translateBy(x: 0.0, y: -bounds.size.height)
			self.context = aContext
			context = aContext
		}
		// Transparent background
        let fillrect = CGRect(x: 0, y: 0, width: aa_imageSize.width, height: aa_imageSize.height)
		context.clear(fillrect)

        if debugAlternateBackgroundColor {
            if tile_index % 3 == 0 {
                context.setFillColor(red: 0.2, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            if tile_index % 3 == 1 {
                context.setFillColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 1.0)
            }
            if tile_index % 3 == 2 {
                context.setFillColor(red: 0.0, green: 0.0, blue: 0.2, alpha: 1.0)
            }
			context.fill(fillrect)
        }

        var window_x0 = Double(cells_per_row2 * (tileIndex.x + 0)) / Double(tile_count)
        var window_x1 = Double(cells_per_row2 * (tileIndex.x + 1)) / Double(tile_count)
        var window_y0 = Double(cells_per_column2 * (tileIndex.y + 0)) / Double(tile_count)
        var window_y1 = Double(cells_per_column2 * (tileIndex.y + 1)) / Double(tile_count)
        // Extend the window size when we are in overdraw mode
        if overdrawEdges {
            let inset_x: Double = corrected_window_inset_x
            let inset_y: Double = corrected_window_inset_y
            window_x0 -= inset_x
            window_x1 += inset_x
            window_y0 -= inset_y
            window_y1 += inset_y
        }
		if AppConstant.TDRenderBitmap.debug_print {
			log.debug("window: \(window_x0.string2) \(window_y0.string2) \(window_x1.string2) \(window_y1.string2)")
		}
		context.triangleDraw_fillTrianglesInTile(
			triangles: triangles,
			window_x0: window_x0,
			window_x1: window_x1,
			window_y0: window_y0,
			window_y1: window_y1,
			scale_x: scale_x,
			scale_y: scale_y
		)
		guard let cgimage: CGImage = context.makeImage() else {
			log.error("Expected CGContext.makeImage() to return an image, but got nil")
			return nil
		}
        var image: UIImage = UIImage(cgImage: cgimage)
        // Anti aliasing by down-scaling
        if antiAlias {
			let sizeBefore: CGSize = image.size
            /*
			MAYBE: Performance improvement. Rework -imageForTile: so it doesn't create UIImages
            but instead reuses the already allocated CGContexts.
            The current UIImage code uses lots of memory
            */
			if let imageScaled: UIImage = image.imageScaled(toExactSize: imageSize) {
				image = imageScaled
			} else {
				log.error("Unable to scale image to size: \(imageSize)")
			}
			let sizeAfter: CGSize = image.size
			if AppConstant.TDRenderBitmap.debug_print {
				log.debug("antialias:  sizeBefore: \(sizeBefore)  sizeAfter: \(sizeAfter)")
			}
        }
        // Crop overdrawn edges
        if overdrawEdges {
			let sizeBefore: CGSize = image.size
			/*
			MAYBE: Performance improvement. Rework -imageForTile: so it doesn't create UIImages
			but instead reuses the already allocated CGContexts.
			The current UIImage code uses lots of memory
			*/
			if let imageCropped: CGImage = image.cgImage?.cropping(to: cropRect) {
                image = UIImage(cgImage: imageCropped)
            }
			let sizeAfter: CGSize = image.size
			if AppConstant.TDRenderBitmap.debug_print {
				log.debug("overdrawEdges:  sizeBefore: \(sizeBefore)  sizeAfter: \(sizeAfter)")
			}
        }
        return image
    }
}

fileprivate func ASSERT_INTEGER(_ value: CGFloat, file: String = #file, _ function: String = #function, line: Int = #line) {
	#if DEBUG
    let remainder: CGFloat = abs(fmod(value, 1.0))
	assert(remainder < 0.001, "too inaccurate. value: \(value.string2)  remainder: \(remainder)   file: \(file)  \(function)  line: \(line)")
	#endif
}

fileprivate func TDRenderBitmapTileIndexMake(x: Int, y: Int) -> TDRenderBitmapTileIndex {
    var index: TDRenderBitmapTileIndex
    index.x = x
    index.y = y
    return index
}
