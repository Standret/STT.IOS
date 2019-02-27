//
//  SttTextFieldHandlerValidator.swift
//  Lemon
//
//  Created by Peter Standret on 2/21/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

class SttTextFieldHandlerValidator {
    
    var useAgent = true
    private(set) var isError = false
    private unowned let inputBox: SttInputBox
    
    init<T: SttViewable>(delegate: T, inputBox: SttInputBox, handler: SttHandlerTextField, action: @escaping (T) -> Void) {
        
        self.inputBox = inputBox
        
        handler.addTarget(type: .didStartEditing, delegate: delegate, handler: { (_,_) in self.isError = inputBox.isError })
        handler.addTarget(type: .editing, delegate: delegate,
                          handler: { [unowned self] (_,_) in
                            if self.isError && self.useAgent {
                                action(delegate)
                            }
            }, textField: inputBox.textField)
    }
    
    func updateError() {
        isError = inputBox.isError
    }
}
