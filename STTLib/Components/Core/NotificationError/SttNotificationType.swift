//
//  SttNotificationType.swift
//  Lemon
//
//  Created by Standret on 12/4/18.
//  Copyright © 2018 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

protocol SttNotificationErrorServiceType: class {
    var errorObservable: Observable<SttBaseError> { get }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T>
}

extension SttNotificationErrorServiceType {
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool = false) -> Observable<T> {
        return self.useError(observable: observable, ignoreBadRequest: ignoreBadRequest)
    }
}

extension Observable {
    
    func useError(service: SttNotificationErrorServiceType, ignoreBadRequest: Bool = false) -> Observable<E> {
        return service.useError(observable: self, ignoreBadRequest: ignoreBadRequest)
    }
}
