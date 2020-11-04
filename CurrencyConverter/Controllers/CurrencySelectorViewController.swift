//
//  CurrencySelectorViewController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-06.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class CurrencySelectorViewController: UIViewController, AlertPresentable, CurrencyDataController {
    var currencies = Config.currencies
    @IBOutlet weak var fromCurrencyTableView: UITableView!
    @IBOutlet weak var toCurrencyTableView: UITableView!
    var previousConversion: CurrencyConversion?
    fileprivate var sectionTitles = ["From", "To"]
    fileprivate var selectedCurrencies = [String: IndexPath]()
    fileprivate var disabledCurrencies = [UITableView: IndexPath]()
    var handler: ((CurrencyConversion) -> ())?
    var isDoneBarButtonItemEnabled: Bool = false {
        willSet {
            navigationItem.rightBarButtonItem?.isEnabled = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
        setupAccessibilityIdentifiers()
        #endif

        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        performPreviousCurrencyConversionSelection()
    }
}

extension CurrencySelectorViewController {
    private func setupAccessibilityIdentifiers() {
        fromCurrencyTableView.accessibilityIdentifier = AccessibilityIdentifier.fromCurrencyTableView.rawValue
        toCurrencyTableView.accessibilityIdentifier = AccessibilityIdentifier.toCurrencyTableView.rawValue
    }
}

extension CurrencySelectorViewController {
    // MARK: - Currency setup method

    fileprivate func setup() {
        if (currencies.count != 0) { return }

        updateCurrencies(after: TimeInterval(26298000))
        let currencyStorageManager = CurrencyStorageManager(filename: "currencies.json")

        if (currencyStorageManager.savedFileExists == false) {
            self.loadCurrencies { [weak self] in
                guard let weakSelf = self else { return }
                if (weakSelf.currencies.count > 0) {
                    currencyStorageManager.save(currencies: weakSelf.currencies)
                    weakSelf.fromCurrencyTableView.reloadData()
                    weakSelf.toCurrencyTableView.reloadData()
                } else {
                    DispatchQueue.main.async {
                        weakSelf.presentAlert(title: "Error",
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

    fileprivate func performPreviousCurrencyConversionSelection() {
        if let conversion = previousConversion {
            if let fromIndexPath = getIndexPath(for: conversion.from), let toIndexPath = getIndexPath(for: conversion.to) {

                fromCurrencyTableView.scrollToRow(at: fromIndexPath, at: .middle, animated: true)
                toCurrencyTableView.scrollToRow(at: toIndexPath, at: .middle, animated: true)

                if (fromCurrencyTableView.indexPathsForVisibleRows?.contains(fromIndexPath) == true) {
                    tableView(fromCurrencyTableView, didSelectRowAt: fromIndexPath)
                }
                if (toCurrencyTableView.indexPathsForVisibleRows?.contains(toIndexPath) == true) {
                    tableView(toCurrencyTableView, didSelectRowAt: toIndexPath)
                }
            }
        }
    }

    fileprivate func updateCurrencies(after seconds: TimeInterval) {
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

extension CurrencySelectorViewController {
    // MARK: - Cell configuration methods

    fileprivate func toggleCellUserInteraction(in tableView: UITableView, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.isUserInteractionEnabled = (cell.isUserInteractionEnabled == true) ? false : true
        cell.textLabel?.alpha = (cell.textLabel?.alpha == 1.0) ? 0.5 : 1.0
    }

    fileprivate func toggleCellCheckMark(for cell: UITableViewCell) {
        if (cell.accessoryType != UITableViewCell.AccessoryType.checkmark) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

    fileprivate func checkIfCellHasCheckMark(in tableView: UITableView, indexPath: IndexPath) -> Bool {
        if let cell = fromCurrencyTableView.cellForRow(at: indexPath), cell.accessoryType == .checkmark {
            return true
        }
        return false
    }
}

extension CurrencySelectorViewController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)

        let tableViewIndex = (tableView == fromCurrencyTableView) ? 0 : 1
        let key = sectionTitles[tableViewIndex]

        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.accessoryType = .none
        cell.enable(true)

        if let selectedCurrencyIndexPath = selectedCurrencies[key] {
            if (selectedCurrencyIndexPath == indexPath) {
                cell.accessoryType = .checkmark
            }
        }

        if let disabledCurrencyIndexPath = disabledCurrencies[tableView] {
            if (disabledCurrencyIndexPath == indexPath) {
                cell.enable(false)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == fromCurrencyTableView) {
            return sectionTitles[0]
        } else {
            return sectionTitles[1]
        }
    }
}

extension CurrencySelectorViewController: UITableViewDelegate {
    // MARK: - Table view delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        let tableViewIndex = (tableView == fromCurrencyTableView) ? 0 : 1
        let key = sectionTitles[tableViewIndex]

        if let oldIndexPath = selectedCurrencies[key] {
            if (oldIndexPath != indexPath) {
                let oldCell = tableView.cellForRow(at: oldIndexPath)
                oldCell?.accessoryType = .none
            }
        }

        selectedCurrencies[key] = indexPath
        if (tableView == fromCurrencyTableView) {
            if let oldIndexPath = disabledCurrencies[toCurrencyTableView] {
                toggleCellUserInteraction(in: toCurrencyTableView, at: oldIndexPath)
            }
            disabledCurrencies[toCurrencyTableView] = indexPath
            if let cell = toCurrencyTableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
                cell.enable(false)
                selectedCurrencies.removeValue(forKey: "To")
            }
        }

        toggleCellCheckMark(for: cell)

        if (cell.accessoryType == .none) {
            selectedCurrencies.removeValue(forKey: key)
        }

        tableView.deselectRow(at: indexPath, animated: true)

        isDoneBarButtonItemEnabled = (selectedCurrencies.values.count == 2)
    }
}

extension CurrencySelectorViewController {
    // MARK: - IBAction methods

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func done(sender: UIBarButtonItem) {
        let fromCurrencyKey = sectionTitles[0]
        let toCurrencyKey = sectionTitles[1]
        if let fromCurrencyIndexPath = selectedCurrencies[fromCurrencyKey], let toCurrencyIndexPath = selectedCurrencies[toCurrencyKey] {
            let fromCurrency = currencies[fromCurrencyIndexPath.row]
            let toCurrency = currencies[toCurrencyIndexPath.row]
            let currencyConvert = CurrencyConversion(from: fromCurrency, to: toCurrency)

            handler?(currencyConvert)

            cancel(sender: sender)
        }
    }
}

extension CurrencySelectorViewController {
    // MARK: - Helper methods

    fileprivate func getIndexPath(for currency: Currency) -> IndexPath? {
        if let index = currencies.firstIndex(of: currency) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
}

extension CurrencySelectorViewController {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let conversion = previousConversion {
            if let fromIndexPath = getIndexPath(for: conversion.from), let toIndexPath = getIndexPath(for: conversion.to) {
                if (scrollView == fromCurrencyTableView) {
                    if (checkIfCellHasCheckMark(in: fromCurrencyTableView, indexPath: fromIndexPath) == false) {
                        tableView(fromCurrencyTableView, didSelectRowAt: fromIndexPath)
                    }
                } else {
                    if (checkIfCellHasCheckMark(in: toCurrencyTableView, indexPath: toIndexPath) == false) {
                        tableView(toCurrencyTableView, didSelectRowAt: toIndexPath)
                    }
                }
            }
        }
    }
}
