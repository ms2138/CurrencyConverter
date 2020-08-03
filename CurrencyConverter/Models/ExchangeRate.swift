//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct ExchangeRate: Codable {
    var rate: Double

    struct RateKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RateKey.self)
        var exchange = Double(0.0)
        for key in container.allKeys {
            exchange = try container.decode(Double.self, forKey: key)
        }
        self.rate = exchange
    }
}
