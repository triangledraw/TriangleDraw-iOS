// MIT license. Copyright (c) 2019 TriangleDraw. All rights reserved.
import UIKit
import TriangleDrawLibrary
import RadiantForms

class HCMenuSubdivideViewController: RFFormViewController {
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
			self?.applyAndDismiss()
		}
		return instance
	}()

	func applyAndDismiss() {
		let item: String = divisionSize.selectedItem ?? "N/A"
		log.debug("selected: \(item)")
//		self.dismiss(animated: true)
	}
}
