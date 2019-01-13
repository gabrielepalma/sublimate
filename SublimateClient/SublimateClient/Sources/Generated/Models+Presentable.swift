// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RxSwift
import SublimateUI

extension DemoAlphaObject : OverviewPresentable {
    var presentationId: String? {
        return remoteId
    }

    var presentationTitle: String? {
        return text
    }

    var presentationThumbnail: Observable<UIImage?> {
        return Observable.just(nil)
    }
}

extension DemoAlphaObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<DemoAlphaObject>)] {
        return [
            ("text", \DemoAlphaObject.text), 
            ("count", \DemoAlphaObject.count)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<DemoAlphaObject>)] {
        return [
            ("localId", \DemoAlphaObject.localId),
            ("remoteId", \DemoAlphaObject.remoteId),
            ("clientCreated", \DemoAlphaObject.clientCreatedDate),
            ("clientLastUpdated", \DemoAlphaObject.clientLastUpdatedDate),
            ("syncOperation", \DemoAlphaObject.syncOperation)
        ]
    }
}

extension DemoBetaObject : OverviewPresentable {
    var presentationId: String? {
        return remoteId
    }

    var presentationTitle: String? {
        return name
    }

    var presentationThumbnail: Observable<UIImage?> {
        return Observable.just(nil)
    }
}

extension DemoBetaObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<DemoBetaObject>)] {
        return [
            ("name", \DemoBetaObject.name), 
            ("surname", \DemoBetaObject.surname)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<DemoBetaObject>)] {
        return [
            ("localId", \DemoBetaObject.localId),
            ("remoteId", \DemoBetaObject.remoteId),
            ("clientCreated", \DemoBetaObject.clientCreatedDate),
            ("clientLastUpdated", \DemoBetaObject.clientLastUpdatedDate),
            ("syncOperation", \DemoBetaObject.syncOperation)
        ]
    }
}


func sublimateTableSources() -> [TableSource] {
    var sources = [TableSource]()
    var temp : TableSource

    temp = TableSource()
    temp.availability = .openAccess
    temp.description = "DemoAlpha"
    temp.viewController = {
        let vc = ObjectsTableViewController<DemoAlphaObject>()
        vc.syncer = DI.demoAlphaSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)
    temp = TableSource()
    temp.availability = .onlyAuthenthicated
    temp.description = "DemoBeta"
    temp.viewController = {
        let vc = ObjectsTableViewController<DemoBetaObject>()
        vc.syncer = DI.demoBetaSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)

    return sources
}
