//
//  SttBindingSet.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 standret. All rights reserved.
//

import Foundation
import UIKit

/**
 An abstraction of binding context. Give a target object with method for target binding elements on view,
 provide in target clouser safe property to target view controller.
 When all elements were binded user have to call aplly to accept all bindings.
 
 ### Usage Example: ###
 ````
 var set = SttBindingSet(parent: self)
 
 // all binding here
 
 set.apply()
 
 ````
 */
class SttBindingSet<TViewController: AnyObject> {
    
    private unowned var parent: TViewController
    
    private var sets = [SttBindingContextType]()
    
    init (parent: TViewController) {
        self.parent = parent
    }
    
    func bind(_ label: UILabel) -> SttLabelBindingContext<TViewController> {
        
        let set = SttLabelBindingContext(viewController: parent, label: label)
        
        set.forProperty { (_,value) in label.text = value }
        sets.append(set)
        
        return set
    }
    
    /**
     Use for text field (one way and two way bindings)
     
     - Important:
     property delegate in target textfield have to be empty or have type **SttHandlerTextField**
     otherwise this method throw fatalError()
     
     */
    func bind(_ textField: UITextField) -> SttTextFieldBindingContext<TViewController> {
        
        var data: (SttHandlerTextField, UITextField)!
        
        if let handler = textField.delegate as? SttHandlerTextField {
            data = (handler, textField)
        }
        else if textField.delegate != nil {
            fatalError("Incorrect delegate in TextField. Expected type nil or SttHandlerTextField")
        }
        else {
            let handler = SttHandlerTextField()
            textField.delegate = handler

            data = (handler, textField)
        }
        
        let set = SttTextFieldBindingContext<TViewController>(viewController: parent, handler: data.0, textField: data.1)
        sets.append(set)
        
        return set
    }
    
    func bind(_ button: UIButton) -> SttButtonBindingSet {
        
        let set = SttButtonBindingSet(button: button)
        sets.append(set)
        return set
    }
    
    /**
     Use for abstract binding.
     
     - REMARK:
     It is reccomend to use only if there are not any **specific** bindings.
     
     - PARAMETER context: Target type which you expect to assign in binding cloisure
     
     ### Usage Example: ###
     ````
     set.bind(TargetType.self)
     
     ````
    */
    func bind<T>(_ context: T.Type) -> SttGenericBindingContext<TViewController, T> {
        
        let set = SttGenericBindingContext<TViewController, T>(vc: parent)
        sets.append(set)
        return set
    }
    
    /// apply all bindings setted in set
    func apply() {
        sets.forEach({ $0.apply() })
    }
}
