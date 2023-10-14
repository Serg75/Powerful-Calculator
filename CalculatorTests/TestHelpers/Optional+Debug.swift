//
//  Optional+Debug.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-14.
//

import Foundation

// Printing Optional variables without "Optional()".

fileprivate protocol Unwrappable {
    func unwrappedValue() -> Any
}

extension Optional: Unwrappable {
    fileprivate func unwrappedValue() -> Any {
        switch self {
        case .some(let wrapped as Unwrappable):
            return wrapped.unwrappedValue()
        case .some(let wrapped):
            return wrapped
        case .none:
            return self as Any
        }
    }
}

postfix operator ~?

/// Unwraps Optionals for debugging purpose
/// - Parameter x: Optional value, e.g. Optional(36)
/// - Returns: Unwrapped Optional value, e.g. 36
public postfix func ~? <X> (x: X?) -> Any {
    return x.unwrappedValue()
}
