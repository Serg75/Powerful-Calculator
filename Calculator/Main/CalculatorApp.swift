//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-11.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView(calculatorViewModel: CalculatorViewModel())
        }
    }
}
