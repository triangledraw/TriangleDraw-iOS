// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

public class RFTextFormItem: RFFormItem {
    public let text: String

    public init(_ text: String) {
        self.text = text
        super.init()
    }

    override func accept(visitor: RFFormItemVisitor) {
        visitor.visit(object: self)
    }
}
