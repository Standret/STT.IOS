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
    var barStyle = UIStatusBarStyle.lightContent
    
    fileprivate var parametr: Any?
    fileprivate var callback: ((Any) -> Void)?
    
    fileprivate var wrappedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        wrappedView = UIView()
        wrappedView.backgroundColor = .clear
        wrappedView.isHidden = true
        
        view.addSubview(wrappedView)
        wrappedView.edgesToSuperview()
        
        viewError = SttErrorLabel()
        viewError.errorColor = UIColor(red:0.98, green:0.26, blue:0.26, alpha:1)
        viewError.messageColor = UIColor(red: 0.251, green: 0.482, blue: 0.316, alpha:1)
        view.addSubview(viewError)
        viewError.delegate = self
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.hidesBackButton = customBackBarButton
        navigationItem.backBarButtonItem = item
    }
    
    func manageWrappedView(color: UIColor, hide: Bool) {
        wrappedView.backgroundColor = color
        wrappedView.isHidden = hide
    }
    
    fileprivate var isFirstStart = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.viewAppearing()
                
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewAppeared()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
}
