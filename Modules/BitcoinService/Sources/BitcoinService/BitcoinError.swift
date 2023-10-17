//
//  BitcoinError.swift
//
//
//  Created by Sergey Slobodenyuk on 2023-10-17.
//

import Foundation

enum BitcoinError: Error {
    case dataParsingError
    case networkError(Error)
}
