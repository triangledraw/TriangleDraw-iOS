// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFSimpleToolbar: UIToolbar {
	public var jumpToPrevious: () -> Void = {}
	public var jumpToNext: () -> Void = {}
	public var dismissKeyboard: () -> Void = {}

	public init() {
		super.init(frame: CGRect.zero)
		self.backgroundColor = UIColor.white
		self.items = self.toolbarItems()
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin]
	}

	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    public static func configureAppearance(whenContainedInInstancesOf containerTypes: [UIAppearanceContainer.Type], theme: RFTheme) {
        do {
            let appearanceProxy: UINavigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: containerTypes)
            appearanceProxy.barTintColor = theme.navigationBar.barTintColor
            appearanceProxy.tintColor = theme.navigationBar.tintColor
        }
        do {
            let appearanceProxy: RFSimpleToolbar = RFSimpleToolbar.appearance(whenContainedInInstancesOf: containerTypes)
            appearanceProxy.barTintColor = theme.toolBar.barTintColor
            appearanceProxy.tintColor = theme.toolBar.tintColor
        }
    }

	public lazy var previousButton: UIBarButtonItem = {
		let image = UIImage(named: "RadiantForms_ArrowLeft", in: Bundle(for: type(of: self)), compatibleWith: nil)
		if let image = image {
			let image2 = image.withRenderingMode(.alwaysTemplate)
			return UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(previousButtonAction))
		}
		return UIBarButtonItem(title: "◀︎", style: .plain, target: self, action: #selector(previousButtonAction))
		}()

	public lazy var nextButton: UIBarButtonItem = {
		let image = UIImage(named: "RadiantForms_ArrowRight", in: Bundle(for: type(of: self)), compatibleWith: nil)
		if let image = image {
			let image2 = image.withRenderingMode(.alwaysTemplate)
			return UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(nextButtonAction))
		}
		return UIBarButtonItem(title: "▶", style: .plain, target: self, action: #selector(nextButtonAction))
		}()

	public lazy var closeButton: UIBarButtonItem = {
		let item = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(closeButtonAction))
		return item
		}()

	public func toolbarItems() -> [UIBarButtonItem] {
		let spacer0 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
		spacer0.width = 15.0

		let spacer1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

		var items = [UIBarButtonItem]()
		items.append(previousButton)
		items.append(spacer0)
		items.append(nextButton)
		items.append(spacer1)
		items.append(closeButton)
		return items
	}

	@objc public func previousButtonAction() {
		jumpToPrevious()
	}

	@objc public func nextButtonAction() {
		jumpToNext()
	}

	@objc public func closeButtonAction() {
		dismissKeyboard()
	}

	public func updateButtonConfiguration(_ cell: UITableViewCell) {
		previousButton.isEnabled = cell.rf_canMakePreviousCellFirstResponder()
		nextButton.isEnabled = cell.rf_canMakeNextCellFirstResponder()
	}
}


@available(*, unavailable, renamed: "RFSimpleToolbar")
typealias SimpleToolbar = RFSimpleToolbar
