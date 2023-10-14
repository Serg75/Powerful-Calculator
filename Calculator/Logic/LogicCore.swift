//
//  LogicCore.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import Foundation

class LogicCore {
    
    /// Evaluates given Arithmetic Expression into a result.
    /// - Parameter expression: Arithmetic Expression for evaluation.
    /// - Returns: Evaluation result as a number.
    func evaluate(_ expression: ArithmeticExpression) -> Double {
        switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return (evaluate(left) + right).roundedWithDecimals
        case let .subtraction(left, right):
            return (evaluate(left) - right).roundedWithDecimals
        case let .multiplication(left, right):
            return (evaluate(left) * right).roundedWithDecimals
        case let .division(left, right):
            return (evaluate(left) / right).roundedWithDecimals
        case let .sine(value):
            return sin(evaluate(value) * Double.pi / 180).roundedWithDecimals
        case let .cosine(value):
            return cos(evaluate(value) * Double.pi / 180).roundedWithDecimals
        }
    }
    
    /// Converts Arithmetic Expression into an array of commands and results.
    /// Uses for presenting the calculation history.
    /// - Parameter expression: Arithmetic Expression for conversion.
    /// - Returns: An array of commands and results.
    func traverse(_ expression: ArithmeticExpression) -> [(String, Double?)] {
        var result = [(String, Double?)]()
        switch expression {
        case let .number(value):
            result.append((value.cleanString, nil))
        case let .addition(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("+", nil))
            result.append((right.cleanString, evaluate(expression)))
        case let .subtraction(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("-", nil))
            result.append((right.cleanString, evaluate(expression)))
        case let .multiplication(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("*", nil))
            result.append((right.cleanString, evaluate(expression)))
        case let .division(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("/", nil))
            result.append((right.cleanString, evaluate(expression)))
        case let .sine(value):
            result.append(contentsOf: traverse(value))
            result.append(("sin(\(evaluate(value).cleanString))", evaluate(expression)))
        case let .cosine(value):
            result.append(contentsOf: traverse(value))
            result.append(("cos(\(evaluate(value).cleanString))", evaluate(expression)))
        }
        return result
    }
}
