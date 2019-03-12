//
//  TextFieldHandlerValidator.swift
//  OVS
//
//  Created by Peter Standret on 2/14/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

class SttTextFieldHandlerValidator {
    
    var useAgent = true
    
    init<T: SttViewable>(delegate: T, inputBox: SttInputBox, handler: SttHandlerTextField, action: @escaping (T) -> Void) {
        var isError = false
        
        handler.addTarget(type: .didStartEditing, delegate: delegate, handler: { (_,_) in isError = inputBox.isError })
        handler.addTarget(type: .editing, delegate: delegate,
                          handler: { [unowned self] (_,_) in
                            if isError && self.useAgent {
                                action(delegate)
                            }
            }, textField: inputBox.textField)
    }
}
