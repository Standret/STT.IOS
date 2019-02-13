//
//  UILabel.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SttTextFieldBindingContext<TViewController: AnyObject>: SttGenericBindingContext<TViewController, String?> {
    
    private let handler: SttHandlerTextField
    private var bindingMode: SttBindingMode = .twoWayBind
    private var forProperty: SttTypeActionTextField?
    private var lazyWriterApply: ((String?) -> Void)!
    
    private var command: SttCommandType!
    
    weak private var target: Dynamic<String?>!
    unowned private var textField: UITextField
    
    init (viewController: TViewController, handler: SttHandlerTextField, textField: UITextField) {
        self.handler = handler
        self.textField = textField
        
        super.init(vc: viewController)
    }
    
    // MARK: - to
    
    @discardableResult
    override func to<TValue>(_ value: Dynamic<TValue>) -> SttGenericBindingContext<TViewController, String?> {
        lazyWriterApply = { value.value = $0 as! TValue }
        return super.to(value)
    }
    
    @discardableResult
    func to(_ value: SttCommandType) -> SttTextFieldBindingContext {
        self.command = value
        
        return self
    }
    
    // MARK: - forTarget
    
    @discardableResult
    func forTarget(_ value: SttTypeActionTextField) -> SttTextFieldBindingContext {
        self.forProperty = value
        
        return self
    }
    
    // MARK: - mutator

    @discardableResult
    func withMode(_ mode: SttBindingMode) -> SttTextFieldBindingContext {
        self.bindingMode = mode
        
        return self
    }

    // MARK: - applier
    
    override func apply() {

        if let forProperty = forProperty, forProperty != .editing {
            bindSpecial()
        }
        else {
            bindEditing()
        }
    }
    
    deinit {
        print("TextField Set deinit")
    }
    
    private func bindSpecial() {
        handler.addTarget(type: forProperty!, delegate: self,
                          handler: { (d,_) in d.command.execute(parametr: d.parametr) })

    }

    private func bindEditing() {
        switch bindingMode {
        case .write, .twoWayListener, .twoWayBind:
            handler.addTarget(type: SttTypeActionTextField.editing, delegate: self,
                              handler: {
                                let value = $0.converter != nil ? $0.converter?.convertBack(value: $1.text, parametr: $0.parametr) : $1.text
                                if let cvalue = value as? String {
                                    $0.lazyWriterApply(cvalue)
                                }
                                else {
                                    fatalError("Incorrect type, expected String?")
                                }
            }, textField: textField)
        default: break
        }

        switch bindingMode {

        case .readListener, .twoWayListener:
            withMode(.listener)
            super.apply()
        case .readBind, .twoWayBind:
            withMode(.bind)
            super.apply()
        default: break
        }
    }
}

// MARK: - custom operator

@discardableResult
func => <TViewController>(left: SttTextFieldBindingContext<TViewController>,
                                      right: SttTypeActionTextField) -> SttTextFieldBindingContext<TViewController> {
    return left.forTarget(right)
}

@discardableResult
func ->> <TViewController>(left: SttTextFieldBindingContext<TViewController>,
                                       right: Dynamic<String?>) -> SttGenericBindingContext<TViewController, String?> {
    return left.withMode(.write).to(right)
}

@discardableResult
func ->> <TViewController>(left: SttTextFieldBindingContext<TViewController>,
                                       right: SttCommandType) -> SttTextFieldBindingContext<TViewController> {
    return left.to(right)
}

@discardableResult
func <->> <TViewController>(left: SttTextFieldBindingContext<TViewController>,
                                        right: Dynamic<String?>) -> SttGenericBindingContext<TViewController, String?> {
    return left.withMode(.twoWayListener).to(right)
}

@discardableResult
func <<->> <TViewController>(left: SttTextFieldBindingContext<TViewController>,
                                         right: Dynamic<String?>) -> SttGenericBindingContext<TViewController, String?> {
    return left.withMode(.twoWayBind).to(right)
}
