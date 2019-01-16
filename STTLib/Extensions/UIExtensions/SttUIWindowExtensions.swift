//
//  SttUIWindowExtensions.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/1/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    func reloadViewControllers() {
        for window in self.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
