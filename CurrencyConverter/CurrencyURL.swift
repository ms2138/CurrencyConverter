//
//  CurrencyURL.swift
//  CurrencyConverter
//
//  Created by mani on 2020-09-22.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyURL {
    #warning("Incomplete implementation.  Please register at https://free.currencyconverterapi.com/free-api-key to get an api key")
    private let apiKey = "ENTER KEY HERE"
    var currencyURL: URL? {
        return createBaseURL(path: "currencies")
    }

    private func createBaseURL(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free.currencyconverterapi.com"
        components.path = "/api/v6/\(path)"
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
        return components.url
    }
}

extension CurrencyURL {
    func getExchangeRateURL(from conversion: CurrencyConversion) -> URL? {
        let queryItems = [URLQueryItem(name: "q", value: "\(conversion.from.id)_\(conversion.to.id)"),
                          URLQueryItem(name: "compact", value: "ultra")]
        return createBaseURL(path: "convert", queryItems: queryItems)
    }
}
