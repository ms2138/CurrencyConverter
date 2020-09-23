//
//  CurrencyDataDecoder.swift
//  CurrencyConverter
//
//  Created by mani on 2020-09-22.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyDataDecoder {
    let data: Data

    init(data: Data) {
        self.data = data
    }

    func decode<T>(type: T.Type) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
