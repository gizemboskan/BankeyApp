//
//  Alertable.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 31.03.2022.
//

import UIKit

/*
 Functional programming inheritance.
 */

let defaultAlert: UIAlertController = {
    let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}()

protocol Alertable { }

extension Alertable where Self: UIViewController {
    
    func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorALert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        
        switch error {
        case .serverError:
            title = "Server Error"
            message = "Please check your network connectivity and try again"
        case .decodingError:
            title = "Decoding Error"
            message = "Please check your network connectivity and try again"
        }
        return (title,message)
        
    }
    
    private func showErrorALert(title: String, message: String) {
        defaultAlert.title = title
        defaultAlert.message = message
        present(defaultAlert, animated: true, completion: nil)
    }
}
