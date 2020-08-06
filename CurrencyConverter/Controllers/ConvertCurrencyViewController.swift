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
    var total = 0.0
    var enteredAmount: String = "" {
        willSet {
            if (newValue.count != 0) {
                outputDisplayLabel.text = newValue
            } else {
                outputDisplayLabel.text = "0"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
