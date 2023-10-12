//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    @Published var commands: [CommandResult] = []
    
    func handleButtonTap(_ button: Command) {
        // the button handling logic
    }

    func isButtonEnabled(_ button: Command) -> Bool {
        // the feature toggling logic
        return true
    }
}
