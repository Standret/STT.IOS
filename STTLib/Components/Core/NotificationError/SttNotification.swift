
//
//  SttNotification.swift
//  OVS
//
//  Created by Peter Standret on 2/28/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

class SttNotificationErrorService: SttNotificationErrorServiceType {
    
    let subject = PublishSubject<SttBaseError>()
    
    var errorObservable: Observable<SttBaseError> { return subject }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T> {
        return observable.do(onError: { (error) in
            if let er = error as? SttBaseError {
                self.subject.onNext(er)
            }
            else {
                self.subject.onNext(SttBaseError.unkown("\(error)"))
            }
        })
    }
}
