//
//  CurrencyDataController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-09-22.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

protocol CurrencyDataController where Self: UIViewController  {
    var currencies: [Currency] { get set }

    func loadCurrencies(completion: (() -> Void)?)
}

extension CurrencyDataController {
    func loadCurrencies(completion: (() -> Void)? = nil) {
        if let url = CurrencyURL().currencyURL {
            let currencyDownloader = CurrencyDataRequest(url: url)
            currencyDownloader.getData { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                    case .success(let data):
                        do {
                            weakSelf.currencies = try CurrencyDataDecoder(data: data).decode(type: CurrencyList.self).currencies
                            weakSelf.currencies.sort { $0.name < $1.name }
                        } catch {
                            debugLog("Failed to get currencies")
                    }
                    case .failure(let error):
                        debugLog("Error: \(error.localizedDescription)")
                }
                completion?()
            }
        }
    }
}
