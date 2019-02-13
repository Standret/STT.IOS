//
//  SttConnectionError.swift
//  OVS
//
//  Created by Peter Standret on 2/1/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

enum SttConnectionError: SttBaseErrorType {
    case timeout
    case noInternetConnection
    case other(String)
    case responseIsNil
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .noInternetConnection:
            result = ("No internet connection", "Check your settings or repeat later")
        case .timeout:
            result = ("Timeout", "Connection timeout")
        case .other(let message):
            result = ("Other", "with message: \(message)")
        case .responseIsNil:
            result = ("Request timeout", "Please try again")
        }
        return result
    }
}
