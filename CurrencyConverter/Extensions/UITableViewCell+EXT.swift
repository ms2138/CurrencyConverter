//
//  UITableViewCell+EXT.swift
//  CurrencyConverter
//
//  Created by mani on 2020-08-08.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func enable(_ state: Bool) {
        self.isUserInteractionEnabled = state
        for view in contentView.subviews {
            view.isUserInteractionEnabled = state
            view.alpha = state ? 1 : 0.5
        }
    }
}
