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
    
    // implements protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handlers = handlers[.shouldReturn]  {
            for ihandler in handlers {
                ihandler(textField)
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let handlers = handlers[.didEndEditing]  {
            for ihandler in handlers {
                ihandler(textField)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let handlers = handlers[.didStartEditing]  {
            for ihandler in handlers {
                ihandler(textField)
            }
        }
    }
    
    @objc func changing(_ textField: UITextField) {
        if let handlers = handlers[.editing]  {
            for ihandler in handlers {
                ihandler(textField)
            }
        }
    }
    
    override init () {
        print ("init text handler")
    }
    
    deinit {
        print("Stt hnalder text filed deinit")
    }
}


