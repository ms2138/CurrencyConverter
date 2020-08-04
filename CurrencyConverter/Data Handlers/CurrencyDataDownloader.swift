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

extension CurrencyDataDownloader {
    func getCurrencyData(completion: @escaping ([Currency]?, URLResponse?, Error?) -> ()) {
        guard let url = createURL(path: "currencies") else { return }
        var currencies: [Currency]?

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CurrencyList.self, from: data)
                    currencies = result.currencies

                } catch {
                    debugLog("Failed to get currency data.")
                }
            }
            DispatchQueue.main.async {
                completion(currencies, response, error)
            }
        }
        dataTask.resume()
    }
}
