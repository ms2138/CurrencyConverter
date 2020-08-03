//
//  CurrencyList.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct CurrencyList: Codable {
    var currencies: [Currency]

    // Add coding key to handle the root results key in the json response
    struct CurrencyKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let results = CurrencyKey(stringValue: "results")!
        static let name = CurrencyKey(stringValue: "currencyName")!
        static let symbol = CurrencyKey(stringValue: "currencySymbol")!
        static let id = CurrencyKey(stringValue: "id")!
    }

    // Add custom decoding and encoding to parse response with root results key
    public init(from decoder: Decoder) throws {
        var currencies = [Currency]()
        let container = try decoder.container(keyedBy: CurrencyKey.self)
        let resultsContainer = try container.nestedContainer(keyedBy: CurrencyKey.self, forKey: .results)
        for key in resultsContainer.allKeys {
            let nestedContainer = try resultsContainer.nestedContainer(keyedBy: CurrencyKey.self, forKey: key)
            let name = try nestedContainer.decode(String.self, forKey: .name)
            let symbol = try nestedContainer.decodeIfPresent(String.self, forKey: .symbol)
            let id = try nestedContainer.decode(String.self, forKey: .id)

            let currency = Currency(name: name, symbol: symbol, id: id)
            currencies.append(currency)
        }
        self.currencies = currencies
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CurrencyKey.self)

        for currency in currencies {
            let nameKey = CurrencyKey(stringValue: currency.name)!
            var currencyContainer = container.nestedContainer(keyedBy: CurrencyKey.self, forKey: nameKey)

            try currencyContainer.encode(currency.name, forKey: .name)
            try currencyContainer.encode(currency.symbol, forKey: .symbol)
            try currencyContainer.encode(currency.id, forKey: .id)
        }
    }
}
