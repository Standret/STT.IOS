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
