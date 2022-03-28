//
//  AccountSummaryTableViewCellViewModel.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 28.03.2022.
//

import UIKit

enum AccountType: String {
    case Banking
    case CreditCard
    case Investment
}

struct AccountSummaryTableViewCellViewModel {
    
    let accountType: AccountType
    let accountName: String
    let balance: Decimal
    var balanceAttributedString: NSAttributedString {
        CurrencyFormatter().makeAttributedCurrency(balance)
    }
}
