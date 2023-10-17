//
//  CalculatorView.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject var colorThemeManager: ColorSchemeManager
    @ObservedObject var calculatorViewModel: CalculatorViewModel

    var body: some View {
        VStack {
            Text("Calculator")
                .font(.largeTitle)
            
            DynamicStack(verticalAlignment: .bottom, spacing: 10) {
                let lastCommand = calculatorViewModel.commands.last
                
                // Display the list of previous commands and results
                VStack {
                    ScrollViewReader { scrollView in
                        List {
                            ForEach(calculatorViewModel.commands, id: \.self) { command in
                                VStack (alignment: .leading) {
                                    Text(command.expression)
                                    if (!command.result.isEmpty) {
                                        HStack {
                                            Spacer()
                                            Text("= \(command.result)")
                                                .strikethrough(command.isOutdated)
                                        }
                                    }
                                }
                                .modifier(RowBackgroundColorModifier(isDimmed: command.isOutdated))
                                .modifier(RowForegroundColorModifier(isDimmed: command.isOutdated))
                                .foregroundColor(command.isOutdated ? .primary : .secondary)
                                .font(command == lastCommand ? .system(size: 21, weight: .bold) : .system(size: 20, weight: .regular))
                            }
                        }.onChange(of: calculatorViewModel.commands) { _ in
                            withAnimation {
                                scrollView.scrollTo(calculatorViewModel.commands.last!)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listStyle(PlainListStyle())
                        .border(Color(.systemGray3))
                    }
                    
                    if calculatorViewModel.showErrorLabel {
                        Text("The last bitcoin value is not available")
                            .foregroundColor(.red)
                    }
                }

                Spacer()
                
                // Display the calculator buttons
                CalculatorButtonMatrix(calculatorViewModel: calculatorViewModel)
            }
        }
        .padding()
        .preferredColorScheme(colorThemeManager.colorScheme)
    }
}

struct RowBackgroundColorModifier: ViewModifier {
    let isDimmed: Bool

    func body(content: Content) -> some View {
        content
            .listRowBackground(!isDimmed ? Color(.systemBackground) : Color(.systemGray5))
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
        CommandResult(expression: "30", result: ""),
        CommandResult(expression: "sin(30)", result: "0.5")
    ]
    return CalculatorView(calculatorViewModel: defaultViewModel)
        .environmentObject(ColorSchemeManager())
}
