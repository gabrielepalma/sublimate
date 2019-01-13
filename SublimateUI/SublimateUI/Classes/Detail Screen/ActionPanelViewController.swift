//
//  ActionPanelViewController.swift
//  SublimateClient
//
//  Created by i335287 on 08/01/2019.
//  Copyright © 2019 Gabriele. All rights reserved.
//

import UIKit
import SwiftMessages

class ActionPanelSegue: SwiftMessagesSegue {
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomCard)
        dimMode = .blur(style: .dark, alpha: 0.9, interactive: true)
        messageView.configureNoDropShadow()
    }
}

public class ActionPanelViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!

    var cancelButtonCallBack: (() -> ())?
    var deleteButtonCallBack: (() -> ())?
    var randomButtonCallBack: (() -> ())?

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupVisuals() {
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        randomButton.backgroundColor = UIColor.darkGray
        randomButton.setTitleColor(UIColor.white, for: .normal)

    }

    @IBAction func cancelButtonTapped() {
        if let cancelButtonCallBack = cancelButtonCallBack {
            cancelButtonCallBack()
        }
    }

    @IBAction func deleteButtonTapped() {
        if let deleteButtonCallBack = deleteButtonCallBack {
            deleteButtonCallBack()
        }
    }

    @IBAction func randomButtonTapped() {
        if let randomButtonCallBack = randomButtonCallBack {
            randomButtonCallBack()
        }
    }
}
