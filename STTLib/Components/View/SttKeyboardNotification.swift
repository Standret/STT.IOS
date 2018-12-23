//
//  SttKeyboardNotification.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

public protocol SttKeyboardNotificationDelegate: class {
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide(height: CGFloat)
}

public class SttKeyboardNotification {
    
    public var isAnimation: Bool = false
    public var callIfKeyboardIsShow: Bool = false
    
    public var isActive: Bool = false
    
    public weak var delegate: SttKeyboardNotificationDelegate!
    
    public var bounds: CGRect {
        if let frame: NSValue = notificationObject?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return frame.cgRectValue
        }
        return CGRect()
    }
    public var heightKeyboard: CGFloat {
        return bounds.height
    }
    
    private var isKeyboardShow: Bool = true
    private var notificationObject: Notification!
    
    public func removeObserver() {
        isActive = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    public func addObserver() {
        isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc private func keyboardWillShow(_ notification: Notification?) {
        notificationObject = notification
        if callIfKeyboardIsShow || !isKeyboardShow {
            delegate?.keyboardWillShow(height: heightKeyboard)
        }
        isKeyboardShow = true
    }
    @objc private func keyboardWillHide(_ notification: Notification?) {
        notificationObject = notification
        delegate?.keyboardWillHide(height: heightKeyboard)
        isKeyboardShow = false
    }
}
