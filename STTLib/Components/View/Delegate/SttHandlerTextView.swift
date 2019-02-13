//
//  SttHandlerTextView.swift
//  YURT
//
//  Created by Standret on 27.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

enum TypeActionTextView {
    case didBeginEditing, didEndEditing
    case editing
}

class SttHandlerTextView: NSObject, UITextViewDelegate {
    
    // private property
    private var handlers = [TypeActionTextView: [SttDelegatedCall<UITextView>]]()
    
    public var maxCharacter: Int = Int.max
    
    // method for add target
    
    func addTarget<T: SttViewable>(type: TypeActionTextView, delegate: T, handler: @escaping (T, UITextView) -> Void, textField: UITextView) {
        
        handlers[type] = handlers[type] ?? [SttDelegatedCall<UITextView>]()
        handlers[type]?.append(SttDelegatedCall<UITextView>(to: delegate, with: handler))
    }
    
    // implements protocol
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        handlers[.didBeginEditing]?.forEach({ $0.callback(textView) })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        handlers[.didEndEditing]?.forEach({ $0.callback(textView) })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        handlers[.editing]?.forEach({ $0.callback(textView) })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= maxCharacter    // 10 Limit Value
    }
}
