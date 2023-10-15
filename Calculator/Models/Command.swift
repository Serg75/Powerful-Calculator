//
//  Command.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-11.
//

import Foundation

// All calculator commands
enum Command: String {
    case d0 = "0"
    case d1 = "1"
    case d2 = "2"
    case d3 = "3"
    case d4 = "4"
    case d5 = "5"
    case d6 = "6"
    case d7 = "7"
    case d8 = "8"
    case d9 = "9"
    case sep = "."
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divide = "/"
    case sin = "sin"
    case cos = "cos"
    case bitcoin = "₿"
    case del = "<-"
    case reset = "C"
}

// Extend Command enum to categorize buttons
extension Command {
    var isDigit: Bool {
        return [.d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .d8, .d9, .sep ].contains(self)
    }
    
    var isOperation: Bool {
        return [.plus, .minus, .multiply, .divide].contains(self)
    }
    
    var isFunction: Bool {
        return [.sin, .cos, .bitcoin].contains(self)
    }
    
    var isDeleteOrReset: Bool {
        return [Command.del, Command.reset].contains(self)
    }
}
