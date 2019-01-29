//
//  FieldsTableViewController.swift
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
import SublimateSync

class FieldsTableViewController<T: SublimateUICompatible>: UITableViewController {
    let reuseIdentifier = "FieldCell"

    // GP TODO: Move this to a new view model
    private var disposeBag = DisposeBag()
    
    var realmConfiguration : Realm.Configuration?
    var model : T?

    func modelWasInvalidated() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FieldCell", bundle:  Bundle(for: FieldCell.self)), forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(FieldsTableViewController.editWasTapped))

        guard let model = model, !model.isInvalidated else {
            modelWasInvalidated()
            return
        }
        Observable.from(object: model).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] obj in
            guard !obj.isInvalidated else {
                self?.modelWasInvalidated()
                return
            }
            self?.tableView.reloadData()
        }, onError: {  [weak self] error in
            if let rxError = error as? RxRealmError, rxError == .objectDeleted {
                self?.modelWasInvalidated()
            }
        }).disposed(by: disposeBag)
    }

    func editErrorObject() {
        let panel : ActionPanelViewController = UIStoryboard.instantiate(storyboard: "ActionPanel")
        panel.cancelButtonCallBack = { [weak panel] in
            panel?.dismiss(animated: true, completion: nil)
        }
        panel.randomButtonTitle = "Retry"
        panel.randomButtonCallBack = { [weak self, weak panel] in
            guard let self = self else {
                panel?.dismiss(animated: true, completion: nil)
                return
            }
            guard var model = self.model, !model.isInvalidated else {
                self.modelWasInvalidated()
                return
            }
            if let realmConfiguration = self.realmConfiguration, let realm = try? Realm(configuration: realmConfiguration){
                try? realm.write {
                    model.isInErrorState = false
                }
            }
            panel?.dismiss(animated: true, completion: nil)
        }
        panel.deleteButtonTitle = "Remove"
        panel.deleteButtonCallBack = { [weak self, weak panel] in
            guard let self = self else {
                panel?.dismiss(animated: true, completion: nil)
                return
            }
            guard let model = self.model, !model.isInvalidated else {
                self.modelWasInvalidated()
                return
            }
            if let realmConfiguration = self.realmConfiguration, let realm = try? Realm(configuration: realmConfiguration){
                try? realm.write {
                    realm.delete(model)
                }
            }
            panel?.dismiss(animated: true, completion: nil)
        }
        let segue = ActionPanelSegue(identifier: "actionPanelSegue", source: self, destination: panel)
        segue.perform()
    }

    func editRegularObject() {
        let panel : ActionPanelViewController = UIStoryboard.instantiate(storyboard: "ActionPanel")
        panel.cancelButtonCallBack = { [weak panel] in
            panel?.dismiss(animated: true, completion: nil)
        }
        panel.randomButtonCallBack = { [weak self, weak panel] in
            guard let self = self else {
                panel?.dismiss(animated: true, completion: nil)
                return
            }
            guard var model = self.model, !model.isInvalidated else {
                self.modelWasInvalidated()
                return
            }
            if let realmConfiguration = self.realmConfiguration, let realm = try? Realm(configuration: realmConfiguration){
                try? realm.write {
                    model.randomize()
                    model.clientLastUpdated = Date().timeIntervalSince1970
                    if model.syncOperation != .create {
                        model.syncOperation = .update
                    }
                }
            }
            panel?.dismiss(animated: true, completion: nil)
        }
        panel.deleteButtonCallBack = { [weak self, weak panel] in
            guard let self = self else {
                panel?.dismiss(animated: true, completion: nil)
                return
            }
            guard var model = self.model, !model.isInvalidated else {
                self.modelWasInvalidated()
                return
            }
            if let realmConfiguration = self.realmConfiguration, let realm = try? Realm(configuration: realmConfiguration){
                try? realm.write {
                    if model.syncOperation != .create {
                        model.syncOperation = .delete
                    }
                    else {
                        realm.delete(model)
                    }
                }
            }
            panel?.dismiss(animated: true, completion: nil)
        }
        let segue = ActionPanelSegue(identifier: "actionPanelSegue", source: self, destination: panel)
        segue.perform()
    }

    @objc func editWasTapped() {
        guard var model = self.model, !model.isInvalidated else {
            self.modelWasInvalidated()
            return
        }
        if model.isInErrorState {
            editErrorObject()
        }
        else {
            editRegularObject()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.model, !model.isInvalidated else {
            self.modelWasInvalidated()
            return 0
        }
        if section == 0 {
            return model.presentationKeyPaths.count
        }
        else {
            return model.metadataKeyPaths.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let model = self.model, !model.isInvalidated else {
            self.modelWasInvalidated()
            return cell
        }
        if let cell = cell as? FieldCell {
            if indexPath.section == 0 {
                cell.titleLabel?.text = model.presentationKeyPaths[indexPath.row].0
                cell.valueLabel?.text = String(describing: model[keyPath: model.presentationKeyPaths[indexPath.row].1])
            }
            else {
                cell.titleLabel?.text = model.metadataKeyPaths[indexPath.row].0
                cell.valueLabel?.text = String(describing: model[keyPath: model.metadataKeyPaths[indexPath.row].1])
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Object Information"
        }
        if section == 1 {
            return "Object metadata"
        }
        return ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
