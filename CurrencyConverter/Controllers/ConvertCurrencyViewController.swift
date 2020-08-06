//
//  ConvertCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class ConvertCurrencyViewController: UIViewController {
    @IBOutlet weak var outputDisplayLabel: UILabel!
    @IBOutlet weak var exchangeRateDisplayLabel: UILabel!
    @IBOutlet weak var convertFromButton: UIButton!
    @IBOutlet weak var convertToButton: UIButton!
    @IBOutlet weak var switchConversionButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    var currencyDataManager: CurrencyDataManager = CurrencyDataManager()
    fileprivate var exchangeRateCache = [String: Double]()
    var total = 0.0
    var roundedTotal: String {
        return String(format: "%.5f", total)
    }
    var enteredAmount: String = "" {
        willSet {
            if (newValue.count != 0) {
                outputDisplayLabel.text = newValue
            } else {
                outputDisplayLabel.text = "0"
            }
        }
    }
    var currencyConversion: CurrencyConversion = {
        let fromCurrency = Currency.init(name: "United States Dollar", symbol: "$", id: "USD")
        let toCurrency = Currency.init(name: "Canadian Dollar", symbol: "$", id: "CAD")
        return CurrencyConversion.init(from: fromCurrency, to: toCurrency)
        }() {
        willSet {
            setConversionButtonsTitle(newValue)
        }
    }
    private(set) lazy var setConversionButtonsTitle = { [unowned self] (conversion: CurrencyConversion) in
        self.convertFromButton.setTitle(conversion.from.name, for: .normal)
        self.convertToButton.setTitle(conversion.to.name, for: .normal)
    }
    fileprivate var conversionID: String {
        return "\(currencyConversion.from.id)_\(currencyConversion.to.id)"
    }
    var exchangeRate: Double? {
        return exchangeRateCache[conversionID]
    }
    var isExchangeRateDisplayed: Bool {
        return outputDisplayLabel.isHidden == true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Exchange/Currency methods

    private func flushExchangeRateCache(after seconds: TimeInterval) {
        let appDefaults = AppDefaults.init()
        if let timeStamp = appDefaults.exchangeRateCacheTimestamp {
            if (Date().timeIntervalSince(timeStamp) >= seconds) {
                exchangeRateCache.removeAll()
                appDefaults.exchangeRateCacheTimestamp = Date()
            }
        } else {
            appDefaults.exchangeRateCacheTimestamp = Date()
        }
    }

    private func updateCurrencies(after seconds: TimeInterval) {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: currencyDataManager.pathToSavedCurrencies.path) as NSDictionary
            if let creationDate = fileAttributes.fileCreationDate() {
                if (Date().timeIntervalSince(creationDate) >= seconds) {
                    currencyDataManager.downloadCurrencies {
                        [unowned self] in
                        if (self.currencyDataManager.currencies.count > 0) {
                            self.currencyDataManager.saveCurrencies()
                        }
                    }
                } else {
                    debugLog("Time interval not met.  Currency update will not proceed.")
                }
            }
        } catch {
            debugLog("Failed to update currencies")
        }
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Currency conversion methods

    func performConversion(using rate: Double, amount: Double) -> Double {
        return rate * amount
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Clear/Reset methods

    func clearAll() {
        if (enteredAmount.count != 0) {
            enteredAmount.removeAll()
            total = 0.0
        }

        if (isExchangeRateDisplayed == true) {
            outputDisplayLabel.isHidden = !isExchangeRateDisplayed
        }
    }

    @IBAction func clearButtonTouched(sender: UIButton) {
        clearAll()
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Number keypad methods
    
    @IBAction func numberKeypadTouched(sender: UIButton) {
        guard let text = sender.title(for: .selected) else {
            return
        }

        if (total != 0.0) { clearAll() }

        if (enteredAmount.count >= 13) {
            return
        }

        if (enteredAmount.count == 0) {
            if (text == "0" || text == ".") {
                return
            }
        }

        if (text == ".") {
            if (enteredAmount.contains(".") == true) {
                return
            }
        }

        enteredAmount.append(text)
    }
}
