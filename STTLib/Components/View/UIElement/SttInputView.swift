//
//  InputView.swift
//  Lemon
//
//  Created by Piter Standret on 12/19/18.
//  Copyright © 2018 startupsoft. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

@IBDesignable
class SttInputView: UIView, SttViewable {
    
    var textView: UITextView!
    private var label: UILabel!
    private var counterLabel: UILabel!
    private var errorLabel: UILabel!
    private var underline: UIView!
    
    private var isEdited = false
    
    private var cnstrUnderlineHeight: NSLayoutConstraint!
    private var cnstrErrorHeight: NSLayoutConstraint!
    
    let handlerTextView = SttHandlerTextView()
    
    var isError: Bool { return !SttString.isWhiteSpace(string: error)}
    
    var labelName: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    var maxCount: Int = 70 {
        didSet {
            handlerTextView.maxCharacter = maxCount
            changeCounterValue(to: 0)
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
        get { return textView.font }
        set { textView.font = newValue }
    }
    var labelFont: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }
    var errorLabelFont: UIFont? {
        get { return errorLabel.font }
        set { errorLabel.font = newValue }
    }
    var counterLabelFont: UIFont? {
        get { return counterLabel.font }
        set { counterLabel.font = newValue }
    }
    
    var textFieldColor: UIColor? {
        get { return textView.textColor }
        set { textView.textColor = newValue }
    }
    var errorColor: UIColor? {
        get { return errorLabel.textColor }
        set { errorLabel.textColor = newValue }
    }
    var counterColor: UIColor? {
        get { return counterLabel.textColor }
        set { counterLabel.textColor = newValue }
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
        
        initTextView()
        initLabel()
        initUnderline()
        initCounter()
        initError()
    }
    
    private func initTextView() {
        
        textView = UITextView()
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.delegate = handlerTextView
        
        addSubview(textView)
        
        textView.edgesToSuperview(excluding: .bottom, insets: .top(20) + .left(8) + .right(8))
        
        handlerTextView.addTarget(type: .didBeginEditing, delegate: self,
                                  handler: { (v, _) in v.startEditing() },
                                  textField: textView)
        handlerTextView.addTarget(type: .didEndEditing, delegate: self,
                                  handler: { (v, _) in v.endEditing() },
                                  textField: textView)
        handlerTextView.addTarget(type: .editing, delegate: self,
                                  handler: { (v, tv) in
                                    self.changeCounterValue(to: self.textView.text.count)
                                    self.layoutIfNeeded()
                                    if !SttString.isEmpty(string: tv.text) {
                                        v.startEditing()
                                    }
                                    if !tv.isFirstResponder {
                                        v.endEditing()
                                    } }, textField: textView)
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
        underline.topToBottom(of: textView, offset: 5)
    }
    private func initCounter() {
        counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 22))
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.text = "59/60"
        counterLabel.textAlignment = .right

        counterLabel.height(22)
        
        addSubview(counterLabel)
        
        counterLabel.edgesToSuperview(excluding: [.top, .left], insets: .bottom(3) + .right(8))
        
        changeCounterValue(to: maxCount)
    }
    private func initError() {
        errorLabel = UILabel()
        errorLabel.textAlignment = .left
        errorLabel.numberOfLines = 3
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = ""
        cnstrErrorHeight = errorLabel.height(22, relation: .equalOrGreater)
        
        addSubview(errorLabel)
        
        errorLabel.edgesToSuperview(excluding: [.right, .top], insets: .bottom(3) + .left(8))
        errorLabel.topToBottom(of: underline, offset: 2)
        errorLabel.rightToLeft(of: counterLabel)
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
        
        if SttString.isWhiteSpace(string: textView.text) {
            UIView.animate(withDuration: 0.3) {
                self.label.transform = CGAffineTransform.identity
            }
        }
        
        cnstrUnderlineHeight.constant = underlineDisableHeight
        UIView.animate(withDuration: 0.3, animations: { self.layoutIfNeeded() })
    }
    
    private func changeCounterValue(to with: Int) {
        counterLabel.text = "\(with)/\(handlerTextView.maxCharacter)"
    }
}
