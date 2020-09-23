//
//  CurrencyDataRequest.swift
//  CurrencyConverter
//
//  Created by mani on 2020-09-22.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
    case success(Value),
    failure(Error)
}

class CurrencyDataRequest {
    private let url: URL
    private let session: URLSession
    private var dataTask: URLSessionDataTask?

    init(url: URL, session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
}
