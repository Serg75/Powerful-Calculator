//
//  LogicCore.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import Foundation

public class LogicCore {
    
    public var bitcoinValue: Double = .infinity

    public init() { }
        
    /// Evaluates given Arithmetic Expression into a result.
    /// - Parameter expression: Arithmetic Expression for evaluation.
    /// - Returns: Evaluation result as a number.
    func evaluate(_ expression: ArithmeticExpression) -> Double {
        switch expression {
        case let .number(val):
            return val.value
        case let .addition(left, right):
            return (evaluate(left) + right.value).roundedWithDecimals
        case let .subtraction(left, right):
            return (evaluate(left) - right.value).roundedWithDecimals
        case let .multiplication(left, right):
            return (evaluate(left) * right.value).roundedWithDecimals
        case let .division(left, right):
            return (evaluate(left) / right.value).roundedWithDecimals
        case let .sine(value):
            return sin(evaluate(value) * Double.pi / 180).roundedWithDecimals
        case let .cosine(value):
            return cos(evaluate(value) * Double.pi / 180).roundedWithDecimals
        case let .bitcoin(value):
            return bitcoinValue * evaluate(value)
        default:
            return 0.0
        }
    }
    
    
    public func updateExpressions(_ expressions: [ArithmeticExpression], command: Command) -> [ArithmeticExpression] {
        var mutableExpressions = expressions
        
        if mutableExpressions.isEmpty {
            mutableExpressions.append(.number(EditableNumber()))
        }
        
        // Take the last expression
        var lastExpression = mutableExpressions.last!


        switch command {
        case _ where command.isDigit:
            // If the command is a digit and ...
            if case .number(var value) = lastExpression {
                // If the last expression is number, update last expression
                // by adding this digit to the end of the the number.
                value += command.rawValue
                lastExpression = .number(value)
            } else if lastExpression.hasSecondArgument {
                // If the last expression has second argument (e.g. addition),
                // update argument by adding this digit to the end of the argument.
                var value = lastExpression.secondArgument
                value += command.rawValue
                lastExpression.replaceSecondArgument(value)
            } else {
                // Else create new expression .number(0) and add it to the
                // given expressions.
                var newNumber = EditableNumber()
                newNumber += command.rawValue
                let newExpression = ArithmeticExpression.number(newNumber)
                mutableExpressions.append(newExpression)
                lastExpression = .empty
            }
            
        case _ where command.isOperation:
            // If the command is an operation, wrap last expression into a new
            // expression (addition for plus command, etc.) and replace the last
            // expression in the given list by the newly created expression.
            // The second argument for the newly created expression should be 0.
            lastExpression.wrapInOperation(command)
            
        case _ where command.isFunction:
            // If the command is a function, wrap last expression into a new
            // expression (sine for sin command, etc.) and replace the last
            // expression in the given list by the newly created expression.
            lastExpression.wrapInFunction(command)
            
        case .del:
            // If the command is delete and ...
            var done = false
            if case .number(var value) = lastExpression {
                // If the last expression is number, update last expression
                // by removing last digit or separator from the end of the
                // number (removing last 0 should not have any effect).
                if value != "0" {
                    value.removeLast()
                    lastExpression = .number(value)
                    done = true
                }
            } else if lastExpression.hasSecondArgument {
                // If the last expression has second argument (e.g. addition),
                // update this argument by removing last digit or separator
                // from the end of the this argument (removing last 0 should not
                // have any effect).
                var value = lastExpression.secondArgument
                if value != "0" {
                    value.removeLast()
                    lastExpression.replaceSecondArgument(value)
                    done = true
                }
            }
            if !done {
                // Else unwrap the last expression
                if !lastExpression.unWrap() {
                    // If the last expression can not be unwrapped (e.g. it is digit)
                    // remove it.
                    lastExpression = .empty
                    mutableExpressions.removeLast()
                    if mutableExpressions.isEmpty {
                        mutableExpressions.append(.number(EditableNumber()))
                    }
                }
            }
            
        case .reset:
            // If the command is reset, remove all expressions.
            mutableExpressions.removeAll()
            mutableExpressions.append(.number(EditableNumber()))
            lastExpression = .empty
        
        default:
            break
        }
        
        // Update the last expression if it is valid.
        switch lastExpression {
        case .empty:
            break
        default:
            mutableExpressions[mutableExpressions.count - 1] = lastExpression
        }
        
        return mutableExpressions
    }

    /// Converts Arithmetic Expression into an array of commands and results.
    /// Uses for presenting the calculation history.
    /// - Parameter expression: Arithmetic Expression for conversion.
    /// - Returns: An array of commands and results.
    public func traverse(_ expression: ArithmeticExpression) -> [(String, Double?)] {
        var result = [(String, Double?)]()
        switch expression {
        case let .number(val):
            result.append((val.stringValue, nil))
        case let .addition(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("+", nil))
            result.append((right.stringValue, evaluate(expression)))
        case let .subtraction(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("-", nil))
            result.append((right.stringValue, evaluate(expression)))
        case let .multiplication(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("*", nil))
            result.append((right.stringValue, evaluate(expression)))
        case let .division(left, right):
            result.append(contentsOf: traverse(left))
            result.append(("/", nil))
            result.append((right.stringValue, evaluate(expression)))
        case let .sine(value):
            result.append(contentsOf: traverse(value))
            result.append(("sin(\(evaluate(value).cleanString))", evaluate(expression)))
        case let .cosine(value):
            result.append(contentsOf: traverse(value))
            result.append(("cos(\(evaluate(value).cleanString))", evaluate(expression)))
        case let .bitcoin(value):
            result.append(contentsOf: traverse(value))
            result.append(("₿(\(evaluate(value).cleanString))", evaluate(expression)))
        default:
            break
        }
        return result
    }
}
