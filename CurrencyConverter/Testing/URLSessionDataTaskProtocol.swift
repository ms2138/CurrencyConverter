//
//  URLSessionDataTaskProtocol.swift
//  CurrencyConverter
//
//  Created by mani on 2020-10-31.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
