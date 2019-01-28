// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RxSwift
import SublimateUI

extension DemoPrivateObject : OverviewPresentable {
    var presentationId: String? {
        return remoteId
    }

    var presentationTitle: String? {
        return title
    }

    var presentationThumbnail: Observable<UIImage?> {
        return Observable.just(nil)
    }
}

extension DemoPrivateObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<DemoPrivateObject>)] {
        return [
            ("title", \DemoPrivateObject.title), 
            ("content", \DemoPrivateObject.content), 
            ("duration", \DemoPrivateObject.duration), 
            ("grade", \DemoPrivateObject.grade)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<DemoPrivateObject>)] {
        return [
            ("localId", \DemoPrivateObject.localId),
            ("remoteId", \DemoPrivateObject.remoteId),
            ("remoteCreated", \DemoPrivateObject.remoteCreatedDate),
            ("clientCreated", \DemoPrivateObject.clientCreatedDate),
            ("clientLastUpdated", \DemoPrivateObject.clientLastUpdatedDate),
            ("syncOperation", \DemoPrivateObject.syncOperation)
        ]
    }
}

extension DemoPublicObject : OverviewPresentable {
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

extension DemoPublicObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<DemoPublicObject>)] {
        return [
            ("name", \DemoPublicObject.name), 
            ("surname", \DemoPublicObject.surname), 
            ("email", \DemoPublicObject.email), 
            ("age", \DemoPublicObject.age), 
            ("weight", \DemoPublicObject.weight)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<DemoPublicObject>)] {
        return [
            ("localId", \DemoPublicObject.localId),
            ("remoteId", \DemoPublicObject.remoteId),
            ("remoteCreated", \DemoPublicObject.remoteCreatedDate),
            ("clientCreated", \DemoPublicObject.clientCreatedDate),
            ("clientLastUpdated", \DemoPublicObject.clientLastUpdatedDate),
            ("syncOperation", \DemoPublicObject.syncOperation)
        ]
    }
}


func sublimateTableSources() -> [TableSource] {
    var sources = [TableSource]()
    var temp : TableSource

    temp = TableSource()
    temp.availability = .onlyAuthenthicated
    temp.description = "DemoPrivate"
    temp.viewController = {
        let vc = ObjectsTableViewController<DemoPrivateObject>()
        vc.syncer = DI.demoPrivateSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)
    temp = TableSource()
    temp.availability = .openAccess
    temp.description = "DemoPublic"
    temp.viewController = {
        let vc = ObjectsTableViewController<DemoPublicObject>()
        vc.syncer = DI.demoPublicSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)

    return sources
}
