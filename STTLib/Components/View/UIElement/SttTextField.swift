//
//  SttTextField.swift
//  SttDictionary
//
//  Created by Admin on 5/17/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SttTextField: UITextField {
    
    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return insertRect(rect: bounds, insets: insets)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return insertRect(rect: bounds, insets: insets)
    }
    
    private func insertRect(rect: CGRect, insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: Double(rect.minX + insets.left), y: Double(rect.minY + insets.top),
                      width: Double(rect.width - insets.left - insets.right), height: Double(rect.height - insets.top - insets.bottom))
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        
        var rect = super.caretRect(for: position)
        rect.size.width = 2
        return rect
    }
}
