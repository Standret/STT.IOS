//
//  SttBaseError.swift
//  OVS
//
//  Created by Peter Standret on 2/1/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

enum SttBaseError: Error, SttBaseErrorType {
    case realmError(SttRealmError)
    case apiError(SttApiError)
    case connectionError(SttConnectionError)
    case jsonConvert(String)
    case unkown(String)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .realmError(let concreate):
            let tempRes = concreate.getMessage()
            result = ("Realm: \(tempRes.0)", tempRes.1)
        case .apiError(let concreate):
            let tempRes = concreate.getMessage()
            result = (tempRes.1, "Api: \(tempRes.0) \(tempRes.1)")
        case .connectionError(let concreate):
            let tempRes = concreate.getMessage()
            result = ("Connection: \(tempRes.0)", tempRes.1)
        case .jsonConvert(let message):
            result = ("Json convert", message)
        case .unkown(let message):
            result = (message, "Description is out")
        }
        
        return result
    }
}
