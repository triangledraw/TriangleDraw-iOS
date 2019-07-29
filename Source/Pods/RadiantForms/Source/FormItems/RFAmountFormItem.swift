// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import UIKit

public typealias RFAmountValue = UInt64

public class RFAmountFormItem: RFFormItem {
    override func accept(visitor: RFFormItemVisitor) {
        visitor.visit(object: self)
    }
    
    public var returnKeyType: UIReturnKeyType = .default
    
    @discardableResult
    public func returnKeyType(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }
    
    public typealias SyncBlock = (_ value: RFAmountValue) -> Void
    public var syncCellWithValue: SyncBlock = { (_) in
        RFLog("sync is not overridden")
    }
    
    internal var innerValue: RFAmountValue = 0
    public var value: RFAmountValue {
        get {
            return self.innerValue
        }
        set {
            self.assignValueAndSync(newValue)
        }
    }
    
    public typealias ValueDidChangeBlock = (_ value: RFAmountValue) -> Void
    public var valueDidChangeBlock: ValueDidChangeBlock = { (value: RFAmountValue) in
        RFLog("not overridden")
    }
    
    public func valueDidChange(_ value: RFAmountValue) {
        innerValue = value
        valueDidChangeBlock(value)
    }
    
    public func assignValueAndSync(_ value: RFAmountValue) {
        innerValue = value
        syncCellWithValue(value)
    }
    
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

    public var maxIntegerDigits: UInt8 = 10
    
    @discardableResult
    public func maxIntegerDigits(_ count: UInt8) -> Self {
        self.maxIntegerDigits = count
        return self
    }

    /// `fractionDigits` is typically between 0 and 5
    public var fractionDigits: UInt8 = 3
    
    @discardableResult
    public func fractionDigits(_ fractionDigits: UInt8) -> Self {
        self.fractionDigits = fractionDigits
        return self
    }

    public var title: String = ""
    
    @discardableResult
    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }

    public var unitSuffix: String = ""
    
    @discardableResult
    public func unitSuffix(_ unitSuffix: String) -> Self {
        self.unitSuffix = unitSuffix
        return self
    }

    /// The `numberFormatter` is optional.
    ///
    /// When providing a `numberFormatter`, then ensure that
    /// both `minimumFractionDigits` and `maximumFractionDigits` gets assigned to `fractionDigits`.
    public var numberFormatter: NumberFormatter? = nil
}


@available(*, unavailable, renamed: "RFAmountValue")
typealias AmountValue = RFAmountValue

@available(*, unavailable, renamed: "RFAmountFormItem")
typealias AmountFormItem = RFAmountFormItem
