//
//  View+ConditionalModifier.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-16.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
