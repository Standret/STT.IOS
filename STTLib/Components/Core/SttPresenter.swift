//
//  SttPresenter.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SttPresenterType: class {
    func prepare(parametr: Any?)
}

class SttPresenter<TDelegate> : SttViewInjector, SttPresenterType {
    
    private weak var _delegate: SttViewable!
    private var _notificationError: SttNotificationErrorServiceType?
    
    var delegate: TDelegate { return _delegate as! TDelegate }
    
    init(notificationError: SttNotificationErrorServiceType?) {
        _notificationError = notificationError
    }
    
    func injectView(delegate: SttViewable) {
        self._delegate = delegate
        
        _ = _notificationError?.errorObservable
            .observeInUI()
            .subscribe(onNext: { [weak self] (err) in
            if (self?._delegate is SttViewableListener) {
                (self!._delegate as! SttViewableListener).sendError(error: err)
            }
        })
        viewDidInjected()
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
