//
//  CodableDictionary.swift
//
//
//  Created by Sergey Slobodenyuk on 2023-10-18.
//

import Foundation

// A wrapper that helps use enums as keys in a dictionary.
struct CodableDictionary<Key : Hashable, Value : Codable> : Codable where Key : CodingKey {

    let decoded: [Key: Value]

    init(_ decoded: [Key: Value]) {
        self.decoded = decoded
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: Key.self)

        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try container.decode(Value.self, forKey: $0))
            }
        )
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Key.self)

        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
}
