//
//  CurrencyList.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct CurrencyList {
    var currencies: [Currency]

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
}
