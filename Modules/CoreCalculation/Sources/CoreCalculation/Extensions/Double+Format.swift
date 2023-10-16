//
//  Double+Format.swift
//  Calculator
//
//  Created by Sergey Slobodenyuk on 2023-10-14.
//

import Foundation

extension Double {
    
    /// String value without decimal in case it is equal to 0.
    /// E.g. 12.0 -> "12", 12.55 -> "12.55"
    var cleanString: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    
    /// Rounded to certain number of decimals.
    var roundedWithDecimals: Double {
        let factor = 1_000_000.0    // 10^6 for 6 decimal places
        return (self * factor).rounded() / factor
    }
}
