//
//  ActionPanelViewController.swift
//  SublimateUI
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
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

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var randomButton: UIButton!

    public var deleteButtonTitle = "Delete"
    public var randomButtonTitle = "Randomize"
    public var cancelButtonTitle = "Cancel"

    public var cancelButtonCallBack: (() -> ())?
    public var deleteButtonCallBack: (() -> ())?
    public var randomButtonCallBack: (() -> ())?

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupVisuals()
    }

    func setupVisuals() {
        cancelButton.backgroundColor = UIColor.black
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.layer.cornerRadius = 10.0
        deleteButton.backgroundColor = UIColor.red
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.setTitle(deleteButtonTitle, for: .normal)
        deleteButton.layer.cornerRadius = 10.0
        randomButton.backgroundColor = UIColor.darkGray
        randomButton.setTitleColor(UIColor.white, for: .normal)
        randomButton.setTitle(randomButtonTitle, for: .normal)
        randomButton.layer.cornerRadius = 10.0
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
