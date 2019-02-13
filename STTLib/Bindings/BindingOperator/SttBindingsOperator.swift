//
//  BindingsOperator.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

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
