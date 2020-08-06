//
//  AppDefaults.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-05.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class AppDefaults {
    var defaults: UserDefaults {
        return UserDefaults.standard
    }
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
}

