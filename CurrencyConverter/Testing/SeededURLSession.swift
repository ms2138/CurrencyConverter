//
//  SeededURLSession.swift
//  CurrencyConverter
//
//  Created by mani on 2020-11-01.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class SeededURLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        if let json = ProcessInfo.processInfo.environment["ConversionSuccess"] {
            let data = Data(json.utf8)
            completionHandler(data, nil, nil)
        }

        if let errorDomain = ProcessInfo.processInfo.environment["ConversionFailure"] {
            let error = NSError(domain: errorDomain, code: 0, userInfo: nil)
            completionHandler(nil, nil, error)
        }

        return FakeDataTask()
    }
}
