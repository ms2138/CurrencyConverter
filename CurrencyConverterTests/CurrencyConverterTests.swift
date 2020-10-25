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

    func testGetExchangeRate() {
        let data = TestHelper().loadData(forResource: "exchangeRate", extension: "json")

        let exchangeRate = try! converter.getExchangeRate(from: data)

        XCTAssertEqual(exchangeRate.rate, 1.339965)
    }

    func testPerformConversionSuccess() {
        let promise = expectation(description: "Performing conversion")
        let data = TestHelper().loadData(forResource: "exchangeRate", extension: "json")

        let session = MockURLSession(data: data, response: nil, error: nil)

        let fromCurrency = Currency.init(name: "United States Dollar", symbol: "$", id: "USD")
        let toCurrency = Currency.init(name: "Canadian Dollar", symbol: "$", id: "CAD")
        let oldConversion = CurrencyConversion.init(from: fromCurrency, to: toCurrency)

        let url = CurrencyURL().getExchangeRateURL(from: oldConversion)

        let dataRequest = CurrencyDataRequest(url: url!, session: session)

        let cc = CurrencyConverter(amount: 55.0)
        cc.performConversion(for: dataRequest) { (result) in
            switch result {
                case .success(let (total, exchange)):
                    XCTAssertNotNil(total)
                    XCTAssertNotNil(exchange)
                case .failure( _):
                    XCTFail("Failed to peform conversion")
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 2.0)
    }

    func testPerformConversionError() {
        let promise = expectation(description: "Performing conversion")
        let session = MockURLSession(data: nil, response: nil, error: NSError(domain: "ParsingErrorDomain", code: 0, userInfo: nil))

        let url = URL(string: "www.currencyapi.com")

        let dataRequest = CurrencyDataRequest(url: url!, session: session)

        let cc = CurrencyConverter(amount: 55.0)
        cc.performConversion(for: dataRequest) { (result) in
            switch result {
                case .success( _):
                    XCTFail("Conversion should not be valid")
                case .failure(let error):
                    XCTAssertNotNil(error)
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 2.0)
    }
}




