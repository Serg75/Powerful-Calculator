//
//  XCTestCase+Debug.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-14.
//

import XCTest

extension XCTestCase {
    
    // Prints the non-equal elements from two collections with element type as (String, Double?)
    func printNonEqualElements(_ left: [(String, Double?)], _ right: [(String, Double?)]) -> String {"""
        Non-equal elements:
        \(
        zip(left, right).filter() { $0 != $1 }
            .map{ "\(($0.0.0, $0.0.1~?)) != \(($0.1.0, $0.1.1~?))" }
            .joined(separator: "\n")
        )
        """
    }
}
