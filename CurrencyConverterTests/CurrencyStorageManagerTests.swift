//
//  CurrencyStorageManagerTests.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-09-23.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencyStorageManagerTests: XCTestCase {
    var currencyStorageManager: CurrencyStorageManager!

    override func setUp() {
        currencyStorageManager = CurrencyStorageManager(filename: "currencies.json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: currencyStorageManager.pathToSavedCurrencies)
    }

    func testSaveCurrenciesSuccess() {
        let currencies = [Currency(name: "United States Dollar", symbol: "$", id: "USD")]

        currencyStorageManager.save(currencies: currencies)

        XCTAssertTrue(currencyStorageManager.savedFileExists)
        XCTAssertEqual(currencyStorageManager.pathToSavedCurrencies.lastPathComponent, "currencies.json")
    }

    func testReadCurrenciesSuccess() {
        if let currencies = currencyStorageManager.read() {
            XCTAssertNotEqual(currencies.count, 0)
        }
    }

}
