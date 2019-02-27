//
//  SttLabelBindingOperator.swift
//  OVS
//
//  Created by Peter Standret on 2/12/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SttLabelBindingContext<TViewController: AnyObject>: SttGenericBindingContext<TViewController, String?> {
    
    private var lazyWriterApply: ((String?) -> Void)!
    
    private var command: SttCommandType!
    
    weak private var target: Dynamic<String?>!
    unowned private var label: UILabel
    
    init (viewController: TViewController, label: UILabel) {
        self.label = label
        
        super.init(vc: viewController)
    }
}
