//
//  AccountSummaryViewController+Networking.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 30.03.2022.
//

import Foundation
import UIKit

extension AccountSummaryViewController {
    
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[AccountModel],NetworkError>) -> Void) {
        let url = URL(string:  "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let accounts = try decoder.decode([AccountModel].self, from: data)
                    completion(.success(accounts))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
