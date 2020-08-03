//
//  Currency.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

struct Currency: Codable, Equatable {
    var name: String
    var symbol: String?
    var id: String

    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id
    }
}
