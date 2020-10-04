//
//  ConvertCurrencyViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-09-28.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class ConvertCurrencyViewControllerTests: XCTestCase {
    var sut: ConvertCurrencyViewController!
    var data: Data!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as? ConvertCurrencyViewController
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = sut

        data = loadData(forResource: "exchangeRate", extension: "json")
    }

    override func tearDown() {
        sut = nil
    }

    func testViewNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func testConvertSuccess() {
        let exchange = try! sut.getExchangeRate(from: data)
        let total = sut.convert(rate: exchange.rate, amount: 55.0)

        let convertedTotal = exchange.rate * 55.0

        XCTAssertEqual(total, convertedTotal)
    }

    func testConvertAndDisplayTotalSuccess() {
        let exchange = try! sut.getExchangeRate(from: data)
        let total = String(format: "%.5f", sut.convert(rate: exchange.rate, amount: 55.0))

        sut.convertAndDisplayTotal(rate: exchange.rate, amount: 55.0)

        XCTAssertEqual(sut.outputDisplayLabel.text!, total)
        XCTAssertEqual(sut.enteredAmount, total)
        XCTAssertEqual(sut.roundedTotal, total)
    }

    func testPerformConversionSuccess() {
        let exchange = try! sut.getExchangeRate(from: data)
        sut.performConversion(for: 55.0, data: data)

        let convertedTotal = exchange.rate * 55.0

        XCTAssertEqual(sut.outputDisplayLabel.text!, String(format: "%.5f", convertedTotal))
    }

    func loadData(forResource resource: String, extension ext: String) -> Data {
        let bundle = Bundle(for: type(of: self))

        let path = bundle.url(forResource: resource, withExtension: ext)!
        return try! Data(contentsOf: path)
    }
}
