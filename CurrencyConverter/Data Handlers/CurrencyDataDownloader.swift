//
//  CurrencyDataDownloader.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-03.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyDataDownloader {
    private let apiKey = "ENTER KEY HERE"

    private func createURL(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free.currencyconverterapi.com"
        components.path = "/api/v7/\(path)"
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
        return components.url
    }
}
