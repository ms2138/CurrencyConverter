//
//  CurrencyDataManager.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-04.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyDataManager {
    var currencies: [Currency]
    var pathToSavedCurrencies: URL {
        return FileManager.default.pathToFile(filename: "currencies.json")
    }

    init() {
        self.currencies = [Currency]()
    }
}
