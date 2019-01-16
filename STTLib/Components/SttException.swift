//
//  SttException.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/13/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

func notImplementException(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("NotImlementException")
}
