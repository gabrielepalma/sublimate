//
//  SublimateMessageView.swift
//  SublimateClient
//
//  Created by i335287 on 08/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
//

import UIKit
import SwiftMessages
import RxSwift
import RxReachability
import Reachability

extension MessageView {

    enum SublimateMessageIcon: String {
        case offline = "😢"
        case online = "🙂"
        case success = "👍"
        case failed = "👎"
        case loggedOut = "🔐"
        case loggedIn = "🔑"
    }

    static func showMessage(message : String, type: SublimateMessageIcon) {

        let view = MessageView.viewFromNib(layout: .cardView)

        view.configureTheme(.info)
        view.configureDropShadow()
        view.button?.isHidden = true

        view.configureContent(title: "", body: message, iconText: type.rawValue)
        view.layoutMarginAdditions = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(view: view)
    }

    static func showOnline() {
        showMessage(message: "Heya! You are online again!", type: .online)
    }

    static func showOffline() {
        showMessage(message: "Oh no! You went offline!", type: .offline)
    }

    static func showLoggedIn() {
        showMessage(message: "You successfully logged in", type: .loggedIn)
    }

    static func showRefreshedToken() {
        showMessage(message: "You successfully refreshed your access token", type: .loggedIn)
    }

    static func showLoggedOut() {
        showMessage(message: "You have been logged out", type: .loggedOut)
    }
}
