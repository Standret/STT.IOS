//
//  SttViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttViewController<T: SttViewInjector>: UIViewController, SttViewControlable {
    
    fileprivate var output: T!
    var presenter: T {
        get { return output }
        set { output = newValue }
    }
    
    var heightScreen: CGFloat { return UIScreen.main.bounds.height }
    var widthScreen: CGFloat { return UIScreen.main.bounds.width }
    
    var useErrorLabel = true
    var hideNavigationBar = false
    var hideTabBar = false
    
    var viewError: SttErrorLabel!
    var barStyle = UIStatusBarStyle.default
    
    fileprivate var parametr: Any?
    fileprivate var callback: ((Any) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewError = SttErrorLabel()
        viewError.errorColor = UIColor(red:0.98, green:0.26, blue:0.26, alpha:1)
        viewError.messageColor = UIColor(red: 0.251, green: 0.482, blue: 0.316, alpha:1)
        view.addSubview(viewError)
        viewError.delegate = self
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    fileprivate var isFirstStart = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstStart {
            isFirstStart = false
            style()
        }
        
        UIApplication.shared.statusBarStyle = barStyle
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
        navigationController?.navigationBar.isHidden = hideNavigationBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return barStyle }
    
    /// Use this function for decorate elements
    func style() { }
    
    // MARK: -- SttViewableListener
    
    func sendError(error: SttBaseErrorType) {
        let serror = error.getMessage()
        if useErrorLabel {
            viewError.showMessage(text: serror.0, detailMessage: serror.1)
        }
        else {
            self.createAlerDialog(title: serror.0, message: serror.1)
        }
    }
    func sendMessage(title: String, message: String?) {
        if useErrorLabel {
            viewError.showMessage(text: title, detailMessage: message, isError: false)
        }
        else {
            self.createAlerDialog(title: title, message: message ?? "")
        }
    }
}

class SttKeyboardViewController<T: SttViewInjector>: SttViewController<T>, SttKeyboardNotificationDelegate {
    
    var isKeyboardShow: Bool { return _isKeyboardShow }
    
    fileprivate var keyboardNotification: SttKeyboardNotification!
    fileprivate var scrollAmount: CGFloat = 0
    fileprivate var scrollAmountGeneral: CGFloat = 0
    
    fileprivate var _isKeyboardShow = false
    fileprivate var moveViewUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotification = SttKeyboardNotification()
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(_:))))
        
        _ = SttGlobalObserver.observableStatusApplication.subscribe(onNext: { (status) in
            if status == .didEnterBackgound {
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
            }
        })
        
        keyboardNotification.addObserver()
    }
    
    @objc
    func handleClick(_ : UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !keyboardNotification.isActive {
            keyboardNotification.addObserver()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        keyboardNotification.removeObserver()
    }

    // MARK: -- SttKeyboardNotificationDelegate
    
    func keyboardWillShow(height: CGFloat) {
        if view != nil {
            scrollAmount = height - scrollAmountGeneral
            scrollAmountGeneral = height
            
            moveViewUp = true
            scrollTheView(move: moveViewUp)
        }
        _isKeyboardShow = true
    }
    func keyboardWillHide(height: CGFloat) {
        if moveViewUp {
            scrollTheView(move: false)
        }
        _isKeyboardShow = false
    }
    
    private func scrollTheView(move: Bool) {
        var frame = view.frame
        if move {
            frame.size.height -= scrollAmount
        }
        else {
            frame.size.height += scrollAmountGeneral
            scrollAmountGeneral = 0
            scrollAmount = 0
        }
        view.frame = frame
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
