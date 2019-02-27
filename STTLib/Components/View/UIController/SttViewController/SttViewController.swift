//
//  SttViewController.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttViewController<T: SttViewControllerInjector>: UIViewController {
    
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
    var customBackBarButton: Bool = false
    
    var viewError: SttErrorLabel!
    var barStyle = UIStatusBarStyle.default
    
    fileprivate var parametr: Any?
    fileprivate var callback: ((Any) -> Void)?
    
    private var backgroundLayer: UIView!
    private var _wrappedView = SttWalIndicatorView()
    var wrappedView: SttWalIndicatorView { return _wrappedView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        wrappedView.backgroundColor = .clear
        wrappedView.isHidden = true
        
        view.addSubview(wrappedView)
        wrappedView.edgesToSuperview()
        
        backgroundLayer = UIView()
        backgroundLayer.translatesAutoresizingMaskIntoConstraints = false
        backgroundLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backgroundLayer.alpha = 0
        view.addSubview(backgroundLayer)
        backgroundLayer.edgesToSuperview()
        
        viewError = SttErrorLabel()
        viewError.errorColor = UIColor(red:0.98, green:0.26, blue:0.26, alpha:1)
        viewError.messageColor = UIColor(red: 0.251, green: 0.482, blue: 0.316, alpha:1)
        view.addSubview(viewError)
        viewError.delegate = self
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = customBackBarButton
        navigationItem.backBarButtonItem = item
        
        navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(onGesture(sender:)))
    }
    
    private var currentTransitionCoordinator: UIViewControllerTransitionCoordinator?
    private var isAppeared: Bool = false
    @objc private func onGesture(sender: UIGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            if let ct = navigationController?.transitionCoordinator {
                currentTransitionCoordinator = ct
            }
        case .cancelled, .ended:
            currentTransitionCoordinator = nil
            backgroundLayer.alpha = 0
        case .possible, .failed:
            break
        }
        
        if let currentTransitionCoordinator = currentTransitionCoordinator {
            print(currentTransitionCoordinator.percentComplete)
            if isAppeared {
                backgroundLayer.alpha = 1 - currentTransitionCoordinator.percentComplete
            }
            else {
                backgroundLayer.alpha = 0
            }
        }
    }
    
    func manageWrappedView(color: UIColor, hide: Bool, useIndicator: Bool = true) {
        wrappedView.backgroundColor = color
        wrappedView.isHidden = hide
        if useIndicator {
            if hide {
                wrappedView.stopAnimating()
            }
            else {
                wrappedView.startAnimating()
            }
        }
    }
    
    fileprivate var isFirstStart = true
    override func viewWillAppear(_ animated: Bool) {
        isAppeared = true
        super.viewWillAppear(animated)
        self.presenter.viewAppearing()
        
        if isFirstStart {
            isFirstStart = false
            style()
            bind()
        }
        
        UIApplication.shared.statusBarStyle = barStyle
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
                
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
        navigationController?.navigationBar.isHidden = hideNavigationBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewAppeared()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isAppeared = false
        super.viewWillDisappear(animated)
        presenter.viewDissapearing()
        
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDissapeared()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return barStyle }
    
    /// Use this function for decorate elements
    func style() { }
    
    /// Use this function for subscribing on notification
    func bind() { }
}
