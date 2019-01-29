//
//  AppDelegate+Init.swift
//  SublimateClient
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit
import RxReachability
import Reachability
import RxSwift
import SwiftMessages
import RealmSwift
import SublimateSync
import SublimateUI

extension AppDelegate {
    func sublimateSetup() {
        initSublimateDependencies()
        registerObjectSyncers(container: DI.box)
        registerForLogoutCleanUp()
        registerForReachabilityMessages(reachability: DI.box.resolve(Reachability.self)!)
        registerForAuthenticationMessages(authManager: DI.box.resolve(AuthenticationManagerProtocol.self)!)
        displayInitialViewController()
    }

    func displayInitialViewController() {
        let list = SchemesTableViewController(datasource: sublimateTableSources(), authManager: DI.authenticationManager!)
        let navigation = UINavigationController(rootViewController: list)
        let initialViewController : UIViewController
        if sublimateTableSources().filter({ source -> Bool in
            source.availability == TableSource.Availability.onlyAuthenthicated
        }).count > 0 {
            let tabBar = UITabBarController()

            let auth = AuthenticationViewController.instantiate(authManager: DI.authenticationManager!)

            let hasAuth = sublimateTableSources().filter { $0.availability == .onlyAuthenthicated }.count == 1
            if hasAuth {
                tabBar.viewControllers = [auth, navigation]
                tabBar.tabBar.items?[0].title = "Authentication"
                tabBar.tabBar.items?[0].image = UIImage(named: "users")
                tabBar.tabBar.items?[1].title = "Data"
                tabBar.tabBar.items?[1].image = UIImage(named: "data")
            }
            else {
                tabBar.viewControllers = [navigation]
                tabBar.tabBar.items?[0].title = "Data"
                tabBar.tabBar.items?[0].image = UIImage(named: "data")
            }


            initialViewController = tabBar
        }
        else {
            initialViewController = navigation
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

    func registerForReachabilityMessages(reachability : Reachability) {
        reachability.rx.isReachable.skip(1).subscribe(onNext: { reachable in
            if reachable {
                MessageView.showOnline()
            }
            else {
                MessageView.showOffline()
            }
        }).disposed(by: disposeBag)
    }

    func registerForAuthenticationMessages(authManager : AuthenticationManagerProtocol) {
        var userWasLoggedIn = authManager.isLoggedIn
        authManager.authState.skip(1).subscribe(onNext: { state in
            switch state {
            case .loggedOut:
                if userWasLoggedIn {
                    MessageView.showLoggedOut()
                }
                userWasLoggedIn = false
                break
            case .loggedIn:
                if userWasLoggedIn {
                    MessageView.showRefreshedToken()
                }
                else {
                    MessageView.showLoggedIn()
                }
                userWasLoggedIn = true
                break
            }
        }).disposed(by: disposeBag)
    }

    func registerForLogoutCleanUp() {
        DI.authenticationManager?.authState.distinctUntilChanged().subscribe(onNext: { state in
            if state == AuthState.loggedOut {
                do {
                    if let realm = try? Realm(configuration: DI.box.resolve(Realm.Configuration.self, name: DI.RealmConfigurationPrivateOnly)!) {
                        try? realm.write {
                            realm.deleteAll()
                        }
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
}
