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
    
    private var handlerStart = [(() -> Void)]()
    private var handlerEnd = [(() -> Void)]()
    private var executeHandler: (() -> Void)
    private var canExecuteHandler: (() -> Bool)?
    
    var concurentExecute: Bool = false
    
    var singleCallEndCallback = true
    private var isCalling = false
    
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

    func addHandler(start: (() -> Void)?, end: (() -> Void)?) {
        if let _start = start {
            handlerStart.append(_start)
        }
        if let _end = end {
            handlerEnd.append(_end)
        }
    }
    
    func execute() {
        if canExecute() {
            for ihand in handlerStart {
                ihand()
            }
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
}

extension SttComand {
    func useWork<T>(observable: Observable<T>) -> Observable<T> {
        return observable.do(onNext: { (element) in
            if self.singleCallEndCallback && self.isCalling {
                for iend in self.handlerEnd {
                    iend()
                }
                self.isCalling = false
            }
        }, onError: { (error) in
            if self.isCalling {
                for iend in self.handlerEnd {
                    iend()
                }
                self.isCalling = false
            }
        }, onCompleted: {
            if self.isCalling {
                for iend in self.handlerEnd {
                    iend()
                }
                self.isCalling = false
            }
        })
    }
}

