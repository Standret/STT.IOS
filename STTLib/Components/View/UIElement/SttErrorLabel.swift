//
//  SttErrorLabel.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttErrorLabel: UIView {
    
    private var errorLabel: UILabel!
    private var topContraint: NSLayoutConstraint!
    private var detailMessage: String?
    var errorColor: UIColor! = UIColor.red
    var messageColor: UIColor! = UIColor.green
    
    weak var delegate: UIViewController! {
        didSet {
            injectConponnent()
        }
    }
    var heightErrorLabel: CGFloat = 40
    var textColor: UIColor? {
        didSet {
            errorLabel.textColor = textColor
        }
    }
    var textFont: UIFont? {
        didSet {
            errorLabel.font = textFont
        }
    }
    
    func showMessage(text: String, detailMessage: String?, isError: Bool = true) {
        DispatchQueue.main.async {
            self.detailMessage = detailMessage
            self.errorLabel.text = text
            self.isHidden = false
            self.backgroundColor = isError ? self.errorColor : self.messageColor
            UIView.animate(withDuration: 0.5, animations: { self.alpha = 1 })
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                timer.invalidate()
                UIView.animate(withDuration: 0.5, animations: { self.alpha = 0 })
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    timer.invalidate()
                    self.isHidden = true
                }
            }
        }
    }
    
    @objc func onClick(_ sender: Any) {
        if let message = detailMessage {
            delegate.createAlerDialog(title: errorLabel.text, message: message)
        }
    }
    
    private func injectConponnent() {
        translatesAutoresizingMaskIntoConstraints = false
        delegate.view.addSubview(self)
        topContraint = self.topAnchor.constraint(equalTo: delegate.view.safeTopAnchor)
        self.safeLeftAnchor.constraint(equalTo: delegate.view.safeLeftAnchor).isActive = true
        self.safeRightAnchor.constraint(equalTo: delegate.view.safeRightAnchor).isActive = true
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1,
                                              constant: heightErrorLabel))
        
        topContraint.isActive = true
        self.alpha = 0
        self.isHidden = true
        
        errorLabel = UILabel()
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        
        self.addSubview(errorLabel)
        self.addConstraints([
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.centerX,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: errorLabel,
                               attribute: NSLayoutConstraint.Attribute.centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.centerY,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: errorLabel,
                               attribute: NSLayoutConstraint.Attribute.centerY,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.left,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: errorLabel,
                               attribute: NSLayoutConstraint.Attribute.left,
                               multiplier: 1,
                               constant: -15),
            NSLayoutConstraint(item: self,
                               attribute: NSLayoutConstraint.Attribute.right,
                               relatedBy: NSLayoutConstraint.Relation.equal,
                               toItem: errorLabel,
                               attribute: NSLayoutConstraint.Attribute.right,
                               multiplier: 1,
                               constant: 15)
            ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick(_:))))
    }
}
