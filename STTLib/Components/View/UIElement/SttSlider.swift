//
//  SttSlider.swift
//  Lemon
//
//  Created by Piter Standret on 1/22/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

class SttSlider : UISlider {
    
    @IBInspectable @objc dynamic var trackWidth: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
