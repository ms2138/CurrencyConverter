//
//  CurrencyConversion.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-03.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct CurrencyConversion: Codable, Equatable {
    var from: Currency
    var to: Currency

    static func == (lhs: CurrencyConversion, rhs: CurrencyConversion) -> Bool {
        return lhs.from.id == rhs.from.id && lhs.to.id == rhs.to.id
    }
}
