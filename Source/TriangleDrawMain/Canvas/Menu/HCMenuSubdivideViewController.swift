// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary
import RadiantForms

protocol HCMenuSubdivideViewControllerDelegate: class {
	func hcMenuSubdivideViewController_apply(n: UInt8)
}

class HCMenuSubdivideViewController: RFFormViewController {
	weak var delegate: HCMenuSubdivideViewControllerDelegate?

	override func populate(_ builder: RFFormBuilder) {
		builder.navigationTitle = "Subdivide"
		builder.demo_showInfo("Split up all triangles\ninto smaller triangles.")
		builder += divisionSize
		builder += applyButton
	}

	lazy var divisionSize: RFSegmentedControlFormItem = {
		let instance = RFSegmentedControlFormItem()
		instance.title = "Divisions"
		instance.items = ["2", "3", "4", "5", "6", "7"]
		return instance
	}()

	lazy var applyButton: RFButtonFormItem = {
		let instance = RFButtonFormItem()
		instance.title = "Apply"
		instance.action = { [weak self] in
			self?.applyAction()
		}
		return instance
	}()

	func applyAction() {
		guard let delegate = self.delegate else {
			log.error("Expected non-nil delegate, but got nil")
			return
		}
		let valueString: String = divisionSize.selectedItem ?? "N/A"
		let value = UInt8(valueString) ?? 255
		guard value >= 2 && value <= 7 else {
			log.error("Expected N to be 2...7, but got \(valueString)")
			return
		}
		delegate.hcMenuSubdivideViewController_apply(n: value)
	}
}
