//
//  MockURLSession.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-10-22.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

@testable import CurrencyConverter

class MockURLSession: URLSessionProtocol {
    let data: Data?
    let response: URLResponse?
    let error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.data, self.response, self.error)
        return URLSession.shared.dataTask(with: url)
    }
}
