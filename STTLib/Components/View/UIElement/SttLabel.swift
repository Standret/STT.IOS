//
//  SttLabel.swift
//  Lemon
//
//  Created by Peter Standret on 1/29/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

class SttLabel: UILabel {
    
    @objc dynamic var highlightedFont: UIFont? {
        didSet {
            if isHighlighted {
                self.font = highlightedFont
                self.setNeedsDisplay()
            }
        }
    }
    
    @objc dynamic var usualFont: UIFont? {
        didSet {
            if !isHighlighted {
                self.font = usualFont
                self.setNeedsDisplay()
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.setNeedsDisplay()
            if isHighlighted {
                self.font = highlightedFont
            }
            else {
                self.font = usualFont
            }
        }
    }
    
}
