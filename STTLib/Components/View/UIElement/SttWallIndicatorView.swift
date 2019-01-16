//
//  SttWallIndicatorView.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/12/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

class SttWalIndicatorView: UIView {
    
    private var indicator: UIActivityIndicatorView!
    
    var indicatorStyle: UIActivityIndicatorView.Style {
        get { return indicator.style }
        set { indicator.style = newValue }
    }
    var indicatorColor: UIColor {
        get { return indicator.color }
        set { indicator.color = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        
        indicator = self.setIndicator()
        indicator.hidesWhenStopped = true
    }
    
    func startAnimating() {
        indicator.startAnimating()
        self.isHidden = false
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
        self.isHidden = true
    }
}
