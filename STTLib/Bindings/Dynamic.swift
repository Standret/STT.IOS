//
//  Dynamic.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

/**
 A dynamic property which inform subscribers about value changing
 */
class Dynamic<Element> {
    
    typealias Listener = (Element) -> Void
    
    private var disposeBag = DisposeBag()
    private var element: Variable<Element>
    
    var value: Element {
        get { return element.value }
        set {
            element.value = newValue
        }
    }
    
    init(_ value: Element) {
        element = Variable<Element>(value)
    }
    
    /// Subscribe on changes and read current value
    func bind(_ listener: @escaping Listener) {
        element.asObservable()
            .subscribe(onNext: listener)
            .disposed(by: disposeBag)
        
        listener(element.value)
    }
    
    /// Subscribe only on changes
    func addListener(_ listener: @escaping Listener) {
        element.asObservable()
            .subscribe(onNext: listener)
            .disposed(by: disposeBag)
    }
    
    func dispose() {
        disposeBag = DisposeBag()
    }
}
