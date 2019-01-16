//
//  SttHeroRouter.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/16/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

extension SttHeroRouterType {
    
    func heroNavigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any? = nil,
                                                 typeNavigation: TypeNavigation = .modality) {
        
        self.heroNavigateWithId(storyboard: storyboard, to: T.self, parametr: parametr, typeNavigation: typeNavigation)
    }
    
}

class SttHeroRouter: SttRouter, SttHeroRouterType {
    
    func heroNavigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation) {
        
        try! transitionHandler
            .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: T.self),
                           to: SttPresenterType.self)
            .apply(to: { $0.hero.isEnabled = true })
            .to(preferred: getTypeNavigation(type: typeNavigation))
            .perform()
    }
}
