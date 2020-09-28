//
//  CurrencySelectorViewControllerHelper.swift
//  CurrencyConverterUITests
//
//  Created by mani on 2020-09-27.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

class CurrencySelectorViewControllerHelper {
    var fromTableView: XCUIElement {
        return XCUIApplication().tables["FromCurrencyTableView"]
    }

    var toTableView: XCUIElement {
        return XCUIApplication().tables["ToCurrencyTableView"]
    }

    var fromTableViewHeaderTitle: XCUIElement {
        return self.fromTableView.staticTexts["From"]
    }

    var toTableViewHeaderTitle: XCUIElement {
        return self.toTableView.staticTexts["To"]
    }
}
