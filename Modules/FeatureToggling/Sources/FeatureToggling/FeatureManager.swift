//
//  FeatureManager.swift
//
//
//  Created by Sergey Slobodenyuk on 2023-10-16.
//

import Foundation
import CoreCalculation

public enum Feature: String, Codable, CodingKey {
    case bitcoinConversion
    case addition
    case subtraction
    case multiplication
    case division
    case sinFunction
    case cosFunction
    case isDarkMode
    
    private enum CodingKeys : CodingKey {
        case bitcoinConversion
        case addition
        case subtraction
        case multiplication
        case division
        case sinFunction
        case cosFunction
        case isDarkMode
    }
}

public class FeatureManager {
    public static let shared = FeatureManager()
    
    private var featureFlags: [Feature: Bool] = [:]
    
    private init() {
        loadFeatureFlags()
    }
    
    private func loadFeatureFlags() {
        if let url = Bundle.main.url(forResource: "FeatureFlags", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                featureFlags = try decoder.decode(CodableDictionary.self, from: data).decoded
            } catch {
                print("Error loading feature flags from JSON: \(error)")
            }
        }
    }
    
    public func isFeatureEnabled(_ feature: Feature) -> Bool {
        return featureFlags[feature] ?? false
    }
}

extension Command {
    public var isEnabled: Bool {
        let commandFeature: Feature? = switch self {
            case .bitcoin: .bitcoinConversion
            case .plus: .addition
            case .minus: .subtraction
            case .multiply: .multiplication
            case .divide: .division
            case .sin: .sinFunction
            case .cos: .cosFunction
            default: nil
        }
        
        if let feature = commandFeature {
            return FeatureManager.shared.isFeatureEnabled(feature)
        }
        
        return true
    }
}
