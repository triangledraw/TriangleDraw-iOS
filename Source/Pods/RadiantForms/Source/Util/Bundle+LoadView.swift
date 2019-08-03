// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

extension Bundle {
	public enum RFLoadViewError: Error {
		case expectedXibToExistButGotNil
		case expectedXibToContainJustOneButGotDifferentNumberOfObjects
		case xibReturnedWrongType
	}

    @available(*, unavailable, renamed: "RFLoadViewError")
    typealias FormLoadViewError = RFLoadViewError

	/* 
	usage:
	let cell: ContactPickerCell = try Bundle.main.rf_loadView("ContactPickerCell")
	*/
	public func rf_loadView<T>(_ name: String) throws -> T {
		guard let topLevelObjects = loadNibNamed(name, owner: self, options: nil) else {
			throw RFLoadViewError.expectedXibToExistButGotNil
		}
		guard topLevelObjects.count == 1 else {
			throw RFLoadViewError.expectedXibToContainJustOneButGotDifferentNumberOfObjects
		}
		guard let result = topLevelObjects.first as? T else {
			throw RFLoadViewError.xibReturnedWrongType
		}
		return result
	}

    @available(*, deprecated, message: "Will be removed with Version2, use rf_loadView instead")
    public func form_loadView<T>(_ name: String) throws -> T {
        return try rf_loadView(name)
    }
}
