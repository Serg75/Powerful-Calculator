//
//  CalculatorView.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI

struct CalculatorView: View {
    @ObservedObject var calculatorViewModel: CalculatorViewModel

    var body: some View {
        VStack {
            Text("Calculator")
                .font(.largeTitle)
            
            let lastCommand = calculatorViewModel.commands.last
            
            // Display the list of previous commands and results
            List(calculatorViewModel.commands) { command in
                HStack {
                    Text(command.expression)
                    Spacer()
                    Text(command.result)
                }
                .modifier(RowBackgroundColorModifier(isDimmed: command.isOutdated))
                .modifier(RowForegroundColorModifier(isDimmed: command.isOutdated))
                .foregroundColor(command.isOutdated ? .primary : .secondary)
                .font(command == lastCommand ? .system(size: 16, weight: .bold) : .system(size: 16, weight: .regular))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listStyle(PlainListStyle())
            .border(Color.gray)
            .padding(.horizontal)

            // Display the calculator buttons
            CalculatorButtonMatrix(calculatorViewModel: calculatorViewModel)
                .padding()
        }
    }
}

struct RowBackgroundColorModifier: ViewModifier {
    let isDimmed: Bool

    func body(content: Content) -> some View {
        content
            .listRowBackground(!isDimmed ? Color.white : Color(.systemGray5))
    }
}

struct RowForegroundColorModifier: ViewModifier {
    let isDimmed: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(!isDimmed ? .primary : .secondary)
    }
}


#Preview {
    let defaultViewModel = CalculatorViewModel()
    defaultViewModel.commands = [
        CommandResult(expression: "2", result: "", isOutdated: true),
        CommandResult(expression: "+", result: "", isOutdated: true),
        CommandResult(expression: "3", result: "5", isOutdated: true),
        CommandResult(expression: "*", result: "", isOutdated: true),
        CommandResult(expression: "4", result: "20", isOutdated: true),
        CommandResult(expression: "55", result: ""),
        CommandResult(expression: "-", result: ""),
        CommandResult(expression: "25", result: "30"),
        CommandResult(expression: "sin(30)", result: "0.5")
    ]
    return CalculatorView(calculatorViewModel: defaultViewModel)
}
