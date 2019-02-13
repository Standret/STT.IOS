//
//  GenericBindingContext.swift
//  OVS
//
//  Created by Peter Standret on 2/8/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

enum SttBindMode {
    case listener
    case bind
}

class SttGenericBindingContext<TViewController: AnyObject, TProperty>: SttBindingContextType {
    
    typealias PropertySetter = (TViewController, TProperty) -> Void
    
    private var lazyApply: (() -> Void)!
    private var lazyDispose: (() -> Void)!
    
    private(set) var setter: PropertySetter!
    private(set) var parametr: Any?
    
    private(set) var bindMode = SttBindMode.bind

    private(set) var converter: SttConverterType?

    unowned let vc: TViewController
    
    init (vc: TViewController) {
        self.vc = vc
    }
    
    @discardableResult
    func forProperty(_ setter: @escaping PropertySetter) -> SttGenericBindingContext<TViewController, TProperty> {
        self.setter = setter
        
        return self
    }
    
    @discardableResult
    func to<TValue>(_ value: Dynamic<TValue>) -> SttGenericBindingContext<TViewController, TProperty> {
        
        lazyApply = { [unowned self] in
            if self.bindMode == .bind {
                value.bind { [unowned self] in
                    let value = self.converter != nil ? self.converter?.convert(value: $0, parametr: self.parametr) : $0
                    self.setter(self.vc, value as! TProperty)
                }
            }
            else {
                value.addListener { [unowned self] in
                    let value = self.converter != nil ? self.converter?.convert(value: $0, parametr: self.parametr) : $0
                    self.setter(self.vc, value as! TProperty)
                }
            }
        }
        
        lazyDispose = { value.dispose() }
        
        return self
    }
    
    @discardableResult
    func withMode(_ mode: SttBindMode) -> SttGenericBindingContext<TViewController, TProperty> {
        self.bindMode = mode
        
        return self
    }
    
    @discardableResult
    func withConverter<T: SttConverterType>(_ _: T.Type) -> SttGenericBindingContext<TViewController, TProperty> {
        self.converter = T()

        return self
    }
    
    @discardableResult
    func withCommandParametr(_ parametr: Any) -> SttGenericBindingContext<TViewController, TProperty> {
        self.parametr = parametr
        
        return self
    }
    
    func apply() {
        
        lazyApply()
    }
    
    deinit {
        lazyDispose()
        print("Generic binding deinit")
    }
}

// MARK: - custom operator

@discardableResult
func => <TViewController, TProperty>(left: SttGenericBindingContext<TViewController, TProperty>,
                                                 right: @escaping (TViewController, TProperty) -> Void) -> SttGenericBindingContext<TViewController, TProperty> {
    return left.forProperty(right)
}

@discardableResult
func <- <TViewController, TProperty, TTarget>(left: SttGenericBindingContext<TViewController, TProperty>,
                                                 right: Dynamic<TTarget>) -> SttGenericBindingContext<TViewController, TProperty> {
    return left.to(right).withMode(.listener)
}

@discardableResult
func <<- <TViewController, TProperty, TTarget>(left: SttGenericBindingContext<TViewController, TProperty>,
                                                  right: Dynamic<TTarget>) -> SttGenericBindingContext<TViewController, TProperty> {
    return left.to(right).withMode(.bind)
}

@discardableResult
func >-< <TViewController, TProperty, T: SttConverterType>(left: SttGenericBindingContext<TViewController, TProperty>,
                                                                       right: T.Type) -> SttGenericBindingContext<TViewController, TProperty> {
    return left.withConverter(T.self)
}

@discardableResult
func -< <TViewController, TProperty>(left: SttGenericBindingContext<TViewController, TProperty> ,
                                                 right: Any) -> SttGenericBindingContext<TViewController, TProperty> {
    return left.withCommandParametr(right)
}
