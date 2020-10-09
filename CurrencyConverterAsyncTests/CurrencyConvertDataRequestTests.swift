//
//  CurrencyConvertDataRequestTests.swift
//  CurrencyConverterAsyncTests
//
//  Created by mani on 2020-10-06.
//  Copyright © 2020 mani. All rights reserved.
//

import XCTest

@testable import CurrencyConverter

class CurrencyConvertDataRequestTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetCurrencyDataSuccess() {
        let url = CurrencyURL().currencyURL!

        let promise = expectation(description: "Data downloaded")

        let dataRequest = CurrencyDataRequest(url: url)
        dataRequest.getData { result in
            switch result {
                case .success(let data):
                    XCTAssertNotNil(data)
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }

        wait(for: [promise], timeout: 4)
    }

    
}
