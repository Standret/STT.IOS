//
//  SttComand.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

class SttComand {
    
    private var eventSubject = PublishSubject<Bool>()
    private var executeHandler: (() -> Void)
    private var canExecuteHandler: (() -> Bool)?
    
    private var isCalling = false
    
    var concurentExecute: Bool = false
    
    var singleCallEndCallback = true
    
    init<T: SttPresenterType> (delegate: T, handler: @escaping (T) -> Void, handlerCanExecute: ((T) -> Bool)? = nil) {
        executeHandler = { [weak delegate] in
            if let _delegate = delegate {
                handler(_delegate)
            }
        }
        canExecuteHandler = { [weak delegate, weak self] in
            if delegate != nil && handlerCanExecute != nil {
                if let _self = self {
                    return handlerCanExecute!(delegate!) && (_self.concurentExecute || !_self.isCalling)
                }
            }
            else if let _self = self {
                return (_self.concurentExecute || !_self.isCalling)
            }
            return true
        }
        isCalling = false
    }
    
    deinit {
        SttLog.trace(message: "Disposed", key: "SttCommand")
        eventSubject.dispose()
    }

    // TODO: Probably needed add call end on disposed
    func useWork(start: (() -> Void)?, end: (() -> Void)?) -> Disposable {
        
        return eventSubject.subscribe(onNext: { res in
            if res {
                start?()
            }
            else {
                end?()
            }
        })
    }
    
    func useWord(handler: @escaping (Bool) -> Void) -> Disposable {
        return eventSubject.subscribe(onNext: handler)
    }
    
    func execute() {
        if canExecute() {
            eventSubject.onNext(true)
            isCalling = true
            executeHandler()
        }
        else {
            SttLog.trace(message: "Command could not be execute. Can execute return: \(canExecute())", key: "SttComand")
        }
    }
    func canExecute() -> Bool {
        if let handler = canExecuteHandler {
            return handler()
        }
        return true
    }
    
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.singleCallEndCallback && self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        }, onError: { (error) in
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        }, onCompleted: {
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        })
    }
}

class SttComandWithParametr<TParametr> {
    
    private var eventSubject = PublishSubject<Bool>()
    private var executeHandler: ((TParametr) -> Void)
    private var canExecuteHandler: ((TParametr) -> Bool)?
    
    private var isCalling = false
    
    var concurentExecute: Bool = false
    
    var singleCallEndCallback = true
    
    init<T: SttPresenterType> (delegate: T, handler: @escaping (T, TParametr) -> Void, handlerCanExecute: ((T, TParametr) -> Bool)? = nil) {
        executeHandler = { [weak delegate] parametr in
            if let _delegate = delegate {
                handler(_delegate, parametr)
            }
        }
        canExecuteHandler = { [weak delegate, weak self] parametr in
            if delegate != nil && handlerCanExecute != nil {
                if let _self = self {
                    return handlerCanExecute!(delegate!, parametr) && (_self.concurentExecute || !_self.isCalling)
                }
            }
            else if let _self = self {
                return (_self.concurentExecute || !_self.isCalling)
            }
            return true
        }
        isCalling = false
    }
    
    deinit {
        SttLog.trace(message: "Disposed", key: "SttCommand")
        eventSubject.dispose()
    }
    
    // TODO: Probably needed add call end on disposed
    func useWork(start: (() -> Void)?, end: (() -> Void)?) -> Disposable {
        
        return eventSubject.subscribe(onNext: { res in
            if res {
                start?()
            }
            else {
                end?()
            }
        })
    }
    
    func useWord(handler: @escaping (Bool) -> Void) -> Disposable {
        return eventSubject.subscribe(onNext: handler)
    }
    
    func execute(parametr: TParametr) {
        if canExecute(parametr: parametr) {
            eventSubject.onNext(true)
            isCalling = true
            executeHandler(parametr)
        }
        else {
            SttLog.trace(message: "Command could not be execute. Can execute return with parametr \(parametr) return: \(canExecute(parametr: parametr))", key: "SttComand")
        }
    }
    func canExecute(parametr: TParametr) -> Bool {
        if let handler = canExecuteHandler {
            return handler(parametr)
        }
        return true
    }
    
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.singleCallEndCallback && self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        }, onError: { (error) in
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        }, onCompleted: {
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        })
    }
}
