//
//  PrivateVariable.swift
//  SublimateClient
//
//  Created by i335287 on 07/11/2018.
//  Copyright © 2018 Gabriele. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class ReadOnlyBehaviorRelay<T> {
    private var relay: BehaviorRelay<T>
    public var value: T {
        return relay.value
    }

    public init(of relay: BehaviorRelay<T>) {
        self.relay = relay
    }

    public func asObservable() -> Observable<T> {
        return relay.asObservable()
    }
}

public extension BehaviorRelay {
    public func asReadOnly() -> ReadOnlyBehaviorRelay<Element> {
        return ReadOnlyBehaviorRelay(of: self)
    }
}
