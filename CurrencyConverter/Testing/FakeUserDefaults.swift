//
//  FakeUserDefaults.swift
//  CurrencyConverter
//
//  Created by mani on 2020-11-01.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class FakeUserDefaults: UserDefaultsProtocol {
    var data: [String: Any] = [:]

    func value(forKey key: String) -> Any? {
        return data[key]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        data[defaultName] = value
    }

    func object(forKey defaultName: String) -> Any? {
        return data[defaultName]
    }
}
