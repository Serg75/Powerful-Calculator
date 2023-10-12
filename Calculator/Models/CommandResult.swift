//
//  CommandResult.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import Foundation

struct CommandResult: Identifiable, Equatable {
    var id = UUID()
    var expression: String
    var result: String
    var isOutdated: Bool = false
}
