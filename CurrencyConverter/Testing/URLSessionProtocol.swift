//
//  URLSessionProtocol.swift
//  CurrencyConverter
//
//  Created by mani on 2020-10-21.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

