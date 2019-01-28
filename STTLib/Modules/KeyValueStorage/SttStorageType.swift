//
//  SttStorageType.swift
//  Lemon
//
//  Created by Piter Standret on 1/22/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

enum SttStoringType {
    case security
    case userAccount
}

/*
 TEntity - must be struct or class type (Not simple Int, String)
 */
protocol SttStorageType {
    
    associatedtype TEntity: Codable
    
    func get() -> TEntity
    func put(item: TEntity) -> Bool
    func drop() -> Bool
    func isExists() -> Bool
    
    func onUpdate() -> Observable<TEntity>
}
