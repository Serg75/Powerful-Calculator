//
//  ColorSchemeManager.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-17.
//

import SwiftUI
import FeatureToggling

class ColorSchemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme = .light
    
    init() {
        colorScheme = FeatureManager.shared
            .isFeatureEnabled(Feature.isDarkMode) ? .dark : .light
    }
}
