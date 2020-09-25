//
//  CurrencyDataDecoderTests.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-09-23.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencyDataDecoderTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testCurrenciesDecodingSuccess() {
        let data = loadData(forResource: "exchangeRate", extension: "json")
        let currencyDataDecoder = CurrencyDataDecoder(data: data)

        let currencies = try! currencyDataDecoder.decode(type: CurrencyList.self).currencies

        XCTAssertNotNil(currencies)
        XCTAssertNotEqual(currencies.count, 0)
    }

    func testExchangeRateDecodingSuccess() {
        let data = loadData(forResource: "exchangeRate", extension: "json")
        let currencyDataDecoder = CurrencyDataDecoder(data: data)

        let exchange = try! currencyDataDecoder.decode(type: ExchangeRate.self)

        XCTAssertNotNil(exchange)
        XCTAssertEqual(exchange.rate, 1.339965)
    }

    func loadData(forResource resource: String, extension ext: String) -> Data {
        let bundle = Bundle(for: type(of: self))

        let path = bundle.url(forResource: resource, withExtension: ext)!
        return try! Data(contentsOf: path)
    }
}
