//
//  SttButton.swift
//  Lemon
//
//  Created by Piter Standret on 1/16/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

class SttButton: UIButton {
    
    @objc dynamic var titleFont: UIFont {
        get { return titleLabel!.font }
        set { titleLabel!.font = newValue }
    }
}

class SttHiglightedButton: SttButton {
    
    @objc dynamic var unSelectedBackground: UIColor? {
        didSet {
            if !isHighlighted {
                self.backgroundColor = unSelectedBackground
            }
        }
    }
    
    @objc dynamic var selectedBackground: UIColor? {
        didSet {
            if isHighlighted {
                self.backgroundColor = selectedBackground
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = selectedBackground
            }
            else {
                self.backgroundColor = unSelectedBackground
            }
            self.setNeedsDisplay()
        }
    }
}
