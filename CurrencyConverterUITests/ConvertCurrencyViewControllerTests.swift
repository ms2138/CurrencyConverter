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
}
