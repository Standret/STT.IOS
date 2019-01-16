//
//  SttViewable.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

typealias SttViewControlable = SttViewableListener
typealias SttViewControllerInjector = SttViewInjector & SttLifeCycleController & SttPresenterType

protocol SttViewable: AnyObject { }

protocol SttViewableListener: SttViewable {
    func sendMessage(title: String, message: String?)
    func sendError(error: SttBaseErrorType)
    func sendError(title: String, description: String)
}

protocol SttViewInjector {
    func injectView(delegate: SttViewable)
}

protocol SttLifeCycleController {
    
    func viewAppeared()
    func viewAppearing()
    
    func viewDissapeared()
    func viewDissapearing()
}
