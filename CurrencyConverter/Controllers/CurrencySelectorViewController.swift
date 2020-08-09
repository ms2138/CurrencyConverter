//
//  CurrencySelectorViewController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-06.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class CurrencySelectorViewController: UIViewController, AlertPresentable {
    @IBOutlet weak var fromCurrencyTableView: UITableView!
    @IBOutlet weak var toCurrencyTableView: UITableView!
    var currencyDataManager: CurrencyDataManager = CurrencyDataManager()
    var previousConversion: CurrencyConversion?
    fileprivate var sectionTitles = ["From", "To"]
    fileprivate var selectedCurrencies = [String: IndexPath]()
    fileprivate var disabledCurrencies = [UITableView: IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCurrencies()
    }
}

extension CurrencySelectorViewController {
    fileprivate func loadCurrencies() {
        if (currencyDataManager.savedFileExists == false) {
            currencyDataManager.downloadCurrencies {
                [weak self] in
                guard let weakSelf = self else { return }
                if (weakSelf.currencyDataManager.currencies.count > 0) {
                    weakSelf.currencyDataManager.currencies.sort { $0.name < $1.name }
                    weakSelf.currencyDataManager.saveCurrencies()
                    weakSelf.toCurrencyTableView.reloadData()
                    weakSelf.toCurrencyTableView.reloadData()
                } else {
                    weakSelf.presentAlert(title: "Error",
                                          message: "Failed to load currencies")
                }
            }
        } else {
            currencyDataManager.readCurrencies()
        }
    }
}

extension CurrencySelectorViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyDataManager.currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)

        let tableViewIndex = (tableView == fromCurrencyTableView) ? 0 : 1
        let key = sectionTitles[tableViewIndex]

        let currency = currencyDataManager.currencies[indexPath.row]
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

