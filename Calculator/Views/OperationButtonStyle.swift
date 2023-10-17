//
//  OperationButtonStyle.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

import SwiftUI

struct OperationButtonStyle: ButtonStyle {
    let backgroundColor: Color = Color.blue
    let foregroundColor: Color = Color(.systemGray6)
    var isMergedRows: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 30, weight: .regular))
            .frame(maxWidth: .infinity)
            .frame(height: isMergedRows ? 108 : 50)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
