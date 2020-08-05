//
//  CustomLabel.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-04.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(UIResponderStandardEditActions.copy(_:)))
    }

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
}
