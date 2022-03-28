//
//  Decimal+Extension.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 28.03.2022.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
