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

class SttNotificationErrorService: SttNotificationErrorServiceType {
    
    let subject = PublishSubject<SttBaseError>()
    
    var errorObservable: Observable<SttBaseError> { return subject }
    
    func useError<T>(observable: Observable<T>, ignoreBadRequest: Bool) -> Observable<T> {
        return observable.do(onError: { error in
            if let er = error as? SttBaseError {
                var flag = true
                if ignoreBadRequest {
                    switch er {
                    case .apiError(let api):
                        switch api {
                        case .badRequest( _):
                            flag = false
                        case .otherApiError(let code):
                            if code == 401 {
                                flag = false
                            }
                        default: break
                        }
                    default: break
                    }
                }
                if flag {
                    self.subject.onNext(er)
                }
            }
            else {
                self.subject.onNext(SttBaseError.unkown("\(error.localizedDescription)"))
            }
        })
    }
}
