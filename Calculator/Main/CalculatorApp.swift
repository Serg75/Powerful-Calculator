//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-11.
//

import SwiftUI

@main
struct CalculatorApp: App {
    @StateObject private var colorThemeManager = ColorSchemeManager()
    
    var body: some Scene {
        WindowGroup {
            CalculatorView(calculatorViewModel: CalculatorViewModel())
                .environmentObject(colorThemeManager)
        }
    }
}
