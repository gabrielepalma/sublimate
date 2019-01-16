//
//  SchemesTableViewController.swift
//  SublimateUI
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit
import RxSwift
import SublimateSync

public class SchemesTableViewController: UITableViewController {
    let reuseIdentifier = "SchemeCell"

    private var disposeBag = DisposeBag()

    var datasource : [TableSource]
    var authManager : AuthenticationManagerProtocol

    public init(datasource : [TableSource], authManager : AuthenticationManagerProtocol) {
        self.datasource = datasource
        self.authManager = authManager
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var splitDataSource : [[TableSource]]?

    func isLoggedIn() -> Bool {
        return authManager.isLoggedIn
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SchemeCell", bundle: Bundle(for: SchemeCell.self)), forCellReuseIdentifier: reuseIdentifier)

        let openDatasource = datasource.filter { $0.availability == .openAccess }
        let authDatasource = datasource.filter { $0.availability == .onlyAuthenthicated }
        splitDataSource = [openDatasource, authDatasource]

        authManager.authState.distinctUntilChanged().asDriver(onErrorJustReturn: AuthState.loggedOut).drive(onNext: { [weak self] state in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return splitDataSource?.count ?? 0
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard isLoggedIn() || section == 0 else {
            return 1
        }

        return max(splitDataSource?[section].count ?? 0, 1)
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        if let splitDataSource = splitDataSource, let cell = cell as? SchemeCell {
            if splitDataSource[indexPath.section].count == 0 {
                cell.descriptionLabel?.text = "No tables in this category"
                cell.accessLabel?.text = ""
            }
            else if !isLoggedIn() && indexPath.section == 1 {
                cell.descriptionLabel?.text = "Log in to access these tables"
                cell.accessLabel?.text = ""
            }
            else {
                cell.descriptionLabel?.text = splitDataSource[indexPath.section][indexPath.row].description
                cell.accessLabel?.text = ""
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let splitDataSource = splitDataSource,
            (indexPath.section == 0 || isLoggedIn()),
            splitDataSource[indexPath.section].count > indexPath.row {
            let source = splitDataSource[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(source.viewController(), animated: true)
        }
    }

    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Open Access"
        }
        if section == 1 {
            return "Private Tables"
        }
        return ""
    }
}
