// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public class RFTextFieldFormItem: RFFormItem {
	override func accept(visitor: RFFormItemVisitor) {
		visitor.visit(object: self)
	}

	public var keyboardType: UIKeyboardType = .default

	@discardableResult
	public func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
		self.keyboardType = keyboardType
		return self
	}

	public var autocorrectionType: UITextAutocorrectionType = .no
	public var autocapitalizationType: UITextAutocapitalizationType = .none
	public var spellCheckingType: UITextSpellCheckingType = .no
	public var secureTextEntry = false

	public var returnKeyType: UIReturnKeyType = .default

	@discardableResult
	public func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
		self.returnKeyType = returnKeyType
		return self
	}

	public typealias SyncBlock = (_ value: String) -> Void
	public var syncCellWithValue: SyncBlock = { (string: String) in
		RFLog("sync is not overridden")
	}

	internal var innerValue: String = ""
	public var value: String {
		get {
			return self.innerValue
		}
		set {
			self.assignValueAndSync(newValue)
		}
	}

	public typealias TextDidChangeBlock = (_ value: String) -> Void
	public var textDidChangeBlock: TextDidChangeBlock = { (value: String) in
		RFLog("not overridden")
	}
    
    public func textDidChange(_ value: String) {
        innerValue = value
        textDidChangeBlock(value)
    }
    
	public typealias TextEditingEndBlock = (_ value: String) -> Void
	public var textEditingEndBlock: TextEditingEndBlock = { (value: String) in
		RFLog("not overridden")
	}
	
	public func editingEnd(_ value: String) {
		textEditingEndBlock(value)
	}
	
	public func assignValueAndSync(_ value: String) {
		innerValue = value
		syncCellWithValue(value)
	}

	public var reloadPersistentValidationState: () -> Void = {}

	public var obtainTitleWidth: () -> CGFloat = {
		return 0
	}

	public var assignTitleWidth: (CGFloat) -> Void = { (width: CGFloat) in
		// do nothing
	}

	public var placeholder: String = ""

	@discardableResult
	public func placeholder(_ placeholder: String) -> Self {
		self.placeholder = placeholder
		return self
	}

	public var title: String = ""

	@discardableResult
	public func title(_ title: String) -> Self {
		self.title = title
		return self
	}

	@discardableResult
	public func password() -> Self {
		self.secureTextEntry = true
		return self
	}

	public let validatorBuilder = RFValidatorBuilder()

	@discardableResult
	public func validate(_ specification: RFSpecification, message: String) -> Self {
		validatorBuilder.hardValidate(specification, message: message)
		return self
	}

	@discardableResult
	public func softValidate(_ specification: RFSpecification, message: String) -> Self {
		validatorBuilder.softValidate(specification, message: message)
		return self
	}

	@discardableResult
	public func submitValidate(_ specification: RFSpecification, message: String) -> Self {
		validatorBuilder.submitValidate(specification, message: message)
		return self
	}

	@discardableResult
	public func required(_ message: String) -> Self {
		submitValidate(RFCountSpecification.min(1), message: message)
		return self
	}

	public func liveValidateValueText() -> RFValidateResult {
		return  validatorBuilder.build().liveValidate(self.value)
	}

	public func liveValidateText(_ text: String) -> RFValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: false)
	}

	public func submitValidateValueText() -> RFValidateResult {
		return validatorBuilder.build().submitValidate(self.value)
	}

	public func submitValidateText(_ text: String) -> RFValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: true, checkSoftRule: true, checkSubmitRule: true)
	}

	public func validateText(_ text: String, checkHardRule: Bool, checkSoftRule: Bool, checkSubmitRule: Bool) -> RFValidateResult {
		return validatorBuilder.build().validate(text, checkHardRule: checkHardRule, checkSoftRule: checkSoftRule, checkSubmitRule: checkSubmitRule)
	}
}

@available(*, unavailable, renamed: "RFTextFieldFormItem")
typealias TextFieldFormItem = RFTextFieldFormItem
