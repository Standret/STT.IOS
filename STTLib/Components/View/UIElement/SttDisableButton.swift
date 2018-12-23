//
//  DisableButton.swift
//  Lemon
//
//  Created by Grimm on 12/14/18.
//  Copyright © 2018 startupsoft. All rights reserved.
//

import Foundation
import UIKit

class SttDisableButton: UIButton {
    
    var activeColor: UIColor? {
        didSet {
            if isEnabled {
                backgroundColor = activeColor
            }
        }
    }
    var disableColor: UIColor?
    
    var activeTintColor: UIColor? {
        didSet {
            if isEnabled {
                tintColor = activeTintColor
            }
        }
    }
    var disableTintColor: UIColor?
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = activeColor
                tintColor = activeTintColor
            }
            else {
                backgroundColor = disableColor
                tintColor = disableTintColor
            }
        }
    }
}
