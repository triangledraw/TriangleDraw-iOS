// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

open class RFFormViewController: UIViewController {
	public var dataSource: RFTableViewSectionArray?
	public var keyboardHandler: RFKeyboardHandler?

	public init() {
		RFLog("super init")
		super.init(nibName: nil, bundle: nil)
	}

	required public init?(coder aDecoder: NSCoder) {
		RFLog("super init")
		super.init(coder: aDecoder)
	}

	override open func loadView() {
		RFLog("super loadview")
		view = tableView
		keyboardHandler = RFKeyboardHandler(tableView: tableView)
		populateAndSetup()
	}

	open func populateAndSetup() {
		populate(formBuilder)
        
        if formBuilder.needsPostPopulate {
            formBuilder.needsPostPopulate = false
            postPopulate(formBuilder)
        }
        
		title = formBuilder.navigationTitle
		dataSource = formBuilder.result(self)
		tableView.dataSource = dataSource
		tableView.delegate = dataSource
	}

	open func reloadForm() {
		formBuilder.removeAll()
		populateAndSetup()
		tableView.reloadData()
	}

    /// This function is required. A subclass must always implement this function.
	open func populate(_ builder: RFFormBuilder) {
		RFLog("subclass must implement populate()")
	}

    /// This function is optional. A subclass may implement this function.
    ///
    /// - This function is invoked the very first time the `populate()` function is invoked.
    /// - This function is not invoked the following times.
    ///
    /// This is the intended place for configuring the initial visible/hidden `RFFormItem`'s
    /// by assigning their `RFFormItem.isHidden` booleans.
    open func postPopulate(_ builder: RFFormBuilder) {
        // This superclass does nothing.
    }
    
	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		keyboardHandler?.addObservers()

		// Fade out, so that the user can see what row has been updated
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	override open func viewDidDisappear(_ animated: Bool) {
		self.keyboardHandler?.removeObservers()
		super.viewDidDisappear(animated)
	}

	public lazy var formBuilder: RFFormBuilder = {
		return RFFormBuilder()
		}()

	public lazy var tableView: RFFormTableView = {
		return RFFormTableView()
		}()
}

@available(*, unavailable, renamed: "RFFormViewController")
typealias FormViewController = RFFormViewController
