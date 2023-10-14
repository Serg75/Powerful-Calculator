//
//  ArithmeticExpression.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-13.
//

import Foundation

enum ArithmeticExpression {
    case number(Double)
    indirect case addition(ArithmeticExpression, Double)
    indirect case subtraction(ArithmeticExpression, Double)
    indirect case multiplication(ArithmeticExpression, Double)
    indirect case division(ArithmeticExpression, Double)
    indirect case sine(ArithmeticExpression)
    indirect case cosine(ArithmeticExpression)
}
