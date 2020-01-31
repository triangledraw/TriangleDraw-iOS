// MIT license. Copyright (c) 2020 TriangleDraw. All rights reserved.
import Foundation

public class E2TagPair: NSObject {
    public var tag0: Int = 0
    public var tag1: Int = 0

	public static func create(tag0: Int, tag1: Int) -> E2TagPair {
		let pair = E2TagPair()
		pair.tag0 = tag0
		pair.tag1 = tag1
		return pair
	}

    static func dictionary(fromPairs pairs: [E2TagPair]) -> [Int: Int] {
        var indexsets = [IndexSet]()
        for pair: E2TagPair in pairs {
			let indexsetOrNil0: IndexSet? = indexsets.firstContainingTag(pair.tag0)
			let indexsetOrNil1: IndexSet? = indexsets.firstContainingTag(pair.tag1)
            if indexsetOrNil0 == nil && indexsetOrNil1 == nil {
                var indexset = IndexSet()
                indexset.insert(pair.tag0)
                indexset.insert(pair.tag1)
                indexsets.append(indexset)
                continue
            }
            if indexsetOrNil0 == indexsetOrNil1 {
                // indexset already contain tag0 and tag1
                continue
            }
            if indexsetOrNil1 == nil, let indexset = indexsetOrNil0 {
				indexsets = indexsets.filter { $0 != indexset }
				indexsets.append(indexset.union(IndexSet(integer: pair.tag1)))
                continue
            }
			if indexsetOrNil0 == nil, let indexset = indexsetOrNil1 {
				indexsets = indexsets.filter { $0 != indexset }
				indexsets.append(indexset.union(IndexSet(integer: pair.tag0)))
                continue
            }
			// Merge indexset0 with indexset1
			let indexset0: IndexSet = indexsetOrNil0 ?? IndexSet()
			let indexset1: IndexSet = indexsetOrNil1 ?? IndexSet()
			indexsets.append(indexset0.union(indexset1))
			indexsets = indexsets.filter { $0 != indexset0 }
			indexsets = indexsets.filter { $0 != indexset1 }
        }
        var replacements = [Int: Int]()
        for indexset: IndexSet in indexsets {
			guard let first: Int = indexset.first else {
				continue
			}
			for (_, index) in indexset.enumerated() {
				if index != first {
					replacements[index] = first
				}
			}
        }
        return replacements
    }
}

extension Collection where Element == IndexSet {
	fileprivate func firstContainingTag(_ tag: Int) -> IndexSet? {
		return self.first { $0.contains(tag) }
	}
}
