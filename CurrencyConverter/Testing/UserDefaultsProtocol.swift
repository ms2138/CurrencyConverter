//
//  UserDefaultsProtocol.swift
//  CurrencyConverter
//
//  Created by mani on 2020-11-01.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func value(forKey key: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: UserDefaultsProtocol {}
