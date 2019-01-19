// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable vertical_whitespace

import UIKit
import RxSwift
import SublimateUI

extension PeopleObject : OverviewPresentable {
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

extension PeopleObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<PeopleObject>)] {
        return [
            ("name", \PeopleObject.name), 
            ("surname", \PeopleObject.surname), 
            ("email", \PeopleObject.email), 
            ("age", \PeopleObject.age), 
            ("weight", \PeopleObject.weight)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<PeopleObject>)] {
        return [
            ("localId", \PeopleObject.localId),
            ("remoteId", \PeopleObject.remoteId),
            ("clientCreated", \PeopleObject.clientCreatedDate),
            ("clientLastUpdated", \PeopleObject.clientLastUpdatedDate),
            ("syncOperation", \PeopleObject.syncOperation)
        ]
    }
}

extension SpeechesObject : OverviewPresentable {
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

extension SpeechesObject : DetailPresentable {
    var presentationKeyPaths : [(String, PartialKeyPath<SpeechesObject>)] {
        return [
            ("title", \SpeechesObject.title), 
            ("content", \SpeechesObject.content), 
            ("duration", \SpeechesObject.duration), 
            ("grade", \SpeechesObject.grade)
        ]
    }

    var metadataKeyPaths : [(String, PartialKeyPath<SpeechesObject>)] {
        return [
            ("localId", \SpeechesObject.localId),
            ("remoteId", \SpeechesObject.remoteId),
            ("clientCreated", \SpeechesObject.clientCreatedDate),
            ("clientLastUpdated", \SpeechesObject.clientLastUpdatedDate),
            ("syncOperation", \SpeechesObject.syncOperation)
        ]
    }
}


func sublimateTableSources() -> [TableSource] {
    var sources = [TableSource]()
    var temp : TableSource

    temp = TableSource()
    temp.availability = .openAccess
    temp.description = "People"
    temp.viewController = {
        let vc = ObjectsTableViewController<PeopleObject>()
        vc.syncer = DI.peopleSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)
    temp = TableSource()
    temp.availability = .onlyAuthenthicated
    temp.description = "Speeches"
    temp.viewController = {
        let vc = ObjectsTableViewController<SpeechesObject>()
        vc.syncer = DI.speechesSyncer
        vc.realmConfiguration = DI.realmConfiguration
        return vc
    }
    sources.append(temp)

    return sources
}
