//
//  TestHelpers.swift
//  CurrencyConverterTests
//
//  Created by mani on 2020-10-18.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class TestHelper {
    func loadData(forResource resource: String, extension ext: String) -> Data {
        let bundle = Bundle(for: type(of: self))

        let path = bundle.url(forResource: resource, withExtension: ext)!
        return try! Data(contentsOf: path)
    }
}
