//
//  AccountModel.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 30.03.2022.
//
import UIKit

struct AccountModel: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}
