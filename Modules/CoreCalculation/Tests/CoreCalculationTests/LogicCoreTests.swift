//
//  LogicCoreTests.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import XCTest

@testable import CoreCalculation

final class LogicCoreTests: XCTestCase {
    let logicCore = LogicCore()

    func testEvaluate() {
        // Test addition
        let additionExpression = ArithmeticExpression.makeAddition(3, 4)
        XCTAssertEqual(logicCore.evaluate(additionExpression), 7.0)

        // Test subtraction
        let subtractionExpression = ArithmeticExpression.makeSubtraction(10, 5)
        XCTAssertEqual(logicCore.evaluate(subtractionExpression), 5.0)

        // Test multiplication
        let multiplicationExpression = ArithmeticExpression.makeMultiplication(6, 8)
        XCTAssertEqual(logicCore.evaluate(multiplicationExpression), 48.0)

        // Test division
        let divisionExpression = ArithmeticExpression.makeDivision(9, 3)
        XCTAssertEqual(logicCore.evaluate(divisionExpression), 3.0)

        // Test sine
        let sineExpression = ArithmeticExpression.makeSine(90) // sin(π/2) = 1.0
        XCTAssertEqual(logicCore.evaluate(sineExpression), 1.0, accuracy: 0.0001)

        // Test cosine
        let cosineExpression = ArithmeticExpression.makeCosine(0) // cos(0) = 1.0
        XCTAssertEqual(logicCore.evaluate(cosineExpression), 1.0, accuracy: 0.0001)
    }

    func testTraverseSimple() {
        // Test expression: (2 + 3) * 4 = 20
        let sum = ArithmeticExpression.makeAddition(2, 3)
        let product = ArithmeticExpression.makeMultiplication(sum, 4)
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
        let division = ArithmeticExpression.makeDivision(5.5, 0.1)
        let sub = ArithmeticExpression.makeSubtraction(division, 25)
        let sin: ArithmeticExpression = .sine(sub)
        let product = ArithmeticExpression.makeMultiplication(sin, 360)
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
    
    func testUpdateExpressionsWithDigit() {
        var expressions: [ArithmeticExpression] = []
        let logicCore = LogicCore()

        // Test case 1: Adding digits to an empty list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .d5)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 5.0)
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 2: Adding digits to an existing number
        expressions = logicCore.updateExpressions(expressions, command: .d2)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 52.0)
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 3: Adding digits after a separator
        expressions = logicCore.updateExpressions(expressions, command: .sep)
        expressions = logicCore.updateExpressions(expressions, command: .d9)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 52.9)
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 4: Adding digits to a number with a second argument
        expressions = logicCore.updateExpressions(expressions, command: .plus)
        expressions = logicCore.updateExpressions(expressions, command: .d3)
        XCTAssertEqual(expressions.count, 1)
        if case .addition(let left, let right) = expressions[0],
           case .number(let value) = left {
            XCTAssertEqual(value.value, 52.9)
            XCTAssertEqual(right.value, 3.0)
        } else {
            XCTFail("Expression is not an addition of numbers")
        }
    }

    func testUpdateExpressionsWithOperation() {
        var expressions: [ArithmeticExpression] = []
        let logicCore = LogicCore()

        // Test case 1: Adding an operation to an empty list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .plus)
        XCTAssertEqual(expressions.count, 1)
        if case .addition(let left, let right) = expressions[0],
           case .number(let value) = left {
            XCTAssertEqual(value.value, 0.0)
            XCTAssertEqual(right.value, 0.0)
        } else {
            XCTFail("Expression is not an addition of numbers")
        }

        // Test case 2: Adding an operation after a number
        expressions = logicCore.updateExpressions(expressions, command: .d7)
        expressions = logicCore.updateExpressions(expressions, command: .minus)
        XCTAssertEqual(expressions.count, 1)
        if case .subtraction(let left, let right) = expressions[0],
           case .addition(_, let rightSub) = left {
            XCTAssertEqual(rightSub.value, 7.0)
            XCTAssertEqual(right.value, 0.0)
        } else {
            XCTFail("Expression is not a subtraction of addition and number")
        }

        // Test case 3: Adding an operation after a number with a second argument
        expressions = logicCore.updateExpressions(expressions, command: .multiply)
        XCTAssertEqual(expressions.count, 1)
        if case .multiplication(let left, let right) = expressions[0],
           case .subtraction(_, _) = left {
            XCTAssertEqual(right.value, 0.0)
        } else {
            XCTFail("Expression is not a multiplication of subtraction and number")
        }
    }

    func testUpdateExpressionsWithFunction() {
        var expressions: [ArithmeticExpression] = []
        let logicCore = LogicCore()

        // Test case 1: Adding a function to an empty list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .sin)
        XCTAssertEqual(expressions.count, 1)
        if case .sine(_) = expressions[0] {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expression is not a sine")
        }

        // Test case 2: Adding a number after a function
        expressions = logicCore.updateExpressions(expressions, command: .d3)
        expressions = logicCore.updateExpressions(expressions, command: .d9)
        XCTAssertEqual(expressions.count, 2)
        if case .sine(_) = expressions[0],
           case .number(let value) = expressions[1] {
            XCTAssertEqual(value.value, 39.0)
        } else {
            XCTFail("Expressions are not a sine and number")
        }

        // Test case 3: Adding a function after a number
        expressions = logicCore.updateExpressions(expressions, command: .cos)
        XCTAssertEqual(expressions.count, 2)
        if case .sine(_) = expressions[0],
           case .cosine(let valueCos) = expressions[1],
           case .number(let value) = valueCos {
            XCTAssertEqual(value.value, 39.0)
        } else {
            XCTFail("Expressions are not a sine and cosine")
        }
    }

    func testUpdateExpressionsWithDelete() {
        var expressions: [ArithmeticExpression] = []
        let logicCore = LogicCore()

        // Test case 1: Deleting digits from an empty list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 0.0)
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 2: Deleting digits from a number
        expressions = logicCore.updateExpressions(expressions, command: .d5)
        expressions = logicCore.updateExpressions(expressions, command: .d9)
        expressions = logicCore.updateExpressions(expressions, command: .d2)
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 59.0)
            XCTAssertEqual(value.stringValue, "59")
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 3: Deleting digits after decimal point from a number
        expressions = logicCore.updateExpressions(expressions, command: .sep)
        expressions = logicCore.updateExpressions(expressions, command: .d9)
        expressions = logicCore.updateExpressions(expressions, command: .d2)
        expressions = logicCore.updateExpressions(expressions, command: .del)
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 59.0)
            XCTAssertEqual(value.stringValue, "59.")
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 4: Deleting decimal point from a number
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 59.0)
            XCTAssertEqual(value.stringValue, "59")
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 5: Deleting digits from a second argument
        expressions = logicCore.updateExpressions(expressions, command: .plus)
        expressions = logicCore.updateExpressions(expressions, command: .d7)
        expressions = logicCore.updateExpressions(expressions, command: .d3)
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .addition(let left, let secondValue) = expressions[0],
           case .number(let firstValue) = left {
            XCTAssertEqual(firstValue.value, 59.0)
            XCTAssertEqual(secondValue.value, 7.0)
        } else {
            XCTFail("Expression is not an addition of numbers")
        }

        // Test case 6: Deleting a second argument
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .addition(let left, let secondValue) = expressions[0],
           case .number(let firstValue) = left {
            XCTAssertEqual(firstValue.value, 59.0)
            XCTAssertEqual(secondValue.value, 0.0)
        } else {
            XCTFail("Expression is not an addition of numbers")
        }

        // Test case 7: Deleting an operation
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 59.0)
            XCTAssertEqual(value.stringValue, "59")
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 8: Deleting a function
        expressions = logicCore.updateExpressions(expressions, command: .sin)
        expressions = logicCore.updateExpressions(expressions, command: .del)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 59.0)
            XCTAssertEqual(value.stringValue, "59")
        } else {
            XCTFail("Expression is not a number")
        }
    }

    func testUpdateExpressionsWithReset() {
        var expressions: [ArithmeticExpression] = []
        let logicCore = LogicCore()

        // Test case 1: Resetting an empty list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .reset)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 0.0)
        } else {
            XCTFail("Expression is not a number")
        }

        // Test case 2: Resetting a list of expressions
        expressions = logicCore.updateExpressions(expressions, command: .d5)
        expressions = logicCore.updateExpressions(expressions, command: .plus)
        expressions = logicCore.updateExpressions(expressions, command: .d3)
        expressions = logicCore.updateExpressions(expressions, command: .reset)
        XCTAssertEqual(expressions.count, 1)
        if case .number(let value) = expressions[0] {
            XCTAssertEqual(value.value, 0.0)
        } else {
            XCTFail("Expression is not a number")
        }
    }
}
