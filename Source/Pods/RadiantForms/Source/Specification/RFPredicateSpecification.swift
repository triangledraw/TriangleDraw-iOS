// MIT license. Copyright (c) 2019 RadiantKit. All rights reserved.
import Foundation

/// Check if an object is satisfied by a closure.
///
/// Closure is sometimes preferred instead of subclassing the `RFSpecification` protocol.
public class RFPredicateSpecification<T>: RFSpecification {
	private let predicate: (T) -> Bool

	public init(predicate: @escaping (T) -> Bool) {
		self.predicate = predicate
	}

	/// Check if the closure is satisfied.
	///
	/// - parameter candidate: The object to be checked.
	///
	/// - returns: `true` if the candidate object is of the right type and is satisfied by the closure, `false` otherwise.
	public func isSatisfiedBy(_ candidate: Any?) -> Bool {
		guard let obj = candidate as? T else { return false }
		return predicate(obj)
	}
}

@available(*, unavailable, renamed: "RFPredicateSpecification")
typealias PredicateSpecification = RFPredicateSpecification
