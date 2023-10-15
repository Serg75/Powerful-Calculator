//
//  EditableNumber.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-15.
//

import Foundation

struct EditableNumber: CustomStringConvertible, Equatable {
    private(set) var value: Double = 0.0
    private(set) var stringValue: String = "0"
    
    init() {
        updateValue()
    }
    
    init(_ value: Double) {
        self.value = value
        self.stringValue = String(value)
    }
    
    private mutating func updateValue() {
        value = Double(stringValue) ?? 0.0
    }
    
    mutating func add(_ input: Character) {
        if input.isNumber {
            if stringValue == "0" {
                stringValue = String(input)
            } else {
                stringValue.append(input)
            }
        } else if input == "." {
            if !stringValue.contains(".") {
                stringValue.append(input)
            }
        }
        updateValue()
    }
    
    mutating func removeLast() {
        if !stringValue.isEmpty {
            stringValue.removeLast()
            if stringValue.isEmpty || stringValue == "0" {
                stringValue = "0"
            }
        }
        updateValue()
    }
    
    static func +=(lhs: inout EditableNumber, rhs: String) {
        if (!rhs.isEmpty) {
            lhs.add(rhs.first!)
        }
    }
    
    static func ==(lhs: EditableNumber, rhs: String) -> Bool {
        return lhs.stringValue == rhs
    }

    static func !=(lhs: EditableNumber, rhs: String) -> Bool {
        return lhs.stringValue != rhs
    }

    var description: String {
        return stringValue
    }
}
