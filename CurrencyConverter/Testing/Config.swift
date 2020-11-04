//
//  Config.swift
//  CurrencyConverter
//
//  Created by mani on 2020-11-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct Config {
    static let urlSession: URLSessionProtocol = isUITesting() ?
        SeededURLSession() : URLSession.shared

    static let userDefaults: UserDefaultsProtocol = isUITesting() ?
        FakeUserDefaults() : UserDefaults.standard

    static let currencies: [Currency] = isUITesting() ?
        SeededCurrencies().currencies : [Currency]()
}

private func isUITesting() -> Bool {
    UserDefaults.standard.bool(forKey: "UITesting")
}
