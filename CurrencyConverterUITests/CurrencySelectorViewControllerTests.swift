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

    func testSelectedCurrencyInToCurrencyTableView() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.buttons["ConvertFromButton"]/*[[".buttons[\"United States Dollar\"]",".buttons[\"ConvertFromButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let tableView = helper.toTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "Canadian Dollar").firstMatch
        let _ = selectedCell.waitForExistence(timeout: 3.0)

        XCTAssertTrue(selectedCell.waitForExistence(timeout: 3.0))
        XCTAssertTrue(selectedCell.isSelected)
    }

    func testSelectingADifferentCurrencyInFromCurrencyTableView() {
        let app = XCUIApplication()
        app.buttons["ConvertFromButton"].tap()

        let tableView = helper.fromTableView
        let selectedCell = tableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch
        _ = selectedCell.waitForExistence(timeout: 1.0)
        XCTAssertTrue(selectedCell.isSelected)

        let newSelectedCell = tableView.cells.containing(.staticText, identifier: "Ukrainian Hryvnia").firstMatch
        newSelectedCell.tap()
        XCTAssertTrue(newSelectedCell.isSelected)
        XCTAssertFalse(selectedCell.isSelected)
    }

}
