//
//  CurrencyDataManager.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-04.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyStorageManager {
    var pathToSavedCurrencies: URL {
        return FileManager.default.pathToFile(filename: "currencies.json")
    }
    var savedFileExists: Bool {
        return FileManager.default.fileExists(atPath: pathToSavedCurrencies.path)
    }

    init() {
        self.currencies = [Currency]()
    }
}

extension CurrencyStorageManager {
    func readCurrencies() {
        do {
            currencies = try JSONDataManager<Currency>().read(from: pathToSavedCurrencies)
        } catch {
            debugLog("Failed to read currency data")
        }
    }

    func saveCurrencies() {
        do {
            try JSONDataManager<[Currency]>().write(data: currencies, to: pathToSavedCurrencies)
        } catch {
            debugLog("Failed to write currency data")
        }
    }

    func downloadCurrencies(completion: (() -> Void)? = nil) {
        let currencyDownloader = CurrencyDataDownloader.init()
        currencyDownloader.getCurrencyData { [weak self] (currencies, response, error) in
            guard let weakSelf = self else { return }
            if let currencies = currencies {
                weakSelf.currencies = currencies
                completion?()
            }
        }
    }
}
