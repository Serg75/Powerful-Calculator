//
//  CalculatorButtonMatrix.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI

struct CalculatorButtonMatrix: View {
    @ObservedObject var calculatorViewModel: CalculatorViewModel

    var body: some View {
        let buttons: [Command] = [
            .sin, .cos, .del, .reset,
            .d7, .d8, .d9, .plus,
            .d4, .d5, .d6, .minus,
            .d1, .d2, .d3, .multiply,
            .d0, .sep, .bitcoin, .divide
        ]

        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 10) {
            ForEach(buttons, id: \.rawValue) { button in
                if calculatorViewModel.isButtonEnabled(button) {
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

#Preview {
    CalculatorButtonMatrix(calculatorViewModel: CalculatorViewModel())
}
