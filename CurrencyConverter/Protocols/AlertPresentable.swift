//
//  AlertPresentable.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-05.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

protocol AlertPresentable where Self: UIViewController {
    func presentAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?)
}

extension AlertPresentable {
    func presentAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}
