//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI
import BitcoinService
import CoreCalculation
import FeatureToggling

@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var commands: [CommandResult]
    @Published var showErrorLabel = false

    private let logicCore = LogicCore()
    private let bitcoinService = BitcoinService()
    
    private var errorLabelTimer: Timer?
    
    private var expressions = [ArithmeticExpression]()
    
    var equations: [Command]
        
    init() {
        commands = [.init(expression: "0", result: "")]
        equations = [.divide, .multiply, .minus, .plus]
            .filter { $0.isEnabled }
    }
    
    func handleButtonTap(_ button: Command) {
        expressions = logicCore.updateExpressions(expressions, command: button)
        generateCommandResults(expressions)
        
        if button == .bitcoin {
            handleBitcoin()
        }
    }
    
    func generateCommandResults(_ expressions: [ArithmeticExpression]) {
        
        var commandResults: [CommandResult] = []
        
        // Iterate through the expressions and convert them to command results
        for i in 0..<expressions.count {
            let expression = expressions[i]
            let lines = logicCore.traverse(expression)
            let isOutdated = i < expressions.count - 1
            
            for (expressionString, result) in lines {
                let commandResult = CommandResult(
                    expression: expressionString,
                    result: result != nil ? "\(result!)" : "",
                    isOutdated: isOutdated
                )
                
                commandResults.append(commandResult)
            }
        }
        
        // Update the @Published property to reflect the converted results
        commands = commandResults
    }

    func handleBitcoin() {
        hideErrorLabel()
        
        Task {
            do {
                let newBitcoinValue = try await bitcoinService.fetchBitcoin()
                Task {
                    updateBitcoinValue(newBitcoinValue)
                    generateCommandResults(expressions)
                }
            } catch {
                handleBitcoinError()
            }
        }
    }
    
    func handleBitcoinError() {
        withAnimation {
            showErrorLabel = true
        }

        // Set up a timer to automatically hide the error label after 10 seconds
        errorLabelTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            guard let strongSelf = self else { return }
            Task {
                // Workaround for Swift 6 issue
                @MainActor in strongSelf.hideErrorLabel()
            }
        }
    }

    func hideErrorLabel() {
        errorLabelTimer?.invalidate()
        withAnimation {
            self.showErrorLabel = false
        }
    }
    
    func updateBitcoinValue(_ newValue: Double) {
        logicCore.bitcoinValue = newValue
    }
}
