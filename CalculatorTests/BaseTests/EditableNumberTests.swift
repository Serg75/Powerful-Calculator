//
//  EditableNumberTests.swift
//  CalculatorTests
//
//  Created by Sergey Slobodenyuk on 2023-10-15.
//

import XCTest

@testable import Calculator

import XCTest

final class EditableNumberTests: XCTestCase {

    func testInitialization() {
        let editableNumber = EditableNumber()
        XCTAssertEqual(editableNumber.value, 0.0)
        XCTAssertEqual(editableNumber.stringValue, "0")
    }

    func testAddDigit() {
        var editableNumber = EditableNumber()
        editableNumber.add("1")
        XCTAssertEqual(editableNumber.value, 1.0)
        XCTAssertEqual(editableNumber.stringValue, "1")
    }

    func testAddMultipleDigits() {
        var editableNumber = EditableNumber()
        editableNumber.add("1")
        editableNumber.add("2")
        editableNumber.add("3")
        XCTAssertEqual(editableNumber.value, 123.0)
        XCTAssertEqual(editableNumber.stringValue, "123")
    }

    func testAddDecimalPoint() {
        var editableNumber = EditableNumber()
        editableNumber.add("1")
        editableNumber.add(".")
        editableNumber.add("5")
        XCTAssertEqual(editableNumber.value, 1.5)
        XCTAssertEqual(editableNumber.stringValue, "1.5")
    }

    func testAddMultipleDecimalPoints() {
        var editableNumber = EditableNumber()
        editableNumber.add(".")
        editableNumber.add("5")
        editableNumber.add(".")
        editableNumber.add("7")
        XCTAssertEqual(editableNumber.value, 0.57)
        XCTAssertEqual(editableNumber.stringValue, "0.57")
    }

    func testRemoveLastDigit() {
        var editableNumber = EditableNumber()
        editableNumber.add("1")
        editableNumber.add("2")
        editableNumber.removeLast()
        XCTAssertEqual(editableNumber.value, 1.0)
        XCTAssertEqual(editableNumber.stringValue, "1")
    }

    func testRemoveLastDecimalPoint() {
        var editableNumber = EditableNumber()
        editableNumber.add("1")
        editableNumber.add(".")
        editableNumber.removeLast()
        XCTAssertEqual(editableNumber.value, 1.0)
        XCTAssertEqual(editableNumber.stringValue, "1")
    }
    
    func testEquality() {
        let number1 = EditableNumber()
        let number2 = EditableNumber()
        XCTAssertTrue(number1 == number2)
        XCTAssertTrue(number2 == number1)
    }

    func testInequality() {
        var number1 = EditableNumber()
        var number2 = EditableNumber()
        XCTAssertTrue(number1 == number2)
        
        // Adding a different digit makes them unequal
        number1.add("1")
        XCTAssertFalse(number1 == number2)
        XCTAssertFalse(number2 == number1)
        
        // Adding the same digit makes them equal again
        number2.add("1")
        XCTAssertTrue(number1 == number2)
        XCTAssertTrue(number2 == number1)
        
        // Adding a decimal point makes them unequal
        number1.add(".")
        XCTAssertFalse(number1 == number2)
        XCTAssertFalse(number2 == number1)
        
        // Adding a different digit after the decimal point makes them unequal
        number1.add("5")
        XCTAssertFalse(number1 == number2)
        XCTAssertFalse(number2 == number1)
    }

}
