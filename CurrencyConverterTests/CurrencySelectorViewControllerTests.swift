//
//  CurrencySelectorViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-10-04.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencySelectorViewControllerTests: XCTestCase {
    var sut: CurrencySelectorViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "CurrencySelector", bundle: nil)
        let nc = storyboard.instantiateInitialViewController() as! UINavigationController
        sut = nc.viewControllers[0] as? CurrencySelectorViewController
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = sut
    }

    override func tearDown() {
        sut = nil
    }

    func testViewNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func testCurrenciesExits() {
        XCTAssertNotNil(sut.currencies)
    }

    func testForCurrencies() {
        XCTAssertNotEqual(sut.currencies.count, 0)
    }
}
