//
//  ArithmeticExpression+Helpers.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-15.
//

import Foundation

@testable import CoreCalculation

extension ArithmeticExpression {
    static func makeNumber(_ value: Double) -> ArithmeticExpression {
        .number(EditableNumber(value))
    }
    
    static func makeSine(_ value: Double) -> ArithmeticExpression {
        .sine(.number(EditableNumber(value)))
    }
    
    static func makeCosine(_ value: Double) -> ArithmeticExpression {
        .cosine(.number(EditableNumber(value)))
    }

    static func makeAddition(_ left: Double, _ right: Double) -> ArithmeticExpression {
        .addition(.number(EditableNumber(left)), EditableNumber(right))
    }
    
    static func makeSubtraction(_ left: Double, _ right: Double) -> ArithmeticExpression {
        .subtraction(.number(EditableNumber(left)), EditableNumber(right))
    }
    
    static func makeSubtraction(_ left: ArithmeticExpression, _ right: Double) -> ArithmeticExpression {
        .subtraction(left, EditableNumber(right))
    }
    
    static func makeMultiplication(_ left: Double, _ right: Double) -> ArithmeticExpression {
        .multiplication(.number(EditableNumber(left)), EditableNumber(right))
    }
    
    static func makeMultiplication(_ left: ArithmeticExpression, _ right: Double) -> ArithmeticExpression {
        .multiplication(left, EditableNumber(right))
    }
    
    static func makeDivision(_ left: Double, _ right: Double) -> ArithmeticExpression {
        .division(.number(EditableNumber(left)), EditableNumber(right))
    }
}

