// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import Foundation
import TriangleDrawLibrary
import RadiantForms
import MBProgressHUD

protocol HCMenuViewControllerDelegate: class {
	func hcMenuViewController_applySubdivide(n: UInt8)
	func hcMenuViewController_canvasGridModeDidChange()
}

enum HexagonCanvasMenuDocument {
	case document(document: Document)
	case mock
}

extension UIViewController {
	/// Open a menu with settings related to the canvas
	func td_presentHexagonCanvasMenu(document: HexagonCanvasMenuDocument = .mock, delegate: HCMenuViewControllerDelegate? = nil) {
		let nc = HCMenuViewController.create(document: document, delegate: delegate)
		self.present(nc, animated: true, completion: nil)
	}
}

class HCMenuViewController: RFFormViewController {
	var _hud: MBProgressHUD?
	var canvas: E2Canvas?
	var document_displayName: String?
	weak var delegate: HCMenuViewControllerDelegate?

	static func create(document: HexagonCanvasMenuDocument, delegate: HCMenuViewControllerDelegate?) -> UINavigationController {
		let vc = HCMenuViewController()
		vc.delegate = delegate

		switch document {
		case let .document(document):
			vc.canvas = document.canvas
			vc.document_displayName = document.displayName
		case .mock:
			vc.canvas = DocumentExample.triangledrawLogo.canvas
			vc.document_displayName = "Mock"
		}

		let nc = UINavigationController(rootViewController: vc)
		nc.navigationBar.barStyle = .default
		nc.modalTransitionStyle = .crossDissolve
		nc.modalPresentationStyle = .formSheet
		return nc
	}

	override func loadView() {
		super.loadView()
		installDismissButton()
	}

	override func populate(_ builder: RFFormBuilder) {
		builder.navigationTitle = "Canvas"
		builder += RFSectionHeaderTitleFormItem().title("Grid System")
		builder += gridMode
		builder += symmetryMode
        builder += subdivideButton

		builder += RFSectionHeaderTitleFormItem().title("Export")
		builder += exportBitmapPNGButton
		builder += exportVectorPDFButton
		builder += exportVectorSVGButton

		builder += RFSectionHeaderTitleFormItem().title("Feedback")
		builder += emailDeveloperButton
	}

	lazy var gridMode: RFSegmentedControlFormItem = {
		let instance = RFSegmentedControlFormItem()
		instance.title = "Format"
		instance.items = CanvasGridMode.allCases.map { $0.localizedDisplayName }
		let currentGridMode: CanvasGridMode = CanvasGridModeController().currentCanvasGridMode
		instance.selected = CanvasGridMode.allCases.firstIndex(of: currentGridMode) ?? 0
		instance.valueDidChangeBlock = { [weak self] value in
			let gridMode: CanvasGridMode = CanvasGridMode.allCases[value]
			CanvasGridModeController().changeCanvasGridMode(to: gridMode)
			self?.delegate?.hcMenuViewController_canvasGridModeDidChange()
		}
		return instance
	}()

	lazy var symmetryMode: RFOptionPickerFormItem = {
		let instance = RFOptionPickerFormItem()
		instance.title("Symmetry")
		for symmetryMode in SymmetryMode.allCases {
			instance.append(symmetryMode.localizedDisplayName, identifier: symmetryMode.rawValue)
		}
		instance.selectOptionWithIdentifier(globalSymmetryMode.rawValue)
		instance.valueDidChange = { (selected: RFOptionRowModel?) in
			var symmetryMode = SymmetryMode.noSymmetry
			if let id: String = selected?.identifier {
				symmetryMode = SymmetryMode(rawValue: id) ?? SymmetryMode.noSymmetry
			}
			globalSymmetryMode = symmetryMode
		}
		return instance
	}()

    lazy var subdivideButton: RFViewControllerFormItem = {
        let instance = RFViewControllerFormItem()
        instance.title = "Subdivide"
        instance.createViewController = { [weak self] (_) in
            let vc = HCMenuSubdivideViewController()
            vc.delegate = self
            return vc
        }
        return instance
    }()

	lazy var exportBitmapPNGButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Bitmap PNG"
		instance.action = { [weak self] in
			self?.exportBitmapPNGAction()
		}
		return instance
	}()

	func exportBitmapPNGAction() {
		guard let canvas: E2Canvas = self.canvas else {
			log.error("Expected document.canvas to be non-nil, but got nil")
			return
		}
		log.debug("initiate")
		let t0 = CFAbsoluteTimeGetCurrent()
		installHUD()
		_hud?.mode = MBProgressHUDMode.determinateHorizontalBar
		_hud?.label.text = NSLocalizedString("CREATE_IMAGE_FOR_SHARING_HUD_TITLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "HUD title indicating that a share-image operation has started")
		_hud?.show(animated: true)
		let triangleCount = canvas.computeTriangleCount()
		let filename = document_displayName ?? ""

		let sourceView: UIView = self.view
		TDRenderBitmap.imageWithSize2048x2048(for: canvas, progress: { [weak self] progress in
			self?._hud?.progress = progress
		}) { [weak self] imageOrNil in
			self?._hud?.hide(animated: true)
			guard let strongSelf: HCMenuViewController = self else {
				log.error("Expected self to be non-nil, but got nil")
				return
			}
			guard let image: UIImage = imageOrNil else {
				log.error("Expected TDRenderBitmap to generate an image, but got nil")
				return
			}
			let t1 = CFAbsoluteTimeGetCurrent()
			let elapsed: Double = t1 - t0
			log.debug("ready for sharing.  elapsed: \(elapsed.string2)")
			let avc = HCMenuViewController.createSharePNGActivityViewController(image: image, filename: filename, triangleCount: triangleCount)
			if let presenter = avc.popoverPresentationController {
				presenter.sourceView = sourceView
			}
			strongSelf.present(avc, animated: true)
		}
	}

	lazy var exportVectorPDFButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Vector PDF"
		instance.action = { [weak self] in
			self?.exportVectorPDFAction()
		}
		return instance
	}()

	func exportVectorPDFAction() {
		guard let canvas: E2Canvas = self.canvas else {
			log.error("Expected document.canvas to be non-nil, but got nil")
			return
		}
		log.debug("initiate")
		installHUD()
		_hud?.mode = MBProgressHUDMode.determinateHorizontalBar
		_hud?.label.text = NSLocalizedString("CREATE_PDF_HUD_TITLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "HUD title indicating that a create PDF operation has started")
		_hud?.show(animated: true)
		let progressBlock: PDFExporter.ProgressBlock = { [weak self] progress in
			self?._hud?.progress = progress
		}
		let completionBlock: PDFExporter.CompletionBlock = { [weak self] pdfData in
			self?._hud?.hide(animated: true)
			self?.exportVectorPDFAction_part2(pdfData)
		}
		PDFExporter.createPDF(from: canvas, progress: progressBlock, completion: completionBlock)
	}

	func exportVectorPDFAction_part2(_ pdfData: Data) {
		guard pdfData.count > 0 else {
			log.error("Expected size of pdf to be greater than 0 bytes")
			return
		}
		let filename: String = document_displayName ?? ""
		let triangleCount: UInt = canvas?.computeTriangleCount() ?? 0
		let avc = HCMenuViewController.createSharePDFActivityViewController(pdfData: pdfData, filename: filename, triangleCount: triangleCount)
		let sourceView: UIView = self.view
		if let presenter = avc.popoverPresentationController {
			presenter.sourceView = sourceView
		}
		self.present(avc, animated: true)
	}

	lazy var exportVectorSVGButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Vector SVG"
		instance.action = { [weak self] in
			self?.exportVectorSVGAction()
		}
		return instance
	}()

	func exportVectorSVGAction() {
		guard let canvas: E2Canvas = self.canvas else {
			log.error("Expected document.canvas to be non-nil, but got nil")
			return
		}
		log.debug("initiate")
		let exporter = SVGExporter(canvas: canvas)
		exporter.appVersion = SystemInfo.appVersion
		exporter.rotated = false
		let svgData: Data = exporter.generateData()

		guard svgData.count > 0 else {
			log.error("Expected size of pdf to be greater than 0 bytes")
			return
		}
		let filename: String = document_displayName ?? ""
		let triangleCount: UInt = canvas.computeTriangleCount()
		let avc = HCMenuViewController.createShareSVGActivityViewController(svgData: svgData, filename: filename, triangleCount: triangleCount)
		let sourceView: UIView = self.view
		if let presenter = avc.popoverPresentationController {
			presenter.sourceView = sourceView
		}
		self.present(avc, animated: true)
	}

	lazy var emailDeveloperButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Email Developer"
		instance.action = { [weak self] in
			self?.td_presentEmailWithFeedback()
		}
		return instance
	}()

	// MARK: - Dismiss Button

	func installDismissButton() {
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissAction))
	}

	@IBAction func dismissAction() {
		self.dismiss(animated: true)
	}

	// MARK: - MBProgressHUD methods

	func installHUD() {
		if _hud != nil {
			return
		}
		guard let view: UIView = navigationController?.view else {
			fatalError("Expected navigationController.view to be non-nil, but got nil")
		}
		// Install a HUD
		let hud: MBProgressHUD = MBProgressHUD(view: view)
		_hud = hud
		navigationController?.view.addSubview(hud)
		hud.delegate = self
		hud.minShowTime = 0.5
	}
}

extension HCMenuViewController: MBProgressHUDDelegate {
	func hudWasHidden(_ hud: MBProgressHUD) {
		// Remove HUD from screen when the HUD was hidded
		_hud?.removeFromSuperview()
		_hud = nil
	}
}

extension HCMenuViewController: HCMenuSubdivideViewControllerDelegate {
	func hcMenuSubdivideViewController_apply(n: UInt8) {
		log.debug("apply subdivide. N=\(n)")
		self.delegate?.hcMenuViewController_applySubdivide(n: n)
		self.dismiss(animated: true)
	}
}


extension E2Canvas {
	fileprivate func computeTriangleCount() -> UInt {
		let n1: UInt = self.numberOfDifferences(from: E2Canvas.createBigCanvas())
		let n2: UInt = self.numberOfDifferences(from: E2Canvas.bigCanvasMask())
		//log.debug("number of triangles: \(n1) \(n2)")
		return min(n1, n2)
	}
}
