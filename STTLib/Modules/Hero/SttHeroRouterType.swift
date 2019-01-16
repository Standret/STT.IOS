//
//  SyyHeroRouterType.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/16/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation

protocol SttHeroRouterType: SttRouterType {
    
    func heroNavigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation)
}
