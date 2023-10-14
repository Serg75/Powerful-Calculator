//
//  LogicCoreTests.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import XCTest

@testable import Calculator

final class LogicCoreTests: XCTestCase {
    let logicCore = LogicCore()

    func testEvaluate() {
        // Test addition
        let additionExpression: ArithmeticExpression = .addition(.number(3), 4)
        XCTAssertEqual(logicCore.evaluate(additionExpression), 7.0)

        // Test subtraction
        let subtractionExpression: ArithmeticExpression = .subtraction(.number(10), 5)
        XCTAssertEqual(logicCore.evaluate(subtractionExpression), 5.0)

        // Test multiplication
        let multiplicationExpression: ArithmeticExpression = .multiplication(.number(6), 8)
        XCTAssertEqual(logicCore.evaluate(multiplicationExpression), 48.0)

        // Test division
        let divisionExpression: ArithmeticExpression = .division(.number(9), 3)
        XCTAssertEqual(logicCore.evaluate(divisionExpression), 3.0)

        // Test sine
        let sineExpression: ArithmeticExpression = .sine(.number(90)) // sin(π/2) = 1.0
        XCTAssertEqual(logicCore.evaluate(sineExpression), 1.0, accuracy: 0.0001)

        // Test cosine
        let cosineExpression: ArithmeticExpression = .cosine(.number(0)) // cos(0) = 1.0
        XCTAssertEqual(logicCore.evaluate(cosineExpression), 1.0, accuracy: 0.0001)
    }

    func testTraverseSimple() {
        // Test expression: (2 + 3) * 4 = 20
        let sum: ArithmeticExpression = .addition(.number(2), 3)
        let product: ArithmeticExpression = .multiplication(sum, 4)
        let traversalResult = logicCore.traverse(product)

        let expectedTraversal: [(String, Double?)] = [
            ("2", nil),
            ("+", nil),
            ("3", 5),
            ("*", nil),
            ("4", 20)
        ]

        // Swift tuples aren't Equatable, so we can't use them with simple equal assertion
        XCTAssertTrue(traversalResult.elementsEqual(expectedTraversal, by: { left, right in
            left == right
        }), printNonEqualElements(traversalResult, expectedTraversal))
    }

    func testTraverseComplex() {
        // Test expression: cos(360 * sin(5.5 / 0.1 - 25)) = -1.0
        let division: ArithmeticExpression = .division(.number(5.5), 0.1)
        let sub: ArithmeticExpression = .subtraction(division, 25)
        let sin: ArithmeticExpression = .sine(sub)
        let product: ArithmeticExpression = .multiplication(sin, 360)
        let cos: ArithmeticExpression = .cosine(product)
        let traversalResult = logicCore.traverse(cos)

        let expectedTraversal: [(String, Double?)] = [
            ("5.5", nil),
            ("/", nil),
            ("0.1", 55),
            ("-", nil),
            ("25", 30),
            ("sin(30)", 0.5),
            ("*", nil),
            ("360", 180),
            ("cos(180)", -1),
        ]

        // Swift tuples aren't Equatable, so we can't use them with simple equal assertion
        XCTAssertTrue(traversalResult.elementsEqual(expectedTraversal, by: { left, right in
            left == right
        }), printNonEqualElements(traversalResult, expectedTraversal))
    }
}
