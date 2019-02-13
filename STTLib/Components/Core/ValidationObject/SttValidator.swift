//
//  SttBaseValidator.swift
//  OVS
//
//  Created by Peter Standret on 2/6/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

class SttValidator: SttValidatorType {
    
    var name: String
    
    var customIncorrectError: String?
    
    var isRequired: Bool
    var regexPattern: String?
    
    var min: Int
    var max: Int
    
    var validationError: String { return try! getValidationError(of: validationResult)}
    var validationResult: SttValidationResult = .ok
    
    required init (name: String,
          isRequired: Bool = false,
          regexPattern: String? = nil,
          min: Int = Int.min, max: Int = Int.max,
          customIncorrectError: String? = nil) {
        
        self.name = name
        
        self.customIncorrectError = customIncorrectError
        
        self.isRequired = isRequired
        self.regexPattern = regexPattern
        
        self.min = min
        self.max = max
        
        validationResult = isRequired ? .empty : .ok
    }
    
    func validate(object: String?, parametr: Any?) -> SttValidationResult {
        
        var result: SttValidationResult = .ok
        
        do {
            if SttString.isEmpty(string: object) {
                result = isRequired ? .empty : .ok
            }
            else if (object! as NSString).length < min {
                result = .toShort
            }
            else if (object! as NSString).length > max {
                result = .toLong
            }
            else if let pattern = regexPattern {
                
                let nsObject = object! as NSString
                let regex = try NSRegularExpression(pattern: pattern)
                if regex.matches(in: object!, range: NSRange(location: 0, length: nsObject.length)).count != 1 {
                    result = .inCorrect
                }
                
            }
            else {
                result = .ok
            }
        }
        catch {
            SttLog.error(message: "error \(error) in validate \(object!)", key: "SttValidationObject")
            result = .inCorrect
        }
        
        validationResult = result
        return result
    }
    
    func getValidationError(of validationResult: SttValidationResult) throws -> String {
        
        var result: String!
        
        switch validationResult {
            
        case .ok: result = ""
        case .inCorrect: result = customIncorrectError ?? "\(name) is incorrect."
        case .toShort: result = "\(name) must contain at least \(min) characters long."
        case .toLong: result = "\(name) must contain at most \(max) characters long."
        case .empty: result = "\(name) is required."
        default: throw ValidatorError.unsupportedResultType
            
        }
        
        return result
    }
}
