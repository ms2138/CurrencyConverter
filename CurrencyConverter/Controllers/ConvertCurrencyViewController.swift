//
//  ConvertCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-02.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class ConvertCurrencyViewController: UIViewController, AlertPresentable, CurrencyDataController {
    var currencies = [Currency]()
    @IBOutlet weak var outputDisplayLabel: UILabel!
    @IBOutlet weak var exchangeRateDisplayLabel: UILabel!
    @IBOutlet weak var convertFromButton: UIButton!
    @IBOutlet weak var convertToButton: UIButton!
    @IBOutlet weak var switchConversionButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
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
        return AppDefaults().selectedCurrencyConversion
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

        setup()

        setupNotifications()

        #if DEBUG
        setupAccessibilityIdentifiers()
        #endif
    }
}

extension ConvertCurrencyViewController {
    private func setupAccessibilityIdentifiers() {
        outputDisplayLabel.accessibilityIdentifier = AccessibilityIdentifier.outputDisplayLabel.rawValue
        exchangeRateDisplayLabel.accessibilityIdentifier = AccessibilityIdentifier.exchangeRateDisplayLabel.rawValue
        convertFromButton.accessibilityIdentifier = AccessibilityIdentifier.convertFromButton.rawValue
        convertToButton.accessibilityIdentifier = AccessibilityIdentifier.convertToButton.rawValue
    }
}

extension ConvertCurrencyViewController {
    // MARK: Setup methods

    private func setup() {
        updateCurrencies(after: TimeInterval(26298000))
        UIButton.appearance().isExclusiveTouch = true
        setConversionButtonsTitle(currencyConversion)

        let currencyStorageManager = CurrencyStorageManager(filename: "currencies.json")

        if (currencyStorageManager.savedFileExists == false) {
            AppDefaults().selectedCurrencyConversion = currencyConversion

            self.loadCurrencies {
                [unowned self] in
                if (self.currencies.count > 0) {
                    currencyStorageManager.save(currencies: self.currencies)
                } else {
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Error",
                                          message: "Failed to load currencies")
                    }
                }
            }
        } else {
            if let theCurrencies = currencyStorageManager.read() {
                currencies = theCurrencies
            }
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
}

extension ConvertCurrencyViewController {
    @objc func save() {
        AppDefaults().selectedCurrencyConversion = currencyConversion
        if (exchangeRateCache.count > 0) {
            debugLog("Saving exchange rate cache to user defaults - \(exchangeRateCache)")
            AppDefaults().exchangeRateCache = exchangeRateCache
        }
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Exchange/Currency methods

    private func flushExchangeRateCache(after seconds: TimeInterval) {
        let appDefaults = AppDefaults()
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
            let currencyStorageManager = CurrencyStorageManager(filename: "currencies.json")
            let fileAttributes = try FileManager.default.attributesOfItem(atPath:
                currencyStorageManager.pathToSavedCurrencies.path) as NSDictionary
            if let creationDate = fileAttributes.fileCreationDate() {
                if (Date().timeIntervalSince(creationDate) >= seconds) {
                    loadCurrencies {
                        [unowned self] in
                        if (self.currencies.count > 0) {
                            currencyStorageManager.save(currencies: self.currencies)
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

    func performConversion() {
        if let amount = Double(enteredAmount), amount != 0.0 {
            if let rate = exchangeRate {
                convertAndDisplayTotal(rate: rate, amount: amount)
            } else {
                convertButton.isUserInteractionEnabled = false
                flushExchangeRateCache(after: 3600)

                if let url = CurrencyURL().getExchangeRateURL(from: currencyConversion) {
                    let currencyDownloader = CurrencyDataRequest(url: url)
                    currencyDownloader.getData { [unowned self] result in
                        DispatchQueue.main.async {
                            switch result {
                                case .success(let data):
                                    do {
                                        let exchange = try CurrencyDataDecoder(data: data).decode(type: ExchangeRate.self)
                                        defer { self.convertButton.isUserInteractionEnabled = true }
                                        let rate = exchange.rate
                                        self.exchangeRateCache[self.conversionID] = rate
                                        self.convertAndDisplayTotal(rate: rate, amount: amount)
                                    } catch {
                                        // If the data request fails, get last saved exchange rate for the given conversionId
                                        if let cache = AppDefaults().exchangeRateCache, let exchange = cache[self.conversionID] {
                                            debugLog("Converting currency using exchange rate cache")
                                            self.convertAndDisplayTotal(rate: exchange, amount: amount)
                                        } else {
                                            self.presentAlert(title: "Error",
                                                              message: "Failed to perform conversion")
                                        }
                                }
                                case .failure(let error):
                                    debugLog("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }

    func convertAndDisplayTotal(rate: Double, amount: Double) {
        total = convert(using: rate, amount: amount)
        enteredAmount = roundedTotal
        debugLog("The total converted amount is: \(total)")
    }

    func convert(using rate: Double, amount: Double) -> Double {
        return rate * amount
    }

    @IBAction func convert(sender: UIButton) {
        performConversion()
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
    // MARK: - Gesture methods
    
    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (enteredAmount.count != 0 && total == 0.0) {
            enteredAmount.removeLast()
        }
    }

    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        let menuController = UIMenuController.shared
        if (menuController.isMenuVisible == true) {
            if let recognizerView = recognizer.view {
                recognizerView.resignFirstResponder()
            }
            menuController.hideMenu()
        }
    }

    @IBAction func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if let rate = exchangeRate {
            exchangeRateDisplayLabel.text = String(rate)
            outputDisplayLabel.isHidden = !isExchangeRateDisplayed
        }
    }

    @IBAction func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == .began) {
            if let recognizerView = recognizer.view, let recognizerSuperView = recognizerView.superview {
                let menuController = UIMenuController.shared
                if (menuController.isMenuVisible == false) {
                    recognizerView.becomeFirstResponder()
                    menuController.showMenu(from: recognizerSuperView, rect: recognizerView.bounds)
                }
            }
        }
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Keypad methods
    
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

    @IBAction func switchConversionDirection(sender: UIButton) {
        switchConversionButton.isUserInteractionEnabled = false
        if (total != 0.0) {
            enteredAmount = roundedTotal
        }

        let toCurrency = currencyConversion.to
        currencyConversion.to = currencyConversion.from
        currencyConversion.from = toCurrency

        UIView.animate(withDuration: 0.2, animations: {
            self.convertFromButton.alpha = 0.0
            self.convertToButton.alpha = 0.0
        }) { (finished) in
            self.setConversionButtonsTitle(self.currencyConversion)

            UIView.animate(withDuration: 0.2, animations: {
                self.convertFromButton.alpha = 1.0
                self.convertToButton.alpha = 1.0
            }) { (finished) in
                self.switchConversionButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showSelectCurrencies"?:
                let navController = segue.destination as! UINavigationController
                if let viewController = navController.topViewController {
                    let vc = viewController as! CurrencySelectorViewController
                    vc.previousConversion = currencyConversion
                    vc.handler = {
                        [unowned self] conversion in
                        self.currencyConversion = conversion
                    }
            }
            default:
                preconditionFailure("Segue identifier did not match")
        }
    }
}
