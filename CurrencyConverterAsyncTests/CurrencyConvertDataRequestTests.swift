//
//  CurrencyConvertDataRequestTests.swift
//  CurrencyConverterAsyncTests
//
//  Created by mani on 2020-10-06.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencyConvertDataRequestTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetCurrencyDataSuccess() {
        let url = CurrencyURL().currencyURL!

        let promise = expectation(description: "Data downloaded")

        let dataRequest = CurrencyDataRequest(url: url)
        dataRequest.getData { result in
            switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }

        wait(for: [promise], timeout: 4)
    }

    func testGetExchangeRateDataSuccess() {
        let fromCurrency = Currency.init(name: "United States Dollar", symbol: "$", id: "USD")
        let toCurrency = Currency.init(name: "Canadian Dollar", symbol: "$", id: "CAD")
        let conversion = CurrencyConversion.init(from: fromCurrency, to: toCurrency)

        let url = CurrencyURL().getExchangeRateURL(from: conversion)!

        let promise = expectation(description: "Data downloaded")

        let dataRequest = CurrencyDataRequest(url: url)
        dataRequest.getData { result in
            switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }

        wait(for: [promise], timeout: 4)
    }

    func testDataFailure() {
        let url = URL(string: "http://free.currencyconverterapi.com")!
        var error: Error?

        let promise = expectation(description: "Expect an error")

        let dataRequest = CurrencyDataRequest(url: url)
        dataRequest.getData { result in
            switch result {
                case .failure(let theError):
                    error = theError
                    promise.fulfill()
                case .success(_):
                    XCTFail("Data was returned")
            }
        }

        wait(for: [promise], timeout: 4)

        XCTAssertNotNil(error)
    }
}
