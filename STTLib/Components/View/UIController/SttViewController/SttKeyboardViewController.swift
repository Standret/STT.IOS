//
//  SttKeyboardViewController.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/12/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SttKeyboardViewController<T: SttViewControllerInjector>: SttViewController<T>, SttKeyboardNotificationDelegate {
    
    var isKeyboardShow: Bool { return _isKeyboardShow }
    var useCancelGesture = true
    var cancelsTouchesInView = true
    
    let keyboardNotification = SttKeyboardNotification()
    fileprivate var scrollAmount: CGFloat = 0
    fileprivate var scrollAmountGeneral: CGFloat = 0
    
    fileprivate var _isKeyboardShow = false
    fileprivate var moveViewUp: Bool = false
    
    private var statusAppDisposable: CompositeDisposable?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        if useCancelGesture {
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(handleClick(_:)))
            cancelGesture.cancelsTouchesInView = cancelsTouchesInView
            view.addGestureRecognizer(cancelGesture)
        }
        
        _ = statusAppDisposable?.insert(SttGlobalObserver.observableStatusApplication.subscribe(onNext: { [unowned self] (status) in
            switch status {
            case .didEnterBackgound:
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
                self.keyboardNotification.removeObserver()
            case .willEnterForeground:
                self.keyboardNotification.addObserver()
            default: break;
            }
        }))
    }
    
    @objc
    func handleClick(_: UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotification.addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        keyboardNotification.removeObserver()
    }
    
    deinit {
        statusAppDisposable?.dispose()
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
        if keyboardNotification.isAnimation {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
