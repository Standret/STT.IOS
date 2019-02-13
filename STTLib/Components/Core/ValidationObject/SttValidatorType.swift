//
//  SttValidatorType.swift
//  OVS
//
//  Created by Peter Standret on 2/6/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

/// Represent base of type for all validator
protocol SttValidatorType {
    
    var name: String { get }
    
    var customIncorrectError: String? { get }
    
    var isRequired: Bool { get }
    var regexPattern: String? { get }
    
    var min: Int { get }
    var max: Int { get }
    
    init (name: String, isRequired: Bool, regexPattern: String?, min: Int, max: Int, customIncorrectError: String?)
    
    var validationError: String { get }
    var validationResult: SttValidationResult { get }
    
    @discardableResult
    func validate(object: String?, parametr: Any?) -> SttValidationResult
}

extension SttValidatorType {
    
    var isError: Bool { return validationResult != .ok }
    
    @discardableResult
    func validate(object: String?, parametr: Any? = nil) -> SttValidationResult {
        return self.validate(object: object, parametr: parametr)
    }
}
