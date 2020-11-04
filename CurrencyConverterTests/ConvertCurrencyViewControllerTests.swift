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
    var appDefaults: AppDefaults!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateInitialViewController() as? ConvertCurrencyViewController
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = sut

        appDefaults = AppDefaults()
        appDefaults.defaults = UserDefaults.testingDefaults
        sut.appDefaults = appDefaults
    }

    override func tearDown() {
        sut = nil
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: fileManager.pathToFile(filename: "currencies.json"))

        UserDefaults.resetDefaults()
    }

    func testViewNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func testConvertButtonExists() {
        XCTAssertNotNil(sut.convertButton)
    }

    func testConvertButtonHasAction() {
        let convertButton = sut.convertButton!

        guard let convertAction = convertButton.actions(forTarget: sut, forControlEvent: .touchUpInside ) else {
            XCTFail("Convert button does not have actions assigned")
            return
        }

        XCTAssertTrue(convertAction.contains("startConvertingWithSender:"))
    }

    func testConvertToButtonSegue() {
        let convertToButton = sut.convertToButton!

        convertToButton.sendActions(for: .touchUpInside)

        let navController = sut.presentedViewController as! UINavigationController
        let currencySelectorViewController = navController.visibleViewController as! CurrencySelectorViewController

        XCTAssertNotNil(currencySelectorViewController)
        XCTAssertTrue(currencySelectorViewController.isKind(of: CurrencySelectorViewController.self))
    }

    func testConvertFromButtonExists() {
        XCTAssertNotNil(sut.convertFromButton)
    }

    func testConvertFromButtonSegue() {
        let convertFromButton = sut.convertFromButton!

        convertFromButton.sendActions(for: .touchUpInside)

        let navController = sut.presentedViewController as! UINavigationController
        let currencySelectorViewController = navController.visibleViewController as! CurrencySelectorViewController

        XCTAssertNotNil(currencySelectorViewController)
        XCTAssertTrue(currencySelectorViewController.isKind(of: CurrencySelectorViewController.self))
    }

    func testSwitchConversionButtonExists() {
        XCTAssertNotNil(sut.switchConversionButton)
    }

    func testSwitchConversionButtonHasAction() {
        let switchConversionButton = sut.switchConversionButton!

        guard let switchAction = switchConversionButton.actions(forTarget: sut, forControlEvent: .touchUpInside ) else {
            XCTFail("Switch conversion button does not have actions assigned")
            return
        }

        XCTAssertTrue(switchAction.contains("switchConversionDirectionWithSender:"))
    }

    func testKeyPadButtonsHasActions() {
        for i in 1...11 {
            if let keypadButton = sut.view.viewWithTag(i) as? UIButton {
                guard let keypadButtonAction = keypadButton.actions(forTarget: sut, forControlEvent: .touchUpInside ) else {
                    XCTFail("Keypad button does not have actions assigned")
                    return
                }

                XCTAssertTrue(keypadButtonAction.contains("numberKeypadTouchedWithSender:"))
            }
        }
    }

    func testClearButtonExists() {
        let clearButton = sut.view.viewWithTag(12) as! UIButton
        XCTAssertNotNil(clearButton)
    }

    func testClearButtonHasAction() {
        if let clearButton = sut.view.viewWithTag(12) as? UIButton {
            guard let clearButtonAction = clearButton.actions(forTarget: sut, forControlEvent: .touchUpInside ) else {
                XCTFail("Clear button does not have actions assigned")
                return
            }

            XCTAssertTrue(clearButtonAction.contains("clearButtonTouchedWithSender:"))
        }
    }

    func testClearAllSuccess() {
        let testString = "70.49383"
        sut.outputDisplayLabel.text = testString
        sut.total = 70.49383
        sut.enteredAmount = testString

        XCTAssertEqual(sut.outputDisplayLabel.text!, testString)

        sut.clearAll()

        XCTAssertEqual(sut.outputDisplayLabel.text!, "0")
        XCTAssertEqual(sut.total, 0.0)
        XCTAssertEqual(sut.enteredAmount, "")
    }

    func testChangingCurrencyConversion() {
        let fromCurrency = Currency.init(name: "United States Dollar", symbol: "$", id: "USD")
        let toCurrency = Currency.init(name: "Canadian Dollar", symbol: "$", id: "CAD")
        let oldConversion = CurrencyConversion.init(from: fromCurrency, to: toCurrency)

        sut.currencyConversion = oldConversion

        XCTAssertEqual(sut.currencyConversion, oldConversion)
        XCTAssertEqual(sut.currencyConversion, appDefaults.selectedCurrencyConversion)

        let newFromCurrency = Currency.init(name: "Ukrainian Hryvnia", symbol: "₴", id: "UAH")
        let newConversion = CurrencyConversion.init(from: newFromCurrency, to: toCurrency)

        sut.currencyConversion = newConversion

        XCTAssertEqual(sut.currencyConversion, newConversion)
        XCTAssertEqual(sut.currencyConversion, appDefaults.selectedCurrencyConversion)
    }
}
