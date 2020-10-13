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
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: fileManager.pathToFile(filename: "currencies.json"))
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

    func testConvertToTableViewExists() {
        XCTAssertNotNil(sut.toCurrencyTableView)
    }

    func testConvertFromTableViewExists() {
        XCTAssertNotNil(sut.fromCurrencyTableView)
    }

    func testCancelBarButtonItemExists() {
        let cancelButton = sut.navigationItem.leftBarButtonItem!

        XCTAssertNotNil(cancelButton)
    }

    func testDoneBarButtonItemExists() {
        let doneButton = sut.navigationItem.rightBarButtonItem!

        XCTAssertNotNil(doneButton)
    }

    func testCancelBarButtonItemHasAction() {
        let cancelButton = sut.navigationItem.leftBarButtonItem!

        guard let cancelAction = cancelButton.action else {
            XCTFail("Cancel bar button item does not have actions assigned")
            return
        }

        XCTAssertEqual(cancelAction, #selector(CurrencySelectorViewController.cancel(sender:)))
    }

    func testDoneBarButtonItemHasAction() {
        let doneButton = sut.navigationItem.rightBarButtonItem!

        guard let doneAction = doneButton.action else {
            XCTFail("Done bar button item does not have actions assigned")
            return
        }

        XCTAssertEqual(doneAction, #selector(CurrencySelectorViewController.done(sender:)))
    }

    func testConvertToTableViewTitleIsSet() {
        let toCurrencyTableView = sut.toCurrencyTableView!

        if let title = sut.tableView(toCurrencyTableView, titleForHeaderInSection: 0) {
            XCTAssertEqual(title, "To")
        }
    }

    func testConvertFromTableViewTitleIsSet() {
        let fromCurrencyTableView = sut.fromCurrencyTableView!

        if let title = sut.tableView(fromCurrencyTableView, titleForHeaderInSection: 0) {
            XCTAssertEqual(title, "From")
        }
    }
}
