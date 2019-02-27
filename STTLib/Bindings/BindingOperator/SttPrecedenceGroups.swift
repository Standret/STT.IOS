//
//  PrecedenceGroups.swift
//  OVS
//
//  Created by Peter Standret on 2/7/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

// MARK: - BindingSet

precedencegroup BindingSet {
    associativity: left
    higherThan: ConverterSet
}

infix operator ->>: BindingSet

infix operator <-: BindingSet
infix operator <<-: BindingSet

infix operator <->>: BindingSet
infix operator <<->>: BindingSet

// MARK: - TargetSet

precedencegroup TargetSet {
    associativity: left
    higherThan: BindingSet
}

infix operator =>: TargetSet

precedencegroup ConverterSet {
    associativity: left
}

// for converter
infix operator >-<: BindingSet

// for command and converter parametr
infix operator -<: BindingSet
