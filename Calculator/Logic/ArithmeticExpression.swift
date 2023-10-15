//
//  ArithmeticExpression.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import Foundation

enum ArithmeticExpression {
    case number(EditableNumber)
    indirect case addition(ArithmeticExpression, EditableNumber)
    indirect case subtraction(ArithmeticExpression, EditableNumber)
    indirect case multiplication(ArithmeticExpression, EditableNumber)
    indirect case division(ArithmeticExpression, EditableNumber)
    indirect case sine(ArithmeticExpression)
    indirect case cosine(ArithmeticExpression)
    case empty  // No expression
}

extension ArithmeticExpression {
    var hasSecondArgument: Bool {
        switch self {
        case .addition, .subtraction, .multiplication, .division:
            return true
        default:
            return false
        }
    }
    
    var secondArgument: EditableNumber {
        switch self {
        case .addition(_, let right):
            return right
        case .subtraction(_, let right):
            return right
        case .multiplication(_, let right):
            return right
        case .division(_, let right):
            return right
        default:
            return EditableNumber()
        }
    }

    mutating func replaceSecondArgument(_ newArgument: EditableNumber) {
        switch self {
        case .addition(let left, _):
            self = .addition(left, newArgument)
        case .subtraction(let left, _):
            self = .subtraction(left, newArgument)
        case .multiplication(let left, _):
            self = .multiplication(left, newArgument)
        case .division(let left, _):
            self = .division(left, newArgument)
        default:
            break
        }
    }
    
}

extension ArithmeticExpression {
    mutating func wrapInOperation(_ command: Command) {
        switch command {
        case .plus:
            self = .addition(self, EditableNumber())
        case .minus:
            self = .subtraction(self, EditableNumber())
        case .multiply:
            self = .multiplication(self, EditableNumber())
        case .divide:
            self = .division(self, EditableNumber())
        default:
            break
        }
    }

    mutating func wrapInFunction(_ command: Command) {
        switch command {
        case .sin:
            self = .sine(self)
        case .cos:
            self = .cosine(self)
        default:
            break
        }
    }
    
    mutating func unWrap() -> Bool {
        switch self {
        case .addition(let left, _):
            self = left
            return true
        case .subtraction(let left, _):
            self = left
            return true
        case .multiplication(let left, _):
            self = left
            return true
        case .division(let left, _):
            self = left
            return true
        case .sine(let expr):
            self = expr
            return true
        case .cosine(let expr):
            self = expr
            return true
        default:
            return false
        }
    }
}
