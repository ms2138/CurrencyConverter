//
//  CurrencySelectorViewController.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-06.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class CurrencySelectorViewController: UIViewController {
    @IBOutlet weak var fromCurrencyTableView: UITableView!
    @IBOutlet weak var toCurrencyTableView: UITableView!
    var currencyDataManager: CurrencyDataManager = CurrencyDataManager()
    var previousConversion: CurrencyConversion?
    fileprivate var sectionTitles = ["From", "To"]
    fileprivate var selectedCurrencies = [String: IndexPath]()
    fileprivate var disabledCurrencies = [UITableView: IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyDataManager.readCurrencies()
    }
}


