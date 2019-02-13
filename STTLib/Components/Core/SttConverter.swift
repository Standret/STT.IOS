//
//  BaseConverter.swift
//  SttDictionary
//
//  Created by Standret on 21.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

protocol SttConverterType: AnyObject {

    init()
    
    func convert(value: Any?, parametr: Any?) -> Any
    func convertBack(value: Any?, parametr: Any?) -> Any
}

class SttConverter<TIn, TOut>: SttConverterType {
    
    required init() { }
    
    func convert(value: Any?, parametr: Any?) -> Any {
        return self.convert(value: value as! TIn, parametr: parametr)
    }
    
    func convertBack(value: Any?, parametr: Any?) -> Any {
        return self.convertBack(value: value as! TOut, parametr: parametr)
    }
    
    func convert(value: TIn, parametr: Any?) -> TOut {
        notImplementException()
    }
    
    func convertBack(value: TOut, parametr: Any?) -> TIn {
        notImplementException()
    }
}

extension SttConverter {
    func convert(value: TIn) -> TOut {
        return self.convert(value: value, parametr: nil)
    }
}

class SttLogDateConverter: SttConverter<Date, String> {

    override func convert(value: Date, parametr: Any?) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss:SSSS"
        
        return formatter.string(from: value)
    }
}
