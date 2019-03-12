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

/**
 TODO: write close with parametr
 */
extension SttRouterType {
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any? = nil) {
        self.navigateWithSegue(to: T.self, parametr: parametr)
    }
    
    func navigateWithId<T: SttPresenterType>(to _: T.Type, parametr: Any? = nil, typeNavigation: TypeNavigation = .push, animate: Bool = true) {
        self.navigateWithId(to: T.self, parametr: parametr, typeNavigation: typeNavigation, animate: animate)
    }
    
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any? = nil,
                                             typeNavigation: TypeNavigation = .push, animate: Bool = true) {
        self.navigateWithId(storyboard: storyboard, to: T.self, parametr: parametr, typeNavigation: typeNavigation, animate: animate)
    }
    
    func navigateWithId(storyboard: SttStoryboardType, to name: String, parametr: Any? = nil, typeNavigation: TypeNavigation = .push, animate: Bool = true) {
        self.navigateWithId(storyboard: storyboard, to: name, parametr: parametr, typeNavigation: typeNavigation, animate: animate)
    }
    
    func close(animate: Bool = true) {
        self.close(animate: animate)
    }
}

class SttRouter: SttRouterType {
    
    unowned let transitionHandler: TransitionHandler
    
    required init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func loadStoryboard(storyboard: SttStoryboardType) {
        
        let stroyboard = UIStoryboard(name: storyboard.name, bundle: nil)
        let vc = stroyboard.instantiateViewController(withIdentifier: "start")
        
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func navigateWithSegue<T: SttPresenterType>(to _: T.Type, parametr: Any?) {
        let presenterName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let targetname = String(presenterName[..<(presenterName.index(presenterName.endIndex, offsetBy: -9))])
        
        executer {
            try transitionHandler
                .forSegue(identifier: targetname, to: SttPresenterType.self)
                .then({ $0.prepare(parametr: parametr) })
        }
    }
    
    func navigateWithId<T: SttPresenterType>(to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation, animate: Bool) {
        
        executer {
            try transitionHandler
                .forCurrentStoryboard(restorationId: getTargetVCId(to: T.self),
                                      to: SttPresenterType.self)
                .to(preferred: getTypeNavigation(type: typeNavigation))
                .transition(animate: animate)
                .then({ $0.prepare(parametr: parametr) })
        }
    }
    
    func navigateWithId<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type, parametr: Any?, typeNavigation: TypeNavigation, animate: Bool) {
        
        executer {
            try transitionHandler
                .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: T.self),
                               to: SttPresenterType.self)
                .to(preferred: getTypeNavigation(type: typeNavigation))
                .transition(animate: animate)
                .then({ $0.prepare(parametr: parametr) })
        }
    }
    
    func navigateWithId(storyboard: SttStoryboardType, to name: String, parametr: Any? = nil, typeNavigation: TypeNavigation = .push, animate: Bool = true) {
        
        executer {
            try transitionHandler
                .forStoryboard(factory: getTarfetStoryboardFactory(storyboard: storyboard, to: name),
                               to: SttPresenterType.self)
                .to(preferred: getTypeNavigation(type: typeNavigation))
                .transition(animate: animate)
                .then({ $0.prepare(parametr: parametr) })
        }
    }
    
    func close(animate: Bool = true) {
        executer {
            try transitionHandler
                .closeCurrentModule()
                .transition(animate: animate)
                .perform()
        }
    }
    
    func forceClose(animate: Bool = true) {
        executer {
            try transitionHandler
                .closeCurrentModule()
                .transition(animate: animate)
                .perform()
        }
    }
    
    internal func getTypeNavigation(type: TypeNavigation) -> TransitionStyle {
        switch type {
        case .push:
            return .navigation(style: .push)
        case .modality:
            return .modal(style: (transition: UIModalTransitionStyle.coverVertical, presentation: UIModalPresentationStyle.popover))
        }
    }  
    
    internal func getTarfetStoryboardFactory<T: SttPresenterType>(storyboard: SttStoryboardType, to _: T.Type) -> StoryboardFactory {
        
        let presenterName = "\(type(of: T.self))".components(separatedBy: ".").first!
        let targetname = String(presenterName[..<(presenterName.index(presenterName.endIndex, offsetBy: -9))])
        
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return StoryboardFactory(storyboard: storyboard, restorationId: targetname)
    }
    
    internal func getTarfetStoryboardFactory(storyboard: SttStoryboardType, to name: String) -> StoryboardFactory {
        
        let storyboard = UIStoryboard(name: storyboard.name, bundle: Bundle.main)
        return StoryboardFactory(storyboard: storyboard, restorationId: name)
    }
    
    internal func getTargetVCId<T: SttPresenterType>(to _: T.Type) -> String {
        
        let presenterName = "\(type(of: T.self))".components(separatedBy: ".").first!
        return String(presenterName[..<(presenterName.index(presenterName.endIndex, offsetBy: -9))])
    }
    
    internal func executer(action: () throws -> Void) {
        
        do {
            try action()
        }
        catch LightRouteError.viewControllerWasNil(let message) {
            SttLog.warning(message: "error during navigation: \(message)", key: "SttRouter")
        }
        catch {
            SttLog.error(message: "catched unexcpected error during naviation: -- \(error)", key: "SttRouter")
            assertionFailure("catched unexcpected error during naviation: -- \(error)")
        }
    }
}
