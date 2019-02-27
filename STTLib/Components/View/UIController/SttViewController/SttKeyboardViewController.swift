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
    
    private var statusAppDisposable = DisposeBag()
    private var cnstrHeight: NSLayoutConstraint!
    
    var targetKeyboardConstraint: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardNotification.callIfKeyboardIsShow = true
        keyboardNotification.delegate = self
        
        if useCancelGesture {
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(handleClick(_:)))
            cancelGesture.cancelsTouchesInView = cancelsTouchesInView
            self.view.addGestureRecognizer(cancelGesture)
        }
        
        SttGlobalObserver.observableStatusApplication.subscribe(onNext: { [unowned self] (status) in
            switch status {
            case .didEnterBackgound:
                self.view.endEditing(true)
                self.navigationController?.navigationBar.endEditing(true)
                self.keyboardNotification.removeObserver()
                print("remove")
            case .willEnterForeground:
                self.keyboardNotification.addObserver()
                print("add")
            default: break;
            }
        }).disposed(by: statusAppDisposable)
    }
    
    @objc
    func handleClick(_ sender: UITapGestureRecognizer?) {
        let senderView = sender?.view?.hitTest(sender!.location(in: view), with: nil)
        if !(senderView?.tag == 900) {
            view.endEditing(true)
        }
    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Int(viewRect.height) <= Int(view.bounds.height - scrollAmount) {
            
            var frame = view.frame
            frame.size.height -= scrollAmount
            if let cnstr = targetKeyboardConstraint {
                cnstr.constant = scrollAmount
                print(cnstr.constant)
            }
            else {
                view.frame = frame
            }
        }
        keyboardNotification.addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    private var viewRect = CGRect.zero
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
        viewRect = frame
        if let cnstr = targetKeyboardConstraint {
            cnstr.constant = scrollAmount
            print(cnstr.constant)
        }
        else {
            view.frame = frame
        }
        if keyboardNotification.isAnimation {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
