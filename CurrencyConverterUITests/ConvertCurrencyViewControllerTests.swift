//
//  ConvertCurrencyViewControllerTests.swift
//  CurrencyConverterUITests
//
//  Created by mani on 2020-09-24.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

class ConvertCurrencyViewControllerTests: XCTestCase {
    var helper: ConvertCurrencyViewControllerHelper!

    override func setUp() {
        helper = ConvertCurrencyViewControllerHelper()

        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testIntialOutputDisplayLabelText() {
        let displayLabel = helper.outputDisplayLabel
        XCTAssertTrue(displayLabel.exists)
        XCTAssertEqual(displayLabel.label, "0")
    }

    func testNumberPad() {
        let app = XCUIApplication()

        let displayLabel = helper.outputDisplayLabel

        var display = ""
        for i in (0...9).reversed() {
            let numberButton = app.buttons.containing(.staticText, identifier:"\(i)").element
            numberButton.tap()
            display += "\(i)"
            XCTAssertTrue(numberButton.exists)
            XCTAssertEqual(displayLabel.label, "\(display)")
        }

        let decimalButton = app.buttons.containing(.staticText, identifier:".").element
        decimalButton.tap()
        display += "."
        XCTAssertTrue(decimalButton.exists)
        XCTAssertEqual(displayLabel.label, "\(display)")
    }

    func testClearOutputDisplay() {
        let app = XCUIApplication()

        let displayLabel = helper.outputDisplayLabel
        XCTAssertEqual(displayLabel.label, "0")

        app.buttons.containing(.staticText, identifier:"5").element.tap()

        XCTAssertEqual(displayLabel.label, "5")

        app.buttons.containing(.staticText, identifier:"C").element.tap()

        XCTAssertEqual(displayLabel.label, "0")
    }

    func testSwipeGestureDeletingASingleDigit() {
        let app = XCUIApplication()

        let displayLabel = helper.outputDisplayLabel
        XCTAssertEqual(displayLabel.label, "0")

        app.buttons.containing(.staticText, identifier:"5").element.tap()
        XCTAssertEqual(displayLabel.label, "5")

        displayLabel.swipeRight()
        XCTAssertEqual(displayLabel.label, "0")

        app.buttons.containing(.staticText, identifier:"5").element.tap()
        XCTAssertEqual(displayLabel.label, "5")

        displayLabel.swipeLeft()
        XCTAssertEqual(displayLabel.label, "0")
    }

    func testCopyMenuFunctionality() {
        let app = XCUIApplication()

        app.buttons["5"].tap()
        helper.outputDisplayLabel.press(forDuration: 1.3)
        let copyMenu = app.staticTexts["Copy"]
        XCTAssertTrue(copyMenu.exists)
        copyMenu.tap()

        XCTAssertFalse(copyMenu.waitForExistence(timeout: 1.0))
    }

    func testExchangeRateDisplayLabelAfterConversion() {
        let app = XCUIApplication()

        app.buttons["5"].tap()
        app.buttons["1"].tap()

        let exchangeRate = helper.exchangeRateDisplayLabel
        XCTAssertEqual(exchangeRate.label, "0")

        app.buttons["Convert"].tap()

        XCTAssertTrue(exchangeRate.waitForExistence(timeout: 2.0))
        let outputdisplaylabelButton = helper.outputDisplayLabel
        outputdisplaylabelButton.doubleTap()

        XCTAssertNotEqual(exchangeRate.label, "0")
    }

}
