//
//  CurrencyDataManager.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-04.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyStorageManager {
    var filename: String
    var pathToSavedCurrencies: URL {
        return FileManager.default.pathToFile(filename: filename)
    }
    var savedFileExists: Bool {
        return FileManager.default.fileExists(atPath: pathToSavedCurrencies.path)
    }

    init(filename: String) {
        self.filename = filename
    }
}

extension CurrencyStorageManager {
    func read() -> [Currency]? {
        do {
            return try JSONDataManager<Currency>().read(from: pathToSavedCurrencies)
        } catch {
            debugLog("Failed to read currency data")
            return nil
        }
    }

    func save(currencies: [Currency]) {
        do {
            try JSONDataManager<[Currency]>().write(data: currencies, to: pathToSavedCurrencies)
        } catch {
            debugLog("Failed to write currency data")
        }
    }
}
