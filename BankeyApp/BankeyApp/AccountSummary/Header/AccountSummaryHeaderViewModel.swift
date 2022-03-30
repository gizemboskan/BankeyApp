//
//  AccountSummaryHeaderViewModel.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 30.03.2022.
//

import UIKit

struct AccountSummaryHeaderViewModel {
    let welcomeMessage: String
    let name: String
    let date: Date
    
    var dateFormatted: String {
        return date.monthDayYearString
    }
}
