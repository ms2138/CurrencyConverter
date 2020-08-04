//
//  JSONDataManager.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-03.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class JSONDataManager<T: Codable> {
    func write(data: T, to path: URL) throws {
        let encoder = JSONEncoder()
        let encodedFeeds = try encoder.encode(data)
        try encodedFeeds.write(to: path, options: .atomic)
    }
}
