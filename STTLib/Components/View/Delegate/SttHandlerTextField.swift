//
//  TextField.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

enum TypeActionTextField {
    case shouldReturn
    case didEndEditing, didStartEditing
    case editing
}

class SttHandlerTextField: NSObject, UITextFieldDelegate {
    
    // private property
    private var handlers = [TypeActionTextField: [(UITextField) -> Void]]()
    
    // method for add target
    
    func addTarget<T: SttViewable>(type: TypeActionTextField, delegate: T, handler: @escaping (T, UITextField) -> Void, textField: UITextField) {
        switch type {
        case .editing:
            textField.addTarget(self, action: #selector(changing), for: .editingChanged)
        default: break
        }
        handlers[type] = handlers[type] ?? [(UITextField) -> Void]()
        handlers[type]!.append { [weak delegate] tf in
            if let _delegate = delegate {
                handler(_delegate, tf)
            }
        }
    }
    
    @objc func changing(_ textField: UITextField) {
        handlers[.editing]?.forEach({ $0(textField) })
    }
    
    // implementation of protocol UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlers[.shouldReturn]?.forEach({ $0(textField) })
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        handlers[.didEndEditing]?.forEach({ $0(textField) })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        handlers[.didStartEditing]?.forEach({ $0(textField) })
    }
}


