//
//  AccountSummaryViewController.swift
//  BankeyApp
//
//  Created by Gizem Boskan on 25.03.2022.
//

import UIKit

final class AccountSummaryViewController: UIViewController {
    
    //Request Models
    var profile: ProfileModel?
    var accountsModel = [AccountModel]()
    
    // ViewModels
    var accountSummaryHeaderViewModel = AccountSummaryHeaderViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountSummaryTableViewCellViewModel: [AccountSummaryTableViewCellViewModel] = []
    
    // Components
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshControl = UIRefreshControl()
    
    // Nerworking
    var profileManager: ProfileManageable = ProfileManager()
    
    // Error alert
    var errorAlert = defaultAlert {
        didSet {
            
        }
    }
    
    var isLoaded = false
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBarButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        setup()
    }
}

// MARK: - Setup
private extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    func setupTableView() {
        tableView.backgroundColor = appColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryTableViewCell.self, forCellReuseIdentifier: AccountSummaryTableViewCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryTableViewCell.rowHeight
        tableView.tableFooterView = UIView()
        
        style()
        layout()
    }
    
    func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupSkeletons() {
        let row = AccountModel.makeSkeleton()
        accountsModel = Array(repeating: row, count: 10)
        
        configureAccountSummaryTableViewCell(with: accountsModel)
    }
}

// MARK: - UITableViewDataSource
extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountSummaryTableViewCellViewModel.isEmpty else { return UITableViewCell() }
        let account = accountSummaryTableViewCellViewModel[indexPath.row]
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryTableViewCell.reuseID, for: indexPath) as! AccountSummaryTableViewCell
            cell.configure(with: account)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSummaryTableViewCellViewModel.count
    }
    
}

// MARK: - UITableViewDelegate
extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Actions
private extension AccountSummaryViewController {
    @objc func logoutBarButtonTapped() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    func reset() {
        profile = nil
        accountsModel = []
        isLoaded = false
    }
}

// MARK: - Networking
private extension AccountSummaryViewController {
    func fetchData() {
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(group: group, userId: userId)
        fetchAccounts(group: group, userId: userId)
        group.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    func fetchProfile(group: DispatchGroup, userId: String) {
        group.enter()
        profileManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    func fetchAccounts(group: DispatchGroup, userId: String) {
        group.enter()
        fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.accountsModel = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
    }
    
    func reloadView() {
        self.tableView.refreshControl?.endRefreshing()
        
        guard let profile = self.profile else { return }
        
        self.isLoaded = true
        self.configureTableHeaderView(with: profile)
        self.configureAccountSummaryTableViewCell(with: self.accountsModel)
        self.tableView.reloadData()
    }
    
    func configureTableHeaderView(with profile: ProfileModel) {
        let vm = AccountSummaryHeaderViewModel(welcomeMessage: "Good morning,",
                                               name: profile.firstName,
                                               date: Date())
        headerView.configure(viewModel: vm)
    }
    
    func configureAccountSummaryTableViewCell(with accounts: [AccountModel]) {
        accountSummaryTableViewCellViewModel = accounts.map {
            AccountSummaryTableViewCellViewModel(accountType: $0.type,
                                                 accountName: $0.name,
                                                 balance: $0.amount)
        }
    }
}

extension AccountSummaryViewController: Alertable {
    
}

// MARK: - Unit testing
extension AccountSummaryViewController {
    func forceFetchProfile() {
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
}
