//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-10-17.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    var converter: CurrencyConverter!

    override func setUp() {
        converter = CurrencyConverter(amount: 49.0)
    }

    override func tearDown() {
    }

    func testConvert() {
        let total = converter.convert(rate: 1.3933)

        XCTAssertEqual(total, 49.0 * 1.3933)
    }
}
