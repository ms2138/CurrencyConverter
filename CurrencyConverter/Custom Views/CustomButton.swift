//
//  CustomButton.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-03.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var normalBackgroundColor: UIColor? {
        willSet {
            backgroundColor = newValue
        }
    }
    @IBInspectable var highlightedBackgroundColor: UIColor?
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
