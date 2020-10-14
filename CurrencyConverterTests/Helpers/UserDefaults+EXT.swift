//
//  UserDefaults+EXT.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-10-12.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var testingDefaults: UserDefaults = UserDefaults(suiteName: "testing")!
    static func resetDefaults() {
        UserDefaults().removePersistentDomain(forName: "testing")
    }
}
