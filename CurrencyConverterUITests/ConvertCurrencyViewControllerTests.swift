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
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments += ["-UITesting", "true"]

        helper = ConvertCurrencyViewControllerHelper()

        continueAfterFailure = false
    }

    override func tearDown() {
        helper = nil
    }

    func testIntialOutputDisplayLabelText() {
        app.launch()

        let displayLabel = helper.outputDisplayLabel
        XCTAssertTrue(displayLabel.exists)
        XCTAssertEqual(displayLabel.label, "0")
    }

    func testNumberPad() {
        app.launch()

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
        app.launch()

        let displayLabel = helper.outputDisplayLabel
        XCTAssertEqual(displayLabel.label, "0")

        app.buttons.containing(.staticText, identifier:"5").element.tap()

        XCTAssertEqual(displayLabel.label, "5")

        app.buttons.containing(.staticText, identifier:"C").element.tap()

        XCTAssertEqual(displayLabel.label, "0")
    }

    func testSwipeGestureDeletingASingleDigit() {
        app.launch()

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
        app.launch()

        app.buttons["5"].tap()
        helper.outputDisplayLabel.press(forDuration: 1.3)
        let copyMenu = app.staticTexts["Copy"]
        XCTAssertTrue(copyMenu.exists)
        copyMenu.tap()

        XCTAssertFalse(copyMenu.waitForExistence(timeout: 1.0))
    }

    func testExchangeRateDisplayLabelAfterConversion() {
        app.launchEnvironment["ConversionSuccess"] = "{\"USD_CAD\":1.339965}"
        app.launch()

        app.buttons["5"].tap()
        app.buttons["1"].tap()

        let exchangeRate = helper.exchangeRateDisplayLabel
        XCTAssertEqual(exchangeRate.label, "0")

        helper.convertButton.tap()

        XCTAssertTrue(exchangeRate.waitForExistence(timeout: 2.0))
        let outputdisplaylabelButton = helper.outputDisplayLabel
        outputdisplaylabelButton.doubleTap()

        XCTAssertNotEqual(exchangeRate.label, "0")
    }

    func testSwitchConversionButton() {
        app.launch()

        let convertToButton = helper.convertToButton
        let convertFromButton = helper.convertFromButton

        XCTAssertEqual(convertFromButton.label, "United States Dollar")
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")

        let upDownArrowButton = app.buttons["Up Down Arrow"]
        upDownArrowButton.tap()

        XCTAssertEqual(convertFromButton.label, "Canadian Dollar")
        XCTAssertEqual(convertToButton.label, "United States Dollar")
    }

    func testConvertToAndFromButtons() {
        app.launch()

        let convertToButton = helper.convertToButton
        let convertFromButton = helper.convertFromButton

        XCTAssertTrue(convertToButton.exists)
        XCTAssertTrue(convertFromButton.exists)

        convertToButton.tap()

        let selectCurrenciesNavBar = app.navigationBars["Select Currencies"]
        let cancelButton = app.navigationBars["Select Currencies"].buttons["Cancel"]

        XCTAssertTrue(selectCurrenciesNavBar.exists)
        XCTAssertTrue(cancelButton.exists)

        cancelButton.tap()

        convertFromButton.tap()

        XCTAssertTrue(selectCurrenciesNavBar.exists)
        XCTAssertTrue(cancelButton.exists)

        cancelButton.tap()
    }

    func testConvertButtonTapSuccess() {
        app.launchEnvironment["ConversionSuccess"] = "{\"USD_CAD\":1.339965}"
        app.launch()

        let displayLabel = helper.outputDisplayLabel

        XCTAssertEqual(displayLabel.label, "0")

        app.buttons["5"].tap()

        let convertButton = helper.convertButton
        convertButton.tap()

        XCTAssertTrue(convertButton.exists)
        XCTAssertNotEqual(displayLabel.label, "5")
        XCTAssertNotEqual(displayLabel.label, "0")
    }

    func testConvertButtonTapFailure() {
        app.launchEnvironment["ConversionFailure"] = "Error"
        app.launch()

        app.buttons["5"].tap()

        let convertButton = helper.convertButton
        convertButton.tap()

        let alert = app.alerts["Error"]

        XCTAssertTrue(alert.waitForExistence(timeout: 2.0))
        XCTAssertTrue(alert.staticTexts["Error"].exists)
        XCTAssertTrue(alert.buttons["OK"].exists)
    }
}
