//
//  AccountSummaryViewController.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 25.03.2022.
//

import UIKit

final class AccountSummaryViewController: UIViewController {
    
    struct Profile {
        let firstName: String
        let lastName: String
    }
    
    var profile: Profile?
    var accounts: [AccountSummaryTableViewCellViewModel] = []
    var tableView = UITableView()
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBarButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        setup()
        setupNavigationBar()
    }
}

// MARK: - Setup
extension AccountSummaryViewController {
    private func setup() {
        setupTableView()
        setupTableHeaderView()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryTableViewCell.self, forCellReuseIdentifier: AccountSummaryTableViewCell.reuseID)
        tableView.rowHeight = AccountSummaryTableViewCell.rowHeight
        tableView.tableFooterView = UIView()
        
        style()
        layout()
    }
    
    private func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        let header = AccountSummaryHeaderView(frame: .zero)
        
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accounts.isEmpty else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTableViewCell.reuseID, for: indexPath) as! AccountSummaryTableViewCell
        let account = accounts[indexPath.row]
        cell.configure(with: account)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Helpers
extension AccountSummaryViewController {
    private func fetchData() {
        let savings = AccountSummaryTableViewCellViewModel(accountType: .Banking,
                                                           accountName: "Basic Savings",
                                                           balance: 929466.23)
        let chequing = AccountSummaryTableViewCellViewModel(accountType: .Banking,
                                                            accountName: "No-Fee All-In Chequing",
                                                            balance: 17562.44)
        let visa = AccountSummaryTableViewCellViewModel(accountType: .CreditCard,
                                                        accountName: "Visa Avion Card",
                                                        balance: 412.83)
        let masterCard = AccountSummaryTableViewCellViewModel(accountType: .CreditCard,
                                                              accountName: "Student Mastercard",
                                                              balance: 50.83)
        let investment1 = AccountSummaryTableViewCellViewModel(accountType: .Investment,
                                                               accountName: "Tax-Free Saver",
                                                               balance: 2000.00)
        let investment2 = AccountSummaryTableViewCellViewModel(accountType: .Investment,
                                                               accountName: "Growth Fund",
                                                               balance: 15000.00)
        accounts.append(savings)
        accounts.append(chequing)
        accounts.append(visa)
        accounts.append(masterCard)
        accounts.append(investment1)
        accounts.append(investment2)
    }
    
    @objc private func logoutBarButtonTapped() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}
