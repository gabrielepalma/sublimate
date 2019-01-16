//
//  AuthenticationViewController.swift
//  SublimateClient
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import Reachability
import RxReachability
import PromiseKit
import SwiftMessages
import SublimateSync

class AuthenticationViewController: UIViewController, NVActivityIndicatorViewable {

    let disposeBag = DisposeBag()

    var authManager : AuthenticationManagerProtocol?

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loggedInIdLabel: UILabel!
    @IBOutlet weak var loggedInUsernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var messagePaddingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
        if let auth = authManager {
            auth.authState.asDriver(onErrorJustReturn: AuthState.loggedOut).drive(onNext: { [weak self] state in
                self?.updateLoggedIn()
            }).disposed(by: disposeBag)
        }
    }

    func updateLoggedIn() {
        guard let auth = authManager else {
            return
        }
        if auth.isLoggedIn {
            self.logoutView.isHidden = false
            self.loginView.isHidden = true
            self.loggedInIdLabel.text = auth.userId ?? ""
            self.loggedInUsernameLabel.text = auth.username ?? ""
        }
        else {
            self.logoutView.isHidden = true
            self.loginView.isHidden = false
            self.passwordTextView.text = ""
            self.usernameTextView.text = ""

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    let minimumDurationAnimation = 0.75
    @IBAction func loginButtonTapped(_ sender: Any) {

        startAnimating(self.view.frame.size, message: "Logging in", type: .ballZigZagDeflect, color: .white, minimumDisplayTime: 1, backgroundColor: .black, textColor: .white)


        let waitAtLeast = after(seconds: minimumDurationAnimation)
        authManager?.loginWithUserCredentials(username: usernameTextView.text ?? "", password: passwordTextView.text ?? "")
            .ensureThen({ () -> Guarantee<Void> in
                waitAtLeast
            })
            .catch({ error in
                MessageView.showMessage(message: "Login failed", type: .failed)
            })
            .finally {
                self.stopAnimating()
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        startAnimating(self.view.frame.size, message: "Creating user", type: .ballZigZagDeflect, color: .white, minimumDisplayTime: 1, backgroundColor: .black, textColor: .white)

        let waitAtLeast = after(seconds: minimumDurationAnimation)
        authManager?.createUser(username: usernameTextView.text ?? "", password: passwordTextView.text ?? "")
            .ensureThen({ () -> Guarantee<Void> in
                waitAtLeast
            })
            .done {
                MessageView.showMessage(message: "User was created", type: .success)
            }
            .catch({ error in
                MessageView.showMessage(message: "Operation failed", type: .failed)
            })
            .finally {
                self.stopAnimating()
        }
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        startAnimating(self.view.frame.size, message: "Logging out", type: .ballZigZagDeflect, color: .white, minimumDisplayTime: 1, backgroundColor: .black, textColor: .white)

        let waitAtLeast = after(seconds: minimumDurationAnimation)
        authManager?.logout()
            .ensureThen({ () -> Guarantee<Void> in
                waitAtLeast
            })
            .catch({ error in
                MessageView.showMessage(message: "An unexpected error occurred", type: .failed)
            })
            .finally {
                self.stopAnimating()
        }
    }

    func setupVisuals() {
        self.view.backgroundColor = UIColor.white

        self.passwordTextView.backgroundColor = UIColor.lightGray
        self.usernameTextView.backgroundColor = UIColor.lightGray

        loginButton.backgroundColor = UIColor.black
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true

        createButton.backgroundColor = UIColor.black
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.layer.cornerRadius = 8
        createButton.clipsToBounds = true

        logoutButton.backgroundColor = UIColor.black
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 8
        logoutButton.clipsToBounds = true
    }
}

extension AuthenticationViewController {
    static func instantiate(authManager : AuthenticationManagerProtocol) -> AuthenticationViewController {
        let vc : AuthenticationViewController = UIStoryboard.instantiate(storyboard: "Authentication", identifier: "AuthenticationViewController")
        vc.authManager = authManager
        return vc
    }
}

