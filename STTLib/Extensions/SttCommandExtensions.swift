//
//  SttCommandExtensions.swift
//  SttDictionary
//
//  Created by Standret on 26.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

extension SttComand {
    func useIndicator(button: UIButton, style: UIActivityIndicatorView.Style = .gray) {
        let indicator = button.setIndicator()
        indicator.color = UIColor.white
        indicator.style = style
        
        let title = button.titleLabel?.text
        let image = button.imageView?.image
        
        self.useWork(start: {
            button.setImage(nil, for: .normal)
            button.setTitle("", for: .disabled)
            button.isEnabled = false
            indicator.startAnimating()
        }) {
            button.setImage(image, for: .normal)
            button.setTitle(title, for: .disabled)
            button.setNeedsDisplay()
            button.isEnabled = true
            indicator.stopAnimating()
        }
    }
    
    func useRefresh(refreshControl: UIRefreshControl) {
        self.useWork(start: nil) {
            refreshControl.endRefreshing()
        }
    }
}
