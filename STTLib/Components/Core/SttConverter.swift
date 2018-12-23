//
//  BaseConverter.swift
//  SttDictionary
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol SttConverterType {
    associatedtype TIn
    associatedtype TOut
    
    func convert(value: TIn, parametr: Any?) -> TOut
}

extension SttConverterType {
    func convert(value: TIn) -> TOut {
        return self.convert(value: value, parametr: nil)
    }
}

class SttLogDateConverter: SttConverterType {
    
    typealias TIn = Date
    typealias TOut = String
    
    func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss:SSSS"
        
        return formatter.string(from: value)
    }
}
