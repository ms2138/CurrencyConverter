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
    var appDefaults = AppDefaults()
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
            appDefaults.selectedCurrencyConversion = newValue
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
        convertButton.accessibilityIdentifier = AccessibilityIdentifier.convertButton.rawValue
    }
}

extension ConvertCurrencyViewController {
    // MARK: Setup methods

    private func setup() {
        updateCurrencies(after: TimeInterval(26298000))
        UIButton.appearance().isExclusiveTouch = true
        setConversionButtonsTitle(currencyConversion)

        if let cache = appDefaults.exchangeRateCache {
            exchangeRateCache = cache
        }

        let currencyStorageManager = CurrencyStorageManager(filename: "currencies.json")

        if (currencyStorageManager.savedFileExists == false) {

            self.loadCurrencies {
                [unowned self] in
                if (self.currencies.count > 0) {
                    currencyStorageManager.save(currencies: self.currencies)
                } else {
                    debugLog("Failed to load currencies")
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
                                               selector: #selector(saveDefaults),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDefaults),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
}

extension ConvertCurrencyViewController {
    @objc func saveDefaults() {
        if (exchangeRateCache.count > 0) {
            debugLog("Saving exchange rate cache to user defaults - \(exchangeRateCache)")
            appDefaults.exchangeRateCache = exchangeRateCache
        }
    }
}

extension ConvertCurrencyViewController {
    // MARK: - Exchange/Currency methods

    private func flushExchangeRateCache(after seconds: TimeInterval) {
        if let timestamp = appDefaults.exchangeRateCacheTimestamp {
            if (Date().timeIntervalSince(timestamp) >= seconds) {
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

    @IBAction func startConverting(sender: UIButton) {
        if let amount = Double(enteredAmount), amount != 0.0 {
            let converter = CurrencyConverter(amount: amount)
            flushExchangeRateCache(after: 3600)

            if let rate = exchangeRate {
                // Use the exchange rate cache to prevent conversion from hitting the server
                debugLog("Converting currency using exchange rate cache")
                total = converter.convert(rate: rate)
                self.outputDisplayLabel.text = roundedTotal
                debugLog("The total converted amount is: \(total)")
            } else {
                convertButton.isUserInteractionEnabled = false

                if let url = CurrencyURL().getExchangeRateURL(from: currencyConversion) {
                    let request = CurrencyDataRequest(url: url)
                    converter.performConversion(for: request) {
                        [unowned self] result in
                        switch result {
                            case .success(let (total, exchange)):
                                self.total = total
                                self.outputDisplayLabel.text = self.roundedTotal
                                self.exchangeRateCache[self.conversionID] = exchange.rate
                            case .failure(let error):
                                self.presentAlert(title: "Error",
                                                  message: "Failed to perform conversion")
                                debugLog("Error: \(error.localizedDescription)")
                        }
                        self.convertButton.isUserInteractionEnabled = true
                    }
                }
            }
        }
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
