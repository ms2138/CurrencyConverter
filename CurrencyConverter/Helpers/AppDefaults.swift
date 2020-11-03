//
//  AppDefaults.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-05.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class AppDefaults {
    var defaults: UserDefaultsProtocol = Config.userDefaults
    
    var exchangeRateCache: [String: Double]? {
        get {
            return defaults.value(forKey: Constants.exchangeRateCache) as? [String: Double]
        }
        set {
            defaults.set(newValue, forKey: Constants.exchangeRateCache)
        }
    }
    var exchangeRateCacheTimestamp: Date? {
        get {
            return defaults.value(forKey: Constants.cacheTimestamp) as? Date
        }
        set {
            defaults.set(newValue, forKey: Constants.cacheTimestamp)
        }
    }
    var selectedCurrencyConversion: CurrencyConversion {
        get {
            if let savedCurrencyConversion = defaults.object(forKey: Constants.selectedCurrencyConversion) as? Data {
                let decoder = JSONDecoder()
                if let decodedCurrencyConversion = try? decoder.decode(CurrencyConversion.self, from: savedCurrencyConversion) {
                    return decodedCurrencyConversion
                }
            }
            // Provide a default currency conversion
            let fromCurrency = Currency.init(name: "United States Dollar", symbol: "$", id: "USD")
            let toCurrency = Currency.init(name: "Canadian Dollar", symbol: "$", id: "CAD")
            return CurrencyConversion.init(from: fromCurrency, to: toCurrency)
        }
        set {
            let encoder = JSONEncoder()
            if let encodedCurrencyConversion = try? encoder.encode(newValue) {
                defaults.set(encodedCurrencyConversion, forKey: Constants.selectedCurrencyConversion)
            }
        }

    }
}

