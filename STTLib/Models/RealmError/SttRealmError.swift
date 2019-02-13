//
//  SttRealmError.swift
//  OVS
//
//  Created by Peter Standret on 2/1/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

enum SttRealmError: SttBaseErrorType {
    
    case notFoundObjects(String)
    case queryIsNull(String)
    case doesNotExactlyQuery(String)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .notFoundObjects(let message):
            result = ("not found", message)
        case .queryIsNull(let message):
            result = ("query could not been nil", message)
        case .doesNotExactlyQuery(let message):
            result = ("query doesn not exactly", "found more one object or didn't find anything: \(message)")
        }
        return result
    }
}
