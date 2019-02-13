//
//  SttStorage.swift
//  Lemon
//
//  Created by Piter Standret on 1/22/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import KeychainSwift
import RxSwift

class SttStorage<T: Codable>: SttStorageType {
    
    typealias TEntity = T
    
    private let type: SttStoringType
    private let key: String
    
    private var keychain: KeychainSwift! = nil
    private var userDefault: UserDefaults! = nil
    
    init (type: SttStoringType, key: String) {
        self.type = type
        self.key = key
        
        switch type {
        case .security:
            self.keychain = KeychainSwift()
        case .userAccount:
            self.userDefault = UserDefaults.standard
        }
    }
    
    func get() -> T {
        switch type {
        case .security:
            return keychain.getData(key)!.getObject(of: TEntity.self)!
        case .userAccount:
            return userDefault.data(forKey: key)!.getObject(of: TEntity.self)!
        }
    }
    
    @discardableResult
    func put(item: T) -> Bool {
        switch type {
        case .security:
            return keychain.set(item.getData()!, forKey: key)
        case .userAccount:
            userDefault.set(item.getData()!, forKey: key)
            return true
        }
    }
    
    @discardableResult
    func drop() -> Bool {
        switch type {
        case .security:
            return keychain.delete(key)
        case .userAccount:
            userDefault.removeObject(forKey: key)
            return true
        }
    }
    
    func isExists() -> Bool {
        switch type {
        case .security:
            return keychain.getData(key) != nil
        case .userAccount:
            return userDefault.data(forKey: key) != nil
        }
    }
    
    func onUpdate() -> Observable<T> {
        notImplementException()
    }
}
