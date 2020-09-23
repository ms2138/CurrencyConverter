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
