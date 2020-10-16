//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by mani on 2020-10-14.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyConverter {
    var amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    func getExchangeRate(from data: Data) throws -> ExchangeRate {
        return try CurrencyDataDecoder(data: data).decode(type: ExchangeRate.self)
    }

    func convert(rate: Double) -> Double {
        return rate * amount
    }
}
