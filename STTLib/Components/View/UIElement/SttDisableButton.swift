//
//  DisableButton.swift
//  Lemon
//
//  Created by Grimm on 12/14/18.
//  Copyright © 2018 startupsoft. All rights reserved.
//

import Foundation
import UIKit

class SttDisableButton: SttButton {
    
    @objc dynamic var activeColor: UIColor? {
        didSet {
            if isEnabled {
                backgroundColor = activeColor
            }
        }
    }
    @objc dynamic  var disableColor: UIColor? {
        didSet {
            if !isEnabled {
                backgroundColor = disableColor
            }
        }
    }
    
    @objc dynamic  var activeTintColor: UIColor? {
        didSet {
            if isEnabled {
                tintColor = activeTintColor
            }
        }
    }
    @objc dynamic var disableTintColor: UIColor? {
        didSet {
            if !isEnabled {
                tintColor = disableTintColor
            }
        }
    }
    
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
