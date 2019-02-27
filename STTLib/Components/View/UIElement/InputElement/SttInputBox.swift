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
    case security(TypeShpwPassword)
}

enum TypeShpwPassword {
    case none
    case eye
    case text
}

@IBDesignable
class SttInputBox: UIView, SttViewable {
    
    private(set) var textField: UITextField!
    
    private var icon: UIImageView!
    private var showButton: SttButton!
    
    private var label: UILabel!
    private var errorLabel: UILabel!
    private var underline: UIView!
    
    private var isEdited = false
    
    private var textsLeft = [NSLayoutConstraint]()
    private var textsRight = [NSLayoutConstraint]()
    private var cnstrtfToRight: NSLayoutConstraint!
    
    let textFieldHandler = SttHandlerTextField()
    
    private var cnstrUnderlineHeight: NSLayoutConstraint!
    private var cnstrErrorHeight: NSLayoutConstraint!
    private var cnstrRightIconTF, cnstrRightButtonTF: NSLayoutConstraint!
    /// disable or enable all start and end editing animation
    var isAnimate: Bool = true
    
    var isError: Bool { return !SttString.isWhiteSpace(string: error) }
    
    @objc dynamic var textEdges: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            
            label.frame = CGRect(x: textEdges.left, y: label.frame.origin.y, width: label.frame.width, height: label.frame.height)
            
            for litem in textsLeft {
                litem.constant = textEdges.left
            }
            
            for ritem in textsRight {
                ritem.constant = -textEdges.right
            }
        }
    }
    
    @IBInspectable
    var labelName: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    
    @objc dynamic var isSimpleLabel: Bool = false {
        didSet {
            label.isHidden = isSimpleLabel
            textField.placeholder = isSimpleLabel ? label.text : ""
        }
    }
    
    @objc dynamic var useVibrationOnError = false
    
    var typeInputBox: TypeInputBox = .text {
        didSet {
            changeType(type: typeInputBox)
        }
    }
    
    var text: String? {
        get { return textField.text }
        set {
            if !isEdited {
                startEditing()
            }
            
            textField.text = newValue
        }
    }
    
    var error: String? {
        didSet {
            
            if !SttString.isWhiteSpace(string: error) {
                underline.backgroundColor = errorColor
                if useVibrationOnError && SttString.isWhiteSpace(string: errorLabel.text) {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }
            }
            else {
                underline.backgroundColor = isEdited ? underlineActiveColor : underlineDisableColor
                label.textColor = isEdited ? labelActiveColor : labelDisableColor
            }
            
            errorLabel.text = error
        }
    }
    
    // MARK: Appereance
    @objc dynamic var textFieldFont: UIFont? {
        get { return textField.font }
        set { textField.font = newValue }
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
        get { return textField.textColor }
        set { if SttString.isEmpty(string: text) { textField.textColor = newValue } }
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
    
    @objc dynamic var showButtonShowText: String? {
        get { return showButton.title(for: .normal) }
        set { showButton.setTitle(newValue, for: .normal) }
    }
    @objc dynamic var showButtonHideText: String? {
        get { return showButton.title(for: .normal) }
        set { showButton.setTitle(newValue, for: .selected) }
    }
    
    @objc dynamic var fontShowButton: UIFont {
        get { return showButton.titleFont }
        set { showButton.titleFont = newValue }
    }
    
    @objc dynamic var titleShowColorShowButton: UIColor? {
        get { return showButton.titleColor(for: .normal) }
        set { showButton.setTitleColor(newValue, for: .normal) }
    }
    @objc dynamic var titleHideShowButton: UIColor? {
        get { return showButton.titleColor(for: .normal) }
        set { showButton.setTitleColor(newValue, for: .selected) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewDidLoad()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    func setAttributedString(string: NSAttributedString) {
        textField.attributedText = string
        if !SttString.isEmpty(string: text) {
            startEditing()
        }
    }
    
    private func viewDidLoad() {
        
        initTextField()
        initIcon()
        initButtonShow()
        initLabel()
        initUnderline()
        initError()
        
        changeType(type: typeInputBox)
    }
    
    private func initTextField() {
        
        textField = SttTextField()
        textField.borderStyle = .none
        textField.keyboardType = .asciiCapable
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = textFieldHandler
        textField.clearButtonMode = .never
        textField.height(40)
        
        if #available(iOS 12, *) {
            textField.textContentType = .oneTimeCode
        } else {
            textField.textContentType = .init(rawValue: "")
        }

        addSubview(textField)
        
        textField.topToSuperview(offset: 19)
        textsLeft.append(textField.leftToSuperview(offset: textEdges.left))
        
        cnstrtfToRight = textField.rightToSuperview(offset: textEdges.right)
        textsRight.append(cnstrtfToRight)
        
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
    
    private func initIcon() {
        icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "eye_open")
        icon.isUserInteractionEnabled = true
        icon.contentMode = .center

        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickShowHandler(_:))))

        addSubview(icon)

        icon.height(22)
        icon.width(22)
        icon.centerY(to: textField)

        cnstrtfToRight.isActive = false
        cnstrRightIconTF = icon.leftToRight(of: textField, offset: 2, priority: LayoutPriority(rawValue: 750))
        icon.rightToSuperview(offset: -(textEdges.right + 2))
    }
    private func initButtonShow() {
        showButton = SttButton()
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.tintColor = .clear
        
        addSubview(showButton)
        
        showButton.height(30)
        showButton.width(30, relation: .equalOrGreater)
        showButton.centerY(to: textField)
        
        cnstrtfToRight.isActive = false
        cnstrRightButtonTF = showButton.leftToRight(of: textField, offset: 2, priority: LayoutPriority(rawValue: 750))
        showButton.rightToSuperview(offset: -(textEdges.right + 2))
        
        showButton.addTarget(self, action: #selector(clickShowHandler(_:)), for: .touchUpInside)
    }
    
    private func initLabel() {
        label = UILabel(frame: CGRect(x: textEdges.left, y: 25, width: 300, height: 22))
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
        
        errorLabel.bottomToSuperview(offset: 3)
        textsLeft.append(errorLabel.leftToSuperview(offset: textEdges.left))
        textsRight.append(errorLabel.rightToSuperview(offset: textEdges.right))
        errorLabel.topToBottom(of: underline, offset: 2)
    }
    
    @objc private func clickShowHandler(_ sender: Any) {
        
        switch typeInputBox {
        case .security(let type):
            textField.isSecureTextEntry.toggle()
            switch type {
            case .eye:
                icon.image = textField.isSecureTextEntry ? UIImage(named: "eye_open") : UIImage(named: "eye_close")
            default:
                showButton.isSelected.toggle()
            }
        default:
            textField.becomeFirstResponder()
        }
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
        
        if SttString.isEmpty(string: textField.text) {
            UIView.animate(withDuration: isAnimate ? 0.3 : 0) {
                self.label.transform = CGAffineTransform.identity
            }
        }
        
        cnstrUnderlineHeight.constant = underlineDisableHeight
        UIView.animate(withDuration: isAnimate ? 0.3 : 0, animations: { self.layoutIfNeeded() })
    }
    
    private func changeType(type: TypeInputBox) {
        textField.isSecureTextEntry = false
        textField.isUserInteractionEnabled = true
        cnstrtfToRight.isActive = true
        
        icon.isHidden = true
        showButton.isHidden = true
        cnstrRightButtonTF.isActive = false
        cnstrRightIconTF.isActive = false
        
        switch type {
        case .text: break;
        case .security(let type):
            switch type {
                
            case .none: break
            case .eye:
                cnstrtfToRight.isActive = false
                icon.isHidden = false
                cnstrRightIconTF.isActive = true
            case .text:
                cnstrtfToRight.isActive = false
                showButton.isHidden = false
                cnstrRightButtonTF.isActive = true
            }
            
            textField.isSecureTextEntry = true
        }
    }
}
