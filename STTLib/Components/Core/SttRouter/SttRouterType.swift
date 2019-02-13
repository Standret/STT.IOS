//
//  SttRouterType.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/16/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

protocol SttRouterType {
    
    func loadStoryboard(storyboard: SttStoryboardType)
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any?)
    
    func navigateWithId<T: SttPresenterType>(to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation, animate: Bool)
    
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation, animate: Bool)
    func navigateWithId(storyboard: SttStoryboardType, to name: String, parametr: Any?, typeNavigation: TypeNavigation, animate: Bool)
    
    func close(animate: Bool)
}
