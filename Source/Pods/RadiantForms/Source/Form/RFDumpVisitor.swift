// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFDumpVisitor: RFFormItemVisitor {
	private typealias StringToAny = [String: Any?]

	public init() {
	}

	class func dump(_ prettyPrinted: Bool = true, items: [RFFormItem]) -> Data {
		var result = [StringToAny]()
		var rowNumber: Int = 0
		for item in items {
			let dumpVisitor = RFDumpVisitor()
			item.accept(visitor: dumpVisitor)

			var dict = StringToAny()
			dict["row"] = rowNumber

			let validateVisitor = RFValidateVisitor()
			item.accept(visitor: validateVisitor)
			switch validateVisitor.result {
			case .valid:
				dict["validate-status"] = "ok"
			case .hardInvalid(let message):
				dict["validate-status"] = "hard-invalid"
				dict["validate-message"] = message
			case .softInvalid(let message):
				dict["validate-status"] = "soft-invalid"
				dict["validate-message"] = message
			}

			dict.rf_update(dumpVisitor.dict)

			result.append(dict)
			rowNumber += 1
		}

		return RFJSONHelper.convert(result, prettyPrinted: prettyPrinted)
	}

	private var dict = StringToAny()

    public func visit(object: RFAmountFormItem) {
        dict["class"] = "RFAmountFormItem"
        dict["elementIdentifier"] = object.elementIdentifier
        dict["styleIdentifier"] = object.styleIdentifier
        dict["styleClass"] = object.styleClass
    }
    
	public func visit(object: RFMetaFormItem) {
		dict["class"] = "RFMetaFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
	}

	public func visit(object: RFCustomFormItem) {
		dict["class"] = "RFCustomFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: RFStaticTextFormItem) {
		dict["class"] = "RFStaticTextFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}

	public func visit(object: RFAttributedTextFormItem) {
		dict["class"] = "RFAttributedTextFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title?.string
		dict["value"] = object.value?.string
	}

	public func visit(object: RFTextFieldFormItem) {
		dict["class"] = "RFTextFieldFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
		dict["placeholder"] = object.placeholder
	}

	public func visit(object: RFTextViewFormItem) {
		dict["class"] = "RFTextViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}

	public func visit(object: RFViewControllerFormItem) {
		dict["class"] = "RFViewControllerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: RFOptionPickerFormItem) {
		dict["class"] = "RFOptionPickerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["placeholder"] = object.placeholder
		dict["value"] = object.selected?.title
	}

	public func visit(object: RFDatePickerFormItem) {
		dict["class"] = "RFDatePickerFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["date"] = object.value
		dict["datePickerMode"] = object.datePickerMode.description
		dict["locale"] = object.locale
		dict["minimumDate"] = object.minimumDate
		dict["maximumDate"] = object.maximumDate
		dict["minuteInterval"] = object.minuteInterval
	}

	public func visit(object: RFButtonFormItem) {
		dict["class"] = "RFButtonFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: RFOptionRowFormItem) {
		dict["class"] = "RFOptionRowFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["state"] = object.selected
	}

	public func visit(object: RFSwitchFormItem) {
		dict["class"] = "RFSwitchFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
		dict["value"] = object.value
	}

	public func visit(object: RFStepperFormItem) {
		dict["class"] = "RFStepperFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: RFSliderFormItem) {
		dict["class"] = "RFSliderFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
		dict["minimumValue"] = object.minimumValue
		dict["maximumValue"] = object.maximumValue
	}

	public func visit(object: RFPrecisionSliderFormItem) {
		dict["class"] = "RFPrecisionSliderFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["value"] = object.value
		dict["minimumValue"] = object.minimumValue
		dict["maximumValue"] = object.maximumValue
		dict["decimalPlaces"] = object.decimalPlaces
	}

	public func visit(object: RFSectionFormItem) {
		dict["class"] = "RFSectionFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: RFSectionHeaderTitleFormItem) {
		dict["class"] = "RFSectionHeaderTitleFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: RFSectionHeaderViewFormItem) {
		dict["class"] = "RFSectionHeaderViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: RFSectionFooterTitleFormItem) {
		dict["class"] = "RFSectionFooterTitleFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
		dict["title"] = object.title
	}

	public func visit(object: RFSectionFooterViewFormItem) {
		dict["class"] = "RFSectionFooterViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: RFSegmentedControlFormItem) {
		dict["class"] = "RFSegmentedControlFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}

	public func visit(object: RFPickerViewFormItem) {
		dict["class"] = "RFPickerViewFormItem"
		dict["elementIdentifier"] = object.elementIdentifier
		dict["styleIdentifier"] = object.styleIdentifier
		dict["styleClass"] = object.styleClass
	}
}

internal struct RFJSONHelper {

	/// Convert from a complex object to a simpler json object.
	///
	/// This function is recursive.
	///
	/// - parameter objectOrNil: The complex object to be converted.
	///
	/// - returns: a converted object otherwise NSNull.
	static func process(_ objectOrNil: Any?) -> Any {
		guard let object = objectOrNil else {
			return NSNull()
		}
		if object is NSNull {
			return NSNull()
		}
		if let dict = object as? NSDictionary {
			var result = [String: Any]()
			for (keyObject, valueObject) in dict {
				guard let key = keyObject as? String else {
					print("Expected string for key, skipping key: \(keyObject)")
					continue
				}
				result[key] = process(valueObject)
			}
			return result
		}
		if let array = object as? NSArray {
			var result = [Any]()
			for valueObject in array {
				let item = process(valueObject)
				result.append(item)
			}
			return result
		}
		if let item = object as? String {
			return item
		}
		if let item = object as? Bool {
			return item
		}
		if let item = object as? Int {
			return item
		}
		if let item = object as? UInt {
			return item
		}
		if let item = object as? Float {
			return item
		}
		if let item = object as? Double {
			return item
		}
		if let item = object as? NSNumber {
			return item
		}
		if let item = object as? Date {
			return item.description
		}

		print("skipping unknown item: \(object)  \(object.self)")
		return NSNull()
	}

	/// Convert from a complex object to json data.
	///
	/// - parameter unprocessedObject: The complex object to be converted.
	/// - parameter prettyPrinted: If true then the json is formatted so it's human readable.
	///
	/// - returns: Data object containing json.
	static func convert(_ unprocessedObject: Any?, prettyPrinted: Bool) -> Data {
		let object = process(unprocessedObject)

		if !JSONSerialization.isValidJSONObject(object) {
			print("the dictionary cannot be serialized to json")
			return Data()
		}

		do {
			let options: JSONSerialization.WritingOptions = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
			let data = try JSONSerialization.data(withJSONObject: object, options: options)
			return data
		} catch _ {
		}

		return Data()
	}
}

@available(*, unavailable, renamed: "RFDumpVisitor")
typealias DumpVisitor = RFDumpVisitor
