//
//  SttNavigationControllerExtensions.swift
//  SttDictionary
//
//  Created by Piter Standret on 7/23/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var shadowColor: CGColor? {
        get { return self.navigationBar.layer.shadowColor }
        set(value) {
            self.navigationBar.layer.masksToBounds = false
            self.navigationBar.layer.shadowColor = value
            self.navigationBar.layer.shadowOpacity = 0.6
            self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            self.navigationBar.layer.shadowRadius = 0.5
        }
    }
    
    func createTransparent() {
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
}
