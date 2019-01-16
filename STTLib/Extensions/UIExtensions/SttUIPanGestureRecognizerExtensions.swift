//
//  SttUIPanGestureRecognizer.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/13/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

enum SttDirection: Int {
    case up
    case down
    case left
    case right
    case none
    
    var isX: Bool { return self == .left || self == .right }
    var isY: Bool { return !isX }
}

extension UIPanGestureRecognizer {
    
    func getDirection(in view: UIView) -> SttDirection {
        let _velocity = velocity(in: view)
        let vertical = abs(_velocity.y) > abs(_velocity.x)
        switch (vertical, _velocity.x, _velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return .none
        }
    }
}
