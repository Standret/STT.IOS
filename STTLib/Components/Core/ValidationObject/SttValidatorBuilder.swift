//
//  SttValidatorFilter.swift
//  OVS
//
//  Created by Peter Standret on 2/6/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

final class SttValidatorBuilder<Target: SttValidatorType> {
    
    private let name: String
    
    private var min = Int.min
    private var max = Int.max
    
    private var isUnique = false
    
    private var pattern: String? = nil
    
    private var customIncorrectError: String? = nil
    
    init (name: String) {
        self.name = name
    }
    
    func useMin(_ value: Int) -> SttValidatorBuilder<Target> {
        min = value
        return self
    }
    func useMax(_ value: Int) -> SttValidatorBuilder<Target> {
        max = value
        return self
    }

    func useUnique(_ value: Bool) -> SttValidatorBuilder<Target> {
        isUnique = value
        return self
    }
    
    func usePattern(_ value: String) -> SttValidatorBuilder<Target> {
        pattern = value
        return self
    }

    func useCustomError(_ value: String) -> SttValidatorBuilder<Target> {
        customIncorrectError = value
        return self
    }
    
    func build() -> SttValidatorType {
        return Target(name: name, isRequired: isUnique, regexPattern: pattern, min: min, max: max, customIncorrectError: customIncorrectError)
    }

}
