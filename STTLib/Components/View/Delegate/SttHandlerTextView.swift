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
    private var handlers = [TypeActionTextView: [(UITextView) -> Void]]()
    
    public var maxCharacter: Int = Int.max
    
    // method for add target
    
    func addTarget<T: SttViewable>(type: TypeActionTextView, delegate: T, handler: @escaping (T, UITextView) -> Void, textField: UITextView) {
        
        handlers[type] = handlers[type] ?? [(UITextView) -> Void]()
        handlers[type]?.append({ [weak delegate] tf in
            if let _delegate = delegate {
                handler(_delegate, tf)
            }
        })
    }
    
    // implements protocol
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        handlers[.didBeginEditing]?.forEach({ $0(textView) })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        handlers[.didEndEditing]?.forEach({ $0(textView) })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        handlers[.editing]?.forEach({ $0(textView) })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= maxCharacter    // 10 Limit Value
    }
}
