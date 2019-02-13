//
//  TextField.swift
//  SttDictionary
//
//  Created by Standret on 5/19/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

enum SttTypeActionTextField {
    case shouldReturn
    case didEndEditing, didStartEditing
    case editing
}

class SttHandlerTextField: NSObject, UITextFieldDelegate {
    
    // private property
    private var handlers = [SttTypeActionTextField: [SttDelegatedCall<UITextField>]]()
    
    // method for add target
    
    func addTarget<T: AnyObject>(type: SttTypeActionTextField, delegate: T, handler: @escaping (T, UITextField) -> Void, textField: UITextField? = nil) {
        switch type {
        case .editing:
            textField!.addTarget(self, action: #selector(changing), for: .editingChanged)
        default: break
        }
        handlers[type] = handlers[type] ?? [SttDelegatedCall<UITextField>]()
        handlers[type]!.append(SttDelegatedCall<UITextField>(to: delegate, with: handler))
    }
    
    @objc func changing(_ textField: UITextField) {
        handlers[.editing]?.forEach({ $0.callback(textField) })
    }
    
    // implementation of protocol UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlers[.shouldReturn]?.forEach({ $0.callback(textField) })
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        handlers[.didEndEditing]?.forEach({ $0.callback(textField) })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        handlers[.didStartEditing]?.forEach({ $0.callback(textField) })
    }
}


