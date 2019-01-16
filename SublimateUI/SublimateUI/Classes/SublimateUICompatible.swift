//
//  SublimateUICompatible.swift
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

public typealias SublimateUICompatible = DetailPresentable & OverviewPresentable & Randomizable & Syncable

public protocol OverviewPresentable {
    var presentationId : String? { get }
    var presentationTitle : String? { get }
    var presentationThumbnail : Observable<UIImage?> { get }
}

public protocol DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<Self>)] { get }
    var metadataKeyPaths : [(String, PartialKeyPath<Self>)] { get }
}

public protocol Randomizable {
    func randomize()
}

public struct TableSource {
    public init() {
    }

    public enum Availability {
        case onlyAuthenthicated
        case openAccess
    }

    public var description : String = ""
    public var availability : Availability = .openAccess
    public var viewController : () -> (UIViewController) = {
        return UIViewController()
    }
}
