//
//  UIStoryboard+Instantiate.swift
//  SublimateUI
//
//    ___  ____
//   / __)(  _ \
//  ( (_ \ ) __/
//   \___/(__)   gabrielepalma.name
//

import UIKit

extension UIStoryboard {
    static public func instantiate<T: UIViewController>(storyboard: String, identifier : String = String(describing: T.self)) -> T {
        guard let result = UIStoryboard(name: storyboard, bundle: Bundle(for: T.self)).instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Fatal error when instantiating \(identifier) from storyboard \(storyboard).")
        }
        return result
    }
}
