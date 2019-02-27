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
    
    var isAnimate: Bool = true
    
    var isError: Bool { return !SttString.isWhiteSpace(string: error)}
    
    @IBInspectable
    var labelName: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    @objc dynamic var useVibrationOnError = false
    
    @objc dynamic var maxCount: Int = 70 {
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
                if useVibrationOnError {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
                
            }
            else {
                underline.backgroundColor = isEdited ? underlineActiveColor : underlineDisableColor
                label.textColor = isEdited ? labelActiveColor : labelDisableColor
            }
        }
    }
    
    // MARK: Appereance
    @objc dynamic var textFieldFont: UIFont? {
        get { return textView.font }
        set { textView.font = newValue }
    }
    @objc dynamic var labelFont: UIFont? {
        get { return label.font }
        set { label.font = newValue }
    }
    @objc dynamic var errorLabelFont: UIFont? {
        get { return errorLabel.font }
        set { errorLabel.font = newValue }
    }
    @objc dynamic var counterLabelFont: UIFont? {
        get { return counterLabel.font }
        set { counterLabel.font = newValue }
    }
    
    @objc dynamic var textFieldColor: UIColor? {
        get { return textView.textColor }
        set { textView.textColor = newValue }
    }
    @objc dynamic var errorColor: UIColor? {
        get { return errorLabel.textColor }
        set { errorLabel.textColor = newValue }
    }
    @objc dynamic var counterColor: UIColor? {
        get { return counterLabel.textColor }
        set { counterLabel.textColor = newValue }
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
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
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
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = handlerTextView
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addSubview(textView)
        
        textView.edgesToSuperview(excluding: .bottom, insets: .top(14) + .left(4) + .right(4))
        
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
        label = UILabel(frame: CGRect(x: 8, y: 25, width: 300, height: 22))
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
        
        UIView.animate(withDuration: isAnimate ? 0.3 : 0, animations: {
            
            let trans  = -(self.label.bounds.width - self.label.bounds.width * 0.575) / 2
            let translation = CGAffineTransform(translationX: trans, y: -25)
            let scaling = CGAffineTransform(scaleX: 0.575,
                                            y: 0.575)
            
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
        
        if SttString.isEmpty(string: textView.text) {
            UIView.animate(withDuration:  isAnimate ? 0.3 : 0) {
                self.label.transform = CGAffineTransform.identity
            }
        }
        
        cnstrUnderlineHeight.constant = underlineDisableHeight
        UIView.animate(withDuration:  isAnimate ? 0.3 : 0, animations: { self.layoutIfNeeded() })
    }
    
    private func changeCounterValue(to with: Int) {
        counterLabel.text = "\(with)/\(handlerTextView.maxCharacter)"
    }
}
