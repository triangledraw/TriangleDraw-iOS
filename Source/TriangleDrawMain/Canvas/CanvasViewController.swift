// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import MBProgressHUD
import TriangleDrawLibrary

class CanvasViewController: UIViewController {
	@IBOutlet weak var hcView: HCView!
	@IBOutlet weak var hcToolbar: HCToolbar!
	@IBOutlet weak var nonFullscreenCanvasArea: UIView!
	@IBOutlet weak var developerLabelContainerView: UIView!
	@IBOutlet weak var developerLabel: UILabel!
	@IBOutlet weak var leaveFullscreenButton: UIButton!


	lazy var hcSafeAreaView: HCSafeAreaView = {
		let instance = HCSafeAreaView(frame: CGRect.zero)
		instance.translatesAutoresizingMaskIntoConstraints = false
		return instance
	}()

	private var developerLabelRefreshTimer: Timer?

    fileprivate var _hud: MBProgressHUD?
    internal var drawingView: TDCanvasDrawingView?
    internal var undoBarButtonItem: UIBarButtonItem?
    internal var redoBarButtonItem: UIBarButtonItem?
    internal var menuBarButtonItem: UIBarButtonItem?

	private(set) var document: Document?

	private var setInitialDocument_invocationCounter: UInt = 0
	/// This function is not supposed be invoked multiple times.
	public func setInitialDocument(_ document: Document, completion: @escaping () -> Void) {
		self.setInitialDocument_invocationCounter += 1
		log.debug("document: \(document)")
		guard setInitialDocument_invocationCounter == 1 else {
			let oldDocument: Document? = self.document
			log.error("This function was invoked \(setInitialDocument_invocationCounter) times. It's supposed to only be invoked once.\noldDocument: \(String(describing: oldDocument))\nnewDocument: \(document)")
			return
		}
		self.document = document
		loadViewIfNeeded()
		loadTheDocument()
		completion()
	}

    private var originalCanvasStringRepresentation = ""
    private var oldCanvas: E2Canvas?
    private var beginDrawingTimestamp: Double = 0.0

	static func create() -> CanvasViewController {
		let storyboard = UIStoryboard(name: "CanvasViewController", bundle: nil)
		guard let vc = storyboard.instantiateInitialViewController() as? CanvasViewController else {
			fatalError("should create a view controller")
		}
		return vc
	}

	static func createInsideNavigationController() -> (UINavigationController, CanvasViewController) {
		let vc = CanvasViewController.create()
		let nc = UINavigationController(rootViewController: vc)
		nc.navigationBar.barStyle = .black
		nc.modalTransitionStyle = .crossDissolve
		return (nc, vc)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}

	init() {
		super.init(nibName: nil, bundle: nil)
		sharedInit()
	}

	func sharedInit() {
		log.debug("init")
	}

    deinit {
        log.debug("deinit")
    }

	var last_cgpoint: CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

		undoManager?.levelsOfUndo = 100

		self.view.insertSubview(self.hcSafeAreaView, belowSubview: self.leaveFullscreenButton)

		configureHCView()
		configureToolbar()
		configureNavigationBar()
		configureLeaveFullscreenButton()

		developerLabel.text = "A\nB\nC\nD"

		switch AppConstant.Canvas.mode {
		case .production:
			developerLabel.isHidden = true
			developerLabelContainerView.isHidden = true
		case .developer:
			developerLabel.isHidden = false
			developerLabelContainerView.isHidden = false
		}

        loadTheDocument()
    }

	/// Insets for the interactive area of the canvas
	///
	/// In fullscreen mode
	///
	/// - On an iPadPro running iOS12, there is zero inset.
	/// - On an iPhone6S running iOS12, there is zero inset.
	/// - On an iPhoneX running iOS12, the top inset is 44 and bottom inset is 34.
	///
	/// In non-fullscreen mode, there is navigationbar + toolbar
	///
	/// - On an iPadPro running iOS12, the top inset is 70 and bottom inset is 50.
	/// - On an iPhone6S running iOS12, the top inset is 64 and bottom inset is 44.
	/// - On an iPhoneX running iOS12, the top inset is 88 and bottom inset is 83.
	var canvasInsets: UIEdgeInsets {
		let outer: CGRect = self.view.bounds
		let inner: CGRect = hcSafeAreaView.frame
		return UIEdgeInsets(
			top: inner.minY - outer.minY,
			left: inner.minX - outer.minX,
			bottom: outer.maxY - inner.maxY,
			right: outer.maxX - inner.maxX
		)
	}

    override func viewWillAppear(_ animated: Bool) {
		log.debug("enter")
		super.viewWillAppear(animated)
        drawingView?.hideLabels = true
        NotificationCenter.default.addObserver(self, selector: #selector(documentStateChanged(notification:)), name: UIDocument.stateChangedNotification, object: document)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerDidChange(notification:)), name: .NSUndoManagerDidCloseUndoGroup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerWillChange(notification:)), name: .NSUndoManagerWillUndoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerDidChange(notification:)), name: .NSUndoManagerDidUndoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerWillChange(notification:)), name: .NSUndoManagerWillRedoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoManagerDidChange(notification:)), name: .NSUndoManagerDidRedoChange, object: nil)
        validateUndoRedoButtons()
		log.debug("leave")
    }

	override func viewDidAppear(_ animated: Bool) {
		log.debug("enter")
		super.viewDidAppear(animated)

		self.hcSafeAreaView.interactionView?.delegate = self.hcView

		switch AppConstant.Canvas.mode {
		case .production:
			()
		case .developer:
			installDeveloperLabelRefreshTimer()
		}
		log.debug("leave")
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if fullscreenMode {
			let insets: UIEdgeInsets = self.view.safeAreaInsets
			self.hcSafeAreaView.frame = self.view.bounds.inset(by: insets)
		} else {
			self.hcSafeAreaView.frame = self.nonFullscreenCanvasArea.frame
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let insets: UIEdgeInsets = self.canvasInsets
		self.hcView.metalView?.renderer?.scrollAndZoom.zoomToFitEdgeInsets = insets
	}

	func installDeveloperLabelRefreshTimer() {
		refreshDeveloperLabel()
		developerLabelRefreshTimer?.invalidate()
		self.developerLabelRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (_) in
			self?.refreshDeveloperLabel()
		}
	}

	func uninstallDeveloperLabelRefreshTimer() {
		developerLabelRefreshTimer?.invalidate()
		developerLabelRefreshTimer = nil
	}

	func refreshDeveloperLabel() {
		let viewSize: CGSize = view.frame.size
		let edgeInsets: UIEdgeInsets = self.canvasInsets
		let scaleString: String = self.hcView.metalView?.renderer?.scrollAndZoom.scale.string1 ?? "N/A"
		let positionString: String = self.hcView.metalView?.renderer?.scrollAndZoom.position.string1 ?? "N/A"
		var strings = [String]()
		strings.append("view: \(viewSize.width.string1), \(viewSize.height.string1)")
		strings.append("inset top/bottom: \(edgeInsets.top.string1), \(edgeInsets.bottom.string1)")
		strings.append("inset left/right: \(edgeInsets.left.string1), \(edgeInsets.right.string1)")
		strings.append("scale: \(scaleString)")
		strings.append("position: \(positionString)")
		developerLabel.text = strings.joined(separator: "\n")
	}

    override func viewWillDisappear(_ animated: Bool) {
		log.debug("enter")
        NotificationCenter.default.removeObserver(self)
		uninstallDeveloperLabelRefreshTimer()
        super.viewWillDisappear(animated)
		log.debug("leave")
    }

	func registerForUndo(_ inverseOperationSelector: Selector, _ actionName: String) {
		guard let undoManager: UndoManager = self.undoManager else {
			log.error("Expected undoManager to be non-nil, but got nil")
			return
		}
		undoManager.registerUndo(withTarget: self) { targetSelf in
			_ = targetSelf.perform(inverseOperationSelector)
		}
		if undoManager.isUndoing == false {
			undoManager.setActionName(actionName)
		}
	}

	override var undoManager: UndoManager? {
		return document?.undoManager
	}

	@objc func undoButtonAction() {
		log.debug("enter")
		undoManager?.undo()
		log.debug("leave")
	}

	@objc func redoButtonAction() {
		log.debug("enter")
		undoManager?.redo()
		log.debug("leave")
	}

    @objc func undoManagerWillChange(notification: Notification) {
        if notification.name == .NSUndoManagerWillUndoChange {
            installHUD()
            _hud?.mode = MBProgressHUDMode.text
            _hud?.label.text = NSLocalizedString("PERFORM_UNDO_HUD_TITLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "HUD showing Undo and the name of the operation that is being undoed")
			_hud?.detailsLabel.text = undoManager?.undoActionName
			_hud?.show(animated: true)
        }
        if notification.name == .NSUndoManagerWillRedoChange {
            installHUD()
            _hud?.mode = MBProgressHUDMode.text
            _hud?.label.text = NSLocalizedString("PERFORM_REDO_HUD_TITLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "HUD showing Redo and the name of the operation that is being redoed")
            _hud?.detailsLabel.text = undoManager?.redoActionName
			_hud?.show(animated: true)
        }
        undoBarButtonItem?.isEnabled = false
        redoBarButtonItem?.isEnabled = false
    }

    @objc func undoManagerDidChange(notification: Notification) {
		_hud?.hide(animated: true)
        validateUndoRedoButtons()
    }

    func validateUndoRedoButtons() {
        undoBarButtonItem?.isEnabled = undoManager?.canUndo ?? false
        redoBarButtonItem?.isEnabled = undoManager?.canRedo ?? false
    }

    @objc func documentStateChanged(notification: Notification) {
        //log.debug(@"called");
        loadTheDocument()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func loadTheDocument() {
		// Middle of the navigation bar
		if Platform.is_ideom_ipad {
			title = document?.displayName ?? ""
		} else {
			// Not sufficient space to show a title
			title = ""
		}

		var canvas: E2Canvas? = document?.canvas
        if canvas == nil {
			log.error("Expected canvas to be non-nil, but got nil. Creating a dummy canvas")
            canvas = E2Canvas.createBigCanvas()
        }
        drawingView?.canvas = canvas
        originalCanvasStringRepresentation = canvas?.stringRepresentation ?? ""
    }

    func hasChanged() -> Bool {
        let currentCanvas: E2Canvas? = drawingView?.canvas
        if currentCanvas == nil {
            return false
        }
        let currentRepresentation = currentCanvas?.stringRepresentation
        if currentRepresentation == nil {
            return false
        }
        let originalRepresentation = originalCanvasStringRepresentation
        if originalRepresentation == "" {
            return false
        }
        let sameRepresentation: Bool = originalRepresentation == currentRepresentation
        let differentRepresentation: Bool = sameRepresentation == false
        return differentRepresentation
    }

    @objc func doneButtonTaped(_ sender: Any?) {
		guard let document: Document = self.document else {
			fatalError("Expected CanvasViewController.document to be non-nil, but got nil. Cannot close document, since there isn't any document.")
		}
		let urlString = String(describing: document.fileURL)
		log.debug("Close A \(urlString)")
		document.close() { [weak self] (_) in
			log.debug("Close B \(urlString)")
			self?.dismiss(animated: true)
		}
    }

	@objc func debugButtonAction() {
		log.debug("enter")

		let provider = VerboseInfoProvider()
		self.verboseInfo(provider)
		let pairs = provider.pairs
		log.debug("pairs: \(pairs)")

		self.td_presentEmailWithVerboseInfo(provider)
		log.debug("leave")
	}


	// MARK: - Drawing operations

    func beginDrawing() {
        oldCanvas = document?.canvas?.createCopy()
        beginDrawingTimestamp = CFAbsoluteTimeGetCurrent()
    }

    func endDrawing() {
        let oldCanvas: E2Canvas? = self.oldCanvas
        self.oldCanvas = nil
        // Restore default state
        if oldCanvas == nil {
            log.error("CanvasVC: endDrawing invoked. However beginDrawing must be called called before calling endDrawing. Ignoring.")
            return
        }
        let newCanvas: E2Canvas? = document?.canvas
        let same: Bool = newCanvas == oldCanvas
        if same {
            // Nothing has changed. No need for undo.
            return
        }
		// Statistics
		let numberOfDifferences: UInt
		if let canvas0: E2Canvas = newCanvas, let canvas1: E2Canvas = oldCanvas {
			numberOfDifferences = canvas0.numberOfDifferences(from: canvas1)
		} else {
			numberOfDifferences = 0
		}
        let t1 = CFAbsoluteTimeGetCurrent()
        let elapsed: Double = t1 - beginDrawingTimestamp
        log.debug("changes: \(numberOfDifferences)   elapsed: \(elapsed)")
        // User changed pixels. Save it on the undo stack.
        setDocCanvas_inner(newCanvas, origCanvas: oldCanvas)
        let actionName = NSLocalizedString("OPERATION_DRAW_LINE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The line-draw operations undo/redo name")
		if let undoManager: UndoManager = self.undoManager {
			if !undoManager.isUndoing {
				undoManager.setActionName(actionName)
			}
		}
    }

    func setDocCanvas_inner(_ canvas: E2Canvas?, origCanvas: E2Canvas?) {
        assert(canvas != nil, "Invalid parameter not satisfying: canvas != nil")
        assert(origCanvas != nil, "Invalid parameter not satisfying: origCanvas != nil")
		undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
			targetSelf.setDocCanvas(origCanvas)
		})
        document?.canvas = canvas
        drawingView?.canvas = document?.canvas
    }

    func setDocCanvas(_ canvas: E2Canvas?) {
        let origCanvas: E2Canvas? = document?.canvas?.createCopy()
        setDocCanvas_inner(canvas, origCanvas: origCanvas)
    }

    func setPixel(_ point: E2CanvasPoint, value: UInt8) {
		log.debug("enter")
		guard let undoManager: UndoManager = self.undoManager else {
			log.error("Expected undoManager to be non-nil, but got nil")
			return
		}
		let origCanvas: E2Canvas? = document?.canvas?.createCopy()
        let actionName = NSLocalizedString("OPERATION_DRAW_SINGLE", tableName: "CanvasVC", bundle: Bundle.main, value: "", comment: "The draw-single-pixel operations undo/redo name")
		undoManager.registerUndo(withTarget: self, handler: { (targetSelf) in
			targetSelf.setDocCanvas(origCanvas)
		})
		if undoManager.isUndoing == false {
			undoManager.setActionName(actionName)
		}
        document?.canvas?.setSymmetricPixel(point, value: value, symmetryMode: globalSymmetryMode)
        drawingView?.canvas = document?.canvas
        log.debug("leave")
    }

    func line(from point0: CGPoint, to point1: CGPoint, value: UInt8) {
        document?.canvas?.line(from: point0, to: point1, value: value)
        document?.canvas?.clearPixelsOutsideHexagon()
        drawingView?.canvas = document?.canvas
    }

	// MARK: - User interaction

    func disableInteraction() {
        view.window?.isUserInteractionEnabled = false
    }

    func enableInteraction() {
        view.window?.isUserInteractionEnabled = true
    }

	// MARK: - Menu

	@objc func menuAction(_ senderBarButtonItem: UIBarButtonItem) {
		guard let document: Document = self.document else {
			log.error("Expected document to be non-nil, but got nil")
			return
		}
		self.td_presentHexagonCanvasMenu(
			document: HexagonCanvasMenuDocument.document(document: document),
			delegate: self
		)
	}


	// MARK: - Fullscreen mode
	
    @objc func enterFullscreenAction() {
        fullscreenMode = true
    }

	@IBAction func leaveFullscreenAction() {
        fullscreenMode = false
    }

    override var prefersStatusBarHidden: Bool {
        return fullscreenMode
    }

	private var _fullscreenMode = false
	private var fullscreenMode: Bool {
		get {
			return _fullscreenMode
		}
		set(fullscreenMode) {
			_fullscreenMode = fullscreenMode
			reloadFullscreenMode(animated: false)
		}
	}

	private func reloadFullscreenMode(animated: Bool) {
		if animated {
			// with animations
			navigationController?.setNavigationBarHidden(fullscreenMode, animated: true)
			hcToolbar?.isHidden = fullscreenMode
			leaveFullscreenButton.isHidden = !fullscreenMode
			UIView.animate(withDuration: 0.33, animations: { [weak self] in
				self?.setNeedsStatusBarAppearanceUpdate()
			})
		} else {
			// no animations
			navigationController?.setNavigationBarHidden(fullscreenMode, animated: false)
			navigationController?.navigationBar.isHidden = fullscreenMode
			hcToolbar?.isHidden = fullscreenMode
			leaveFullscreenButton.isHidden = !fullscreenMode
			setNeedsStatusBarAppearanceUpdate()
		}
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

extension CanvasViewController: MBProgressHUDDelegate {
	func hudWasHidden(_ hud: MBProgressHUD) {
        // Remove HUD from screen when the HUD was hidded
        _hud?.removeFromSuperview()
        _hud = nil
    }
}

extension CanvasViewController: HCMenuViewControllerDelegate {
	func hcMenuViewController_applySubdivide(n: UInt8) {
		log.debug("apply subdivide. N=\(n)")
		self.subdivide(n: n)
	}

	func hcMenuViewController_canvasGridModeDidChange() {
		hcView?.canvasGridModeDidChange()
	}
}

extension CanvasViewController: AcceptsVerboseInfoProvider {
	func verboseInfo(_ provider: VerboseInfoProvider) {
		let append = provider.append

		if let document: Document = self.document {
			append("document.displayName", document.displayName)
			append("document.fileURL", document.fileURL.absoluteString)
			append("document.hasUnsavedChanges", document.hasUnsavedChanges ? "true" : "false")
			if document.canvas != nil {
				append("document.canvas", "non-nil")
			} else {
				append("document.canvas", "nil (This is possible an error state!)")
			}
		} else {
			append("document", "nil (This is possible an error state!)")
		}

		if let undoManager: UndoManager = self.undoManager {
			append("undoManager.canUndo", "\(undoManager.canUndo)")
			append("undoManager.undoActionName", "\(undoManager.undoActionName)")
		} else {
			append("undoManager", "nil (This is possible an error state!)")
		}

		do {
			let viewSize: CGSize = view.frame.size
			let edgeInsets: UIEdgeInsets = self.canvasInsets
			let scaleString: String = self.hcView.metalView?.renderer?.scrollAndZoom.scale.string1 ?? "N/A"
			let positionString: String = self.hcView.metalView?.renderer?.scrollAndZoom.position.string1 ?? "N/A"
			append("view", "\(viewSize.width.string1), \(viewSize.height.string1)")
			append("inset top/bottom", "\(edgeInsets.top.string1), \(edgeInsets.bottom.string1)")
			append("inset left/right", "\(edgeInsets.left.string1), \(edgeInsets.right.string1)")
			append("scale", scaleString)
			append("position", positionString)
		}

		if let renderer: HCRenderer = self.hcView.metalView?.renderer {
			let edgeInsets: UIEdgeInsets = renderer.scrollAndZoom.zoomToFitEdgeInsets
			append("hcRenderer inset top/bottom", "\(edgeInsets.top.string1), \(edgeInsets.bottom.string1)")
			append("hcRenderer inset left/right", "\(edgeInsets.left.string1), \(edgeInsets.right.string1)")
		} else {
			append("hcRenderer", "nil (This is possible an error state!)")
		}

		self.hcSafeAreaView.verboseInfo(provider)

		SystemInfo().verboseInfo(provider)
	}
}
