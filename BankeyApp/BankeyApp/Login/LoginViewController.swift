//
//  ViewController.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 22.03.2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

final class LoginViewController: UIViewController {
    
    let bankeyLabel = UILabel()
    let bankeyInfoLabel = UILabel()
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    weak var delegate: LoginViewControllerDelegate?
    
    var username: String? {
        loginView.usernameTextField.text
    }
    
    var password: String? {
        loginView.passwordTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        signInButton.configuration?.showsActivityIndicator = false
    }
}

extension LoginViewController {
    
    private func style() {
        bankeyLabel.translatesAutoresizingMaskIntoConstraints = false
        bankeyLabel.textAlignment = .center
        bankeyLabel.textColor = .darkGray
        bankeyLabel.numberOfLines = 0
        bankeyLabel.text = "Bankey"
        
        bankeyInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        bankeyInfoLabel.textAlignment = .center
        bankeyInfoLabel.textColor = .lightGray
        bankeyInfoLabel.numberOfLines = 0
        bankeyInfoLabel.text = "Your premium source for all things in banking!"
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8.0 // for indicator spacing
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
    }
    
    private func layout() {
        view.addSubview(bankeyLabel)
        view.addSubview(bankeyInfoLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // bankeyLabel
        NSLayoutConstraint.activate([
            bankeyLabel.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.topAnchor, multiplier: 16.0),
            bankeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bankeyLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0)
            
        ])
        
        // bankeyInfoLabel
        NSLayoutConstraint.activate([
            bankeyInfoLabel.topAnchor.constraint(equalToSystemSpacingBelow: bankeyLabel.bottomAnchor, multiplier: 2.0),
            bankeyInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bankeyInfoLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0)
            
        ])
        
        // loginView
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1.0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1.0)
        ])
        
        // signInButton
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2.0),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // errorMessageLabel
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2.0),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc func signInButtonTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username / password should never be nil")
            return
        }
        
        //        if username.isEmpty || password.isEmpty {
        //            configureView(withMessage: "Username / password can not be empty")
        //            return
        //        }
        
        if username == "Gizem" && password == "Welcome" {
            signInButton.configuration?.showsActivityIndicator = true
        } else {
            // configureView(withMessage: "Incorrect username / password")
            delegate?.didLogin()
        }
    }
    
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}
