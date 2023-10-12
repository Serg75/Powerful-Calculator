//
//  OperationButtonStyle.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI

struct OperationButtonStyle: ButtonStyle {
    let backgroundColor: Color = Color.blue
    let foregroundColor: Color = Color.white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
