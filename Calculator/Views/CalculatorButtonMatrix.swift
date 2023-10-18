//
//  CalculatorButtonMatrix.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI
import CoreCalculation

struct CalculatorButtonMatrix: View {
    @ObservedObject var calculatorViewModel: CalculatorViewModel
    
    var body: some View {

        if #available(iOS 16.0, *) {

            let equations = calculatorViewModel.equations

            Grid {
                GridRow {
                    if (Command.sin.isEnabled) {
                        Button(Command.sin.rawValue) {
                            calculatorViewModel.handleButtonTap(Command.sin)
                        }
                        .buttonStyle(OperationButtonStyle())
                        .if(!Command.cos.isEnabled) { $0.gridCellColumns(2) }
                    }
                    
                    if (Command.cos.isEnabled) {
                        Button(Command.cos.rawValue) {
                            calculatorViewModel.handleButtonTap(Command.cos)
                        }
                        .buttonStyle(OperationButtonStyle())
                        .if(!Command.sin.isEnabled) { $0.gridCellColumns(2) }
                    }
                    
                    if (!Command.sin.isEnabled && !Command.cos.isEnabled) {
                        Color.clear
                            .gridCellColumns(2)
                            .gridCellUnsizedAxes([.horizontal, .vertical])
                    }
                    
                    Button(Command.del.rawValue) {
                        calculatorViewModel.handleButtonTap(Command.del)
                    }
                    .buttonStyle(OperationButtonStyle())
                    
                    Button(Command.reset.rawValue) {
                        calculatorViewModel.handleButtonTap(Command.reset)
                    }
                    .buttonStyle(OperationButtonStyle())
                    
                }
                GridRow {
                    Grid {
                        digits789(calculatorViewModel)
                        
                        digits456(calculatorViewModel)
                        
                        digits123(calculatorViewModel)
                        
                        digitsBottom(calculatorViewModel)
                    }
                    .gridCellColumns(3)
                    Grid {
                        let firstMergedRow = (equations.count - 2) * 2
                        ForEach(0..<equations.count, id: \.self) { index in
                            let mergedRowCount = index >= firstMergedRow ? (equations.count > 1 ? 2 : 4) : 1
                            let button = equations[index]
                            Button(button.rawValue) {
                                calculatorViewModel.handleButtonTap(button)
                            }
                            .buttonStyle(OperationButtonStyle(mergedRowCount: mergedRowCount))
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions

            let buttons: [Command] = [
                .sin, .cos, .del, .reset,
                .d7, .d8, .d9, .plus,
                .d4, .d5, .d6, .minus,
                .d1, .d2, .d3, .multiply,
                .d0, .sep, .bitcoin, .divide
            ]
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 10) {
                ForEach(buttons, id: \.rawValue) { button in
                    if button.isEnabled {
                        Button(button.rawValue) {
                            calculatorViewModel.handleButtonTap(button)
                        }
                        .buttonStyle(OperationButtonStyle())
                    } else {
                        Color.clear
                    }
                }
            }
        }
    }
}


@available(iOS 16.0, *)
@ViewBuilder
func digits123(_ calculatorViewModel: CalculatorViewModel) -> some View {
    let buttons: [Command] = [.d1, .d2, .d3]
    GridRow {
        ForEach(buttons, id: \.rawValue) { button in
            Button(button.rawValue) {
                Task {
                    await calculatorViewModel.handleButtonTap(button)
                }
            }
            .buttonStyle(OperationButtonStyle())
        }
    }
}

@available(iOS 16.0, *)
@ViewBuilder
func digits456(_ calculatorViewModel: CalculatorViewModel) -> some View {
    let buttons: [Command] = [.d4, .d5, .d6]
    GridRow {
        ForEach(buttons, id: \.rawValue) { button in
            Button(button.rawValue) {
                Task {
                    await calculatorViewModel.handleButtonTap(button)
                }
            }
            .buttonStyle(OperationButtonStyle())
        }
    }
}

@available(iOS 16.0, *)
@ViewBuilder
func digits789(_ calculatorViewModel: CalculatorViewModel) -> some View {
    let buttons: [Command] = [.d7, .d8, .d9]
    GridRow {
        ForEach(buttons, id: \.rawValue) { button in
            Button(button.rawValue) {
                Task {
                    await calculatorViewModel.handleButtonTap(button)
                }
            }
            .buttonStyle(OperationButtonStyle())
        }
    }
}

@available(iOS 16.0, *)
@ViewBuilder
func digitsBottom(_ calculatorViewModel: CalculatorViewModel) -> some View {
    GridRow {
        let bitcoinEnabled = Command.bitcoin.isEnabled
        
        Button(Command.d0.rawValue) {
            Task {
                await calculatorViewModel.handleButtonTap(Command.d0)
            }
        }
        .buttonStyle(OperationButtonStyle())
        .if(!bitcoinEnabled) { $0.gridCellColumns(2) }
        
        Button(Command.sep.rawValue) {
            Task {
                await calculatorViewModel.handleButtonTap(Command.sep)
            }
        }
        .buttonStyle(OperationButtonStyle())

        if (bitcoinEnabled) {
            Button(Command.bitcoin.rawValue) {
                Task {
                    await calculatorViewModel.handleButtonTap(Command.bitcoin)
                }
            }
            .buttonStyle(OperationButtonStyle())
        }
    }
}

#Preview {
    CalculatorButtonMatrix(calculatorViewModel: CalculatorViewModel())
}
