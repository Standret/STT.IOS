//
//  SttComand.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

protocol SttCommandType: AnyObject {
    
    var observableCanNext: Observable<Bool> { get }
    
    func execute(parametr: Any?)
    func canExecute(parametr: Any?) -> Bool
    
    func raiseCanExecute(parametr: Any?)

    func useWork(start: (() -> Void)?, end: (() -> Void)?) -> Disposable
    func useWork(handler: @escaping (Bool) -> Void) -> Disposable
    
    func useWork<T>(observable: Observable<T>) -> Observable<T>
}

extension SttCommandType {
    func raiseCanExecute(parametr: Any? = nil) {
        self.raiseCanExecute(parametr: parametr)
    }
}

class SttCommand: SttCommandType {
    
    private var canNextSubject = PublishSubject<Bool>()
    private var eventSubject = PublishSubject<Bool>()
    private var executeHandler: (() -> Void)
    private var canExecuteHandler: (() -> Bool)?
    
    var observableCanNext: Observable<Bool> { return canNextSubject }
    
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
        canNextSubject.dispose()
        eventSubject.dispose()
    }
    
    func execute(parametr: Any?) {
        self.execute()
    }
    func canExecute(parametr: Any?) -> Bool {
        return self.canExecute()
    }
    
    func raiseCanExecute(parametr: Any?) {
        canNextSubject.onNext(canExecute())
    }
    
    func execute() {
        if canExecute() {
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
    func useWork(handler: @escaping (Bool) -> Void) -> Disposable {
        return eventSubject.subscribe(onNext: handler)
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
        }, onSubscribed: {
            self.eventSubject.onNext(true)
            self.isCalling = true
        }, onDispose: {
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        })
    }
}

class SttComandWithParametr<TParametr>: SttCommandType {
    
    private var canNextSubject = PublishSubject<Bool>()
    private var eventSubject = PublishSubject<Bool>()
    private var executeHandler: ((TParametr) -> Void)
    private var canExecuteHandler: ((TParametr) -> Bool)?
    
    private var isCalling = false
    
    var observableCanNext: Observable<Bool> { return canNextSubject }
    
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
        canNextSubject.dispose()
        eventSubject.dispose()
    }
    
    func execute(parametr: Any?) {
        self.execute(parametr: parametr as! TParametr)
    }
    func canExecute(parametr: Any?) -> Bool {
        return self.canExecute(parametr: parametr as! TParametr)
    }
    
    func raiseCanExecute(parametr: Any?) {
        canNextSubject.onNext(canExecute(parametr: parametr))
    }
    
    func execute(parametr: TParametr) {
        if canExecute(parametr: parametr) {
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

    func useWork(handler: @escaping (Bool) -> Void) -> Disposable {
        return eventSubject.subscribe(onNext: handler)
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
        }, onSubscribed: {
            if !self.isCalling {
                self.eventSubject.onNext(true)
                self.isCalling = true
            }
        }, onDispose: {
            if self.isCalling {
                self.eventSubject.onNext(false)
                self.isCalling = false
            }
        })
    }
}
