//
//  OperationButtonStyle.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-12.
//

fileprivate let BUTTON_HEIGHT = 50
fileprivate let SPACE = 8

import SwiftUI

struct OperationButtonStyle: ButtonStyle {
    let backgroundColor: Color = Color.blue
    let foregroundColor: Color = Color(.systemGray6)
    var mergedRowCount = 1

    func makeBody(configuration: Configuration) -> some View {
        let spacesHeight = mergedRowCount > 1 ? (mergedRowCount - 1) * SPACE : 0
        return configuration.label
            .font(.system(size: 30, weight: .regular))
            .frame(maxWidth: .infinity)
            .frame(height: CGFloat(mergedRowCount * BUTTON_HEIGHT + spacesHeight))
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
