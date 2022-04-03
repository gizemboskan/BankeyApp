//
//  ProfileModel.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 30.03.2022.
//

import UIKit

struct ProfileModel: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
