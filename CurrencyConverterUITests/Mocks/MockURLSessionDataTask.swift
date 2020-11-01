//
//  MockURLSessionDataTask.swift
//  CurrencyConverterUITests
//
//  Created by mani on 2020-10-31.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

@testable import CurrencyConverter

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
    func cancel() {}
}
