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

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as? ConvertCurrencyViewController
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = sut
    }

    override func tearDown() {
        sut = nil
    }

    func testViewNotNil() {
        XCTAssertNotNil(sut.view)
    }

    
}
