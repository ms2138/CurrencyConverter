//
//  FileManager+EXT.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-04.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

extension FileManager {
    func pathToFile(filename name: String) -> URL {
        let documentDirectories = self.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent(name)
    }
}
