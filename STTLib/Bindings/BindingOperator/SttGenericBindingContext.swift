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

/**
 An abstraction which can use for all possible bindings
 
 - REMARK:
 You should not create this class directly. Binding set create and provide it for you
 
 */
class SttGenericBindingContext<TViewController: AnyObject, TProperty>: SttBindingContextType {
    
    typealias PropertySetter = (_ vc: TViewController, _ property: TProperty) -> Void
    
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
    
    /**
     Add to context handler which call when dynamic property change
     
     - Parameter setter: Closure with 2 parameters property with safe point on view and new parametr
     
     ### Usage Example: ###
     ````
     set.bind(String.self).forProperty { $0.viewElement.property = $1 }
     
     ````
     */
    @discardableResult
    func forProperty(_ setter: @escaping PropertySetter) -> SttGenericBindingContext<TViewController, TProperty> {
        self.setter = setter
        
        return self
    }
    
    /**
     Add to context Dynamic property for handler
     
     ### Usage Example: ###
     ````
     set.bind(String.self).forProperty { $0.viewElement.property = $1 }
        .to(dynamicProperty)
     
     ````
    */
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
    
    /**
     Add to context binding mode
     
     - Important:
     By default use bind mode so you should not call this method in most of cases
     
     ### Usage Example: ###
     ````
     set.bind(String.self).forProperty { $0.viewElement.property = $1 }
     .to(dynamicProperty)
     .withMode(.listener)
     
     ````
     */
    @discardableResult
    func withMode(_ mode: SttBindMode) -> SttGenericBindingContext<TViewController, TProperty> {
        self.bindMode = mode
        
        return self
    }
    
    /**
     Add to context converter
     
     - Important:
     
     Type on binding function and result of converter have to have the same type.
     
     Also, the type of dynamic property and type of converter's parameter have to have the same type.
     
     Otherwise program throw faralError
     
     ### Usage Example: ###
     ````
     set.bind(String.self).forProperty { $0.viewElement.property = $1 }
     .to(dynamicProperty)
     .withConverter(Converter.self)
     
     ````
     */
    @discardableResult
    func withConverter<T: SttConverterType>(_ _: T.Type) -> SttGenericBindingContext<TViewController, TProperty> {
        self.converter = T()

        return self
    }
    
    /**
     Add to context parameters. By default use as converter's parameter
     
     - This parametr pass as
     
     ### Usage Example: ###
     ````
     set.bind(String.self).forProperty { $0.viewElement.property = $1 }
     .to(dynamicProperty)
     .withConverter(Converter.self)
     .withCommandParametr(2319)
     
     ````
     */
    @discardableResult
    func withCommandParametr(_ parametr: Any) -> SttGenericBindingContext<TViewController, TProperty> {
        self.parametr = parametr
        
        return self
    }
    
    /**
     apply binding context
     
     ## IMPORTANT ##
     
     Do not call this method directly!
     Binding set call this method for you
     
    */
    func apply() {
        
        lazyApply()
    }
    
    deinit {
        lazyDispose()
    }
}

// MARK: - custom operator

/**
 
 Custom operators
 Second way to write bindings
 
 For more information look at our documentation on github
 
 UPS :\ Something missing
 If you see this message just write me. Prter Standret
 
 */

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
