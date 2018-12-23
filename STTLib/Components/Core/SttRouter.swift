//
//  SttRouter.swift
//  SttDictionary
//
//  Created by Piter Standret on 12/8/18.
//  Copyright © 2018 Piter Standret. All rights reserved.
//

import Foundation
import LightRoute

class SttRouter {
    
    unowned var transitionHandler: TransitionHandler
    
    required init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func defaultPush(segue: String, parametr: Any? = nil) {
        try! transitionHandler
            .forSegue(identifier: segue, to: SttPresenterType.self)
            .then({ $0.prepare(parametr: parametr) })
    }
}
