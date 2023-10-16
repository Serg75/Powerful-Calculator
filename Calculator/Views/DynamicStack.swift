//
//  DynamicStack.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-16.
//

import SwiftUI

struct DynamicStack<Content: View>: View {
    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        GeometryReader { proxy in
            Group {
                if proxy.size.width > proxy.size.height {
                    HStack(
                        alignment: verticalAlignment,
                        spacing: spacing,
                        content: content
                    )
                } else {
                    VStack(
                        alignment: horizontalAlignment,
                        spacing: spacing,
                        content: content
                    )
                }
            }
        }
    }
}

#Preview {
    VStack {
        DynamicStack(verticalAlignment: .bottom, spacing: 10) {
            Text("one")
            Text("two")
        }
        .frame(maxWidth: 200, maxHeight: 300)
        .background(Color.cyan)

        DynamicStack(verticalAlignment: .bottom, spacing: 10) {
            Text("one")
            Text("two")
        }
        .frame(maxWidth: 300, maxHeight: 200)
        .background(Color.yellow)
    }
}
