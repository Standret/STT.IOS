//
//  SttApiError.swift
//  OVS
//
//  Created by Peter Standret on 2/1/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

enum SttApiError: SttBaseErrorType {
    
    case badRequest(ServerError)
    case internalServerError(String)
    case otherApiError(Int)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .badRequest(let error):
            result = ("Bad request", "\(error.description)")
        case .internalServerError(let message):
            result = ("Internal Server Error", message)
        case .otherApiError(let code):
            result = ("Other", "with code: \(code)")
        }
        return result
    }
}
