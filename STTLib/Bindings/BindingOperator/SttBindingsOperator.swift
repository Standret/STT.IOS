//
//  BindingsOperator.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

/**
 
 Custom operators
 Second way to write bindings
 
 For more information look at our documentation on github
 
 UPS :\ Something missing
 If you see this message just write me. Prter Standret
 
 */

func => <TV: AnyObject>(left: SttBindingSet<TV>, right: UILabel) -> SttLabelBindingContext<TV> {
    return left.bind(right)
}

func => <TV: AnyObject>(left: SttBindingSet<TV>, right: UITextField) -> SttTextFieldBindingContext<TV> {
    return left.bind(right)
}

func => <TV: AnyObject>(left: SttBindingSet<TV>, right: UIButton) -> SttButtonBindingSet {
    return left.bind(right)
}

func => <TV: AnyObject, T>(left: SttBindingSet<TV>, right: T.Type) -> SttGenericBindingContext<TV, T> {
    return left.bind(right)
}
