//
//  SttRouter.swift
//  SttDictionary
//
//  Created by Piter Standret on 12/8/18.
//  Copyright © 2018 Piter Standret. All rights reserved.
//

import Foundation
import LightRoute
import UIKit

extension SttRouterType {
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any? = nil) {
        self.navigateWithSegue(to: T.self, parametr: parametr)
    }
    
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any? = nil,
                                             typeNavigation: TypeNavigation = .push) {
        self.navigateWithId(storyboard: storyboard, to: T.self, parametr: parametr, typeNavigation: typeNavigation)
    }
    
    func close(animate: Bool = true) {
        self.close(animate: animate)
    }
}

class SttRouter {
    
    unowned let transitionHandler: TransitionHandler
    
    required init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any?) {
        let presenterName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let targetname = String(presenterName[..<(presenterName.index(presenterName.endIndex, offsetBy: -9))])
        
        try! transitionHandler
            .forSegue(identifier: targetname, to: SttPresenterType.self)
            .then({ $0.prepare(parametr: parametr) })
    }
    
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation) {
        
        try! transitionHandler
            .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: T.self),
                           to: SttPresenterType.self)
            .to(preferred: getTypeNavigation(type: typeNavigation))
            .perform()
    }
    
    func close(animate: Bool = true) {
        try! transitionHandler
                .closeCurrentModule()
                .transition(animate: animate)
                .perform()
    }
    
    internal func getTypeNavigation(type: TypeNavigation) -> TransitionStyle {
        switch type {
        case .push:
            return .navigation(style: .push)
        case .modality:
            return .modal(style: (transition: UIModalTransitionStyle.flipHorizontal, presentation: UIModalPresentationStyle.popover))
        }
    }
    
    internal func getTarfetStoryboardFactory<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type) -> StoryboardFactory {
        
        let presenterName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let targetname = String(presenterName[..<(presenterName.index(presenterName.endIndex, offsetBy: -9))])
        
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return StoryboardFactory(storyboard: storyboard, restorationId: targetname)
    }
}
