//
//  SttRouterType.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/16/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

protocol SttRouterType {
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any?)
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation)
    
    func close(animate: Bool)
}
