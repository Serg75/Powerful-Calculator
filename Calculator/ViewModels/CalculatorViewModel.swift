//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import Foundation
import CoreCalculation
import FeatureToggling

class CalculatorViewModel: ObservableObject {
    @Published var commands: [CommandResult] = []
    
    private let logicCore = LogicCore()
    private var expressions = [ArithmeticExpression]()
    
    var equations: [Command]
        
    init() {
        equations = [.divide, .multiply, .minus, .plus]
            .filter { $0.isEnabled }
    }
    
    func handleButtonTap(_ button: Command) {
        expressions = logicCore.updateExpressions(expressions, command: button)
        generateCommandResults(expressions)
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
}
