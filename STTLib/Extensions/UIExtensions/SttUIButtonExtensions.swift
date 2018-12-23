//
//  SttButtonExtensions.swift
//  MiniFlix
//
//  Created by Standret on 10/29/18.
//  Copyright © 2018 ved. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setUnderlineTitle(title: String) {
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: self.titleColor(for: .normal)!,
            .font: UIFont(name: "HelveticaNeue-Medium", size: self.titleLabel!.font.pointSize)!
            ]), for: .normal)
    }
}
