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
        helper = nil
    }

    func testFromCurrencyTableView() {
        helper.convertFromButton.tap()

        XCTAssertTrue(helper.fromTableView.exists)
        XCTAssertTrue(helper.fromTableViewHeaderTitle.exists)
        XCTAssertEqual(helper.fromTableViewHeaderTitle.label, "From")
    }

    func testToCurrencyTableView() {
        helper.convertFromButton.tap()

        XCTAssertTrue(helper.toTableView.exists)
        XCTAssertTrue(helper.toTableViewHeaderTitle.exists)
        XCTAssertEqual(helper.toTableViewHeaderTitle.label, "To")
    }

    func testCurrenciesInFromCurrencyTableView() {
        helper.convertFromButton.tap()

        let tableView = helper.fromTableView
        XCTAssertNotEqual(tableView.cells.count, 0)
    }

    func testCurrenciesInToCurrencyTableView() {
        helper.convertFromButton.tap()

        let tableView = helper.toTableView
        XCTAssertNotEqual(tableView.cells.count, 0)
    }

    func testSelectedCurrencyInFromCurrencyTableView() {
        helper.convertFromButton.tap()

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
        helper.convertFromButton.tap()

        let tableView = helper.fromTableView
        let selectedCell = tableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch
        _ = selectedCell.waitForExistence(timeout: 1.0)
        XCTAssertTrue(selectedCell.isSelected)

        let newSelectedCell = tableView.cells.containing(.staticText, identifier: "Ukrainian Hryvnia").firstMatch
        newSelectedCell.tap()
        XCTAssertTrue(newSelectedCell.isSelected)
        XCTAssertFalse(selectedCell.isSelected)
    }

    func testSelectingADifferentCurrencyInToCurrencyTableView() {
        helper.convertFromButton.tap()

        let tableView = helper.toTableView
        let selectedCell = tableView.cells.containing(.staticText, identifier: "Canadian Dollar").firstMatch
        _ = selectedCell.waitForExistence(timeout: 1.0)
        XCTAssertTrue(selectedCell.isSelected)

        let newSelectedCell = tableView.cells.containing(.staticText, identifier: "CFP Franc").firstMatch
        newSelectedCell.tap()
        XCTAssertTrue(newSelectedCell.isSelected)
        XCTAssertFalse(selectedCell.isSelected)
    }

    func testSelectingTheSameCurrency() {
        helper.convertFromButton.tap()

        let fromTableView = helper.fromTableView
        let fromSelectedCurrencyCell = fromTableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch
        _ = fromSelectedCurrencyCell.waitForExistence(timeout: 1.0)
        XCTAssertTrue(fromSelectedCurrencyCell.isSelected)

        let toTableView = helper.toTableView
        let toSelectedCurrencyCell = toTableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch
        toSelectedCurrencyCell.tap()
        XCTAssertFalse(toSelectedCurrencyCell.isSelected)
    }

    func testDoneButtonDisabledIfNoCurrencySelectedInFromCurrencyTableView() {
        let app = XCUIApplication()
        helper.convertFromButton.tap()

        let tableView = helper.fromTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "United States Dollar").firstMatch
        let _ = selectedCell.waitForExistence(timeout: 1.0)

        XCTAssertTrue(selectedCell.isSelected)

        selectedCell.tap()

        XCTAssertFalse(app.buttons["Done"].firstMatch.isEnabled)
    }

    func testDoneButtonDisabledIfNoCurrencySelectedInToCurrencyTableView() {
        let app = XCUIApplication()
        helper.convertFromButton.tap()

        let tableView = helper.toTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "Canadian Dollar").firstMatch
        let _ = selectedCell.waitForExistence(timeout: 1.0)

        XCTAssertTrue(selectedCell.isSelected)

        selectedCell.tap()

        XCTAssertFalse(app.buttons["Done"].firstMatch.isEnabled)
    }

    func testDoneButton() {
        let app = XCUIApplication()
        let convertFromButton = helper.convertFromButton
        XCTAssertEqual(convertFromButton.label, "United States Dollar")

        let convertToButton = helper.convertToButton
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")

        convertFromButton.tap()

        let doneButton = app.buttons["Done"].firstMatch
        XCTAssertFalse(doneButton.isEnabled)
        XCTAssertTrue(doneButton.waitForExistence(timeout: 1.0))
        XCTAssertEqual(doneButton.label, "Done")
        XCTAssertTrue(doneButton.isEnabled)

        doneButton.tap()

        XCTAssertEqual(convertFromButton.label, "United States Dollar")
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")
    }

    func testCancelButton() {
        let app = XCUIApplication()
        let convertFromButton = helper.convertFromButton
        XCTAssertEqual(convertFromButton.label, "United States Dollar")

        let convertToButton = helper.convertToButton
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")

        convertFromButton.tap()

        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists)
        XCTAssertEqual(cancelButton.label, "Cancel")
        XCTAssertTrue(cancelButton.isEnabled)

        cancelButton.tap()

        XCTAssertEqual(convertFromButton.label, "United States Dollar")
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")
    }

    func testSelectingNewCurrencyFromToCurrencyTableView() {
        let app = XCUIApplication()
        let convertFromButton = helper.convertFromButton
        XCTAssertEqual(convertFromButton.label, "United States Dollar")

        let convertToButton = helper.convertToButton
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")

        convertFromButton.tap()

        let tableView = helper.toTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "Euro").firstMatch
        let _ = selectedCell.waitForExistence(timeout: 1.0)
        selectedCell.tap()

        XCTAssertTrue(selectedCell.isSelected)

        let doneButton = app.buttons["Done"].firstMatch
        XCTAssertTrue(doneButton.isEnabled)

        doneButton.tap()

        XCTAssertEqual(convertFromButton.label, "United States Dollar")
        XCTAssertEqual(convertToButton.label, "Euro")
    }

    func testSelectingNewCurrencyFromFromCurrencyTableView() {
        let app = XCUIApplication()
        let convertFromButton = helper.convertFromButton
        XCTAssertEqual(convertFromButton.label, "United States Dollar")

        let convertToButton = helper.convertToButton
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")

        convertFromButton.tap()

        let tableView = helper.fromTableView

        let selectedCell = tableView.cells.containing(.staticText, identifier: "Ukrainian Hryvnia").firstMatch
        let _ = selectedCell.waitForExistence(timeout: 1.0)
        selectedCell.tap()

        XCTAssertTrue(selectedCell.isSelected)

        let doneButton = app.buttons["Done"].firstMatch
        XCTAssertTrue(doneButton.isEnabled)

        doneButton.tap()

        XCTAssertEqual(convertFromButton.label, "Ukrainian Hryvnia")
        XCTAssertEqual(convertToButton.label, "Canadian Dollar")
    }
}
