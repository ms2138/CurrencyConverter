//
//  SeededCurrencies.swift
//  CurrencyConverter
//
//  Created by mani on 2020-11-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class SeededCurrencies {
    var currencies: [Currency] {
        let bundle = Bundle(for: type(of: self))

        let path = bundle.url(forResource: "currencies", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        let currencyDataDecoder = CurrencyDataDecoder(data: data)
        var currencies = try! currencyDataDecoder.decode(type: CurrencyList.self).currencies
        currencies.sort { $0.name < $1.name }
        return currencies
    }
}
