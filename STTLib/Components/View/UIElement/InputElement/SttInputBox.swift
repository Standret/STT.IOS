//
//  SttInputBox.swift
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
class SttInputBox: UIView, SttViewable {
    
    private var _textField: UITextField!
    var textField: UITextField { return _textField }
    private var label: UILabel!
    private var errorLabel: UILabel!
    private var underline: UIView!
    
    private var isEdited = false
    
    private var textsLeft = [NSLayoutConstraint]()
    private var textsRight = [NSLayoutConstraint]()
    
    let textFieldHandler = SttHandlerTextField()
    
    private var cnstrUnderlineHeight: NSLayoutConstraint!
    private var cnstrErrorHeight: NSLayoutConstraint!
    
    var isError: Bool { return !SttString.isWhiteSpace(string: error) }
    
    @objc dynamic var textEdges: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            
            label.frame = CGRect(x: textEdges.left, y: label.frame.origin.y, width: label.frame.width, height: label.frame.height)
            
            for litem in textsLeft {
                litem.constant = textEdges.left
            }
            
            for ritem in textsRight {
                ritem.constant = textEdges.right
            }
        }
    }
    
    var labelName: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    @objc dynamic var isSimpleLabel: Bool = false {
        didSet {
            label.isHidden = isSimpleLabel
            _textField.placeholder = isSimpleLabel ? label.text : ""
        }
    }
    
    var typeInputBox: TypeInputBox = .text {
        didSet {
            changeType(type: typeInputBox)
        }
    }
    
    var text: String? {
        get { return _textField.text }
        set {
            if !isEdited {
                startEditing()
            }
            
            _textField.text = newValue
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
    @objc dynamic var textFieldFont: UIFont? {
        get { return _textField.font }
        set { _textField.font = newValue }
    }
    @objc dynamic var labelFont: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }
    @objc dynamic var errorLabelFont: UIFont? {
        get { return errorLabel.font }
        set { errorLabel.font = newValue }
    }
    
    @objc dynamic var textFieldColor: UIColor? {
        get { return _textField.textColor }
        set { _textField.textColor = newValue }
    }
    @objc dynamic var errorColor: UIColor? {
        get { return errorLabel.textColor }
        set { errorLabel.textColor = newValue }
    }
    
    @objc dynamic var labelActiveColor: UIColor = .black
    @objc dynamic var labelDisableColor: UIColor = .black {
        didSet {
            if !isError {
                label.textColor = labelDisableColor
            }
        }
    }
    
    @objc dynamic var underlineActiveColor: UIColor = .black
    @objc dynamic var underlineDisableColor: UIColor = .black {
        didSet {
            if !isError && !isEdited {
                underline.backgroundColor = underlineDisableColor
            }
        }
    }
    
    @objc dynamic var underlineActiveHeight: CGFloat = 2 {
        didSet {
            if isEdited {
                cnstrUnderlineHeight.constant = underlineActiveHeight
            }
        }
    }
    @objc dynamic var underlineDisableHeight: CGFloat = 0.5 {
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
        
        _textField = UITextField()
        _textField.borderStyle = .none
        _textField.textAlignment = .left
        _textField.autocorrectionType = .no
        _textField.translatesAutoresizingMaskIntoConstraints = false
        _textField.delegate = textFieldHandler
        _textField.clearButtonMode = .never
        _textField.height(40)

        addSubview(_textField)
        
        _textField.topToSuperview(offset: 20)
        textsLeft.append(_textField.leftToSuperview(offset: textEdges.left))
        textsRight.append(_textField.rightToSuperview(offset: textEdges.right))
        
        textFieldHandler.addTarget(type: .didStartEditing, delegate: self,
                                   handler: { (v, _) in v.startEditing() },
                                   textField: _textField)
        textFieldHandler.addTarget(type: .didEndEditing, delegate: self,
                                   handler: { (v, _) in v.endEditing() },
                                   textField: _textField)
        textFieldHandler.addTarget(type: .editing, delegate: self,
                                   handler: { (v, tf) in
                                    if !SttString.isEmpty(string: tf.text) {
                                        v.startEditing()
                                    }
                                    if !tf.isEditing {
                                        v.endEditing()
                                    } },
                                   textField: _textField)
    }
    private func initLabel() {
        label = UILabel(frame: CGRect(x: textEdges.left, y: 32, width: 300, height: 22))
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
        underline.topToBottom(of: _textField, offset: 5)
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
        
        errorLabel.bottomToSuperview(offset: 3)
        textsLeft.append(errorLabel.leftToSuperview(offset: textEdges.left))
        textsRight.append(errorLabel.leftToSuperview(offset: textEdges.right))
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
        
        if SttString.isWhiteSpace(string: _textField.text) {
            UIView.animate(withDuration: 0.3) {
                self.label.transform = CGAffineTransform.identity
            }
        }
        
        cnstrUnderlineHeight.constant = underlineDisableHeight
        UIView.animate(withDuration: 0.3, animations: { self.layoutIfNeeded() })
    }
    
    private func changeType(type: TypeInputBox) {
        _textField.isSecureTextEntry = false
        _textField.isUserInteractionEnabled = true
        
        switch type {
        case .text: break;
        case .security:
            _textField.isSecureTextEntry = true
        }
    }
}
