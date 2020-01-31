// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import UIKit

typealias WFActivitySpecificItemProviderItemBlock = (UIActivity.ActivityType) -> Any?
let WFActivitySpecificItemProviderTypeDefault = "WFActivitySpecificItemProviderTypeDefault"

class WFActivitySpecificItemProvider: UIActivityItemProvider {
	var items: [AnyHashable: Any]
	var itemBlock: WFActivitySpecificItemProviderItemBlock?

    init(placeholderItem: Any, items: [AnyHashable: Any], block itemBlock: WFActivitySpecificItemProviderItemBlock?) {
		self.items = items
		self.itemBlock = itemBlock
		super.init(placeholderItem: placeholderItem)
    }

    convenience init(placeholderItem: Any, items: [AnyHashable: Any]) {
        self.init(placeholderItem: placeholderItem, items: items, block: nil)
    }

    convenience init(placeholderItem: Any, block itemBlock: @escaping WFActivitySpecificItemProviderItemBlock) {
		self.init(placeholderItem: placeholderItem, items: [:], block: itemBlock)
    }

    convenience override init(placeholderItem: Any) {
		self.init(placeholderItem: placeholderItem, items: [:], block: nil)
    }

    override var item: Any {
        // check items dictionary first
        if let aType = activityType {
			if let item = items[aType] {
				return item
			}
        }
        // try calling block
        if let block = itemBlock, let aType = activityType {
			if let item = block(aType) {
				return item
			}
        }
        // check items dictionary for default
		if let item = items[WFActivitySpecificItemProviderTypeDefault] {
			return item
		}
        // return placeholder as last resort
		if let item = placeholderItem {
			return item
		}
		fatalError("Expected an item, but got nil")
    }
}
