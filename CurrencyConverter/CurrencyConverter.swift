//
//  CurrencyConverter.swift
//  CurrencyConverter
//
//  Created by mani on 2020-10-14.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

class CurrencyConverter {
    var amount: Double

    init(amount: Double) {
        self.amount = amount
    }

    func getExchangeRate(from data: Data) throws -> ExchangeRate {
        return try CurrencyDataDecoder(data: data).decode(type: ExchangeRate.self)
    }

    func performConversion(for request: CurrencyDataRequest,
                           completion: @escaping ((Result<(Double, ExchangeRate), Error>) -> Void)) {
        request.getData { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        do {
                            let exchange = try self.getExchangeRate(from: data)
                            let total = self.convert(rate: exchange.rate)
                            completion(.success((total, exchange)))
                        } catch {
                            debugLog("Error: \(error.localizedDescription)")
                            completion(.failure(error))
                    }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }

    func convert(rate: Double) -> Double {
        return rate * amount
    }
}
