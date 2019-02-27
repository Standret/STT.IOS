//
//  Log.swift
//  SttDictionary
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

class DateConverter: SttConverter<Date, String> {
    
    override func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.string(from: value)
    }
}

class SttLog {
    
    static var logInSystem = true
    
    class func trace(message: String, key: String) {
        log(type: "trace", message: message, key: key)
    }
    class func warning(message: String, key: String) {
        log(type: "warning", message: message, key: key)
    }
    class func error(message: String, key: String) {
        log(type: "error", message: message, key: key)
    }
    
    fileprivate class func log(type: String, message: String, key: String) {
        
        if logInSystem {
            NSLog("<\(key)> \(message)")
        }
        else {
            print("[\(type)][\(SttLogDateConverter().convert(value: Date()))] <\(key)> \(message)")
        }
    }
}


class SttRequestLog {
    class func log(url: String, body: String) {
        print("\n-------------------------------------")
        print("--> \(url)")
        print("BODY:\n\(body)")
        print("\n-------------------------------------\n")
    }
}
