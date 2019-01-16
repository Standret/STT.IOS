//
//  SttSearchBarDelegate.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/13/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

enum TypeActionSearchbar {
    case cancelClicked
    case shouldBeginEditing
}

class SttHanlderSearchBar: NSObject, UISearchBarDelegate {
    
    // private property
    private var handlers = [TypeActionSearchbar: [(UISearchBar) -> Void]]()
    private var shouldHandlers = [TypeActionSearchbar: [(UISearchBar) -> Bool]]()

    public var maxCharacter: Int = Int.max
    
    // method for add target
    
    func addTarget<T: SttViewable>(type: TypeActionSearchbar, delegate: T, handler: @escaping (T, UISearchBar) -> Void) {
        
        handlers[type] = handlers[type] ?? [(UISearchBar) -> Void]()
        handlers[type]?.append({ [weak delegate] sb in
            if let _delegate = delegate {
                handler(_delegate, sb)
            }
        })
    }
    
    func addTargetForShould<T: SttViewable>(type: TypeActionSearchbar, delegate: T, handler: @escaping (T, UISearchBar) -> Bool) {
        
        switch type {
        case .shouldBeginEditing:
            shouldHandlers[type] = shouldHandlers[type] ?? [(UISearchBar) -> Bool]()
            shouldHandlers[type]?.append({ [weak delegate] sb in
                
                if let _delegate = delegate {
                    return handler(_delegate, sb)
                }
                
                return true
            })
        default: fatalError("Unsupported type")
        }
    }
    // MARK: implementation of protocol UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        handlers[.cancelClicked]?.forEach({ $0(searchBar) })
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        handlers[.shouldBeginEditing]?.forEach({ $0(searchBar) })
        
        return shouldHandlers[.shouldBeginEditing]?.map({ $0(searchBar) }).last ?? true
    }
}
