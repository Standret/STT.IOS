//
//  ArrayExtensions.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/3/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation

extension Array {
    
    func getElement(indexes: [Int]) -> Array<Element> {
        var arr = [Element]()
        for index in indexes {
            arr.append(self[index])
        }
        return arr
    }
    
    mutating func getAndDelete(index: Int) -> Element {
        let elem = self[index]
        self.remove(at: index)
        return elem
    }
    
    func insertAndReturn(element: Element, at index: Int) -> Array<Element> {
        var newSequence = self
        newSequence.insert(element, at: index)
        return newSequence
    }
}
