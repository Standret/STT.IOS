//
//  SttObjectValidator.swift
//  Miniflix
//
//  Created by Piter Standret on 10/24/18.
//  Copyright © 2018 ved. All rights reserved.
//

import Foundation

/// Use for throw unsupported exception in extensions
enum ValidatorError: Error {
    case unsupportedResultType
}

/// Represent result of validation
enum SttValidationResult {
    case ok, inCorrect, taken
    case toShort, toLong, empty
    case isNotMatch
}

/// Represent base of type for all validator
protocol SttValidatorType {
    
    var name: String { get }
    
    var isRequired: Bool { get }
    var regexPattern: String? { get }
    var min: Int { get }
    var max: Int { get }
    
    func validate(object: String?) -> SttValidationResult
}

extension SttValidatorType {
    
    func getValidationError(of validationResult: SttValidationResult) throws -> String {
        
        var result: String!
        
        switch validationResult {
        
        case .ok: result = ""
        case .inCorrect: result = "\(name) is incorrect."
        case .toShort: result = "\(name) must be not less than \(min) characters long."
        case .toLong: result = "\(name) must be not more than \(max) characters long."
        case .empty: result = "\(name) is required."
        default: throw ValidatorError.unsupportedResultType
            
        }
        
        return result
    }
    
    func validate(object: String?) -> SttValidationResult {
        var result: SttValidationResult!
        do {
            if SttString.isEmpty(string: object) {
                if isRequired {
                    result = .empty
                }
                else {
                    result = .ok
                }
            }
            else if regexPattern != nil {
                
                let nsObject = object! as NSString
                let regex = try NSRegularExpression(pattern: regexPattern!)
                if regex.matches(in: object!, range: NSRange(location: 0, length: nsObject.length)).count != 1 {
//                    if let customError = customIncorrectError {
//                        validationResult = .inCorrect
//                        validationError = customError
//                    }
                    result = .inCorrect
                }
                
            }
            else if (object! as NSString).length < min {
                result = .toShort
            }
            else if (object! as NSString).length > max {
                result = .toLong
            }
            else {
                result = .ok
            }
        }
        catch {
            SttLog.error(message: "error \(error) in validate \(object!)", key: "SttValidationObject")
            
            result = .inCorrect
        }
        
        return result
    }
    
}

class SttValidationObject {
    
    var name: String = "Unkown"
    var isRequired: Bool = false
    var regexPattern: String?
    var min: Int = 0
    var max: Int = Int.max
    var customIncorrectError: String?
    
    var validationResult: SttValidationResult = SttValidationResult.ok
    var validationError: String = ""
    var isError: Bool { return validationResult != .ok }
    
    func validate(object: String?) {
        do {
            if SttString.isEmpty(string: object) {
                if isRequired {
                    validationResult = .empty
                    validationError = "\(name) is required."
                }
                else {
                    validationResult = .ok
                    validationError = ""
                }
                return
            }
            let nsObject = object! as NSString
            if let _pattern = regexPattern {
                let regex = try NSRegularExpression(pattern: _pattern)
                if regex.matches(in: object!, range: NSRange(location: 0, length: nsObject.length)).count != 1 {
                    if let customError = customIncorrectError {
                        validationResult = .inCorrect
                        validationError = customError
                    }
                    validationResult = .inCorrect
                    validationError = "Invalid \(name)"//"\(name) is incorrect."
                    return
                }
            }
            if nsObject.length < min {
                validationResult = .toShort
                validationError = "Too short"//"\(name) must be not less than \(min) characters long."
                return
            }
            if nsObject.length > max {
                validationResult = .toLong
                validationError = "Too long"//"\(name) must be not more than \(max) characters long."
                return
            }
            validationResult = .ok
            validationError = ""
        }
        catch {
            SttLog.error(message: "error \(error) in validate \(object!)", key: "SttValidationObject")
            print ("error \(error) in validate \(object!)")
            
            validationResult = .inCorrect
            validationError = "\(name) is incorrect."
        }
    }
    
}
