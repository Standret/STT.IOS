//
//  InputBox.swift
//  Lemon
//
//  Created by Standret on 12/13/18.
//  Copyright © 2018 startupsoft. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

enum TypeInputBox {
    case text
    case security
}

@IBDesignable
class InputBox: UIView, SttViewable {
    
    var textField: UITextField!
    private var label: UILabel!
    private var errorLabel: UILabel!
    private var underline: UIView!
    
    private var isEdited = false
    
    let textFieldHandler = SttHandlerTextField()
    
    private var cnstrUnderlineHeight: NSLayoutConstraint!
    private var cnstrErrorHeight: NSLayoutConstraint!
    
    var isError: Bool { return !SttString.isWhiteSpace(string: error)}
    
    var labelName: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    var isSimpleLabel: Bool = false {
        didSet {
            label.isHidden = isSimpleLabel
            textField.placeholder = isSimpleLabel ? label.text : ""
        }
    }
    
    var typeInputBox: TypeInputBox = .text {
        didSet {
            changeType(type: typeInputBox)
        }
    }
    
    var error: String? {
        didSet {
            errorLabel.text = error
            
            if !SttString.isWhiteSpace(string: error) {
                underline.backgroundColor = errorColor
//                if isEdited {
//                    label.textColor = errorColor
//                }
            }
            else {
                underline.backgroundColor = isEdited ? underlineActiveColor : underlineDisableColor
                label.textColor = isEdited ? labelActiveColor : labelDisableColor
            }
        }
    }
    
    // MARK: Appereance
    var textFieldFont: UIFont? {
        get { return textField.font }
        set { textField.font = newValue }
    }
    var labelFont: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }
    var errorLabelFont: UIFont? {
        get { return errorLabel.font }
        set { errorLabel.font = newValue }
    }
    
    var textFieldColor: UIColor? {
        get { return textField.textColor }
        set { textField.textColor = newValue }
    }
    var errorColor: UIColor? {
        get { return errorLabel.textColor }
        set { errorLabel.textColor = newValue }
    }
    
    var labelActiveColor: UIColor = .black
    var labelDisableColor: UIColor = .black {
        didSet {
            if !isError {
                label.textColor = labelDisableColor
            }
        }
    }
    
    var underlineActiveColor: UIColor = .black
    var underlineDisableColor: UIColor = .black {
        didSet {
            if !isError && !isEdited {
                underline.backgroundColor = underlineDisableColor
            }
        }
    }
    
    var underlineActiveHeight: CGFloat = 2 {
        didSet {
            if isEdited {
                cnstrUnderlineHeight.constant = underlineActiveHeight
            }
        }
    }
    var underlineDisableHeight: CGFloat = 0.5 {
        didSet {
            if !isEdited {
                cnstrUnderlineHeight.constant = underlineDisableHeight
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        
        initTextField()
        initLabel()
        initUnderline()
        initError()
    }
    
    private func initTextField() {
        
        textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = textFieldHandler
        textField.clearButtonMode = .whileEditing
        textField.height(40)

        addSubview(textField)
        
        textField.edgesToSuperview(excluding: .bottom, insets: .top(20) + .left(8) + .right(8))
        
        textFieldHandler.addTarget(type: .didStartEditing, delegate: self,
                                   handler: { (v, _) in v.startEditing() },
                                   textField: textField)
        textFieldHandler.addTarget(type: .didEndEditing, delegate: self,
                                   handler: { (v, _) in v.endEditing() },
                                   textField: textField)
        textFieldHandler.addTarget(type: .editing, delegate: self,
                                   handler: { (v, tf) in
                                    if !SttString.isEmpty(string: tf.text) {
                                        v.startEditing()
                                    }
                                    if !tf.isEditing {
                                        v.endEditing()
                                    } },
                                   textField: textField)
    }
    private func initLabel() {
        label = UILabel(frame: CGRect(x: 8, y: 32, width: 300, height: 22))
        label.textAlignment = .left
        label.text = "Field"
        addSubview(label)
    }
    private func initUnderline() {
        underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = underlineDisableColor
        
        cnstrUnderlineHeight = underline.height(underlineDisableHeight)
        
        addSubview(underline)
        underline.edgesToSuperview(excluding: [.top, .bottom])
        underline.topToBottom(of: textField, offset: 5)
    }
    private func initError() {
        errorLabel = UILabel()
        errorLabel.textAlignment = .left
        errorLabel.numberOfLines = 3
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = ""
        cnstrErrorHeight = errorLabel.height(0, relation: .equalOrGreater)
        
        addSubview(errorLabel)
        
        errorLabel.edgesToSuperview(excluding: .top, insets: .bottom(3) + .left(8) + .right(8))
        errorLabel.topToBottom(of: underline, offset: 2)
    }
    
    private func startEditing() {
        isEdited = true
        
        label.textColor = labelActiveColor
        if isError {
            //label.textColor = errorColor
        }
        else {
            underline.backgroundColor = underlineActiveColor
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            let trans  = -(self.label.bounds.width - self.label.bounds.width * 0.65) / 2
            let translation = CGAffineTransform(translationX: trans, y: -32)
            let scaling = CGAffineTransform(scaleX: 0.65,
                                            y: 0.65)
            
            self.label.transform = scaling.concatenating(translation)
            
            self.cnstrUnderlineHeight.constant = self.underlineActiveHeight
            
            self.layoutIfNeeded()
        })
    }
    private func endEditing() {
        isEdited = false
        
        label.textColor = labelDisableColor
        if isError {
            //underline.backgroundColor = underlineDisableColor
            //label.textColor = labelDisableColor
        }
        else {
            underline.backgroundColor = underlineDisableColor
        }
        
        if SttString.isWhiteSpace(string: textField.text) {
            UIView.animate(withDuration: 0.3) {
                self.label.transform = CGAffineTransform.identity
            }
        }
        
        cnstrUnderlineHeight.constant = underlineDisableHeight
        UIView.animate(withDuration: 0.3, animations: { self.layoutIfNeeded() })
    }
    
    private func changeType(type: TypeInputBox) {
        textField.isSecureTextEntry = false
        textField.isUserInteractionEnabled = true
        
        switch type {
        case .text: break;
        case .security:
            textField.isSecureTextEntry = true
        }
    }
}
