//
//  ObjectsTableViewController.swift
//  SublimateUI
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit
import RealmSwift
import RxRealm
import RxSwift
import RxRealmDataSources
import SublimateSync

public class ObjectsTableViewController<T : SublimateUICompatible>: UITableViewController {

    let reuseIdentifier = "ObjectCell"
    private var disposeBag = DisposeBag()
    public var syncer : Syncer<T>?
    public var dataSource : RxTableViewRealmDataSource<T>?
    public var realmConfiguration : Realm.Configuration?

    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ObjectCell", bundle:  Bundle(for: ObjectCell.self)), forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        let dataSource = RxTableViewRealmDataSource<T>(
        cellIdentifier: reuseIdentifier, cellType: ObjectCell.self) {cell, indexPath, object in
            cell.identifierLabel?.text = object.presentationId
            cell.titleLabel?.text = object.presentationTitle
            switch object.syncOperation {
            case .create:
                cell.syncStatusLabel?.text = "CREATE"
            case .delete:
                cell.syncStatusLabel?.text = "DELETE"
            case .update:
                cell.syncStatusLabel?.text = "UPDATE"
            case .none:
                cell.syncStatusLabel?.text = ""
            }
            cell.selectionStyle = .none
        }

        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            let refresh = refreshControl.rx.controlEvent(.valueChanged)

            refresh.bind(onNext: {
                self.syncer?.scheduleSyncronization()
            }).disposed(by: disposeBag)

            syncer?.isSyncing.asObservable().asDriver(onErrorJustReturn: false).filter { $0 == false }.drive(onNext: { (value) in
                refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        }

        let realm = try! Realm(configuration: realmConfiguration!)
        let list = realm.objects(T.self).sorted(byKeyPath: "clientCreated", ascending: false)
        Observable.changeset(from: list).bind(to: tableView.rx.realmChanges(dataSource)).disposed(by: disposeBag)
        self.dataSource = dataSource

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ObjectsTableViewController.randomlyCreateTapped))
    }

    @objc func randomlyCreateTapped() {
        var obj = T()
        obj.randomize()
        obj.syncOperation = SyncOperation.create
        if let realmConfiguration = realmConfiguration, let realm = try? Realm(configuration: realmConfiguration) {
            try? realm.write {
                realm.add(obj, update: false)
            }
        }
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        syncer?.activate()
        syncer?.startRefreshTimer(period: 30)
        syncer?.scheduleSyncronization()
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            let obj = dataSource.model(at: indexPath)
            let vc = FieldsTableViewController<T>()
            vc.model = obj
            vc.realmConfiguration = realmConfiguration
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
