//
//  SttBindingSet.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

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
    
    func bind<T>(_ context: T.Type) -> SttGenericBindingContext<TViewController, T> {
        
        let set = SttGenericBindingContext<TViewController, T>(vc: parent)
        sets.append(set)
        return set
    }
    
    func apply() {
        sets.forEach({ $0.apply() })
    }
    
    deinit {
        print("Binding set deinit")
    }
}
