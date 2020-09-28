//
//  CurrencySelectorViewControllerTests.swift
//  CurrencyConverterUITests
//
//  Created by mani on 2020-09-27.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

class CurrencySelectorViewControllerTests: XCTestCase {
    var helper: CurrencySelectorViewControllerHelper!

    override func setUp() {
        helper = CurrencySelectorViewControllerHelper()

        continueAfterFailure = false

        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testFromCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        XCTAssertTrue(helper.fromTableView.exists)
        XCTAssertTrue(helper.fromTableViewHeaderTitle.exists)
        XCTAssertEqual(helper.fromTableViewHeaderTitle.label, "From")
    }

    func testToCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        XCTAssertTrue(helper.toTableView.exists)
        XCTAssertTrue(helper.toTableViewHeaderTitle.exists)
        XCTAssertEqual(helper.toTableViewHeaderTitle.label, "To")
    }

    func testCurrenciesInFromCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        let tableView = helper.fromTableView
        XCTAssertNotEqual(tableView.cells.count, 0)
    }

    func testCurrenciesInToCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        let tableView = helper.toTableView
        XCTAssertNotEqual(tableView.cells.count, 0)
    }

    func testSelectedCurrencyInFromCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        let tableView = helper.fromTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch

        XCTAssertTrue(selectedCell.waitForExistence(timeout: 3.0))
        XCTAssertTrue(selectedCell.isSelected)
    }
}
