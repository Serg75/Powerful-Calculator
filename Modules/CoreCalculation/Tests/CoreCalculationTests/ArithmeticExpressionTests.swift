//
//  ArithmeticExpressionTests.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-15.
//

import XCTest

@testable import CoreCalculation

final class ArithmeticExpressionTests: XCTestCase {
    func testHasSecondArgument() {
        let additionExpression = ArithmeticExpression.makeAddition(5, 1)
        XCTAssertTrue(additionExpression.hasSecondArgument)
        
        let subtractionExpression = ArithmeticExpression.makeSubtraction(3, 2)
        XCTAssertTrue(subtractionExpression.hasSecondArgument)
        
        let sineExpression = ArithmeticExpression.makeSine(90)
        XCTAssertFalse(sineExpression.hasSecondArgument)
    }
    
    func testSecondArgument() {
        let additionExpression = ArithmeticExpression.makeAddition(5, 2)
        XCTAssertEqual(additionExpression.secondArgument, EditableNumber(2))
        
        let subtractionExpression = ArithmeticExpression.makeSubtraction(3, 1)
        XCTAssertEqual(subtractionExpression.secondArgument, EditableNumber(1))
        
        let sineExpression = ArithmeticExpression.makeSine(90)
        XCTAssertEqual(sineExpression.secondArgument, EditableNumber())
    }
    
    func testReplaceSecondArgument() {
        var additionExpression = ArithmeticExpression.makeAddition(5, 1)
        var newArgument = EditableNumber(3)
        
        additionExpression.replaceSecondArgument(newArgument)
        XCTAssertEqual(additionExpression.secondArgument, newArgument)
    }
    
    func testWrapInOperation() {
        var expression = ArithmeticExpression.makeNumber(3)
        expression.wrapInOperation(.plus)
        
        if case .addition(_, _) = expression {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testWrapInFunction() {
        var expression = ArithmeticExpression.makeNumber(90)
        expression.wrapInFunction(.sin)
        
        if case .sine(_) = expression {
            XCTAssertTrue(true)
        } else {
            XCTAssertTrue(false)
        }
    }
    
    func testUnWrap() {
        let sine = ArithmeticExpression.makeSine(30)
        var expression = ArithmeticExpression.addition(sine, EditableNumber(0.5))
        XCTAssertTrue(expression.unWrap())
        
        if case .sine(let value) = expression,
           case .number(let number) = value {
            XCTAssertTrue(number.value == 30)
        } else {
            XCTAssertTrue(false)
        }
        
        expression = ArithmeticExpression.makeNumber(3)
        XCTAssertFalse(expression.unWrap())
    }
}
