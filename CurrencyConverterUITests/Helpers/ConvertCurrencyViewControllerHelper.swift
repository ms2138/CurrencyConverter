//
//  ConvertCurrencyViewControllerHelper.swift
//  CurrencyConverterUITests
//
//  Created by mani on 2020-09-24.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

class ConvertCurrencyViewControllerHelper {
    var outputDisplayLabel: XCUIElement {
        return XCUIApplication().buttons["OutputDisplayLabel"]
    }

    var exchangeRateDisplayLabel: XCUIElement {
        return XCUIApplication().buttons["ExchangeRateDisplayLabel"]
    }

    var convertFromButton: XCUIElement {
        return XCUIApplication().buttons["ConvertFromButton"]
    }

    var convertToButton: XCUIElement {
        return XCUIApplication().buttons["ConvertToButton"]
    }
}
