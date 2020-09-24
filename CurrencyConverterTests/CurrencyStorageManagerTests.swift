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

    }
}
