//
//  SttPresenter.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Updated to v2 on 1/12/19.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SttPresenterType: AnyObject {
    func prepare(parametr: Any?)
}

class SttPresenter<TDelegate> : SttViewControllerInjector {
    
    private weak var _delegate: SttViewable!
    private var _notificationError: SttNotificationErrorServiceType?
    private var messageDisposable: Disposable?
    
    var delegate: TDelegate { return _delegate as! TDelegate }
    
    init(notificationError: SttNotificationErrorServiceType?) {
        _notificationError = notificationError
    }
    
    func injectView(delegate: SttViewable) {
        self._delegate = delegate
        
        viewDidInjected()
    }
    
    func viewAppearing() { }
    func viewAppeared() {
        messageDisposable = _notificationError?.errorObservable
            .observeInUI()
            .subscribe(onNext: { [unowned self] (err) in
                if (self._delegate is SttViewableListener) {
                    (self._delegate as! SttViewableListener).sendError(error: err)
                }
            })
    }
    
    func viewDissapearing() { }
    func viewDissapeared() {
        messageDisposable?.dispose()
    }
    
    func viewDidInjected() { }
    
    func prepare(parametr: Any?) { }
}

class SttPresenterWithParametr<TDelegate, TParametr>: SttPresenter<TDelegate> {
    
    override func prepare(parametr: Any?) {
        prepare(parametr: parametr as! TParametr)
    }
    
    func prepare(parametr: TParametr)  { }
}
